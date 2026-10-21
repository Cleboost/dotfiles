-- BeamNG.drive\lua\ge\extensions\cheatMenuu.lu (GUI MENU)
local M = {}
local im = ui_imgui
local ffi = require("ffi")
local open = im.BoolPtr(true)
local shouldCollapse = true -- Новый флаг, который сработает один раз при старте


-- АВТОМАТИЧЕСКИЙ ФИКС ВЫЛЕТОВ РАДИАЛЬНОГО МЕНЮ И КАРЬЕРЫ (recoveryPrompt)

local function applyCareerCrashFix()
    if not core_quickAccess then return end

    -- Находим приватную таблицу menuTree в модуле quickAccess через upvalues
    local menuTree = nil
    local targetFunc = core_quickAccess.addEntry or core_quickAccess.show
    if targetFunc then
        local i = 1
        while true do
            local name, val = debug.getupvalue(targetFunc, i)
            if not name then break end
            if name == "menuTree" or name == "entries" then
                menuTree = val
                break
            end
            i = i + 1
        end
    end

    -- Если таблица меню найдена, оборачиваем генераторы эвакуации в безопасный pcall
    if menuTree then
        for path, levelData in pairs(menuTree) do
            if string.find(path, "towing") or string.find(path, "career") or string.find(path, "recovery") then
                for _, item in ipairs(levelData) do
                    if item and type(item.generator) == "function" and not item._patchedByCheatMenu then
                        local originalGenerator = item.generator
                        item.generator = function(entries, ...)
                            -- pcall предотвратит краш игры, если оригинальный скрипт вернет ошибку
                            local status, err = pcall(originalGenerator, entries, ...)
                            if not status then
                                if log then
                                    log('W', 'CheatMenu_Fix', 'Bypassed crash in game recovery prompt: ' .. tostring(err))
                                end
                            end
                        end
                        item._patchedByCheatMenu = true
                    end
                end
            end
        end
    end
end





-- Галочки управления защитой от нестабильности
if _G.CheatMenu_EnableInstabilityProtection == nil then
    _G.CheatMenu_EnableInstabilityProtection = im.BoolPtr(true) -- Защита включена по умолчанию (ВКЛ)
end
if _G.CheatMenu_InstabilityAutoRepair == nil then
    _G.CheatMenu_InstabilityAutoRepair = im.BoolPtr(true) -- Авто-ремонт R и возврат камеры (по умолчанию ВКЛ)
end


if _G.CheatMenu_InstabilityAlertTimer == nil then _G.CheatMenu_InstabilityAlertTimer = 0.0 end
if _G.CheatMenu_InstabilityHomeDelay == nil then _G.CheatMenu_InstabilityHomeDelay = 0 end
if _G.CheatMenu_InstabilityTargetVid == nil then _G.CheatMenu_InstabilityTargetVid = 0 end
if _G.CheatMenu_TargetRespawnPos == nil then _G.CheatMenu_TargetRespawnPos = false end


-- Инициализируем общую структуру обмена данными
if not _G.CheatMenuWindow_Data then
    _G.CheatMenuWindow_Data = { vehicleStates = {}, parts = {} }
end
if not _G.CheatMenu_VehTelemetry then
    _G.CheatMenu_VehTelemetry = {}
end
if _G.CheatMenu_DisableCollapse == nil then
    _G.CheatMenu_DisableCollapse = im.BoolPtr(false) -- Галочка для интерфейса
end

if _G.CheatMenu_TimeOfDay == nil then 
    _G.CheatMenu_TimeOfDay = im.FloatPtr(0.5) 
end



-- Инициализация переменных для управления светофорами города
if _G.CheatMenu_Signals_DebugLevel == nil then _G.CheatMenu_Signals_DebugLevel = im.IntPtr(0) end
if _G.CheatMenu_Signals_OverrideState == nil then _G.CheatMenu_Signals_OverrideState = "auto" end



-- Переменные климата и окружения
if _G.CheatMenu_DayNightSpeed == nil then _G.CheatMenu_DayNightSpeed = im.FloatPtr(1.0) end
if _G.CheatMenu_WindSpeed == nil then _G.CheatMenu_WindSpeed = im.FloatPtr(0.0) end
if _G.CheatMenu_AmbientTemp == nil then _G.CheatMenu_AmbientTemp = im.FloatPtr(20.0) end



-- Переменные управления ветром (Скорость и Направление)
if _G.CheatMenu_WindSpeed == nil then _G.CheatMenu_WindSpeed = im.FloatPtr(0.0) end
if _G.CheatMenu_WindDir == nil then _G.CheatMenu_WindDir = im.FloatPtr(0.0) end
if _G.CheatMenu_WindVert == nil then _G.CheatMenu_WindVert = im.FloatPtr(0.0) end -- Вертикальный ветер


-- Инициализация переменных для облачности и перистых облаков
if _G.CheatMenu_CloudCover == nil then _G.CheatMenu_CloudCover = im.FloatPtr(0.2) end
if _G.CheatMenu_CloudAlt == nil then _G.CheatMenu_CloudAlt = im.FloatPtr(2.5) end
if _G.CheatMenu_CirrusCover == nil then _G.CheatMenu_CirrusCover = im.FloatPtr(0.2) end
if _G.CheatMenu_CirrusDensity == nil then _G.CheatMenu_CirrusDensity = im.FloatPtr(0.5) end
if _G.CheatMenu_CirrusAlt == nil then _G.CheatMenu_CirrusAlt = im.FloatPtr(8.0) end




-- ВИРТУАЛЬНЫЙ ФИЗИЧЕСКИЙ МУСОР (КУБЫ, СФЕРЫ, ПАЛОЧКИ С ТОЧНОЙ КОЛЛИЗИЕЙ)

if _G.CheatMenu_VirtSand_Enabled == nil then _G.CheatMenu_VirtSand_Enabled = im.BoolPtr(false) end
if _G.CheatMenu_VirtSand_Count == nil then _G.CheatMenu_VirtSand_Count = im.IntPtr(150) end
if _G.CheatMenu_VirtSand_Radius == nil then _G.CheatMenu_VirtSand_Radius = im.FloatPtr(2.0) end
if _G.CheatMenu_VirtSand_Height == nil then _G.CheatMenu_VirtSand_Height = im.FloatPtr(2.5) end
if _G.CheatMenu_VirtSand_CubeSize == nil then _G.CheatMenu_VirtSand_CubeSize = im.FloatPtr(0.12) end
if _G.CheatMenu_VirtSand_StickLength == nil then _G.CheatMenu_VirtSand_StickLength = im.FloatPtr(0.60) end
if _G.CheatMenu_VirtSand_ShapeIdx == nil then _G.CheatMenu_VirtSand_ShapeIdx = 0 end -- 0: Куб, 1: Сфера, 2: Палочка
if _G.CheatMenu_VirtSand_List == nil then _G.CheatMenu_VirtSand_List = {} end

local function generateVirtualPhysicalSand()
    local playerVeh = be:getPlayerVehicle(0)
    if not playerVeh then return end
    
    local pPos = playerVeh:getPosition()
    -- Спавним предметы ровно над крышей машины (на высоте 2.5 метра)
    local center = pPos + vec3(0, 0, 2.5)
    
    local count = _G.CheatMenu_VirtSand_Count[0]
    local radius = _G.CheatMenu_VirtSand_Radius[0]
    local height = _G.CheatMenu_VirtSand_Height[0]
    local baseSize = _G.CheatMenu_VirtSand_CubeSize[0]
    local stickLen = _G.CheatMenu_VirtSand_StickLength[0]
    local shapeType = _G.CheatMenu_VirtSand_ShapeIdx
    
    local vLuaBricks = {}

    for i = 1, count do
        local angle = math.random() * math.pi * 2
        local r = math.sqrt(math.random()) * radius
        local zOffset = math.random() * height
        
        local x = center.x + r * math.cos(angle)
        local y = center.y + r * math.sin(angle)
        local z = center.z + zOffset
        local sz = baseSize * (0.8 + math.random() * 0.4)

        local dir = vec3((math.random()-0.5)*2, (math.random()-0.5)*2, (math.random()-0.5)*0.5):normalized()

        table.insert(vLuaBricks, { 
            x = x, y = y, z = z, 
            velX = (math.random()-0.5)*0.2, 
            velY = (math.random()-0.5)*0.2, 
            velZ = -1.5,
            sz = sz, 
            len = stickLen, 
            shape = shapeType,
            dirX = dir.x, dirY = dir.y, dirZ = dir.z 
        })
    end
    
    _G.CheatMenu_VirtSand_Enabled[0] = true

    -- Отправляем список частиц прямо в физическое ядро автомобиля
    local jsonData = jsonEncode(vLuaBricks)
    playerVeh:queueLuaCommand(string.format("if CheatMenuM and CheatMenuM.spawnParticles then CheatMenuM.spawnParticles([===[%s]===]) end", jsonData))
end

-- Точный просчет физики падения на кузов авто через Raycast
local function updateVirtualSandPhysics(dt)
    if not _G.CheatMenu_VirtSand_Enabled[0] or not _G.CheatMenu_VirtSand_List then return end
    
    local playerVeh = be:getPlayerVehicle(0)
    local vehPos = playerVeh and playerVeh:getPosition()
    local vehVel = playerVeh and playerVeh:getVelocity() or vec3(0,0,0)
    
    local items = _G.CheatMenu_VirtSand_List
    local subDt = math.min(dt, 0.033)
    
    for i = 1, #items do
        local c = items[i]
        
        -- 1. Гравитация
        c.vel.z = c.vel.z - 9.81 * subDt
        c.vel = c.vel * (1.0 - 0.2 * subDt) -- Сопротивление воздуха
        
        local moveVec = c.vel * subDt
        local moveDist = moveVec:length()
        
        if moveDist > 0.0001 then
            local moveDir = moveVec / moveDist
            local radius = c.size * 0.5
            if c.shape == 2 then radius = math.max(c.size * 0.3, c.length * 0.2) end
            
            local rayStart = c.pos
            local rayEnd = c.pos + moveVec + moveDir * radius
            
            -- 2. ЛАЗЕРНАЯ ТРАССИРОВКА: Ищет полигоны кузова авто и земли
            local rayRes = Engine.castRay(rayStart, rayEnd, true, true)
            
            if rayRes and rayRes.pt and rayRes.norm then
                local hitPt = vec3(rayRes.pt)
                local hitNorm = vec3(rayRes.norm):normalized()
                
                -- Корректируем позицию: сажаем объект прямо НА поверхность капота/крыши
                c.pos = hitPt + hitNorm * radius
                
                -- Вычисляем отскок и гашение энергии о металл кузова
                local vDotN = c.vel:dot(hitNorm)
                if vDotN < 0 then
                    -- Гасим вертикальную скорость (чтобы предмет не подпрыгивал до небес)
                    c.vel = c.vel - hitNorm * (vDotN * 1.3)
                    
                    -- Трение скольжения по крыше/капоту
                    c.vel.x = c.vel.x * 0.82
                    c.vel.y = c.vel.y * 0.82
                end
                
                -- Если машина едет, передаем кинетическую энергию крыши объекту
                if vehPos and (c.pos - vehPos):length() < 3.5 then
                    c.vel.x = c.vel.x + vehVel.x * 0.4 * subDt
                    c.vel.y = c.vel.y + vehVel.y * 0.4 * subDt
                    c.vel.z = c.vel.z + vehVel.z * 0.4 * subDt
                end
            else
                -- Если преград нет — свободно перемещаем
                c.pos = c.pos + moveVec
            end
        end
        
        -- 3. Резервная коллизия с землей (Terrain)
        local groundZ = -100
        if core_terrain and core_terrain.getTerrainHeight then
            groundZ = core_terrain.getTerrainHeight(c.pos) or -100
        end
        
        local minZ = groundZ + c.size * 0.5
        if c.pos.z < minZ then
            c.pos.z = minZ
            if c.vel.z < 0 then c.vel.z = -c.vel.z * 0.15 end
            c.vel.x = c.vel.x * 0.7
            c.vel.y = c.vel.y * 0.7
        end
    end
end





-- Инициализируем указатели и переменные для новых разработческих функций
if _G.CheatMenu_CameraFovVal == nil then 
    _G.CheatMenu_CameraFovVal = im.FloatPtr(65.0) 
end
if _G.CheatMenu_MaterialDebug == nil then 
    _G.CheatMenu_MaterialDebug = im.BoolPtr(false) 
end
if _G.CheatMenu_PhysicsSpeedFactor == nil then 
    _G.CheatMenu_PhysicsSpeedFactor = im.FloatPtr(1.0) 
end

-- Дополнительные переменные для управления электрикой и деформацией кузова
if _G.CheatMenu_LastHornState == nil then _G.CheatMenu_LastHornState = false end
if _G.CheatMenu_LastFlashState == nil then _G.CheatMenu_LastFlashState = false end
if _G.CheatMenu_AddDamageAmount == nil then _G.CheatMenu_AddDamageAmount = im.IntPtr(500) end

-- Хранилище для данных отслеживания повреждений
if not _G.CheatMenuWindow_Data.damageTrackerData then
    _G.CheatMenuWindow_Data.damageTrackerData = { overrev = 0, overtorque = 0, oilHot = 0 }
end

-- Глобальное хранилище для универсального редактора профилей карьеры
if not _G.CheatMenu_ProfileEditor then
    _G.CheatMenu_ProfileEditor = {
        files = {},
        selectedIdx = -1,
        data = nil,
        path = ""
    }
end

local function scanProfiles()
    _G.CheatMenu_ProfileEditor.files = FS:findFiles("settings/cloud/saves/", "playerAttributes.json", -1, true, false) or {}
    _G.CheatMenu_ProfileEditor.selectedIdx = -1
    _G.CheatMenu_ProfileEditor.data = nil
    _G.CheatMenu_ProfileEditor.path = ""
end

-- Добавляем скрытый триггер для отслеживания респавна
if _G.CheatMenu_NeedsCollapseTrigger == nil then
    _G.CheatMenu_NeedsCollapseTrigger = true
end



if _G.CheatMenu_InfiniteDebris == nil then _G.CheatMenu_InfiniteDebris = im.BoolPtr(false) end

-- Функция управления временем жизни осколков и лимитами движка
local function applyInfiniteDebrisSettings(enabled)
    local particleClasses = {"ParticleData"}
    for _, className in ipairs(particleClasses) do
        local names = scenetree.findClassObjects(className)
        if names then
            for i = 1, #names do
                local obj = scenetree.findObject(names[i])
                if obj then
                    if enabled then
                        -- Устанавливаем время жизни частиц в 24 часа (осколки лежат на земле)
                        obj:setField("lifetimeMS", 0, "86400000")
                    else
                        -- Возвращаем стандартные 3 секунды
                        obj:setField("lifetimeMS", 0, "3000")
                    end
                    obj:postApply()
                end
            end
        end
    end

    -- Увеличиваем буфер памяти под осколки и следы на карте
    if enabled then
        setConsoleVariable("$pref::TS::maxDecalCount", "100000")
    else
        setConsoleVariable("$pref::TS::maxDecalCount", "4000")
    end
end


-- Инициализация переменных для реального звездного неба и астрономии
if _G.CheatMenu_Celest_Enabled == nil then _G.CheatMenu_Celest_Enabled = im.BoolPtr(true) end
if _G.CheatMenu_Celest_Lat == nil then _G.CheatMenu_Celest_Lat = im.FloatPtr(47.0) end
if _G.CheatMenu_Celest_Lon == nil then _G.CheatMenu_Celest_Lon = im.FloatPtr(8.0) end
if _G.CheatMenu_Celest_Year == nil then _G.CheatMenu_Celest_Year = im.IntPtr(2026) end
if _G.CheatMenu_Celest_Month == nil then _G.CheatMenu_Celest_Month = im.IntPtr(6) end
if _G.CheatMenu_Celest_Day == nil then _G.CheatMenu_Celest_Day = im.IntPtr(20) end
if _G.CheatMenu_Celest_MoonScale == nil then _G.CheatMenu_Celest_MoonScale = im.FloatPtr(0.05) end
if _G.CheatMenu_Celest_NorthOffset == nil then _G.CheatMenu_Celest_NorthOffset = im.FloatPtr(0.0) end
if _G.CheatMenu_Celest_MeteorRate == nil then _G.CheatMenu_Celest_MeteorRate = im.FloatPtr(30.0) end
if _G.CheatMenu_Celest_Hover == nil then _G.CheatMenu_Celest_Hover = im.BoolPtr(false) end


if _G.CheatMenu_GlobalStrengthMult == nil then _G.CheatMenu_GlobalStrengthMult = im.FloatPtr(1.0) end
if _G.CheatMenu_PartStrengthFilter == nil then _G.CheatMenu_PartStrengthFilter = im.ArrayChar(64) end
if not _G.CheatMenu_PartStrengthValues then _G.CheatMenu_PartStrengthValues = {} end

if _G.CheatMenu_Freeze_globalStrengthMult == nil then
    _G.CheatMenu_Freeze_globalStrengthMult = im.BoolPtr(false)
end







-- ПОЛНАЯ ТАБЛИЦА ВСЕХ ПРЕСЕТОВ И КЛЮЧЕЙ ГРАФИКИ (100% Все 31+ параметров)

local gfxPresets = {
  Lowest = {
    GraphicMeshQuality = "Lowest", GraphicTerrainQuality = "Lowest", GraphicTextureQuality = "Lowest",
    GraphicLightingQuality = "Lowest", GraphicShadowsQuality = "Lowest", lastSplitCastersEnabled = false,
    vehicleShadowEnabled = false, GraphicMaxDecalCount = 2000, GraphicGrassDensity = 0,
    GraphicAnisotropic = 0, GraphicAntialias = 0, GraphicAntialiasType = "fxaa",
    GraphicDynReflectionEnabled = false, GraphicDynReflectionFacesPerupdate = 1, GraphicDynReflectionDetail = 0,
    GraphicDynReflectionDistance = 10, GraphicDynReflectionTexsize = 0, GraphicDynMirrorsEnabled = false,
    GraphicDynMirrorsDetail = 0, GraphicDynMirrorsDistance = 10, GraphicDynMirrorsTexsize = 0,
    GraphicCloudsQuality = "Disabled", GraphicClusteredQuality = "Lowest", PostFXSSAOGeneralEnabled = false,
    PostFXSSAOGeneralQuality = "Normal", PostFXScreenSpaceShadowsEnabled = false, PostFXDOFGeneralEnabled = false,
    PostFXMotionBlurEnabled = false, SkipGenerateLicencePlate = true
  },
  Low = {
    GraphicMeshQuality = "Low", GraphicTerrainQuality = "Low", GraphicTextureQuality = "Low",
    GraphicLightingQuality = "Low", GraphicShadowsQuality = "Low", lastSplitCastersEnabled = false,
    vehicleShadowEnabled = false, GraphicMaxDecalCount = 3000, GraphicGrassDensity = 0.25,
    GraphicAnisotropic = 2, GraphicAntialias = 4, GraphicAntialiasType = "fxaa",
    GraphicDynReflectionEnabled = false, GraphicDynReflectionFacesPerupdate = 1, GraphicDynReflectionDetail = 0,
    GraphicDynReflectionDistance = 50, GraphicDynReflectionTexsize = 0, GraphicDynMirrorsEnabled = false,
    GraphicDynMirrorsDetail = 0, GraphicDynMirrorsDistance = 50, GraphicDynMirrorsTexsize = 0,
    GraphicCloudsQuality = "Low", GraphicClusteredQuality = "Low", PostFXSSAOGeneralEnabled = false,
    PostFXSSAOGeneralQuality = "Normal", PostFXScreenSpaceShadowsEnabled = false, PostFXDOFGeneralEnabled = false,
    PostFXMotionBlurEnabled = false, SkipGenerateLicencePlate = true
  },
  Normal = {
    GraphicMeshQuality = "Normal", GraphicTerrainQuality = "Normal", GraphicTextureQuality = "Normal",
    GraphicLightingQuality = "High", GraphicShadowsQuality = "Normal", lastSplitCastersEnabled = false,
    vehicleShadowEnabled = false, GraphicMaxDecalCount = 4000, GraphicGrassDensity = 0.5,
    GraphicAnisotropic = 4, GraphicAntialias = 4, GraphicAntialiasType = "fxaa",
    GraphicDynReflectionEnabled = false, GraphicDynReflectionFacesPerupdate = 1, GraphicDynReflectionDetail = 0.5,
    GraphicDynReflectionDistance = 200, GraphicDynReflectionTexsize = 1, GraphicDynMirrorsEnabled = true,
    GraphicDynMirrorsDetail = 0.75, GraphicDynMirrorsDistance = 200, GraphicDynMirrorsTexsize = 1,
    GraphicCloudsQuality = "Normal", GraphicClusteredQuality = "Normal", PostFXSSAOGeneralEnabled = true,
    PostFXSSAOGeneralQuality = "Normal", PostFXScreenSpaceShadowsEnabled = true, PostFXDOFGeneralEnabled = true,
    PostFXMotionBlurEnabled = true, SkipGenerateLicencePlate = false
  },
  High = {
    GraphicMeshQuality = "High", GraphicTerrainQuality = "High", GraphicTextureQuality = "Normal",
    GraphicLightingQuality = "High", GraphicShadowsQuality = "High", lastSplitCastersEnabled = false,
    vehicleShadowEnabled = false, GraphicMaxDecalCount = 6000, GraphicGrassDensity = 0.75,
    GraphicAnisotropic = 8, GraphicAntialias = 4, GraphicAntialiasType = "smaa",
    GraphicDynReflectionEnabled = true, GraphicDynReflectionFacesPerupdate = 1, GraphicDynReflectionDetail = 0.75,
    GraphicDynReflectionDistance = 200, GraphicDynReflectionTexsize = 1, GraphicDynMirrorsEnabled = true,
    GraphicDynMirrorsDetail = 0.75, GraphicDynMirrorsDistance = 200, GraphicDynMirrorsTexsize = 1,
    GraphicCloudsQuality = "High", GraphicClusteredQuality = "High", PostFXSSAOGeneralEnabled = true,
    PostFXSSAOGeneralQuality = "Normal", PostFXScreenSpaceShadowsEnabled = true, PostFXDOFGeneralEnabled = true,
    PostFXMotionBlurEnabled = true, SkipGenerateLicencePlate = false
  },
  Ultra = {
    GraphicMeshQuality = "Ultra", GraphicTerrainQuality = "High", GraphicTextureQuality = "Normal",
    GraphicLightingQuality = "Ultra", GraphicShadowsQuality = "High", lastSplitCastersEnabled = false,
    vehicleShadowEnabled = false, GraphicMaxDecalCount = 8000, GraphicGrassDensity = 1.0,
    GraphicAnisotropic = 16, GraphicAntialias = 4, GraphicAntialiasType = "smaa",
    GraphicDynReflectionEnabled = true, GraphicDynReflectionFacesPerupdate = 2, GraphicDynReflectionDetail = 0.75,
    GraphicDynReflectionDistance = 300, GraphicDynReflectionTexsize = 2, GraphicDynMirrorsEnabled = true,
    GraphicDynMirrorsDetail = 0.75, GraphicDynMirrorsDistance = 300, GraphicDynMirrorsTexsize = 2,
    GraphicCloudsQuality = "High", GraphicClusteredQuality = "Ultra", PostFXSSAOGeneralEnabled = true,
    PostFXSSAOGeneralQuality = "Normal", PostFXScreenSpaceShadowsEnabled = true, PostFXDOFGeneralEnabled = true,
    PostFXMotionBlurEnabled = true, SkipGenerateLicencePlate = false
  },
  SteamDeck = {
    GraphicMeshQuality = "Normal", GraphicTerrainQuality = "Low", GraphicTextureQuality = "Low",
    GraphicLightingQuality = "High", GraphicShadowsQuality = "Low", lastSplitCastersEnabled = false,
    vehicleShadowEnabled = false, GraphicMaxDecalCount = 4000, GraphicGrassDensity = 0.5,
    GraphicAnisotropic = 4, GraphicAntialias = 4, GraphicAntialiasType = "fxaa",
    GraphicDynReflectionEnabled = false, GraphicDynReflectionFacesPerupdate = 1, GraphicDynReflectionDetail = 0.5,
    GraphicDynReflectionDistance = 200, GraphicDynReflectionTexsize = 1, GraphicDynMirrorsEnabled = false,
    GraphicDynMirrorsDetail = 0.75, GraphicDynMirrorsDistance = 200, GraphicDynMirrorsTexsize = 1,
    GraphicCloudsQuality = "Low", GraphicClusteredQuality = "Low", PostFXSSAOGeneralEnabled = true,
    PostFXSSAOGeneralQuality = "Normal", PostFXScreenSpaceShadowsEnabled = true, PostFXDOFGeneralEnabled = true,
    PostFXMotionBlurEnabled = true, SkipGenerateLicencePlate = false
  }
}

-- Универсальная функция записи значения в систему настроек BeamNG
local function applyGraphicSetting(key, val)
    local opts = core_settings_graphic and core_settings_graphic.getOptions()
    if opts and opts[key] and type(opts[key].set) == "function" then
        opts[key].set(val)
    elseif settings and settings.setValue then
        settings.setValue(key, val)
    end
end

-- Универсальная функция чтения любого значения
local function getGraphicVal(key, defaultVal)
    local opts = core_settings_graphic and core_settings_graphic.getOptions()
    if opts and opts[key] and type(opts[key].get) == "function" then
        return opts[key].get()
    elseif settings and settings.getValue then
        local v = settings.getValue(key)
        if v ~= nil then return v end
    end
    return defaultVal
end

-- Функция применения пресета целиком
local function applyGraphicPreset(presetName)
    local preset = gfxPresets[presetName]
    if not preset then return end

    for k, v in pairs(preset) do
        applyGraphicSetting(k, v)
    end

    if core_settings_graphic and core_settings_graphic.applyGraphicsState then
        core_settings_graphic.applyGraphicsState()
    end
end



-- Инициализация генератора виртуальной кучи песка (из мелких 3D квадратов)
if _G.CheatMenu_Sand_Enabled == nil then _G.CheatMenu_Sand_Enabled = im.BoolPtr(false) end
if _G.CheatMenu_Sand_Count == nil then _G.CheatMenu_Sand_Count = im.IntPtr(400) end
if _G.CheatMenu_Sand_Radius == nil then _G.CheatMenu_Sand_Radius = im.FloatPtr(3.0) end
if _G.CheatMenu_Sand_Height == nil then _G.CheatMenu_Sand_Height = im.FloatPtr(1.2) end
if _G.CheatMenu_Sand_CubeSize == nil then _G.CheatMenu_Sand_CubeSize = im.FloatPtr(0.08) end
if _G.CheatMenu_Sand_Cubes == nil then _G.CheatMenu_Sand_Cubes = {} end
if _G.CheatMenu_Sand_Color == nil then
    _G.CheatMenu_Sand_Color = im.ArrayFloat(3)
    _G.CheatMenu_Sand_Color[0], _G.CheatMenu_Sand_Color[1], _G.CheatMenu_Sand_Color[2] = 0.9, 0.75, 0.3 -- Песочно-золотой цвет
end

-- Вспомогательная функция формирования холма/кучи из мелких кубиков
local function generateSandPile()
    local playerVeh = be:getPlayerVehicle(0)
    if not playerVeh then return end
    
    local pos = playerVeh:getPosition()
    local fwd = playerVeh:getDirectionVector():normalized()
    local center = pos + fwd * 4.0 -- Генерируем в 4 метрах перед машиной
    
    local count = _G.CheatMenu_Sand_Count[0]
    local radius = _G.CheatMenu_Sand_Radius[0]
    local height = _G.CheatMenu_Sand_Height[0]
    local baseSize = _G.CheatMenu_Sand_CubeSize[0]
    
    _G.CheatMenu_Sand_Cubes = {}
    for i = 1, count do
        -- Случайный угол и радиус в форме конуса/холмика (парабола)
        local angle = math.random() * math.pi * 2
        local r = math.sqrt(math.random()) * radius
        local moundZ = height * (1.0 - (r / radius)^2)
        local zOffset = math.random() * math.max(0.02, moundZ)
        
        local x = center.x + r * math.cos(angle)
        local y = center.y + r * math.sin(angle)
        local z = center.z + zOffset
        
        local sz = baseSize * (0.7 + math.random() * 0.6)
        
        table.insert(_G.CheatMenu_Sand_Cubes, {
            minPt = vec3(x - sz, y - sz, z - sz),
            maxPt = vec3(x + sz, y + sz, z + sz)
        })
    end
    _G.CheatMenu_Sand_Enabled[0] = true
end



-- Инициализация расширенных параметров ИИ Автопилота
if _G.CheatMenu_Ai_ModeIdx == nil then _G.CheatMenu_Ai_ModeIdx = 0 end
if _G.CheatMenu_Ai_TargetVehId == nil then _G.CheatMenu_Ai_TargetVehId = im.IntPtr(0) end
if _G.CheatMenu_Ai_SpeedLimit == nil then _G.CheatMenu_Ai_SpeedLimit = im.FloatPtr(60.0) end
if _G.CheatMenu_Ai_SpeedModeIdx == nil then _G.CheatMenu_Ai_SpeedModeIdx = 0 end -- 0: legal, 1: limit, 2: off
if _G.CheatMenu_Ai_InLane == nil then _G.CheatMenu_Ai_InLane = im.BoolPtr(true) end
if _G.CheatMenu_Ai_AvoidCars == nil then _G.CheatMenu_Ai_AvoidCars = im.BoolPtr(true) end
if _G.CheatMenu_Ai_Aggression == nil then _G.CheatMenu_Ai_Aggression = im.FloatPtr(0.35) end
if _G.CheatMenu_Ai_CustomCmd == nil then 
    _G.CheatMenu_Ai_CustomCmd = im.ArrayChar(256) 
    ffi.copy(_G.CheatMenu_Ai_CustomCmd, "if ai then ai.setMode('manual') ai.setTarget('wpTargetName') end") 
end



-- Инициализация параметров изменения размера и рельефа карты
if _G.CheatMenu_MapScaleX == nil then _G.CheatMenu_MapScaleX = im.FloatPtr(1.0) end
if _G.CheatMenu_MapScaleY == nil then _G.CheatMenu_MapScaleY = im.FloatPtr(1.0) end
if _G.CheatMenu_MapScaleZ == nil then _G.CheatMenu_MapScaleZ = im.FloatPtr(1.0) end
if _G.CheatMenu_MapScaleUniform == nil then _G.CheatMenu_MapScaleUniform = im.FloatPtr(1.0) end



-- Инициализация параметров полноценного Полета (Fly Mode)
if _G.CheatMenu_FlyMode == nil then _G.CheatMenu_FlyMode = im.BoolPtr(false) end
if _G.CheatMenu_FlyHover == nil then _G.CheatMenu_FlyHover = im.BoolPtr(true) end
if _G.CheatMenu_FlySpeed == nil then _G.CheatMenu_FlySpeed = im.FloatPtr(15.0) end



-- Инициализация параметров Smoke Tuner (дым от покрышек)
if _G.CheatMenu_Smoke_Enabled == nil then _G.CheatMenu_Smoke_Enabled = im.BoolPtr(false) end
if _G.CheatMenu_Smoke_Color == nil then 
    _G.CheatMenu_Smoke_Color = im.ArrayFloat(4)
    _G.CheatMenu_Smoke_Color[0], _G.CheatMenu_Smoke_Color[1], _G.CheatMenu_Smoke_Color[2], _G.CheatMenu_Smoke_Color[3] = 0.9, 0.1, 0.1, 1.0
end
if _G.CheatMenu_Smoke_Density == nil then _G.CheatMenu_Smoke_Density = im.FloatPtr(1.0) end
if _G.CheatMenu_Smoke_Size == nil then _G.CheatMenu_Smoke_Size = im.FloatPtr(1.0) end
if _G.CheatMenu_Smoke_Lifetime == nil then _G.CheatMenu_Smoke_Lifetime = im.FloatPtr(1.0) end
if _G.CheatMenu_Smoke_EasyBurnout == nil then _G.CheatMenu_Smoke_EasyBurnout = im.BoolPtr(false) end



-- Инициализация переменных для особого управления камерой
if _G.CheatMenu_CamSpeed == nil then _G.CheatMenu_CamSpeed = im.FloatPtr(30.0) end
if _G.CheatMenu_CamYaw == nil then _G.CheatMenu_CamYaw = im.FloatPtr(0.0) end
if _G.CheatMenu_CamPitch == nil then _G.CheatMenu_CamPitch = im.FloatPtr(0.0) end
if _G.CheatMenu_CamRoll == nil then _G.CheatMenu_CamRoll = im.FloatPtr(0.0) end




if _G.CheatMenu_GlassTint_Enabled == nil then _G.CheatMenu_GlassTint_Enabled = im.BoolPtr(false) end
if _G.CheatMenu_GlassTint_Solid == nil then _G.CheatMenu_GlassTint_Solid = im.BoolPtr(false) end -- Указатель режима глухой покраски [2]
if _G.CheatMenu_GlassTint_Color == nil then 
    _G.CheatMenu_GlassTint_Color = im.ArrayFloat(3)
    _G.CheatMenu_GlassTint_Color[0], _G.CheatMenu_GlassTint_Color[1], _G.CheatMenu_GlassTint_Color[2] = 0.0, 0.0, 0.0
end
if _G.CheatMenu_GlassTint_Alpha == nil then _G.CheatMenu_GlassTint_Alpha = im.FloatPtr(0.8) end




-- Инициализация переменных для спавнера объектов и функции разброса
if _G.CheatMenu_Obj_UseAllScan == nil then _G.CheatMenu_Obj_UseAllScan = im.BoolPtr(false) end
if _G.CheatMenu_Obj_AllFilter == nil then _G.CheatMenu_Obj_AllFilter = im.ArrayChar(64) end
if _G.CheatMenu_Obj_SelAllIdx == nil then _G.CheatMenu_Obj_SelAllIdx = 0 end
if _G.CheatMenu_Obj_SelectedCatIdx == nil then _G.CheatMenu_Obj_SelectedCatIdx = 0 end
if _G.CheatMenu_Obj_SelectedPropIdx == nil then _G.CheatMenu_Obj_SelectedPropIdx = 0 end
if _G.CheatMenu_Obj_SpawnDistance == nil then _G.CheatMenu_Obj_SpawnDistance = im.FloatPtr(6.0) end
if _G.CheatMenu_Obj_SpawnCount == nil then _G.CheatMenu_Obj_SpawnCount = im.IntPtr(1) end
if _G.CheatMenu_Obj_ScatterRadius == nil then _G.CheatMenu_Obj_ScatterRadius = im.FloatPtr(3.0) end
if _G.CheatMenu_Obj_ScaleX == nil then _G.CheatMenu_Obj_ScaleX = im.FloatPtr(1.0) end
if _G.CheatMenu_Obj_ScaleY == nil then _G.CheatMenu_Obj_ScaleY = im.FloatPtr(1.0) end
if _G.CheatMenu_Obj_ScaleZ == nil then _G.CheatMenu_Obj_ScaleZ = im.FloatPtr(1.0) end
if _G.CheatMenu_Obj_RotYaw == nil then _G.CheatMenu_Obj_RotYaw = im.FloatPtr(0.0) end
if _G.CheatMenu_Obj_CustomPath == nil then _G.CheatMenu_Obj_CustomPath = im.ArrayChar(256) end
if not _G.CheatMenu_SpawnedObjectsList then _G.CheatMenu_SpawnedObjectsList = {} end
if _G.CheatMenu_Obj_ScaleUniform == nil then _G.CheatMenu_Obj_ScaleUniform = im.FloatPtr(1.0) end
-- Инициализация формации спавна и интервала между объектами
if _G.CheatMenu_Obj_PatternIdx == nil then _G.CheatMenu_Obj_PatternIdx = 0 end
if _G.CheatMenu_Obj_Spacing == nil then _G.CheatMenu_Obj_Spacing = im.FloatPtr(3.0) end


if _G.CheatMenu_Headlight_Enabled == nil then _G.CheatMenu_Headlight_Enabled = im.BoolPtr(false) end
if _G.CheatMenu_Headlight_Brightness == nil then _G.CheatMenu_Headlight_Brightness = im.FloatPtr(1.0) end
if _G.CheatMenu_Headlight_Color == nil then 
    _G.CheatMenu_Headlight_Color = im.ArrayFloat(3)
    _G.CheatMenu_Headlight_Color[0], _G.CheatMenu_Headlight_Color[1], _G.CheatMenu_Headlight_Color[2] = 1.0, 1.0, 1.0 -- По умолчанию белый
end

if _G.CheatMenu_Neon_Enabled == nil then _G.CheatMenu_Neon_Enabled = im.BoolPtr(false) end
if _G.CheatMenu_Neon_Brightness == nil then _G.CheatMenu_Neon_Brightness = im.FloatPtr(1.0) end
if _G.CheatMenu_Neon_Color == nil then 
    _G.CheatMenu_Neon_Color = im.ArrayFloat(3)
    _G.CheatMenu_Neon_Color[0], _G.CheatMenu_Neon_Color[1], _G.CheatMenu_Neon_Color[2] = 0.0, 1.0, 1.0 -- По умолчанию бирюзовый (cyan)
end






-- Инициализация ползунка выбора количества спавнящихся авто
if _G.CheatMenu_Spawn_Amount == nil then _G.CheatMenu_Spawn_Amount = im.IntPtr(1) end

-- Инициализация параметров каталога транспорта
if _G.CheatMenu_Spawn_SelModelIdx == nil then _G.CheatMenu_Spawn_SelModelIdx = 0 end
if _G.CheatMenu_Spawn_SelConfigIdx == nil then _G.CheatMenu_Spawn_SelConfigIdx = 0 end
if _G.CheatMenu_Spawn_ModelFilter == nil then _G.CheatMenu_Spawn_ModelFilter = im.ArrayChar(64) end
if _G.CheatMenu_Spawn_ConfigFilter == nil then _G.CheatMenu_Spawn_ConfigFilter = im.ArrayChar(64) end

local cachedModelList = nil
-- Вспомогательная функция сборки и алфавитной сортировки всех моделей машин
local function getCachedModelList()
    if not cachedModelList then
        cachedModelList = {}
        -- Получаем полный список моделей через нативный getModelList(true)
        local listData = core_vehicles.getModelList and core_vehicles.getModelList(true)
        local models = listData and listData.models or {}
        
        for _, mData in ipairs(models) do
            local mKey = mData.key
            if mKey then
                local brand = mData.Brand or (mData.model and mData.model.Brand) or ""
                local name = mData.Name or (mData.model and mData.model.Name) or ""
                local fullName = (brand ~= "" and (brand .. " ") or "") .. name
                table.insert(cachedModelList, { key = mKey, name = fullName })
            end
        end
        table.sort(cachedModelList, function(a, b) return a.name < b.name end)
    end
    return cachedModelList
end

-- Вспомогательная функция извлечения всех .pc конфигураций модели
local function getModelConfigs(modelKey)
    local model = core_vehicles.getModel(modelKey)
    local configs = {}
    if model and model.configs then
        for cfgKey, cfgData in pairs(model.configs) do
            table.insert(configs, { key = cfgKey, name = cfgData.Configuration or cfgKey })
        end
        table.sort(configs, function(a, b) return a.name < b.name end)
    end
    return configs
end



-- Инициализация переменных для начисления наград RLS Career
if _G.CheatMenu_RLS_Money == nil then _G.CheatMenu_RLS_Money = im.IntPtr(5000) end
if _G.CheatMenu_RLS_XP == nil then _G.CheatMenu_RLS_XP = im.IntPtr(250) end
if _G.CheatMenu_RLS_Labourer == nil then _G.CheatMenu_RLS_Labourer = im.IntPtr(50) end
if _G.CheatMenu_RLS_ScalePayment == nil then _G.CheatMenu_RLS_ScalePayment = im.BoolPtr(true) end
if _G.CheatMenu_RLS_TagIdx == nil then _G.CheatMenu_RLS_TagIdx = 0 end



-- Инициализация индекса стиля UI (по умолчанию 0 - Оригинальный стиль игры)
if _G.CheatMenu_GuiStyleIdx == nil then
    _G.CheatMenu_GuiStyleIdx = 0
end

local pushedColorsCount = 0

-- Таблица кастомных цветовых схем (включая Dark, Light и Classic для изоляции окна)
local themes = {
    [1] = { -- Dark Theme
        {im.Col_Text, 0.90, 0.90, 0.90, 1.00},
        {im.Col_WindowBg, 0.06, 0.06, 0.06, 0.94},
        {im.Col_FrameBg, 0.16, 0.29, 0.48, 0.54},
        {im.Col_FrameBgHovered, 0.26, 0.59, 0.98, 0.40},
        {im.Col_FrameBgActive, 0.26, 0.59, 0.98, 0.67},
        {im.Col_TitleBg, 0.04, 0.04, 0.04, 1.00},
        {im.Col_TitleBgActive, 0.18, 0.35, 0.58, 1.00},
        {im.Col_Button, 0.26, 0.59, 0.98, 0.40},
        {im.Col_ButtonHovered, 0.26, 0.59, 0.98, 1.00},
        {im.Col_ButtonActive, 0.06, 0.53, 0.98, 1.00},
        {im.Col_Header, 0.26, 0.59, 0.98, 0.31},
        {im.Col_HeaderHovered, 0.26, 0.59, 0.98, 0.80},
        {im.Col_HeaderActive, 0.26, 0.59, 0.98, 1.00},
        {im.Col_SliderGrab, 0.24, 0.52, 0.88, 1.00},
        {im.Col_SliderGrabActive, 0.26, 0.59, 0.98, 1.00},
        {im.Col_Tab, 0.18, 0.35, 0.58, 0.86},
        {im.Col_TabHovered, 0.26, 0.59, 0.98, 0.80},
        {im.Col_TabActive, 0.20, 0.41, 0.68, 1.00},
        {im.Col_CheckMark, 0.26, 0.59, 0.98, 1.00}
    },
    [2] = { -- Light Theme
        {im.Col_Text, 0.00, 0.00, 0.00, 1.00},
        {im.Col_WindowBg, 0.94, 0.94, 0.94, 1.00},
        {im.Col_FrameBg, 1.00, 1.00, 1.00, 1.00},
        {im.Col_FrameBgHovered, 0.26, 0.59, 0.98, 0.40},
        {im.Col_FrameBgActive, 0.26, 0.59, 0.98, 0.67},
        {im.Col_TitleBg, 0.96, 0.96, 0.96, 1.00},
        {im.Col_TitleBgActive, 0.82, 0.82, 0.82, 1.00},
        {im.Col_Button, 0.26, 0.59, 0.98, 0.40},
        {im.Col_ButtonHovered, 0.26, 0.59, 0.98, 1.00},
        {im.Col_ButtonActive, 0.06, 0.53, 0.98, 1.00},
        {im.Col_Header, 0.26, 0.59, 0.98, 0.31},
        {im.Col_HeaderHovered, 0.26, 0.59, 0.98, 0.80},
        {im.Col_HeaderActive, 0.26, 0.59, 0.98, 1.00},
        {im.Col_SliderGrab, 0.26, 0.59, 0.98, 0.78},
        {im.Col_SliderGrabActive, 0.26, 0.59, 0.98, 1.00},
        {im.Col_Tab, 0.82, 0.82, 0.82, 0.86},
        {im.Col_TabHovered, 0.26, 0.59, 0.98, 0.80},
        {im.Col_TabActive, 0.70, 0.70, 0.70, 1.00},
        {im.Col_CheckMark, 0.26, 0.59, 0.98, 1.00}
    },
    [3] = { -- Classic Theme
        {im.Col_Text, 0.90, 0.90, 0.90, 1.00},
        {im.Col_WindowBg, 0.00, 0.00, 0.00, 0.85},
        {im.Col_FrameBg, 0.80, 0.80, 0.80, 0.30},
        {im.Col_FrameBgHovered, 0.80, 0.80, 0.80, 0.40},
        {im.Col_FrameBgActive, 0.80, 0.80, 0.80, 0.60},
        {im.Col_TitleBg, 0.50, 0.50, 0.50, 0.45},
        {im.Col_TitleBgActive, 0.50, 0.50, 0.50, 0.80},
        {im.Col_Button, 0.50, 0.50, 0.50, 0.60},
        {im.Col_ButtonHovered, 0.50, 0.50, 0.50, 0.80},
        {im.Col_ButtonActive, 0.50, 0.50, 0.50, 1.00},
        {im.Col_Header, 0.50, 0.50, 0.50, 0.45},
        {im.Col_HeaderHovered, 0.50, 0.50, 0.50, 0.80},
        {im.Col_HeaderActive, 0.50, 0.50, 0.50, 1.00},
        {im.Col_SliderGrab, 0.50, 0.50, 0.50, 0.80},
        {im.Col_SliderGrabActive, 0.50, 0.50, 0.50, 1.00},
        {im.Col_Tab, 0.50, 0.50, 0.50, 0.60},
        {im.Col_TabHovered, 0.50, 0.50, 0.50, 0.80},
        {im.Col_TabActive, 0.50, 0.50, 0.50, 1.00},
        {im.Col_CheckMark, 0.90, 0.90, 0.90, 0.85}
    },
    [4] = { -- BeamNG Orange
        {im.Col_Text, 0.95, 0.95, 0.95, 1.0},
        {im.Col_WindowBg, 0.1, 0.1, 0.12, 0.95},
        {im.Col_Button, 1.0, 0.4, 0.0, 0.6},
        {im.Col_ButtonHovered, 1.0, 0.5, 0.1, 0.8},
        {im.Col_ButtonActive, 0.8, 0.3, 0.0, 1.0},
        {im.Col_Header, 1.0, 0.4, 0.0, 0.4},
        {im.Col_HeaderHovered, 1.0, 0.5, 0.1, 0.6},
        {im.Col_HeaderActive, 0.8, 0.3, 0.0, 0.8},
        {im.Col_CheckMark, 1.0, 0.5, 0.1, 1.0},
        {im.Col_SliderGrab, 1.0, 0.4, 0.0, 0.7},
        {im.Col_SliderGrabActive, 0.8, 0.3, 0.0, 1.0},
        {im.Col_Tab, 1.0, 0.4, 0.0, 0.3},
        {im.Col_TabHovered, 1.0, 0.5, 0.1, 0.6},
        {im.Col_TabActive, 0.8, 0.3, 0.0, 0.8},
        {im.Col_FrameBg, 0.15, 0.15, 0.18, 1.0},
        {im.Col_FrameBgHovered, 0.25, 0.25, 0.3, 1.0},
        {im.Col_FrameBgActive, 0.35, 0.35, 0.4, 1.0},
        {im.Col_TitleBg, 0.15, 0.15, 0.18, 1.0},
        {im.Col_TitleBgActive, 1.0, 0.4, 0.0, 0.8}
    },
    [5] = { -- Hacker Green
        {im.Col_Text, 0.0, 1.0, 0.3, 1.0},
        {im.Col_WindowBg, 0.05, 0.07, 0.05, 0.95},
        {im.Col_Button, 0.0, 0.5, 0.1, 0.6},
        {im.Col_ButtonHovered, 0.0, 0.8, 0.2, 0.8},
        {im.Col_ButtonActive, 0.0, 1.0, 0.3, 1.0},
        {im.Col_Header, 0.0, 0.4, 0.1, 0.4},
        {im.Col_HeaderHovered, 0.0, 0.7, 0.2, 0.6},
        {im.Col_HeaderActive, 0.0, 1.0, 0.3, 0.8},
        {im.Col_CheckMark, 0.0, 1.0, 0.3, 1.0},
        {im.Col_SliderGrab, 0.0, 0.6, 0.2, 0.7},
        {im.Col_SliderGrabActive, 0.0, 1.0, 0.3, 1.0},
        {im.Col_FrameBg, 0.02, 0.04, 0.02, 1.0},
        {im.Col_FrameBgHovered, 0.05, 0.1, 0.05, 1.0},
        {im.Col_FrameBgActive, 0.1, 0.2, 0.1, 1.0},
        {im.Col_TitleBg, 0.02, 0.04, 0.02, 1.0},
        {im.Col_TitleBgActive, 0.0, 0.5, 0.1, 0.8}
    },
    [6] = { -- Cyberpunk Neon
        {im.Col_Text, 0.0, 1.0, 1.0, 1.0},
        {im.Col_WindowBg, 0.05, 0.02, 0.08, 0.95},
        {im.Col_Button, 1.0, 0.0, 0.5, 0.6},
        {im.Col_ButtonHovered, 1.0, 0.2, 0.7, 0.8},
        {im.Col_ButtonActive, 0.0, 1.0, 1.0, 1.0},
        {im.Col_Header, 1.0, 0.0, 0.5, 0.4},
        {im.Col_HeaderHovered, 1.0, 0.2, 0.7, 0.6},
        {im.Col_HeaderActive, 0.0, 1.0, 1.0, 0.8},
        {im.Col_CheckMark, 0.0, 1.0, 1.0, 1.0},
        {im.Col_SliderGrab, 1.0, 0.0, 0.5, 0.7},
        {im.Col_SliderGrabActive, 0.0, 1.0, 1.0, 1.0},
        {im.Col_FrameBg, 0.08, 0.04, 0.12, 1.0},
        {im.Col_FrameBgHovered, 0.12, 0.06, 0.18, 1.0},
        {im.Col_FrameBgActive, 0.18, 0.08, 0.25, 1.0},
        {im.Col_TitleBg, 0.08, 0.04, 0.12, 1.0},
        {im.Col_TitleBgActive, 1.0, 0.0, 0.5, 0.8}
    },
    [7] = { -- Cherry Red
        {im.Col_Text, 0.95, 0.9, 0.9, 1.0},
        {im.Col_WindowBg, 0.12, 0.08, 0.08, 0.95},
        {im.Col_Button, 0.6, 0.1, 0.15, 0.6},
        {im.Col_ButtonHovered, 0.8, 0.15, 0.2, 0.8},
        {im.Col_ButtonActive, 1.0, 0.2, 0.3, 1.0},
        {im.Col_Header, 0.5, 0.1, 0.12, 0.4},
        {im.Col_HeaderHovered, 0.7, 0.15, 0.18, 0.6},
        {im.Col_HeaderActive, 0.9, 0.2, 0.25, 0.8},
        {im.Col_CheckMark, 0.9, 0.2, 0.25, 1.0},
        {im.Col_SliderGrab, 0.6, 0.1, 0.15, 0.7},
        {im.Col_SliderGrabActive, 0.8, 0.15, 0.2, 1.0},
        {im.Col_FrameBg, 0.18, 0.12, 0.12, 1.0},
        {im.Col_FrameBgHovered, 0.24, 0.16, 0.16, 1.0},
        {im.Col_FrameBgActive, 0.32, 0.2, 0.2, 1.0},
        {im.Col_TitleBg, 0.18, 0.12, 0.12, 1.0},
        {im.Col_TitleBgActive, 0.6, 0.1, 0.15, 0.8}
    },
    [8] = { -- Corporate Grey
        {im.Col_Text, 0.9, 0.9, 0.9, 1.0},
        {im.Col_WindowBg, 0.2, 0.2, 0.22, 0.95},
        {im.Col_Button, 0.3, 0.3, 0.32, 0.6},
        {im.Col_ButtonHovered, 0.4, 0.4, 0.42, 0.8},
        {im.Col_ButtonActive, 0.5, 0.5, 0.52, 1.0},
        {im.Col_Header, 0.28, 0.28, 0.3, 0.4},
        {im.Col_HeaderHovered, 0.35, 0.35, 0.38, 0.6},
        {im.Col_HeaderActive, 0.45, 0.45, 0.48, 0.8},
        {im.Col_CheckMark, 0.7, 0.7, 0.72, 1.0},
        {im.Col_SliderGrab, 0.35, 0.35, 0.38, 0.7},
        {im.Col_SliderGrabActive, 0.45, 0.45, 0.48, 1.0},
        {im.Col_FrameBg, 0.25, 0.25, 0.28, 1.0},
        {im.Col_FrameBgHovered, 0.32, 0.32, 0.35, 1.0},
        {im.Col_FrameBgActive, 0.4, 0.4, 0.45, 1.0},
        {im.Col_TitleBg, 0.25, 0.25, 0.28, 1.0},
        {im.Col_TitleBgActive, 0.35, 0.35, 0.38, 0.8}
    },
    [9] = { -- Midnight Blue
        {im.Col_Text, 0.9, 0.95, 1.0, 1.0},
        {im.Col_WindowBg, 0.06, 0.08, 0.15, 0.95},
        {im.Col_Button, 0.12, 0.2, 0.4, 0.6},
        {im.Col_ButtonHovered, 0.18, 0.28, 0.55, 0.8},
        {im.Col_ButtonActive, 0.25, 0.38, 0.75, 1.0},
        {im.Col_Header, 0.1, 0.18, 0.35, 0.4},
        {im.Col_HeaderHovered, 0.15, 0.25, 0.5, 0.6},
        {im.Col_HeaderActive, 0.22, 0.35, 0.7, 0.8},
        {im.Col_CheckMark, 0.25, 0.38, 0.75, 1.0},
        {im.Col_SliderGrab, 0.15, 0.25, 0.5, 0.7},
        {im.Col_SliderGrabActive, 0.22, 0.35, 0.7, 1.0},
        {im.Col_FrameBg, 0.08, 0.12, 0.2, 1.0},
        {im.Col_FrameBgHovered, 0.12, 0.18, 0.28, 1.0},
        {im.Col_FrameBgActive, 0.18, 0.25, 0.38, 1.0},
        {im.Col_TitleBg, 0.08, 0.12, 0.2, 1.0},
        {im.Col_TitleBgActive, 0.15, 0.25, 0.5, 0.8}
    }
}

-- Отправка кастомных цветов темы в стек ImGui
local function pushThemeColors(themeIdx)
    local theme = themes[themeIdx]
    if not theme then return end -- Для индекса 0 ничего не пушим (наследуется заводской стиль игры)
    
    pushedColorsCount = 0
    for _, colorInfo in ipairs(theme) do
        im.PushStyleColor2(colorInfo[1], im.ImVec4(colorInfo[2], colorInfo[3], colorInfo[4], colorInfo[5]))
        pushedColorsCount = pushedColorsCount + 1
    end
end

-- Извлечение цветов из стека (в цикле для безопасности)
local function popThemeColors()
    if pushedColorsCount > 0 then
        for i = 1, pushedColorsCount do
            im.PopStyleColor()
        end
        pushedColorsCount = 0
    end
end





-- Функция применения стилей ImGui
local function applyGuiStyle(idx)
    -- Безопасная инициализация бэкапа оригинальной темы игры при первом вызове в кадре
    if not isBackupCreated then
        local stylePtr = im.GetStyle()
        if stylePtr then
            -- Вычисляем точный размер структуры в памяти и выделяем под нее байтовый буфер
            local size = ffi.sizeof(stylePtr[0])
            defaultStyleBackup = ffi.new("char[?]", size)
            ffi.copy(defaultStyleBackup, stylePtr, size)
            isBackupCreated = true
        end
    end

    if idx == 0 then
        -- Восстановление оригинальной темы из байтового бэкапа
        if isBackupCreated and defaultStyleBackup then
            local stylePtr = im.GetStyle()
            local size = ffi.sizeof(stylePtr[0])
            ffi.copy(stylePtr, defaultStyleBackup, size)
        end
    elseif idx == 1 then
        im.StyleColorsDark()
    elseif idx == 2 then
        im.StyleColorsLight()
    elseif idx == 3 then
        im.StyleColorsClassic()
    end
end





-- ============================================================
-- SYSTÈME DE SAUVEGARDES DE CONFIG (PRESETS)
-- ============================================================
local PRESET_FILE = "settings/cheatMenuPresets.json"
local NUM_PRESET_SLOTS = 5

local _presets = nil  -- cache chargé depuis le fichier

local function loadPresets()
    if _presets then return _presets end
    if FS:fileExists(PRESET_FILE) then
        local raw = readFile(PRESET_FILE)
        local ok, data = pcall(jsonDecode, raw)
        if ok and type(data) == "table" then
            _presets = data
            return _presets
        end
    end
    _presets = {}
    return _presets
end

local function savePresetsFile()
    writeFile(PRESET_FILE, jsonEncode(_presets or {}))
end

-- Clés à sauvegarder par véhicule (varName utilisé dans ptrCache)
local PRESET_KEYS = {
    { key = "powerMultiplier",    default = 1.0  },
    { key = "gripMultiplier",     default = 1.0  },
    { key = "brakeMultiplier",    default = 1.0  },
    { key = "globalStrengthMult", default = 1.0  },
    { key = "weightMultiplier",   default = 1.0  },
    { key = "gravityMultiplier",  default = 1.0  },
    { key = "engineBrakeMult",    default = 1.0  },
    { key = "airDragMult",        default = 1.0  },
    { key = "torqueMultiplier",   default = 1.0  },
    { key = "frictionMultiplier", default = 1.0  },
}

local function captureCurrentConfig(vehId)
    local cfg = {}
    for _, entry in ipairs(PRESET_KEYS) do
        local ptr = ptrCache[vehId] and ptrCache[vehId][entry.key]
        cfg[entry.key] = ptr and ptr[0] or entry.default
    end
    return cfg
end

local function applyPresetConfig(vehId, cfg)
    local v = be:getObjectByID(vehId)
    if not v then return end
    for _, entry in ipairs(PRESET_KEYS) do
        local val = cfg[entry.key]
        if val then
            if not ptrCache[vehId] then ptrCache[vehId] = {} end
            if not ptrCache[vehId][entry.key] then
                ptrCache[vehId][entry.key] = im.FloatPtr(val)
            else
                ptrCache[vehId][entry.key][0] = val
            end
            -- Applique côté véhicule via les fonctions existantes
            local fnMap = {
                powerMultiplier    = "applyPowerMultiplier",
                gripMultiplier     = "applyGripMultiplier",
                brakeMultiplier    = "applyBrakeMultiplier",
                globalStrengthMult = "applyGlobalBeamStrengthMult",
                weightMultiplier   = "applyWeightMultiplier",
                gravityMultiplier  = "applyGravityMultiplier",
                engineBrakeMult    = "applyEngineBrakeMult",
                airDragMult        = "applyAirDragMult",
                torqueMultiplier   = "applyTorqueMultiplier",
                frictionMultiplier = "applyFrictionMultiplier",
            }
            local fn = fnMap[entry.key]
            if fn then
                v:queueLuaCommand(string.format(
                    "if CheatMenuM and CheatMenuM.%s then CheatMenuM.%s(%f) end", fn, fn, val))
            end
        end
    end
end

-- État UI du système de presets
if _G.CheatMenu_Preset_NameBuf == nil then
    _G.CheatMenu_Preset_NameBuf = im.ArrayChar(64)
end
if _G.CheatMenu_Preset_SelectedIdx == nil then
    _G.CheatMenu_Preset_SelectedIdx = im.IntPtr(-1)
end
if _G.CheatMenu_Preset_Msg == nil then
    _G.CheatMenu_Preset_Msg = ""
end
if _G.CheatMenu_Preset_MsgTimer == nil then
    _G.CheatMenu_Preset_MsgTimer = 0.0
end

local function renderPresetsTab(vehId, dtReal)
    loadPresets()

    -- Message flash
    if _G.CheatMenu_Preset_MsgTimer > 0 then
        _G.CheatMenu_Preset_MsgTimer = _G.CheatMenu_Preset_MsgTimer - (dtReal or 0.016)
        im.TextColored(im.ImVec4(0.4, 1.0, 0.5, 1.0), _G.CheatMenu_Preset_Msg)
        im.Separator()
    end

    im.TextColored(im.ImVec4(1.0, 0.85, 0.3, 1.0), "Sauvegarder la configuration actuelle")
    im.SetNextItemWidth(260)
    im.InputText("##preset_name", _G.CheatMenu_Preset_NameBuf, 64)
    im.SameLine()
    if im.Button("Sauvegarder##preset_save", im.ImVec2(100, 0)) then
        local name = ffi.string(_G.CheatMenu_Preset_NameBuf)
        name = name:match("^%s*(.-)%s*$") -- trim
        if name ~= "" then
            local cfg = captureCurrentConfig(vehId)
            cfg._name = name
            cfg._date = os.date("%Y-%m-%d %H:%M")
            -- Remplace si nom existant, sinon ajoute
            local found = false
            for i, p in ipairs(_presets) do
                if p._name == name then
                    _presets[i] = cfg
                    found = true
                    break
                end
            end
            if not found then table.insert(_presets, cfg) end
            savePresetsFile()
            _G.CheatMenu_Preset_Msg = "Preset '" .. name .. "' sauvegardé!"
            _G.CheatMenu_Preset_MsgTimer = 3.0
        end
    end

    im.Separator()
    im.TextColored(im.ImVec4(1.0, 0.85, 0.3, 1.0), "Presets sauvegardés")

    if #_presets == 0 then
        im.TextDisabled("Aucun preset sauvegardé.")
    else
        for i, p in ipairs(_presets) do
            local label = string.format("[%d] %s  (%s)", i, p._name or "?", p._date or "")
            local selected = (_G.CheatMenu_Preset_SelectedIdx[0] == i - 1)
            if im.Selectable(label .. "##psel" .. i, selected) then
                _G.CheatMenu_Preset_SelectedIdx[0] = i - 1
            end
        end

        local selIdx = _G.CheatMenu_Preset_SelectedIdx[0] + 1
        if selIdx >= 1 and selIdx <= #_presets then
            local selPreset = _presets[selIdx]
            im.Separator()
            im.TextColored(im.ImVec4(0.6, 1.0, 0.6, 1.0), "Preset sélectionné : " .. (selPreset._name or "?"))

            -- Afficher les valeurs
            for _, entry in ipairs(PRESET_KEYS) do
                local val = selPreset[entry.key]
                if val then
                    im.Text(string.format("  %s = %.2f", entry.key, val))
                end
            end

            im.Spacing()
            if im.Button("Charger ce preset##preset_load", im.ImVec2(160, 0)) then
                applyPresetConfig(vehId, selPreset)
                _G.CheatMenu_Preset_Msg = "Preset '" .. (selPreset._name or "?") .. "' chargé!"
                _G.CheatMenu_Preset_MsgTimer = 3.0
            end
            im.SameLine()
            if im.Button("Supprimer##preset_del", im.ImVec2(100, 0)) then
                local name = selPreset._name or "?"
                table.remove(_presets, selIdx)
                savePresetsFile()
                _G.CheatMenu_Preset_SelectedIdx[0] = -1
                _G.CheatMenu_Preset_Msg = "Preset '" .. name .. "' supprimé."
                _G.CheatMenu_Preset_MsgTimer = 3.0
            end
        end
    end
end
-- ============================================================

local ptrCache = {}
local function getPtr(vehId, key, defaultVal, ptrType)
    if not ptrCache[vehId] then ptrCache[vehId] = {} end
    if not ptrCache[vehId][key] then
        ptrCache[vehId][key] = im[ptrType or "FloatPtr"](defaultVal)
    end
    return ptrCache[vehId][key]
end

-- ============================================================
-- PRESET CONDUITE (toggle F9 + auto au spawn)
-- ============================================================
local DRIVE_CHEAT_SETTINGS_FILE = "settings/cheatMenuDrivePreset.json"

local DRIVE_VEHICLE_PRESETS = {
  {
    id = "etk_series",
    label = "ETK Series",
    match = function(modelKey)
      if not modelKey then return false end
      local k = modelKey:lower()
      return k == "etk800" or k == "etkc" or k == "etki" or k:match("^etk") ~= nil
    end,
    config = {
      torqueProfile = "circuit",
      powerMultiplier = 9,
      rpmMultiplier = 8,
      gearMultiplier = 0.9,
      globalStrengthMult = 85000,
      structuralBoost = 1.38,
      laneKeepGain = 0.85,
      driveStabilityAssist = true,
      gravityMultiplier = 1.38,
      gripMultiplier = 1.95,
      brakeMultiplier = 32,
      brakeExtraMult = 1.15,
      brakePressureGain = 1.55,
      hardBrakeThreshold = 0.35,
      hardBrakeGain = 0.65,
      hardBrakePressureBoost = 1.5,
      hardEngineBrakeBoost = 2.2,
      massMultiplier = 0.93,
      stickyGrip = true,
      stickyGripForce = 0.48,
      disableTireTreadMorph = true,
      engineBrakeMultiplier = 1.35,
      dragMultiplier = 0.76,
      indestructibleEngine = true,
      collisionProof = true,
      freezeThermals = true,
      superTires = true,
      tireFrictionMult = 1.45,
      tireSlidingMult = 1.32,
      tireStiffnessMult = 1.16,
      tireDampMult = 1.26,
      tirePressurePSI = 30,
      suspensionSpringMult = 1.2,
      suspensionDampMult = 1.52,
      suspensionHeightMult = 0.96,
    },
    hint = "ETK: x9, grip 1.95, freins x32 + boost pédale, rapports longs, anti-burn + sticky",
  },
  {
    id = "scintilla",
    label = "Civetta Scintilla (OP)",
    match = function(modelKey)
      if not modelKey then return false end
      return modelKey:lower() == "scintilla"
    end,
    config = {
      torqueProfile = "circuit",
      powerMultiplier = 11,
      rpmMultiplier = 10,
      gearMultiplier = 0.98,
      globalStrengthMult = 95000,
      structuralBoost = 1.42,
      laneKeepGain = 0.9,
      awdOnPreset = true,
      pauseGameEsc = true,
      disableTireTreadMorph = true,
      launchTorqueRampSec = 1.2,
      launchTorqueMinFactor = 0.24,
      torqueLowEndScale = 0.65,
      tractionControlStrength = 1.9,
      downforceAssistGain = 3.6,
      driveStabilityAssist = true,
      stabilityStraightSteerMax = 0.38,
      stabilityAssistGain = 1.65,
      stabilityYawDampGain = 1.28,
      tractionControlMaxSpeed = 220,
      gravityMultiplier = 1.52,
      gripMultiplier = 2.55,
      brakeMultiplier = 24,
      brakeExtraMult = 1.12,
      brakePressureGain = 1.45,
      hardBrakeThreshold = 0.38,
      hardBrakeGain = 0.58,
      hardBrakePressureBoost = 1.4,
      hardEngineBrakeBoost = 2.05,
      massMultiplier = 0.98,
      engineBrakeMultiplier = 1.32,
      dragMultiplier = 0.55,
      indestructibleEngine = true,
      collisionProof = true,
      freezeThermals = true,
      superTires = true,
      stickyGrip = true,
      stickyGripForce = 0.85,
      tireFrictionMult = 1.88,
      tireSlidingMult = 1.14,
      tireStiffnessMult = 1.22,
      tireDampMult = 1.38,
      tirePressurePSI = 28,
      advancedTireTuning = {
        width = 1.05,
        sideSpring = 1.2, sideDamp = 1.32, sideStrength = 1.14,
        treadSpring = 1.16, treadDamp = 1.28, treadStrength = 1.18, treadDeform = 0.9,
        periSpring = 1.12, periDamp = 1.22, periStrength = 1.08,
        friction = 1.82, sliding = 1.1,
      },
      suspensionSpringMult = 1.28,
      suspensionDampMult = 1.7,
      suspensionHeightMult = 0.955,
    },
    hint = "Scintilla: grip max, freins x24+bonus, x11, AWD, ESC jeu off",
  },
  {
    id = "wl40",
    label = "Hirochi WL-40 (fun chantier)",
    match = function(modelKey)
      if not modelKey then return false end
      return modelKey:lower() == "wl40"
    end,
    config = {
      torqueProfile = "circuit",
      powerMultiplier = 7,
      rpmMultiplier = 10,
      gearMultiplier = 0.55,
      disableTractionControl = true,
      unlockIndustrialGovernor = true,
      globalStrengthMult = 24000,
      structuralBoost = 1.28,
      laneKeepGain = 0.25,
      driveStabilityAssist = true,
      stabilityStraightSteerMax = 0.48,
      stabilityAssistGain = 1.12,
      stabilityYawDampGain = 1.05,
      tractionControlStrength = 1.65,
      tractionControlMaxSpeed = 48,
      launchTorqueRampSec = 1.05,
      launchTorqueMinFactor = 0.32,
      torqueLowEndScale = 0.72,
      gravityMultiplier = 1.15,
      gripMultiplier = 1.42,
      brakeMultiplier = 9,
      brakeExtraMult = 1.04,
      massMultiplier = 0.9,
      engineBrakeMultiplier = 1.1,
      dragMultiplier = 0.74,
      indestructibleEngine = true,
      collisionProof = true,
      freezeThermals = true,
      superTires = true,
      stickyGrip = true,
      stickyGripForce = 0.5,
      disableTireTreadMorph = true,
      tireFrictionMult = 1.34,
      tireSlidingMult = 1.24,
      tireStiffnessMult = 1.1,
      tireDampMult = 1.18,
      tirePressurePSI = 36,
      suspensionSpringMult = 1.12,
      suspensionDampMult = 1.38,
      suspensionHeightMult = 0.99,
    },
    hint = "WL-40: x7, RPM x10, rapports longs, sans limite ECU 2200 / gouverneur",
  },
}

if _G.CheatMenu_DriveCheatEnabled == nil then
  _G.CheatMenu_DriveCheatEnabled = false
end
if _G.CheatMenu_DriveCheatEnabledPtr == nil then
  _G.CheatMenu_DriveCheatEnabledPtr = im.BoolPtr(_G.CheatMenu_DriveCheatEnabled)
end
if _G.CheatMenu_DriveCheat_F9Down == nil then
  _G.CheatMenu_DriveCheat_F9Down = false
end

local function saveDriveCheatSettings()
  writeFile(DRIVE_CHEAT_SETTINGS_FILE, jsonEncode({ enabled = _G.CheatMenu_DriveCheatEnabled == true }))
end

local function loadDriveCheatSettings()
  if not FS:fileExists(DRIVE_CHEAT_SETTINGS_FILE) then return end
  local ok, data = pcall(jsonDecode, readFile(DRIVE_CHEAT_SETTINGS_FILE))
  if ok and type(data) == "table" and data.enabled ~= nil then
    _G.CheatMenu_DriveCheatEnabled = data.enabled == true
    if _G.CheatMenu_DriveCheatEnabledPtr then
      _G.CheatMenu_DriveCheatEnabledPtr[0] = _G.CheatMenu_DriveCheatEnabled
    end
  end
end
loadDriveCheatSettings()

-- Bisection preset : cocher = module DÉSACTIVÉ pour ce véhicule (test freeze Scintilla, etc.)
local DRIVE_MODULE_OFF_FILE = "settings/cheatMenuDrivePresetModuleOff.json"
local DRIVE_MODULE_DEFS = {
  { id = "globalStrength",   label = "Carrosserie blindée (globalStrength)" },
  { id = "indestructibleEngine", label = "Moteur indestructible + heal" },
  { id = "freezeThermals", label = "Anti-surchauffe (freeze thermals)" },
  { id = "suspension",     label = "Suspension (ressorts / amort.)" },
  { id = "superTires",     label = "Super tires (beams roues)" },
  { id = "tireFriction",   label = "Friction pneus" },
  { id = "grip",           label = "Grip global" },
  { id = "brakes",         label = "Freins" },
  { id = "gravity",        label = "Gravité" },
  { id = "power",          label = "Puissance moteur (~3 s)" },
  { id = "rpm",            label = "RPM / rupteur (~3 s)" },
  { id = "drag",           label = "Drag air (~3 s)" },
  { id = "engineBrake",    label = "Frein moteur (~3 s)" },
}

if _G.CheatMenu_DriveModuleOff == nil then
  _G.CheatMenu_DriveModuleOff = {}
end

local function loadDriveModuleOffSettings()
  if not FS:fileExists(DRIVE_MODULE_OFF_FILE) then return end
  local ok, data = pcall(jsonDecode, readFile(DRIVE_MODULE_OFF_FILE))
  if ok and type(data) == "table" then
    _G.CheatMenu_DriveModuleOff = data
  end
end

local function saveDriveModuleOffSettings()
  writeFile(DRIVE_MODULE_OFF_FILE, jsonEncode(_G.CheatMenu_DriveModuleOff or {}))
end

loadDriveModuleOffSettings()

local function getDriveModuleOffPtr(presetId, moduleId)
  local gkey = "CheatMenu_DriveModOff_" .. tostring(presetId) .. "_" .. tostring(moduleId)
  if _G[gkey] == nil then
    _G[gkey] = im.BoolPtr(false)
  end
  local ptr = _G[gkey]
  local tbl = _G.CheatMenu_DriveModuleOff[presetId]
  ptr[0] = tbl and tbl[moduleId] == true
  return ptr
end

local function setDriveModuleOff(presetId, moduleId, isOff)
  if not _G.CheatMenu_DriveModuleOff[presetId] then
    _G.CheatMenu_DriveModuleOff[presetId] = {}
  end
  if isOff then
    _G.CheatMenu_DriveModuleOff[presetId][moduleId] = true
  else
    _G.CheatMenu_DriveModuleOff[presetId][moduleId] = nil
  end
  saveDriveModuleOffSettings()
end

local function buildDrivePresetPayload(preset)
  if not preset or not preset.config then return nil end
  local cfg = {}
  for k, v in pairs(preset.config) do
    cfg[k] = v
  end
  cfg.presetId = preset.id
  cfg.moduleOff = {}
  for _, def in ipairs(DRIVE_MODULE_DEFS) do
    local off = _G.CheatMenu_DriveModuleOff[preset.id]
        and _G.CheatMenu_DriveModuleOff[preset.id][def.id] == true
    if off then cfg.moduleOff[def.id] = true end
  end
  return cfg
end

local function driveModuleOffSummary(presetId)
  local parts = {}
  for _, def in ipairs(DRIVE_MODULE_DEFS) do
    local off = _G.CheatMenu_DriveModuleOff[presetId]
        and _G.CheatMenu_DriveModuleOff[presetId][def.id] == true
    if off then
      parts[#parts + 1] = def.id
    end
  end
  if #parts == 0 then return "tous modules ON" end
  return "OFF: " .. table.concat(parts, ", ")
end

local function drivePresetModuleOff(presetId, moduleId)
  local off = _G.CheatMenu_DriveModuleOff[presetId]
  return off and off[moduleId] == true
end

local function drivePresetExpectedMotor(preset)
  if not preset or not preset.config then return 1, 1 end
  local cfg = preset.config
  local wantP = drivePresetModuleOff(preset.id, "power") and 1 or (cfg.powerMultiplier or 1)
  local wantR = drivePresetModuleOff(preset.id, "rpm") and 1 or (cfg.rpmMultiplier or 1)
  return wantP, wantR
end

local function drivePresetMotorMatches(preset, vs)
  if not preset or not vs then return false end
  local wantP, wantR = drivePresetExpectedMotor(preset)
  local pwr = vs.powerMultiplier or 1
  local rpm = vs.rpmMultiplier or 1
  if wantP > 1.05 and pwr < wantP * 0.85 then return false end
  if wantR > 1.05 and rpm < wantR * 0.85 then return false end
  return true
end

local function normalizeDriveModelKey(modelKey)
  if not modelKey or modelKey == "" then return nil end
  local k = tostring(modelKey):lower():gsub("\\", "/")
  local base = k:match("([^/]+)$") or k
  base = base:gsub("%.jbeam$", "")
  return base
end

local function getVehicleDriveModelKey(v)
  if not v then return nil end
  local key = v.getJBeamFilename and v:getJBeamFilename()
  key = normalizeDriveModelKey(key)
  if key and key ~= "" and key ~= "?" then return key end
  if v.getField and v:getField("jbeam", 0) then
    return normalizeDriveModelKey(v:getField("jbeam", 0))
  end
  return key
end

local function findDrivePresetForModel(modelKey)
  local norm = normalizeDriveModelKey(modelKey)
  if not norm then return nil end
  for _, preset in ipairs(DRIVE_VEHICLE_PRESETS) do
    if preset.match(norm) then return preset end
  end
  return nil
end

-- BeamMP / multi : preset uniquement sur TA voiture (pas le clone ETK du pote)
local function cheatMenuIsMyVehicle(v, vehId)
  if not v and vehId and be and be.getObjectByID then
    v = be:getObjectByID(vehId)
  end
  if not v then return false end
  local vid = v:getID()
  if be and be.getPlayerVehicleID then
    local playerVid = be:getPlayerVehicleID(0)
    if playerVid and playerVid >= 0 and vid == playerVid then
      return true
    end
  end
  if be and be.getPlayerVehicle then
    local pv = be:getPlayerVehicle(0)
    if pv and pv:getID() == vid then return true end
  end
  if type(v.isPlayerControlled) == "function" and v:isPlayerControlled() then
    return true
  end
  return false
end

local function syncDriveCheatPtrs(vehId, cfg)
  if not cfg then return end
  for key, val in pairs(cfg) do
    if key == "moduleOff" or key == "presetId" then
    elseif type(val) == "number" then
      getPtr(vehId, key, val, "FloatPtr")[0] = val
    elseif type(val) == "boolean" then
      getPtr(vehId, key, val, "BoolPtr")[0] = val
    end
  end
end

local function applyDriveCheatConfigToVehicle(v, cfg, applyOpts)
  if not v or not cfg then return end
  applyOpts = applyOpts or {}
  local vehId = v:getID()
  local payload = jsonEncode(cfg)
  if applyOpts.afterRespawn then
    v:queueLuaCommand("_G.CheatMenu_DrivePresetRespawnApply = true")
  end
  if applyOpts.freshSpawn then
    v:queueLuaCommand("_G.CheatMenu_DrivePresetFreshSpawn = true")
  end
  if applyOpts.softReapply then
    v:queueLuaCommand("_G.CheatMenu_DrivePresetSoftReapply = true")
  end
  v:queueLuaCommand(string.format(
    "if CheatMenuM and CheatMenuM.applyDrivePreset then CheatMenuM.applyDrivePreset([===[%s]===]) end",
    payload))
  syncDriveCheatPtrs(vehId, cfg)
end

local function clearDriveCheatOnVehicle(v)
  if not v then return end
  v:queueLuaCommand([[
    if CheatMenuM and CheatMenuM.resetCheats then CheatMenuM.resetCheats() end
    if CheatMenuM and CheatMenuM.applyGlobalBeamStrengthMult then CheatMenuM.applyGlobalBeamStrengthMult(1.0) end
  ]])
end

local _driveCheatPendingApply = nil

local function scheduleDriveCheatApply(vehId, delaySec, applyOpts)
  applyOpts = applyOpts or {}
  local applyAt = os.clock() + (delaySec or 1.0)
  if _driveCheatPendingApply then
    _driveCheatPendingApply.applyAt = math.max(_driveCheatPendingApply.applyAt, applyAt)
    _driveCheatPendingApply.vehId = vehId or _driveCheatPendingApply.vehId
    if applyOpts.afterRespawn then _driveCheatPendingApply.afterRespawn = true end
    if applyOpts.freshSpawn then _driveCheatPendingApply.freshSpawn = true end
    if applyOpts.softReapply then _driveCheatPendingApply.softReapply = true end
    return
  end
  _driveCheatPendingApply = {
    vehId = vehId or (be:getPlayerVehicle(0) and be:getPlayerVehicle(0):getID()),
    applyAt = applyAt,
    afterRespawn = applyOpts.afterRespawn == true,
    freshSpawn = applyOpts.freshSpawn == true,
    softReapply = applyOpts.softReapply == true,
  }
end

local function processDriveCheatPendingApply()
  if not _driveCheatPendingApply then return end
  if os.clock() < _driveCheatPendingApply.applyAt then return end
  local vehId = _driveCheatPendingApply.vehId
  local afterRespawn = _driveCheatPendingApply.afterRespawn
  local freshSpawn = _driveCheatPendingApply.freshSpawn
  local softReapply = _driveCheatPendingApply.softReapply
  _driveCheatPendingApply = nil
  local v = vehId and be:getObjectByID(vehId) or be:getPlayerVehicle(0)
  if not v then return end
  if not cheatMenuIsMyVehicle(v) then return end

  if _G.CheatMenu_DriveCheatEnabled then
    local preset = findDrivePresetForModel(getVehicleDriveModelKey(v))
    if preset then
      applyDriveCheatConfigToVehicle(v, buildDrivePresetPayload(preset), {
        afterRespawn = afterRespawn and not softReapply,
        freshSpawn = freshSpawn and not softReapply,
        softReapply = softReapply,
      })
      if guihooks and guihooks.message then
        guihooks.message("Preset conduite: " .. preset.label .. " — " .. driveModuleOffSummary(preset.id), 4, "cheat_drive_preset")
      end
    end
  else
    clearDriveCheatOnVehicle(v)
  end
  v:queueLuaCommand(string.format("_G.CheatMenu_DriveCheatEnabled = %s", tostring(_G.CheatMenu_DriveCheatEnabled == true)))
end

function M.onDrivePresetPowerApplied(vehId)
  local v = vehId and be:getObjectByID(vehId) or be:getPlayerVehicle(0)
  if not v then return end
  vehId = v:getID()
  if _G.CheatMenuWindow_Data and _G.CheatMenuWindow_Data.torqueCurve then
    _G.CheatMenuWindow_Data.torqueCurve[vehId] = nil
  end
  if _G.CheatMenu_DriveCheatEnabled then
    local preset = findDrivePresetForModel(getVehicleDriveModelKey(v))
    if preset then
      syncDriveCheatPtrs(vehId, buildDrivePresetPayload(preset))
    end
  end
  v:queueLuaCommand("if CheatMenuM and CheatMenuM.pushTorqueCurveToGe then CheatMenuM.pushTorqueCurveToGe(true) end")
end

function M.scheduleDriveCheatApplyForVehicle(vehId, opts)
  opts = opts or {}
  if not _G.CheatMenu_DriveCheatEnabled then return end
  scheduleDriveCheatApply(vehId, opts.delay or 1.0, {
    afterRespawn = opts.afterRespawn == true,
    freshSpawn = opts.freshSpawn == true,
    softReapply = opts.softReapply == true,
  })
end

function M.toggleDriveCheatPreset()
  _G.CheatMenu_DriveCheatEnabled = not _G.CheatMenu_DriveCheatEnabled
  if _G.CheatMenu_DriveCheatEnabledPtr then
    _G.CheatMenu_DriveCheatEnabledPtr[0] = _G.CheatMenu_DriveCheatEnabled
  end
  saveDriveCheatSettings()

  local v = be:getPlayerVehicle(0)
  if not v then return end

  if _G.CheatMenu_DriveCheatEnabled then
    local preset = findDrivePresetForModel(getVehicleDriveModelKey(v))
    if preset then
      applyDriveCheatConfigToVehicle(v, buildDrivePresetPayload(preset))
      if guihooks and guihooks.message then
        guihooks.message("Preset conduite ON — " .. preset.label .. " (" .. driveModuleOffSummary(preset.id) .. ")", 5, "cheat_drive_preset")
      end
    else
      _G.CheatMenu_DriveCheatEnabled = false
      if _G.CheatMenu_DriveCheatEnabledPtr then _G.CheatMenu_DriveCheatEnabledPtr[0] = false end
      saveDriveCheatSettings()
      if guihooks and guihooks.message then
        guihooks.message("Pas de preset pour ce véhicule (ETK / Scintilla pour l'instant).", 4, "cheat_drive_preset")
      end
    end
  else
    clearDriveCheatOnVehicle(v)
    if guihooks and guihooks.message then
      guihooks.message("Preset conduite OFF — retour stock", 3, "cheat_drive_preset")
    end
  end

  v:queueLuaCommand(string.format("_G.CheatMenu_DriveCheatEnabled = %s", tostring(_G.CheatMenu_DriveCheatEnabled == true)))
end

local function renderDriveCheatBar(v, vehId)
  local modelKey = getVehicleDriveModelKey(v) or "?"
  local preset = findDrivePresetForModel(modelKey)
  local enabledPtr = _G.CheatMenu_DriveCheatEnabledPtr
  if not enabledPtr then return end
  enabledPtr[0] = _G.CheatMenu_DriveCheatEnabled == true

  im.TextColored(im.ImVec4(0.45, 0.95, 1.0, 1.0), "Preset conduite (spawn / F9)")
  if im.Checkbox("Activer preset auto##drive_cheat_en", enabledPtr) then
    local want = enabledPtr[0]
    if want ~= (_G.CheatMenu_DriveCheatEnabled == true) then
      M.toggleDriveCheatPreset()
    end
  end
  im.SameLine()
  if im.Button("Toggle (F9)##drive_cheat_btn", im.ImVec2(110, 0)) then
    M.toggleDriveCheatPreset()
  end
  if preset then
    im.TextDisabled(string.format("Modèle: %s  →  %s", modelKey, preset.label))
    im.TextDisabled(preset.hint or "Preset conduite actif pour ce modèle.")
    im.TextDisabled("Multi/BeamMP : preset seulement sur TA voiture (ID joueur).")
    im.TextDisabled(driveModuleOffSummary(preset.id))
    local vs = _G.CheatMenuWindow_Data and _G.CheatMenuWindow_Data.vehicleStates
        and _G.CheatMenuWindow_Data.vehicleStates[vehId]
    if vs and _G.CheatMenu_DriveCheatEnabled then
      local pwr = vs.powerMultiplier or 1
      local rpm = vs.rpmMultiplier or 1
      local wantP, wantR = drivePresetExpectedMotor(preset)
      local motorOk = drivePresetMotorMatches(preset, vs)
      local statusCol = motorOk
          and im.ImVec4(0.5, 1.0, 0.65, 1.0)
          or im.ImVec4(1.0, 0.72, 0.35, 1.0)
      im.TextColored(
        statusCol,
        string.format("Moteur live: x%.1f | x%.1f RPM (cible x%.0f / x%.0f)",
          pwr, rpm, wantP, wantR))
      if motorOk then
        im.TextColored(im.ImVec4(0.5, 1.0, 0.65, 1.0), "Preset moteur OK sur la voiture")
      else
        im.TextColored(
          im.ImVec4(1.0, 0.55, 0.45, 1.0),
          "F9 ON mais moteur pas appliqué (flag châssis seul) — F9 OFF/ON ou respawn ETK")
        if vs.drivePresetActive == true and pwr < 1.5 then
          im.TextDisabled("Le menu mentait avant : « preset actif » = flag interne, pas x9 réel.")
        end
      end
    end
    local bisectOpen = im.TreeNode1("Bisection modules (test freeze)##drive_mod_bisect")
    if bisectOpen then
      im.TextDisabled("Cocher = module coupé. F9 OFF puis ON pour réappliquer.")
      im.TextDisabled("Ordre: puissance → super tires → carrosserie → reste.")
      for _, def in ipairs(DRIVE_MODULE_DEFS) do
        local offPtr = getDriveModuleOffPtr(preset.id, def.id)
        if im.Checkbox(def.label .. "##drive_off_" .. def.id, offPtr) then
          setDriveModuleOff(preset.id, def.id, offPtr[0] == true)
        end
      end
      im.TreePop()
    end
  else
    im.TextDisabled(string.format("Modèle: %s  →  aucun preset défini", modelKey))
  end
  im.Separator()
end

local function pollDriveCheatHotkey()
  if not im or not im.GetKeyIndex or not im.IsKeyDown then return end
  local f9Idx = im.GetKeyIndex(im.Key_F9)
  local f9Now = im.IsKeyDown(f9Idx)
  if f9Now and not _G.CheatMenu_DriveCheat_F9Down then
    M.toggleDriveCheatPreset()
  end
  _G.CheatMenu_DriveCheat_F9Down = f9Now
end
-- ============================================================

local function getStringPtr(vehId, key, defaultVal)
    if not ptrCache[vehId] then ptrCache[vehId] = {} end
    if not ptrCache[vehId][key] then
        local buf = im.ArrayChar(128)
        ffi.copy(buf, tostring(defaultVal or ""))
        ptrCache[vehId][key] = buf
    end
    return ptrCache[vehId][key]
end

local function getConsoleNumber(varName)
  local result = getConsoleVariable(varName)
  return result == "" and -1 or result
end

local function renderEngineVarSlider(label, varName, minVal, maxVal, defaultVal, isInt)
    local currentVal = getConsoleVariable(varName)
    currentVal = currentVal == "" and defaultVal or tonumber(currentVal) or defaultVal
    
    local ptr = getPtr(0, "pref_" .. varName, currentVal, isInt and "IntPtr" or "FloatPtr")
    
    if not im.IsItemActive() then
        ptr[0] = currentVal
    end
    
    im.SetNextItemWidth(200)
    local changed
    if isInt then
        changed = im.SliderInt(label .. "##" .. varName, ptr, minVal, maxVal, "%d")
    else
        changed = im.SliderFloat(label .. "##" .. varName, ptr, minVal, maxVal, "%.3f")
    end
    
    if changed then
        setConsoleVariable(varName, tostring(ptr[0]))
    end
    if im.IsItemHovered() then
        im.SetTooltip("Ctrl + Click to type a custom value (supports any value down to 0)")
    end
end

-- Инициализируем структуру данных для всей электроники
if not _G.CheatMenuWindow_Data.electrics then
    _G.CheatMenuWindow_Data.electrics = {}
end

local electricsFilterText = im.ArrayChar(64) -- Фильтр поиска по электронике
local partFilterText = im.ArrayChar(64)
local tempFilterText = im.ArrayChar(64)
local powertrainFilterText = im.ArrayChar(64)

-- Интеграция с системой группового спавна BeamNG
local multiSpawn = core_multiSpawn or (extensions and extensions.core_multiSpawn)

local spawnModesList = {
    "roadAhead", "roadBehind", "roadAheadAlt", "roadBehindAlt",
    "traffic", "raceGrid", "raceGridAlt",
    "lineLeft", "lineRight", "lineBehind", "lineAbove", "lineAhead"
}

local countriesList = {"All", "USA", "Japan", "Germany", "France", "Italy", "UK", "Sweden", "Russia"}
local weatherModule = core_weather or (extensions and extensions.core_weather)

-- Инициализируем глобальную таблицу задержек записи для предотвращения "отскоков" интерфейса
if not _G.CheatMenu_LastWriteTimes then
    _G.CheatMenu_LastWriteTimes = {}
end

if not _G.CheatMenu_VehSpecs then
    _G.CheatMenu_VehSpecs = {}
end

-- Безопасный инициализатор/исправитель указателей ImGui в глобальном пространстве _G
local function sanitizeGlobalPtr(globalKey, defaultVal, creatorFunc)
    local val = _G[globalKey]
    if not val or (type(val) ~= "table" and type(val) ~= "userdata") or val[0] == nil then
        _G[globalKey] = creatorFunc(defaultVal)
    end
end

if _G.CheatMenu_AllVehiclesESP == nil then
    _G.CheatMenu_AllVehiclesESP = false
end
if _G.CheatMenu_ESP_MaxDistance == nil then
    _G.CheatMenu_ESP_MaxDistance = 1000.0
end

-- Принудительно проверяем и исправляем типы указателей, если они были повреждены при перезагрузках
sanitizeGlobalPtr("CheatMenu_ESP_ShowLines", true, im.BoolPtr)
sanitizeGlobalPtr("CheatMenu_ESP_ShowText", true, im.BoolPtr)
sanitizeGlobalPtr("CheatMenu_ESP_ShowSpeed", true, im.BoolPtr)
sanitizeGlobalPtr("CheatMenu_ESP_ShowModel", true, im.BoolPtr)

local col = _G.CheatMenu_ESP_LineColor
if not col or (type(col) ~= "table" and type(col) ~= "userdata") or col[0] == nil then
    _G.CheatMenu_ESP_LineColor = im.ArrayFloat(4)
    _G.CheatMenu_ESP_LineColor[0] = 0.2
    _G.CheatMenu_ESP_LineColor[1] = 1.0
    _G.CheatMenu_ESP_LineColor[2] = 0.2
    _G.CheatMenu_ESP_LineColor[3] = 1.0
end

if _G.CheatMenu_ESP_LineThickness == nil then
    _G.CheatMenu_ESP_LineThickness = 1.0
end

local tCol = _G.CheatMenu_ESP_TextColor
if not tCol or (type(tCol) ~= "table" and type(tCol) ~= "userdata") or tCol[0] == nil then
    _G.CheatMenu_ESP_TextColor = im.ArrayFloat(4)
    _G.CheatMenu_ESP_TextColor[0] = 1.0
    _G.CheatMenu_ESP_TextColor[1] = 1.0
    _G.CheatMenu_ESP_TextColor[2] = 1.0
    _G.CheatMenu_ESP_TextColor[3] = 1.0
end

local bCol = _G.CheatMenu_ESP_BgColor
if not bCol or (type(bCol) ~= "table" and type(bCol) ~= "userdata") or bCol[0] == nil then
    _G.CheatMenu_ESP_BgColor = im.ArrayFloat(4)
    _G.CheatMenu_ESP_BgColor[0] = 0.0
    _G.CheatMenu_ESP_BgColor[1] = 0.0
    _G.CheatMenu_ESP_BgColor[2] = 0.0
    _G.CheatMenu_ESP_BgColor[3] = 0.7
end




if _G.CheatMenu_TeleportX == nil then _G.CheatMenu_TeleportX = im.FloatPtr(0.0) end
if _G.CheatMenu_TeleportY == nil then _G.CheatMenu_TeleportY = im.FloatPtr(0.0) end
if _G.CheatMenu_TeleportZ == nil then _G.CheatMenu_TeleportZ = im.FloatPtr(0.0) end
if _G.CheatMenu_TeleportDistance == nil then _G.CheatMenu_TeleportDistance = im.FloatPtr(10.0) end
if _G.CheatMenu_FreezeVehicle == nil then _G.CheatMenu_FreezeVehicle = im.BoolPtr(false) end

if _G.CheatMenu_EngineInertia == nil then _G.CheatMenu_EngineInertia = im.FloatPtr(0.12) end

-- Глобальный флаг для постоянного взлома миссий
if _G.CheatMenu_PermanentMissionUnlock == nil then
    _G.CheatMenu_PermanentMissionUnlock = false
end

-- Перехватчик калькулятора миссий игры (unlocks.lua)
local originalUpdateUnlockStatus = nil
local function applyPermanentMissionUnlock(enabled)
    local unlocksMod = gameplay_missions_unlocks
    if not unlocksMod then return end
    
    if enabled then
        -- Сохраняем оригинальную функцию игры в буфер, если еще не сохранили
        if not originalUpdateUnlockStatus and unlocksMod.updateUnlockStatus then
            originalUpdateUnlockStatus = unlocksMod.updateUnlockStatus
        end
        
        -- Переопределяем системный расчет игры на наш чит-вариант
        unlocksMod.updateUnlockStatus = function(missions)
            missions = missions or gameplay_missions_missions.get()
            for _, mission in ipairs(missions) do
                mission.unlocks = mission.unlocks or {}
                mission.unlocks.startable = true
                mission.unlocks.visible = true
            end
            if gameplay_rawPois then gameplay_rawPois.clear() end
        end
        
        -- Принудительно вызываем один раз для немедленного открытия
        unlocksMod.updateUnlockStatus()
    else
        -- Возвращаем оригинальную функцию расчета прогресса на место
        if originalUpdateUnlockStatus then
            unlocksMod.updateUnlockStatus = originalUpdateUnlockStatus
            originalUpdateUnlockStatus = nil
            -- Запускаем оригинальный расчет, чтобы заблокировать недоступные миссии обратно
            unlocksMod.updateUnlockStatus()
        end
    end
end

-- Объявляем функцию как ГЛОБАЛЬНУЮ (без слова local!), чтобы она была доступна везде
function syncPtr(vehId, ptrName, stateVal, ptrType)
    local ptr = getPtr(vehId, ptrName, stateVal, ptrType)
    
    local lastWrite = _G.CheatMenu_LastWriteTimes and _G.CheatMenu_LastWriteTimes[vehId .. "." .. ptrName]
    local isRecentWrite = lastWrite and (os.clock() - lastWrite) < 0.6
    
    if not isRecentWrite and not im.IsItemActive() then
        ptr[0] = stateVal
    end
    return ptr
end



-- РАСЧЕТ ИНДЕКСА ПРОИЗВОДИТЕЛЬНОСТИ И КЛАССОВ (Performance Index / PI)

local vehicleClasses = {
  {name = "X",  minPI = 101, description = "Modified"},
  {name = "S",  minPI = 86,  description = "Super Sports"},
  {name = "A",  minPI = 66,  description = "High Performance"},
  {name = "B",  minPI = 41,  description = "Sports"},
  {name = "C",  minPI = 21,  description = "Standard"},
  {name = "D",  minPI = 0,   description = "Economy/Utility"}
}

local performanceIndexMultipliers = {
  time_60 = {bias = 19.61451, multiplier = -8.29016},
  time_330 = {bias = 9.67742, multiplier = -0.96774},
  time_1000 = {bias = 15, multiplier = -0.5},
  time_1_8 = {bias = 22.40741, multiplier = -2.03704},
  time_1_4 = {bias = 29.14286, multiplier = -1.61905},
  time_0_60 = {bias = 21.42857, multiplier = -1.42857},
  velAt_1_8 = {bias = -8.00000, multiplier = 0.53333},
  velAt_1_4 = {bias = -6.00000, multiplier = 0.40000},
  brakingG = {bias = -3.57143, multiplier = 7.14286},
}

local baseCertificationData = {
  time_60 = 1.833000027,
  time_330 = 4.06650006,
  time_1_8 = 5.666500084,
  time_1_4 = 8.133500122,
  velAt_1_4 = 90.25240982,
  velAt_1_8 = 70.94814975,
  time_0_60 = 2.366500035,
  brakingG = 1.41712463,
  power = {propulsionPowerCombined = 1395241},
  torque = 1740,
  weight = 1280,
}

local function getWeightedValue(testData, category)
  if not testData[category] then return 0 end
  return math.max(performanceIndexMultipliers[category].bias + testData[category] * performanceIndexMultipliers[category].multiplier, 0)
end

local function getAggregateScores(testData)
  if not testData then return end

  -- Исправление ошибки типов: безопасно обрабатываем и таблицы, и числа
  local power = nil
  if type(testData.power) == "table" then
    power = testData.power.propulsionPowerCombined
  elseif type(testData.power) == "number" then
    -- Переводим лошадиные силы в Ватты (1 л.с. = 745.7 Вт)
    power = testData.power * 745.7
  end

  local basePower = baseCertificationData.power and baseCertificationData.power.propulsionPowerCombined

  local aggregateScores = {}

  aggregateScores.powerScore = power and (power / basePower) * 100 or 0
  aggregateScores.powerToWeightScore = (power and testData.weight) and
    (power / testData.weight) / (basePower / baseCertificationData.weight) * 100 or 0
  aggregateScores.timeTo60Score = (baseCertificationData.time_60 / testData.time_60) * 100
  aggregateScores.quarterMileScore = (baseCertificationData.time_1_4 / testData.time_1_4) * 100
  aggregateScores.speedProgressionScore = ((testData.velAt_1_4 - testData.velAt_1_8) / (baseCertificationData.velAt_1_4 - baseCertificationData.velAt_1_8)) * 100
  aggregateScores.brakingGForceScore = testData.brakingG and ((testData.brakingG / baseCertificationData.brakingG) * 100) or 0

  if testData.time_0_60 == 0 then testData.time_0_60 = nil end -- a time of 0 means the vehicle is not able to reach 60mph
  aggregateScores.time0To60Score = testData.time_0_60 and ((baseCertificationData.time_0_60 / testData.time_0_60) * 100) or 0

  return aggregateScores
end

local function getPerformanceIndex(testData)
  local weightedRawValueSum =
    getWeightedValue(testData, "time_60") +
    getWeightedValue(testData, "time_330") +
    getWeightedValue(testData, "time_1000") +
    getWeightedValue(testData, "time_1_8") +
    getWeightedValue(testData, "time_1_4") +
    getWeightedValue(testData, "time_0_60") +
    getWeightedValue(testData, "velAt_1_8") +
    getWeightedValue(testData, "velAt_1_4") +
    getWeightedValue(testData, "brakingG")

  return weightedRawValueSum
end

local function getClassFromData(testData)
  local performanceIndex = getPerformanceIndex(testData)
  if not performanceIndex then return end

  for _, class in ipairs(vehicleClasses) do
    if performanceIndex >= class.minPI then
      return {class = class, performanceIndex = performanceIndex}
    end
  end
end

local function getClassFromVehId(vehId)
  local vehicleDetails = core_vehicles and core_vehicles.getVehicleDetails(vehId)
  if not vehicleDetails then return end

  local performanceData = vehicleDetails.configs["Drag Times"]
  if not performanceData then return end

  performanceData.power = vehicleDetails.configs["Power"]
  performanceData.weight = vehicleDetails.configs["Weight"]

  return getClassFromData(performanceData)
end


-- Инициализируем указатели ImGui для тестера подвески
local nodeFrontPtr = im.IntPtr(nodeFrontAxle)
local nodeRearPtr = im.IntPtr(nodeRearAxle)
local freqExistsWindowPtr = im.IntPtr(1)
local numFreqsPtr = im.IntPtr(numFreqs)

local freqFiltersInitialized = false
local isTesterActive = false -- Флаг активности тестера (по умолчанию выключен)

-- Создание частотных фильтров
local function createFreqFilters()
    if not newFreqExists then return {} end
    local filters_list = {}
    for i = 1, numFreqs do
        local freq = minFreq + (i - 1) * freqStep
        filters_list[i] = {
            freq = freq,
            filter = newFreqExists()
        }
    end
    return filters_list
end

-- Инициализация нод тестера
local function initFreqNodes()
    for _, node in ipairs(freqNodes) do
        node.freqFilters = createFreqFilters()
        node.amplitudes = {}
    end
end

-- Безопасная инициализация при открытии вкладки
local function ensureFreqFilters()
    if freqFiltersInitialized then return end
    if newFreqExists then
        initFreqNodes()
        freqFiltersInitialized = true
    end
end


-- НАСТРОЙКИ И ФУНКЦИИ ДЛЯ РЕДАКТОРА КРАСКИ (Metallic Paint Editor)


-- Конвертация строки параметров краски в таблицу данных
local function stringToPaintData(colorString)
  if not colorString or colorString == "" then return {1, 1, 1, 1} end
  local result = {}
  for i, v in ipairs(stringToTable(colorString, '%s')) do
    result[i] = tonumber(v) or 1
  end
  for i = 1, 4 do
    if not result[i] then result[i] = 1 end
  end
  return result
end

-- Конвертация таблицы данных обратно в системную строку
local function paintDataToString(data)
  return string.format("%s %s %s %s", data[1], data[2], data[3], data[4])
end

-- Отрисовка ползунков параметров краски для выбранного слоя кузова
local function drawPaintLayerSliders(veh, layerIndex)
    local fieldVal = veh:getField('metallicPaintData', layerIndex)
    local data = stringToPaintData(fieldVal)
    local vehId = veh:getID()
    
    -- Получаем указатели на параметры слоя
    local roughPtr = getPtr(vehId, "paint_" .. layerIndex .. "_roughness", data[1], "FloatPtr")
    local metalPtr = getPtr(vehId, "paint_" .. layerIndex .. "_metallic", data[2], "FloatPtr")
    local coatPtr  = getPtr(vehId, "paint_" .. layerIndex .. "_coat", data[3], "FloatPtr")
    local coatRoughPtr = getPtr(vehId, "paint_" .. layerIndex .. "_coatRough", data[4], "FloatPtr")
    
    local changed = false
    
    -- Ползунок Шероховатости (Roughness)
    if not im.IsItemActive() then roughPtr[0] = data[1] end
    im.SetNextItemWidth(180)
    if im.SliderFloat("Roughness##rough_" .. layerIndex, roughPtr, 0.0, 1.0, "%.3f") then
        data[1] = roughPtr[0]
        changed = true
    end
    
    -- Ползунок Металлика (Metallic)
    if not im.IsItemActive() then metalPtr[0] = data[2] end
    im.SetNextItemWidth(180)
    if im.SliderFloat("Metallic##metal_" .. layerIndex, metalPtr, 0.0, 1.0, "%.3f") then
        data[2] = metalPtr[0]
        changed = true
    end
    
    -- Ползунок Лака (Clear Coat)
    if not im.IsItemActive() then coatPtr[0] = data[3] end
    im.SetNextItemWidth(180)
    if im.SliderFloat("Clear Coat##coat_" .. layerIndex, coatPtr, 0.0, 1.0, "%.3f") then
        data[3] = coatPtr[0]
        changed = true
    end
    
    -- Ползунок шероховатости лака (Coat Roughness)
    if not im.IsItemActive() then coatRoughPtr[0] = data[4] end
    im.SetNextItemWidth(180)
    if im.SliderFloat("Coat Roughness##coatRough_" .. layerIndex, coatRoughPtr, 0.0, 1.0, "%.3f") then
        data[4] = coatRoughPtr[0]
        changed = true
    end
    
    -- Если пользователь изменил любой ползунок, мгновенно обновляем кузов машины
    if changed then
        local strVal = paintDataToString(data)
        veh:setField('metallicPaintData', layerIndex, strVal)
    end
end

-- Функция применения качества теней (выполняется на стороне Game Engine)
local function applyShadowQualityGE(multiplier)
    if multiplier == 0 then return end
    local classes = {'PointLight', 'SpotLight', 'Sun', 'ScatterSky', 'ProjectedShadow', 'EnvironmentProbe'}
    if not _G.shadow_defaults_map then _G.shadow_defaults_map = {} end
    for _, className in ipairs(classes) do
        local names = scenetree.findClassObjects(className)
        for i = 1, #names do
            local obj = scenetree.findObject(names[i])
            if obj then
                local id = obj:getID()
                if not _G.shadow_defaults_map[id] then
                    _G.shadow_defaults_map[id] = obj.texSize or 512
                end
                obj.texSize = _G.shadow_defaults_map[id] * multiplier
                obj:postApply()
            end
        end
    end
end

-- Функция выплаты вознаграждения в RLS / Ванильной Карьере
function payoutRLSCareerReward()
    -- Безопасная проверка: активен ли режим карьеры прямо сейчас
    if not (career_career and career_career.isActive and career_career.isActive()) then
        -- Выводим игровое уведомление, если пользователь находится в свободном режиме
        if log then log('W', 'CheatMenu', 'payoutRLSCareerReward failed: Player is not in Career Mode.') end
        return
    end

    local moneyVal = _G.CheatMenu_RLS_Money[0]
    local xpVal = _G.CheatMenu_RLS_XP[0]
    local labVal = _G.CheatMenu_RLS_Labourer[0]
    local scaleByDiff = _G.CheatMenu_RLS_ScalePayment[0]

    -- 1. Формируем структуру данных награды (money, beamXP, labourer)
    local rewardData = {}
    if moneyVal > 0 then rewardData.money = { amount = moneyVal } end
    if xpVal > 0 then rewardData.beamXP = { amount = xpVal } end
    if labVal > 0 then rewardData.labourer = { amount = labVal } end

    -- 2. Масштабируем награду (кроме денег) в зависимости от выбранной сложности карьеры
    if scaleByDiff and career_modules_difficultyMode and career_modules_difficultyMode.scalePaymentRewardData then
        career_modules_difficultyMode.scalePaymentRewardData(rewardData, {includeMoney = false})
    end

    -- 3. Выбираем тип (теги и текст) в зависимости от категории
    local presetTags = {
        [0] = { tags = {"cheat"}, label = "Admin Payout Bonus" },
        [1] = { tags = {"gameplay", "reward", "laborer"}, label = "Laborer Job Payout Bonus" },
        [2] = { tags = {"transport", "taxi"}, label = "Taxi Service Fare Payout" },
        [3] = { tags = {"facility", "work"}, label = "Facility Operations Contract Paid" },
        [4] = { tags = {"cardGames"}, label = "Gambling Card Games Refund" }
    }
    
    local selectedPreset = presetTags[_G.CheatMenu_RLS_TagIdx] or presetTags[0]
    local paidMoney = (rewardData.money and rewardData.money.amount) or moneyVal
    local finalLabel = string.format("%s: +$%d", selectedPreset.label, paidMoney)

    -- 4. Отправляем транзакцию через штатный платежный шлюз карьеры
    if career_modules_payment and career_modules_payment.reward then
        career_modules_payment.reward(rewardData, {
            label = finalLabel,
            tags = selectedPreset.tags
        }, true) -- true автоматически сохраняет карьеру
    else
        -- Резервный метод начисления, если платежный модуль недоступен
        local fallbackAttribs = {}
        if moneyVal > 0 then fallbackAttribs.money = moneyVal end
        if xpVal > 0 then fallbackAttribs.beamXP = xpVal end
        if labVal > 0 then fallbackAttribs.labourer = labVal end
        
        if career_modules_playerAttributes and career_modules_playerAttributes.addAttributes then
            career_modules_playerAttributes.addAttributes(fallbackAttribs, {
                label = finalLabel,
                tags = selectedPreset.tags
            })
        end
    end

    -- 5. Принудительно инициируем сохранение прогресса на жесткий диск
    if career_saveSystem and career_saveSystem.saveCurrent then
        career_saveSystem.saveCurrent()
    end
end


-- ПОЛНОЦЕННЫЙ РАДУЖНЫЙ РЕЖИМ (FULL RAINBOW HSV MODE)

if _G.CheatMenu_Rainbow_Enabled == nil then _G.CheatMenu_Rainbow_Enabled = im.BoolPtr(false) end
if _G.CheatMenu_Rainbow_Speed == nil then _G.CheatMenu_Rainbow_Speed = im.FloatPtr(1.0) end          -- Скорость вращения радуги
if _G.CheatMenu_Rainbow_Sat == nil then _G.CheatMenu_Rainbow_Sat = im.FloatPtr(1.0) end              -- Насыщенность (0 = серый, 1 = сочный)
if _G.CheatMenu_Rainbow_Val == nil then _G.CheatMenu_Rainbow_Val = im.FloatPtr(1.0) end              -- Яркость
if _G.CheatMenu_Rainbow_Gloss == nil then _G.CheatMenu_Rainbow_Gloss = im.FloatPtr(1.4) end          -- Глянец / Хром
if _G.CheatMenu_Rainbow_ShiftLayer1 == nil then _G.CheatMenu_Rainbow_ShiftLayer1 = im.FloatPtr(0.33) end-- Сдвиг цвета для 2 слоя
if _G.CheatMenu_Rainbow_ShiftLayer2 == nil then _G.CheatMenu_Rainbow_ShiftLayer2 = im.FloatPtr(0.66) end-- Сдвиг цвета для 3 слоя

_G.CheatMenu_Rainbow_CurrentHue = 0.0


-- ВСПРАВОЧНЫЕ ФУНКЦИИ HSV -> RGB (ДОЛЖНЫ БЫТЬ СТРОГО ВЫШЕ ИХ ВЫЗОВА)

local function clamp01(x) 
  return (x < 0 and 0) or (x > 1 and 1) or x 
end

local function triadHsvToRgb(h, s, v)
  h = (h % 1) * 6
  local c = v * s
  local x = c * (1 - math.abs((h % 2) - 1))
  local m = v - c
  local r, g, b
  local i = math.floor(h)
  if i == 0 then r, g, b = c, x, 0
  elseif i == 1 then r, g, b = x, c, 0
  elseif i == 2 then r, g, b = 0, c, x
  elseif i == 3 then r, g, b = 0, x, c
  elseif i == 4 then r, g, b = x, 0, c
  else r, g, b = c, 0, x end
  return r + m, g + m, b + m
end



-- Теперь вызываем логику радуги (triadHsvToRgb теперь объявлен выше и доступен!)
local function updateFullRainbowMode(dt)
  if not _G.CheatMenu_Rainbow_Enabled or not _G.CheatMenu_Rainbow_Enabled[0] then return end
  local playerVeh = be:getPlayerVehicle(0)
  if not playerVeh then return end

  local speed = _G.CheatMenu_Rainbow_Speed[0]
  local sat = _G.CheatMenu_Rainbow_Sat[0]
  local val = _G.CheatMenu_Rainbow_Val[0]
  local gloss = _G.CheatMenu_Rainbow_Gloss[0]
  local shift1 = _G.CheatMenu_Rainbow_ShiftLayer1[0]
  local shift2 = _G.CheatMenu_Rainbow_ShiftLayer2[0]

  _G.CheatMenu_Rainbow_CurrentHue = ((_G.CheatMenu_Rainbow_CurrentHue or 0.0) + dt * speed * 0.15) % 1.0

  local h1 = _G.CheatMenu_Rainbow_CurrentHue
  local h2 = (h1 + shift1) % 1.0
  local h3 = (h1 + shift2) % 1.0

  local r1, g1, b1 = triadHsvToRgb(h1, sat, val)
  local r2, g2, b2 = triadHsvToRgb(h2, sat, val)
  local r3, g3, b3 = triadHsvToRgb(h3, sat, val)

  playerVeh.color = Point4F(clamp01(r1), clamp01(g1), clamp01(b1), gloss)
  playerVeh.colorPalette0 = Point4F(clamp01(r2), clamp01(g2), clamp01(b2), gloss)
  playerVeh.colorPalette1 = Point4F(clamp01(r3), clamp01(g3), clamp01(b3), gloss)
end

-- Главный цикл радуги (вызывается каждый кадр)
local function updateFullRainbowMode(dt)
  if not _G.CheatMenu_Rainbow_Enabled[0] then return end
  local playerVeh = be:getPlayerVehicle(0)
  if not playerVeh then return end

  local speed = _G.CheatMenu_Rainbow_Speed[0]
  local sat = _G.CheatMenu_Rainbow_Sat[0]
  local val = _G.CheatMenu_Rainbow_Val[0]
  local gloss = _G.CheatMenu_Rainbow_Gloss[0]
  local shift1 = _G.CheatMenu_Rainbow_ShiftLayer1[0]
  local shift2 = _G.CheatMenu_Rainbow_ShiftLayer2[0]

  -- Вращаем спектр [0.0 .. 1.0] с учетом времени и скорости
  _G.CheatMenu_Rainbow_CurrentHue = (_G.CheatMenu_Rainbow_CurrentHue + dt * speed * 0.15) % 1.0

  local h1 = _G.CheatMenu_Rainbow_CurrentHue
  local h2 = (h1 + shift1) % 1.0
  local h3 = (h1 + shift2) % 1.0

  -- Конвертация HSV в RGB
  local r1, g1, b1 = triadHsvToRgb(h1, sat, val)
  local r2, g2, b2 = triadHsvToRgb(h2, sat, val)
  local r3, g3, b3 = triadHsvToRgb(h3, sat, val)

  -- Мгновенная плавная запись напрямую в видеокарту
  playerVeh.color = Point4F(clamp01(r1), clamp01(g1), clamp01(b1), gloss)
  playerVeh.colorPalette0 = Point4F(clamp01(r2), clamp01(g2), clamp01(b2), gloss)
  playerVeh.colorPalette1 = Point4F(clamp01(r3), clamp01(g3), clamp01(b3), gloss)
end

-- УНИВЕРСАЛЬНАЯ СИСТЕМА ПОКОМПОНЕНТНОЙ ПОКРАСКИ (АВТО + КАРТА И МИР)
if not _G.part_mat_defaults_map then _G.part_mat_defaults_map = {} end
if not _G.CheatMenu_PartSettings then _G.CheatMenu_PartSettings = {} end
if not _G.CheatMenu_WorldSettings then _G.CheatMenu_WorldSettings = {} end

-- Функция принудительного окрашивания ЛЮБЫХ PBR-материалов (детали машины или карты)
local function applyPartMaterialColorGE(matName, r, g, b, brightness, emissive, metallic, roughness, resetToDefault)
    local mat = scenetree.findObject(matName)
    if not mat then return end
    local matId = mat:getID()

    -- Сохраняем заводской бэкап при первом задействовании
    if not _G.part_mat_defaults_map[matId] then
        _G.part_mat_defaults_map[matId] = {
            diffuseColor = {},
            baseColorFactor = {},
            emissiveFactor = {},
            metallicFactor = {},
            roughnessFactor = {}
        }
        for stage = 0, 3 do
            _G.part_mat_defaults_map[matId].diffuseColor[stage] = mat:getField("diffuseColor", stage)
            _G.part_mat_defaults_map[matId].baseColorFactor[stage] = mat:getField("baseColorFactor", stage)
            _G.part_mat_defaults_map[matId].emissiveFactor[stage] = mat:getField("emissiveFactor", stage)
            _G.part_mat_defaults_map[matId].metallicFactor[stage] = mat:getField("metallicFactor", stage)
            _G.part_mat_defaults_map[matId].roughnessFactor[stage] = mat:getField("roughnessFactor", stage)
        end
    end

    local backup = _G.part_mat_defaults_map[matId]

    if resetToDefault then
        for stage = 0, 3 do
            if backup.diffuseColor[stage] then mat:setField("diffuseColor", stage, backup.diffuseColor[stage]) end
            if backup.baseColorFactor[stage] then mat:setField("baseColorFactor", stage, backup.baseColorFactor[stage]) end
            if backup.emissiveFactor[stage] then mat:setField("emissiveFactor", stage, backup.emissiveFactor[stage]) end
            if backup.metallicFactor[stage] then mat:setField("metallicFactor", stage, backup.metallicFactor[stage]) end
            if backup.roughnessFactor[stage] then mat:setField("roughnessFactor", stage, backup.roughnessFactor[stage]) end
        end
    else
        brightness = brightness or 1.0
        emissive = emissive or 0.0

        -- Умножение цвета (пробивает тёмный асфальт, резину и пластик)
        local colStr = string.format("%f %f %f 1", r * brightness, g * brightness, b * brightness)
        -- Внедрение свечения/оттенка (для неонового мира или некрасящихся текстур)
        local emStr = string.format("%f %f %f", r * emissive, g * emissive, b * emissive)

        for stage = 0, 3 do
            mat:setField("diffuseColor", stage, colStr)
            mat:setField("baseColorFactor", stage, colStr)
            mat:setField("emissiveFactor", stage, emStr)
            
            if metallic then mat:setField("metallicFactor", stage, tostring(metallic)) end
            if roughness then mat:setField("roughnessFactor", stage, tostring(roughness)) end
        end
    end
    mat:postApply()
end

-- Сканер материалов текущего АВТОМОБИЛЯ
local function scanAndCategorizeVehicleMaterials(modelName)
    local matNames = scenetree.findClassObjects("Material")
    if not matNames then return {} end

    local modelLower = string.lower(modelName or "")
    local categories = {
        ["Wheels & Rims"] = {},
        ["Interior & Trim"] = {},
        ["Suspension & Springs"] = {},
        ["Chassis & Subframe"] = {},
        ["Brakes & Calipers"] = {},
        ["Engine & Exhaust"] = {},
        ["Body Panels"] = {},
        ["Other Parts"] = {}
    }

    for i = 1, #matNames do
        local mName = matNames[i]
        local mLower = string.lower(mName)

        local isVehMat = (modelLower ~= "" and string.find(mLower, modelLower))
        local isGenericPart = string.find(mLower, "wheel") or string.find(mLower, "rim") or string.find(mLower, "suspension") or string.find(mLower, "interior") or string.find(mLower, "chassis") or string.find(mLower, "brake") or string.find(mLower, "engine") or string.find(mLower, "int")

        if isVehMat or isGenericPart then
            if not string.find(mLower, "glass") and not string.find(mLower, "light") and not string.find(mLower, "_on") and not string.find(mLower, "gauge") then
                if string.find(mLower, "wheel") or string.find(mLower, "rim") or string.find(mLower, "alloy") or string.find(mLower, "hubcap") or string.find(mLower, "center") then
                    table.insert(categories["Wheels & Rims"], mName)
                elseif string.find(mLower, "interior") or string.find(mLower, "int_") or string.find(mLower, "dash") or string.find(mLower, "seat") or string.find(mLower, "leather") or string.find(mLower, "plastic") or string.find(mLower, "trim") or string.find(mLower, "console") or string.find(mLower, "steering") or string.find(mLower, "carpet") then
                    table.insert(categories["Interior & Trim"], mName)
                elseif string.find(mLower, "suspension") or string.find(mLower, "arm") or string.find(mLower, "coil") or string.find(mLower, "spring") or string.find(mLower, "shock") or string.find(mLower, "strut") or string.find(mLower, "swaybar") or string.find(mLower, "link") then
                    table.insert(categories["Suspension & Springs"], mName)
                elseif string.find(mLower, "chassis") or string.find(mLower, "frame") or string.find(mLower, "subframe") or string.find(mLower, "underbody") then
                    table.insert(categories["Chassis & Subframe"], mName)
                elseif string.find(mLower, "brake") or string.find(mLower, "caliper") or string.find(mLower, "disc") then
                    table.insert(categories["Brakes & Calipers"], mName)
                elseif string.find(mLower, "engine") or string.find(mLower, "exhaust") or string.find(mLower, "intake") or string.find(mLower, "turbo") or string.find(mLower, "transmission") or string.find(mLower, "diff") or string.find(mLower, "header") then
                    table.insert(categories["Engine & Exhaust"], mName)
                elseif string.find(mLower, "body") or string.find(mLower, "door") or string.find(mLower, "hood") or string.find(mLower, "fender") or string.find(mLower, "bumper") or string.find(mLower, "tailgate") or string.find(mLower, "trunk") or string.find(mLower, "spoiler") or string.find(mLower, "panel") or string.find(mLower, "fascia") then
                    table.insert(categories["Body Panels"], mName)
                else
                    table.insert(categories["Other Parts"], mName)
                end
            end
        end
    end

    return categories
end

-- НОВЫЙ СКАНЕР: Находит и раскладывает материалы ИГРОВОЙ КАРТЫ И ОКРУЖАЮЩЕГО МИРА
local function scanAndCategorizeWorldMaterials()
    local matNames = scenetree.findClassObjects("Material")
    if not matNames then return {} end

    local playerVeh = be:getPlayerVehicle(0)
    local modelLower = playerVeh and string.lower(playerVeh.JBeam or "") or ""

    local categories = {
        ["Terrain & Roads"] = {},
        ["Vegetation & Trees"] = {},
        ["Buildings & Barriers"] = {},
        ["Props & Objects"] = {},
        ["Water & Sky"] = {},
        ["All Other Map Materials"] = {}
    }

    for i = 1, #matNames do
        local mName = matNames[i]
        local mLower = string.lower(mName)

        -- Исключаем детали машины, системный интерфейс и сетки
        local isVehMat = (modelLower ~= "" and string.find(mLower, modelLower))
        local isVehicleComponent = string.find(mLower, "suspension") or string.find(mLower, "wheel") or string.find(mLower, "brake") or string.find(mLower, "interior") or string.find(mLower, "engine")
        local isSystem = string.find(mLower, "ui") or string.find(mLower, "editor") or string.find(mLower, "debug") or string.find(mLower, "icon")

        if not isVehMat and not isVehicleComponent and not isSystem then
            -- 1. Ландшафт, дороги, асфальт, бетонки, обочины
            if string.find(mLower, "terrain") or string.find(mLower, "asphalt") or string.find(mLower, "road") or string.find(mLower, "dirt") or string.find(mLower, "rock") or string.find(mLower, "gravel") or string.find(mLower, "sand") or string.find(mLower, "mud") or string.find(mLower, "concrete") or string.find(mLower, "ground") or string.find(mLower, "path") or string.find(mLower, "curb") then
                table.insert(categories["Terrain & Roads"], mName)

            -- 2. Деревья, кусты, трава, кроны, кора
            elseif string.find(mLower, "tree") or string.find(mLower, "leaf") or string.find(mLower, "leaves") or string.find(mLower, "bark") or string.find(mLower, "bush") or string.find(mLower, "branch") or string.find(mLower, "grass") or string.find(mLower, "foliage") or string.find(mLower, "wood") or string.find(mLower, "plant") then
                table.insert(categories["Vegetation & Trees"], mName)

            -- 3. Здания, отбойники, мосты, стены, заборы
            elseif string.find(mLower, "building") or string.find(mLower, "wall") or string.find(mLower, "house") or string.find(mLower, "barrier") or string.find(mLower, "guardrail") or string.find(mLower, "fence") or string.find(mLower, "bridge") or string.find(mLower, "brick") or string.find(mLower, "structure") or string.find(mLower, "roof") then
                table.insert(categories["Buildings & Barriers"], mName)

            -- 4. Вода, реки, океаны, облака
            elseif string.find(mLower, "water") or string.find(mLower, "ocean") or string.find(mLower, "river") or string.find(mLower, "lake") or string.find(mLower, "sky") or string.find(mLower, "cloud") then
                table.insert(categories["Water & Sky"], mName)

            -- 5. Пропсы, знаки, столбы, бочки, контейнеры
            elseif string.find(mLower, "prop") or string.find(mLower, "sign") or string.find(mLower, "pole") or string.find(mLower, "lamp") or string.find(mLower, "decal") or string.find(mLower, "container") or string.find(mLower, "barrel") or string.find(mLower, "trash") then
                table.insert(categories["Props & Objects"], mName)
            else
                table.insert(categories["All Other Map Materials"], mName)
            end
        end
    end

    return categories
end




-- ИСПРАВЛЕННАЯ СВЕРХНАДЕЖНАЯ ФУНКЦИЯ МАСШТАБИРОВАНИЯ КАРТЫ И ЗЕМЛИ

local function applyMapScaleGE(sx, sy, sz, isReset)
    if not _G.map_scale_defaults then _G.map_scale_defaults = {} end

    -- Рассчитываем усредненный масштабирующий коэффициент для плоской сетки земли (X/Y)
    local scaleXY = (sx + sy) * 0.5

    -- 1. ТРАНСФОРМАЦИЯ ЛАНДШАФТА И СЕТКИ ЗЕМЛИ (TerrainBlock)
    local terrains = scenetree.findClassObjects("TerrainBlock")
    if terrains then
        for i = 1, #terrains do
            local t = scenetree.findObject(terrains[i])
            if t then
                local id = t:getID()
                
                -- Инициализация кэша дефолтных параметров
                if not _G.map_scale_defaults[id] then
                    _G.map_scale_defaults[id] = {}
                end
                
                local def = _G.map_scale_defaults[id]
                
                -- Пополевая проверка с авто-дозаполнением (защита от nil, если старый кэш висит в памяти)
                if def.squareSize == nil then
                    def.squareSize = tonumber(t:getField("squareSize", 0)) or (t.squareSize and tonumber(t.squareSize)) or 1.0
                end
                if def.maxHeight == nil then
                    def.maxHeight = tonumber(t:getField("maxHeight", 0)) or (t.maxHeight and tonumber(t.maxHeight)) or 2048.0
                end
                if def.posX == nil then
                    local pos = t:getPosition()
                    def.posX = pos.x
                    def.posY = pos.y
                    def.posZ = pos.z
                end
                
                if isReset then
                    t:setField("squareSize", 0, tostring(def.squareSize))
                    t:setField("maxHeight", 0, tostring(def.maxHeight))
                    t:setPosition(vec3(def.posX, def.posY, def.posZ))
                else
                    -- Вычисляем новые габариты ячейки земли и предел высоты
                    local newSquareSize = def.squareSize * scaleXY
                    local newMaxHeight = def.maxHeight * sz
                    
                    t:setField("squareSize", 0, tostring(newSquareSize))
                    t:setField("maxHeight", 0, tostring(newMaxHeight))
                    
                    -- Сдвигаем начальную позицию земли относительно масштабного коэффициента
                    t:setPosition(vec3(def.posX * scaleXY, def.posY * scaleXY, def.posZ * sz))
                end
                t:postApply() -- Применяем изменения к поверхности
            end
        end
    end

    -- 2. МАСШТАБИРОВАНИЕ 3D-ОБЪЕКТОВ И ЗДАНИЙ (TSStatic)
    local statics = scenetree.findClassObjects("TSStatic")
    if statics then
        for i = 1, #statics do
            local obj = scenetree.findObject(statics[i])
            if obj then
                local id = obj:getID()
                if not _G.map_scale_defaults[id] then
                    _G.map_scale_defaults[id] = {}
                end
                local def = _G.map_scale_defaults[id]
                
                if def.posX == nil or def.scaleX == nil then
                    local origPos = obj:getPosition()
                    local origScale = obj:getScale()
                    def.posX = origPos.x
                    def.posY = origPos.y
                    def.posZ = origPos.z
                    def.scaleX = origScale.x
                    def.scaleY = origScale.y
                    def.scaleZ = origScale.z
                end
                
                if isReset then
                    obj:setPosition(vec3(def.posX, def.posY, def.posZ))
                    obj:setScale(vec3(def.scaleX, def.scaleY, def.scaleZ))
                else
                    obj:setPosition(vec3(def.posX * sx, def.posY * sy, def.posZ * sz))
                    obj:setScale(vec3(def.scaleX * sx, def.scaleY * sy, def.scaleZ * sz))
                end
                obj:postApply()
            end
        end
    end

    -- 3. Обновление физических коллизий мира
    be:reloadCollision()
end




-- Функция изменения цвета и тонировки стекол (с фильтром фар, бэкапом и глухой покраской) [2]
local function applyGlassTintGE(model, r, g, b, alpha, solidPaint, resetToDefault)
    local matNames = scenetree.findClassObjects("Material")
    if not matNames then return end
    
    if not _G.glass_defaults_map then _G.glass_defaults_map = {} end
    
    local modelLower = string.lower(model or "")
    for i = 1, #matNames do
        local mName = matNames[i]
        local mNameLower = string.lower(mName)
        
        -- Находим все материалы стекол машины
        local isGlass = string.find(mNameLower, "glass") and string.find(mNameLower, modelLower)
        
        -- Умный фильтр-исключение: отсекаем фары, фонари, поворотники и приборы освещения
        local isLightLens = string.find(mNameLower, "light") 
                         or string.find(mNameLower, "lens") 
                         or string.find(mNameLower, "signal") 
                         or string.find(mNameLower, "reflect")
                         or string.find(mNameLower, "lamp")
        
        if isGlass and not isLightLens then
            local mat = scenetree.findObject(mName)
            if mat then
                local matId = mat:getID()
                
                -- Делаем снимок (бэкап) оригинальных параметров при первом вызове [2]
                if not _G.glass_defaults_map[matId] then
                    _G.glass_defaults_map[matId] = {
                        diffuseColor = {},
                        opacity = {},
                        baseColorFactor = {},
                        opacityFactor = {},
                        translucent = mat:getField("translucent", 0) or "1"
                    }
                    for stage = 0, 3 do
                        _G.glass_defaults_map[matId].diffuseColor[stage] = mat:getField("diffuseColor", stage)
                        _G.glass_defaults_map[matId].opacity[stage] = mat:getField("opacity", stage)
                        _G.glass_defaults_map[matId].baseColorFactor[stage] = mat:getField("baseColorFactor", stage)
                        _G.glass_defaults_map[matId].opacityFactor[stage] = mat:getField("opacityFactor", stage)
                    end
                end
                
                if resetToDefault then
                    -- Мгновенно возвращаем заводской бэкап [2]
                    local backup = _G.glass_defaults_map[matId]
                    if backup then
                        for stage = 0, 3 do
                            mat:setField("diffuseColor", stage, backup.diffuseColor[stage] or "1 1 1 1")
                            mat:setField("opacity", stage, backup.opacity[stage] or "1")
                            mat:setField("baseColorFactor", stage, backup.baseColorFactor[stage] or "1 1 1 1")
                            mat:setField("opacityFactor", stage, backup.opacityFactor[stage] or "1")
                        end
                        mat:setField("translucent", 0, backup.translucent or "1")
                        mat:postApply()
                    end
                else
                    -- Применяем тонировку или глухую покраску
                    local colStr = string.format("%f %f %f %f", r, g, b, alpha)
                    local colFactorStr = string.format("%f %f %f %f", r, g, b, alpha)
                    
                    for stage = 0, 3 do
                        mat:setField("diffuseColor", stage, colStr)
                        mat:setField("opacity", stage, tostring(alpha))
                        mat:setField("baseColorFactor", stage, colFactorStr)
                        mat:setField("opacityFactor", stage, tostring(alpha))
                    end
                    
                    -- Управление свойством translucency (если выключено (0) — материал становится глухим, как кузов) [2]
                    if solidPaint then
                        mat:setField("translucent", 0, "0")
                    else
                        mat:setField("translucent", 0, "1")
                    end
                    
                    mat:postApply() -- Применяем изменения графики
                end
            end
        end
    end
end








-- Функция регулирования цвета PBR-материалов свечения фар и неона на корпусе машины [2, 4]
local function adjustVehicleMaterialsGE(model, r, g, b, brightness, resetToDefault)
    local matNames = scenetree.findClassObjects("Material")
    if not matNames then return end
    
    local modelLower = string.lower(model or "")
    if not _G.light_mat_defaults_map then _G.light_mat_defaults_map = {} end
    
    for i = 1, #matNames do
        local mName = matNames[i]
        local mNameLower = string.lower(mName)
        
        local isModelMat = string.find(mNameLower, modelLower)
        local isLightMat = string.find(mNameLower, "lights") or string.find(mNameLower, "glass_on")
        local isOn = string.find(mNameLower, "_on")
        
        -- Поддерживаем также общие дополнительные фары (off_road_lights, roundlight, squarelight) из JBeam [4]
        if (isModelMat or string.find(mNameLower, "off_road") or string.find(mNameLower, "roundlight") or string.find(mNameLower, "squarelight")) and isLightMat and isOn then
            local mat = scenetree.findObject(mName)
            if mat then
                local matId = mat:getID()
                
                -- Кэшируем оригинальные параметры при первом изменении
                if not _G.light_mat_defaults_map[matId] then
                    _G.light_mat_defaults_map[matId] = {
                        emissiveFactor = mat:getField("emissiveFactor", 0) or "1 1 1",
                        baseColorFactor = mat:getField("baseColorFactor", 0) or "1 1 1 1"
                    }
                end
                
                local backup = _G.light_mat_defaults_map[matId]
                
                if resetToDefault then
                    -- Восстанавливаем оригинальные заводские значения свечения [2]
                    for stage = 0, 3 do
                        mat:setField("emissiveFactor", stage, backup.emissiveFactor)
                        mat:setField("baseColorFactor", stage, backup.baseColorFactor)
                        mat:setField("diffuseColor", stage, backup.baseColorFactor)
                    end
                    mat:postApply()
                else
                    -- Мощная PBR-эмиссия свечения (умножаем цвет на яркость для эффекта свечения) [2.1.1]
                    local emR = r * brightness * 6.0
                    local emG = g * brightness * 6.0
                    local emB = b * brightness * 6.0
                    
                    local emStr = string.format("%f %f %f", emR, emG, emB)
                    local colStr = string.format("%f %f %f 1", r, g, b)
                    
                    for stage = 0, 3 do
                        mat:setField("emissiveFactor", stage, emStr)
                        mat:setField("baseColorFactor", stage, colStr)
                        mat:setField("diffuseColor", stage, colStr)
                    end
                    mat:postApply() -- Применяем шейдеры
                end
            end
        end
    end
end

-- Вспомогательная функция безопасного извлечения RGB каналов независимо от индексации (ImGui 0 или Lua 1) [2]
local function getRGB(colorTable)
    if not colorTable then return 1.0, 1.0, 1.0 end
    -- Если это ImGui ArrayFloat (индексы начинаются с 0)
    if colorTable[0] ~= nil then
        return colorTable[0], colorTable[1], colorTable[2]
    end
    -- Если это стандартная Lua-таблица (индексы начинаются с 1)
    return colorTable[1] or 1.0, colorTable[2] or 1.0, colorTable[3] or 1.0
end

-- Функция регулирования цвета материалов свечения кузова фар и неона (PBR v1.5) [2, 4]
local function adjustVehicleMaterialsGE(model, headlightColorTable, brightness, resetToDefault)
    local matNames = scenetree.findClassObjects("Material")
    if not matNames then return end
    
    local r, g, b = getRGB(headlightColorTable) -- Безопасно извлекаем каналы R, G, B без nil-вылетов [2]
    local modelLower = string.lower(model or "")
    if not _G.light_mat_defaults_map then _G.light_mat_defaults_map = {} end
    
    for i = 1, #matNames do
        local mName = matNames[i]
        local mNameLower = string.lower(mName)
        
        local isModelMat = string.find(mNameLower, modelLower)
        local isLightMat = string.find(mNameLower, "lights") or string.find(mNameLower, "glass_on") or string.find(mNameLower, "neon") or string.find(mNameLower, "tube")
        local isOn = string.find(mNameLower, "_on") or string.find(mNameLower, "glow")
        
        -- Поддерживаем также общие дополнительные фары (off_road_lights) и неоновые трубки [4]
        if (isModelMat or string.find(mNameLower, "off_road") or string.find(mNameLower, "roundlight") or string.find(mNameLower, "squarelight") or string.find(mNameLower, "neon")) and isLightMat and isOn then
            local mat = scenetree.findObject(mName)
            if mat then
                local matId = mat:getID()
                
                -- Кэшируем оригинальные параметры при первом изменении
                if not _G.light_mat_defaults_map[matId] then
                    _G.light_mat_defaults_map[matId] = {
                        emissiveFactor = mat:getField("emissiveFactor", 0) or "1 1 1",
                        baseColorFactor = mat:getField("baseColorFactor", 0) or "1 1 1 1"
                    }
                end
                
                local backup = _G.light_mat_defaults_map[matId]
                
                if resetToDefault then
                    -- Восстанавливаем оригинальные значения
                    for stage = 0, 3 do
                        mat:setField("emissiveFactor", stage, backup.emissiveFactor)
                        mat:setField("baseColorFactor", stage, backup.baseColorFactor)
                        mat:setField("diffuseColor", stage, backup.baseColorFactor)
                    end
                    mat:postApply()
                else
                    -- Мощная PBR-эмиссия свечения (умножаем цвет на яркость для эффекта "ксенона")
                    local emR = r * brightness * 6.0
                    local emG = g * brightness * 6.0
                    local emB = b * brightness * 6.0
                    
                    local emStr = string.format("%f %f %f", emR, emG, emB)
                    local colStr = string.format("%f %f %f 1", r, g, b)
                    
                    for stage = 0, 3 do
                        mat:setField("emissiveFactor", stage, emStr)
                        mat:setField("baseColorFactor", stage, colStr)
                        mat:setField("diffuseColor", stage, colStr)
                    end
                    mat:postApply() -- Безопасно применяем PBR-свечение
                end
            end
        end
    end
end

-- Функция регулирования яркости, дальности и цвета фар и неона в реальном времени (SAFE / 3D SEARCH) [2]
local function adjustVehicleLightsGE(vehId, headlightBrightness, headlightColor, neonBrightness, neonColor, resetToDefault, modelName)
    local veh = be:getObjectByID(vehId)
    if not veh then return end
    
    local vehPos = veh:getPosition()
    if not vehPos then return end
    
    if not _G.light_defaults_map then _G.light_defaults_map = {} end
    
    -- Собираем все прожекторы и точечные лампы на всей карте через pairs
    local allLights = {}
    local spotLights = scenetree.findClassObjects("SpotLight")
    local pointLights = scenetree.findClassObjects("PointLight")
    
    if spotLights then
        for _, name in pairs(spotLights) do
            table.insert(allLights, name)
        end
    end
    if pointLights then
        for _, name in pairs(pointLights) do
            table.insert(allLights, name)
        end
    end
    
    -- Безопасно извлекаем RGB каналы фар и неона (предотвращает любые nil-вылеты!) [2]
    local hR, hG, hB = getRGB(headlightColor)
    local nR, nG, nB = getRGB(neonColor)
    
    for i = 1, #allLights do
        local childName = allLights[i]
        local child = scenetree.findObject(childName)
        
        if child then
            local childPos = child:getPosition()
            -- Безопасно приводим к vec3 для исключения конфликтов C++ типов [2]
            if childPos and vehPos:distance(vec3(childPos)) < 4.5 then
                local childId = child:getID()
                
                -- Кэшируем оригинальные параметры при первом изменении
                if not _G.light_defaults_map[childId] then
                    _G.light_defaults_map[childId] = {
                        brightness = child.brightness or 1.0,
                        range = child.range or 10.0,
                        color = child:getField("color", 0) or "1 1 1 1"
                    }
                end
                
                local backup = _G.light_defaults_map[childId]
                
                -- Исключаем любые системные прожекторы камеры или редактора для безопасности
                local intName = string.lower(child:getInternalName() or "")
                local objName = string.lower(child:getName() or "")
                local searchIn = intName .. " " .. objName
                local isSystemLight = string.find(searchIn, "camera") or string.find(searchIn, "editor") or string.find(searchIn, "debug")
                
                if not isSystemLight then
                    if resetToDefault then
                        -- Восстанавливаем оригинальные значения из бэкапа
                        child.brightness = backup.brightness
                        child.range = backup.range
                        child:setField("color", 0, backup.color)
                    else
                        -- Проверяем, неоновое это свечение или основные фары
                        local isNeon = string.find(searchIn, "neon") or string.find(searchIn, "underglow")
                        
                        if isNeon then
                            -- Тюнинг НЕОНА (свет на дорогу)
                            child.brightness = backup.brightness * neonBrightness
                            local colStr = string.format("%f %f %f 1", nR, nG, nB)
                            child:setField("color", 0, colStr)
                        else
                            -- Тюнинг ФАР (свет на дорогу с увеличением дальности)
                            child.brightness = backup.brightness * headlightBrightness
                            local colStr = string.format("%f %f %f 1", hR, hG, hB)
                            child:setField("color", 0, colStr)
                            
                            -- Дальность свечения увеличиваем пропорционально яркости
                            local rangeMult = math.min(3.0, math.max(1.0, headlightBrightness))
                            child.range = backup.range * rangeMult
                        end
                    end
                    
                    child:postApply() -- Применяем настройки
                end
            end
        end
    end
    
    -- СИНХРОННО: перекрашиваем PBR-текстуры свечения фар и неона на кузове машины! [2, 4]
    if resetToDefault then
        adjustVehicleMaterialsGE(modelName, {1, 1, 1}, 1.0, true)
        adjustVehicleMaterialsGE("neon", {0, 1, 1}, 1.0, true)
    else
        adjustVehicleMaterialsGE(modelName, headlightColor, headlightBrightness, false)
        adjustVehicleMaterialsGE("neon", neonColor, neonBrightness, false)
    end
end


-- Вспомогательная функция отправки расширенных JBeam-параметров шин в физику (БЕЗОПАСНАЯ) [2]
local function sendAdvancedTireTuning(vehId, v, vehState, paramName, value)
    vehState[paramName] = value
    _G.CheatMenu_LastWriteTimes[vehId .. "." .. paramName] = os.clock()
    
    local cmd = string.format([[
        local p = {
            radius = %f, width = %f,
            sideSpring = %f, sideDamp = %f, sideExpSpring = %f, sideExpDamp = %f, sidePre = %f, sideDeform = %f, sideStrength = %f,
            reinfSpring = %f, reinfDamp = %f, reinfPre = %f,
            treadSpring = %f, treadDamp = %f, treadPre = %f, treadDeform = %f, treadStrength = %f,
            treadReinfSpring = %f, treadReinfDamp = %f, treadReinfPre = %f,
            periSpring = %f, periDamp = %f, periPre = %f, periDeform = %f, periStrength = %f,
            periReinfSpring = %f, periReinfDamp = %f, periReinfPre = %f,
            nodeWeight = %f, friction = %f, sliding = %f
        }
        applyAdvancedTireTuning(p)
    ]], 
    vehState.tireRadiusMult or 1.0, vehState.tireWidthMult or 1.0,
    vehState.tireSideSpring or 1.0, vehState.tireSideDamp or 1.0, vehState.tireSideExpSpring or 1.0, vehState.tireSideExpDamp or 1.0, vehState.tireSidePre or 1.0, vehState.tireSideDeform or 1.0, vehState.tireSideStrength or 1.0,
    vehState.tireReinfSpring or 1.0, vehState.tireReinfDamp or 1.0, vehState.tireReinfPre or 1.0,
    vehState.tireTreadSpring or 1.0, vehState.tireTreadDamp or 1.0, vehState.tireTreadPre or 1.0, vehState.tireTreadDeform or 1.0, vehState.tireTreadStrength or 1.0,
    vehState.tireTreadReinfSpring or 1.0, vehState.tireTreadReinfDamp or 1.0, vehState.tireTreadReinfPre or 1.0,
    vehState.tirePeriSpring or 1.0, vehState.tirePeriDamp or 1.0, vehState.tirePeriPre or 1.0, vehState.tirePeriDeform or 1.0, vehState.tirePeriStrength or 1.0,
    vehState.tirePeriReinfSpring or 1.0, vehState.tirePeriReinfDamp or 1.0, vehState.tirePeriReinfPre or 1.0,
    vehState.tireNodeWeight or 1.0, vehState.tireFriction or 1.0, vehState.tireSliding or 1.0)
    
    v:queueLuaCommand(cmd)
end



-- НАСТРОЙКИ И МАТЕМАТИКА ПЛАВНОЙ ПРОЦЕДУРНОЙ ПОКРАСКИ (TRIAD HSV GENERATOR)

if _G.CheatMenu_AutoPaint_Enabled == nil then _G.CheatMenu_AutoPaint_Enabled = im.BoolPtr(false) end
if _G.CheatMenu_AutoPaint_Speed == nil then _G.CheatMenu_AutoPaint_Speed = im.FloatPtr(1.0) end      -- Частота смены целей (сек)
if _G.CheatMenu_AutoPaint_Smoothness == nil then _G.CheatMenu_AutoPaint_Smoothness = im.FloatPtr(3.0) end-- Плавность переливания (скорость сглаживания)
if _G.CheatMenu_AutoPaint_ModeIdx == nil then _G.CheatMenu_AutoPaint_ModeIdx = 0 end                 -- 0: vivid, 1: pastel, 2: any
if _G.CheatMenu_AutoPaint_ChromeMin == nil then _G.CheatMenu_AutoPaint_ChromeMin = im.FloatPtr(1.0) end
if _G.CheatMenu_AutoPaint_ChromeMax == nil then _G.CheatMenu_AutoPaint_ChromeMax = im.FloatPtr(1.6) end
if _G.CheatMenu_AutoPaint_MinHueGap == nil then _G.CheatMenu_AutoPaint_MinHueGap = im.FloatPtr(0.15) end

-- Хранилище текущих и целевых цветов для плавного перехода
_G.CheatMenu_PaintState = nil

local function clamp01(x) return (x < 0 and 0) or (x > 1 and 1) or x end
local function randf(a, b) return a + (b - a) * math.random() end

local function triadHsvToRgb(h, s, v)
  h = (h % 1) * 6
  local c = v * s
  local x = c * (1 - math.abs((h % 2) - 1))
  local m = v - c
  local r, g, b
  local i = math.floor(h)
  if i == 0 then r, g, b = c, x, 0
  elseif i == 1 then r, g, b = x, c, 0
  elseif i == 2 then r, g, b = 0, c, x
  elseif i == 3 then r, g, b = 0, x, c
  elseif i == 4 then r, g, b = x, 0, c
  else r, g, b = c, 0, x end
  return r + m, g + m, b + m
end

local function pickSV(mode)
  if mode == 'vivid' then
    return randf(0.80, 1.00), randf(0.85, 1.00)
  elseif mode == 'pastel' then
    return randf(0.30, 0.55), randf(0.90, 1.00)
  else
    return randf(0.10, 1.00), randf(0.60, 1.00)
  end
end

local function pickHueDifferent(baseHue, minGap)
  for _ = 1, 12 do
    local h = math.random()
    local d = math.min(math.abs(h - baseHue), 1 - math.abs(h - baseHue))
    if d >= minGap then return h end
  end
  return (baseHue + minGap) % 1
end

local function generateTriadColors()
  local modes = {'vivid', 'pastel', 'any'}
  local mode = modes[(_G.CheatMenu_AutoPaint_ModeIdx or 0) + 1] or 'vivid'
  local cMin = _G.CheatMenu_AutoPaint_ChromeMin[0]
  local cMax = _G.CheatMenu_AutoPaint_ChromeMax[0]
  local minGap = _G.CheatMenu_AutoPaint_MinHueGap[0]

  local h1 = math.random()
  local s1, v1 = pickSV(mode)
  local r1, g1, b1 = triadHsvToRgb(h1, s1, v1)
  local w1 = randf(cMin, cMax)

  local h2 = pickHueDifferent(h1, minGap)
  local s2, v2 = pickSV(mode)
  local r2, g2, b2 = triadHsvToRgb(h2, s2, v2)
  local w2 = randf(cMin, cMax)

  local h3 = pickHueDifferent((h1 + 0.33) % 1, minGap)
  local s3, v3 = pickSV(mode)
  local r3, g3, b3 = triadHsvToRgb(h3, s3, v3)
  local w3 = randf(cMin, cMax)

  return Point4F(clamp01(r1), clamp01(g1), clamp01(b1), w1),
         Point4F(clamp01(r2), clamp01(g2), clamp01(b2), w2),
         Point4F(clamp01(r3), clamp01(g3), clamp01(b3), w3)
end

-- Линейная интерполяция (LERP) между компонентами цвета Point4F
local function lerpPoint4F(cur, target, factor)
  if not cur then return target end
  if not target then return cur end
  return Point4F(
    cur.x + (target.x - cur.x) * factor,
    cur.y + (target.y - cur.y) * factor,
    cur.z + (target.z - cur.z) * factor,
    cur.w + (target.w - cur.w) * factor
  )
end

-- Функция обновления плавного перелива в реальном времени
local function updateSmoothTriadPaint(dt)
  if not _G.CheatMenu_AutoPaint_Enabled[0] then return end
  local playerVeh = be:getPlayerVehicle(0)
  if not playerVeh then return end

  local changeInterval = 1.0 / math.max(0.1, _G.CheatMenu_AutoPaint_Speed[0])
  local smoothFactor = math.min(1.0, dt * _G.CheatMenu_AutoPaint_Smoothness[0])

  if not _G.CheatMenu_PaintState then
    _G.CheatMenu_PaintState = {
      currP = playerVeh.color or Point4F(1,1,1,1),
      currS = playerVeh.colorPalette0 or Point4F(1,1,1,1),
      currT = playerVeh.colorPalette1 or Point4F(1,1,1,1),
      targetP = nil, targetS = nil, targetT = nil,
      timer = 999
    }
  end

  local ps = _G.CheatMenu_PaintState
  ps.timer = ps.timer + dt

  -- Если пора выбрать новые гармоничные цвета
  if ps.timer >= changeInterval or not ps.targetP then
    ps.timer = 0
    local p, s, t = generateTriadColors()
    ps.targetP, ps.targetS, ps.targetT = p, s, t
  end

  -- Плавная интерполяция (LERP) кадр за кадром
  ps.currP = lerpPoint4F(ps.currP, ps.targetP, smoothFactor)
  ps.currS = lerpPoint4F(ps.currS, ps.targetS, smoothFactor)
  ps.currT = lerpPoint4F(ps.currT, ps.targetT, smoothFactor)

  -- Мгновенная запись в материалы авто без лагов
  playerVeh.color = ps.currP
  playerVeh.colorPalette0 = ps.currS
  playerVeh.colorPalette1 = ps.currT
end

function M.onUpdate(dtReal, dtSim, dtRaw)
    
    
    -- АВТОМАТИЧЕСКОЕ СНЯТИЕ С ПАУЗЫ ПОСЛЕ ИЗМЕНЕНИЯ РАЗМЕРОВ
    
    if _G.CheatMenu_PendingUnpause then
        _G.CheatMenu_UnpauseFrameCount = (_G.CheatMenu_UnpauseFrameCount or 0) - 1
        if _G.CheatMenu_UnpauseFrameCount <= 0 then
            _G.CheatMenu_PendingUnpause = false
            if bullettime and bullettime.pause then
                bullettime.pause(false)
            end
        end
    end
    
    
    -- АВТОМАТИЧЕСКИЙ ВОЗВРАТ КАМЕРЫ ПРИ СРЫВЕ КООРДИНАТ (CAMERA RECOVERY)
    local playerVeh = be:getPlayerVehicle(0)
    if playerVeh and core_camera and type(core_camera.getPosition) == "function" then
        local camPos = core_camera.getPosition()
        local vehPos = playerVeh:getPosition()
        
        if camPos and vehPos then
            local dist = camPos:distance(vehPos)
            -- Если камера улетела дальше 2000м или её координаты сломались (NaN)
            if dist > 2000 or dist ~= dist then
                if type(core_camera.setVehicle) == "function" then
                    core_camera.setVehicle(playerVeh)
                end
                if type(core_camera.resetCamera) == "function" then
                    core_camera.resetCamera(0)
                end
            end
        end
    end
    
    if not open[0] then return end

    -- Обсчет физики виртуального песка (гравитация и толкание колесами)
    updateVirtualSandPhysics(dtSim)
    -- Полноценный радужный режим
    updateFullRainbowMode(dtSim)

    -- Плавная трехцветная автопокраска
    updateSmoothTriadPaint(dtSim)
    
    -- Запускаем фикс безопасности один раз при старте обновления интерфейса
    if not _G.CheatMenu_CrashFixApplied then
        applyCareerCrashFix()
        _G.CheatMenu_CrashFixApplied = true
    end

    -- Сворачиваем окно, ТОЛЬКО если галочка "Не сворачивать" НЕ стоит
    if not _G.CheatMenu_DisableCollapse[0] and _G.CheatMenu_NeedsCollapseTrigger then
        im.SetNextWindowCollapsed(true, im.Cond_Always)
        _G.CheatMenu_NeedsCollapseTrigger = false
    elseif _G.CheatMenu_DisableCollapse[0] then
        _G.CheatMenu_NeedsCollapseTrigger = false
    end
    
    local windowFlags = im.WindowFlags_NoDocking

    local v = be:getPlayerVehicle(0)
    if not v then
        pushThemeColors(_G.CheatMenu_GuiStyleIdx)
        im.SetNextWindowSizeConstraints(im.ImVec2(300, 150), im.ImVec2(1920, 1080))
        im.Begin("Radial Cheat Menu (imGUI) by Sasha ir (YT)", open, windowFlags)
        im.Text("Please enter a vehicle to initialize.")
        im.End()
        popThemeColors()
        return
    end
    
    pushThemeColors(_G.CheatMenu_GuiStyleIdx)
    im.SetNextWindowSizeConstraints(im.ImVec2(400, 300), im.ImVec2(1920, 1080))
    im.Begin("Radial Cheat Menu (imGUI) by Sasha ir (YT)", open, windowFlags)



    


    
    
    local vehId = v:getID()
    local vehState = _G.CheatMenuWindow_Data.vehicleStates[vehId]
    if not vehState then
        im.Text("Waiting for vehicle connection...")
        im.Text("Ensure that your active vehicle has spawned and the extension is loaded.")
        if im.Button("Force Reinitialize Connection") then
            v:queueLuaCommand([[
              if CheatMenuM then
                if CheatMenuM.onVehicleLoaded then CheatMenuM.onVehicleLoaded() end
                if CheatMenuM.pushMinimalGeConnection then CheatMenuM.pushMinimalGeConnection() end
                if CheatMenuM.syncVehicleStateToGe then pcall(CheatMenuM.syncVehicleStateToGe) end
              end
            ]])
        end
        im.End()
        popThemeColors() -- Снимаем кастомные цвета при раннем закрытии
        return
    end

    -- Безопасная инициализация таблиц электроники
    if not _G.CheatMenuWindow_Data.electrics then
        _G.CheatMenuWindow_Data.electrics = {}
    end
    if not _G.CheatMenuWindow_Data.electrics_defaults then
        _G.CheatMenuWindow_Data.electrics_defaults = {}
    end
    if vehId and not _G.CheatMenuWindow_Data.electrics_defaults[vehId] then
        _G.CheatMenuWindow_Data.electrics_defaults[vehId] = {}
    end

    -- Принудительная санитация глобальных переменных (тип cdata/userdata)
    if type(_G.CheatMenu_OBD_Port) ~= "cdata" and type(_G.CheatMenu_OBD_Port) ~= "userdata" then
        _G.CheatMenu_OBD_Port = im.ArrayChar(16)
        ffi.copy(_G.CheatMenu_OBD_Port, "com12")
    end

    if type(_G.CheatMenu_ElectricsFilter) ~= "cdata" and type(_G.CheatMenu_ElectricsFilter) ~= "userdata" then
        _G.CheatMenu_ElectricsFilter = im.ArrayChar(64)
    end

    -- Синхронизация значений указателей ImGui с полученным состоянием VL
    for k, val in pairs(vehState) do
        if type(val) == "number" then
            getPtr(vehId, k, val, "FloatPtr")[0] = val
        elseif type(val) == "boolean" then
            getPtr(vehId, k, val, "BoolPtr")[0] = val
        end
    end

    -- Вспомогательные функции отправки команд
    local function sendVar(varName, val, applyFunc)
        vehState[varName] = val
        local cmd
        if applyFunc then
            cmd = string.format("CheatMenuM.state.%s = %s; CheatMenuM.%s()", varName, tostring(val), applyFunc)
        else
            cmd = string.format("CheatMenuM.state.%s = %s", varName, tostring(val))
        end
        v:queueLuaCommand(cmd)
    end

    local function sendElec(varName, val)
        v:queueLuaCommand(string.format("electrics.values['%s'] = %s; beamLFin = false; beamWFin = false", varName, tostring(val)))
    end


    -- Инициализация таймеров троттлинга цвета дыма
    if _G.CheatMenu_Smoke_LastSendTime == nil then _G.CheatMenu_Smoke_LastSendTime = 0 end
    if _G.CheatMenu_Smoke_ColorDirty == nil then _G.CheatMenu_Smoke_ColorDirty = false end
    
    -- Ограничитель отправки цвета: отправляет изменения в игру не чаще 1 раза в секунду
    if _G.CheatMenu_Smoke_ColorDirty then
        local now = os.clock()
        if (now - _G.CheatMenu_Smoke_LastSendTime) >= 1.0 then
            _G.CheatMenu_Smoke_LastSendTime = now
            _G.CheatMenu_Smoke_ColorDirty = false
            applyTireSmokeSettings(v, false) -- Мягкое обновление цвета без мерцания дыма
        end
    end

    -- Инициализируем хранилище бэкапа оригинальных настроек дыма карты
    if _G.CheatMenu_Smoke_Defaults == nil then
        _G.CheatMenu_Smoke_Defaults = {}
    end

    -- Внутренняя функция создания резервной копии заводских параметров
    local function backupSmokeDefaults()
        local emitters = {
            "BNGP_6", "BNGP_22", -- Асфальт
            "BNGP_7", "BNGP_23", -- Бетон
            "BNGP_8", "BNGP_9", "BNGP_10", "BNGP_11", "BNGP_12" -- Гравий, трава, грязь, песок
        }
        for _, name in ipairs(emitters) do
            local emitter = scenetree.findObject(name)
            -- Создаем бэкап только один раз, пока данные чистые и не измененные читом
            if emitter and not _G.CheatMenu_Smoke_Defaults[name] then
                local defaults = {
                    ejectionPeriodMS = emitter.ejectionPeriodMS or 30
                }
                local pName = emitter.particles
                local pData = scenetree.findObject(pName)
                if pData then
                    defaults.colors0 = pData:getField("colors0", "")
                    defaults.colors1 = pData:getField("colors1", "")
                    defaults.colors2 = pData:getField("colors2", "")
                    defaults.sizes0 = pData:getField("sizes0", "")
                    defaults.sizes1 = pData:getField("sizes1", "")
                    defaults.sizes2 = pData:getField("sizes2", "")
                    defaults.lifetimeMS = pData.lifetimeMS or 1500
                end
                _G.CheatMenu_Smoke_Defaults[name] = defaults
            end
        end
    end

    function applyTireSmokeSettings(v, forceReset)
        local r = _G.CheatMenu_Smoke_Color[0]
        local g = _G.CheatMenu_Smoke_Color[1]
        local b = _G.CheatMenu_Smoke_Color[2]
        local density = _G.CheatMenu_Smoke_Density[0]
        local size = _G.CheatMenu_Smoke_Size[0]
        local lifetime = _G.CheatMenu_Smoke_Lifetime[0]
        local enabled = _G.CheatMenu_Smoke_Enabled[0]
        
        -- Все типы эмиттеров под колесами (асфальт, бетон, гравий, трава, грязь, песок)
        local emitters = {
            "BNGP_6", "BNGP_22", -- Асфальт
            "BNGP_7", "BNGP_23", -- Бетон
            "BNGP_8", "BNGP_9", "BNGP_10", "BNGP_11", "BNGP_12"
        }
        
        for _, name in ipairs(emitters) do
            local emitter = scenetree.findObject(name)
            if emitter then
                if enabled then
                    local basePeriod = 30
                    emitter.ejectionPeriodMS = math.max(1, math.floor(basePeriod / density))
                else
                    -- Возвращаем оригинальную заводскую плотность (около 100), чтобы дым не был завышен
                    emitter.ejectionPeriodMS = 100 
                end
                emitter:postApply()
                
                local pName = emitter.particles
                local pData = scenetree.findObject(pName)
                if pData then
                    if enabled then
                        local colStr = string.format("%f %f %f 1", r, g, b)
                        pData:setField("colors", 0, colStr)
                        pData:setField("colors", 1, colStr)
                        pData:setField("colors", 2, string.format("%f %f %f 0", r, g, b))
                        
                        local baseSize0, baseSize1, baseSize2 = 1.5, 3.5, 6.0
                        pData:setField("sizes", 0, tostring(baseSize0 * size))
                        pData:setField("sizes", 1, tostring(baseSize1 * size))
                        pData:setField("sizes", 2, tostring(baseSize2 * size))
                        
                        local baseLifetime = 1500
                        pData.lifetimeMS = math.floor(baseLifetime * lifetime)
                    else
                        -- Возвращаем штатные заводские параметры дыма
                        pData:setField("colors", 0, "1 1 1 1")
                        pData:setField("colors", 1, "1 1 1 1")
                        pData:setField("colors", 2, "1 1 1 0")
                        pData:setField("sizes", 0, "1.5")
                        pData:setField("sizes", 1, "3.5")
                        pData:setField("sizes", 2, "6.0")
                        pData.lifetimeMS = 1500
                    end
                    pData:postApply()
                end
                
                -- Выполняем жесткий сброс эмиттера ТОЛЬКО при инициализации или изменении размера/времени жизни.
                if forceReset then
                    emitter.overrideNoParticles = true
                    emitter:postApply()
                    emitter.overrideNoParticles = false
                    emitter:postApply()
                end
            end
        end
        
        if _G.CheatMenu_Smoke_EasyBurnout[0] and enabled then
            v:queueLuaCommand("CheatMenuM.state.gripMultiplier = 0.15; CheatMenuM.applyGripMultiplier(0.15)")
        else
            v:queueLuaCommand("CheatMenuM.state.gripMultiplier = 1.0; CheatMenuM.applyGripMultiplier(1.0)")
        end
    end









    

    -- Универсальный слайдер с логарифмической шкалой
    local function renderSliderWithReset(label, varName, minVal, maxVal, defaultVal, applyFunc, format, passValue)
        local ptr = getPtr(vehId, varName, vehState[varName] or defaultVal, "FloatPtr")
        
        -- 1. Кнопка Reset
        if im.Button("RES##" .. varName, im.ImVec2(30, 0)) then
            ptr[0] = defaultVal
            if passValue then
                v:queueLuaCommand(string.format("CheatMenuM.%s(%f)", applyFunc, defaultVal))
            else
                sendVar(varName, defaultVal, applyFunc)
            end
        end
        im.SameLine()
        
        -- 2. Слайдер с логарифмическим флагом
        im.SetNextItemWidth(-1)
        -- im.SliderFlags_Logarithmic делает шкалу удобной для множителей
        local changed = im.SliderFloat("##" .. varName, ptr, minVal, maxVal, label .. ": " .. (format or "%.2f"), im.SliderFlags_Logarithmic)
        
        -- Добавляем подсказку при наведении
        if im.IsItemHovered() then
            im.SetTooltip("Ctrl + Click to type a specific value")
        end
        
        if changed then
            if passValue then
                v:queueLuaCommand(string.format("CheatMenuM.%s(%f)", applyFunc, ptr[0]))
            else
                sendVar(varName, ptr[0], applyFunc)
            end
        end
    end

    -- Целочисленный слайдер с кнопкой сброса (RES) слева
    local function renderSliderIntWithReset(label, varName, minVal, maxVal, defaultVal, sendFunc)
        local ptr = getPtr(vehId, varName, vehState[varName] or defaultVal, "IntPtr")
        
        -- 1. Кнопка Reset
        if im.Button("RES##" .. varName, im.ImVec2(30, 0)) then
            ptr[0] = defaultVal
            sendFunc(varName, defaultVal)
        end
        im.SameLine()
        
        -- 2. Слайдер
        im.SetNextItemWidth(-1)
        local changed = im.SliderInt("##" .. varName, ptr, minVal, maxVal, label .. ": %d")
        
        if im.IsItemHovered() then
            im.SetTooltip("Ctrl + Click to type a specific value")
        end

        if changed then
            sendFunc(varName, ptr[0])
        end
    end
    -- Целочисленный слайдер аналогично (БЕЗ PushID)
    -- Целочисленный слайдер (для размеров колес используем обычный, т.к. логарифм для целых чисел работает иначе)
    local function renderSliderIntWithResetTraffic(label, varName, minVal, maxVal, defaultVal, sendFunc)
        local ptr = getPtr(vehId, varName, vehState[varName] or defaultVal, "IntPtr")
                
        im.SetNextItemWidth(-1)
        local changed = im.SliderInt("##" .. varName, ptr, minVal, maxVal, label .. ": %d")
        
        if im.IsItemHovered() then
            im.SetTooltip("Ctrl + Click to type a specific value")
        end

        if changed then
            sendFunc(varName, ptr[0])
        end
    end

        
        -- ОТДЕЛЬНЫЙ ЦИКЛ СКАНИРОВАНИЯ И КЭШИРОВАНИЯ ХАРАКТЕРИСТИК АВТОМОБИЛЕЙ
        
        if _G.CheatMenu_SpecsTimer == nil then 
            _G.CheatMenu_SpecsTimer = 0 
        end
        _G.CheatMenu_SpecsTimer = _G.CheatMenu_SpecsTimer + 1
        
        local specsVehicles = getAllVehiclesByType()
        local activePlayerId = be:getPlayerVehicleID(0)
        
        for _, targetVeh in ipairs(specsVehicles) do
            local tId = targetVeh:getID()
            local isPlayer = (tId == activePlayerId)
            
            if not _G.CheatMenu_VehSpecs then 
                _G.CheatMenu_VehSpecs = {} 
            end
            
            -- Логика опроса: сканируем один раз при спавне, а для игрока — дополнительно каждые 8 кадров для real-time обновления
            local needScan = not _G.CheatMenu_VehSpecs[tId] or _G.CheatMenu_VehSpecs[tId] == "PENDING"
            if isPlayer and (_G.CheatMenu_SpecsTimer % 8 == 0) then
                needScan = true
            end

            -- Опрос всех доступных параметров electrics.values автомобиля каждые 8 кадров
            if _G.CheatMenu_SpecsTimer % 8 == 0 then
                v:queueLuaCommand(string.format([[
                    local elecData = {}
                    if electrics and electrics.values then
                        for k, v in pairs(electrics.values) do
                            local t = type(v)
                            -- Передаем только те типы данных, которые можно сериализовать
                            if t == "number" or t == "boolean" or t == "string" then
                                elecData[k] = v
                            end
                        end
                    end
                    obj:queueGameEngineLua("_G.CheatMenuWindow_Data.electrics[" .. %d .. "] = " .. serialize(elecData))
                ]], vehId))
            end
            
            if needScan then
                if not _G.CheatMenu_VehSpecs[tId] then
                    _G.CheatMenu_VehSpecs[tId] = "PENDING" -- Временный флаг ожидания данных
                end
                
                targetVeh:queueLuaCommand(string.format([[
                    -- 1. Вычисляем точные габариты AABB (длина, ширина, высота) кузова в метрах
                    local minX, maxX = 10000, -10000
                    local minY, maxY = 10000, -10000
                    local minZ, maxZ = 10000, -10000
                    if v.data and v.data.nodes then
                        for i = 0, tableSizeC(v.data.nodes) - 1 do
                            local pos = v.data.nodes[i].pos
                            if pos.x < minX then minX = pos.x end
                            if pos.x > maxX then maxX = pos.x end
                            if pos.y < minY then minY = pos.y end
                            if pos.y > maxY then maxY = pos.y end
                            if pos.z < minZ then minZ = pos.z end
                            if pos.z > maxZ then maxZ = pos.z end
                        end
                    end
                    local width = maxX - minX
                    local length = maxY - minY
                    local height = maxZ - minZ

                    -- 2. Вес и пиковые характеристики двигателя
                    local stats = obj:calcBeamStats()
                    local weight = math.ceil(stats.total_weight)
                    
                    local maxPower, maxTorque = 0, 0
                    local maxPowerRPM, maxTorqueRPM = 0, 0
                    local engines = powertrain.getDevicesByCategory("engine")
                    if engines and #engines > 0 then
                        local tData = engines[1]:getTorqueData()
                        if tData then
                            maxPower = math.floor(tData.maxPower or 0)
                            maxTorque = math.floor(tData.maxTorque or 0)
                            maxPowerRPM = math.floor(tData.maxPowerRPM or 0)
                            maxTorqueRPM = math.floor(tData.maxTorqueRPM or 0)
                        end
                    end

                    -- 3. Вычисление типа двигателя, наддува и топлива
                    local motorType = "Other"
                    if engines and #engines > 0 then
                        local hasICE, hasEV = false, false
                        for _, ve in pairs(engines) do
                            if ve.type == "combustionEngine" then hasICE = true
                            elseif ve.type == "electricMotor" or ve.type == "seriesElectricMotor" or ve.type == "electricMotorPMDC" then hasEV = true end
                        end
                        if hasICE and hasEV then motorType = "Hybrid"
                        elseif hasICE then motorType = "ICE"
                        elseif hasEV then motorType = "Electric" end
                    end

                    local indType = "NA"
                    if engines then
                        local hasTurbo, hasSC, hasN2O = false, false, false
                        for _, ve in pairs(engines) do
                            if ve.turbocharger and ve.turbocharger.isExisting then hasTurbo = true end
                            if ve.supercharger and ve.supercharger.isExisting then hasSC = true end
                            if ve.nitrousOxideInjection and ve.nitrousOxideInjection.isExisting then hasN2O = true end
                        end
                        if hasTurbo and hasSC and hasN2O then indType = "Turbo + SC + N2O"
                        elseif hasTurbo and hasSC then indType = "Turbo + SC"
                        elseif hasTurbo then indType = "Turbo"
                        elseif hasSC then indType = "SC" end
                    end

                    local fuelType = "Other"
                    local hasGas, hasDiesel, hasBattery = false, false, false
                    for _, ve in pairs(energyStorage.getStorages()) do
                        if ve.type == "fuelTank" then
                            if ve.energyType == "gasoline" then hasGas = true
                            elseif ve.energyType == "diesel" then hasDiesel = true end
                        elseif ve.type == "electricBattery" then hasBattery = true end
                    end
                    if hasGas or hasDiesel then
                        if hasBattery then fuelType = "Hybrid" else fuelType = hasGas and "Gasoline" or "Diesel" end
                    elseif hasBattery then fuelType = "Battery" end

                    -- 4. Определение типа трансмиссии
                    local transType = "Other"
                    local hasAuto, hasCVT, hasDCT, hasManual, hasSeq = false, false, false, false, false
                    for _, ve in pairs(powertrain.getDevicesByCategory("gearbox")) do
                        if ve.type == "automaticGearbox" then hasAuto = true
                        elseif ve.type == "cvtGearbox" then hasCVT = true
                        elseif ve.type == "dctGearbox" then hasDCT = true
                        elseif ve.type == "manualGearbox" then hasManual = true
                        elseif ve.type == "sequentialGearbox" then hasSeq = true end
                    end
                    if hasAuto then transType = "Auto"
                    elseif hasCVT then transType = "CVT"
                    elseif hasDCT then transType = "DCT"
                    elseif hasManual then transType = "Manual"
                    elseif hasSeq then transType = "Seq" end

                    -- 5. Извлечение типа привода (Drivetrain Layout)
                    local layout = "Other"
                    local propulsedWheelsCount = 0
                    local wheelCount = 0
                    local adjustedWheels = {}
                    if wheels and wheels.wheels then
                        for k, wd in pairs(wheels.wheels) do
                            adjustedWheels[wd.wheelID] = wd
                        end
                        local diffs = powertrain.getDevicesByCategory("differential")
                        for _, diff in ipairs(diffs) do
                            if diff.mode == "dually" then
                                local cw1 = powertrain.getChildWheels(diff, 1)
                                local cw2 = powertrain.getChildWheels(diff, 2)
                                if #cw1 == 1 and #cw2 == 1 then adjustedWheels[cw1[1].wheelID] = nil end
                            end
                        end
                        for _, wd in pairs(adjustedWheels) do
                            wheelCount = wheelCount + 1
                            if wd.isPropulsed then propulsedWheelsCount = propulsedWheelsCount + 1 end
                        end
                        if wheelCount <= 4 and wheelCount > 1 then
                            local propulsedWheelLocations = {fr = 0, fl = 0, rr = 0, rl = 0}
                            local vectorForward = vec3(v.data.nodes[v.data.refNodes[0].ref].pos) - vec3(v.data.nodes[v.data.refNodes[0].back].pos)
                            local vectorUp = vec3(v.data.nodes[v.data.refNodes[0].up].pos) - vec3(v.data.nodes[v.data.refNodes[0].ref].pos)
                            local vectorRight = vectorForward:cross(vectorUp)
                            for _, wd in pairs(adjustedWheels) do
                                if wd.isPropulsed then
                                    local wheelNodePos = vec3(v.data.nodes[wd.node1].pos)
                                    local wheelVector = wheelNodePos - (obj:getPosition() - vec3(v.data.nodes[v.data.refNodes[0].ref].pos))
                                    local dotForward = vectorForward:dot(wheelVector)
                                    local dotLeft = vectorRight:dot(wheelVector)
                                    if dotForward >= 0 then
                                        if dotLeft >= 0 then propulsedWheelLocations.fr = propulsedWheelLocations.fr + 1 else propulsedWheelLocations.fl = propulsedWheelLocations.fl + 1 end
                                    else
                                        if dotLeft >= 0 then propulsedWheelLocations.rr = propulsedWheelLocations.rr + 1 else propulsedWheelLocations.rl = propulsedWheelLocations.rl + 1 end
                                    end
                                end
                            end
                            local diffCount = #powertrain.getDevicesByCategory("differential")
                            if diffCount == 0 or diffCount == 1 then
                                if propulsedWheelLocations.fr > 0 or propulsedWheelLocations.fl > 0 then layout = "FWD"
                                elseif propulsedWheelLocations.rr > 0 or propulsedWheelLocations.rl > 0 then layout = "RWD" end
                            elseif diffCount == 3 then
                                if propulsedWheelLocations.fr > 0 and propulsedWheelLocations.fl > 0 and propulsedWheelLocations.rr > 0 and propulsedWheelLocations.rl > 0 then
                                    layout = "AWD"
                                end
                            end
                        end
                        if layout == "Other" and propulsedWheelsCount > 0 then
                            layout = wheelCount .. "x" .. propulsedWheelsCount
                        end
                    end

                    -- 6. Расчет развесовки по осям (перед/зад)
                    local totalMass = 0
                    local weightedY = 0
                    local numNodes = tableSizeC(v.data.nodes)
                    for i = 0, numNodes - 1 do
                        local n = v.data.nodes[i]
                        local m = n.nodeWeight or 1
                        weightedY = weightedY + n.pos.y * m
                        totalMass = totalMass + m
                    end
                    local cogY = weightedY / totalMass
                    
                    local frontMass = 0
                    for i = 0, numNodes - 1 do
                        local n = v.data.nodes[i]
                        local m = n.nodeWeight or 1
                        if n.pos.y > cogY then frontMass = frontMass + m end
                    end
                    local frontPercent = math.floor((frontMass / totalMass) * 100)
                    local rearPercent = 100 - frontPercent

                    -- 7. [ИСПРАВЛЕНО] Двухфазное вычисление объема ДВС, холостого хода, красной зоны
                    local displacement = 0
                    local outputRPM = 0
                    local maxRPM = 0
                    if engines and #engines > 0 then
                        local eng = engines[1]
                        
                        -- Метод А: Пытаемся считать физическую переменную объема
                        local rawDisp = eng.displacement or (eng.jbeamData and (eng.jbeamData.engineDisplacement or eng.jbeamData.displacement)) or 0
                        local num = tonumber(string.match(tostring(rawDisp), "[%%d%%.]+")) or 0
                        
                        if num > 0 then
                            if num < 0.05 then
                                displacement = num * 1000 -- куб.м в литры (0.0032 -> 3.2L)
                            elseif num > 25.0 then
                                displacement = num / 1000 -- куб.см в литры (3200 -> 3.2L)
                            else
                                displacement = num -- литры
                            end
                        end
                        
                        -- Метод Б (Резервный): Парсим системный ключ JBeam активной детали двигателя (например, "bolide_engine_3.2_v8")
                        if displacement <= 0.05 and v.data and v.data.activeParts then
                            for slot, partName in pairs(v.data.activeParts) do
                                if string.find(slot, "engine") or string.find(partName, "engine") then
                                    -- Ищем десятичную дробь в имени детали (например, "3.2" из "bolide_engine_3.2_v8")
                                    local numStr = string.match(partName, "_(%%d+%%.%%d+)") or string.match(partName, "(%%d+%%.%%d+)")
                                    if not numStr then
                                        -- Если дроби нет, ищем одиночную цифру литража (например, "_5" из "pickup_engine_v8_5")
                                        numStr = string.match(partName, "_(%%d+)")
                                    end
                                    local parsedNum = tonumber(numStr)
                                    if parsedNum and parsedNum > 0.1 and parsedNum < 25.0 then
                                        displacement = parsedNum
                                        break
                                    end
                                end
                            end
                        end
                        
                        displacement = math.floor(displacement * 10 + 0.5) / 10
                        
                        outputRPM = math.floor(eng.outputRPM or 0)
                        maxRPM = math.floor(eng.maxRPM or 0)
                    end

                    -- 8. Определение материала тормозных колодок
                    local brakeType = "Standard"
                    if v.data and v.data.activeParts then
                        for partName, _ in pairs(v.data.activeParts) do
                            if string.find(partName, "ceramic") then brakeType = "Carbon-Ceramic"
                            elseif string.find(partName, "race") then brakeType = "Race"
                            elseif string.find(partName, "sport") then brakeType = "Sport"
                            elseif string.find(partName, "heavy") then brakeType = "Heavy Duty" end
                        end
                    end

                    -- 9. Аэродинамическое сопротивление Cd
                    local cd = 0.32
                    if v.data and v.data.general and v.data.general.dragCoef then
                        cd = v.data.general.dragCoef
                    end

                    -- 10. Максимальный угол выворота колес (в градусах)
                    local maxSteer = 0
                    if wheels and wheels.wheels then
                        for _, w in pairs(wheels.wheels) do
                            if w.steeringLimit and w.steeringLimit > maxSteer then maxSteer = w.steeringLimit end
                        end
                    end
                    local maxSteerDeg = math.floor(maxSteer * 57.295779513 + 0.5)
                    if maxSteerDeg == 0 then maxSteerDeg = 35 end

                    -- Вставьте эти строчки в тело сканера (где считываются параметры ДВС перед сборкой cmd):
                    local engInertia = 0.12
                    if engines and #engines > 0 then
                        engInertia = engines[1].inertia or 0.12
                    end

                    -- Собираем строку через безопасную конкатенацию строк
                    local cmd = "_G.CheatMenu_VehSpecs[" .. %d .. "] = { " ..
                        "weight = " .. weight .. ", " ..
                        "power = " .. maxPower .. ", " ..
                        "powerRPM = " .. maxPowerRPM .. ", " ..
                        "torque = " .. maxTorque .. ", " ..
                        "torqueRPM = " .. maxTorqueRPM .. ", " ..
                        "propulsion = '" .. motorType .. "', " ..
                        "induction = '" .. indType .. "', " ..
                        "fuel = '" .. fuelType .. "', " ..
                        "transmission = '" .. transType .. "', " ..
                        "drivetrain = '" .. layout .. "', " ..
                        "length = " .. length .. ", " ..
                        "width = " .. width .. ", " ..
                        "height = " .. height .. ", " ..
                        "frontWeight = " .. frontPercent .. ", " ..
                        "rearWeight = " .. rearPercent .. ", " ..
                        "displacement = " .. displacement .. ", " ..
                        "outputRPM = " .. outputRPM .. ", " ..
                        "maxRPM = " .. maxRPM .. ", " ..
                        "brakeType = '" .. brakeType .. "', " ..
                        "cd = " .. cd .. ", " ..
                        "inertia = " .. engInertia .. ", " ..
                        "maxSteer = " .. maxSteerDeg .. " }"
                        
                    obj:queueGameEngineLua(cmd)
                ]], tId, tId))
            end
        end

    -- 1. Размещаем кнопки ЗДЕСЬ (они будут висеть над вкладками)
    im.PushStyleColor2(im.Col_Button, im.ImVec4(0.75, 0.2, 0.2, 1.0))
    if im.Button("Reset All Cheats", im.ImVec2(120, 23)) then
        v:queueLuaCommand("CheatMenuM.resetCheats()")
    end
    im.SameLine()
    im.PopStyleColor()
    if im.Button("Repair", im.ImVec2(50, 23)) then
        v:queueLuaCommand("recovery.recoverInPlace()")
    end
    im.SameLine()
    im.Checkbox("not hide menu##disableCollapse", _G.CheatMenu_DisableCollapse)
    
    im.SameLine()
    im.SetNextItemWidth(150)
    local styleNames = {
        "Default Theme",
        "Dark Theme", 
        "Light Theme", 
        "Classic Theme", 
        "BeamNG Orange", 
        "Hacker Green", 
        "Cyberpunk Neon", 
        "Cherry Red", 
        "Corporate Grey", 
        "Midnight Blue"
    }
    if im.BeginCombo("##gui_style_select", styleNames[_G.CheatMenu_GuiStyleIdx + 1]) then
        for idx = 0, #styleNames - 1 do
            local isSelected = (_G.CheatMenu_GuiStyleIdx == idx)
            if im.Selectable1(styleNames[idx + 1], isSelected) then
                _G.CheatMenu_GuiStyleIdx = idx
            end
        end
        im.EndCombo()
    end
    
    -- Кнопка пуска/паузы физики
    if im.Button(isPaused and "Resume Simulation##bt_pause" or "Pause Simulation##bt_pause", im.ImVec2(120, 23)) then
        bullettime.togglePause()
    end
    im.SameLine()
    -- Отображение текущего состояния симуляции
    local isPaused = bullettime.getPause()
    if isPaused then
        im.TextColored(im.ImVec4(1.0, 0.2, 0.2, 1.0), "Simulation: PAUSE")
    else
        im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), "Simulation: ON.")
    end

    
    -- ФУНКЦИЯ ПОЛУЧЕНИЯ НАСТОЯЩЕГО ДИНАМИЧЕСКОГО FPS ИЗ BeamNG VariableRegistry
    
    local function getRealFPS()
        if VariableRegistry and VariableRegistry.get then
            -- 1. Считываем мгновенный реальный FPS (fps::instantaneous)
            local inst = VariableRegistry.get("$fps::instantaneous", -1)
            if inst and tonumber(inst) and tonumber(inst) > 0 then
                return tonumber(inst)
            end
            
            -- 2. Если мгновенный недоступен — считываем средний FPS (fps::avg)
            local avg = VariableRegistry.get("$fps::avg", -1)
            if avg and tonumber(avg) and tonumber(avg) > 0 then
                return tonumber(avg)
            end
        end
        
        -- Резерв через нативный Engine
        if Engine and Engine.getFPS then
            return Engine.getFPS()
        end
        
        return 60.0
    end

    -- Считываем точный динамический FPS
    local fpsReal = getRealFPS()

    im.SameLine()
    im.TextColored(im.ImVec4(0.4, 1.0, 0.4, 1.0), string.format("FPS: %.1f", fpsReal))
    
    -- Всплывающая подсказка с детальной статистикой (Avg, Min, Max, MS) при наведении на FPS
    if im.IsItemHovered() then
        im.BeginTooltip()
        if VariableRegistry and VariableRegistry.get then
            local fpsInst = tonumber(VariableRegistry.get("$fps::instantaneous", -1)) or fpsReal
            local fpsAvg  = tonumber(VariableRegistry.get("$fps::avg", -1)) or fpsReal
            local fpsMin  = tonumber(VariableRegistry.get("$fps::min", -1)) or 0
            local fpsMax  = tonumber(VariableRegistry.get("$fps::max", -1)) or 0
            
            im.Text(string.format("Instant FPS: %.1f", fpsInst))
            im.Text(string.format("Average FPS: %.1f", fpsAvg))
            im.Text(string.format("Min FPS:     %.1f", fpsMin))
            im.Text(string.format("Max FPS:     %.1f", fpsMax))
            if fpsReal > 0 then
                im.Text(string.format("Frame Time:  %.2f ms", 1000.0 / fpsReal))
            end
        else
            im.Text(string.format("FPS: %.1f", fpsReal))
        end
        im.EndTooltip()
    end
        
    im.SameLine()
    if im.SmallButton("Graph##perf_graph") then
        togglePerformanceGraph()
    end
    im.SameLine()
    if im.Button("Mod page on beamng.com") then
        openWebBrowser("https://www.beamng.com/resources/radial-cheat-menu.37823/")
    end
    im.Separator() -- Добавим линию для красоты

    renderDriveCheatBar(v, vehId)
    
    -- 2. Теперь начинаем вкладки
    if im.BeginTabBar("CheatMenuTabBar") then
        
        -- ХАРАКТЕРИСТИКИ ДВИГАТЕЛЯ И ФИЗИКИ
        if im.BeginTabItem("Hi") then
            im.SeparatorText("Hello")
            im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), "Hello! If something doesn't work:")
            im.Text("1. Press the tilde (~) or ` key on your keyboard")
            im.Text("2. click on Click Lines -> Copy all filtered Errors and Warnings")
            im.Text("3. Send errors in a private message on the forum.")
            
            if im.Button("Mod page on beamng.com") then
                openWebBrowser("https://www.beamng.com/resources/radial-cheat-menu.37823/")
            end
            if im.Button("Mod discussion thread on beamng.com") then
                openWebBrowser("https://www.beamng.com/threads/radial-cheat-menu-imgui-menu.110365/")
            end
            im.EndTabItem()
        end
        -- ХАРАКТЕРИСТИКИ ДВИГАТЕЛЯ И ФИЗИКИ
        if im.BeginTabItem("Power & Physics") then

            
            -- НАСТРОЙКИ ЗАЩИТЫ ОТ НЕСТАБИЛЬНОСТИ И АВТО-ВОССТАНОВЛЕНИЯ
            if im.CollapsingHeader1("Physics Instability Protection (recommend not to disable it)##instab_settings_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "In the new version 0.39 of the game, the game deletes a car if it detects instability, so we came up with this feature.")
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Automatic Physics Protection & Camera Fix:")
                im.Spacing()

                -- Галочка 1: Включение защиты от нестабильности (По умолчанию ВКЛ)
                im.Checkbox("Enable Instability Protection##chk_instab_prot", _G.CheatMenu_EnableInstabilityProtection)
                if im.IsItemHovered() then
                    im.SetTooltip("When enabled, automatically intercepts physics explosions, resets cheats to 1.0x and prevents vehicle deletion.")
                end

                -- Галочка 2: Авто-ремонт и возврат камеры (По умолчанию ВКЛ)
                if _G.CheatMenu_EnableInstabilityProtection[0] then
                    im.Indent(15)
                    im.Checkbox("Auto-Repair Car & Reset Camera Focus (Key R)##chk_instab_autorepair", _G.CheatMenu_InstabilityAutoRepair)
                    if im.IsItemHovered() then
                        im.SetTooltip("Automatically triggers vehicle repair (Key R / recovery.recoverInPlace) and resets camera focus back behind the car.")
                    end
                    im.Unindent(15)
                end
                if im.Button("Simulate Physics Instability Event (For tests)##btn_sim_instab", im.ImVec2(330, 24)) then
                    M.onInstabilityDetected(vehId, { instabilityHandled = false })
                end
            end
            
            
            -- КАРТОЧКА ТЕХНИЧЕСКИХ ХАРАКТЕРИСТИК (SPECIFICATIONS SHEET)
            
            if _G.CheatMenu_VehSpecs and _G.CheatMenu_VehSpecs[vehId] then
                local specs = _G.CheatMenu_VehSpecs[vehId]
                
                if specs == "PENDING" then
                    im.Text("Scanning vehicle specifications...")
                else
                    if im.CollapsingHeader1("Car info##veh_specs_header") then
                        im.BeginGroup()
                        
                        -- Колонка 1: Габариты и Аэродинамика
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Body & Dimensions:")
                        im.Text(string.format("Weight: %d kg", specs.weight or 0))
                        im.Text(string.format("Front/Rear: %d%%/%d%%", specs.frontWeight or 50, specs.rearWeight or 50))
                        im.Text(string.format("Length: %.2f m", specs.length or 0))
                        im.Text(string.format("Width:  %.2f m", specs.width or 0))
                        im.Text(string.format("Height: %.2f m", specs.height or 0))
                        im.Text(string.format("Steer Angle:  %d deg", specs.maxSteer or 35))
                        im.Text(string.format("Drag Coeff (Cd): %.2f", specs.cd or 0.32))
                        
                        im.EndGroup()
                        im.SameLine(150)
                        im.BeginGroup()
                        
                        -- Колонка 2: Двигатель и Трансмиссия
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Powertrain Layout:")
                        im.Text(string.format("Drivetrain: %s", tostring(specs.drivetrain)))
                        im.Text(string.format("Gearbox: %s", tostring(specs.transmission)))
                        im.Text(string.format("Induction: %s", tostring(specs.induction)))
                        im.Text(string.format("Propulsion: %s", tostring(specs.propulsion)))
                        
                        if specs.displacement and specs.displacement > 0.05 then
                            im.Text(string.format("Displacement: %.1f L", specs.displacement))
                        else
                            im.Text("Displacement: N/A")
                        end
                        
                        im.Text(string.format("Fuel Type: %s", tostring(specs.fuel)))
                        im.Text(string.format("Brake Pads: %s", tostring(specs.brakeType)))
                        
                        im.EndGroup()
                        im.SameLine(280)
                        im.BeginGroup()
                        
                        -- Колонка 3: Массы, Сила, Тормоза
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Performance:")
                        
                        if specs.power and specs.power > 0 then
                            im.Text(string.format("Power: %d HP (%d RPM)", specs.power, specs.powerRPM or 0))
                        else
                            im.Text("Power: N/A")
                        end
                        
                        if specs.torque and specs.torque > 0 then
                            im.Text(string.format("Torque: %d Nm (%d RPM)", specs.torque, specs.torqueRPM or 0))
                        else
                            im.Text("Torque: N/A")
                        end

                        if specs.power and specs.power > 0 then
                            local pwRatio = specs.weight / specs.power
                            im.Text(string.format("Weight/HP: %.2f kg/HP", pwRatio))
                        else
                            im.Text("Weight/HP:  N/A")
                        end
                        -- Обороты и Лимиты
                        im.Text(string.format("RPM/Max: %d/%d", specs.outputRPM or 0, specs.maxRPM or 0))
                        
                        
                        im.EndGroup()
                        im.SameLine(475)
                        im.BeginGroup()
                        
                        -- Колонка 3: Массы, Сила, Тормоза
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Live:")
                        
                        -- Мощность и Крутящий момент (из engineInfo)
                        im.Text(string.format("Engine: %.1f HP", vehState.enginePowerHP or 0.0))
                        im.Text(string.format("Engine: %.1f Nm", vehState.flywheelTorque or 0.0))
                        im.Text(string.format("Wheel:  %.1f HP", vehState.wheelPowerHP or 0.0))
                        im.Text(string.format("Wheel:  %.1f Nm", vehState.wheelTorque or 0.0))
                        
                        -- Двигатель и Охлаждение
                        im.Text(string.format("Engine Load:         %.1f%%", (vehState.engineLoad or 0.0) * 100))
                        im.Text(string.format("Engine Throttle:    %.1f%%", (vehState.engineThrottle or 0.0) * 100))
                        
                        -- Положение педалей в реальном времени
                        im.Text(string.format("Throttle: %.0f%% Brake: %.0f%% Clutch: %.0f%%", 
                            (vehState.pedalThrottle or 0.0) * 100, 
                            (vehState.pedalBrake or 0.0) * 100, 
                            (vehState.pedalClutch or 0.0) * 100))
                        
                        -- Коробка передач и сцепление
                        im.Text(string.format("Gear: %s", tostring(vehState.gearName)))
                        
                        im.SameLine()
                        -- Статус
                        if vehState.gearboxMode then
                            im.Text(string.format("(%s)", tostring(vehState.gearboxMode):upper()))
                        end
                        im.EndGroup()
                    end
                end
            end

            im.Separator()
            im.Text("Strength:")

            renderSliderWithReset("Strength Multiplier(all)", "invulnerableMultiplier", 0.0, 999999999999999999000000000.0, 1.0, "applyInvulnerability", "%.2f")
            renderSliderWithReset("Strength Multiplier(STABLE, for parts)", "globalStrengthMult", 0.001, 9999999999999999999999900.0, 1.0, "applyGlobalBeamStrengthMult", "%.2f", true)
            local softnessPtr = getPtr(vehId, "partSoftnessMultiplier", 1.0, "FloatPtr")

            if im.Button("RES##partSoftnessMultiplier", im.ImVec2(30, 0)) then
                softnessPtr[0] = 1.0
                v:queueLuaCommand([[
                    for _, b in pairs(v.data.beams) do
                        if b.wheelID == nil and (b.beamType == 0 or b.beamType == 2) and type(b.beamSpring) == "number" and b.beamSpring >= 5000 then
                            local origSpring = b.beamSpring or 100000
                            local origDamp = b.beamDamp or 100
                            obj:setBeamSpringDamp(b.cid, origSpring, origDamp, -1, -1)
                        end
                    end
                ]])
            end
            im.SameLine()

            im.SetNextItemWidth(-1)
            if im.SliderFloat("##partSoftnessMultiplier", softnessPtr, 0.00001, 1.0, "Part Softness Multiplier (Jelly Car): %.3fx", im.SliderFlags_Logarithmic) then
                v:queueLuaCommand(string.format([[
                    local mult = %f
                    for _, b in pairs(v.data.beams) do
                        if b.wheelID == nil and (b.beamType == 0 or b.beamType == 2) and type(b.beamSpring) == "number" and b.beamSpring >= 5000 then
                            local origSpring = b.beamSpring or 100000
                            local origDamp = b.beamDamp or 100
                            local newSpring = math.max(1, origSpring * mult)
                            local newDamp = math.max(1, origDamp * mult)
                            obj:setBeamSpringDamp(b.cid, newSpring, newDamp, newSpring, newDamp)
                        end
                    end
                ]], softnessPtr[0]))
            end

            if im.IsItemHovered() then
                im.SetTooltip("Ctrl + Click to type a specific value")
            end
            
            im.Checkbox("Freeze Strength Multiplier(STABLE, for parts)##freeze_globalStrengthMult", _G.CheatMenu_Freeze_globalStrengthMult)
            if im.IsItemHovered() then
                im.SetTooltip("Freeze value: automatically re-applies this strength multiplier every time the vehicle is reset/respawned (Ctrl+R).")
            end

            local indestructibleEnginePtr = getPtr(vehId, "indestructibleEngine", vehState.indestructibleEngine or false, "BoolPtr")
            if im.Checkbox("Engine God Mode (Engine + Transmission)", indestructibleEnginePtr) then
                sendVar("indestructibleEngine", indestructibleEnginePtr[0], "healDrivetrain")
            end

            local freezeThermalsPtr = getPtr(vehId, "freezeThermals", vehState.freezeThermals or false, "BoolPtr")
            if im.Checkbox("Anti-Overheat (Lock Temps at 20 C)", freezeThermalsPtr) then
                sendVar("freezeThermals", freezeThermalsPtr[0], "forceThermalsCooldown")
            end
            
            if _G.CheatMenu_SuperTiresV2 == nil then _G.CheatMenu_SuperTiresV2 = im.BoolPtr(false) end
            if im.Checkbox("Tire Protection v2 (Parts Strength Boost + Freeze)", _G.CheatMenu_SuperTiresV2) then
                local enabled = _G.CheatMenu_SuperTiresV2[0]
                local targetMult = enabled and 100000.0 or 1.0
                
                -- Выставляем прочность элементов в 100,000x и включаем заморозку на респавн
                getPtr(vehId, "globalStrengthMult", 1.0, "FloatPtr")[0] = targetMult
                _G.CheatMenu_Freeze_globalStrengthMult[0] = enabled
                v:queueLuaCommand(string.format("if CheatMenuM and CheatMenuM.applyGlobalBeamStrengthMult then CheatMenuM.applyGlobalBeamStrengthMult(%f) end", targetMult))
            end
            if im.IsItemHovered() then
                im.SetTooltip("Tire Protection v2: Sets 'Strength Multiplier (STABLE for parts)' to 100,000x and locks it on respawn.")
            end

            if _G.CheatMenu_StickyGrip == nil then _G.CheatMenu_StickyGrip = im.BoolPtr(false) end
            if _G.CheatMenu_StickyGripForce == nil then _G.CheatMenu_StickyGripForce = im.FloatPtr(0.2) end

            if im.Checkbox("Sticky Tires + Rollover protection", _G.CheatMenu_StickyGrip) then
                local enabled = _G.CheatMenu_StickyGrip[0]
                local targetGrip = enabled and 2 or 1.0
                
                getPtr(vehId, "gripMultiplier", 1.0, "FloatPtr")[0] = targetGrip
                v:queueLuaCommand(string.format("if CheatMenuM then CheatMenuM.state.gripMultiplier = %f; CheatMenuM.applyGripMultiplier(); CheatMenuM.state.stickyGrip = %s; CheatMenuM.state.stickyGripForce = %f end", targetGrip, tostring(enabled), _G.CheatMenu_StickyGripForce[0]))
            end
            if im.IsItemHovered() then
                im.SetTooltip("Glues tire hubs directly to the road surface below with 25x grip without changing body gravity.")
            end

            -- Слайдер настройки силы липкости
            if _G.CheatMenu_StickyGrip[0] then
                im.Indent(15)
                im.SetNextItemWidth(220)
                if im.SliderFloat("Stickiness Force Multiplier##sticky_force", _G.CheatMenu_StickyGripForce, 0.01, 3.0, "Force: %.2fx") then
                    v:queueLuaCommand(string.format("if CheatMenuM then CheatMenuM.state.stickyGripForce = %f end", _G.CheatMenu_StickyGripForce[0]))
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Adjust how strongly the tires stick to the road surface (lower values = lighter, softer attachment).")
                end
                im.Unindent(15)
            end
            
            local underwaterPtr = getPtr(vehId, "underwaterMode", vehState.underwaterMode or false, "BoolPtr")
            if im.Checkbox("Drive underwater", underwaterPtr) then
                sendVar("underwaterMode", underwaterPtr[0], "applyUnderwaterMode")
            end
            
            local awdPtr = getPtr(vehId, "awdMode", vehState.awdMode or false, "BoolPtr")
            if im.Checkbox("Max lock AWD/RWD/FWD", awdPtr) then
                sendVar("awdMode", awdPtr[0], "applyAWD")
            end
            
            local regenPtr = getPtr(vehId, "regenEnabled", vehState.regenEnabled or false, "BoolPtr")
            if im.Checkbox("Regeneration car", regenPtr) then
                if regenPtr[0] then
                    v:queueLuaCommand("CheatMenuM.startRegenerate()")
                else
                    v:queueLuaCommand("CheatMenuM.cancelRegenerate()")
                end
            end

            local superTiresPtr = getPtr(vehId, "superTires", vehState.superTires or false, "BoolPtr")
            if im.Checkbox("Tire Protection (v1)", superTiresPtr) then
                local val = superTiresPtr[0]
                vehState.superTires = val
                v:queueLuaCommand(string.format("CheatMenuM.state.superTires = %s; CheatMenuM.applySuperTires(%s)", 
                    tostring(val), tostring(val)))
            end
            
            im.Separator()
            im.Text("Tuning car:")
            im.SameLine()
            -- Индикатор Check Engine
            if vehState.checkEngine then
                im.TextColored(im.ImVec4(1.0, 0.2, 0.2, 1.0), "Check Engine: ERR")
            else
                im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), "Check Engine: OK")
            end
            -- 1. Слайдер разгона (Virtual Rocket Booster)
            local vehMass = (_G.CheatMenu_VehSpecs and _G.CheatMenu_VehSpecs[vehId] and _G.CheatMenu_VehSpecs[vehId].weight) or 1500
            if vehMass <= 0 then vehMass = 1500 end

            local currentG = vehState.pedalThrustForce or 0.0
            local approxHP = math.floor(currentG * vehMass * 0.3705 + 0.5)

            renderSliderWithReset(string.format("Virtual Rocket Booster (~%d HP)", approxHP), "pedalThrustForce", 0.0, 100.0, 0.0, nil, "%.1f G")
            if im.IsItemHovered() then 
                im.SetTooltip(string.format("Applies forward rocket thrust proportional to throttle input.\nEquivalent power at 100 km/h: ~%d HP (Car mass: %d kg)", approxHP, vehMass)) 
            end

            -- 2. Слайдер торможения (Virtual Braking Booster)
            local currentBrakeG = vehState.pedalBrakeForce or 0.0
            local approxBrakeHP = math.floor(currentBrakeG * vehMass * 0.3705 + 0.5)

            renderSliderWithReset(string.format("Virtual Braking Booster (~%d HP)", approxBrakeHP), "pedalBrakeForce", 0.0, 100.0, 0.0, nil, "%.1f G")
            if im.IsItemHovered() then 
                im.SetTooltip(string.format("Applies active reverse braking thrust proportional to brake pedal input.\nDeceleration power at 100 km/h: ~%d HP (Car mass: %d kg)", approxBrakeHP, vehMass)) 
            end
            if im.IsItemHovered() then 
                im.SetTooltip("Applies additional forward rocket thrust in G-force proportional to your throttle pedal input") 
            end
            renderSliderWithReset("Engine Power Multiplier", "powerMultiplier", 1.0, 10000000.0, 1.0, "applyPowerMultiplier", "%.1f")
            renderSliderWithReset("RPM Limit Multiplier", "rpmMultiplier", 0, 100.0, 1.0, "applyRPMMultiplier", "%.1f")
            renderSliderWithReset("Tire Grip", "gripMultiplier", 0.0, 10000000.0, 1.0, "applyGripMultiplier", "%.1f")
            renderSliderWithReset("Brakes Strength", "brakeMultiplier", 0.0, 1000000.0, 1.0, "applyBrakeMultiplier", "%.1f")
            renderSliderWithReset("Gear Ratio", "gearMultiplier", 0.0, 1000.0, 1.0, "applyGearingMultiplier", "%.2f")
            renderSliderWithReset("Car Weight(Body)", "massMultiplier", 0.75, 50.0, 1.0, "applyMassMultiplier", "%.2f")
            
            if im.CollapsingHeader1("FUN & Other##torque_tuner_header") then
                -- Торможение двигателем (engineBrakeTorque)
                local brakeTorquePtr = getPtr(vehId, "engineBrakeTorque", vehState.engineBrakeTorque or 40.0, "FloatPtr")
                
                -- Кнопка сброса торможения двигателем к исходному значению
                local defBrake = vehState.powertrainDefaults and vehState.powertrainDefaults.mainEngine and vehState.powertrainDefaults.mainEngine.engineBrakeTorque or 40.0
                if im.Button("RES##res_engBrake", im.ImVec2(30, 0)) then
                    brakeTorquePtr[0] = defBrake
                    v:queueLuaCommand(string.format("local eng = powertrain.getDevice('mainEngine'); if eng then eng.engineBrakeTorque = %f end", defBrake))
                end
                im.SameLine()
                im.SetNextItemWidth(-1)
                if im.SliderFloat("Brake Torque (Nm)##engBrake", brakeTorquePtr, -1000.0, 1000.0, "Engine Brake Torque: %.1f Nm") then
                    v:queueLuaCommand(string.format("local eng = powertrain.getDevice('mainEngine'); if eng then eng.engineBrakeTorque = %f end", brakeTorquePtr[0]))
                end
                -- Автоматическое считывание текущей инерции, если пользователь не тянет ползунок
                local telSpecs = _G.CheatMenu_VehSpecs[vehId]
                if telSpecs and type(telSpecs) == "table" and telSpecs.inertia and not im.IsItemActive() then
                    _G.CheatMenu_EngineInertia[0] = telSpecs.inertia
                end
                
                im.SetNextItemWidth(-1)
                if im.SliderFloat("##eng_inertia", _G.CheatMenu_EngineInertia, 0.01, 500.0, "Engine Rotational Inertia: %.3f kg*m²") then
                    v:queueLuaCommand(string.format([[
                        local eng = powertrain and powertrain.getDevice('mainEngine')
                        if eng then
                            eng.inertia = %f
                        end
                    ]], _G.CheatMenu_EngineInertia[0]))
                end
                if im.IsItemHovered() then 
                    im.SetTooltip("Lower values (0.01) make the engine rev up instantly like an F1 car. Higher values (10.0+) make revs sluggish and slow.") 
                end
                renderSliderWithReset("Air Drag/Wind", "dragMultiplier", 0.0, 500.0, 1.0, "applyDragAndCompensate", "%.2f")
            end

            
            -- ТЮНЕР ПОЛКИ МОМЕНТА И МОЩНОСТИ В РЕАЛЬНОМ ВРЕМЕНИ (ФИЗИЧЕСКИЙ РЕАЛТАЙМ)
            
            if not _G.CheatMenuWindow_Data.torqueCurve then
                _G.CheatMenuWindow_Data.torqueCurve = {}
            end

            if not _G.CheatMenuWindow_Data.torqueCurve[vehId] then
                v:queueLuaCommand("if CheatMenuM and CheatMenuM.pushTorqueCurveToGe then CheatMenuM.pushTorqueCurveToGe(true) end")
            end

            local tCurve = _G.CheatMenuWindow_Data.torqueCurve[vehId]
            if (not tCurve or #tCurve == 0) then
                if im.Button("Charger courbe moteur (ETK / auto-detect)##load_tcurve_etk", im.ImVec2(280, 26)) then
                    _G.CheatMenuWindow_Data.torqueCurve[vehId] = nil
                    v:queueLuaCommand("if CheatMenuM and CheatMenuM.pushTorqueCurveToGe then CheatMenuM.pushTorqueCurveToGe(true) end")
                end
                im.TextDisabled("Pas de courbe : l'ETK n'utilise pas toujours 'mainEngine' — bouton ci-dessus.")
            end
            if tCurve and #tCurve > 0 then
                if im.CollapsingHeader1("Power & Torque Curve Editor##torque_tuner_header") then
                    local specs = _G.CheatMenu_VehSpecs[vehId]
                    local currentRPM = specs.outputRPM or 0
                    
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), string.format("Live Engine Speed: %.0f RPM", currentRPM))
                    im.Text("Tuner Graphic Panel (Interactive Equalizer):")
                    im.Spacing()

                    -- Определение ближайшей точки RPM для интерактивной подсветки графика
                    local closestIdx = -1
                    local minDist = 999999
                    for i, p in ipairs(tCurve) do
                        local dist = math.abs(p[1] - currentRPM)
                        if dist < minDist then
                            minDist = dist
                            closestIdx = i
                        end
                    end

                    -- Автоматический подбор оптимальной высоты шкалы графика (в зависимости от максимального Nm мотора)
                    local maxTorqueInCurve = 500
                    for _, p in ipairs(tCurve) do
                        if p[2] > maxTorqueInCurve then
                            maxTorqueInCurve = p[2]
                        end
                    end
                    local sliderMaxLimit = math.ceil(maxTorqueInCurve * 1.5)

                    -- Отрисовка интерактивного горизонтального графика
                    im.BeginChild1("TorqueGraphContainer", im.ImVec2(0, 260), true, im.WindowFlags_HorizontalScrollbar)
                    
                    for i, p in ipairs(tCurve) do
                        local rpm = p[1]
                        local torque = p[2]
                        local hp = (torque * rpm) / 7120.8 -- Расчет HP
                        
                        -- Запоминаем стартовую координату начала колонки по оси X
                        local colStartX = im.GetCursorPosX()
                        
                        im.BeginGroup()
                        
                        -- 1. Вывод крутящего момента (оранжево-желтый) с центрированием
                        local tStr = string.format("%.0f", torque)
                        local tWidth = im.CalcTextSize(tStr).x
                        im.SetCursorPosX(colStartX + (32 - tWidth) / 2)
                        
                        local isActive = (i == closestIdx) and (currentRPM > 50)
                        if isActive then
                            im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), tStr)
                        else
                            im.TextColored(im.ImVec4(0.9, 0.7, 0.2, 1.0), tStr)
                        end
                        
                        -- 2. Вывод мощности HP (красный) с центрированием
                        local hpStr = string.format("%.0f", hp)
                        local hpWidth = im.CalcTextSize(hpStr).x
                        im.SetCursorPosX(colStartX + (32 - hpWidth) / 2)
                        
                        if isActive then
                            im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), hpStr .. " HP")
                        else
                            im.TextColored(im.ImVec4(1.0, 0.3, 0.3, 1.0), hpStr .. " HP")
                        end
                        
                        -- Настройка указателя ImGui для слайдера
                        local ptr = getPtr(vehId, "tCurve_" .. rpm, torque, "FloatPtr")
                        if not im.IsItemActive() then
                            ptr[0] = torque
                        end

                        -- Подсветка активной частоты мотора в физике
                        if isActive then
                            im.PushStyleColor2(im.Col_FrameBg, im.ImVec4(0.1, 0.4, 0.1, 0.6))
                            im.PushStyleColor2(im.Col_SliderGrab, im.ImVec4(0.2, 1.0, 0.2, 1.0))
                        end

                        -- Вертикальный слайдер как столбец графика (выровнен по левому краю группы)
                        im.SetCursorPosX(colStartX)
                        im.SetNextItemWidth(32)
                        if im.VSliderFloat("##v_tPoint_" .. rpm, im.ImVec2(42, 160), ptr, 0.0, sliderMaxLimit, "") then
                            p[2] = ptr[0]
                            local updateCmd = string.format("local eng = powertrain and powertrain.getDevice('mainEngine'); if eng and eng.customTorquePoints and eng.customTorquePoints[%d] then eng.customTorquePoints[%d][2] = %f; if createCurve then local newCurve = createCurve(eng.customTorquePoints); if newCurve then for k, v in pairs(newCurve) do if type(k) == 'number' then if eng.slowInertiaTorqueCurve then eng.slowInertiaTorqueCurve[k] = v end; if eng.fastInertiaTorqueCurve then eng.fastInertiaTorqueCurve[k] = v end; if eng.torqueCurve then eng.torqueCurve[k] = v end end end end end end", i, i, ptr[0])
                            v:queueLuaCommand(updateCmd)
                        end

                        if im.IsItemHovered() then
                            im.SetTooltip(string.format("RPM: %.0f\nTorque: %.1f Nm\nPower: %.1f HP", rpm, torque, hp))
                        end

                        if isActive then
                            im.PopStyleColor(2)
                        end

                        -- 3. Подпись оборотов RPM под слайдером с центрированием
                        local rpmLabel = string.format("%.0fk", rpm / 1000)
                        if rpm == 0 then rpmLabel = "0" end
                        local rWidth = im.CalcTextSize(rpmLabel).x
                        im.SetCursorPosX(colStartX + (32 - rWidth) / 2)
                        
                        if isActive then
                            im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), rpmLabel)
                        else
                            im.Text(rpmLabel)
                        end

                        im.EndGroup()
                        im.SameLine(0, 12) -- Точный горизонтальный шаг между колонками
                    end
                    
                    im.EndChild()
                    
                    -- Кнопка сброса (перезапись кривых обратно на оригинальные значения из бэкапа)
                    if im.Button("Reset Torque Curve to Factory Defaults##res_curve_btn", im.ImVec2(-1, 25)) then
                        _G.CheatMenuWindow_Data.torqueCurve[vehId] = nil -- Очищаем кэш интерфейса для мгновенного перезапроса
                        local resetCmd = string.format("local eng = powertrain and powertrain.getDevice('mainEngine'); if eng and eng.factoryTorquePoints then eng.customTorquePoints = {}; for _, pt in ipairs(eng.factoryTorquePoints) do table.insert(eng.customTorquePoints, {pt[1], pt[2]}) end; if createCurve then local newCurve = createCurve(eng.customTorquePoints); if newCurve then for k, v in pairs(newCurve) do if type(k) == 'number' then if eng.slowInertiaTorqueCurve then eng.slowInertiaTorqueCurve[k] = v end; if eng.fastInertiaTorqueCurve then eng.fastInertiaTorqueCurve[k] = v end; if eng.torqueCurve then eng.torqueCurve[k] = v end end end end end; obj:queueGameEngineLua('_G.CheatMenuWindow_Data.torqueCurve[' .. %d .. '] = ' .. serialize(eng.customTorquePoints)) end", vehId)
                        v:queueLuaCommand(resetCmd)
                    end
                end
            else
                im.Text("Engine diagnostics: Torque curve data is currently unavailable.")
            end
            if im.CollapsingHeader1("Turbocharger Tuning & Live Control##turbo_header") then
                if not vehState.hasTurbo then
                    im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "No active turbocharger detected on this vehicle.")
                    im.Text("Note: Naturally aspirated (NA) and Electric vehicles do not support turbo tuning.")
                    im.Text("Please install a turbocharger part in the Vehicle Config menu first.")
                else
                    -- 1. ТЕЛЕМЕТРИЯ ТУРБИНЫ В РЕАЛЬНОМ ВРЕМЕНИ (Честные показатели с учетом обхода JBeam)
                    im.TextColored(im.ImVec4(0.4, 1.0, 0.4, 1.0), "Live Telemetry:")
                    im.Text(string.format("Boost Pressure: %.2f PSI", vehState.turboPressurePSI or 0.0))
                    im.Text(string.format("Turbine Speed:  %.0f RPM", vehState.turboRPM or 0.0))
                    
                    -- Шкала давления наддува
                    local barFraction = math.min(math.max((vehState.turboPressurePSI or 0.0) / 100.0, 0.0), 1.0)
                    im.ProgressBar(barFraction, im.ImVec2(0, 14), string.format("%.1f PSI", vehState.turboPressurePSI or 0.0))
                    
                    im.Separator()
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Tuning & Spool Performance (Unlimited):")
                    
                    -- 2. ГЛАВНЫЙ МНОЖИТЕЛЬ ДАВЛЕНИЯ ТУРБИНЫ (Обход лимитов JBeam)
                    local multPtr = syncPtr(vehId, "turbo_multiplier", vehState.turboMultiplier or 1.0, "FloatPtr")
                    
                    if im.Button("RES##res_turboMult", im.ImVec2(30, 0)) then
                        multPtr[0] = 1.0
                        _G.CheatMenu_LastWriteTimes[vehId .. ".turbo_multiplier"] = os.clock()
                        v:queueLuaCommand("if not _G.CheatMenu_TurboTuner then injectTurboBypass() end; _G.CheatMenu_TurboTuner.multiplier = 1.0")
                    end
                    im.SameLine()
                    im.SetNextItemWidth(200)
                    if im.SliderFloat("Boost Multiplier##slider_turboMult", multPtr, 1.0, 100.0, "Multiplier: %.2fx") then
                        _G.CheatMenu_LastWriteTimes[vehId .. ".turbo_multiplier"] = os.clock()
                        -- Применяем множитель, пробивающий лимиты JBeam
                        v:queueLuaCommand(string.format("if not _G.CheatMenu_TurboTuner then injectTurboBypass() end; _G.CheatMenu_TurboTuner.multiplier = %f", multPtr[0]))
                    end
                    if im.IsItemHovered() then im.SetTooltip("Directly multiplies final boost pressure and engine torque (bypasses JBeam maps limits).") end

                    -- 3. НАСТРОЙКА АНТИЛАГА (Anti-Lag System / ALS)
                    local antilagPtr = syncPtr(vehId, "turbo_antilag", vehState.antilagCoef or 0.0, "FloatPtr")
                    
                    if im.Button("RES##res_antilag", im.ImVec2(30, 0)) then
                        antilagPtr[0] = 0.0
                        _G.CheatMenu_LastWriteTimes[vehId .. ".turbo_antilag"] = os.clock()
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.turbocharger and eng.turbocharger.setAntilagCoef then eng.turbocharger.setAntilagCoef(0.0) end")
                    end
                    im.SameLine()
                    im.SetNextItemWidth(200)
                    if im.SliderFloat("Anti-Lag Force (ALS)##slider_antilag", antilagPtr, 0.0, 10.0, "Coef: %.2f") then
                        _G.CheatMenu_LastWriteTimes[vehId .. ".turbo_antilag"] = os.clock()
                        v:queueLuaCommand(string.format("local eng = powertrain.getDevice('mainEngine'); if eng and eng.turbocharger and eng.turbocharger.setAntilagCoef then eng.turbocharger.setAntilagCoef(%f) end", antilagPtr[0]))
                    end
                    if im.IsItemHovered() then im.SetTooltip("ALS keeps exhaust pressure high when you let off the throttle, keeping turbine spinning.") end
                end
            end

            im.Separator()
            im.Text("Infinite Supplies:")

            local infFuelPtr = getPtr(vehId, "infiniteFuel", vehState.infiniteFuel or false, "BoolPtr")
            if im.Checkbox("Infinite Fuel & Battery", infFuelPtr) then
                sendVar("infiniteFuel", infFuelPtr[0], "applyInfiniteFuel")
            end

            local infN2OPtr = getPtr(vehId, "infiniteN2O", vehState.infiniteN2O or false, "BoolPtr")
            if im.Checkbox("Infinite Nitrous Oxide (N2O)", infN2OPtr) then
                sendVar("infiniteN2O", infN2OPtr[0], "applyInfiniteN2O")
            end

            local infJatoPtr = getPtr(vehId, "infiniteJato", vehState.infiniteJato or false, "BoolPtr")
            if im.Checkbox("Infinite JATO Rockets Fuel", infJatoPtr) then
                sendVar("infiniteJato", infJatoPtr[0])
            end

            renderSliderWithReset("JATO Power Multiplier", "jatoMultiplier", 1.0, 100000.0, 1.0)

            im.Separator()
            im.Text("Gravity:")
            renderSliderWithReset("Gravity Multiplier", "gravityMultiplier", -10000.0, 10000.0, 1.0, "applyGravityMultiplier", "%.1f")
            if im.CollapsingHeader1("3D Gravity (Maneuvering Pad)") then
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "3D Thrusters (Maneuvering Pad):")
                
                -- Слайдеры постоянных сил (X, Y, Z) [2]
                local tXPtr = syncPtr(vehId, "thrust_x", vehState.thrustX or 0.0, "FloatPtr")
                im.SetNextItemWidth(350)
                if im.SliderFloat("Side Thrust (X)##s_tX", tXPtr, -100.0, 100.0, "%.1f G") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_x"] = os.clock()
                    sendVar("thrustX", tXPtr[0])
                end
                if im.IsItemHovered() then im.SetTooltip("Applies continuous lateral force. Negative = Push Left, Positive = Push Right [2].") end
                
                local tYPtr = syncPtr(vehId, "thrust_y", vehState.thrustY or 0.0, "FloatPtr")
                im.SetNextItemWidth(350)
                if im.SliderFloat("Forward Thrust (Y)##s_tY", tYPtr, -100.0, 100.0, "%.1f G") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_y"] = os.clock()
                    sendVar("thrustY", tYPtr[0])
                end
                if im.IsItemHovered() then im.SetTooltip("Applies continuous longitudinal force. Negative = Push Backward, Positive = Push Forward [2].") end

                local tZPtr = syncPtr(vehId, "thrust_z", vehState.thrustZ or 0.0, "FloatPtr")
                im.SetNextItemWidth(350)
                if im.SliderFloat("Vertical Thrust (Z)##s_tZ", tZPtr, -100.0, 100.0, "%.1f G") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_z"] = os.clock()
                    sendVar("thrustZ", tZPtr[0])
                end
                if im.IsItemHovered() then im.SetTooltip("Applies continuous vertical force. Negative = Push Down, Positive = Push Up (Fly!) [2].") end
                
                -- Кнопка сброса маневровых двигателей
                if im.Button("Reset 3D Thrusters##btn_res_thr", im.ImVec2(-1, 22)) then
                    tXPtr[0], tYPtr[0], tZPtr[0] = 0.0, 0.0, 0.0
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_x"] = os.clock()
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_y"] = os.clock()
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_z"] = os.clock()
                    sendVar("thrustX", 0.0)
                    sendVar("thrustY", 0.0)
                    sendVar("thrustZ", 0.0)
                end

                im.Spacing()
                im.Text("Maneuvering D-Pad (Hold to Push):")
                
                -- Интерактивные кнопки удержания (D-Pad) [2]
                local holdPowerPtr = getPtr(vehId, "hold_thrust_power", 50.0, "FloatPtr")
                im.SetNextItemWidth(350)
                im.SliderFloat("Power##hold_pwr", holdPowerPtr, 0.5, 1000.0, "Force: %.1f G")
                
                local pwr = holdPowerPtr[0]
                
                -- Ряд 1: Вперед
                im.SetCursorPosX(im.GetCursorPosX() + 41)
                im.Button("  ^  ##hold_fwd", im.ImVec2(35, 30))
                if im.IsItemActive() then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_y"] = os.clock()
                    sendVar("thrustY", pwr)
                elseif im.IsItemDeactivated() then
                    sendVar("thrustY", 0.0)
                end
                
                -- Ряд 2: Влево | Назад | Вправо
                im.Button(" <  ##hold_left", im.ImVec2(35, 30))
                if im.IsItemActive() then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_x"] = os.clock()
                    sendVar("thrustX", -pwr)
                elseif im.IsItemDeactivated() then
                    sendVar("thrustX", 0.0)
                end
                
                im.SameLine()
                im.Button("  v  ##hold_back", im.ImVec2(35, 30))
                if im.IsItemActive() then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_y"] = os.clock()
                    sendVar("thrustY", -pwr)
                elseif im.IsItemDeactivated() then
                    sendVar("thrustY", 0.0)
                end
                
                im.SameLine()
                im.Button("  >  ##hold_right", im.ImVec2(35, 30))
                if im.IsItemActive() then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_x"] = os.clock()
                    sendVar("thrustX", pwr)
                elseif im.IsItemDeactivated() then
                    sendVar("thrustX", 0.0)
                end
                
                -- Вертикальные кнопки (Вверх / Вниз)
                im.SameLine()
                im.Spacing()
                im.SameLine()
                im.Button("Up##hold_up", im.ImVec2(45, 30))
                if im.IsItemActive() then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_z"] = os.clock()
                    sendVar("thrustZ", pwr)
                elseif im.IsItemDeactivated() then
                    sendVar("thrustZ", 0.0)
                end
                
                im.SameLine()
                im.Button("Down##hold_down", im.ImVec2(45, 30))
                if im.IsItemActive() then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".thrust_z"] = os.clock()
                    sendVar("thrustZ", -pwr)
                elseif im.IsItemDeactivated() then
                    sendVar("thrustZ", 0.0)
                end
            end
            if im.CollapsingHeader1("Flight Mode (Fly Car)##fly_mode_header") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Full Aircraft / Drone Flight Controls:")
                im.TextColored(im.ImVec4(1.0, 0.5, 0.9, 1.0), "Experimental !!!")
                
                -- Галочка включения АВТОМАТИЧЕСКОГО полета (Парение и Отмена Гравитации)
                local flyActive = im.Checkbox("Enable Auto-Hover Flight Mode (Anti-Gravity)##chk_fly_active", _G.CheatMenu_FlyMode)
                if flyActive then
                    sendVar("flyMode", _G.CheatMenu_FlyMode[0])
                end
                
                if _G.CheatMenu_FlyMode[0] then
                    im.SameLine()
                    if im.Checkbox("Hover / Auto-Stabilize##chk_fly_hover", _G.CheatMenu_FlyHover) then
                        sendVar("flyHover", _G.CheatMenu_FlyHover[0])
                    end
                    if im.IsItemHovered() then im.SetTooltip("Cancels gravity and neutralizes inertia when controls are released.") end
                end

                im.Separator()
                -- Слайдер силы/скорости доступен ВСЕГДА
                im.SetNextItemWidth(250)
                if im.SliderFloat("Flight Speed / Power##fly_speed", _G.CheatMenu_FlySpeed, 1.0, 1000.0, "Force: %.1f G") then
                    sendVar("flySpeed", _G.CheatMenu_FlySpeed[0])
                end
                
                im.Spacing()
                im.Text("Flight Maneuvering Pad (Hold to Control - Works Always):")
                
                local fSpeed = _G.CheatMenu_FlySpeed[0]
                
                -- КНОПКИ ТЕПЕРЬ ДОСТУПНЫ ВСЕГДА (ВНЕ ЗАВИСИМОСТИ ОТ ГАЛОЧКИ FLY MODE)
                -- Управление линейным перемещением
                im.Text("Movement:")
                if im.Button("Ascend (Up)##fly_up", im.ImVec2(80, 28)) then end
                if im.IsItemActive() then sendVar("thrustZ", fSpeed) elseif im.IsItemDeactivated() then sendVar("thrustZ", 0.0) end
                im.SameLine()
                if im.Button("Descend (Down)##fly_down", im.ImVec2(85, 28)) then end
                if im.IsItemActive() then sendVar("thrustZ", -fSpeed) elseif im.IsItemDeactivated() then sendVar("thrustZ", 0.0) end
                im.SameLine()
                if im.Button("Forward##fly_fwd", im.ImVec2(80, 28)) then end
                if im.IsItemActive() then sendVar("thrustY", fSpeed) elseif im.IsItemDeactivated() then sendVar("thrustY", 0.0) end
                im.SameLine()
                if im.Button("Backward##fly_bwd", im.ImVec2(80, 28)) then end
                if im.IsItemActive() then sendVar("thrustY", -fSpeed) elseif im.IsItemDeactivated() then sendVar("thrustY", 0.0) end

                -- Управление вращением (Тангаж / Pitch)
                im.Text("Attitude / Pitch & Roll:")
                if im.Button("Pitch Down (Nose Down)##fly_p_dwn", im.ImVec2(130, 28)) then end
                if im.IsItemActive() then sendVar("flyPitch", fSpeed * 0.5) elseif im.IsItemDeactivated() then sendVar("flyPitch", 0.0) end
                im.SameLine()
                if im.Button("Pitch Up (Nose Up)##fly_p_up", im.ImVec2(130, 28)) then end
                if im.IsItemActive() then sendVar("flyPitch", -fSpeed * 0.5) elseif im.IsItemDeactivated() then sendVar("flyPitch", 0.0) end
                
                -- Управление поворотом и креном (Yaw / Roll)
                if im.Button("Turn Left (Yaw)##fly_y_lft", im.ImVec2(130, 28)) then end
                if im.IsItemActive() then sendVar("flyYaw", fSpeed * 0.5) elseif im.IsItemDeactivated() then sendVar("flyYaw", 0.0) end
                im.SameLine()
                if im.Button("Turn Right (Yaw)##fly_y_rgt", im.ImVec2(130, 28)) then end
                if im.IsItemActive() then sendVar("flyYaw", -fSpeed * 0.5) elseif im.IsItemDeactivated() then sendVar("flyYaw", 0.0) end
                
                if im.Button("Roll Left##fly_r_lft", im.ImVec2(130, 28)) then end
                if im.IsItemActive() then sendVar("flyRoll", -fSpeed * 0.5) elseif im.IsItemDeactivated() then sendVar("flyRoll", 0.0) end
                im.SameLine()
                if im.Button("Roll Right##fly_r_rgt", im.ImVec2(130, 28)) then end
                if im.IsItemActive() then sendVar("flyRoll", fSpeed * 0.5) elseif im.IsItemDeactivated() then sendVar("flyRoll", 0.0) end
            end

            im.EndTabItem()
        end
        -- ВКЛАДКА ДВИГАТЕЛЯ, ТРАНСМИССИИ И ОДОМЕТРА
        if im.BeginTabItem("Edit & Devices") then
            if im.CollapsingHeader1("Torque & Friction Scalers (Multipliers)") then
                -- Проверяем, пришли ли данные от автомобиля
                local hasEngine = vehState.engineBrakeTorque ~= nil
                
                if not hasEngine then
                    im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "No engine diagnostic data received yet.")
                    im.Text("Make sure the car is active and the vehicle script is running.")
                    im.Text("Note: Electric vehicles may not have a 'mainEngine' device.")
                else
                    -- Изменение крутящего момента (scaleOutputTorque) и трения (scaleFriction)
                    
                    local torqueScalePtr = getPtr(vehId, "torqueScaleVal", 1.0, "FloatPtr")
                    -- Кнопка сброса множителя крутящего момента в 1.0
                    if im.Button("RES##res_torqueScale", im.ImVec2(30, 0)) then
                        torqueScalePtr[0] = 1.0
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.scaleOutputTorque then eng:scaleOutputTorque(1.0) end")
                    end
                    im.SameLine()
                    im.SetNextItemWidth(150)
                    im.InputFloat("Torque Scale##torqueScale", torqueScalePtr, 0.1, 1.0, "%.2f")
                    im.SameLine()
                    if im.Button("Apply##torqueApply") then
                        v:queueLuaCommand(string.format("local eng = powertrain.getDevice('mainEngine'); if eng and eng.scaleOutputTorque then eng:scaleOutputTorque(%f) end", torqueScalePtr[0]))
                    end
                    
                    local frictionScalePtr = getPtr(vehId, "frictionScaleVal", 1.0, "FloatPtr")
                    -- Кнопка сброса множителя трения в 1.0
                    if im.Button("RES##res_frictionScale", im.ImVec2(30, 0)) then
                        frictionScalePtr[0] = 1.0
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.scaleFriction then eng:scaleFriction(1.0) end")
                    end
                    im.SameLine()
                    im.SetNextItemWidth(150)
                    im.InputFloat("Friction Scale##frictionScale", frictionScalePtr, 0.1, 1.0, "%.2f")
                    im.SameLine()
                    if im.Button("Apply##frictionApply") then
                        v:queueLuaCommand(string.format("local eng = powertrain.getDevice('mainEngine'); if eng and eng.scaleFriction then eng:scaleFriction(%f) end", frictionScalePtr[0]))
                    end
                end
            end

            im.Separator()

            if im.CollapsingHeader1("Odometer editor") then
                local inputOdoPtr = getPtr(vehId, "set_odo", 10000.0, "FloatPtr")
                -- Кнопка быстрого сброса одометра в 0 (с безопасным rawget-вызовом)
                if im.Button("RES##res_inputOdometer", im.ImVec2(30, 0)) then
                    inputOdoPtr[0] = 0.0
                    v:queueLuaCommand("partCondition.initConditions(nil, 0, 1, {'a'})")
                    v:queueLuaCommand("if rawget(extensions, 'blrVehicleUtils') then extensions.blrVehicleUtils.loadOdometer() end")
                end
                im.SameLine()
                im.SetNextItemWidth(200)
                im.InputFloat("##inputOdometer", inputOdoPtr, 1000.0, 10000.0, "%.0f")
                im.SameLine()
                if im.Button("Apply Odometer") then
                    -- Установка пробега и износа, а также безопасная проверка фикса для BLR
                    v:queueLuaCommand(string.format("partCondition.initConditions(nil, %f, 1, {'a'})", inputOdoPtr[0]))
                    v:queueLuaCommand("if rawget(extensions, 'blrVehicleUtils') then extensions.blrVehicleUtils.loadOdometer() end")
                end
            end
            im.Separator()
            
            -- НАКОПИТЕЛИ ЭНЕРГИИ (energyStorage.getStorages)
            if im.CollapsingHeader1("Energy Storages (Fuel Tanks / Batteries / N20 / Air Tanks)") then
                if vehState.energyStorages and next(vehState.energyStorages) then
                    for storageName, sData in pairs(vehState.energyStorages) do
                        local ratioPtr = getPtr(vehId, "storage_ratio_" .. storageName, sData.remainingRatio or 1.0, "FloatPtr")
                        
                        -- Кнопка быстрого сброса уровня бака/батареи до 100% (заправка)
                        if im.Button("RES##res_ratio_" .. storageName, im.ImVec2(30, 0)) then
                            ratioPtr[0] = 1.0
                            v:queueLuaCommand(string.format("local s = energyStorage.getStorages()['%s']; if s and s.setRemainingRatio then s:setRemainingRatio(1.0) end", storageName))
                        end
                        im.SameLine()
                        im.SetNextItemWidth(-150)
                        local changed = im.SliderFloat(storageName .. " Ratio##ratio_" .. storageName, ratioPtr, 0.0, 1.0, "Ratio: %.2f")
                        
                        im.SameLine()
                        if im.Button("Set##btn_ratio_" .. storageName) or changed then
                            v:queueLuaCommand(string.format("local s = energyStorage.getStorages()['%s']; if s and s.setRemainingRatio then s:setRemainingRatio(%f) end", storageName, ratioPtr[0]))
                        end
                    end
                    -- Топливная система
                    im.Text(string.format("Fuel Level: %.1f%% (%.2fL / %.2fL)", 
                        (vehState.fuelRatio or 0.0) * 100, 
                        vehState.fuelVolume or 0.0, 
                        vehState.fuelCapacity or 0.0))
                end
            end

            -- УПРАВЛЕНИЕ СИСТЕМАМИ СТАБИЛИЗАЦИИ (esc.lua / driveModes.lua)
            if vehState.hasESCSystem ~= nil then
                if im.CollapsingHeader1("ESC, TCS & Drive Modes") then
                    if not vehState.hasESCSystem then
                        im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "This vehicle does not have an ESC/TCS or Drive Modes system installed.")
                    else
                        -- Вывод статуса систем
                        if vehState.escSystemType == "driveModes" then
                            im.Text(string.format("Current Drive Mode: %s", tostring(vehState.escName)))
                        else
                            im.Text(string.format("Active ESC Mode:    %s", tostring(vehState.escName)))
                        end
                        
                        if vehState.escFailure then
                          im.TextColored(im.ImVec4(1.0, 0.2, 0.2, 1.0), "System Status: ESC/TCS FAILURE (Sensor/Wheel Error)")
                        else
                          im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), "System Status: ESC/TCS OK (Sensing Active)")
                        end
                        
                        -- Вывод интервенции систем в реальном времени
                        if vehState.escActive == 1 then
                            im.TextColored(im.ImVec4(1.0, 0.5, 0.0, 1.0), "ESC INTERVENTION: ACTIVE BRAKING")
                        else
                            im.Text("ESC Intervention: Idle")
                        end
                        
                        if vehState.tcsActive == 1 then
                            im.TextColored(im.ImVec4(1.0, 0.5, 0.0, 1.0), "TCS INTERVENTION: ENGINE THROTTLE CUT")
                        else
                            im.Text("TCS Intervention: Idle")
                        end
                        
                        im.Separator()
                        
                        -- 1. Кнопки выбора режимов (адаптировано под классический ESC и современные DriveModes)
                        if vehState.escConfigs and #vehState.escConfigs > 0 then
                            if vehState.escSystemType == "driveModes" then
                                im.Text("Select Active Drive Mode (DSE):")
                            else
                                im.Text("Select Stability Control Mode:")
                            end
                            
                            for _, config in ipairs(vehState.escConfigs) do
                                local isCurrent = vehState.currentESCKey == config.key
                                
                                -- Выделяем оранжевым цветом кнопку текущего режима
                                if isCurrent then
                                    im.PushStyleColor2(im.Col_Button, im.ImVec4(1.0, 0.4, 0.0, 1.0))
                                end
                                
                                if im.Button(config.name .. "##escMode_" .. tostring(config.key)) then
                                    if vehState.escSystemType == "driveModes" then
                                        v:queueLuaCommand(string.format("if controller and controller.getController('driveModes') then controller.getController('driveModes').setDriveMode('%s') end", tostring(config.key)))
                                    else
                                        v:queueLuaCommand(string.format("if controller and controller.getController('esc') then controller.getController('esc').setESCMode(%d) end", config.key))
                                    end
                                end
                                
                                if isCurrent then
                                    im.PopStyleColor()
                                end
                                im.SameLine()
                            end
                            im.NewLine()
                        end
                        
                        -- 2. Временная приостановка работы ESC (pauseESCAction) - только для классического ESC
                        if vehState.escSystemType == "esc" then
                            im.Separator()
                            local pauseESCPtr = getPtr(vehId, "pause_esc", vehState.pauseESCAction or false, "BoolPtr")
                            if not im.IsItemActive() then
                                pauseESCPtr[0] = vehState.pauseESCAction or false
                            end
                            if im.Checkbox("Pause ESC/TCS Intervention##pauseESC", pauseESCPtr) then
                                v:queueLuaCommand(string.format("if controller and controller.getController('esc') then controller.getController('esc').pauseESCAction = %s end", tostring(pauseESCPtr[0])))
                            end
                            
                            im.Separator()
                            
                            -- 3. Настройка чувствительности порогов (только для классического ESC)
                            im.Text("Adjust Sensitivity of Active Preset:")
                            
                            -- Порог пробуксовки TCS
                            local slipPtr = getPtr(vehId, "esc_slipThreshold", vehState.slipThreshold or 0.0, "FloatPtr")
                            if not im.IsItemActive() then
                                slipPtr[0] = vehState.slipThreshold or 0.0
                            end
                            im.SetNextItemWidth(150)
                            if im.SliderFloat("TCS Slip Threshold##slipThreshold", slipPtr, 0.0, 1.0, "%.3f") then
                                v:queueLuaCommand(string.format("local esc = controller and controller.getController('esc'); local cfg = esc and esc.getCurrentConfigData(); if cfg then cfg.slipThreshold = %f end", slipPtr[0]))
                            end
                            
                            -- Порог срабатывания ESC по сносу (Yaw)
                            local escThreshPtr = getPtr(vehId, "esc_threshold", vehState.escThreshold or 0.0, "FloatPtr")
                            if not im.IsItemActive() then
                                escThreshPtr[0] = vehState.escThreshold or 0.0
                            end
                            im.SetNextItemWidth(150)
                            if im.SliderFloat("ESC Yaw Threshold##escThreshold", escThreshPtr, 0.0, 10.0, "%.3f") then
                                v:queueLuaCommand(string.format("local esc = controller and controller.getController('esc'); local cfg = esc and esc.getCurrentConfigData(); if cfg then cfg.escThreshold = %f end", escThreshPtr[0]))
                            end
                        end
                    end
                end
            end
            im.Separator()

            -- ГЛАВНЫЙ КОНТРОЛЛЕР АВТОМОБИЛЯ И ПОМОЩНИКИ ВОЖДЕНИЯ (vehicleController.lua & core_vehicleBridge)
                if im.CollapsingHeader1("Vehicle Controller & Driving Assists") then
                    im.Text("Shifter Mode & Driving Assists:")
                    
                    -- 1. Переключение режимов КПП через core_vehicleBridge
                    if im.Button("Arcade Mode##sh_arcade", im.ImVec2(120, 24)) then
                        core_vehicleBridge.executeAction(v, "setGearboxMode", "arcade")
                    end
                    im.SameLine()
                    if im.Button("Realistic Mode##sh_real", im.ImVec2(120, 24)) then
                        core_vehicleBridge.executeAction(v, "setGearboxMode", "realistic")
                    end
                    im.SameLine()
                        
                    -- 2. Вызов встроенного окна выбора помощников вождения (Driving Assists Popup)
                    if im.Button("Driving Assists Menu##btn_assists_popup", im.ImVec2(160, 24)) then
                        if ui_popup and ui_popup.openDrivingAssistsPopup then
                            ui_popup.openDrivingAssistsPopup()
                        end
                    end

                    -- 3. Переключатель авто-сцепления (Auto Clutch)
                    local autoClutchVal = settings and settings.getValue("autoClutch", true)
                    local autoClutchPtr = getPtr(vehId, "setting_autoClutch", autoClutchVal, "BoolPtr")
                    if not im.IsItemActive() then autoClutchPtr[0] = autoClutchVal end
                    if im.Checkbox("Auto Clutch (Авто-сцепление)##chk_autoClutch", autoClutchPtr) then
                        if settings and settings.setValue then
                            settings.setValue("autoClutch", autoClutchPtr[0])
                        end
                    end
                    
                    im.Text(string.format("Clutch Engagement: %.1f%%", (vehState.clutchRatio or 0.0) * 100))
                    im.Text(string.format("Shifting Status: %s", vehState.isShifting and "SHIFTING..." or "STABLE"))
                    
                    im.Separator()
                    
                    -- 2. Заморозка трансмиссии
                    local frzPtr = getPtr(vehId, "set_controllerFreeze", vehState.freezeState or false, "BoolPtr")
                    if not im.IsItemActive() then
                        frzPtr[0] = vehState.freezeState or false
                    end
                    if im.Checkbox("Freeze Vehicle Motion (Freeze the wheels)##ctrlFreeze", frzPtr) then
                        v:queueLuaCommand(string.format("if controller and controller.getController('vehicleController') then controller.getController('vehicleController').setFreeze(%s) end", tostring(frzPtr[0])))
                    end
                    
                    im.Separator()
                    
                    im.Text("Engine Powertrain Controls:")
                    -- 3. Регулировка зажигания (0 = Выкл, 1 = ACC, 2 = Вкл, 3 = Стартер)
                    local ignPtr = getPtr(vehId, "set_ignitionLevel", vehState.ignitionLevel or 0, "IntPtr")
                    if not im.IsItemActive() then
                        ignPtr[0] = vehState.ignitionLevel or 0
                    end
                    im.SetNextItemWidth(200)
                    if im.SliderInt("Ignition Level##ignLevel", ignPtr, 0, 3, "Level: %d") then
                        v:queueLuaCommand(string.format("electrics.setIgnitionLevel(%d)", ignPtr[0]))
                    end
                    -- Включение и выключение двигателя (enable / disable)
                    if im.Button("Enable Engine", im.ImVec2(120, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.enable then eng:enable() end")
                    end
                    im.SameLine()
                    if im.Button("Disable Engine", im.ImVec2(120, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.disable then eng:disable() end")
                    end

                    -- Регулировка проблесковых маячков (Lightbar Mode)
                    local lightbarPtr = getPtr(vehId, "set_lightbarMode", 0, "IntPtr")
                    if not im.IsItemActive() and vehState.lightbar ~= nil then
                        lightbarPtr[0] = tonumber(vehState.lightbar) or 0
                    end
                    im.SetNextItemWidth(200)
                    if im.SliderInt("Lightbar Mode##lightbarMode", lightbarPtr, 0, 3, "Mode: %d") then
                        v:queueLuaCommand(string.format("electrics.set_lightbar_signal(%d)", lightbarPtr[0]))
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("0 = Off, 1 = Left, 2 = Right, 3 = Full Signal")
                    end

                    -- Управление режимом фар (Lights State)
                    local lightModePtr = getPtr(vehId, "set_lightMode", 0, "IntPtr")
                    if not im.IsItemActive() and vehState.lightsState ~= nil then
                        lightModePtr[0] = tonumber(vehState.lightsState) or 0
                    end
                    im.SetNextItemWidth(200)
                    if im.SliderInt("Lights State##lightMode", lightModePtr, 0, 2, "State: %d") then
                        v:queueLuaCommand(string.format("electrics.setLightsState(%d)", lightModePtr[0]))
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("0 = Off, 1 = Low Beams, 2 = High Beams")
                    end
                    
                    im.Separator()
                    
                    -- 4. Переопределение агрессивности вождения (drivingAggression)
                    local aggPtr = getPtr(vehId, "set_drivingAggression", vehState.drivingAggression or 0.75, "FloatPtr")
                    local overrideAggPtr = getPtr(vehId, "override_aggression", false, "BoolPtr")
                    
                    if not im.IsItemActive() then
                        aggPtr[0] = vehState.drivingAggression or 0.75
                    end
                    
                    im.Text(string.format("Driving Aggression: %.2f", vehState.drivingAggression or 0.0))
                    if im.Checkbox("Override Aggression (The driver's desire to downshift and drive faster)##checkAgg", overrideAggPtr) then
                        if overrideAggPtr[0] then
                            v:queueLuaCommand(string.format("if controller and controller.getController('vehicleController') then controller.getController('vehicleController').setAggressionOverride(%f) end", aggPtr[0]))
                        else
                            v:queueLuaCommand("if controller and controller.getController('vehicleController') then controller.getController('vehicleController').setAggressionOverride(nil) end")
                        end
                    end
                    
                    if overrideAggPtr[0] then
                        im.SetNextItemWidth(300)
                        if im.SliderFloat("Aggression##sliderAgg", aggPtr, 0.0, 1.0, "%.2f") then
                            v:queueLuaCommand(string.format("if controller and controller.getController('vehicleController') then controller.getController('vehicleController').setAggressionOverride(%f) end", aggPtr[0]))
                        end
                    end
                    
                    im.Separator()
                    
                    -- 5. Управление умным ручником
                    im.Text("Smart Parking Brake:")
                    if im.Button("Apply Parking Brake##pBrakeOn") then
                        v:queueLuaCommand("if controller and controller.getController('vehicleController') then controller.getController('vehicleController').smartParkingBrake(1) end")
                    end
                    im.SameLine()
                    if im.Button("Release Parking Brake##pBrakeOff") then
                        v:queueLuaCommand("if controller and controller.getController('vehicleController') then controller.getController('vehicleController').smartParkingBrake(0) end")
                    end
                    
                end
                if im.CollapsingHeader1("Electric Editor & Info") then
                    -- Раздел 2: Мониторинг параметров Electrics
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "All Vehicle Electrics Monitor:")
                    
                    -- Системные действия
                    if im.Button("Initialize Electrics (init)") then
                        v:queueLuaCommand("electrics.init()")
                    end
                    im.SameLine()
                    if im.Button("Reset Electrics (reset)") then
                        v:queueLuaCommand("electrics.reset()")
                    end
                    im.Text("Filter:")
                    im.SameLine()
                    im.SetNextItemWidth(250)
                    im.InputText("##FilterElec", _G.CheatMenu_ElectricsFilter)
                    
                    local searchStr = string.lower(ffi.string(_G.CheatMenu_ElectricsFilter))
                    local elecValues = _G.CheatMenuWindow_Data.electrics[vehId]
                    
                    if not elecValues or next(elecValues) == nil then
                        im.Text("Waiting for electrics telemetry from vehicle...")
                    else
                        local sortedKeys = {}
                        for k in pairs(elecValues) do
                            table.insert(sortedKeys, k)
                        end
                        table.sort(sortedKeys)
                        
                        im.BeginChild1("ElectricsScrollArea", im.ImVec2(0, 350), true, 0)
                        
                        im.Columns(3, "elec_layout_cols", true)
                        im.SetColumnWidth(0, 220) -- Название и сброс
                        im.SetColumnWidth(1, 180) -- Редактор
                        im.SetColumnWidth(2, 100) -- Заморозка
                        
                        im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Parameter Name")
                        im.NextColumn()
                        im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Edit Value")
                        im.NextColumn()
                        im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Freeze")
                        im.Separator()
                        im.NextColumn()
                        
                        for _, key in ipairs(sortedKeys) do
                            local matchesFilter = true
                            if searchStr ~= "" then
                                if not string.find(string.lower(key), searchStr) then
                                    matchesFilter = false
                                end
                            end
                            
                            if matchesFilter then
                                local val = elecValues[key]
                                
                                -- Сохраняем самое первое увиденное значение как заводское
                                if _G.CheatMenuWindow_Data.electrics_defaults[vehId][key] == nil then
                                    _G.CheatMenuWindow_Data.electrics_defaults[vehId][key] = val
                                end
                                
                                -- КОЛОНКА 1: Кнопка Сброса и Имя параметра
                                if im.Button("RES##res_elec_" .. key, im.ImVec2(32, 19)) then
                                    local defaultVal = _G.CheatMenuWindow_Data.electrics_defaults[vehId][key]
                                    if defaultVal ~= nil then
                                        -- Возвращаем дефолт в интерфейсные указатели
                                        if type(defaultVal) == "boolean" then
                                            getPtr(vehId, "edit_elec_" .. key, defaultVal, "BoolPtr")[0] = defaultVal
                                        elseif type(defaultVal) == "number" then
                                            getPtr(vehId, "edit_elec_" .. key, defaultVal, "FloatPtr")[0] = defaultVal
                                        else
                                            ffi.copy(getStringPtr(vehId, "edit_elec_" .. key, defaultVal), tostring(defaultVal))
                                        end
                                        
                                        getPtr(vehId, "freeze_elec_" .. key, false, "BoolPtr")[0] = false
                                        
                                        -- Отправляем сброс и снятие заморозки в машину
                                        local valStr = tostring(defaultVal)
                                        if type(defaultVal) == "string" then valStr = string.format("'%s'", defaultVal) end
                                        v:queueLuaCommand(string.format([[
                                            if _G.CheatMenu_FrozenElectrics then _G.CheatMenu_FrozenElectrics['%s'] = nil end
                                            electrics.values['%s'] = %s
                                        ]], key, key, valStr))
                                    end
                                end
                                im.SameLine()
                                im.Text(key)
                                im.NextColumn()
                                
                                -- КОЛОНКА 2: Поле ввода (в зависимости от типа данных)
                                local isFrozenPtr = getPtr(vehId, "freeze_elec_" .. key, false, "BoolPtr")
                                
                                if type(val) == "boolean" then
                                    local ptr = getPtr(vehId, "edit_elec_" .. key, val, "BoolPtr")
                                    if not im.IsItemActive() and not isFrozenPtr[0] then
                                        ptr[0] = val
                                    end
                                    if im.Checkbox("##bool_elec_" .. key, ptr) then
                                        local cmdVal = tostring(ptr[0])
                                        v:queueLuaCommand(string.format("electrics.values['%s'] = %s", key, cmdVal))
                                        if isFrozenPtr[0] then
                                            v:queueLuaCommand(string.format("_G.CheatMenu_FrozenElectrics['%s'] = %s", key, cmdVal))
                                        end
                                    end
                                    
                                elseif type(val) == "number" then
                                    local ptr = getPtr(vehId, "edit_elec_" .. key, val, "FloatPtr")
                                    if not im.IsItemActive() and not isFrozenPtr[0] then
                                        ptr[0] = val
                                    end
                                    im.SetNextItemWidth(-1)
                                    if im.InputFloat("##num_elec_" .. key, ptr, 1.0, 10.0, "%.4f") then
                                        v:queueLuaCommand(string.format("electrics.values['%s'] = %f", key, ptr[0]))
                                        if isFrozenPtr[0] then
                                            v:queueLuaCommand(string.format("_G.CheatMenu_FrozenElectrics['%s'] = %f", key, ptr[0]))
                                        end
                                    end
                                    
                                else -- Текстовое значение (string)
                                    local ptr = getStringPtr(vehId, "edit_elec_" .. key, val)
                                    if not im.IsItemActive() and not isFrozenPtr[0] then
                                        ffi.copy(ptr, tostring(val))
                                    end
                                    im.SetNextItemWidth(-1)
                                    if im.InputText("##str_elec_" .. key, ptr) then
                                        local strVal = ffi.string(ptr)
                                        v:queueLuaCommand(string.format("electrics.values['%s'] = '%s'", key, strVal))
                                        if isFrozenPtr[0] then
                                            v:queueLuaCommand(string.format("_G.CheatMenu_FrozenElectrics['%s'] = '%s'", key, strVal))
                                        end
                                    end
                                end
                                im.NextColumn()
                                
                                -- КОЛОНКА 3: Галочка Заморозки (Тройной каскадный перехват)
                                if im.Checkbox("##freeze_elec_" .. key, isFrozenPtr) then
                                    if isFrozenPtr[0] then
                                        -- Сборка значения из редакторов для жесткой фиксации
                                        local valToFreeze
                                        if type(val) == "boolean" then
                                            valToFreeze = tostring(getPtr(vehId, "edit_elec_" .. key, val, "BoolPtr")[0])
                                        elseif type(val) == "number" then
                                            valToFreeze = tostring(getPtr(vehId, "edit_elec_" .. key, val, "FloatPtr")[0])
                                        else
                                            valToFreeze = string.format("'%s'", ffi.string(getStringPtr(vehId, "edit_elec_" .. key, val)))
                                        end
                                        
                                        -- Навешиваем тройной хук перехвата на стороне машины
                                        v:queueLuaCommand(string.format([[
                                            -- 1. Перехват физического шага (для трансмиссии, ABS и т.д.)
                                            if not electrics._originalUpdate then
                                                electrics._originalUpdate = electrics.update
                                                electrics.update = function(dt)
                                                    electrics._originalUpdate(dt)
                                                    if _G.CheatMenu_FrozenElectrics then
                                                        for k, v in pairs(_G.CheatMenu_FrozenElectrics) do
                                                            electrics.values[k] = v
                                                        end
                                                    end
                                                end
                                            end

                                            -- 2. Перехват графического шага (для стрелок приборов и UI-приложений)
                                            if not electrics._originalUpdateGFX then
                                                electrics._originalUpdateGFX = electrics.updateGFX or function() end
                                                electrics.updateGFX = function(dt)
                                                    electrics._originalUpdateGFX(dt)
                                                    if _G.CheatMenu_FrozenElectrics then
                                                        for k, v in pairs(_G.CheatMenu_FrozenElectrics) do
                                                            electrics.values[k] = v
                                                        end
                                                    end
                                                end
                                            end

                                            -- 3. Перехват на уровне вашего чит-модуля (как самый поздний рубеж фиксации)
                                            if CheatMenuM then
                                                if not CheatMenuM._originalUpdateGFX then
                                                    CheatMenuM._originalUpdateGFX = CheatMenuM.updateGFX or function() end
                                                    CheatMenuM.updateGFX = function(dt)
                                                        CheatMenuM._originalUpdateGFX(dt)
                                                        if _G.CheatMenu_FrozenElectrics then
                                                            for k, v in pairs(_G.CheatMenu_FrozenElectrics) do
                                                                electrics.values[k] = v
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            _G.CheatMenu_FrozenElectrics = _G.CheatMenu_FrozenElectrics or {}
                                            _G.CheatMenu_FrozenElectrics['%s'] = %s
                                        ]], key, valToFreeze))
                                    else
                                        -- Удаление значения из списка активных заморозок
                                        v:queueLuaCommand(string.format([[
                                            if _G.CheatMenu_FrozenElectrics then
                                                _G.CheatMenu_FrozenElectrics['%s'] = nil
                                            end
                                        ]], key))
                                    end
                                end
                                im.NextColumn()
                            end
                        end
                        
                        im.Columns(1)
                        im.EndChild()
                    end
                    
                    
                end

            -- УСТРОЙСТВА ТРАНСМИССИИ (powertrain)
                if im.CollapsingHeader1("Thermals Editor & Info") then
                    im.Text(string.format("Radiator Fan: %.1f RPM", vehState.radiatorFanSpin or 0.0))
                    -- Вспомогательная функция для красивого отображения названий температур
                    local function getFriendlyTempName(key)
                        if key == "mainEngine.thermals.coolantTemperature" then
                            return "Water Temp (coolantTemperature)"
                        elseif key == "mainEngine.thermals.oilTemperature" then
                            return "Oil Temp (oilTemperature)"
                        elseif key == "mainEngine.thermals.engineBlockTemperature" then
                            return "Engine Block Temp"
                        elseif key == "mainEngine.thermals.cylinderWallTemperature" then
                            return "Cylinder Wall Temp"
                        elseif key == "mainEngine.thermals.exhaustTemperature" then
                            return "Exhaust Temp"
                        end
                        
                        -- Форматируем тормоза колес для красоты
                        if string.find(key, "^wheel%.") then
                            local parts = {}
                            for part in string.gmatch(key, "[^%.]+") do table.insert(parts, part) end
                            if parts[2] and parts[4] then
                                local label = parts[2] .. " Brake "
                                if parts[4] == "brakeCoreTemperature" then
                                    return label .. "Core Temp"
                                elseif parts[4] == "brakeSurfaceTemperature" then
                                    return label .. "Surface Temp"
                                end
                            end
                        end
                        return key
                    end

                    -- УПРАВЛЕНИЕ ТЕМПЕРАТУРАМИ (Универсальный слайдер-редактор с умным поиском и заморозкой)
                    if vehState.engineThermals and next(vehState.engineThermals) then
                        im.Text("Search Temperature Sensor:")
                        im.InputText("##TempSearch", tempFilterText)
                        local searchStr = string.lower(ffi.string(tempFilterText))
                                                
                        -- Сортируем ключи по алфавиту, чтобы поля не прыгали
                        local sortedTempKeys = {}
                        for k in pairs(vehState.engineThermals) do table.insert(sortedTempKeys, k) end
                        table.sort(sortedTempKeys)
                        
                        for _, tempKey in ipairs(sortedTempKeys) do
                            local friendlyName = getFriendlyTempName(tempKey)
                            
                            -- Умная фильтрация по поисковому запросу и синонимам (теперь поддерживает слитные watertemp и oiltemp)
                            local match = true
                            if searchStr ~= "" then
                                local searchIn = string.lower(tempKey .. " " .. friendlyName .. " вода ож охлаждающая водяной масло watertemp oiltemp")
                                if not string.find(searchIn, searchStr) then
                                    match = false
                                end
                            end
                            
                            if match then
                                local tempVal = vehState.engineThermals[tempKey]
                                local tempPtr = getPtr(vehId, "edit_temp_" .. tempKey, tempVal, "FloatPtr")
                                
                                -- Получаем указатель на статус заморозки этой температуры
                                local isFrozenPtr = getPtr(vehId, "freeze_temp_" .. tempKey, false, "BoolPtr")
                                
                                -- Обновляем положение слайдера, только если пользователь его не тянет и температура не заморожена
                                if not im.IsItemActive() and not isFrozenPtr[0] then
                                    tempPtr[0] = tempVal
                                end
                                
                                -- Кнопка быстрого сброса на оптимальную температуру (90 градусов)
                                if im.Button("RES##res_" .. tempKey, im.ImVec2(30, 0)) then
                                    tempPtr[0] = 90.0
                                    v:queueLuaCommand(string.format("CheatMenuM.setVehicleThermal('%s', 90.0)", tempKey))
                                    if isFrozenPtr[0] then
                                        v:queueLuaCommand(string.format("if CheatMenuM.frozenThermals then CheatMenuM.frozenThermals['%s'] = 90.0 end", tempKey))
                                    end
                                end
                                im.SameLine()
                                
                                -- Слайдер температуры от -50 до 1500 градусов
                                im.SetNextItemWidth(220)
                                local changed = im.SliderFloat(friendlyName .. "##slider_" .. tempKey, tempPtr, -50.0, 1500.0, "%.1f")
                                if changed then
                                    v:queueLuaCommand(string.format("CheatMenuM.setVehicleThermal('%s', %f)", tempKey, tempPtr[0]))
                                    if isFrozenPtr[0] then
                                        v:queueLuaCommand(string.format("if CheatMenuM.frozenThermals then CheatMenuM.frozenThermals['%s'] = %f end", tempKey, tempPtr[0]))
                                    end
                                end
                                
                                -- Галочка удержания / заморозки температуры
                                im.SameLine()
                                if im.Checkbox("Freeze##freeze_" .. tempKey, isFrozenPtr) then
                                    if isFrozenPtr[0] then
                                        v:queueLuaCommand(string.format("if not CheatMenuM.frozenThermals then CheatMenuM.frozenThermals = {} end; CheatMenuM.frozenThermals['%s'] = %f", tempKey, tempPtr[0]))
                                    else
                                        v:queueLuaCommand(string.format("if CheatMenuM.frozenThermals then CheatMenuM.frozenThermals['%s'] = nil end", tempKey))
                                    end
                                end
                            end
                        end
                    end
                    
                    if im.Button("Reset Engine Temperatures", im.ImVec2(-1, 0)) then
                        -- Отключаем все галочки заморозки в интерфейсе для температур
                        if vehState.engineThermals then
                            for k in pairs(vehState.engineThermals) do
                                getPtr(vehId, "freeze_temp_" .. k, false, "BoolPtr")[0] = false
                            end
                        end
                        -- Очищаем заморозку на стороне машины и сбрасываем термодинамику всех систем
                        v:queueLuaCommand([[
                            CheatMenuM.frozenThermals = {}
                            if powertrain and powertrain.getDevices then
                                for _, d in pairs(powertrain.getDevices()) do
                                    if d.thermals and d.thermals.reset then d.thermals:reset() end
                                end
                            end
                        ]])
                    end
                    
                    if im.Button("Blow Head Gasket (Punch the cylinder head)", im.ImVec2(300, 0)) then
                        v:queueLuaCommand("damageTracker.setDamage('engine', 'headGasketDamaged', true)")
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals then eng.thermals.headGasketBlown = true end")
                    end
                    im.SameLine()
                    if im.Button("Radiator Leak", im.ImVec2(120, 0)) then
                        v:queueLuaCommand('damageTracker.setDamage("engine", "radiatorLeak", true)')
                    end
                    if im.Button("Explode Engine##f_eng_boom", im.ImVec2(150, 0)) then
                        v:queueLuaCommand([[
                            local eng = powertrain.getDevice("mainEngine")
                            if eng then
                                local ecid = eng.engineNodeID or (v.data.refNodes and v.data.refNodes[0] and v.data.refNodes[0].ref) or 0
                                sounds.playSoundOnceFollowNode("event:>Vehicle>Fire>Fire_Ignition", ecid, 4)
                                for _, e in pairs(powertrain.getDevicesByCategory("engine")) do if e.lockUp then e:lockUp() end end
                                if fire and fire.igniteNode then fire.igniteNode(ecid) end
                            end
                        ]])
                    end
                    im.SameLine()
                    if im.Button("Seize Engine##f_eng_seize", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("for _, e in pairs(powertrain.getDevicesByCategory('engine')) do if e.lockUp then e:lockUp() end end; damageTracker.setDamage('engine', 'engineLockedUp', true)")
                    end
                    im.SameLine()
                    if im.Button("Damage Rod Bearings##f_eng_rod", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng then eng.rodBearingsDamaged = true; damageTracker.setDamage('engine', 'connectingRodBearingsDamaged', true) end")
                    end

                    if im.Button("Blow Head Gasket##f_eng_gasket", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals and eng.thermals.setPartConditionThermals then eng.thermals.setPartConditionThermals(0, {headGasketBlown = true}, nil) end; damageTracker.setDamage('engine', 'headGasketDamaged', true)")
                    end
                    im.SameLine()
                    if im.Button("Damage Piston Rings##f_eng_rings", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals and eng.thermals.setPartConditionThermals then eng.thermals.setPartConditionThermals(0, {pistonRingsDamaged = true}, nil) end; damageTracker.setDamage('engine', 'pistonRingsDamaged', true)")
                    end
                    im.SameLine()
                    if im.Button("Destroy Turbocharger##f_eng_turbo", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.turbocharger then eng.turbocharger.isBroken = true end")
                    end
                    if im.Button("Puncture Radiator##f_rad_leak", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals and eng.thermals.applyDeformGroupDamageRadiator then eng.thermals.applyDeformGroupDamageRadiator(1) end; damageTracker.setDamage('engine', 'radiatorLeak', true)")
                    end
                    im.SameLine()
                    if im.Button("Puncture Oil Pan##f_oil_leak", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals and eng.thermals.applyDeformGroupDamageOilpan then eng.thermals.applyDeformGroupDamageOilpan(1) end; damageTracker.setDamage('engine', 'oilpanLeak', true)")
                    end
                    im.SameLine()
                    if im.Button("Zero Oil Pressure##f_oil_zero", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals then eng.thermals.oilMass = 0; eng.thermals.oilVolume = 0 end; electrics.values.oilLowPressure = 1")
                    end

                    if im.Button("Overheat Coolant##f_cool_boil", im.ImVec2(150, 0)) then
                        v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals then eng.thermals.coolantTemperature = 300 end; damageTracker.setDamage('engine', 'coolantOverheating', true)")
                    end
                end
            if im.CollapsingHeader1("Powertrain Devices Editor & Info") then
                if vehState.powertrainDevices and next(vehState.powertrainDevices) then
                    -- Поле ввода строки поиска
                    im.Text("Search Powertrain Device or Parameter:")
                    im.InputText("##PowertrainSearch", powertrainFilterText)
                    local searchStr = string.lower(ffi.string(powertrainFilterText))
                    
                    for devName, dData in pairs(vehState.powertrainDevices) do
                        
                        -- 1. Проверяем совпадение с именем устройства или его типом
                        local nameMatches = false
                        if searchStr ~= "" then
                            local searchIn = string.lower(devName .. " " .. (dData.type or ""))
                            if string.find(searchIn, searchStr) then
                                nameMatches = true
                            end
                        end
                        
                        -- 2. Проверяем, есть ли совпадения с параметрами внутри устройства
                        local propMatches = false
                        local matchedProps = {}
                        
                        if dData.props then
                            for propName in pairs(dData.props) do
                                local pNameLower = string.lower(propName)
                                if searchStr == "" or string.find(pNameLower, searchStr) then
                                    propMatches = true
                                    matchedProps[propName] = true
                                end
                            end
                        end
                        
                        -- Показываем устройство, если совпало его имя, тип ИЛИ хотя бы одно внутреннее свойство
                        local match = (searchStr == "") or nameMatches or propMatches
                        
                        if match then
                            -- Используем нативный заголовок
                            if im.CollapsingHeader1(devName .. " (" .. dData.type .. ")##tree_" .. devName) then
                                im.Text("Status: " .. (dData.isBroken and "BROKEN" or "OK"))
                                
                                -- 1. Кнопка безопасной поломки (с защитой от отсутствия onBreak)
                                im.SameLine()
                                if im.Button("Break Device##break_" .. devName) then
                                    v:queueLuaCommand(string.format("local d = powertrain.getDevice('%s'); if d then if not d.onBreak then d.onBreak = function() end end powertrain.breakDevice(d) end", devName))
                                end
                                
                                -- 2. Кнопка восстановления сломанной детали (с безопасным сбросом ДВС)
                                im.SameLine()
                                if im.Button("Repair##repair_" .. devName) then
                                    v:queueLuaCommand(string.format([[
                                        local d = powertrain.getDevice('%s')
                                        if d then
                                            d.isBroken = false
                                            if d.type == 'combustionEngine' then
                                                if d.thermals and d.thermals.reset then d.thermals:reset() end
                                            elseif d.reset then
                                                d:reset(d.jbeamData or {})
                                            end
                                        end
                                    ]], devName))
                                end
                                
                                -- 3. Кнопка полного сброса параметров к заводским (с безопасным сбросом ДВС)
                                im.SameLine()
                                if im.Button("Reset Defaults##reset_" .. devName) then
                                    -- Сбрасываем галочки заморозки в интерфейсе для этой детали
                                    if dData.props then
                                        for k in pairs(dData.props) do
                                            getPtr(vehId, "freeze_" .. devName .. "_" .. k, false, "BoolPtr")[0] = false
                                        end
                                    end
                                    -- Отправляем команду сброса параметров и очистки заморозки на машину
                                    v:queueLuaCommand(string.format([[
                                        if CheatMenuM.frozenProperties then CheatMenuM.frozenProperties['%s'] = nil end
                                        local d = powertrain.getDevice('%s')
                                        local def = CheatMenuM.powertrainDefaults and CheatMenuM.powertrainDefaults['%s']
                                        if d and def then
                                            for k, v in pairs(def) do d[k] = v end
                                            d.isBroken = false
                                            if d.type == 'combustionEngine' then
                                                if d.thermals and d.thermals.reset then d.thermals:reset() end
                                            elseif d.reset then
                                                d:reset(d.jbeamData or {})
                                            end
                                        end
                                    ]], devName, devName, devName))
                                end
                                
                                -- 4. Свойства отображаются СРАЗУ, отделяясь линией
                                if dData.props and next(dData.props) then
                                    im.Separator()
                                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Adjustable Properties:")
                                    
                                    -- Формируем отфильтрованный список ключей
                                    local sortedKeys = {}
                                    for k in pairs(dData.props) do
                                        -- Если совпало имя устройства, поиск пустой или совпало конкретное свойство
                                        if searchStr == "" or nameMatches or matchedProps[k] then
                                            table.insert(sortedKeys, k)
                                        end
                                    end
                                    table.sort(sortedKeys)
                                    
                                    -- Получаем заводские параметры для этой детали
                                    local defProps = vehState.powertrainDefaults and vehState.powertrainDefaults[devName]
                                    
                                    for _, propName in ipairs(sortedKeys) do
                                        local propValue = dData.props[propName]
                                        local pType = type(propValue)
                                        local defaultVal = defProps and defProps[propName]
                                        
                                        if pType == "number" then
                                            local pPtr = getPtr(vehId, "dev_" .. devName .. "_" .. propName, propValue, "FloatPtr")
                                            if not im.IsItemActive() then
                                                pPtr[0] = propValue
                                            end
                                            
                                            -- Кнопка сброса (RES)
                                            if defaultVal ~= nil then
                                                if im.Button("RES##res_" .. devName .. "_" .. propName, im.ImVec2(30, 0)) then
                                                    pPtr[0] = defaultVal
                                                    v:queueLuaCommand(string.format("CheatMenuM.setDeviceProperty('%s', '%s', %f)", devName, propName, defaultVal))
                                                    local isFrozenPtr = getPtr(vehId, "freeze_" .. devName .. "_" .. propName, false, "BoolPtr")
                                                    if isFrozenPtr[0] then
                                                        v:queueLuaCommand(string.format("if CheatMenuM.frozenProperties and CheatMenuM.frozenProperties['%s'] then CheatMenuM.frozenProperties['%s']['%s'] = %f end", devName, devName, propName, defaultVal))
                                                    end
                                                end
                                                im.SameLine()
                                            end
                                            
                                            im.SetNextItemWidth(150)
                                            local changed = im.InputFloat(propName .. "##f_" .. devName .. "_" .. propName, pPtr, 0.1, 1.0, "%.3f")
                                            if changed then
                                                v:queueLuaCommand(string.format("CheatMenuM.setDeviceProperty('%s', '%s', %f)", devName, propName, pPtr[0]))
                                                local isFrozenPtr = getPtr(vehId, "freeze_" .. devName .. "_" .. propName, false, "BoolPtr")
                                                if isFrozenPtr[0] then
                                                    v:queueLuaCommand(string.format("if CheatMenuM.frozenProperties and CheatMenuM.frozenProperties['%s'] then CheatMenuM.frozenProperties['%s']['%s'] = %f end", devName, devName, propName, pPtr[0]))
                                                end
                                            end
                                            
                                            -- Галочка "Заморозить"
                                            im.SameLine()
                                            local isFrozenPtr = getPtr(vehId, "freeze_" .. devName .. "_" .. propName, false, "BoolPtr")
                                            if im.Checkbox("Freeze##freeze_" .. devName .. "_" .. propName, isFrozenPtr) then
                                                if isFrozenPtr[0] then
                                                    v:queueLuaCommand(string.format("if not CheatMenuM.frozenProperties then CheatMenuM.frozenProperties = {} end; if not CheatMenuM.frozenProperties['%s'] then CheatMenuM.frozenProperties['%s'] = {} end; CheatMenuM.frozenProperties['%s']['%s'] = %f", devName, devName, devName, propName, pPtr[0]))
                                                else
                                                    v:queueLuaCommand(string.format("if CheatMenuM.frozenProperties and CheatMenuM.frozenProperties['%s'] then CheatMenuM.frozenProperties['%s']['%s'] = nil end", devName, devName, propName))
                                                end
                                            end
                                            
                                        elseif pType == "boolean" then
                                            local pPtr = getPtr(vehId, "dev_" .. devName .. "_" .. propName, propValue, "BoolPtr")
                                            if not im.IsItemActive() then
                                                pPtr[0] = propValue
                                            end
                                            
                                            -- Кнопка сброса (RES)
                                            if defaultVal ~= nil then
                                                if im.Button("RES##res_" .. devName .. "_" .. propName, im.ImVec2(30, 0)) then
                                                    pPtr[0] = defaultVal
                                                    v:queueLuaCommand(string.format("CheatMenuM.setDeviceProperty('%s', '%s', %s)", devName, propName, tostring(defaultVal)))
                                                    local isFrozenPtr = getPtr(vehId, "freeze_" .. devName .. "_" .. propName, false, "BoolPtr")
                                                    if isFrozenPtr[0] then
                                                        v:queueLuaCommand(string.format("if CheatMenuM.frozenProperties and CheatMenuM.frozenProperties['%s'] then CheatMenuM.frozenProperties['%s']['%s'] = %s end", devName, devName, propName, tostring(defaultVal)))
                                                    end
                                                end
                                                im.SameLine()
                                            end
                                            
                                            local changed = im.Checkbox(propName .. "##b_" .. devName .. "_" .. propName, pPtr)
                                            if changed then
                                                v:queueLuaCommand(string.format("CheatMenuM.setDeviceProperty('%s', '%s', %s)", devName, propName, tostring(pPtr[0])))
                                                local isFrozenPtr = getPtr(vehId, "freeze_" .. devName .. "_" .. propName, false, "BoolPtr")
                                                if isFrozenPtr[0] then
                                                    v:queueLuaCommand(string.format("if CheatMenuM.frozenProperties and CheatMenuM.frozenProperties['%s'] then CheatMenuM.frozenProperties['%s']['%s'] = %s end", devName, devName, propName, tostring(pPtr[0])))
                                                end
                                            end
                                            
                                            -- Галочка "Заморозить"
                                            im.SameLine()
                                            local isFrozenPtr = getPtr(vehId, "freeze_" .. devName .. "_" .. propName, false, "BoolPtr")
                                            if im.Checkbox("Freeze##freeze_" .. devName .. "_" .. propName, isFrozenPtr) then
                                                if isFrozenPtr[0] then
                                                    v:queueLuaCommand(string.format("if not CheatMenuM.frozenProperties then CheatMenuM.frozenProperties = {} end; if not CheatMenuM.frozenProperties['%s'] then CheatMenuM.frozenProperties['%s'] = {} end; CheatMenuM.frozenProperties['%s']['%s'] = %s", devName, devName, devName, propName, tostring(pPtr[0])))
                                                else
                                                    v:queueLuaCommand(string.format("if CheatMenuM.frozenProperties and CheatMenuM.frozenProperties['%s'] then CheatMenuM.frozenProperties['%s']['%s'] = nil end", devName, devName, propName))
                                                end
                                            end
                                            
                                        elseif pType == "string" then
                                            im.Text(propName .. ": " .. tostring(propValue))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if im.CollapsingHeader1("Parts Strength Editor (beamStrength) (Stable method)##part_str_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Vehicle Parts Durability & Strength Control:")
                im.Text("Adjust beamStrength globally for all parts or fine-tune individual components.")
                -- 2. СПИСОК ВСЕХ НАЙДЕННЫХ ДЕТАЛЕЙ С ИНДИВИДУАЛЬНОЙ НАСТРОЙКОЙ
                renderSliderWithReset("Strength Multiplier(STABLE, for parts)", "globalStrengthMult", 0.001, 9999999999999999999999900.0, 1.0, "applyGlobalBeamStrengthMult", "%.2f", true)
            
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Individual Parts Strength List:")
                im.Text("Search Component:")
                im.SameLine()
                im.SetNextItemWidth(200)
                im.InputText("##PartStrSearch", _G.CheatMenu_PartStrengthFilter)
                
                local searchStr = string.lower(ffi.string(_G.CheatMenu_PartStrengthFilter))
                local partList = vehState.partStrengthsList or {}

                if #partList == 0 then
                    im.Text("Scanning vehicle parts durability data...")
                    if im.Button("Rescan Parts Strength##btn_rescan_str") then
                        v:queueLuaCommand("CheatMenuM.scanPartBeamStrengths()")
                    end
                else
                    im.BeginChild1("PartsStrengthScrollArea", im.ImVec2(0, 350), true, 0)
                    
                    for _, partInfo in ipairs(partList) do
                        local pName = partInfo.name
                        local pFriendly = (partInfo.friendly and partInfo.friendly ~= "") and partInfo.friendly or pName
                        
                        -- Фильтрация по поисковой строке
                        local match = true
                        if searchStr ~= "" then
                            local searchIn = string.lower(pName .. " " .. pFriendly)
                            if not string.find(searchIn, searchStr) then
                                match = false
                            end
                        end
                        
                        if match then
                            -- Считываем актуальный множитель детали из состояния машины через syncPtr
                            local currentMult = partInfo.mult or 1.0
                            local pPtr = syncPtr(vehId, "pstr_" .. pName, currentMult, "FloatPtr")
                            
                            im.BeginGroup()
                            -- Кнопка сброса отдельной детали
                            if im.Button("RES##res_pstr_" .. pName, im.ImVec2(32, 20)) then
                                pPtr[0] = 1.0
                                _G.CheatMenu_LastWriteTimes[vehId .. ".pstr_" .. pName] = os.clock()
                                v:queueLuaCommand(string.format("CheatMenuM.applyPartBeamStrengthMult('%s', 1.0)", pName))
                            end
                            
                            im.SameLine()
                            im.SetNextItemWidth(200)
                            local pChanged = im.SliderFloat(pFriendly .. "##s_pstr_" .. pName, pPtr, 0.0, 9999999999999999999999900.0, "%.2fx", im.SliderFlags_Logarithmic)
                            
                            if pChanged then
                                _G.CheatMenu_LastWriteTimes[vehId .. ".pstr_" .. pName] = os.clock()
                                v:queueLuaCommand(string.format("CheatMenuM.applyPartBeamStrengthMult('%s', %f)", pName, pPtr[0]))
                            end
                            
                            if im.IsItemHovered() then
                                im.SetTooltip("Technical JBeam ID: " .. pName)
                            end
                            im.EndGroup()
                        end
                    end
                    
                    im.EndChild()
                end
            end
            if im.CollapsingHeader1("Individual Component Failures##all_failures_master") then
                im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "Complete Catalog of Vehicle Component Failures:")
                im.Text("Every single component, wheel, and axis can be broken individually:")
                im.Spacing()

                -- 1. ENGINE & POWERTRAIN
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "1. Engine & Internal Components:")

                if im.Button("Explode Engine##f_eng_boom", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local eng = powertrain.getDevice("mainEngine")
                        if eng then
                            local ecid = eng.engineNodeID or (v.data.refNodes and v.data.refNodes[0] and v.data.refNodes[0].ref) or 0
                            sounds.playSoundOnceFollowNode("event:>Vehicle>Fire>Fire_Ignition", ecid, 4)
                            for _, e in pairs(powertrain.getDevicesByCategory("engine")) do if e.lockUp then e:lockUp() end end
                            if fire and fire.igniteNode then fire.igniteNode(ecid) end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Seize Engine##f_eng_seize", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("for _, e in pairs(powertrain.getDevicesByCategory('engine')) do if e.lockUp then e:lockUp() end end; damageTracker.setDamage('engine', 'engineLockedUp', true)")
                end
                im.SameLine()
                if im.Button("Damage Rod Bearings##f_eng_rod", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng then eng.rodBearingsDamaged = true; damageTracker.setDamage('engine', 'connectingRodBearingsDamaged', true) end")
                end

                if im.Button("Blow Head Gasket##f_eng_gasket", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals and eng.thermals.setPartConditionThermals then eng.thermals.setPartConditionThermals(0, {headGasketBlown = true}, nil) end; damageTracker.setDamage('engine', 'headGasketDamaged', true)")
                end
                im.SameLine()
                if im.Button("Damage Piston Rings##f_eng_rings", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals and eng.thermals.setPartConditionThermals then eng.thermals.setPartConditionThermals(0, {pistonRingsDamaged = true}, nil) end; damageTracker.setDamage('engine', 'pistonRingsDamaged', true)")
                end
                im.SameLine()
                if im.Button("Destroy Turbocharger##f_eng_turbo", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.turbocharger then eng.turbocharger.isBroken = true end")
                end

                im.Separator()

                -- 2. COOLING, OIL & FUEL SYSTEMS
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "2. Cooling, Oil & Fuel Systems:")

                if im.Button("Puncture Radiator##f_rad_leak", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals and eng.thermals.applyDeformGroupDamageRadiator then eng.thermals.applyDeformGroupDamageRadiator(1) end; damageTracker.setDamage('engine', 'radiatorLeak', true)")
                end
                im.SameLine()
                if im.Button("Puncture Oil Pan##f_oil_leak", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals and eng.thermals.applyDeformGroupDamageOilpan then eng.thermals.applyDeformGroupDamageOilpan(1) end; damageTracker.setDamage('engine', 'oilpanLeak', true)")
                end
                im.SameLine()
                if im.Button("Zero Oil Pressure##f_oil_zero", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals then eng.thermals.oilMass = 0; eng.thermals.oilVolume = 0 end; electrics.values.oilLowPressure = 1")
                end

                if im.Button("Overheat Coolant##f_cool_boil", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.thermals then eng.thermals.coolantTemperature = 300 end; damageTracker.setDamage('engine', 'coolantOverheating', true)")
                end
                im.SameLine()
                if im.Button("Leak Fuel Tank##f_fuel_leak", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("for _, s in pairs(energyStorage.getStorages()) do if s.type == 'fuelTank' then s.currentLeakRate = math.max(s.brokenLeakRate or 0, (s.remainingVolume or 10) / 8) end end")
                end

                im.Separator()

                -- 3. TRANSMISSION & DRIVETRAIN
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "3. Transmission & Drivetrain:")

                if im.Button("Destroy Gearbox##f_tr_gears", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("for _, d in pairs(powertrain.getDevicesByCategory('gearbox')) do d.isBroken = true end")
                end
                im.SameLine()
                if im.Button("Burn Clutch##f_tr_clutch", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("for _, d in pairs(powertrain.getDevices()) do if d.clutchTemperature ~= nil then d.clutchTemperature = 600; d.clutchEfficiency = 0 end end")
                end
                im.SameLine()
                if im.Button("Snap Driveshafts##f_tr_shaft", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("for _, d in pairs(powertrain.getDevices()) do if d.type == 'shaft' or d.type == 'driveshaft' then d.isBroken = true end end")
                end

                if im.Button("Break Differential##f_tr_diff", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("for _, d in pairs(powertrain.getDevicesByCategory('differential')) do d.isBroken = true end")
                end

                im.Separator()

                -- 4. BRAKES, STEERING & PEDALS
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "4. Brakes & Steering Controls:")

                if im.Button("Brake Loss: ALL##f_br_all", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do if wd.initialBrakeTorque then wd.brakeTorque = wd.initialBrakeTorque * 0.05 end end")
                end
                im.SameLine()
                if im.Button("Brake Loss: FRONT##f_br_front", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local ySum, count = 0, 0
                        for _, wd in pairs(wheels.wheels) do local n = v.data.nodes[wd.node1]; if n then ySum = ySum + n.pos.y; count = count + 1 end end
                        local centerY = (count > 0) and (ySum / count) or 0
                        for _, wd in pairs(wheels.wheels) do
                            local wPos = vec3(v.data.nodes[wd.node1].pos)
                            if wPos.y > centerY and wd.initialBrakeTorque then wd.brakeTorque = wd.initialBrakeTorque * 0.05 end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Brake Loss: REAR##f_br_rear", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local ySum, count = 0, 0
                        for _, wd in pairs(wheels.wheels) do local n = v.data.nodes[wd.node1]; if n then ySum = ySum + n.pos.y; count = count + 1 end end
                        local centerY = (count > 0) and (ySum / count) or 0
                        for _, wd in pairs(wheels.wheels) do
                            local wPos = vec3(v.data.nodes[wd.node1].pos)
                            if wPos.y <= centerY and wd.initialBrakeTorque then wd.brakeTorque = wd.initialBrakeTorque * 0.05 end
                        end
                    ]])
                end

                if im.Button("Overheat Brakes##f_br_fade", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do wd.brakeSurfaceTemperature = 1000; wd.brakeCoreTemperature = 1000 end")
                end
                im.SameLine()
                if im.Button("Steering Hydro Failure##f_st_hydro", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local nop = function() end
                        for _, h in ipairs(hydros.hydros or {}) do
                            if h.inputSource == "steering_input" then
                                h.fsetRelDisplacement = nop
                                h.fsetRelDeformedDisplacement = nop
                                if h.beamCID then obj:setBeamSpringDamp(h.beamCID, 0, 10, -1, -1) end
                            end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Stuck Throttle 100%##f_ped_th100", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("electrics.values.throttleOverride = 1.0")
                end

                if im.Button("Stuck Throttle 50%##f_ped_th50", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("electrics.values.throttleOverride = 0.5")
                end
                im.SameLine()
                if im.Button("Release Throttle##f_ped_th0", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("electrics.values.throttleOverride = nil")
                end

                im.Separator()

                -- 5. TIRES & WHEELS (INDIVIDUAL PER-WHEEL)
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "5. Tire Blowouts (Instant):")
                if im.Button("Pop All##f_tp_all", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do beamstate.deflateTire(wd.cid) end")
                end
                im.SameLine()
                if im.Button("Pop FL##f_tp_fl", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if n:find('fl') or n:find('frontleft') then beamstate.deflateTire(wd.cid) end end")
                end
                im.SameLine()
                if im.Button("Pop FR##f_tp_fr", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if n:find('fr') or n:find('frontright') then beamstate.deflateTire(wd.cid) end end")
                end
                im.SameLine()
                if im.Button("Pop RL##f_tp_rl", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if n:find('rl') or n:find('rearleft') then beamstate.deflateTire(wd.cid) end end")
                end
                im.SameLine()
                if im.Button("Pop RR##f_tp_rr", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if n:find('rr') or n:find('rearright') then beamstate.deflateTire(wd.cid) end end")
                end

                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Slow Punctures:")
                if im.Button("Puncture All##f_punc_all", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do if not wd.isTireDeflated and wd.pressureGroup then wd.punctureLeakRate = 2000; wd.isPunctured = true end end")
                end
                im.SameLine()
                if im.Button("Puncture FL##f_punc_fl", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if (n:find('fl') or n:find('frontleft')) and wd.pressureGroup then wd.punctureLeakRate = 2000; wd.isPunctured = true end end")
                end
                im.SameLine()
                if im.Button("Puncture FR##f_punc_fr", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if (n:find('fr') or n:find('frontright')) and wd.pressureGroup then wd.punctureLeakRate = 2000; wd.isPunctured = true end end")
                end
                im.SameLine()
                if im.Button("Puncture RL##f_punc_rl", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if (n:find('rl') or n:find('rearleft')) and wd.pressureGroup then wd.punctureLeakRate = 2000; wd.isPunctured = true end end")
                end
                im.SameLine()
                if im.Button("Puncture RR##f_punc_rr", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if (n:find('rr') or n:find('rearright')) and wd.pressureGroup then wd.punctureLeakRate = 2000; wd.isPunctured = true end end")
                end

                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Detach Wheels / Hubs:")
                if im.Button("Detach All##f_hub_all", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do beamstate.breakBreakGroup('wheel_' .. wd.name); beamstate.breakBreakGroup('hub_' .. wd.name) end")
                end
                im.SameLine()
                if im.Button("Detach FL##f_hub_fl", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if n:find('fl') or n:find('frontleft') then beamstate.breakBreakGroup('wheel_' .. wd.name); beamstate.breakBreakGroup('hub_' .. wd.name) end end")
                end
                im.SameLine()
                if im.Button("Detach FR##f_hub_fr", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if n:find('fr') or n:find('frontright') then beamstate.breakBreakGroup('wheel_' .. wd.name); beamstate.breakBreakGroup('hub_' .. wd.name) end end")
                end
                im.SameLine()
                if im.Button("Detach RL##f_hub_rl", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if n:find('rl') or n:find('rearleft') then beamstate.breakBreakGroup('wheel_' .. wd.name); beamstate.breakBreakGroup('hub_' .. wd.name) end end")
                end
                im.SameLine()
                if im.Button("Detach RR##f_hub_rr", im.ImVec2(110, 24)) then
                    v:queueLuaCommand("for _, wd in pairs(wheels.wheels) do local n = wd.name:lower(); if n:find('rr') or n:find('rearright') then beamstate.breakBreakGroup('wheel_' .. wd.name); beamstate.breakBreakGroup('hub_' .. wd.name) end end")
                end

                im.Separator()

                -- 6. SUSPENSION (SAFE & ACCURATE)
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "6. Suspension Failures:")

                if im.Button("Break All Springs##f_spring_all", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        for _, b in pairs(v.data.beams) do
                            local name = (b.name or ""):lower()
                            local part = (b.partOrigin or ""):lower()
                            if (part:find("coil") or part:find("spring") or part:find("strut") or name:find("spring")) and not part:find("arm") and not part:find("link") and not part:find("swaybar") then
                                obj:setBeamSpringDamp(b.cid, 0, b.beamDamp or 0, -1, -1)
                            end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Break Front Springs##f_spring_front", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local ySum, count = 0, 0
                        for _, wd in pairs(wheels.wheels) do local n = v.data.nodes[wd.node1]; if n then ySum = ySum + n.pos.y; count = count + 1 end end
                        local centerY = (count > 0) and (ySum / count) or 0
                        for _, b in pairs(v.data.beams) do
                            local name = (b.name or ""):lower()
                            local part = (b.partOrigin or ""):lower()
                            local n1 = v.data.nodes[b.id1]
                            if (part:find("coil") or part:find("spring") or part:find("strut") or name:find("spring")) and not part:find("arm") and not part:find("link") and not part:find("swaybar") then
                                if n1 and n1.pos.y > centerY then
                                    obj:setBeamSpringDamp(b.cid, 0, b.beamDamp or 0, -1, -1)
                                end
                            end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Break Rear Springs##f_spring_rear", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local ySum, count = 0, 0
                        for _, wd in pairs(wheels.wheels) do local n = v.data.nodes[wd.node1]; if n then ySum = ySum + n.pos.y; count = count + 1 end end
                        local centerY = (count > 0) and (ySum / count) or 0
                        for _, b in pairs(v.data.beams) do
                            local name = (b.name or ""):lower()
                            local part = (b.partOrigin or ""):lower()
                            local n1 = v.data.nodes[b.id1]
                            if (part:find("coil") or part:find("spring") or part:find("strut") or name:find("spring")) and not part:find("arm") and not part:find("link") and not part:find("swaybar") then
                                if n1 and n1.pos.y <= centerY then
                                    obj:setBeamSpringDamp(b.cid, 0, b.beamDamp or 0, -1, -1)
                                end
                            end
                        end
                    ]])
                end

                if im.Button("Blow All Dampers##f_damp_all", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        for _, b in pairs(v.data.beams) do
                            local name = (b.name or ""):lower()
                            local part = (b.partOrigin or ""):lower()
                            if part:find("shock") or part:find("damp") or name:find("damp") then
                                local vs = b.beamDampVelocitySplit or 1
                                obj:setBoundedBeamDamp(b.cid, 1, 1, 1, 1, vs, b.beamDampVelocitySplitRebound or vs)
                            end
                        end
                    ]])
                end

                im.Separator()

                -- 7. BODY & AERODYNAMICS
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "7. Body & Aerodynamics:")

                if im.Button("Pop Hood Latch##f_latch_hood", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        if v.data and v.data.beams then
                            for _, b in pairs(v.data.beams) do
                                if b.breakGroup then
                                    local bgs = type(b.breakGroup) == "table" and b.breakGroup or {b.breakGroup}
                                    for _, grp in ipairs(bgs) do
                                        local gName = tostring(grp):lower()
                                        if gName:find("hoodlatch") or gName:find("hood_latch") then beamstate.breakBreakGroup(grp) end
                                    end
                                end
                            end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Detach Spoiler / Wing##f_wing_pop", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        if v.data and v.data.beams then
                            for _, b in pairs(v.data.beams) do
                                if b.breakGroup then
                                    local bgs = type(b.breakGroup) == "table" and b.breakGroup or {b.breakGroup}
                                    for _, grp in ipairs(bgs) do
                                        if tostring(grp):lower():find("spoiler") then beamstate.breakBreakGroup(grp) end
                                    end
                                end
                            end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Disconnect Couplers##f_coupler_pop", im.ImVec2(180, 0)) then
                    v:queueLuaCommand("if beamstate and beamstate.breakAllCouplers then beamstate.breakAllCouplers() end")
                end

                im.Separator()

                -- 8. VEHICLE MELTING FEATURE (CRASH-FREE SAFE MELT)
                im.TextColored(im.ImVec4(0.9, 0.3, 0.9, 1.0), "8. Vehicle Melting Feature:")

                if im.Button("Melt Entire Vehicle##f_melt_all", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        if v.data and v.data.beams then
                            for _, b in pairs(v.data.beams) do
                                if b.cid then
                                    local origSpring = b.beamSpring or 50000
                                    obj:setBeamSpringDamp(b.cid, math.min(origSpring, 5000), 50, -1, -1)
                                    obj:setBeamLengthRefRatio(b.cid, 0.15)
                                end
                            end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Melt Front / Engine##f_melt_front", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local ySum, count = 0, 0
                        for _, wd in pairs(wheels.wheels) do local n = v.data.nodes[wd.node1]; if n then ySum = ySum + n.pos.y; count = count + 1 end end
                        local centerY = (count > 0) and (ySum / count) or 0
                        if v.data and v.data.beams then
                            for _, b in pairs(v.data.beams) do
                                local n1 = v.data.nodes[b.id1]
                                if n1 and n1.pos.y > centerY and b.cid then
                                    local origSpring = b.beamSpring or 50000
                                    obj:setBeamSpringDamp(b.cid, math.min(origSpring, 5000), 50, -1, -1)
                                    obj:setBeamLengthRefRatio(b.cid, 0.15)
                                end
                            end
                        end
                    ]])
                end
                im.SameLine()
                if im.Button("Melt Rear / Trunk##f_melt_rear", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local ySum, count = 0, 0
                        for _, wd in pairs(wheels.wheels) do local n = v.data.nodes[wd.node1]; if n then ySum = ySum + n.pos.y; count = count + 1 end end
                        local centerY = (count > 0) and (ySum / count) or 0
                        if v.data and v.data.beams then
                            for _, b in pairs(v.data.beams) do
                                local n1 = v.data.nodes[b.id1]
                                if n1 and n1.pos.y <= centerY and b.cid then
                                    local origSpring = b.beamSpring or 50000
                                    obj:setBeamSpringDamp(b.cid, math.min(origSpring, 5000), 50, -1, -1)
                                    obj:setBeamLengthRefRatio(b.cid, 0.15)
                                end
                            end
                        end
                    ]])
                end
                if im.Button("Break Rear Springs##f_spring_front", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local ref = (v.data.refNodes and v.data.refNodes[0] and v.data.refNodes[0].ref) or 0
                        local refPos = vec3(v.data.nodes[ref].pos)
                        for _, b in pairs(v.data.beams) do
                            local n1 = v.data.nodes[b.id1]
                            if b.wheelID == nil and type(b.beamSpring) == "number" and b.beamSpring >= 5000 and n1 and vec3(n1.pos).y > refPos.y then
                                obj:setBeamSpringDamp(b.cid, 0, b.beamDamp or 0, -1, -1)
                            end
                        end
                    ]])
                end
                if im.Button("Break Front Springs##f_spring_rear", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        local ref = (v.data.refNodes and v.data.refNodes[0] and v.data.refNodes[0].ref) or 0
                        local refPos = vec3(v.data.nodes[ref].pos)
                        for _, b in pairs(v.data.beams) do
                            local n1 = v.data.nodes[b.id1]
                            if b.wheelID == nil and type(b.beamSpring) == "number" and b.beamSpring >= 5000 and n1 and vec3(n1.pos).y <= refPos.y then
                                obj:setBeamSpringDamp(b.cid, 0, b.beamDamp or 0, -1, -1)
                            end
                        end
                    ]])
                end
                if im.Button("Blow ALL Shock Dampers##f_damp_all", im.ImVec2(180, 0)) then
                    v:queueLuaCommand([[
                        for _, b in pairs(v.data.beams) do
                            if b.wheelID == nil and b.beamType == 2 and (b.beamSpring or 0) == 0 then
                                local vs = b.beamDampVelocitySplit or 1
                                obj:setBoundedBeamDamp(b.cid, 1, 1, 1, 1, vs, b.beamDampVelocitySplitRebound or vs)
                            end
                        end
                    ]])
                end

                im.Separator()

                -- MASTER BUTTON
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.8, 0.2, 0.2, 1.0))
                if im.Button("TOTAL DESTRUCTION 1##f_master_destroy", im.ImVec2(-1, 30)) then
                    v:queueLuaCommand([[
                        for _, wd in pairs(wheels.wheels) do
                            beamstate.deflateTire(wd.cid)
                            beamstate.breakBreakGroup("wheel_" .. wd.name)
                            beamstate.breakBreakGroup("hub_" .. wd.name)
                            if wd.initialBrakeTorque then wd.brakeTorque = wd.initialBrakeTorque * 0.05 end
                        end
                        local eng = powertrain.getDevice("mainEngine")
                        if eng then
                            if eng.thermals then
                                if eng.thermals.applyDeformGroupDamageOilpan then eng.thermals.applyDeformGroupDamageOilpan(1) end
                                if eng.thermals.applyDeformGroupDamageRadiator then eng.thermals.applyDeformGroupDamageRadiator(1) end
                                if eng.thermals.setPartConditionThermals then eng.thermals.setPartConditionThermals(0, {headGasketBlown = true, pistonRingsDamaged = true}, nil) end
                            end
                            for _, e in pairs(powertrain.getDevicesByCategory("engine")) do if e.lockUp then e:lockUp() end end
                        end
                        for _, s in pairs(energyStorage.getStorages()) do if s.type == "fuelTank" then s.currentLeakRate = math.max(s.brokenLeakRate or 0, (s.remainingVolume or 10) / 8) end end
                        if beamstate and beamstate.breakAllCouplers then beamstate.breakAllCouplers() end
                    ]])
                end
                if im.Button("TOTAL DESTRUCTION 2##f_master_destroy", im.ImVec2(-1, 30)) then
                    v:queueLuaCommand([[
                        for _, wd in pairs(wheels.wheels) do
                            beamstate.deflateTire(wd.cid)
                            beamstate.breakBreakGroup("wheel_" .. wd.name)
                            beamstate.breakBreakGroup("hub_" .. wd.name)
                            if wd.initialBrakeTorque then wd.brakeTorque = wd.initialBrakeTorque * 0.05 end
                        end
                        local eng = powertrain.getDevice("mainEngine")
                        if eng then
                            if eng.thermals then
                                if eng.thermals.applyDeformGroupDamageOilpan then eng.thermals.applyDeformGroupDamageOilpan(1) end
                                if eng.thermals.applyDeformGroupDamageRadiator then eng.thermals.applyDeformGroupDamageRadiator(1) end
                                if eng.thermals.setPartConditionThermals then eng.thermals.setPartConditionThermals(0, {headGasketBlown = true, pistonRingsDamaged = true}, nil) end
                            end
                            for _, e in pairs(powertrain.getDevicesByCategory("engine")) do if e.lockUp then e:lockUp() end end
                        end
                        for _, s in pairs(energyStorage.getStorages()) do if s.type == "fuelTank" then s.currentLeakRate = math.max(s.brokenLeakRate or 0, (s.remainingVolume or 10) / 8) end end
                        for _, b in pairs(v.data.beams) do
                            if b.wheelID == nil and (b.beamType == 0 or b.beamType == 2) and type(b.beamSpring) == "number" and b.beamSpring >= 5000 then
                                obj:setBeamSpringDamp(b.cid, 0, 0, -1, -1)
                            end
                        end
                        if beamstate and beamstate.breakAllCouplers then beamstate.breakAllCouplers() end
                    ]])
                end
                if im.Button("TOTAL DESTRUCTION 3##f_master_destroy", im.ImVec2(-1, 30)) then
                    v:queueLuaCommand([[
                        for _, wd in pairs(wheels.wheels) do
                            beamstate.deflateTire(wd.cid)
                            beamstate.breakBreakGroup("wheel_" .. wd.name)
                            beamstate.breakBreakGroup("hub_" .. wd.name)
                            if wd.initialBrakeTorque then wd.brakeTorque = wd.initialBrakeTorque * 0.05 end
                        end
                        for _, s in pairs(energyStorage.getStorages()) do if s.type == "fuelTank" then s.currentLeakRate = math.max(s.brokenLeakRate or 0, (s.remainingVolume or 10) / 8) end end
                        for _, b in pairs(v.data.beams) do
                            if b.wheelID == nil and (b.beamType == 0 or b.beamType == 2) and type(b.beamSpring) == "number" and b.beamSpring >= 5000 then
                                obj:setBeamSpringDamp(b.cid, 1, 1, 1, 1)
                            end
                        end
                        if beamstate and beamstate.breakAllCouplers then beamstate.breakAllCouplers() end
                    ]])
                end
                -- Initialize global pointer for part softness
                if _G.CheatMenu_PartSoftnessMult == nil then
                    _G.CheatMenu_PartSoftnessMult = im.FloatPtr(0.01)
                end

                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Controlled Part Softness (Jelly Car):")

                im.SetNextItemWidth(250)
                im.SliderFloat("Softness Multiplier##part_softness_slider", _G.CheatMenu_PartSoftnessMult, 0.00001, 1.0, "Stiffness: %.5fx", im.SliderFlags_Logarithmic)

                if im.Button("Apply Controlled Softness##btn_apply_softness", im.ImVec2(220, 28)) then
                    local mult = _G.CheatMenu_PartSoftnessMult[0]
                    v:queueLuaCommand(string.format([[
                        local mult = %f
                        for _, b in pairs(v.data.beams) do
                            if b.wheelID == nil and (b.beamType == 0 or b.beamType == 2) and type(b.beamSpring) == "number" and b.beamSpring >= 5000 then
                                local origSpring = b.beamSpring or 100000
                                local origDamp = b.beamDamp or 100
                                local newSpring = math.max(1, origSpring * mult)
                                local newDamp = math.max(1, origDamp * mult)
                                obj:setBeamSpringDamp(b.cid, newSpring, newDamp, newSpring, newDamp)
                            end
                        end
                    ]], mult))
                end

                im.SameLine()

                if im.Button("Reset Softness (1.0x)##btn_reset_softness", im.ImVec2(160, 28)) then
                    _G.CheatMenu_PartSoftnessMult[0] = 1.0
                    v:queueLuaCommand([[
                        for _, b in pairs(v.data.beams) do
                            if b.wheelID == nil and (b.beamType == 0 or b.beamType == 2) and type(b.beamSpring) == "number" and b.beamSpring >= 5000 then
                                local origSpring = b.beamSpring or 100000
                                local origDamp = b.beamDamp or 100
                                obj:setBeamSpringDamp(b.cid, origSpring, origDamp, -1, -1)
                            end
                        end
                    ]])
                end
                im.PopStyleColor()
            end

            im.EndTabItem()
        end

        -- СРЕДА, РЕСУРСЫ И ВИЗУАЛ
        if im.BeginTabItem("Visuals & World") then
            
            -- РЕАЛЬНОЕ АСТРОНОМИЧЕСКОЕ НЕБО, СОЗВЕЗДИЯ И ЗАТМЕНИЯ (CORE_CELESTIAL)
            
            if im.CollapsingHeader1("Real Astronomical Sky & Constellations (Celestial)##celestial_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Real Astronomical Sky, Stars, Meteors & Eclipses:")
                im.Text("Calculates true solar, lunar, and stellar orbits based on date & GPS coordinates:")
                im.Spacing()

                local celest = core_celestial or (extensions and extensions.core_celestial)

                if not celest then
                    im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "Celestial sky module (core_celestial) is not active on this map.")
                else
                    -- 1. ГЛАВНЫЙ ПЕРЕКЛЮЧАТЕЛЬ И РАЗМЕР ЛУНЫ
                    local isCelestEnabled = celest.isEnabled and celest.isEnabled() or true
                    _G.CheatMenu_Celest_Enabled[0] = isCelestEnabled
                    -- if im.Checkbox("Enable Real Astronomical Sky (Реальное звездное небо)##chk_celest_en", _G.CheatMenu_Celest_Enabled) then
                    --     celest.setEnabled(_G.CheatMenu_Celest_Enabled[0])
                    -- end

                    if _G.CheatMenu_Celest_Enabled[0] then
                        im.SetNextItemWidth(220)
                        if im.SliderFloat("Moon Scale##celest_moon_sc", _G.CheatMenu_Celest_MoonScale, 0.01, 0.30, "Scale: %.3f") then
                            celest.setMoonScale(_G.CheatMenu_Celest_MoonScale[0])
                        end

                        im.SetNextItemWidth(220)
                        if im.SliderFloat("True North Offset##celest_north_off", _G.CheatMenu_Celest_NorthOffset, -180.0, 180.0, "Angle: %.1f deg") then
                            celest.setNorthOffset(_G.CheatMenu_Celest_NorthOffset[0])
                        end

                        im.Separator()

                        -- -----------------------------------------------------------------
                        -- 2. ГЕОГРАФИЧЕСКИЕ КООРДИНАТЫ И ДАТА (GPS & CALENDAR)
                        -- -----------------------------------------------------------------
                        if im.TreeNode1("1. Observer Coordinates & Calendar Date##tree_celest_date") then
                            im.SetNextItemWidth(200)
                            im.SliderFloat("Latitude (deg)##celest_lat", _G.CheatMenu_Celest_Lat, -90.0, 90.0, "Lat: %.2f°")
                            im.SameLine()
                            im.SetNextItemWidth(200)
                            im.SliderFloat("Longitude (deg)##celest_lon", _G.CheatMenu_Celest_Lon, -180.0, 180.0, "Lon: %.2f°")

                            if im.Button("Apply Location Coordinates##btn_app_celest_loc") then
                                celest.setLocation(_G.CheatMenu_Celest_Lat[0], _G.CheatMenu_Celest_Lon[0])
                            end

                            im.Spacing()
                            im.Text("Calendar Date:")
                            im.SetNextItemWidth(120)
                            im.InputInt("Year##c_y", _G.CheatMenu_Celest_Year)
                            im.SameLine()
                            im.SetNextItemWidth(100)
                            im.InputInt("Month##c_m", _G.CheatMenu_Celest_Month)
                            im.SameLine()
                            im.SetNextItemWidth(100)
                            im.InputInt("Day##c_d", _G.CheatMenu_Celest_Day)

                            if im.Button("Apply Calendar Date##btn_app_celest_date") then
                                celest.setDate(_G.CheatMenu_Celest_Year[0], _G.CheatMenu_Celest_Month[0], _G.CheatMenu_Celest_Day[0])
                            end

                            im.TreePop()
                        end

                        -- -----------------------------------------------------------------
                        -- 3. МЕТЕОРНЫЕ ДОЖДИ И ПАДАЮЩИЕ ЗВЕЗДЫ (METEOR SHOWERS)
                        -- -----------------------------------------------------------------
                        if im.TreeNode1("2. Meteor Showers & Shooting Stars##tree_celest_meteors") then
                            im.Text("Meteor Shower Presets:")

                            if im.Button("Default Calendar Shower##m_p_def", im.ImVec2(180, 24)) then
                                celest.setMeteorRatePreset("default")
                            end
                            im.SameLine()
                            if im.Button("Low (10/min)##m_p_low", im.ImVec2(120, 24)) then
                                celest.setMeteorRatePreset("low")
                            end
                            im.SameLine()
                            if im.Button("Moderate (30/min)##m_p_mod", im.ImVec2(140, 24)) then
                                celest.setMeteorRatePreset("moderate")
                            end
                            im.SameLine()
                            if im.Button("High Shower (120/min)##m_p_high", im.ImVec2(160, 24)) then
                                celest.setMeteorRatePreset("high")
                            end

                            im.SetNextItemWidth(220)
                            if im.SliderFloat("Custom Meteor Rate##m_rate_slider", _G.CheatMenu_Celest_MeteorRate, 1.0, 500.0, "Rate: %.0f / min") then
                                celest.setMeteorTestRate(_G.CheatMenu_Celest_MeteorRate[0])
                            end

                            im.TreePop()
                        end

                        -- -----------------------------------------------------------------
                        -- 4. АСТРОНОМИЧЕСКИЕ СЕТКИ И СОЗВЕЗДИЯ (GRID & CONSTELLATIONS)
                        -- -----------------------------------------------------------------
                        if im.TreeNode1("3. Constellation Maps & Grids##tree_celest_grids") then
                            local dispState = celest.getDisplayState and celest.getDisplayState() or {}

                            local function drawGridToggle(label, key)
                                local curVal = dispState[key] == true
                                local ptr = getPtr(vehId, "celest_grid_" .. key, curVal, "BoolPtr")
                                if not im.IsItemActive() then ptr[0] = curVal end
                                if im.Checkbox(label .. "##chk_grid_" .. key, ptr) then
                                    celest.setDisplayOption(key, ptr[0])
                                end
                            end

                            drawGridToggle("Constellation Lines", "constellationLines")
                            drawGridToggle("Constellation Labels", "constellationLabels")
                            drawGridToggle("Horizon Grid", "horizonGrid")
                            drawGridToggle("Equatorial Grid", "equatorialGrid")
                            drawGridToggle("Meridian Grid", "meridianGrid")
                            drawGridToggle("Moon Path Grid", "moonGrid")

                            im.Separator()
                            -- Интерактивная карточка при наведении мышкой на звездное небо
                            if im.Checkbox("Enable Star & Constellation Mouse Hover Fact-Sheet##chk_celest_hover", _G.CheatMenu_Celest_Hover) then
                                celest.setHoverEnabled(_G.CheatMenu_Celest_Hover[0])
                            end
                            if im.IsItemHovered() then im.SetTooltip("Shows a localized floating fact sheet when pointing your mouse at stars and constellations!") end

                            im.TreePop()
                        end

                        -- -----------------------------------------------------------------
                        -- 5. ПОИСК И ПЕРЕХОД К СОЛНЕЧНОМУ ЗАТМЕНИЮ (SOLAR ECLIPSE FINDER)
                        -- -----------------------------------------------------------------
                        if im.TreeNode1("4. Solar Eclipse Finder & Jump##tree_celest_eclipse") then
                            im.Text("Calculates and jumps to the next visible solar eclipse for current coordinates:")
                            
                            im.PushStyleColor2(im.Col_Button, im.ImVec4(0.8, 0.3, 0.1, 1.0))
                            if im.Button("FIND & JUMP TO NEXT SOLAR ECLIPSE##btn_jump_eclipse", im.ImVec2(360, 28)) then
                                local eclipseDate = celest.findNextSolarEclipse and celest.findNextSolarEclipse()
                                if eclipseDate then
                                    celest.setDate(eclipseDate.year, eclipseDate.month, eclipseDate.day)
                                    if core_environment and core_environment.setTimeOfDay then
                                        core_environment.setTimeOfDay({ time = eclipseDate.time, play = false })
                                    end
                                    _G.CheatMenu_Celest_Year[0] = eclipseDate.year
                                    _G.CheatMenu_Celest_Month[0] = eclipseDate.month
                                    _G.CheatMenu_Celest_Day[0] = eclipseDate.day
                                    guihooks.trigger('showNotification', {
                                        title = "Solar Eclipse Found!",
                                        text = string.format("Jumped to Eclipse: %04d-%02d-%02d (Time: %.2f)", eclipseDate.year, eclipseDate.month, eclipseDate.day, eclipseDate.time),
                                        icon = "star"
                                    })
                                else
                                    guihooks.trigger('showNotification', {title = "No Eclipse Found", text = "No visible eclipse found within range.", icon = "alert"})
                                end
                            end
                            im.PopStyleColor()

                            im.TreePop()
                        end
                    end
                end
            end
            
            -- УПРАВЛЕНИЕ СВЕТОФОРАМИ ГОРОДА И СИСТЕМОЙ СИГНАЛОВ (TRAFFIC SIGNALS)
            
            if im.CollapsingHeader1("City Traffic Signals & Traffic Lights Control##traffic_signals_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "City-Wide Traffic Lights & Signal System Control:")
                im.Text("Manage all city intersections, traffic lights, stop signs, and signal timing:")
                im.Spacing()

                local sigMod = core_trafficSignals or (extensions and extensions.core_trafficSignals)

                -- Вспомогательная функция принудительного переключения всех светофоров города
                local function forceAllCityTrafficLights(targetStateName)
                    if not sigMod then return end

                    if targetStateName == "auto" then
                        -- Возобновляем автоматический режим работы всех светофоров
                        _G.CheatMenu_Signals_OverrideState = "auto"
                        local sequences = sigMod.getSequences and sigMod.getSequences() or {}
                        for _, seq in ipairs(sequences) do
                            seq:enableTimer(true)
                        end
                        if sigMod.resetTimer then sigMod.resetTimer() end
                        return
                    end

                    _G.CheatMenu_Signals_OverrideState = targetStateName

                    -- 1. Замораживаем таймеры всех последовательностей переключения
                    local sequences = sigMod.getSequences and sigMod.getSequences() or {}
                    for _, seq in ipairs(sequences) do
                        seq:enableTimer(false)
                    end

                    -- 2. Переключаем все светофоры города в выбранное состояние
                    local instances = sigMod.getSignals and sigMod.getSignals() or {}
                    for _, instance in ipairs(instances) do
                        local ctrl = instance:getController()
                        if ctrl and ctrl.states then
                            local foundIdx = nil
                            for idx, st in ipairs(ctrl.states) do
                                if st.state == targetStateName or string.find(string.lower(st.state), targetStateName) then
                                    foundIdx = idx
                                    break
                                end
                            end

                            if foundIdx then
                                instance:setStrictState(foundIdx)
                            else
                                instance:setStrictState(ctrl.defaultIndex or 1)
                            end
                        end
                    end
                end

                if not sigMod then
                    im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "Traffic signals module (core_trafficSignals) is not active on this map.")
                else
                    local data = sigMod.getData and sigMod.getData() or {}
                    local instances = sigMod.getSignals and sigMod.getSignals() or {}
                    local sequences = sigMod.getSequences and sigMod.getSequences() or {}
                    local controllers = sigMod.getControllers and sigMod.getControllers() or {}

                    -- Вывод общей статистики по светофорам карты
                    im.Text(string.format("System Status: %s | Timer: %.1f s", (data.active and "ACTIVE" or "OFF"), data.timer or 0))
                    im.Text(string.format("Map Signals: %d Objects | %d Sequences | %d Controllers", #instances, #sequences, #controllers))
                    
                    im.Separator()
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "City-Wide Traffic Lights Override (Управление всеми светофорами):")

                    -- КНОПКИ ГЛОБАЛЬНОГО ПЕРЕКЛЮЧЕНИЯ ВСЕХ СВЕТОФОРОВ ГОРОДА
                    im.PushStyleColor2(im.Col_Button, im.ImVec4(0.8, 0.2, 0.2, 1.0))
                    if im.Button("ALL RED##btn_all_red", im.ImVec2(180, 28)) then
                        forceAllCityTrafficLights("red")
                    end
                    im.PopStyleColor()

                    im.SameLine()
                    im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.7, 0.2, 1.0))
                    if im.Button("ALL GREEN##btn_all_green", im.ImVec2(180, 28)) then
                        forceAllCityTrafficLights("green")
                    end
                    im.PopStyleColor()

                    im.SameLine()
                    im.PushStyleColor2(im.Col_Button, im.ImVec4(0.9, 0.7, 0.1, 1.0))
                    if im.Button("ALL YELLOW##btn_all_yellow", im.ImVec2(180, 28)) then
                        forceAllCityTrafficLights("yellow")
                    end
                    im.PopStyleColor()

                    if im.Button("ALL OFF##btn_all_off", im.ImVec2(240, 26)) then
                        forceAllCityTrafficLights("none")
                    end

                    im.SameLine()
                    im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.5, 0.9, 1.0))
                    if im.Button("Resume Auto Cycle##btn_resume_cycle", im.ImVec2(280, 26)) then
                        forceAllCityTrafficLights("auto")
                    end
                    im.PopStyleColor()

                    im.Separator()
                    im.Text("System & Debug Controls:")

                    -- Переключатель активности системы
                    local sysActive = data.active or false
                    local sysActivePtr = getPtr(vehId, "sig_sys_active_ptr", sysActive, "BoolPtr")
                    if not im.IsItemActive() then sysActivePtr[0] = sysActive end
                    if im.Checkbox("Enable Traffic Signals System##chk_sig_active", sysActivePtr) then
                        sigMod.setActive(sysActivePtr[0], true)
                    end

                    -- Регулировка 3D дебаг-визуализации на карте
                    im.SetNextItemWidth(220)
                    local dbgVal = sigMod.debugLevel or 0
                    _G.CheatMenu_Signals_DebugLevel[0] = dbgVal
                    if im.SliderInt("Debug Visualizer Level##sig_dbg_slider", _G.CheatMenu_Signals_DebugLevel, 0, 2, "Level: %d") then
                        sigMod.debugLevel = _G.CheatMenu_Signals_DebugLevel[0]
                    end
                    if im.IsItemHovered() then im.SetTooltip("0 = Off, 1 = Basic Info, 2 = 3D Shapes & Color Spheres on Map") end

                    im.SameLine()
                    if im.Button("Reset Timers##btn_res_sig_timer") then
                        sigMod.resetTimer()
                    end

                    -- Прокручиваемый список всех светофоров карты с возможностью точечного управления
                    if #instances > 0 and im.TreeNode1("Live Traffic Signals List (" .. #instances .. " objects)##tree_signals_list") then
                        local playerVeh = be:getPlayerVehicle(0)
                        local pPos = playerVeh and playerVeh:getPosition() or core_camera.getPosition()

                        im.BeginChild1("SignalsScrollList", im.ImVec2(0, 220), true, 0)
                        for idx, instance in ipairs(instances) do
                            local stateName = instance:getState() or "none"
                            local dist = (pPos and instance.pos) and math.floor(pPos:distance(instance.pos)) or 0

                            im.Text(string.format("[%d] %s | State: %s | Dist: %d m", idx, instance.name or "Signal", stateName, dist))
                            
                            im.SameLine()
                            if im.SmallButton("Set Green##sig_g_" .. idx) then
                                local ctrl = instance:getController()
                                if ctrl then
                                    for sIdx, st in ipairs(ctrl.states) do
                                        if string.find(st.state, "green") then
                                            instance:setStrictState(sIdx)
                                            break
                                        end
                                    end
                                end
                            end

                            im.SameLine()
                            if im.SmallButton("Set Red##sig_r_" .. idx) then
                                local ctrl = instance:getController()
                                if ctrl then
                                    for sIdx, st in ipairs(ctrl.states) do
                                        if string.find(st.state, "red") then
                                            instance:setStrictState(sIdx)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        im.EndChild()
                        im.TreePop()
                    end
                end
            end
            if im.CollapsingHeader1("Why's This Dealer? (Easter Egg Control)##tree_obj_spawner") then
                
                -- ПАСХАЛКА "WHY'S THIS DEALER?" (ТАНЦУЮЩЕЕ АВТО)
                
                im.Separator()
                im.TextColored(im.ImVec4(1.0, 0.4, 0.8, 1.0), "BeamNG Easter Egg:")
                
                
                -- УПРАВЛЕНИЕ СКОРОСТЬЮ ПАСХАЛКИ "WHY'S THIS DEALER?"
                
                im.Separator()
                im.TextColored(im.ImVec4(1.0, 0.4, 0.8, 1.0), "Why's This Dealer? (Easter Egg Control):")

                -- Инициализация переменной скорости
                if _G.CheatMenu_WhySpeed == nil then _G.CheatMenu_WhySpeed = im.FloatPtr(1.0) end

                -- 1. Оригинальная пасхалка
                if im.Button("Default Meme Preset ('this dealer')##btn_why_def", im.ImVec2(260, 26)) then
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then
                        pVeh:why("this dealer")
                    end
                end

                -- 2. Настройка произвольной скорости
                im.SetNextItemWidth(200)
                
                im.SliderFloat("##why_speed_slider", _G.CheatMenu_WhySpeed, 0.1, 1000.0, "Speed: %.1fx")

                im.SameLine()
                if im.Button("Apply Speed##btn_why_speed_apply", im.ImVec2(100, 26)) then
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then
                        -- Передаем числовое значение скорости
                        pVeh:why(tostring(_G.CheatMenu_WhySpeed[0]))
                    end
                end

                -- 3. Быстрые кнопки пресетов скорости
                if im.Button("0.5x##btn_why_05") then
                    _G.CheatMenu_WhySpeed[0] = 0.5
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("0.5") end
                end
                im.SameLine()
                if im.Button("1x##btn_why_1") then
                    _G.CheatMenu_WhySpeed[0] = 1.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("1") end
                end
                im.SameLine()
                if im.Button("5x##btn_why_5") then
                    _G.CheatMenu_WhySpeed[0] = 5.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("5") end
                end
                im.SameLine()
                if im.Button("10x##btn_why_5") then
                    _G.CheatMenu_WhySpeed[0] = 5.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("10") end
                end
                im.SameLine()
                if im.Button("15x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("15") end
                end
                im.SameLine()
                if im.Button("30x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("30") end
                end
                im.SameLine()
                if im.Button("50x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("50") end
                end
                im.SameLine()
                if im.Button("75x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("75") end
                end
                im.SameLine()
                if im.Button("100x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("100") end
                end
                im.SameLine()
                if im.Button("150x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("150") end
                end
                im.SameLine()
                if im.Button("200x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("200") end
                end
                im.SameLine()
                if im.Button("300x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("300") end
                end
                im.SameLine()
                if im.Button("500x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("500") end
                end
                im.SameLine()
                if im.Button("700x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("700") end
                end
                im.SameLine()
                if im.Button("800x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("800") end
                end
                im.SameLine()
                if im.Button("1000x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("1000") end
                end
                im.SameLine()
                if im.Button("10000x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("10000") end
                end
                im.SameLine()
                if im.Button("100000x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("100000") end
                end
                im.SameLine()
                if im.Button("1000000x##btn_why_15") then
                    _G.CheatMenu_WhySpeed[0] = 15.0
                    local pVeh = be:getPlayerVehicle(0)
                    if pVeh and type(pVeh.why) == "function" then pVeh:why("1000000") end
                end
                if im.Button("Stop##btn_why_dealer", im.ImVec2(280, 28)) then
                    local playerVeh = be:getPlayerVehicle(0)
                    if playerVeh then
                        -- Вызов функции пасхалки в движке BeamNG
                        if type(playerVeh.why) == "function" then
                            playerVeh:why("stop")
                        else
                            -- Резервный запуск через консоль Game Engine
                            obj:queueGameEngineLua("if be:getPlayerVehicle(0) and be:getPlayerVehicle(0).why then be:getPlayerVehicle(0):why('stop') end")
                        end
                    end
                end
            end
            
            -- СПАВНЕР 3D-ОБЪЕКТОВ С ФОРМАЦИЯМИ (ДРУГ ЗА ДРУГОМ, БОК О БОК, БАШНЯ)
            
            if im.CollapsingHeader1("3D Object & Prop Spawner##tree_obj_spawner") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "3D Object & Prop Spawner with Formations & Layouts:")
                im.Text("Spawn physical obstacles, ramps, walls, rocks, and props in rows, columns, towers or scatter:")
                im.Spacing()

                -- Catalog 3D объектов BeamNG
                local propCatalog = {
                    {
                        category = "Test",
                        items = {
                            { name = "n2o", path = "vehicles/common/n2o_bottle.dae" }
                        }
                    }
                }

                -- Функция сканирования всех .dae/.fbx объектов игры
                local function scanAllGameObjects()
                    if _G.CheatMenu_AllDiscoveredObjects then
                        return _G.CheatMenu_AllDiscoveredObjects
                    end
                    
                    local list = {}
                    local searchPaths = { "art/shapes/", "vehicles/common/", "levels/", "art/" }
                    
                    for _, path in ipairs(searchPaths) do
                        local daeFiles = FS:findFiles(path, "*.dae", -1, true, false) or {}
                        for _, filePath in ipairs(daeFiles) do
                            local fileName = filePath:match("([^/]+)$") or filePath
                            table.insert(list, { name = fileName, path = filePath, fullLabel = fileName .. " [" .. filePath .. "]" })
                        end
                        
                        local fbxFiles = FS:findFiles(path, "*.fbx", -1, true, false) or {}
                        for _, filePath in ipairs(fbxFiles) do
                            local fileName = filePath:match("([^/]+)$") or filePath
                            table.insert(list, { name = fileName, path = filePath, fullLabel = fileName .. " [" .. filePath .. "]" })
                        end
                    end
                    
                    table.sort(list, function(a, b) return a.name < b.name end)
                    _G.CheatMenu_AllDiscoveredObjects = list
                    return list
                end

                -- Расширенная функция спавна с формациями (разброс, друг за другом, бок о бок, башня)
                local function spawnTSStaticObject(shapePath)
                    if not shapePath or shapePath == "" then return end

                    local playerVeh = be:getPlayerVehicle(0)
                    local basePos = nil
                    local fwd = vec3(0, 1, 0)
                    local right = vec3(1, 0, 0)

                    if playerVeh then
                        local pPos = playerVeh:getPosition()
                        fwd = playerVeh:getDirectionVector():normalized()
                        right = fwd:cross(vec3(0, 0, 1)):normalized()
                        local dist = _G.CheatMenu_Obj_SpawnDistance[0]
                        basePos = pPos + fwd * dist
                    else
                        basePos = core_camera and core_camera.getPosition() or vec3(0,0,0)
                    end

                    local count = math.max(1, _G.CheatMenu_Obj_SpawnCount[0])
                    local spacing = _G.CheatMenu_Obj_Spacing[0]
                    local radius = math.max(0, _G.CheatMenu_Obj_ScatterRadius[0])
                    local pattern = _G.CheatMenu_Obj_PatternIdx or 0

                    local missionGroup = scenetree.findObject("MissionGroup") or scenetree.findObject("ExtraGroup")

                    for i = 1, count do
                        local itemPos = vec3(basePos.x, basePos.y, basePos.z)

                        if pattern == 0 then
                            -- 0: Случайный разброс
                            if radius > 0 and (count > 1 or radius > 0.1) then
                                local angle = math.random() * math.pi * 2
                                local rDist = math.sqrt(math.random()) * radius
                                itemPos.x = itemPos.x + math.cos(angle) * rDist
                                itemPos.y = itemPos.y + math.sin(angle) * rDist
                            end
                        elseif pattern == 1 then
                            -- 1: Друг за другом (вперед по ходу движения)
                            local offset = (i - 1) * spacing
                            itemPos = basePos + fwd * offset
                        elseif pattern == 2 then
                            -- 2: Бок о бок (в ряд перпендикулярно машине)
                            local offset = (i - (count + 1) * 0.5) * spacing
                            itemPos = basePos + right * offset
                        elseif pattern == 3 then
                            -- 3: Друг на друга (вертикальная башня)
                            local offset = (i - 1) * spacing
                            itemPos = basePos + vec3(0, 0, offset)
                        end

                        local obj = createObject("TSStatic")
                        if obj then
                            obj:setField("shapeName", 0, shapePath)
                            obj:setPosition(itemPos)
                            obj:setField("scale", 0, string.format("%f %f %f", _G.CheatMenu_Obj_ScaleX[0], _G.CheatMenu_Obj_ScaleY[0], _G.CheatMenu_Obj_ScaleZ[0]))
                            obj:setField("collisionType", 0, "Visible Mesh") -- Включаем точную физическую коллизию
                            obj:registerObject("")

                            if missionGroup then
                                missionGroup:addObject(obj)
                            end

                            obj:postApply()
                            table.insert(_G.CheatMenu_SpawnedObjectsList, obj:getID())
                        end
                    end

                    be:reloadCollision() -- Мгновенно обновляем физику всех спавненных объектов
                end

                -- ГАЛОЧКА: Переключение между пресетами и сканированием ВСЕХ файлов игры
                im.Checkbox("Scan ALL Game Files (.dae / .fbx)##chk_scan_all_objs", _G.CheatMenu_Obj_UseAllScan)

                local chosenPathToSpawn = nil

                if _G.CheatMenu_Obj_UseAllScan[0] then
                    
                    -- РЕЖИМ 1: ПОЛНОЕ СКАНИРОВАНИЕ ВСЕХ 3D-ФАЙЛОВ ИГРЫ
                    
                    im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Searching ALL 3D models in game files:")
                    im.SetNextItemWidth(260)
                    im.InputText("Filter Objects##AllObjFilter", _G.CheatMenu_Obj_AllFilter)
                    local filterText = string.lower(ffi.string(_G.CheatMenu_Obj_AllFilter))

                    local allObjects = scanAllGameObjects()
                    local filteredAllObjects = {}

                    for _, item in ipairs(allObjects) do
                        if filterText == "" or string.find(string.lower(item.fullLabel), filterText) then
                            table.insert(filteredAllObjects, item)
                        end
                    end

                    if _G.CheatMenu_Obj_SelAllIdx >= #filteredAllObjects then
                        _G.CheatMenu_Obj_SelAllIdx = 0
                    end

                    local chosenAllObj = filteredAllObjects[_G.CheatMenu_Obj_SelAllIdx + 1]
                    local chosenAllLabel = chosenAllObj and chosenAllObj.fullLabel or string.format("Select Model (%d found)...", #filteredAllObjects)

                    im.SetNextItemWidth(-1)
                    if im.BeginCombo("All Game Models##combo_all_game_objs", chosenAllLabel) then
                        for idx, item in ipairs(filteredAllObjects) do
                            local isSel = (_G.CheatMenu_Obj_SelAllIdx == idx - 1)
                            if im.Selectable1(item.name .. " [" .. item.path .. "]##all_obj_" .. idx, isSel) then
                                _G.CheatMenu_Obj_SelAllIdx = idx - 1
                            end
                        end
                        im.EndCombo()
                    end

                    if chosenAllObj then
                        chosenPathToSpawn = chosenAllObj.path
                    end
                else
                    
                    -- РЕЖИМ 2: ГОТОВЫЙ КАТАЛОГ ПО КАТЕГОРИЯМ
                    
                    local catList = {}
                    for _, cat in ipairs(propCatalog) do
                        table.insert(catList, cat.category)
                    end

                    if _G.CheatMenu_Obj_SelectedCatIdx >= #catList then _G.CheatMenu_Obj_SelectedCatIdx = 0 end

                    im.SetNextItemWidth(260)
                    if im.BeginCombo("Object Category##combo_obj_cat", catList[_G.CheatMenu_Obj_SelectedCatIdx + 1]) then
                        for idx, cName in ipairs(catList) do
                            local isSel = (_G.CheatMenu_Obj_SelectedCatIdx == idx - 1)
                            if im.Selectable1(cName, isSel) then
                                _G.CheatMenu_Obj_SelectedCatIdx = idx - 1
                                _G.CheatMenu_Obj_SelectedPropIdx = 0
                            end
                        end
                        im.EndCombo()
                    end

                    local currentCatObj = propCatalog[_G.CheatMenu_Obj_SelectedCatIdx + 1]
                    local currentPropList = currentCatObj and currentCatObj.items or {}

                    if _G.CheatMenu_Obj_SelectedPropIdx >= #currentPropList then _G.CheatMenu_Obj_SelectedPropIdx = 0 end

                    local chosenProp = currentPropList[_G.CheatMenu_Obj_SelectedPropIdx + 1]
                    local chosenPropName = chosenProp and chosenProp.name or "Select Object..."

                    im.SetNextItemWidth(260)
                    if im.BeginCombo("Select Object##combo_obj_items", chosenPropName) then
                        for idx, prop in ipairs(currentPropList) do
                            local isSel = (_G.CheatMenu_Obj_SelectedPropIdx == idx - 1)
                            if im.Selectable1(prop.name, isSel) then
                                _G.CheatMenu_Obj_SelectedPropIdx = idx - 1
                            end
                        end
                        im.EndCombo()
                    end

                    if chosenProp then
                        chosenPathToSpawn = chosenProp.path
                    end
                end

                im.Separator()
                im.Text("Spawn Placement & Quantity Parameters:")

                -- Настройка количества предметов
                im.SetNextItemWidth(220)
                im.SliderInt("Quantity to Spawn##obj_count", _G.CheatMenu_Obj_SpawnCount, 1, 5000, "%d items")

                -- Селектор формации спавна
                local patternsList = {
                    "Random",
                    "In a Line / Column",
                    "Side by Side / Row",
                    "Vertical Stack / Tower"
                }

                im.SetNextItemWidth(260)
                if im.BeginCombo("Spawn Formation##combo_pattern", patternsList[_G.CheatMenu_Obj_PatternIdx + 1] or patternsList[1]) then
                    for idx, pName in ipairs(patternsList) do
                        local isSel = (_G.CheatMenu_Obj_PatternIdx == idx - 1)
                        if im.Selectable1(pName, isSel) then
                            _G.CheatMenu_Obj_PatternIdx = idx - 1
                        end
                    end
                    im.EndCombo()
                end

                -- Динамический ползунок: Радиус разброса ИЛИ Интервал между объектами
                if _G.CheatMenu_Obj_PatternIdx == 0 then
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Scatter Radius##obj_scatter", _G.CheatMenu_Obj_ScatterRadius, 0.0, 500.0, "%.1f m")
                else
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Spacing / Gap##obj_spacing", _G.CheatMenu_Obj_Spacing, 0.2, 500.0, "%.1f m")
                end

                im.SetNextItemWidth(220)
                im.SliderFloat("Distance Ahead (m)##obj_dist", _G.CheatMenu_Obj_SpawnDistance, 1.0, 500.0, "Distance: %.1f m")

                im.Separator()
                im.Text("Scale & Size Parameters:")

                -- ОБЩИЙ РАЗМЕР ОБЪЕКТА (меняет сразу X, Y и Z)
                im.SetNextItemWidth(220)
                if im.SliderFloat("Overall Size##obj_sc_uniform", _G.CheatMenu_Obj_ScaleUniform, 0.1, 50.0, "Size: %.1fx") then
                    _G.CheatMenu_Obj_ScaleX[0] = _G.CheatMenu_Obj_ScaleUniform[0]
                    _G.CheatMenu_Obj_ScaleY[0] = _G.CheatMenu_Obj_ScaleUniform[0]
                    _G.CheatMenu_Obj_ScaleZ[0] = _G.CheatMenu_Obj_ScaleUniform[0]
                end

                -- Раздельные оси для точной подгонки пропорций
                im.SetNextItemWidth(140)
                im.SliderFloat("Scale X##obj_sc_x", _G.CheatMenu_Obj_ScaleX, 0.1, 50.0, "X: %.1fx")
                im.SameLine()
                im.SetNextItemWidth(140)
                im.SliderFloat("Scale Y##obj_sc_y", _G.CheatMenu_Obj_ScaleY, 0.1, 50.0, "Y: %.1fx")
                im.SameLine()
                im.SetNextItemWidth(140)
                im.SliderFloat("Scale Z##obj_sc_z", _G.CheatMenu_Obj_ScaleZ, 0.1, 50.0, "Z: %.1fx")

                im.SetNextItemWidth(220)
                im.SliderFloat("Rotation Angle##obj_rot_y", _G.CheatMenu_Obj_RotYaw, 0.0, 360.0, "Angle: %.0f deg")

                im.Spacing()
                -- Кнопки спавна и удаления
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.7, 0.3, 1.0))
                if im.Button("SPAWN OBJECT(S) IN FRONT OF CAR##btn_spawn_prop", im.ImVec2(340, 28)) then
                    if chosenPathToSpawn then
                        spawnTSStaticObject(chosenPathToSpawn)
                    end
                end
                im.PopStyleColor()

                im.SameLine()
                if im.Button("Undo Last Spawned##btn_undo_obj", im.ImVec2(160, 28)) then
                    local list = _G.CheatMenu_SpawnedObjectsList
                    if list and #list > 0 then
                        local lastId = list[#list]
                        local obj = scenetree.findObject(lastId)
                        if obj then obj:delete() end
                        table.remove(list, #list)
                        be:reloadCollision()
                    end
                end

                if im.Button("Delete ALL Spawned Props##btn_del_all_objs", im.ImVec2(240, 24)) then
                    local list = _G.CheatMenu_SpawnedObjectsList
                    if list then
                        for _, id in ipairs(list) do
                            local obj = scenetree.findObject(id)
                            if obj then obj:delete() end
                        end
                        _G.CheatMenu_SpawnedObjectsList = {}
                        be:reloadCollision()
                    end
                end

                im.Separator()
                im.Text("Custom Model File Spawner (.dae / .fbx):")
                im.SetNextItemWidth(260)
                im.InputText("File Path##custom_obj_path", _G.CheatMenu_Obj_CustomPath)
                im.SameLine()
                if im.Button("Spawn Custom File##btn_spawn_custom_obj") then
                    local customPath = ffi.string(_G.CheatMenu_Obj_CustomPath)
                    if customPath ~= "" then
                        spawnTSStaticObject(customPath)
                    end
                end
            end
            
            if im.CollapsingHeader1("Simulation speed(Safe method)") then
                -- Ваш оригинальный слайдер симуляции автомобиля
                im.Text("Simulation speed:")
                renderSliderWithReset("Simulation speed", "timeScale", 0.001, 10.0, 1.0, "applyTimeScale", "%.3f")
                
                -- Сетка быстрых кнопок-пресетов для вашего слайдера (от 0.1x до 10x)
                local timeScalePtr = getPtr(vehId, "timeScale", 1.0, "FloatPtr")
                local tsPresets = {
                    { name = "0.001x", val = 0.001 },
                    { name = "0.01x", val = 0.01 },
                    { name = "0.1x", val = 0.1 },
                    { name = "0.25x", val = 0.25 },
                    { name = "0.5x", val = 0.5 },
                    { name = "0.75x", val = 0.75 },
                    { name = "1x (Normal)", val = 1.0 },
                    { name = "2x", val = 2.0 },
                    { name = "3x", val = 3.0 },
                    { name = "4x", val = 4.0 },
                    { name = "5x", val = 5.0 },
                    { name = "6x", val = 6.0 },
                    { name = "7x", val = 7.0 },
                    { name = "8x", val = 8.0 },
                    { name = "9x", val = 9.0 },
                    { name = "10x", val = 10.0 }
                }
                
                im.Text("Presets for Simulation Speed:")
                for idx, preset in ipairs(tsPresets) do
                    local isCurrent = math.abs(timeScalePtr[0] - preset.val) < 0.0001
                    
                    -- Подсвечиваем текущую выбранную скорость оранжевым
                    if isCurrent then
                        im.PushStyleColor2(im.Col_Button, im.ImVec4(1.0, 0.4, 0.0, 1.0))
                    end
                    
                    if im.Button(preset.name .. "##ts_preset_" .. idx, im.ImVec2(105, 22)) then
                        timeScalePtr[0] = preset.val
                        sendVar("timeScale", preset.val, "applyTimeScale")
                    end
                    
                    if isCurrent then
                        im.PopStyleColor()
                    end
                    
                    -- Выстраиваем по 4 кнопки в ряд
                    if idx % 4 ~= 0 then
                        im.SameLine()
                    end
                end
            end

            if im.CollapsingHeader1("Physics Speed (Only for Tests)") then
                -- Множитель скорости физики (be:setPhysicsSpeedFactor)
                im.SetNextItemWidth(250)
                if im.SliderFloat("Physics Speed (Factor) (For testing very powerful PCs)##physics_speed_fact", _G.CheatMenu_PhysicsSpeedFactor, 0.01, 100.0, "%.2fx") then
                    be:setPhysicsSpeedFactor(_G.CheatMenu_PhysicsSpeedFactor[0])
                end
            end

            im.Separator()
            if im.CollapsingHeader1("Time of Day editor") then
                im.Text("Time of Day:")
                im.SetNextItemWidth(-1)
                -- Слайдер от 0.0 до 1.0 (0.0 - полночь, 0.5 - полдень, 1.0 - полночь)
                if im.SliderFloat("##time_slider", _G.CheatMenu_TimeOfDay, 0.0, 1.0, "Time: %.2f") then
                    if core_environment then 
                        core_environment.setTimeOfDay({time = _G.CheatMenu_TimeOfDay[0], play = false}) 
                    end
                end
                -- Блок точной настройки времени суток
                if _G.CheatMenu_PreciseTimeStr == nil then 
                    _G.CheatMenu_PreciseTimeStr = im.ArrayChar(16) 
                    ffi.copy(_G.CheatMenu_PreciseTimeStr, "12:00:00") 
                end
                im.Text("Set Precise Time of Day:")
                im.SetNextItemWidth(120)
                im.InputText("##precise_tod_input", _G.CheatMenu_PreciseTimeStr)
                im.SameLine()
                if im.Button("Apply Time (HH:MM:SS)##precise_tod_btn") then
                    local timeStr = ffi.string(_G.CheatMenu_PreciseTimeStr)
                    setTimeOfDay(timeStr)
                    local todTable = getTimeOfDay()
                    if todTable then
                        _G.CheatMenu_TimeOfDay[0] = (((todTable.hours * 3600 + todTable.mins * 60 + todTable.secs) / 86400) + 0.5) % 1
                    end
                end

                im.Spacing()
                
                if im.Button("Random") then
                    local randomTime = math.random()
                    _G.CheatMenu_TimeOfDay[0] = randomTime
                    if core_environment then 
                        core_environment.setTimeOfDay({time = randomTime, play = false}) 
                    end
                end
                im.SameLine()
                if im.Button("Random + Speed") then
                    if core_environment then
                        local randomTime = math.random()
                        local randomSpeed = math.random(1, 50) 
                        _G.CheatMenu_TimeOfDay[0] = randomTime
                        core_environment.setTimeOfDay({
                            time = randomTime, 
                            play = true, 
                            dayScale = randomSpeed, 
                            nightScale = randomSpeed
                        })
                    end
                end
                im.SameLine()
                if im.Button("Default") then
                    if core_environment then core_environment.setTimeOfDay({time = 0.1, play = false}) end
                end
            end
            
            if im.CollapsingHeader1("Climate Settings") then
                
                -- 1. СКОРОСТЬ ТЕЧЕНИЯ ДНЯ И НОЧИ
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Day / Night Cycle Speed:")
                im.SetNextItemWidth(220)
                if im.SliderFloat("Cycle Speed Multiplier##day_night_speed", _G.CheatMenu_DayNightSpeed, 0.0, 500.0, "Speed: %.1fx", im.SliderFlags_Logarithmic) then
                    if core_environment then
                        local speed = _G.CheatMenu_DayNightSpeed[0]
                        core_environment.setTimeOfDay({
                            play = (speed > 0),
                            dayScale = speed,
                            nightScale = speed
                        })
                    end
                end
                if im.IsItemHovered() then 
                    im.SetTooltip("Controls how fast time flows (0 = stop, 1 = realtime, 100+ = rapid day/night cycle).") 
                end

                im.SameLine()
                if im.Button("Reset Speed##btn_res_tod_speed") then
                    _G.CheatMenu_DayNightSpeed[0] = 1.0
                    if core_environment then
                        core_environment.setTimeOfDay({ play = true, dayScale = 1.0, nightScale = 1.0 })
                    end
                end

                im.Separator()

                -- 2. СКОРОСТЬ ВЕТРА
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Wind Velocity:")
                im.SetNextItemWidth(220)
                if im.SliderFloat("Wind Speed (m/s)##wind_speed_slider", _G.CheatMenu_WindSpeed, 0.0, 150.0, "Wind: %.1f m/s") then
                    local wSpeed = _G.CheatMenu_WindSpeed[0]
                    if core_environment then
                        if core_environment.setWindSpeed then
                            core_environment.setWindSpeed(wSpeed)
                        elseif core_environment.setWind then
                            core_environment.setWind(wSpeed)
                        end
                    end
                    local levelInfo = scenetree.findObject("theLevelInfo") or scenetree.findObjectOfClass("LevelInfo")
                    if levelInfo then
                        levelInfo:setField("windSpeed", 0, tostring(wSpeed))
                        levelInfo:postApply()
                    end
                end
                if im.IsItemHovered() then 
                    im.SetTooltip("Applies physical wind forces affecting aerodynamic drag, trees, and flying debris.") 
                end

                im.SameLine()
                if im.Button("Reset Wind##btn_res_wind") then
                    _G.CheatMenu_WindSpeed[0] = 0.0
                    if core_environment and core_environment.setWindSpeed then
                        core_environment.setWindSpeed(0.0)
                    end
                    local levelInfo = scenetree.findObject("theLevelInfo") or scenetree.findObjectOfClass("LevelInfo")
                    if levelInfo then
                        levelInfo:setField("windSpeed", 0, "0")
                        levelInfo:postApply()
                    end
                end

                im.Separator()

                -- 3. ОКРУЖАЮЩАЯ ТЕМПЕРАТУРА ВОЗДУХА
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Ambient Map Temperature:")

                local liveTemp = 20.0
                if core_environment and type(core_environment.getTemperature) == "function" then
                    liveTemp = core_environment.getTemperature() or (_G.CheatMenu_AmbientTemp and _G.CheatMenu_AmbientTemp[0] or 20.0)
                elseif _G.CheatMenu_AmbientTemp then
                    liveTemp = _G.CheatMenu_AmbientTemp[0]
                end

                -- Выбор цвета индикатора: Голубой (<0°C), Зеленый (0-35°C), Красный (>35°C)
                local tempColor = im.ImVec4(0.4, 1.0, 0.4, 1.0)
                if liveTemp < 0 then
                    tempColor = im.ImVec4(0.4, 0.8, 1.0, 1.0)
                elseif liveTemp > 35 then
                    tempColor = im.ImVec4(1.0, 0.3, 0.2, 1.0)
                end

                im.SameLine()
                im.TextColored(tempColor, string.format("Temp: %.1f°C", liveTemp))
                if im.IsItemHovered() then
                    im.SetTooltip("Current Live Ambient Map Temperature")
                end
                
                -- Вспомогательная функция для чистой установки температуры
                local function applyMapTemp(tempC)
                    _G.CheatMenu_AmbientTemp[0] = tempC
                    if core_environment and core_environment.setTemperature then
                        core_environment.setTemperature(tempC)
                    end
                    local levelInfo = scenetree.findObject("theLevelInfo") or scenetree.findObjectOfClass("LevelInfo")
                    if levelInfo and levelInfo.setTemperatureCurveC then
                        levelInfo:setTemperatureCurveC({{0, tempC}, {1, tempC}})
                        if core_environment and core_environment.reset then
                            core_environment.reset()
                        end
                    end
                end

                im.SetNextItemWidth(220)
                if im.SliderFloat("Air Temp (°C)##ambient_temp_slider", _G.CheatMenu_AmbientTemp, -1000.0, 1000.0, "Temp: %.1f °C") then
                    applyMapTemp(_G.CheatMenu_AmbientTemp[0])
                end
                if im.IsItemHovered() then 
                    im.SetTooltip("Directly impacts engine radiator efficiency, intercooler cooling, brake thermals, and tire heat.") 
                end

                im.SameLine()
                if im.Button("Reset Temp (20°C)##btn_res_temp") then
                    applyMapTemp(20.0)
                end

                
                -- ПРЕСЕТЫ ТЕМПЕРАТУРЫ (ОТ ГЛУБОКОГО КОСМОСА ДО ПЕЧИ И ЛАВЫ)
                
                im.Spacing()
                im.Text("Temperature Presets:")

                local tempPresets = {
                    { name = "-10000°C", val = -10000.0 },
                    { name = "-5000°C", val = -5000.0 },
                    { name = "-3000°C", val = -3000.0 },
                    { name = "-2000°C", val = -2000.0 },
                    { name = "-1000°C (Space)", val = -1000.0 },
                    { name = "-1000°C (Space)", val = -1000.0 },
                    { name = "-273°C (Abs. Zero)", val = -273.15 },
                    { name = "-270°C (Abs. Zero)", val = -270.0 },
                    { name = "-250°C", val = -250.0 },
                    { name = "-200°C", val = -200.0 },
                    { name = "-150°C", val = -150.0 },
                    { name = "-100°C (Deep Freeze)", val = -100.0 },
                    { name = "-70°C", val = -70.0 },
                    { name = "-50°C (Siberia)", val = -50.0 },
                    { name = "-40°C (Siberia)", val = -40.0 },
                    { name = "-30°C (Siberia)", val = -30.0 },
                    { name = "-20°C (Winter)", val = -20.0 },
                    { name = "-10°C (Winter)", val = -10.0 },
                    { name = "0°C (Freezing)", val = 0.0 },
                    { name = "5°C (Cool)", val = 5.0 },
                    { name = "10°C (Cool)", val = 10.0 },
                    { name = "15°C (Cool)", val = 15.0 },
                    { name = "20°C (Standard)", val = 20.0 },
                    { name = "25°C (Standard)", val = 25.0 },
                    { name = "30°C (Summer)", val = 30.0 },
                    { name = "35°C (Summer)", val = 35.0 },
                    { name = "40°C (Summer)", val = 40.0 },
                    { name = "45°C (Desert)", val = 45.0 },
                    { name = "50°C (Desert)", val = 50.0 },
                    { name = "70°C (Desert)", val = 70.0 },
                    { name = "100°C (Boiling)", val = 100.0 },
                    { name = "150°C", val = 150.0 },
                    { name = "200°C (Oven)", val = 200.0 },
                    { name = "250°C", val = 250.0 },
                    { name = "500°C (Inferno)", val = 500.0 },
                    { name = "750°C (Inferno)", val = 750.0 },
                    { name = "1000°C (Lava)", val = 1000.0 },
                    { name = "1500°C", val = 1500.0 },
                    { name = "2000°C", val = 2000.0 },
                    { name = "2500°C", val = 2500.0 },
                    { name = "3000°C", val = 3000.0 },
                    { name = "5000°C", val = 5000.0 },
                    { name = "7500°C", val = 7500.0 },
                    { name = "10000°C", val = 10000.0 }
                }

                for idx, p in ipairs(tempPresets) do
                    local isCurrent = math.abs(_G.CheatMenu_AmbientTemp[0] - p.val) < 0.1
                    
                    -- Выделяем синим цветом текущий выбранный пресет
                    if isCurrent then
                        im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.6, 0.9, 1.0))
                    end

                    if im.Button(p.name .. "##temp_preset_" .. idx, im.ImVec2(125, 22)) then
                        applyMapTemp(p.val)
                    end

                    if isCurrent then
                        im.PopStyleColor()
                    end

                    -- Перенос строки: по 4 кнопки в ряд
                    if idx % 4 ~= 0 and idx < #tempPresets then
                        im.SameLine()
                    end
                end
            end
            
            if im.CollapsingHeader1("Weather Control & Sky Customizer") then
                -- Быстрый переход во встроенные меню погоды BeamNG и обучающий всплывающий диалог
                im.Text("Native Environment & Weather UI Shortcuts:")
                if im.Button("Open Environment Menu##btn_open_env_menu", im.ImVec2(180, 24)) then
                    guihooks.trigger('ChangeState', {state = 'pause.environment'})
                end
                im.SameLine()
                if im.Button("Open Weather Tab##btn_open_weather_tab", im.ImVec2(160, 24)) then
                    guihooks.trigger('ChangeState', {state = 'pause.environment.weather'})
                end
                im.SameLine()
                if im.Button("Weather Lesson Popup##btn_weather_popup", im.ImVec2(160, 24)) then
                    if ui_popup and ui_popup.openPopupById then
                        ui_popup.openPopupById("weather", { root = "/gameplay/discover/freeroamTutorial/lessons/" })
                    end
                end

                im.Separator()

                if weatherModule then
                    im.Separator()

                    local wPresets = weatherModule.getPresets() or {}
                    if #wPresets > 0 then
                        -- 1. Выбор пресета погоды
                        local selWeatherIdxPtr = getPtr(vehId, "sel_weather_idx", 0, "IntPtr")
                        if selWeatherIdxPtr[0] >= #wPresets then selWeatherIdxPtr[0] = 0 end
                        
                        local currentPreset = wPresets[selWeatherIdxPtr[0] + 1] or "Select Weather"
                        
                        im.SetNextItemWidth(220)
                        if im.BeginCombo("Weather Preset##combo_weather", currentPreset) then
                            for idx, pName in ipairs(wPresets) do
                                local isSelected = (selWeatherIdxPtr[0] == idx - 1)
                                if im.Selectable1(pName, isSelected) then
                                    selWeatherIdxPtr[0] = idx - 1
                                end
                            end
                            im.EndCombo()
                        end

                        -- 2. Слайдер времени перехода
                        local switchTimePtr = getPtr(vehId, "weather_switch_time", 5.0, "FloatPtr")
                        im.SetNextItemWidth(220)
                        im.SliderFloat("Transition Time##weather_time", switchTimePtr, 0.0, 60.0, "%.1f seconds")

                        -- 3. Кнопки применения
                        if im.Button("Smooth Transition##btn_switch_weather", im.ImVec2(180, 24)) then
                            weatherModule.switchWeather(wPresets[selWeatherIdxPtr[0] + 1], switchTimePtr[0])
                        end
                        
                        im.SameLine()
                        if im.Button("Instant Set##btn_activate_weather", im.ImVec2(160, 24)) then
                            weatherModule.activate(wPresets[selWeatherIdxPtr[0] + 1])
                        end
                    else
                        im.Text("No weather presets loaded on this level.")
                    end
                end

                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Extended Environment & Volumetric Sky Features:")
                im.Spacing()

                local env = core_environment or (extensions and extensions.core_environment)

                if not env then
                    im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "Environment module (core_environment) is not active.")
                else
                    -- -----------------------------------------------------------------
                    -- 1. СИНХРОНИЗАЦИЯ ВРЕМЕНИ С ЧАСАМИ ПК И ПРЕСЕТЫ СУТОК
                    -- -----------------------------------------------------------------
                    if im.TreeNode1("1. Real-Time Clock Sync & Time Presets##tree_tod_ext") then
                        if im.Button("Sync Time with PC Clock##btn_sync_pc_time", im.ImVec2(320, 26)) then
                            env.syncTimeToRealClock(2.0)
                        end
                        if im.IsItemHovered() then im.SetTooltip("Sets map time of day to your actual computer clock time!") end

                        im.SameLine()
                        if im.Button("Sync UTC Time##btn_sync_utc_time", im.ImVec2(140, 26)) then
                            env.syncTimeToRealClockUtc(2.0)
                        end

                        im.Spacing()
                        im.Text("Time of Day Presets:")

                        local todPresets = {
                            { name = "Sunrise", val = 0.775 },
                            { name = "Morning", val = 0.825 },
                            { name = "earlyNoon", val = 0.9 },
                            { name = "Noon", val = 0.0 },
                            { name = "lateNoon", val = 0.1 },
                            { name = "Afternoon", val = 0.175 },
                            { name = "evening", val = 0.23 },
                            { name = "Sunset", val = 0.245 },
                            { name = "Night", val = 0.5 }
                        }

                        for idx, p in ipairs(todPresets) do
                            if im.Button(p.name .. "##btn_tod_p_" .. idx, im.ImVec2(150, 24)) then
                                env.setTimeOfDay({ time = p.val, play = false })
                            end
                            if idx % 3 ~= 0 and idx < #todPresets then im.SameLine() end
                        end

                        im.TreePop()
                    end

                    -- -----------------------------------------------------------------
                    -- 2. ОБЛАЧНОСТЬ И ПЕРИСТЫЕ ОБЛАКА (VOLUMETRIC CLOUDS & CIRRUS)
                    -- -----------------------------------------------------------------
                    if im.TreeNode1("2. Clouds & Volumetric Sky Customizer##tree_clouds_ext") then
                        im.Text("Cumulus & Stratus Cloud Layer:")

                        -- Общая облачность
                        local curCover = env.getCloudCover and env.getCloudCover() or 0.2
                        _G.CheatMenu_CloudCover[0] = curCover
                        im.SetNextItemWidth(220)
                        if im.SliderFloat("Cloud Coverage##c_cover", _G.CheatMenu_CloudCover, 0.0, 1.0, "Coverage: %.2f") then
                            env.setCloudCover(_G.CheatMenu_CloudCover[0])
                        end

                        -- Высота основного слоя облаков
                        local curAlt = env.getCloudAltitudeKm and env.getCloudAltitudeKm() or 2.5
                        _G.CheatMenu_CloudAlt[0] = curAlt
                        im.SetNextItemWidth(220)
                        if im.SliderFloat("Cloud Altitude##c_alt", _G.CheatMenu_CloudAlt, 0.5, 15.0, "Altitude: %.1f km") then
                            env.setCloudAltitudeKm(_G.CheatMenu_CloudAlt[0])
                        end

                        im.Separator()
                        im.Text("Cirrus High Altitude Layer:")

                        -- Перистые облака (Cirrus)
                        local curCirrusCover = env.getCloudCirrusCoverage and env.getCloudCirrusCoverage() or 0.2
                        _G.CheatMenu_CirrusCover[0] = curCirrusCover
                        im.SetNextItemWidth(220)
                        if im.SliderFloat("Cirrus Coverage##cirrus_cov", _G.CheatMenu_CirrusCover, 0.0, 1.0, "Coverage: %.2f") then
                            env.setCloudCirrusCoverage(_G.CheatMenu_CirrusCover[0])
                        end

                        local curCirrusDens = env.getCloudCirrusDensity and env.getCloudCirrusDensity() or 0.5
                        _G.CheatMenu_CirrusDensity[0] = curCirrusDens
                        im.SetNextItemWidth(220)
                        if im.SliderFloat("Cirrus Density##cirrus_dens", _G.CheatMenu_CirrusDensity, 0.0, 2.0, "Density: %.2f") then
                            env.setCloudCirrusDensity(_G.CheatMenu_CirrusDensity[0])
                        end

                        local curCirrusAlt = env.getCloudCirrusAltitudeKm and env.getCloudCirrusAltitudeKm() or 8.0
                        _G.CheatMenu_CirrusAlt[0] = curCirrusAlt
                        im.SetNextItemWidth(220)
                        if im.SliderFloat("Cirrus Altitude(km)##cirrus_alt", _G.CheatMenu_CirrusAlt, 4.0, 20.0, "Altitude: %.1f km") then
                            env.setCloudCirrusAltitudeKm(_G.CheatMenu_CirrusAlt[0])
                        end

                        im.Spacing()
                        -- Перегенерация узора облачности
                        im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.6, 0.8, 1.0))
                        if im.Button("Regenerate Cloud Weather Map##btn_regen_clouds", im.ImVec2(340, 26)) then
                            env.regenerateWeatherMap()
                        end
                        im.PopStyleColor()

                        im.TreePop()
                    end

                    -- -----------------------------------------------------------------
                    -- 4. СЛЕДЫ ШИН И УЛИЧНОЕ ОСВЕЩЕНИЕ (TIRE MARKS & MAP UTILITIES)
                    -- -----------------------------------------------------------------
                    if im.TreeNode1("4. Map Utilities & Tire Marks##tree_map_utils") then
                        if im.Button("Clear All Tire Marks from Map##btn_clear_tires", im.ImVec2(320, 26)) then
                            env.resetTireMarks()
                        end
                        if im.IsItemHovered() then im.SetTooltip("Instantly erases all tire rubber skid marks from roads across the entire map!") end

                        im.SameLine()
                        if im.Button("Refresh Street Lights##btn_ref_lights", im.ImVec2(240, 26)) then
                            env.refreshnightLightsObjects()
                        end

                        if im.Button("Reload Surface GroundModels##btn_rel_gm", im.ImVec2(360, 26)) then
                            env.reloadGroundModels()
                        end

                        im.SameLine()
                        if im.Button("Dump GroundModels to JSON##btn_dump_gm", im.ImVec2(200, 26)) then
                            env.dumpGroundModels()
                        end

                        im.TreePop()
                    end
                end
            end
            if im.CollapsingHeader1("Fog & Atmosphere Settings") then
                local levelInfo = scenetree.findObject("theLevelInfo") or scenetree.findObjectOfClass("LevelInfo")
                if levelInfo then

                    -- 1. Плотность тумана (fogDensity)
                    local fogDensityVal = tonumber(levelInfo.fogDensity) or 0.0
                    local fogDensityPtr = getPtr(0, "fog_density", fogDensityVal, "FloatPtr")
                    if not im.IsItemActive() then fogDensityPtr[0] = fogDensityVal end
                    im.SetNextItemWidth(200)
                    -- Используем логарифмический слайдер, так как плотность тумана обычно настраивается в малых долях (от 0.0001 до 0.1)
                    if im.SliderFloat("Fog Density##fog_density", fogDensityPtr, 0.0, 0.5, "%.5f", im.SliderFlags_Logarithmic) then
                        levelInfo.fogDensity = fogDensityPtr[0]
                        levelInfo:postApply()
                        if core_environment then core_environment.setFogDensity(fogDensityPtr[0]) end
                    end

                    -- 2. Смещение начала тумана (высота над землей, где туман отсутствует)
                    local fogOffsetVal = tonumber(levelInfo.fogDensityOffset) or 0.0
                    local fogOffsetPtr = getPtr(0, "fog_offset", fogOffsetVal, "FloatPtr")
                    if not im.IsItemActive() then fogOffsetPtr[0] = fogOffsetVal end
                    im.SetNextItemWidth(200)
                    if im.SliderFloat("Fog Offset##fog_offset", fogOffsetPtr, 0.0, 1000.0, "%.1f m") then
                        levelInfo.fogDensityOffset = fogOffsetPtr[0]
                        levelInfo:postApply()
                    end

                    -- 3. Высота атмосферного тумана (верхний предел распределения)
                    local fogHeightVal = tonumber(levelInfo.fogAtmosphereHeight) or 0.0
                    local fogHeightPtr = getPtr(0, "fog_height", fogHeightVal, "FloatPtr")
                    if not im.IsItemActive() then fogHeightPtr[0] = fogHeightVal end
                    im.SetNextItemWidth(200)
                    if im.SliderFloat("Atmosphere Height##fog_height", fogHeightPtr, 0.0, 5000.0, "%.1f m") then
                        levelInfo.fogAtmosphereHeight = fogHeightPtr[0]
                        levelInfo:postApply()
                    end

                    -- 4. Выбор цвета тумана (fogColor)
                    local colorStr = levelInfo:getField("fogColor", "")
                    local colorData = stringToPaintData(colorStr) -- использование вашей функции разбора строк
                    
                    local colorPtr = im.ArrayFloat(3)
                    colorPtr[0] = colorData[1]
                    colorPtr[1] = colorData[2]
                    colorPtr[2] = colorData[3]
                    
                    im.SetNextItemWidth(200)
                    if im.ColorEdit3("Fog Color##fog_color", colorPtr) then
                        local newColorStr = string.format("%f %f %f %f", colorPtr[0], colorPtr[1], colorPtr[2], colorData[4])
                        levelInfo:setField("fogColor", 0, newColorStr)
                        levelInfo:postApply()
                    end
                end
            end
            if im.CollapsingHeader1("Wind & Air Turbulence Controls (3D)##wind_ctrl_hdr") then
                
                local function getCompassDirText(deg)
                    deg = (deg % 360 + 360) % 360
                    if deg >= 337.5 or deg < 22.5 then return "N (North / Север)"
                    elseif deg >= 22.5 and deg < 67.5 then return "NE (North-East / СВ)"
                    elseif deg >= 67.5 and deg < 112.5 then return "E (East / Восток)"
                    elseif deg >= 112.5 and deg < 157.5 then return "SE (South-East / ЮВ)"
                    elseif deg >= 157.5 and deg < 202.5 then return "S (South / Юг)"
                    elseif deg >= 202.5 and deg < 247.5 then return "SW (South-West / ЮЗ)"
                    elseif deg >= 247.5 and deg < 292.5 then return "W (West / Запад)"
                    else return "NW (North-West / СЗ)" end
                end

                -- Исправленная функция 3D физики ветра (X, Y, Z)
                local function applyWindSettings(speed, dirDeg, vertSpeed)
                    vertSpeed = vertSpeed or (_G.CheatMenu_WindVert and _G.CheatMenu_WindVert[0] or 0.0)
                    _G.CheatMenu_WindSpeed[0] = speed
                    _G.CheatMenu_WindDir[0] = dirDeg
                    _G.CheatMenu_WindVert[0] = vertSpeed

                    local rad = math.rad(dirDeg)
                    local dirX = math.sin(rad) * speed
                    local dirY = math.cos(rad) * speed
                    local dirZ = vertSpeed

                    if core_environment then
                        if core_environment.setWind then
                            core_environment.setWind(speed, dirDeg)
                        elseif core_environment.setWindSpeed then
                            core_environment.setWindSpeed(speed)
                        end
                    end

                    local levelInfo = scenetree.findObject("theLevelInfo") or scenetree.findObjectOfClass("LevelInfo")
                    if levelInfo then
                        levelInfo:setField("windSpeed", 0, tostring(speed))
                        levelInfo:setField("windDirection", 0, tostring(dirDeg))
                        levelInfo:postApply()
                    end

                    -- Передаем точный 3D вектор (X, Y, Z) прямо в физический объект машины
                    local playerVeh = be:getPlayerVehicle(0)
                    if playerVeh then
                        playerVeh:queueLuaCommand(string.format("if obj and obj.setWind then obj:setWind(%f, %f, %f) end", dirX, dirY, dirZ))
                    end
                end

                local curSpeed = _G.CheatMenu_WindSpeed[0]
                local curDir = _G.CheatMenu_WindDir[0]
                local curVert = _G.CheatMenu_WindVert[0]

                -- ТЕЛЕМЕТРИЯ ВЕТРА (Горизонтальный + Вертикальный поток)
                local vertText = "Flat (0 m/s)"
                if curVert > 0.5 then vertText = string.format("Updraft (+%.1f m/s)", curVert)
                elseif curVert < -0.5 then vertText = string.format("Downdraft (%.1f m/s)", curVert) end

                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), string.format("Live Wind: Horiz: %.1f m/s (%.0f km/h) | Vert: %s | Compass: %s", curSpeed, curSpeed * 3.6, vertText, getCompassDirText(curDir)))
                im.Spacing()

                -- ЛЕВАЯ КОЛОНКА (Слайдеры и Относительные кнопки)
                im.BeginGroup()
                    im.SetNextItemWidth(220)
                    if im.SliderFloat("Horizontal Speed##w_speed_slider", _G.CheatMenu_WindSpeed, -3000.0, 3000.0, "Horiz: %.1f m/s") then
                        applyWindSettings(_G.CheatMenu_WindSpeed[0], _G.CheatMenu_WindDir[0], _G.CheatMenu_WindVert[0])
                    end

                    im.SameLine()
                    if im.Button("Reset Wind##btn_res_wind_ctrl") then
                        applyWindSettings(0.0, 0.0, 0.0)
                    end

                    im.SetNextItemWidth(220)
                    if im.SliderFloat("Wind Angle (0-360°)##w_dir_slider", _G.CheatMenu_WindDir, 0.0, 360.0, "Angle: %.0f deg") then
                        applyWindSettings(_G.CheatMenu_WindSpeed[0], _G.CheatMenu_WindDir[0], _G.CheatMenu_WindVert[0])
                    end

                    
                    -- ВЕРТИКАЛЬНЫЙ ВЕТЕР (ВВЕРХ / ВНИЗ)
                    
                    im.Spacing()
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Vertical Wind (Up / Down Draft):")
                    
                    im.SetNextItemWidth(220)
                    if im.SliderFloat("Vertical Force (Z)##w_vert_slider", _G.CheatMenu_WindVert, -500.0, 500.0, "Z-Force: %.1f m/s") then
                        applyWindSettings(_G.CheatMenu_WindSpeed[0], _G.CheatMenu_WindDir[0], _G.CheatMenu_WindVert[0])
                    end

                    if im.Button("Downdraft (-30m/s)##w_dwn", im.ImVec2(150, 22)) then
                        applyWindSettings(_G.CheatMenu_WindSpeed[0], _G.CheatMenu_WindDir[0], -30.0)
                    end
                    im.SameLine()
                    if im.Button("Updraft (+30m/s)##w_up", im.ImVec2(150, 22)) then
                        applyWindSettings(_G.CheatMenu_WindSpeed[0], _G.CheatMenu_WindDir[0], 30.0)
                    end

                    -- Относительные кнопки направления
                    im.Spacing()
                    im.Text("Relative Wind Direction:")
                    if im.Button("Headwind##w_head", im.ImVec2(110, 22)) then
                        local pVeh = be:getPlayerVehicle(0)
                        if pVeh then
                            local fwd = pVeh:getDirectionVector()
                            local vehAngle = math.deg(math.atan2(fwd.x, fwd.y))
                            applyWindSettings(_G.CheatMenu_WindSpeed[0], vehAngle, _G.CheatMenu_WindVert[0])
                        end
                    end
                    im.SameLine()
                    if im.Button("Tailwind##w_tail", im.ImVec2(110, 22)) then
                        local pVeh = be:getPlayerVehicle(0)
                        if pVeh then
                            local fwd = pVeh:getDirectionVector()
                            local vehAngle = math.deg(math.atan2(fwd.x, fwd.y)) + 180
                            applyWindSettings(_G.CheatMenu_WindSpeed[0], vehAngle, _G.CheatMenu_WindVert[0])
                        end
                    end

                    if im.Button("Crosswind Left##w_left", im.ImVec2(110, 22)) then
                        local pVeh = be:getPlayerVehicle(0)
                        if pVeh then
                            local fwd = pVeh:getDirectionVector()
                            local vehAngle = math.deg(math.atan2(fwd.x, fwd.y)) + 270
                            applyWindSettings(_G.CheatMenu_WindSpeed[0], vehAngle, _G.CheatMenu_WindVert[0])
                        end
                    end
                    im.SameLine()
                    if im.Button("Crosswind Right##w_right", im.ImVec2(110, 22)) then
                        local pVeh = be:getPlayerVehicle(0)
                        if pVeh then
                            local fwd = pVeh:getDirectionVector()
                            local vehAngle = math.deg(math.atan2(fwd.x, fwd.y)) + 90
                            applyWindSettings(_G.CheatMenu_WindSpeed[0], vehAngle, _G.CheatMenu_WindVert[0])
                        end
                    end
                im.EndGroup()

                
                -- ПРАВАЯ КОЛОНКА: ИНТЕРАКТИВНЫЙ ДЖОЙСТИК (БЕЗ ОШИБОК C++)
                
                im.SameLine(0, 25)
                im.BeginGroup()
                    im.Text("360° Interactive Compass Pad:")

                    local joyRadius = 60.0
                    local drawList = im.GetWindowDrawList()
                    local cursorP = im.GetCursorScreenPos()
                    local centerP = im.ImVec2(cursorP.x + joyRadius, cursorP.y + joyRadius)

                    im.InvisibleButton("##wind_joystick_pad", im.ImVec2(joyRadius * 2, joyRadius * 2))
                    local isActive = im.IsItemActive()

                    if isActive then
                        local io = im.GetIO()
                        local mX = io.MousePos.x - centerP.x
                        local mY = io.MousePos.y - centerP.y
                        local angleRad = math.atan2(mX, -mY)
                        local angleDeg = math.deg(angleRad)
                        if angleDeg < 0 then angleDeg = angleDeg + 360 end

                        applyWindSettings(_G.CheatMenu_WindSpeed[0], angleDeg, _G.CheatMenu_WindVert[0])
                    end

                    local colOuter = im.GetColorU322(im.ImVec4(0.12, 0.14, 0.18, 0.9))
                    local colBorder = im.GetColorU322(isActive and im.ImVec4(0.2, 0.8, 1.0, 1.0) or im.ImVec4(0.4, 0.6, 0.8, 0.8))
                    local colGrid = im.GetColorU322(im.ImVec4(0.3, 0.35, 0.4, 0.4))
                    local colText = im.GetColorU322(im.ImVec4(0.9, 0.9, 0.9, 0.9))

                    -- РЕНДЕР КРУГОВ И СЕТКИ С ПОЛНЫМ НАБОРОМ АРГУМЕНТОВ
                    drawList:AddCircleFilled(centerP, joyRadius, colOuter, 36)
                    drawList:AddCircle(centerP, joyRadius, colBorder, 36, 2.0)
                    drawList:AddCircle(centerP, joyRadius * 0.5, colGrid, 36, 1.0)

                    drawList:AddLine(im.ImVec2(centerP.x - joyRadius + 5, centerP.y), im.ImVec2(centerP.x + joyRadius - 5, centerP.y), colGrid, 1.0)
                    drawList:AddLine(im.ImVec2(centerP.x, centerP.y - joyRadius + 5), im.ImVec2(centerP.x, centerP.y + joyRadius - 5), colGrid, 1.0)

                    drawList:AddText1(im.ImVec2(centerP.x - 4, centerP.y - joyRadius + 3), colText, "N")
                    drawList:AddText1(im.ImVec2(centerP.x - 4, centerP.y + joyRadius - 15), colText, "S")
                    drawList:AddText1(im.ImVec2(centerP.x + joyRadius - 14, centerP.y - 7), colText, "E")
                    drawList:AddText1(im.ImVec2(centerP.x - joyRadius + 5, centerP.y - 7), colText, "W")

                    local curRad = math.rad(_G.CheatMenu_WindDir[0])
                    local arrowLen = joyRadius * 0.78
                    local knobX = centerP.x + arrowLen * math.sin(curRad)
                    local knobY = centerP.y - arrowLen * math.cos(curRad)
                    local knobP = im.ImVec2(knobX, knobY)

                    local colArrow = im.GetColorU322(im.ImVec4(1.0, 0.4, 0.1, 1.0))
                    local colKnob = im.GetColorU322(im.ImVec4(1.0, 0.6, 0.2, 1.0))

                    -- Исправленные вызовы отрисовки стрелки и маркера (с указанием всех 5 аргументов)
                    drawList:AddLine(centerP, knobP, colArrow, 3.0)
                    drawList:AddCircleFilled(knobP, 7.0, colKnob, 16) -- Передано 16 сегментов
                    drawList:AddCircle(knobP, 7.0, im.GetColorU322(im.ImVec4(1.0, 1.0, 1.0, 1.0)), 16, 1.5)

                im.EndGroup()

                -- Пресеты силы
                im.Spacing()
                im.Text("Wind Force Presets:")

                local windPresets = {
                    { name = "0 m/s (Calm)", speed = 0.0 },
                    { name = "5 m/s (Breeze)", speed = 5.0 },
                    { name = "15 m/s (Strong)", speed = 15.0 },
                    { name = "30 m/s (Gale)", speed = 30.0 },
                    { name = "60 m/s (Storm)", speed = 60.0 },
                    { name = "100 m/s (Hurricane)", speed = 100.0 },
                    { name = "180 m/s (Tornado)", speed = 180.0 },
                    { name = "300 m/s (Supersonic)", speed = 300.0 }
                }

                for idx, w in ipairs(windPresets) do
                    local isCurrent = math.abs(_G.CheatMenu_WindSpeed[0] - w.speed) < 0.5
                    
                    if isCurrent then
                        im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.6, 0.9, 1.0))
                    end

                    if im.Button(w.name .. "##w_preset_" .. idx, im.ImVec2(125, 22)) then
                        applyWindSettings(w.speed, _G.CheatMenu_WindDir[0], _G.CheatMenu_WindVert[0])
                    end

                    if isCurrent then
                        im.PopStyleColor()
                    end

                    if idx % 4 ~= 0 and idx < #windPresets then
                        im.SameLine()
                    end
                end
            end
            im.Separator()

            if im.CollapsingHeader1("Paint Car") then
                -- ПОЛНОЦЕННЫЙ РЕДАКТОР ЦВЕТА И ПАЛИТРЫ АВТОМОБИЛЯ (Metallic Paint, Palette & Random Biased Paint)
                if im.CollapsingHeader1("Full Paint & Palette Editor##full_color_editor") then
                    local playerVeh = be:getPlayerVehicle(0)
                    if playerVeh then
                        local vId = playerVeh:getID()
                        
                        -- Настройка вероятности выбора стандартного/реалистичного цвета
                        if _G.CheatMenu_CommonPaintProb == nil then _G.CheatMenu_CommonPaintProb = im.FloatPtr(0.7) end
                        im.SetNextItemWidth(180)
                        im.SliderFloat("Real-world Bias Rate##paint_bias", _G.CheatMenu_CommonPaintProb, 0.0, 1.0, "Realism: %.2f")
                        if im.IsItemHovered() then 
                            im.SetTooltip("Higher values increase the probability of getting common colors like Black, White, Grey or Red.") 
                        end
                        
                        -- Кнопка генератора случайного цвета с учетом смещения к реальным цветам
                        if im.Button("Apply Biased Random Color##btn_rand_biased_paint", im.ImVec2(-1, 24)) then
                            local paintName, paintData = getRandomPaint(vId, _G.CheatMenu_CommonPaintProb[0])
                            if paintData then
                                -- Применяем базовый цвет через Point4F во избежание ошибок биндинга
                                local bc = paintData.baseColor or {1, 1, 1, 1}
                                playerVeh.color = Point4F(bc[1], bc[2], bc[3], bc[4])
                                
                                -- Конвертируем и применяем параметры металлика
                                local metStr = vehicleMetallicPaintString(
                                    paintData.metallic or 0.2, 
                                    paintData.roughness or 0.5, 
                                    paintData.clearcoat or 0.8, 
                                    paintData.clearcoatRoughness or 0.0
                                )
                                playerVeh:setField('metallicPaintData', 0, metStr)
                                log('I', 'CheatMenu', 'Applied paint preset: ' .. tostring(paintName))
                            end
                        end
                        im.Separator()
                        
                        -- Отрисовка настройки слоев краски
                        local layers = {
                            { name = "Primary Paint Layer 0 (Base)", field = "color", metIndex = 0 },
                            { name = "Secondary Paint Layer 1 (Palette 1)", field = "colorPalette0", metIndex = 1 },
                            { name = "Details Paint Layer 2 (Palette 2)", field = "colorPalette1", metIndex = 2 }
                        }
                        
                        for _, layer in ipairs(layers) do
                            if im.TreeNode1(layer.name .. "##tree_layer_" .. layer.field) then
                                -- Чтение и редактирование RGBA цвета через ImGui ColorEdit4 с использованием Point4F
                                local curColor = playerVeh[layer.field] or Point4F(1, 1, 1, 1)
                                local colArr = im.ArrayFloat(4)
                                colArr[0], colArr[1], colArr[2], colArr[3] = curColor.x, curColor.y, curColor.z, curColor.w
                                
                                im.SetNextItemWidth(220)
                                if im.ColorEdit4("Base Color##col_" .. layer.field, colArr) then
                                    -- Передаем Point4F вместо ColorF во избежание краша
                                    playerVeh[layer.field] = Point4F(colArr[0], colArr[1], colArr[2], colArr[3])
                                end
                                
                                -- Настройка характеристик Metallic, Roughness, Clearcoat для выбранного слоя
                                im.Spacing()
                                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Metallic & Reflective Parameters:")
                                drawPaintLayerSliders(playerVeh, layer.metIndex)
                                
                                im.TreePop()
                            end
                        end
                    else
                        im.Text("Please enter a vehicle to edit paint parameters.")
                    end
                end
                if im.CollapsingHeader1("Metallic Paint & Coat Editor##full_color_editor") then
                    local veh = be:getPlayerVehicle(0)
                    if veh then
                        if im.CollapsingHeader1("Base Paint Layer 0##paint_layer_0") then
                            drawPaintLayerSliders(veh, 0)
                        end
                        if im.CollapsingHeader1("Secondary Paint Layer 1##paint_layer_1") then
                            drawPaintLayerSliders(veh, 1)
                        end
                        if im.CollapsingHeader1("Details Paint Layer 2##paint_layer_2") then
                            drawPaintLayerSliders(veh, 2)
                        end
                    end
                end
                if im.CollapsingHeader1("Factory Paint Presets & Random##full_color_editor") then
                    local playerVeh = be:getPlayerVehicle(0)
                    if playerVeh then
                        local vehId = playerVeh:getID()
                        local modelName = playerVeh.JBeam
                        
                        -- Кнопка выбора случайного цвета из распределения автомобиля
                        if im.Button("Apply Random Paint Car##btn_rand_paint_act", im.ImVec2(-1, 25)) then
                            local paintsModule = core_vehiclePaints or (extensions and extensions.core_vehiclePaints)
                            local vManager = core_vehicle_manager or (extensions and extensions.core_vehicle_manager)
                            if paintsModule and vManager then
                                -- Вызываем функцию из вашего core_vehiclePaints
                                local randomPaintsList = paintsModule.getRandomPaintsByVehicle(vehId)
                                if randomPaintsList then
                                    vManager.setVehicleColorsNames(vehId, randomPaintsList)
                                end
                            end
                        end
                        
                        im.Spacing()
                        im.Text("Factory Paint Presets:")
                        
                        local modelData = core_vehicles and core_vehicles.getModel(modelName)
                        local paintsDict = modelData and modelData.model and modelData.model.paints
                        
                        if paintsDict then
                            local paintNames = {}
                            for pName, _ in pairs(paintsDict) do
                                table.insert(paintNames, pName)
                            end
                            table.sort(paintNames)
                            
                            if #paintNames > 0 then
                                local selPaintIdxPtr = getPtr(vehId, "sel_factory_paint_idx", 0, "IntPtr")
                                if selPaintIdxPtr[0] >= #paintNames then selPaintIdxPtr[0] = 0 end
                                
                                local chosenPaintName = paintNames[selPaintIdxPtr[0] + 1]
                                im.SetNextItemWidth(-1)
                                if im.BeginCombo("Select Color##combo_factory_paints", chosenPaintName) then
                                    for idx, pName in ipairs(paintNames) do
                                        local isSelected = (selPaintIdxPtr[0] == idx - 1)
                                        if im.Selectable1(pName, isSelected) then
                                            selPaintIdxPtr[0] = idx - 1
                                            
                                            local vManager = core_vehicle_manager or (extensions and extensions.core_vehicle_manager)
                                            if vManager then
                                                -- Применяем выбранный цвет на все три слоя
                                                vManager.setVehicleColorsNames(vehId, {pName, pName, pName})
                                            end
                                        end
                                    end
                                    im.EndCombo()
                                end
                            else
                                im.Text("No factory paints found for this vehicle model.")
                            end
                        else
                            im.Text("Failed to retrieve vehicle paints dictionary.")
                        end

                        -- Отрисовка многоцветных макетов (Two-Tone / Ливреи)
                        local multiSetups = modelData and modelData.model and modelData.model.multiPaintSetups
                        if multiSetups and #multiSetups > 0 then
                            im.Spacing()
                            im.Text("Multi-Paint Setups:")
                            
                            local selSetupIdxPtr = getPtr(vehId, "sel_multi_setup_idx", 0, "IntPtr")
                            if selSetupIdxPtr[0] >= #multiSetups then selSetupIdxPtr[0] = 0 end
                            
                            local chosenSetup = multiSetups[selSetupIdxPtr[0] + 1]
                            local chosenSetupName = chosenSetup and chosenSetup.name or "Select Setup"
                            
                            im.SetNextItemWidth(-1)
                            if im.BeginCombo("Select Design##combo_multi_setups", chosenSetupName) then
                                for idx, setup in ipairs(multiSetups) do
                                    local isSelected = (selSetupIdxPtr[0] == idx - 1)
                                    if im.Selectable1(setup.name, isSelected) then
                                        selSetupIdxPtr[0] = idx - 1
                                        
                                        local vManager = core_vehicle_manager or (extensions and extensions.core_vehicle_manager)
                                        if vManager then
                                            -- Применяем макет из 3 цветов к палитрам
                                            vManager.setVehicleColorsNames(vehId, {
                                                setup.paintName1 or "White",
                                                setup.paintName2 or setup.paintName1 or "White",
                                                setup.paintName3 or setup.paintName1 or "White"
                                            })
                                        end
                                    end
                                end
                                im.EndCombo()
                            end
                        end
                    end
                end
                im.Separator()
            end
            
            if im.CollapsingHeader1("Rainbow Painting Car Mode##rainbow_mode_hdr") then
                im.TextColored(im.ImVec4(1.0, 0.4, 0.8, 1.0), "Smooth HSV Spectrum Cycling:")
                
                -- Включатель радуги
                if im.Checkbox("Enable Rainbow Mode##chk_rainbow_active", _G.CheatMenu_Rainbow_Enabled) then
                    -- Если включили радугу, отключаем авто-покраску Triad во избежание конфликта
                    if _G.CheatMenu_Rainbow_Enabled[0] and _G.CheatMenu_AutoPaint_Enabled then
                        _G.CheatMenu_AutoPaint_Enabled[0] = false
                    end
                end

                if _G.CheatMenu_Rainbow_Enabled[0] then
                    im.Spacing()

                    -- 1. Регулировка скорости
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Rainbow Speed##rb_speed", _G.CheatMenu_Rainbow_Speed, 0.1, 300.0, "Speed: %.1fx")

                    -- 2. Регулировка насыщенности
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Color Saturation##rb_sat", _G.CheatMenu_Rainbow_Sat, 0.0, 1.0, "Saturation: %.2f")

                    -- 3. Регулировка яркости
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Color Brightness##rb_val", _G.CheatMenu_Rainbow_Val, 0.1, 1.0, "Brightness: %.2f")

                    -- 4. Глянец / Хром
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Gloss / Chrominess##rb_gloss", _G.CheatMenu_Rainbow_Gloss, 0.0, 2.0, "Gloss: %.2f")

                    im.Separator()
                    im.Text("Palette Layers Phase Shift:")

                    -- 5. Сдвиг оттенка для 2-го слоя кузова
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Layer 1 Phase Shift##rb_s1", _G.CheatMenu_Rainbow_ShiftLayer1, 0.0, 1.0, "Shift: %.2f")

                    -- 6. Сдвиг оттенка для 3-го слоя кузова
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Layer 2 Phase Shift##rb_s2", _G.CheatMenu_Rainbow_ShiftLayer2, 0.0, 1.0, "Shift: %.2f")
                end
            end

            if im.CollapsingHeader1("Window Tint & Custom Color Editor##glass_tint_header") then
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Custom Window Tint & Coloring System:")
                
                local tintChanged = false
                
                -- Выключатель тонировки
                if im.Checkbox("Enable Custom Window Tint##chk_glass_tint", _G.CheatMenu_GlassTint_Enabled) then
                    tintChanged = true
                end
                
                if _G.CheatMenu_GlassTint_Enabled[0] then
                    im.Spacing()
                    im.Text("Tint Color:")
                    im.SetNextItemWidth(220)
                    if im.ColorEdit3("Color Picker##glass_col_picker", _G.CheatMenu_GlassTint_Color) then
                        tintChanged = true
                    end
                    
                    im.Spacing()
                    im.SetNextItemWidth(220)
                    -- Позволяем доводить плотность тонировки до полных 1.0 (глухая заливка) [2]
                    if im.SliderFloat("Tint Opacity (Darkness)##slider_glass_alpha", _G.CheatMenu_GlassTint_Alpha, 0.0, 1.0, "Darkness: %.2f") then
                        tintChanged = true
                    end
                    
                    -- Режим глухой покраски (Solid Paint) [2]
                    if im.Checkbox("Paint Mode (100% Solid Opaque Paint)##chk_glass_solid", _G.CheatMenu_GlassTint_Solid) then
                        tintChanged = true
                    end
                    if im.IsItemHovered() then im.SetTooltip("Disables glass translucency completely, turning the windows into a solid, painted surface (like car body panel) [2].") end
                end
                
                -- КНОПКА ВОЗВРАТА К ЗАВОДСКИМ ПАРАМЕТРАМ [2]
                im.Spacing()
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.4, 0.4, 0.4, 1.0))
                if im.Button("Reset Glass to Factory Defaults##btn_reset_glass", im.ImVec2(-1, 24)) then
                    _G.CheatMenu_GlassTint_Enabled[0] = false
                    _G.CheatMenu_GlassTint_Solid[0] = false
                    _G.CheatMenu_GlassTint_Alpha[0] = 0.8
                    _G.CheatMenu_GlassTint_Color[0], _G.CheatMenu_GlassTint_Color[1], _G.CheatMenu_GlassTint_Color[2] = 0.0, 0.0, 0.0
                    
                    -- Восстанавливаем оригинальные материалы из кэша [2]
                    applyGlassTintGE(v.JBeam, 1.0, 1.0, 1.0, 0.0, false, true)
                end
                im.PopStyleColor()
                
                -- Если пользователь изменил параметры тонировки или выключил её
                if tintChanged then
                    if _G.CheatMenu_GlassTint_Enabled[0] then
                        applyGlassTintGE(
                            v.JBeam, 
                            _G.CheatMenu_GlassTint_Color[0], 
                            _G.CheatMenu_GlassTint_Color[1], 
                            _G.CheatMenu_GlassTint_Color[2], 
                            _G.CheatMenu_GlassTint_Alpha[0],
                            _G.CheatMenu_GlassTint_Solid[0], -- Передаем флаг глухой покраски [2]
                            false
                        )
                    else
                        -- Сбрасываем стекла в прозрачное состояние при выключении галочки [2]
                        applyGlassTintGE(v.JBeam, 1.0, 1.0, 1.0, 0.0, false, false)
                    end
                end
            end

            if im.CollapsingHeader1("Headlights & Neon Underglow Editor##lights_editor_header") then
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Real-time Headlights & Neon Adjuster:")
                
                local lightsChanged = false
                
                -- 1. ТЮНИНГ ФАР (Headlights)
                if im.TreeNode1("Headlights Customizer##tree_headlights") then
                    if im.Checkbox("Enable Custom Headlights Settings##chk_hLights", _G.CheatMenu_Headlight_Enabled) then
                        lightsChanged = true
                    end
                    
                    if _G.CheatMenu_Headlight_Enabled[0] then
                        im.SetNextItemWidth(180)
                        -- Логарифмический слайдер яркости до 50x
                        if im.SliderFloat("Brightness##slider_hBright", _G.CheatMenu_Headlight_Brightness, 0.1, 150.0, "%.1fx", im.SliderFlags_Logarithmic) then
                            lightsChanged = true
                        end
                        if im.IsItemHovered() then im.SetTooltip("Scales headlight intensity and range. Great for night driving!") end
                        
                        im.SetNextItemWidth(220)
                        if im.ColorEdit3("Light Color##hColor_picker", _G.CheatMenu_Headlight_Color) then
                            lightsChanged = true
                        end
                    end
                    im.TreePop()
                end
                
                -- 2. ТЮНИНГ НЕОНА (Neon Underglow)
                if im.TreeNode1("Neon Underglow Customizer##tree_neon") then
                    if im.Checkbox("Enable Custom Neon Settings##chk_neon", _G.CheatMenu_Neon_Enabled) then
                        lightsChanged = true
                    end
                    
                    if _G.CheatMenu_Neon_Enabled[0] then
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Brightness##slider_nBright", _G.CheatMenu_Neon_Brightness, 0.1, 150.0, "%.1fx", im.SliderFlags_Logarithmic) then
                            lightsChanged = true
                        end
                        if im.IsItemHovered() then im.SetTooltip("Scales underglow neon intensity.") end
                        
                        im.SetNextItemWidth(220)
                        if im.ColorEdit3("Neon Color##nColor_picker", _G.CheatMenu_Neon_Color) then
                            lightsChanged = true
                        end
                    end
                    im.TreePop()
                end
                
                -- Кнопка сброса фар и неона к заводским (Factory Reset)
                im.Spacing()
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.4, 0.4, 0.4, 1.0))
                if im.Button("Reset Headlights & Neon to Defaults##btn_reset_lights", im.ImVec2(-1, 24)) then
                    _G.CheatMenu_Headlight_Enabled[0] = false
                    _G.CheatMenu_Headlight_Brightness[0] = 1.0
                    _G.CheatMenu_Headlight_Color[0], _G.CheatMenu_Headlight_Color[1], _G.CheatMenu_Headlight_Color[2] = 1.0, 1.0, 1.0
                    
                    _G.CheatMenu_Neon_Enabled[0] = false
                    _G.CheatMenu_Neon_Brightness[0] = 1.0
                    _G.CheatMenu_Neon_Color[0], _G.CheatMenu_Neon_Color[1], _G.CheatMenu_Neon_Color[2] = 0.0, 1.0, 1.0
                    
                    -- Восстанавливаем оригинальные параметры из бэкапа (включая цвет свечения на кузове!)
                    adjustVehicleLightsGE(vehId, 1.0, {1, 1, 1}, 1.0, {0, 1, 1}, true, v.JBeam)
                end
                im.PopStyleColor()
                
                -- Обработка изменений в реальном времени [2]
                if lightsChanged then
                    local hB = _G.CheatMenu_Headlight_Enabled[0] and _G.CheatMenu_Headlight_Brightness[0] or 1.0
                    local hC = _G.CheatMenu_Headlight_Enabled[0] and _G.CheatMenu_Headlight_Color or {1, 1, 1}
                    
                    local nB = _G.CheatMenu_Neon_Enabled[0] and _G.CheatMenu_Neon_Brightness[0] or 1.0
                    local nC = _G.CheatMenu_Neon_Enabled[0] and _G.CheatMenu_Neon_Color or {0, 1, 1}
                    
                    adjustVehicleLightsGE(vehId, hB, hC, nB, nC, false, v.JBeam)
                end
                im.PopStyleColor()
                
                -- Обработка изменений в реальном времени
                if lightsChanged then
                    local hB = _G.CheatMenu_Headlight_Enabled[0] and _G.CheatMenu_Headlight_Brightness[0] or 1.0
                    local hC = _G.CheatMenu_Headlight_Enabled[0] and _G.CheatMenu_Headlight_Color or {1, 1, 1}
                    
                    local nB = _G.CheatMenu_Neon_Enabled[0] and _G.CheatMenu_Neon_Brightness[0] or 1.0
                    local nC = _G.CheatMenu_Neon_Enabled[0] and _G.CheatMenu_Neon_Color or {0, 1, 1}
                    
                    adjustVehicleLightsGE(vehId, hB, hC, nB, nC, false)
                end
            end
            
            if im.CollapsingHeader1("Procedural Triad Auto-Painter (Smooth Colors)##procedural_paint_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Procedural Color Flow & Instant Painter:")
                im.Text("Harmonious 3-color palette generation with zero-lag smooth transitions.")

                -- 1. Кнопка однократного мгновенного перекраса
                if im.Button("Instant Random Triad Repaint##btn_instant_triad", im.ImVec2(-1, 26)) then
                    local playerVeh = be:getPlayerVehicle(0)
                    if playerVeh then
                        local p, s, t = generateTriadColors()
                        playerVeh.color = p
                        playerVeh.colorPalette0 = s
                        playerVeh.colorPalette1 = t
                        if core_vehicles and core_vehicles.updateVehicleColors then
                            core_vehicles.updateVehicleColors(playerVeh:getID())
                        end
                    end
                end

                im.Separator()

                -- 2. Включатель постоянного авто-перелива
                im.Checkbox("Enable Dynamic Color Flow (Auto-Paint)##chk_auto_paint", _G.CheatMenu_AutoPaint_Enabled)

                if _G.CheatMenu_AutoPaint_Enabled[0] then
                    im.Spacing()

                    -- 3. Ползунок скорости (частота слены целей)
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Change Frequency (Speed)##slider_ap_speed", _G.CheatMenu_AutoPaint_Speed, 0.1, 10.0, "Speed: %.1fx")
                    if im.IsItemHovered() then im.SetTooltip("Controls how often new random colors are picked.") end

                    -- 4. Ползунок плавности (перетекания)
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Transition Smoothness (Fade)##slider_ap_smooth", _G.CheatMenu_AutoPaint_Smoothness, 0.2, 15.0, "Smoothness: %.1f")
                    if im.IsItemHovered() then im.SetTooltip("Lower = ultra smooth & slow color fade. Higher = snappy fast color mix.") end

                    im.Spacing()

                    -- 5. Выбор палитры стиля (Vivid, Pastel, Any)
                    local paintModes = { "Vivid (Яркие)", "Pastel (Пастельные)", "Any (Любые случайные)" }
                    local curModeStr = paintModes[_G.CheatMenu_AutoPaint_ModeIdx + 1] or "Vivid"
                    
                    im.SetNextItemWidth(220)
                    if im.BeginCombo("Color Style Mode##combo_ap_mode", curModeStr) then
                        for idx, mName in ipairs(paintModes) do
                            local isSel = (_G.CheatMenu_AutoPaint_ModeIdx == idx - 1)
                            if im.Selectable1(mName, isSel) then
                                _G.CheatMenu_AutoPaint_ModeIdx = idx - 1
                            end
                        end
                        im.EndCombo()
                    end

                    -- 6. Диапазон хромированности/глянцевости (Gloss/Chrome)
                    im.SetNextItemWidth(150)
                    im.SliderFloat("Gloss Min##ap_cmin", _G.CheatMenu_AutoPaint_ChromeMin, 0.0, 2.0, "%.2f")
                    im.SameLine()
                    im.SetNextItemWidth(150)
                    im.SliderFloat("Gloss Max##ap_cmax", _G.CheatMenu_AutoPaint_ChromeMax, 0.0, 2.0, "%.2f")

                    -- 7. Минимальный разнос оттенков
                    im.SetNextItemWidth(220)
                    im.SliderFloat("Min Hue Gap##ap_huegap", _G.CheatMenu_AutoPaint_MinHueGap, 0.05, 0.40, "Gap: %.2f")
                end
            end
            
            if im.CollapsingHeader1("Paint Parts and Components Car##comp_painter_hdr") then
                local playerVeh = be:getPlayerVehicle(0)
                if not playerVeh then
                    im.Text("Please enter a vehicle.")
                else
                    local modelName = playerVeh.JBeam
                    local categories = scanAndCategorizeVehicleMaterials(modelName)

                    -- -----------------------------------------------------------------
                    -- ГЛАВНАЯ КНОПКА ПОКРАСКИ АБСОЛЮТНО ВСЕХ ДЕТАЛЕЙ МАШИНЫ В 1 ЦВЕТ
                    -- -----------------------------------------------------------------
                    if not _G.CheatMenu_MasterPartSettings then
                        _G.CheatMenu_MasterPartSettings = {
                            col = im.ArrayFloat(3),
                            brightness = im.FloatPtr(2.5),
                            emissive = im.FloatPtr(0.15)
                        }
                        _G.CheatMenu_MasterPartSettings.col[0], _G.CheatMenu_MasterPartSettings.col[1], _G.CheatMenu_MasterPartSettings.col[2] = 1.0, 0.0, 0.0
                    end
                    local mSet = _G.CheatMenu_MasterPartSettings

                    im.TextColored(im.ImVec4(0.2, 1.0, 0.4, 1.0), "Master Painter (Paint EVERY Single Vehicle Component in 1 Color):")
                    im.SetNextItemWidth(140)
                    im.ColorEdit3("Global Color##master_col", mSet.col)
                    im.SameLine()
                    im.SetNextItemWidth(120)
                    im.SliderFloat("Boost##master_bright", mSet.brightness, 1.0, 20.0, "%.1fx")
                    im.SameLine()
                    im.SetNextItemWidth(120)
                    im.SliderFloat("Emissive##master_emiss", mSet.emissive, 0.0, 1.0, "%.2f")

                    im.PushStyleColor2(im.Col_Button, im.ImVec4(0.9, 0.4, 0.0, 1.0))
                    if im.Button("PAINT ALL VEHICLE PARTS (1 COLOR)##btn_paint_everything", im.ImVec2(270, 28)) then
                        local r, g, b = mSet.col[0], mSet.col[1], mSet.col[2]
                        for _, matList in pairs(categories) do
                            for _, mName in ipairs(matList) do
                                applyPartMaterialColorGE(mName, r, g, b, mSet.brightness[0], mSet.emissive[0], nil, nil, false)
                            end
                        end
                    end
                    im.PopStyleColor()

                    im.SameLine()
                    if im.Button("RESET ALL VEHICLE PARTS##btn_reset_everything", im.ImVec2(200, 28)) then
                        for _, matList in pairs(categories) do
                            for _, mName in ipairs(matList) do
                                applyPartMaterialColorGE(mName, 1.0, 1.0, 1.0, 1.0, 0.0, nil, nil, true)
                            end
                        end
                    end

                    im.Separator()
                    im.Spacing()

                    -- -----------------------------------------------------------------
                    -- РАЗБИВКА ПО КАТЕГОРИЯМ
                    -- -----------------------------------------------------------------
                    local hasMaterials = false
                    for catName, matList in pairs(categories) do
                        if #matList > 0 then
                            hasMaterials = true
                            
                            if im.TreeNode1(catName .. string.format(" (%d materials)##tree_cat_%s", #matList, catName)) then
                                
                                local grpKey = "grp_" .. catName
                                if not _G.CheatMenu_PartSettings[grpKey] then
                                    _G.CheatMenu_PartSettings[grpKey] = {
                                        col = im.ArrayFloat(3),
                                        brightness = im.FloatPtr(2.0),
                                        emissive = im.FloatPtr(0.15)
                                    }
                                    _G.CheatMenu_PartSettings[grpKey].col[0], _G.CheatMenu_PartSettings[grpKey].col[1], _G.CheatMenu_PartSettings[grpKey].col[2] = 1.0, 0.0, 0.0
                                end
                                local gSet = _G.CheatMenu_PartSettings[grpKey]

                                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Batch Controls for " .. catName .. ":")
                                im.SetNextItemWidth(140)
                                im.ColorEdit3("Batch Color##grp_col_" .. catName, gSet.col)
                                im.SameLine()
                                im.SetNextItemWidth(120)
                                im.SliderFloat("Boost##grp_bright_" .. catName, gSet.brightness, 1.0, 15.0, "%.1fx")
                                im.SameLine()
                                im.SetNextItemWidth(120)
                                im.SliderFloat("Emissive##grp_emiss_" .. catName, gSet.emissive, 0.0, 1.0, "%.2f")

                                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.6, 0.2, 1.0))
                                if im.Button("Paint All " .. catName .. "##btn_paint_all_" .. catName) then
                                    local r, g, b = gSet.col[0], gSet.col[1], gSet.col[2]
                                    for _, mName in ipairs(matList) do
                                        applyPartMaterialColorGE(mName, r, g, b, gSet.brightness[0], gSet.emissive[0], nil, nil, false)
                                    end
                                end
                                im.PopStyleColor()

                                im.SameLine()
                                if im.Button("Reset All " .. catName .. "##btn_res_all_" .. catName) then
                                    for _, mName in ipairs(matList) do
                                        applyPartMaterialColorGE(mName, 1.0, 1.0, 1.0, 1.0, 0.0, nil, nil, true)
                                    end
                                end

                                im.Separator()

                                for _, mName in ipairs(matList) do
                                    local singleKey = "mat_" .. mName
                                    if not _G.CheatMenu_PartSettings[singleKey] then
                                        _G.CheatMenu_PartSettings[singleKey] = {
                                            col = im.ArrayFloat(3),
                                            brightness = im.FloatPtr(2.0),
                                            emissive = im.FloatPtr(0.15)
                                        }
                                        _G.CheatMenu_PartSettings[singleKey].col[0], _G.CheatMenu_PartSettings[singleKey].col[1], _G.CheatMenu_PartSettings[singleKey].col[2] = 0.8, 0.8, 0.8
                                    end

                                    local sSet = _G.CheatMenu_PartSettings[singleKey]

                                    if im.TreeNode1(mName .. "##tree_mat_" .. mName) then
                                        local changed = false

                                        im.SetNextItemWidth(180)
                                        if im.ColorEdit3("Color##p_" .. mName, sSet.col) then changed = true end
                                        
                                        im.SetNextItemWidth(180)
                                        if im.SliderFloat("Color Boost (HDR)##b_" .. mName, sSet.brightness, 1.0, 20.0, "%.1fx") then changed = true end

                                        im.SetNextItemWidth(180)
                                        if im.SliderFloat("Emissive Force##e_" .. mName, sSet.emissive, 0.0, 1.0, "%.2f") then changed = true end

                                        if changed then
                                            applyPartMaterialColorGE(
                                                mName,
                                                sSet.col[0], sSet.col[1], sSet.col[2],
                                                sSet.brightness[0],
                                                sSet.emissive[0],
                                                nil, nil, false
                                            )
                                        end

                                        if im.Button("Reset Material##btn_res_" .. mName) then
                                            applyPartMaterialColorGE(mName, 1.0, 1.0, 1.0, 1.0, 0.0, nil, nil, true)
                                        end

                                        im.TreePop()
                                    end
                                end

                                im.TreePop()
                            end
                        end
                    end

                    if not hasMaterials then
                        im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "No customizable part materials detected for this vehicle.")
                    end
                end
            end
            
            if im.CollapsingHeader1("Paint World and Maps##world_painter_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Repaint map terrain, asphalt roads, trees, grass, buildings, and water:")
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Tip: Set Emissive to 0.2-0.5 to create a glowing Neon Cyberpunk World!")
                im.Spacing()

                local worldCategories = scanAndCategorizeWorldMaterials()

                -- 1. ГЛОБАЛЬНАЯ ПОКРАСКА ВСЕЙ КАРТЫ В 1 ЦВЕТ
                if not _G.CheatMenu_MasterWorldSettings then
                    _G.CheatMenu_MasterWorldSettings = {
                        col = im.ArrayFloat(3),
                        brightness = im.FloatPtr(2.0),
                        emissive = im.FloatPtr(0.1)
                    }
                    _G.CheatMenu_MasterWorldSettings.col[0], _G.CheatMenu_MasterWorldSettings.col[1], _G.CheatMenu_MasterWorldSettings.col[2] = 0.0, 0.8, 1.0
                end
                local wMaster = _G.CheatMenu_MasterWorldSettings

                im.TextColored(im.ImVec4(0.2, 1.0, 0.4, 1.0), "Master World Painter (Repaint ENTIRE Map in 1 Color):")
                im.SetNextItemWidth(140)
                im.ColorEdit3("Map Color##w_master_col", wMaster.col)
                im.SameLine()
                im.SetNextItemWidth(120)
                im.SliderFloat("Boost##w_master_bright", wMaster.brightness, 1.0, 20.0, "%.1fx")
                im.SameLine()
                im.SetNextItemWidth(120)
                im.SliderFloat("Emissive Glow##w_master_emiss", wMaster.emissive, 0.0, 1.0, "%.2f")

                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.0, 0.6, 0.8, 1.0))
                if im.Button("REPAINT ENTIRE MAP WORLD##btn_paint_world_all", im.ImVec2(240, 28)) then
                    local r, g, b = wMaster.col[0], wMaster.col[1], wMaster.col[2]
                    for _, matList in pairs(worldCategories) do
                        for _, mName in ipairs(matList) do
                            applyPartMaterialColorGE(mName, r, g, b, wMaster.brightness[0], wMaster.emissive[0], nil, nil, false)
                        end
                    end
                end
                im.PopStyleColor()

                im.SameLine()
                if im.Button("RESET ENTIRE MAP TO FACTORY##btn_res_world_all", im.ImVec2(230, 28)) then
                    for _, matList in pairs(worldCategories) do
                        for _, mName in ipairs(matList) do
                            applyPartMaterialColorGE(mName, 1.0, 1.0, 1.0, 1.0, 0.0, nil, nil, true)
                        end
                    end
                end

                im.Separator()
                im.Spacing()

                -- 2. ПОКРАСКА КАТЕГОРИЙ КАРТЫ (ЗЕМЛЯ, ДЕРЕВЬЯ, ЗДАНИЯ, ВОДА)
                for catName, matList in pairs(worldCategories) do
                    if #matList > 0 then
                        if im.TreeNode1(catName .. string.format(" (%d materials)##tree_wcat_%s", #matList, catName)) then
                            
                            local wGrpKey = "wgrp_" .. catName
                            if not _G.CheatMenu_WorldSettings[wGrpKey] then
                                _G.CheatMenu_WorldSettings[wGrpKey] = {
                                    col = im.ArrayFloat(3),
                                    brightness = im.FloatPtr(2.0),
                                    emissive = im.FloatPtr(0.1)
                                }
                                _G.CheatMenu_WorldSettings[wGrpKey].col[0], _G.CheatMenu_WorldSettings[wGrpKey].col[1], _G.CheatMenu_WorldSettings[wGrpKey].col[2] = 0.2, 0.9, 0.2
                            end
                            local wSet = _G.CheatMenu_WorldSettings[wGrpKey]

                            im.SetNextItemWidth(140)
                            im.ColorEdit3("Group Color##wgrp_col_" .. catName, wSet.col)
                            im.SameLine()
                            im.SetNextItemWidth(120)
                            im.SliderFloat("Boost##wgrp_b_" .. catName, wSet.brightness, 1.0, 15.0, "%.1fx")
                            im.SameLine()
                            im.SetNextItemWidth(120)
                            im.SliderFloat("Emissive##wgrp_e_" .. catName, wSet.emissive, 0.0, 1.0, "%.2f")

                            im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.6, 0.2, 1.0))
                            if im.Button("Paint Category " .. catName .. "##btn_paint_wcat_" .. catName) then
                                local r, g, b = wSet.col[0], wSet.col[1], wSet.col[2]
                                for _, mName in ipairs(matList) do
                                    applyPartMaterialColorGE(mName, r, g, b, wSet.brightness[0], wSet.emissive[0], nil, nil, false)
                                end
                            end
                            im.PopStyleColor()

                            im.SameLine()
                            if im.Button("Reset Category##btn_res_wcat_" .. catName) then
                                for _, mName in ipairs(matList) do
                                    applyPartMaterialColorGE(mName, 1.0, 1.0, 1.0, 1.0, 0.0, nil, nil, true)
                                end
                            end

                            im.Separator()

                            -- Список конкретных материалов на карте
                            for _, mName in ipairs(matList) do
                                local wSingleKey = "wmat_" .. mName
                                if not _G.CheatMenu_WorldSettings[wSingleKey] then
                                    _G.CheatMenu_WorldSettings[wSingleKey] = {
                                        col = im.ArrayFloat(3),
                                        brightness = im.FloatPtr(2.0),
                                        emissive = im.FloatPtr(0.1)
                                    }
                                    _G.CheatMenu_WorldSettings[wSingleKey].col[0], _G.CheatMenu_WorldSettings[wSingleKey].col[1], _G.CheatMenu_WorldSettings[wSingleKey].col[2] = 0.8, 0.8, 0.8
                                end
                                local wsSet = _G.CheatMenu_WorldSettings[wSingleKey]

                                if im.TreeNode1(mName .. "##tree_wmat_" .. mName) then
                                    local changed = false

                                    im.SetNextItemWidth(180)
                                    if im.ColorEdit3("Color##wp_" .. mName, wsSet.col) then changed = true end

                                    im.SetNextItemWidth(180)
                                    if im.SliderFloat("Color Boost##wb_" .. mName, wsSet.brightness, 1.0, 20.0, "%.1fx") then changed = true end

                                    im.SetNextItemWidth(180)
                                    if im.SliderFloat("Emissive Glow##we_" .. mName, wsSet.emissive, 0.0, 1.0, "%.2f") then changed = true end

                                    if changed then
                                        applyPartMaterialColorGE(
                                            mName,
                                            wsSet.col[0], wsSet.col[1], wsSet.col[2],
                                            wsSet.brightness[0],
                                            wsSet.emissive[0],
                                            nil, nil, false
                                        )
                                    end

                                    if im.Button("Reset Map Material##btn_wres_" .. mName) then
                                        applyPartMaterialColorGE(mName, 1.0, 1.0, 1.0, 1.0, 0.0, nil, nil, true)
                                    end

                                    im.TreePop()
                                end
                            end

                            im.TreePop()
                        end
                    end
                end
            end

            im.Separator()
            -- ПАНЕЛЬ SMOKE TUNER (ДЫМ ОТ ПОКРЫШЕК - С ПАЛИТРОЙ И ТРОТТЛИНГОМ)
            if im.CollapsingHeader1("SMOKE TUNER (Experimental)##smoke_tuner_hdr") then
                im.AlignTextToFramePadding()
                im.Text("SMOKE TUNER")
                im.TextColored(im.ImVec4(1.0, 0.5, 0.9, 1.0), "If the feature isn't working, rejoin the map.")
                im.TextColored(im.ImVec4(1.0, 0.5, 0.9, 1.0), "If the modified smoke remains after disabling the feature, rejoin the map.")
                im.TextColored(im.ImVec4(1.0, 0.5, 0.9, 1.0), "Experimental !!!")

                im.SameLine(im.GetContentRegionAvail().x - 40)
                
                -- Выключатель (Мгновенное применение при клике)
                if im.Checkbox("##chk_smoke_tuner", _G.CheatMenu_Smoke_Enabled) then
                    _G.CheatMenu_Smoke_LastSendTime = 0
                    applyTireSmokeSettings(v, true)
                end
                
                if _G.CheatMenu_Smoke_Enabled[0] then
                    im.Spacing()
                    im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "COLOUR:")
                    
                    -- Профессиональный ColorPicker (запускает секундный троттлинг при перетаскивании)
                    im.SetNextItemWidth(220)
                    if im.ColorEdit3("Color Picker##sm_col_picker", _G.CheatMenu_Smoke_Color) then
                        _G.CheatMenu_Smoke_ColorDirty = true
                    end
                    
                    -- Поле предпросмотра Hex-кода текущего цвета
                    local rByte = math.floor(_G.CheatMenu_Smoke_Color[0] * 255)
                    local gByte = math.floor(_G.CheatMenu_Smoke_Color[1] * 255)
                    local bByte = math.floor(_G.CheatMenu_Smoke_Color[2] * 255)
                    im.Text(string.format("Hex: #%02X%02X%02X", rByte, gByte, bByte))
                    
                    im.Spacing()
                    im.Text("Preset Palette:")
                    
                    -- Расширенная палитра быстрых цветов (18 пресетов, по 9 в ряд)
                    local presets = {
                        {1.0, 1.0, 1.0},    -- Белый
                        {0.05, 0.05, 0.05},  -- Черный
                        {0.5, 0.5, 0.5},    -- Серый
                        {0.9, 0.1, 0.1},    -- Красный
                        {0.5, 0.0, 0.0},    -- Темно-красный
                        {1.0, 0.5, 0.0},    -- Оранжевый
                        {1.0, 0.8, 0.0},    -- Золотой
                        {1.0, 1.0, 0.0},    -- Желтый
                        {0.5, 1.0, 0.0},    -- Лайм
                        {0.0, 1.0, 0.0},    -- Зеленый
                        {0.0, 0.4, 0.0},    -- Темно-зеленый
                        {0.0, 1.0, 1.0},    -- Бирюзовый
                        {0.0, 0.6, 1.0},    -- Голубой
                        {0.1, 0.1, 1.0},    -- Синий
                        {0.5, 0.0, 0.8},    -- Фиолетовый
                        {1.0, 0.0, 1.0},    -- Маджента
                        {1.0, 0.4, 0.7},    -- Розовый
                        {0.4, 0.2, 0.0}     -- Коричневый
                    }
                    
                    for pIdx, rgb in ipairs(presets) do
                        im.PushID1("preset_sm_" .. pIdx)
                        if im.ColorButton("##pres_btn", im.ImVec4(rgb[1], rgb[2], rgb[3], 1.0), 0, im.ImVec2(22, 22)) then
                            _G.CheatMenu_Smoke_Color[0], _G.CheatMenu_Smoke_Color[1], _G.CheatMenu_Smoke_Color[2] = rgb[1], rgb[2], rgb[3]
                            _G.CheatMenu_Smoke_LastSendTime = 0 -- Сброс задержки для мгновенного перекраса
                            _G.CheatMenu_Smoke_ColorDirty = true
                        end
                        im.PopID()
                        -- Перенос строки по 9 кнопок
                        if pIdx % 9 ~= 0 and pIdx < #presets then im.SameLine() end
                    end
                    
                    im.Spacing()
                    im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "AMOUNT:")
                    
                    local amountChanged = false
                    im.SetNextItemWidth(180)
                    if im.SliderFloat("Density##sm_density", _G.CheatMenu_Smoke_Density, 1.0, 30.0, "%.1fx") then amountChanged = true end
                    
                    im.SetNextItemWidth(180)
                    if im.SliderFloat("Size##sm_size", _G.CheatMenu_Smoke_Size, 0.5, 15.0, "%.1fx") then amountChanged = true end
                    
                    im.SetNextItemWidth(180)
                    if im.SliderFloat("Lifetime##sm_life", _G.CheatMenu_Smoke_Lifetime, 0.5, 15.0, "%.1fx") then amountChanged = true end
                    
                    if im.Checkbox("Always smoke (easy burnout)##chk_burnout", _G.CheatMenu_Smoke_EasyBurnout) then
                        amountChanged = true
                    end
                    
                    if amountChanged then
                        _G.CheatMenu_Smoke_LastSendTime = 0
                        applyTireSmokeSettings(v, true)
                    end
                    
                    if im.Button("Reset to defaults##btn_smoke_reset", im.ImVec2(-1, 24)) then
                        _G.CheatMenu_Smoke_Color[0], _G.CheatMenu_Smoke_Color[1], _G.CheatMenu_Smoke_Color[2] = 1.0, 1.0, 1.0
                        _G.CheatMenu_Smoke_Density[0] = 1.0
                        _G.CheatMenu_Smoke_Size[0] = 1.0
                        _G.CheatMenu_Smoke_Lifetime[0] = 1.0
                        _G.CheatMenu_Smoke_EasyBurnout[0] = false
                        _G.CheatMenu_Smoke_LastSendTime = 0
                        _G.CheatMenu_Smoke_ColorDirty = false
                        applyTireSmokeSettings(v, true)
                    end
                end
            end

            im.Separator()
            
            -- ОСОБОЕ УПРАВЛЕНИЕ КАМЕРОЙ И ПАССАЖИРСКИЕ МЕСТА (SPECIAL CAMERA & SEATS)
            
            if im.CollapsingHeader1("Special Camera Controls & Passenger Seats##special_cam_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Special Camera Controls & Vehicle Seats Management:")
                im.Spacing()

                if core_camera then
                    local activeCamName = core_camera.getActiveCamName and core_camera.getActiveCamName(0) or "orbit"
                    im.Text(string.format("Current Active Camera: %s", tostring(activeCamName)))
                    
                    local activeVehId = be:getPlayerVehicleID(0)
                    local allCams = (activeVehId and activeVehId ~= -1 and core_camera.getCameraDataById) and core_camera.getCameraDataById(activeVehId) or {}
                    
                    local passengerSeats = {}
                    local standardCams = {}

                    -- Автоматическое сканирование всех пассажирских кресел и камер салона авто
                    for camName, camObj in pairs(allCams) do
                        if type(camObj) == "table" and not camObj.hidden then
                            local nameLower = string.lower(camName)
                            if string.find(nameLower, "passenger") or string.find(nameLower, "rear") or string.find(nameLower, "rider") or (string.find(nameLower, "onboard%.") and nameLower ~= "onboard.driver" and nameLower ~= "onboard.hood") then
                                table.insert(passengerSeats, camName)
                            else
                                table.insert(standardCams, camName)
                            end
                        end
                    end
                    table.sort(passengerSeats)
                    table.sort(standardCams)

                    -- -----------------------------------------------------------------
                    -- 1. ПОСАДКА НА ПАССАЖИРСКИЕ МЕСТА (PASSENGER SEATS)
                    -- -----------------------------------------------------------------

                    if #passengerSeats == 0 then
                        im.Text("Standard Vehicle Seats:")
                        if im.Button("Driver Seat##btn_seat_driver", im.ImVec2(220, 26)) then
                            core_camera.setByName(0, "driver")
                        end
                        im.SameLine()
                        if im.Button("Front Passenger##btn_seat_pass", im.ImVec2(240, 26)) then
                            core_camera.setByName(0, "onboard.passenger")
                        end
                    else
                        -- Отрисовка индивидуальных кнопок для каждого пассажирского места
                        for idx, seatName in ipairs(passengerSeats) do
                            local cleanLabel = seatName:gsub("onboard%.", ""):gsub("_", " "):upper()
                            
                            im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.5, 0.8, 1.0))
                            if im.Button("Sit: " .. cleanLabel .. "##btn_seat_" .. idx, im.ImVec2(180, 26)) then
                                core_camera.setByName(0, seatName)
                            end
                            im.PopStyleColor()

                            if idx % 3 ~= 0 and idx < #passengerSeats then
                                im.SameLine()
                            end
                        end
                    end

                    -- -----------------------------------------------------------------
                    -- 2. СТАНДАРТНЫЕ И ВНЕШНИЕ КАМЕРЫ (MODES)
                    -- -----------------------------------------------------------------
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Standard Camera Modes:")
                    
                    local quickModes = {
                        { name = "Driver (Водитель)", mode = "driver" },
                        { name = "Orbit (Орбита)", mode = "orbit" },
                        { name = "Chase (Погоня)", mode = "chase" },
                        { name = "Hood (Капот)", mode = "onboard.hood" },
                        { name = "Relative (Относительная)", mode = "relative" },
                        { name = "Free Cam (Свободная)", mode = "free" }
                    }

                    for idx, qm in ipairs(quickModes) do
                        if im.Button(qm.name .. "##btn_qmode_" .. idx, im.ImVec2(165, 26)) then
                            core_camera.setByName(0, qm.mode)
                        end
                        if idx % 3 ~= 0 and idx < #quickModes then
                            im.SameLine()
                        end
                    end

                    im.Separator()
                    im.Spacing()

                    -- -----------------------------------------------------------------
                    -- 3. ОСОБЫЕ ФУНКЦИИ И НАСТРОЙКИ (SPECIAL TWEAKS)
                    -- -----------------------------------------------------------------
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Special Camera Tweaks:")

                    -- Скорость движения камеры
                    local currentSpeed = core_camera.getSpeed and core_camera.getSpeed() or 30.0
                    _G.CheatMenu_CamSpeed[0] = currentSpeed
                    im.SetNextItemWidth(220)
                    if im.SliderFloat("Camera Speed (Скорость свободной камеры)##cam_speed", _G.CheatMenu_CamSpeed, 2.0, 100.0, "Speed: %.1f") then
                        if core_camera.setSpeed then core_camera.setSpeed(_G.CheatMenu_CamSpeed[0]) end
                    end

                    -- Взгляд назад (Look Back)
                    local isLookBack = core_camera.getLookBack and core_camera.getLookBack() or false
                    local lookBackPtr = getPtr(0, "cam_look_back_ptr", isLookBack, "BoolPtr")
                    if not im.IsItemActive() then lookBackPtr[0] = isLookBack end
                    if im.Checkbox("Look Back (Взгляд назад)##chk_look_back", lookBackPtr) then
                        if core_camera.setLookBack then core_camera.setLookBack(0, lookBackPtr[0]) end
                    end

                    im.SameLine()
                    -- Приближение водителя (Driver Zoom Toggle)
                    if im.Button("Toggle Driver Zoom (Приближение)##btn_dr_zoom", im.ImVec2(220, 24)) then
                        if core_camera.driverZoomToggle then core_camera.driverZoomToggle(0) end
                    end

                    im.SameLine()
                    -- Сброс и центрирование камеры
                    if im.Button("Center / Reset Camera##btn_reset_cam", im.ImVec2(180, 24)) then
                        if core_camera.resetCamera then core_camera.resetCamera(0) end
                    end

                    -- -----------------------------------------------------------------
                    -- 4. УГОЛ ПОВОРОТА СВОБОДНОЙ КАМЕРЫ (YAW / PITCH / ROLL)
                    -- -----------------------------------------------------------------
                    if core_camera.getActiveGlobalCameraName and core_camera.getActiveGlobalCameraName() == "free" then
                        im.Separator()
                        im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Free Camera Exact Angle (Поворот свободной камеры):")

                        im.SetNextItemWidth(140)
                        im.SliderFloat("Yaw (Поворот)##cam_yaw", _G.CheatMenu_CamYaw, -180.0, 180.0, "%.0f deg")
                        im.SameLine()
                        im.SetNextItemWidth(140)
                        im.SliderFloat("Pitch (Наклон)##cam_pitch", _G.CheatMenu_CamPitch, -90.0, 90.0, "%.0f deg")
                        im.SameLine()
                        im.SetNextItemWidth(140)
                        im.SliderFloat("Roll (Крен)##cam_roll", _G.CheatMenu_CamRoll, -180.0, 180.0, "%.0f deg")

                        if im.Button("Apply Exact Angle (Применить угол)##btn_apply_angle", im.ImVec2(240, 24)) then
                            if core_camera.setFreeCameraYawPitchRollDeg then
                                core_camera.setFreeCameraYawPitchRollDeg(_G.CheatMenu_CamYaw[0], _G.CheatMenu_CamPitch[0], _G.CheatMenu_CamRoll[0])
                            end
                        end
                    end

                    im.Separator()
                end

                -- 5. Настройка FOV (Угла обзора)
                local currentFov = 65.0
                if core_camera and core_camera.getFovDeg then
                    currentFov = core_camera.getFovDeg() or 65.0
                end

                if not im.IsItemActive() then
                    _G.CheatMenu_CameraFovVal[0] = currentFov
                end

                im.SetNextItemWidth(250)
                if im.SliderFloat("Camera FOV##cam_fov_slider", _G.CheatMenu_CameraFovVal, 10.0, 120.0, "%.1f deg") then
                    if core_camera and core_camera.setFOV then
                        core_camera.setFOV(0, _G.CheatMenu_CameraFovVal[0])
                    end
                end

                im.SameLine()
                if im.Button("Reset FOV (65)") then
                    _G.CheatMenu_CameraFovVal[0] = 65.0
                    if core_camera and core_camera.setFOV then
                        core_camera.setFOV(0, 65.0)
                    end
                end
            end
            -- 2. КАМЕРА И ОБЗОР (FOV, Teleport by Ray)
            if im.CollapsingHeader1("Camera Controls & FOV Tools") then
                -- 1. Управление режимами и состоянием камеры
                if core_camera then
                    local activeCamName = core_camera.getActiveCamName and core_camera.getActiveCamName(0) or "orbit"
                    im.Text(string.format("Active Camera Mode: %s", tostring(activeCamName)))
                    
                    -- Получение списка доступных режимов камеры для активного авто
                    local camConfigs = core_camera.getConfigurationReadOnly and core_camera.getConfigurationReadOnly() or {}
                    local activeVehId = be:getPlayerVehicleID(0)
                    local camData = (activeVehId and activeVehId ~= -1 and core_camera.getCameraDataById) and core_camera.getCameraDataById(activeVehId) or {}
                    
                    local validCams = {}
                    for _, config in ipairs(camConfigs) do
                        local name = config and config.name
                        local enabled = config and config.enabled
                        local visible = name and camData[name] and not camData[name].hidden
                        if name and enabled and visible then
                            table.insert(validCams, name)
                        end
                    end

                    -- Выпадающий список выбора режима камеры
                    if #validCams > 0 then
                        im.SetNextItemWidth(200)
                        if im.BeginCombo("Select Camera Mode##combo_cam_mode", activeCamName) then
                            for _, camName in ipairs(validCams) do
                                local isSelected = (camName == activeCamName)
                                if im.Selectable1(camName, isSelected) then
                                    if core_camera.setByName then
                                        core_camera.setByName(0, camName)
                                    end
                                end
                            end
                            im.EndCombo()
                        end
                    end

                    -- Кнопки быстрой смены и сброса позиции камеры
                    if im.Button("Next Camera Mode##btn_next_cam") then
                        if core_camera.changeAI then core_camera.changeAI(0, 1) end
                    end
                    im.SameLine()
                    if im.Button("Center / Reset Camera##btn_reset_cam") then
                        if core_camera.resetCamera then core_camera.resetCamera(0) end
                    end
                    im.SameLine()
                    
                    -- Переключатель взгляда назад (Look Back)
                    local isLookBack = core_camera.getLookBack and core_camera.getLookBack() or false
                    local lookBackPtr = getPtr(0, "cam_look_back_ptr", isLookBack, "BoolPtr")
                    if not im.IsItemActive() then lookBackPtr[0] = isLookBack end
                    if im.Checkbox("Look Back##chk_look_back", lookBackPtr) then
                        if core_camera.setLookBack then
                            core_camera.setLookBack(lookBackPtr[0])
                        end
                    end
                    if im.Button("Free Camera") then
                        commands.toggleCamera()
                    end
                    im.Separator()
                end

                -- 2. Настройка FOV (Угла обзора)
                local currentFov = 65.0
                if core_camera and core_camera.getFov then
                    currentFov = core_camera.getFov() or 65.0
                end

                if not im.IsItemActive() then
                    _G.CheatMenu_CameraFovVal[0] = currentFov
                end

                im.SetNextItemWidth(250)
                if im.SliderFloat("Camera FOV##cam_fov_slider", _G.CheatMenu_CameraFovVal, 10.0, 120.0, "%.1f deg") then
                    if core_camera and core_camera.setFOV then
                        core_camera.setFOV(0, _G.CheatMenu_CameraFovVal[0])
                    end
                end

                im.SameLine()
                if im.Button("Reset FOV (65)") then
                    _G.CheatMenu_CameraFovVal[0] = 65.0
                    if core_camera and core_camera.setFOV then
                        core_camera.setFOV(0, 65.0)
                    end
                end
                im.Separator()
            end

            if im.CollapsingHeader1("Lighting Car Controller") then
                -- Системные действия
                if im.Button("Initialize Electrics (init)") then
                    v:queueLuaCommand("electrics.init()")
                end
                im.SameLine()
                if im.Button("Reset Electrics (reset)") then
                    v:queueLuaCommand("electrics.reset()")
                end

                im.Separator()

                -- Интерактивный клаксон (изменяет состояние при зажатии кнопки мыши)
                local isHornPressed = im.Button("HOLD TO HORN (horn)##btn_horn", im.ImVec2(200, 30))
                if im.IsItemActive() then
                    if not _G.CheatMenu_LastHornState then
                        v:queueLuaCommand("electrics.horn(true)")
                        _G.CheatMenu_LastHornState = true
                    end
                else
                    if _G.CheatMenu_LastHornState then
                        v:queueLuaCommand("electrics.horn(false)")
                        _G.CheatMenu_LastHornState = false
                    end
                end

                -- Мигание дальним светом (light_flash_highbeams)
                im.SameLine()
                local isFlashPressed = im.Button("FLASH HIGHBEAMS##btn_flash", im.ImVec2(200, 30))
                if im.IsItemActive() then
                    if not _G.CheatMenu_LastFlashState then
                        v:queueLuaCommand("electrics.light_flash_highbeams(true)")
                        _G.CheatMenu_LastFlashState = true
                    end
                else
                    if _G.CheatMenu_LastFlashState then
                        v:queueLuaCommand("electrics.light_flash_highbeams(false)")
                        _G.CheatMenu_LastFlashState = false
                    end
                end

                im.Spacing()

                -- Управление световыми сигналами
                if im.Button("Left Blinker (toggle_left_signal)") then
                    v:queueLuaCommand("electrics.toggle_left_signal()")
                end
                im.SameLine()
                if im.Button("Right Blinker (toggle_right_signal)") then
                    v:queueLuaCommand("electrics.toggle_right_signal()")
                end
                im.SameLine()
                if im.Button("Hazard Lights (toggle_warn_signal)") then
                    v:queueLuaCommand("electrics.toggle_warn_signal()")
                end

                -- Установка аварийного сигнала через значения (set_warn_signal)
                if im.Button("Hazards ON (set_warn_signal)") then
                    v:queueLuaCommand("electrics.set_warn_signal(true)")
                end
                im.SameLine()
                if im.Button("Hazards OFF (set_warn_signal)") then
                    v:queueLuaCommand("electrics.set_warn_signal(false)")
                end

                im.Spacing()

                -- Противотуманные фары и спецсигналы
                if im.Button("Toggle Fog Lights") then
                    v:queueLuaCommand("electrics.toggle_fog_lights()")
                end
                im.SameLine()
                if im.Button("Toggle Lights") then
                    v:queueLuaCommand("electrics.toggle_lights()")
                end
                im.SameLine()
                if im.Button("Toggle Lightbar") then
                    v:queueLuaCommand("electrics.toggle_lightbar_signal()")
                end

                -- Принудительное выставление состояний
                local fogStatePtr = getPtr(vehId, "state_fog_lights", false, "BoolPtr")
                if im.Checkbox("Force Fog Lights State", fogStatePtr) then
                    v:queueLuaCommand(string.format("electrics.set_fog_lights(%s)", tostring(fogStatePtr[0])))
                end
            end
            if im.CollapsingHeader1("ESP Wallhack##gfx_jbeam_debug") then
                local espPtr = getPtr(vehId, "espMode2", vehState.espMode2 or false, "BoolPtr")
                if im.Checkbox("ESP Target Info & Line (for the current vehicle)", espPtr) then
                    sendVar("espMode2", espPtr[0])
                end
                
                -- Линии отладки (debugMode)
                tsDebugPtr = syncPtr(vehId, "traffic_debugMode", gameplay_traffic.debugMode or false, "BoolPtr")
                if im.Checkbox("ESP Target Info & Line (only traffic)##tr_debug", tsDebugPtr) then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".traffic_debugMode"] = os.clock()
                    gameplay_traffic.setDebugMode(tsDebugPtr[0])
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Draws colored trails showing AI paths, target nodes, distances and current speed readouts on top of cars.")
                end
                
                -- Глобальный ESP-радар на абсолютно все машины на карте
                local allEspPtr = syncPtr(vehId, "all_vehicles_esp", _G.CheatMenu_AllVehiclesESP or false, "BoolPtr")
                if im.Checkbox("ESP Target Info & Line (for all other vehicles)##all_esp", allEspPtr) then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".all_vehicles_esp"] = os.clock()
                    _G.CheatMenu_AllVehiclesESP = allEspPtr[0]
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Draws laser lines and real-time telemetry tables over absolutely all vehicles on the map.")
                end

                -- Выпадающие настройки параметров ESP радара
                if _G.CheatMenu_AllVehiclesESP then
                    im.Indent(15)
                    
                    -- Слайдер максимальной дальности отрисовки
                    local distPtr = getPtr(vehId, "esp_max_distance_ptr", _G.CheatMenu_ESP_MaxDistance, "FloatPtr")
                    im.SetNextItemWidth(150)
                    if im.SliderFloat("Max Distance##esp_dist", distPtr, 1.0, 10000.0, "%.0f m") then
                        _G.CheatMenu_ESP_MaxDistance = distPtr[0]
                    end

                    -- Опции визуализации
                    im.Checkbox("Draw Laser Lines##esp_lines", _G.CheatMenu_ESP_ShowLines)
                    im.SameLine()
                    im.Checkbox("Draw Info Text##esp_text", _G.CheatMenu_ESP_ShowText)

                    if _G.CheatMenu_ESP_ShowText and _G.CheatMenu_ESP_ShowText[0] then
                        im.Checkbox("Show Model Name##esp_model", _G.CheatMenu_ESP_ShowModel)
                        im.SameLine()
                        im.Checkbox("Show Speed Meter##esp_speed", _G.CheatMenu_ESP_ShowSpeed)
                    end

                    -- Настройка лазерной линии
                    im.SetNextItemWidth(200)
                    im.ColorEdit4("Line Color##esp_color", _G.CheatMenu_ESP_LineColor)
                    
                    local thickPtr = getPtr(vehId, "esp_line_thickness_ptr", _G.CheatMenu_ESP_LineThickness or 1.0, "FloatPtr")
                    im.SetNextItemWidth(150)
                    if im.SliderFloat("Line Thickness##esp_thick", thickPtr, 1.0, 10.0, "%.0f") then
                        _G.CheatMenu_ESP_LineThickness = thickPtr[0]
                    end

                    -- Настройка цветов текста и фона таблицы
                    if _G.CheatMenu_ESP_ShowText and _G.CheatMenu_ESP_ShowText[0] then
                        im.SetNextItemWidth(200)
                        im.ColorEdit4("Text Color##esp_txt_color", _G.CheatMenu_ESP_TextColor)
                        
                        im.SetNextItemWidth(200)
                        im.ColorEdit4("Background Color##esp_bg_color", _G.CheatMenu_ESP_BgColor)
                    end

                    im.Unindent(15)
                    im.Spacing()
                end
            end
            if im.CollapsingHeader1("Persistent Debris & Particle Booster##debris_header") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Crash Debris & Fragment Controller:")
                im.Text("Glass & plastic shards remain on ground until vehicle respawn (Ctrl+R).")

                -- 1. Переключатель "Осколки не исчезают"
                if im.Checkbox("Keep Shards on Ground Until Respawn##chk_inf_debris", _G.CheatMenu_InfiniteDebris) then
                    applyInfiniteDebrisSettings(_G.CheatMenu_InfiniteDebris[0])
                end
                if im.IsItemHovered() then 
                    im.SetTooltip("Prevents glass and plastic shards from fading away. Auto-clears when resetting the car.") 
                end

                -- 2. Слайдер множителя количества осколков
                local multPtr = syncPtr(vehId, "debrisMultiplier", vehState.debrisMultiplier or 1.0, "FloatPtr")
                im.SetNextItemWidth(220)
                if im.SliderFloat("Debris Amount Multiplier##slider_deb_mult", multPtr, 1.0, 200.0, "Multiplier: %.0fx") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".debrisMultiplier"] = os.clock()
                    sendVar("debrisMultiplier", multPtr[0])
                end
                if im.IsItemHovered() then 
                    im.SetTooltip("Increases the density of glass shards and plastic fragments during collisions.") 
                end

                -- 3. Кнопка ручной уборки мусора с карты
                if im.Button("Clear All Ground Debris Now##btn_clear_decals", im.ImVec2(-1, 24)) then
                    if Engine and Engine.Render and Engine.Render.clearDecals then
                        Engine.Render.clearDecals()
                    end
                end
            end
            
            if im.CollapsingHeader1("Plate editor##veh_specs_header") then
                if im.Button("Plate: OUTLAW") then
                    v:queueLuaCommand("if obj and obj.setPlateText then obj:setPlateText('OUTLAW') end")
                end
                im.SameLine()
                if im.Button("Clear Plate Text") then
                    v:queueLuaCommand("if obj and obj.setPlateText then obj:setPlateText('') end")
                end
            end
            
            im.Separator()
            if im.CollapsingHeader1("Master Graphics Configurator##gfx_master_all_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "1-Click Quality Presets:")
                im.Spacing()

                -- 1. КНОПКИ БЫСТРОГО ПРИМЕНЕНИЯ ПРЕСЕТОВ
                local presetList = { "Lowest", "Low", "Normal", "High", "Ultra", "SteamDeck" }
                for idx, pName in ipairs(presetList) do
                    if im.Button(pName .. "##btn_preset_" .. pName, im.ImVec2(105, 26)) then
                        applyGraphicPreset(pName)
                    end
                    if idx % 3 ~= 0 and idx < #presetList then
                        im.SameLine()
                    end
                end

                im.Separator()
                im.Spacing()
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Individual Parameters Fine-Tuning:")

                -- Вспомогательные рендеры элементов контроля
                local function renderCombo(label, key, keysList, displayNames)
                    local curVal = tostring(getGraphicVal(key, keysList[1]))
                    local curIdx = 1
                    for i, k in ipairs(keysList) do
                        if tostring(k) == curVal then curIdx = i; break end
                    end

                    im.SetNextItemWidth(180)
                    if im.BeginCombo(label, displayNames[curIdx] or curVal) then
                        for i, k in ipairs(keysList) do
                            local isSel = (curIdx == i)
                            if im.Selectable1(displayNames[i] or tostring(k), isSel) then
                                applyGraphicSetting(key, k)
                            end
                        end
                        im.EndCombo()
                    end
                end

                local function renderToggle(label, key)
                    local curVal = getGraphicVal(key, false)
                    local state = (curVal == true or curVal == 1 or curVal == "true")
                    local ptr = getPtr(0, "full_gfx_chk_" .. key, state, "BoolPtr")
                    if not im.IsItemActive() then ptr[0] = state end
                    if im.Checkbox(label, ptr) then
                        applyGraphicSetting(key, ptr[0])
                    end
                end

                local function renderSliderFloat(label, key, minVal, maxVal, format)
                    local curVal = tonumber(getGraphicVal(key, minVal)) or minVal
                    local ptr = getPtr(0, "full_gfx_fslider_" .. key, curVal, "FloatPtr")
                    if not im.IsItemActive() then ptr[0] = curVal end
                    im.SetNextItemWidth(180)
                    if im.SliderFloat(label, ptr, minVal, maxVal, format or "%.2f") then
                        applyGraphicSetting(key, ptr[0])
                    end
                end

                local function renderSliderInt(label, key, minVal, maxVal)
                    local curVal = tonumber(getGraphicVal(key, minVal)) or minVal
                    local ptr = getPtr(0, "full_gfx_islider_" .. key, math.floor(curVal), "IntPtr")
                    if not im.IsItemActive() then ptr[0] = math.floor(curVal) end
                    im.SetNextItemWidth(180)
                    if im.SliderInt(label, ptr, minVal, maxVal, "%d") then
                        applyGraphicSetting(key, ptr[0])
                    end
                end

                -- 1. ГЕОМЕТРИЯ, ЛАНДШАФТ И ТЕКСТУРЫ
                if im.TreeNode1("1. Geometry, Terrain & Textures##tree_g1") then
                    renderCombo("Mesh Quality (GraphicMeshQuality)##k_mesh", "GraphicMeshQuality", {"Lowest", "Low", "Normal", "High", "Ultra"}, {"Lowest", "Low", "Normal", "High", "Ultra"})
                    renderCombo("Terrain Quality (GraphicTerrainQuality)##k_terrain", "GraphicTerrainQuality", {"Lowest", "Low", "Normal", "High"}, {"Lowest", "Low", "Normal", "High"})
                    renderCombo("Texture Quality (GraphicTextureQuality)##k_tex", "GraphicTextureQuality", {"Lowest", "Low", "Normal"}, {"Lowest", "Low", "Normal"})
                    renderSliderFloat("Grass Density (GraphicGrassDensity)##k_grass", "GraphicGrassDensity", 0.0, 1.0, "%.2f")
                    renderSliderInt("Max Decal Count (GraphicMaxDecalCount)##k_decal", "GraphicMaxDecalCount", 0, 20000)
                    im.TreePop()
                end

                -- 2. ОСВЕЩЕНИЕ, ТЕНИ И КАСТЕРЫ
                if im.TreeNode1("2. Lighting, Shadows & Casters##tree_g2") then
                    renderCombo("Lighting Quality (GraphicLightingQuality)##k_light", "GraphicLightingQuality", {"Lowest", "Low", "High", "Ultra"}, {"Lowest", "Low", "High", "Ultra"})
                    renderCombo("Shadows Quality (GraphicShadowsQuality)##k_shadow", "GraphicShadowsQuality", {"Disabled", "Lowest", "Low", "Normal", "High", "Ultra"}, {"Disabled", "Lowest", "Low", "Normal", "High", "Ultra"})
                    renderCombo("Clustered Quality (GraphicClusteredQuality)##k_clustered", "GraphicClusteredQuality", {"Lowest", "Low", "Normal", "High", "Ultra"}, {"Lowest", "Low", "Normal", "High", "Ultra"})
                    
                    renderToggle("Screen Space Shadows (PostFXScreenSpaceShadowsEnabled)", "PostFXScreenSpaceShadowsEnabled")
                    renderToggle("Vehicle Self Shadows (vehicleShadowEnabled)", "vehicleShadowEnabled")
                    renderToggle("Split Casters (lastSplitCastersEnabled)", "lastSplitCastersEnabled")
                    im.TreePop()
                end

                -- 3. ДИНАМИЧЕСКИЕ ОТРАЖЕНИЯ И ЗЕРКАЛА
                if im.TreeNode1("3. Dynamic Reflections & Mirrors##tree_g3") then
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Body Reflections:")
                    renderToggle("Enable Dynamic Reflections (GraphicDynReflectionEnabled)", "GraphicDynReflectionEnabled")
                    renderSliderInt("Reflection Faces/Update (GraphicDynReflectionFacesPerupdate)", "GraphicDynReflectionFacesPerupdate", 1, 6)
                    renderSliderFloat("Reflection Detail (GraphicDynReflectionDetail)", "GraphicDynReflectionDetail", 0.0, 1.0, "%.2f")
                    renderSliderInt("Reflection Distance (GraphicDynReflectionDistance)", "GraphicDynReflectionDistance", 10, 1000)
                    renderCombo("Reflection Tex Size (GraphicDynReflectionTexsize)", "GraphicDynReflectionTexsize", {0, 1, 2, 3}, {"128px (Low)", "256px (Normal)", "512px (High)", "1024px (Ultra)"})

                    im.Separator()
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Rearview Mirrors:")
                    renderToggle("Enable Dynamic Mirrors (GraphicDynMirrorsEnabled)", "GraphicDynMirrorsEnabled")
                    renderSliderFloat("Mirrors Detail (GraphicDynMirrorsDetail)", "GraphicDynMirrorsDetail", 0.0, 1.0, "%.2f")
                    renderSliderInt("Mirrors Distance (GraphicDynMirrorsDistance)", "GraphicDynMirrorsDistance", 10, 1000)
                    renderCombo("Mirrors Tex Size (GraphicDynMirrorsTexsize)", "GraphicDynMirrorsTexsize", {0, 1, 2, 3}, {"128px (Low)", "256px (Normal)", "512px (High)", "1024px (Ultra)"})
                    im.TreePop()
                end

                -- 4. СГЛАЖИВАНИЕ, ФИЛЬТРАЦИЯ И ОБЛАКА
                if im.TreeNode1("4. Anti-Aliasing, Anisotropy & Clouds##tree_g4") then
                    renderCombo("Anisotropic Filtering (GraphicAnisotropic)", "GraphicAnisotropic", {0, 2, 4, 8, 16}, {"Off", "x2", "x4", "x8", "x16"})
                    renderCombo("Anti-Aliasing Level (GraphicAntialias)", "GraphicAntialias", {0, 1, 2, 4}, {"Off", "x1", "x2", "x4"})
                    renderCombo("Anti-Aliasing Type (GraphicAntialiasType)", "GraphicAntialiasType", {"fxaa", "smaa"}, {"FXAA", "SMAA"})
                    renderCombo("Clouds Quality (GraphicCloudsQuality)", "GraphicCloudsQuality", {"Disabled", "Low", "Normal", "High"}, {"Disabled", "Low", "Normal", "High"})
                    renderToggle("Skip License Plate Generation (SkipGenerateLicencePlate)", "SkipGenerateLicencePlate")
                    im.TreePop()
                end

                -- 5. ПОСТ-ЭФФЕКТЫ (SSAO, DOF, MOTION BLUR)
                if im.TreeNode1("5. PostFX Effects (SSAO, DOF, Motion Blur)##tree_g5") then
                    renderToggle("Ambient Occlusion (PostFXSSAOGeneralEnabled)", "PostFXSSAOGeneralEnabled")
                    renderCombo("SSAO Quality Level (PostFXSSAOGeneralQuality)", "PostFXSSAOGeneralQuality", {"Normal", "High"}, {"Normal (16 samples)", "High (64 samples)"})
                    renderToggle("Depth of Field (PostFXDOFGeneralEnabled)", "PostFXDOFGeneralEnabled")
                    
                    renderToggle("Motion Blur (PostFXMotionBlurEnabled)", "PostFXMotionBlurEnabled")
                    renderSliderFloat("Motion Blur Strength (PostFXMotionBlurStrength)", "PostFXMotionBlurStrength", 0.0, 2.0, "%.2f")
                    renderToggle("Motion Blur Player Vehicle (PostFXMotionBlurPlayerVehicle)", "PostFXMotionBlurPlayerVehicle")
                    im.TreePop()
                end

                -- 6. ДИСПОЗИТИВЫ, ЭКСПОЗИЦИЯ И HDR
                if im.TreeNode1("6. Display Modes, HDR & EV Compensation##tree_g6") then
                    renderCombo("Display Mode (GraphicDisplayModes)", "GraphicDisplayModes", {"Window", "Borderless", "Fullscreen"}, {"Windowed", "Borderless", "Fullscreen"})
                    renderToggle("Vertical Sync (vsync)", "vsync")
                    renderSliderFloat("EV Exposure Compensation (GraphicEVCompensation)", "GraphicEVCompensation", -3.0, 3.0, "%.1f EV")

                    renderToggle("HDR Output Enabled (GraphicHDREnabled)", "GraphicHDREnabled")
                    renderSliderInt("HDR Paper White Nits (GraphicHDRPaperWhiteNits)", "GraphicHDRPaperWhiteNits", 50, 1000)
                    renderSliderInt("HDR Peak White Nits (GraphicHDRPeakWhiteNits)", "GraphicHDRPeakWhiteNits", 400, 4000)
                    renderSliderFloat("HDR UI Brightness Multiplier (GraphicHDRUiMultiplier)", "GraphicHDRUiMultiplier", 0.5, 4.0, "%.2f")
                    im.TreePop()
                end
            end

            im.Separator()
            im.TextColored(im.ImVec4(1.0, 0.5, 0.9, 1.0), "Please note: These graphics settings are not saved.")
            im.TextColored(im.ImVec4(1.0, 0.5, 0.9, 1.0), "Your original graphics settings will reappear after restarting the game.")

            if im.CollapsingHeader1("Engine Graphics & Performance Limits##engine_gfx_header") then
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Fine-tune rendering parameters (Drag to 0 to disable entirely):")
                im.Spacing()

                -- Настройки текстур и преломлений
                renderEngineVarSlider("Texture Reduction Level", "$pref::Video::textureReductionLevel", 0, 4, 0, true)
                renderEngineVarSlider("Refraction Texture Scale", "$pref::Reflect::refractTexScale", 0.001, 4.0, 1.0, false)

                -- Детализация мешей и ландшафта (LOD)
                renderEngineVarSlider("Terrain Detail Scale", "$pref::Terrain::detailScale", 0.0, 10.0, 1.0, false)
                renderEngineVarSlider("Terrain LOD Scale (Distance)", "$pref::Terrain::lodScale", 0.0, 10.0, 1.0, false)
                renderEngineVarSlider("Mesh Detail Adjust (LOD)", "$pref::TS::detailAdjust", 0.0, 10.0, 1.0, false)

                -- Трава и тени
                renderEngineVarSlider("Grass / GroundCover Density", "$pref::GroundCover::densityScale", 0.0, 5.0, 1.0, false)
                renderEngineVarSlider("Shadow Quality Scalar", "$pref::Shadows::textureScalar", 0.0, 8.0, 1.0, false)

                -- Лимиты декалей (следы шин, грязь)
                renderEngineVarSlider("Max Decal Count", "$pref::TS::maxDecalCount", 0, 20000, 4000, true)
            end
            
                if im.CollapsingHeader1("Texture & Rendering Features (Reloads the map textures again)") then
                    -- Чекбоксы включения/отключения текстурных технологий
                    local function renderEngineCheckbox(label, varName, defaultValue)
                        local currentVal = getConsoleVariable(varName)
                        -- Инвертируем логику, так как переменная называется "disable..."
                        local state = (currentVal == "" and defaultValue or tonumber(currentVal) or 0) == 0
                        local ptr = getPtr(0, "pref_check_" .. varName, state, "BoolPtr")
                        
                        if not im.IsItemActive() then ptr[0] = state end
                        
                        if im.Checkbox(label .. "##" .. varName, ptr) then
                            setConsoleVariable(varName, ptr[0] and "0" or "1")
                        end
                    end

                    renderEngineCheckbox("Pixel Specular", "$pref::Video::disablePixSpecular", 0)
                    renderEngineCheckbox("Normal Mapping", "$pref::Video::disableNormalmapping", 0)
                    renderEngineCheckbox("Parallax Mapping", "$pref::Video::disableParallaxMapping", 0)
                    renderEngineCheckbox("True Water Reflections", "$pref::Water::disableTrueReflections", 0)
                    
                end
                if im.CollapsingHeader1("Shadows & Detail Limits") then
                    -- Кастомный слайдер для теней с интеграцией GE-метода (Изолирован ##)
                    local shadowPtr = getPtr(vehId, "shadowMultiplier", vehState.shadowMultiplier or 1.0, "FloatPtr")
                    im.PushItemWidth(-220)
                    local shadowChanged = im.SliderFloat("Shadow Quality##shadowMultiplier", shadowPtr, 0, 2.0, "%.2f")
                    im.PopItemWidth()
                    im.SameLine()

                    if im.Button("Reset##shadowMultiplier") then
                        shadowPtr[0] = 1.0
                        
                        -- ИСПРАВЛЕНИЕ: Отправляем команду в машину жестко текстом с аргументом в скобках (1.0)
                        v:queueLuaCommand("if CheatMenuM then CheatMenuM.state.shadowMultiplier = 1.0; CheatMenuM.applyShadowQuality(1.0) end")
                        
                        applyShadowQualityGE(1.0)
                    elseif shadowChanged then
                        -- ИСПРАВЛЕНИЕ: Отправляем команду с текущим значением слайдера shadowPtr[0] в скобках
                        local cmd = string.format("if CheatMenuM then CheatMenuM.state.shadowMultiplier = %f; CheatMenuM.applyShadowQuality(%f) end", shadowPtr[0], shadowPtr[0])
                        v:queueLuaCommand(cmd)
                        
                        applyShadowQualityGE(shadowPtr[0])
                    end
                    -- Отключение теней (0 = включены, 1 = частично отключены, 2 = полностью отключены)
                    renderEngineVarSlider("Shadows Disable State (0 = On, 2 = Off)", "$pref::Shadows::disable", 0, 2, 0, true)
                    renderEngineVarSlider("Skip Render Detail Levels (LOD Skip)", "$pref::TS::skipRenderDLs", 0, 5, 0, true)
                end
                im.Separator()
                
                -- СИСТЕМНЫЕ И РАЗРАБОТЧЕСКИЕ ИНСТРУМЕНТЫ (SYSTEM & DEV TOOLS)
                
            
                im.Text("SYSTEM & DEV TOOLS")
                if im.CollapsingHeader1("Game Engine Lua Controls") then
                    if im.Button("Exit to Main Game Menu##btn_exit_menu", im.ImVec2(240, 24)) then
                        returnToMainMenu()
                    end
                    if im.Button("World Editor (F11)") then editor.toggleActive() end
                end
                if im.CollapsingHeader1("Interactive Vehicle Triggers (Doors & Handles)##triggers_hdr") then
                    im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Interactive Triggers (Door Handles, Latches, Interior Switches):")

                    -- 1. Включение / Выключение интерактивных триггеров (двери, ручки, кнопки)
                    local triggersEnabled = VehicleTrigger and VehicleTrigger.enabled or false
                    local trigEnabledPtr = getPtr(vehId, "vt_enabled_ptr", triggersEnabled, "BoolPtr")
                    if not im.IsItemActive() then trigEnabledPtr[0] = triggersEnabled end
                    if im.Checkbox("Enable Interactive Triggers (Двери / Ручки)##chk_vt_enable", trigEnabledPtr) then
                        if VehicleTrigger then
                            VehicleTrigger.enabled = trigEnabledPtr[0]
                            VehicleTrigger.renderingEnabled = trigEnabledPtr[0]
                        end
                    end

                    -- 2. Включение / Выключение отладочного интерфейса триггеров (Triggers Debug UI)
                    local isDebugOn = core_vehicleTriggers and core_vehicleTriggers.state and core_vehicleTriggers.state.debugEnabled or false
                    local trigDebugPtr = getPtr(vehId, "vt_debug_ptr", isDebugOn, "BoolPtr")
                    if not im.IsItemActive() then trigDebugPtr[0] = isDebugOn end
                    if im.Checkbox("Triggers Debug UI (Визуальная отладка триггеров)##chk_vt_debug", trigDebugPtr) then
                        if core_vehicleTriggers then
                            if trigDebugPtr[0] then
                                core_vehicleTriggers.enableDebugUI()
                            else
                                core_vehicleTriggers.disableDebugUI()
                            end
                        end
                    end

                    im.Separator()
                    im.Text("Trigger Crosshair Settings:")

                    -- 3. Отображение прицела при ходьбе пешком
                    local walkCrosshair = settings and settings.getValue and settings.getValue("enableVehicleTriggerCrosshairWalkingMode") ~= false
                    local walkCrossPtr = getPtr(vehId, "vt_walk_cross_ptr", walkCrosshair, "BoolPtr")
                    if not im.IsItemActive() then walkCrossPtr[0] = walkCrosshair end
                    if im.Checkbox("Crosshair in Walking Mode (Прицел пешком)##chk_vt_walk_cross", walkCrossPtr) then
                        if settings and settings.setValue then
                            settings.setValue("enableVehicleTriggerCrosshairWalkingMode", walkCrossPtr[0])
                        end
                    end

                    -- 4. Отображение прицела в салоне авто
                    local camCrosshair = settings and settings.getValue and settings.getValue("enableVehicleTriggerCrosshairInternalCameras") ~= false
                    local camCrossPtr = getPtr(vehId, "vt_cam_cross_ptr", camCrosshair, "BoolPtr")
                    if not im.IsItemActive() then camCrossPtr[0] = camCrosshair end
                    if im.Checkbox("Crosshair in Internal Cameras (Прицел в салоне)##chk_vt_cam_cross", camCrossPtr) then
                        if settings and settings.setValue then
                            settings.setValue("enableVehicleTriggerCrosshairInternalCameras", camCrossPtr[0])
                        end
                    end

                    -- 5. Статистика и телеметрия триггеров в реальном времени
                    if core_vehicleTriggers and core_vehicleTriggers.state then
                        local vtState = core_vehicleTriggers.state
                        im.Separator()
                        local dist = core_vehicleTriggers.getTriggerRaycastDistance and core_vehicleTriggers.getTriggerRaycastDistance() or 50.0
                        im.Text(string.format("Raycast Distance: %.1f m | Aim Mode: %s", dist, tostring(vtState.aimMode or "n/a")))
                        
                        if vtState.crosshairHasTarget then
                            im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), "Crosshair Target: HOVERED TRIGGER")
                        else
                            im.Text("Crosshair Target: None")
                        end

                        if vtState.currentlyUsedTrigger then
                            im.TextColored(im.ImVec4(1.0, 0.6, 0.2, 1.0), "Active Used Trigger: ENGAGED")
                        end
                    end
                    im.Separator()
                end
                -- ПАНЕЛЬ РАСШИРЕННОГО ДЕБАГА ГРАФИКИ, ШЕЙДЕРОВ И ФИЗИЧЕСКИХ ОБЪЕКТОВ
                if im.CollapsingHeader1("Graphics & JBeam Debug Panel##gfx_jbeam_debug") then
                    -- Раздел 1: Системные режимы визуализации рендеринга (Normal Map, Depth, Wireframe)
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Renderer Visualization Modes:")
                    
                    -- Кнопка быстрого сброса режима рендера в дефолт
                    if im.Button("Reset Rendering to Normal##btn_res_render_mode", im.ImVec2(-1, 22)) then
                        setConsoleVariable("$renderer::visualizationMode", "0")
                        setConsoleVariable("$pref::Video::wireframe", "0")
                    end
                    
                    -- Кнопка принудительного отключения всех физических дебагов
                    if im.Button("Disable All Physical Debug Views##btn_clear_phys_debug", im.ImVec2(-1, 22)) then
                        be:setNodeDebugFilter("none")
                        be:setBeamDebugFilter("none")
                    end
                end
                -- 3. УПРАВЛЕНИЕ СИСТЕМОЙ И КЭШЕМ (Reload, UI, Collision)
                if im.CollapsingHeader1("Reload & Cache Operations") then
                    if im.Button("Reload Web UI (reloadUI)") then
                        reloadUI()
                    end
                    
                    if im.Button("Reload Collisions (reloadCollision)") then
                        be:reloadCollision()
                    end
                    im.SameLine()
                    if im.Button("Reload Vehicle (be:reloadVehicle)") then
                        be:reloadVehicle(0)
                    end
                    im.SameLine()
                    if im.Button("Reset Vehicle (be:resetVehicle)") then
                        be:resetVehicle(0)
                    end
                    -- Выгрузка детального профилировщика графической памяти в лог
                    if im.Button("Dump GFX Resources Memory to Console Log##btn_gfx_dump", im.ImVec2(340, 24)) then
                        dumpGfxResourcesMemory()
                    end
                end
                
                if im.CollapsingHeader1("System Events & Errors Simulation") then
                    -- 6. Искусственный вызов нестабильности физики (Instability Detected)
                    if im.Button("Simulate Physics Instability Event##btn_sim_instab", im.ImVec2(240, 24)) then
                        M.onInstabilityDetected(vehId, { instabilityHandled = false })
                    end
                    im.SameLine()
                    -- 7. Симуляция ошибки создания машины (Spawn Error Toast)
                    if im.Button("Simulate Spawn Error Toast##btn_sim_spawn_err", im.ImVec2(240, 24)) then
                        onSpawnError("CRITICAL_JBEAM_CORRUPTION", "pickup")
                    end

                    -- 8. Искусственный сброс игрового состояния (Reset Gameplay)
                    if im.Button("Trigger Reset Gameplay Event##btn_sim_reset_gp", im.ImVec2(240, 24)) then
                        resetGameplay(0)
                    end
                end
                if im.CollapsingHeader1("Material Debug Mode") then
                    -- Отладка материалов (Material Debug)
                    if im.Checkbox("Enable Material Debug Mode", _G.CheatMenu_MaterialDebug) then
                        enableMaterialDebug(_G.CheatMenu_MaterialDebug[0])
                    end
                end

                
                -- ГЕНЕРАТОР ВИРТУАЛЬНОГО ФИЗИЧЕСКОГО ПЕСКА
                
                if im.CollapsingHeader1("Virtual Physics Objects Spawner##virt_sand_hdr") then
                    im.TextColored(im.ImVec4(0.9, 0.8, 0.4, 1.0), "Physics Simulated Debris / Objects:")
                    im.Text("Real-time physical contact! Falls onto roof & hood without flying off.")
                    
                    im.Checkbox("Enable Physics Simulation##chk_virt_sand", _G.CheatMenu_VirtSand_Enabled)
                    
                    -- Выбор формы объектов
                    local shapesList = { "Cubes", "Spheres", "Sticks" }
                    local currentShapeStr = shapesList[_G.CheatMenu_VirtSand_ShapeIdx + 1] or "Cubes"
                    
                    im.SetNextItemWidth(220)
                    if im.BeginCombo("Object Shape##combo_virt_shape", currentShapeStr) then
                        for idx, sName in ipairs(shapesList) do
                            local isSel = (_G.CheatMenu_VirtSand_ShapeIdx == idx - 1)
                            if im.Selectable1(sName, isSel) then
                                _G.CheatMenu_VirtSand_ShapeIdx = idx - 1
                            end
                        end
                        im.EndCombo()
                    end

                    im.SetNextItemWidth(200)
                    im.SliderInt("Object Quantity##v_sand_cnt", _G.CheatMenu_VirtSand_Count, 1, 5000, "%d items")
                    
                    im.SetNextItemWidth(200)
                    im.SliderFloat("Spawn Area Radius##v_sand_rad", _G.CheatMenu_VirtSand_Radius, 0.2, 10.0, "%.1f m")

                    im.SetNextItemWidth(200)
                    im.SliderFloat("Object Base Size##v_sand_sz", _G.CheatMenu_VirtSand_CubeSize, 0.03, 1.0, "%.2f m")

                    if _G.CheatMenu_VirtSand_ShapeIdx == 2 then
                        im.SetNextItemWidth(200)
                        im.SliderFloat("Stick Length##v_sand_len", _G.CheatMenu_VirtSand_StickLength, 0.1, 3.0, "%.2f m")
                    end

                    im.SetNextItemWidth(200)
                    im.ColorEdit3("Objects Color##v_sand_col", _G.CheatMenu_Sand_Color)

                    im.Spacing()
                    im.PushStyleColor2(im.Col_Button, im.ImVec4(0.8, 0.6, 0.2, 1.0))
                    if im.Button("Spawn Objects Heap Above Car##btn_gen_v_sand", im.ImVec2(250, 28)) then
                        generateVirtualPhysicalSand()
                    end
                    im.PopStyleColor()

                    im.SameLine()
                    if im.Button("Clear All##btn_clr_v_sand", im.ImVec2(100, 28)) then
                        _G.CheatMenu_VirtSand_List = {}
                        _G.CheatMenu_VirtSand_Enabled[0] = false
                    end
                end

            im.EndTabItem()
        end

        -- КАРЬЕРА И УПРАВЛЕНИЕ МИРОМ
        if im.BeginTabItem("Career") then

            local classInfo = getClassFromVehId(vehId)
            
            if im.CollapsingHeader1("Performance Index and Metrics") then
                if not classInfo then
                    im.TextColored(im.ImVec4(1.0, 0.6, 0.2, 1.0), "Performance Index: -")
                    im.Text("This occurs for custom-built or heavily modified vehicles.")
                    im.Text("To load standard PI metrics, please switch to a factory vehicle configuration.")
                else
                    local class = classInfo.class
                    local piVal = classInfo.performanceIndex or 0
                    
                    -- Выбираем цвет в зависимости от класса автомобиля (в стиле Forza/Gran Turismo)
                    local classColor = im.ImVec4(1.0, 1.0, 1.0, 1.0)
                    if class.name == "D" then classColor = im.ImVec4(0.4, 0.6, 1.0, 1.0)      -- Голубой
                    elseif class.name == "C" then classColor = im.ImVec4(0.2, 0.8, 0.2, 1.0)   -- Зеленый
                    elseif class.name == "B" then classColor = im.ImVec4(1.0, 0.6, 0.1, 1.0)   -- Оранжевый
                    elseif class.name == "A" then classColor = im.ImVec4(0.9, 0.1, 0.1, 1.0)   -- Красный
                    elseif class.name == "S" then classColor = im.ImVec4(0.7, 0.2, 0.8, 1.0)   -- Фиолетовый
                    elseif class.name == "X" then classColor = im.ImVec4(1.0, 0.8, 0.0, 1.0)   -- Золотой
                    end
                    
                    -- Отрисовываем красивую карточку класса автомобиля
                    im.Spacing()
                    im.Text("Vehicle Performance Class:")
                    
                    im.PushStyleColor2(im.Col_Button, classColor)
                    im.Button(string.format("  CLASS %s  ", class.name), im.ImVec2(120, 36))
                    im.PopStyleColor()
                    im.SameLine()
                    
                    im.BeginGroup()
                    im.Text(string.format("Performance Index: %.0f", piVal))
                    im.TextColored(classColor, class.description or "")
                    im.EndGroup()
                                    
                    -- Рассчитываем и выводим детальные оценки (Aggregate Scores)
                    local vehicleDetails = core_vehicles.getVehicleDetails(vehId)
                    local performanceData = vehicleDetails and vehicleDetails.configs["Drag Times"]
                    if performanceData then
                        performanceData.power = vehicleDetails.configs["Power"]
                        performanceData.weight = vehicleDetails.configs["Weight"]
                        
                        local scores = getAggregateScores(performanceData)
                        if scores then
                            if im.CollapsingHeader1("Performance Metrics") then
                                im.Spacing()
                                
                                local function drawScoreBar(label, score)
                                    local fraction = math.min(math.max(score / 100, 0.0), 1.0) -- нормируем до 150% для запаса
                                    im.Text(string.format("%s: %.1f%%", label, score))
                                    im.SetNextItemWidth(-1)
                                    -- Рисуем цветную шкалу сравнения
                                    im.ProgressBar(fraction, im.ImVec2(0, 14), "")
                                    im.Spacing()
                                end
                                
                                drawScoreBar("Power Output", scores.powerScore or 0)
                                drawScoreBar("Power-To-Weight Ratio", scores.powerToWeightScore or 0)
                                drawScoreBar("Time-To-60 Acceleration (0-100 km/h)", scores.timeTo60Score or 0)
                                drawScoreBar("Quarter Mile Sprint (402m)", scores.quarterMileScore or 0)
                                drawScoreBar("High-Speed Acceleration Progression", scores.speedProgressionScore or 0)
                                drawScoreBar("Braking Deceleration (G-Force)", scores.brakingGForceScore or 0)
                            end
                        end
                    end
                end
            end
            im.Separator()
            
            if im.CollapsingHeader1("Resource Modifiers") then
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "You must be in career mode:")
                -- Ползунок выбора суммы денег
                local cashAmountPtr = getPtr(vehId, "cheat_cash_to_add", 20000, "IntPtr")
                im.SetNextItemWidth(300)
                im.SliderInt("##cash_amount_slider", cashAmountPtr, 0, 1000000, "Sum: $%d")
                im.SameLine()
                if im.Button("Add Cash##btn_apply_cash") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({money = cashAmountPtr[0]}, {tags={"cheat"}, label="Cheat Money"})
                    end
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Ctrl + Click to type any custom amount")
                end
                
                -- 1. Регулятор добавления опыта (BeamXP)
                local xpAmountPtr = getPtr(vehId, "cheat_xp_to_add", 1000, "IntPtr")
                im.SetNextItemWidth(300)
                im.SliderInt("##xp_amount_slider", xpAmountPtr, 0, 5000, "XP: %d")
                im.SameLine()
                if im.Button("Add BeamXP##btn_apply_xp") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({beamXP = xpAmountPtr[0]}, {tags={"cheat"}, label="Cheat XP"})
                    end
                end

                -- 2. Регулятор добавления бонусных звезд (Bonus Stars)
                local starsAmountPtr = getPtr(vehId, "cheat_stars_to_add", 10, "IntPtr")
                im.SetNextItemWidth(300)
                im.SliderInt("##stars_amount_slider", starsAmountPtr, 0, 300, "Stars: %d")
                im.SameLine()
                if im.Button("Add Stars##btn_apply_stars") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({bonusStars = starsAmountPtr[0]}, {tags={"cheat"}})
                    end
                end

                -- 3. Регулятор добавления ваучеров (Vouchers)
                local vouchersAmountPtr = getPtr(vehId, "cheat_vouchers_to_add", 100, "IntPtr")
                im.SetNextItemWidth(300)
                im.SliderInt("##vouchers_amount_slider", vouchersAmountPtr, 0, 1000, "Vouchers: %d")
                im.SameLine()
                if im.Button("Add Vouchers##btn_apply_vouchers") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({vouchers = vouchersAmountPtr[0]}, {tags={"cheat"}})
                    end
                end

                
                if im.Button("Add $20,000 Cash") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({money = 20000}, {tags={"cheat"}, label="Cheat Money"})
                    end
                end
                im.SameLine()
                if im.Button("Add 1,000 BeamXP") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({beamXP = 1000}, {tags={"cheat"}, label="Cheat XP"})
                    end
                end
                im.SameLine()
                if im.Button("Add 10 Bonus Stars") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({bonusStars = 10}, {tags={"cheat"}})
                    end
                end
                im.SameLine()
                if im.Button("Add 100 Vouchers") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({vouchers = 100}, {tags={"cheat"}})
                    end
                end
            end

            im.TextColored(im.ImVec4(1.0, 0.5, 0.9, 1.0), "You can edit any profile and its data using the Profile Editor:")
            if im.CollapsingHeader1("Profile Editor##profile_editor_header") then
                local editorState = _G.CheatMenu_ProfileEditor
                
                -- Кнопка сканирования/обновления списка сохранений
                if im.Button("Scan Save Profiles##btn_scan_prof", im.ImVec2(180, 24)) or #editorState.files == 0 then
                    scanProfiles()
                end
                
                if #editorState.files > 0 then
                    im.Spacing()
                    im.Text("Select Profile Save File:")
                    
                    -- Формируем красивое название профиля для списка
                    local currentLabel = "Select File..."
                    if editorState.selectedIdx ~= -1 and editorState.files[editorState.selectedIdx + 1] then
                        local rawPath = editorState.files[editorState.selectedIdx + 1]
                        currentLabel = string.match(rawPath, "saves/(.*)") or rawPath
                    end
                    
                    -- Выпадающий список выбора файла сохранения
                    im.SetNextItemWidth(-1)
                    if im.BeginCombo("Save File##combo_save_files", currentLabel) then
                        for idx, fullPath in ipairs(editorState.files) do
                            local label = string.match(fullPath, "saves/(.*)") or fullPath
                            local isSelected = (editorState.selectedIdx == idx - 1)
                            if im.Selectable1(label, isSelected) then
                                editorState.selectedIdx = idx - 1
                                editorState.path = fullPath
                                -- Загружаем данные из выбранного JSON
                                editorState.data = jsonReadFile(fullPath)
                            end
                        end
                        im.EndCombo()
                    end
                    
                    -- Если файл выбран и успешно загружен
                    if editorState.data then
                        im.Spacing()
                        im.TextColored(im.ImVec4(0.4, 1.0, 0.4, 1.0), "Save Path: " .. editorState.path)
                        
                        -- Кнопка записи изменений обратно в файл
                        if im.Button("Save Changes to Profile##btn_save_json_changes", im.ImVec2(-1, 28)) then
                            jsonWriteFile(editorState.path, editorState.data, true)
                            -- Если редактируется запущенная сейчас карьера, принудительно обновляем данные в ОЗУ
                            if career_modules_playerAttributes and career_modules_playerAttributes.loadAttributes then
                                career_modules_playerAttributes.loadAttributes()
                            end
                        end
                        
                        im.Separator()
                        im.Text("Adjust Career Attributes:")
                        
                        -- Сортируем параметры по алфавиту для удобного поиска
                        local sortedKeys = {}
                        for k, _ in pairs(editorState.data) do
                            table.insert(sortedKeys, k)
                        end
                        table.sort(sortedKeys)
                        
                        -- Прокручиваемая область для параметров
                        im.BeginChild1("ProfileScroll", im.ImVec2(0, 400), true, 0)
                        for _, key in ipairs(sortedKeys) do
                            local attr = editorState.data[key]
                            if attr and type(attr) == "table" and attr.value then
                                local isFloat = (type(attr.value) == "number" and attr.value % 1 ~= 0)
                                
                                if isFloat then
                                    -- Отрисовка полей с плавающей запятой
                                    local tempValPtr = getPtr(0, "prof_edit_" .. key, attr.value, "FloatPtr")
                                    if not im.IsItemActive() then tempValPtr[0] = attr.value end
                                    im.SetNextItemWidth(180)
                                    if im.InputFloat(key .. "##prof_" .. key, tempValPtr, 100.0, 1000.0, "%.3f") then
                                        attr.value = tempValPtr[0]
                                    end
                                else
                                    -- Отрисовка целочисленных полей
                                    local tempValPtr = getPtr(0, "prof_edit_" .. key, attr.value, "IntPtr")
                                    if not im.IsItemActive() then tempValPtr[0] = math.floor(attr.value) end
                                    im.SetNextItemWidth(180)
                                    if im.InputInt(key .. "##prof_" .. key, tempValPtr, 100, 1000) then
                                        attr.value = tempValPtr[0]
                                    end
                                end
                            end
                        end
                        im.EndChild()
                    end
                else
                    im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "No active career saves found.")
                end
            end

            if im.CollapsingHeader1("Career Progression Branches") then
                im.Text("Career Progression Branches (You must be in career mode):")

                if im.Button("Max APM Branches (+10k XP)") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({
                            ["apm"] = 10000, ["apm-aiRacing"] = 10000, ["apm-commercial"] = 10000, ["apm-commercial-delivery"] = 10000,
                            ["apm-experimental"] = 10000, ["apm-experimental-crashtest"] = 10000, ["apm-motorsport"] = 10000,
                            ["apm-motorsport-dragracing"] = 10000, ["apm-motorsport-drift"] = 10000, ["apm-motorsport-timeTrial"] = 10000,
                            ["apm-special"] = 10000, ["apm-special-chase"] = 10000, ["apm-special-evade"] = 10000
                        }, {tags={"cheat"}})
                    end
                end
                im.SameLine()
                if im.Button("Max BMRA Branches (+10k XP)") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({
                            ["bmra"] = 10000, ["bmra-dragracing"] = 10000, ["bmra-drift"] = 10000, ["bmra-gridRacing"] = 10000, ["bmra-timeTrial"] = 10000
                        }, {tags={"cheat"}})
                    end
                end
                
                if im.Button("Max Logistics (+10k XP)") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({
                            ["logistics"] = 10000, ["logistics-delivery"] = 10000, ["logistics-materials"] = 10000, ["logistics-vehicleDelivery"] = 10000
                        }, {tags={"cheat"}})
                    end
                end
                im.SameLine()
                if im.Button("Max Freestyle (+10k XP)") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({
                            ["freestyle"] = 10000, ["freestyle-crawl"] = 10000, ["freestyle-evade"] = 10000, ["freestyle-miniGames"] = 10000, ["freestyle-police"] = 10000
                        }, {tags={"cheat"}})
                    end
                end

                if im.Button("Max All Shop Reputations (+700 to All)") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({
                            belascoAutoReputation = 700, belascoCityConstructionReputation = 700, belascoCityExhaustReputation = 700,
                            belascoCityGarageReputation = 700, commercialVehicleSalesReputation = 700, fastAutomotiveReputation = 700,
                            hotRolledReputation = 700, industrialWarehouseReputation = 700, jeffersonMotorsReputation = 700,
                            jerryRiggsReputation = 700, lensflareStudiosReputation = 700, quarrysideAutoSalesReputation = 700,
                            rentaboxReputation = 700, richsMotorCompanyReputation = 700, sealbrikReputation = 700,
                            shuffleboardLogisticsReputation = 700, smashAutoRepairsReputation = 700, spearleafLogisticsReputation = 700,
                            spearleafRefineryReputation = 700, torresTiresReputation = 700
                        }, {tags={"cheat"}})
                    end
                end
                im.SameLine()
                if im.Button("Smooth Balanced XP (+1,000 to All)") then
                    if career_modules_playerAttributes then
                        career_modules_playerAttributes.addAttributes({
                            ["apm"] = 1000, ["apm-aiRacing"] = 1000, ["apm-commercial"] = 1000, ["apm-commercial-delivery"] = 1000,
                            ["apm-experimental"] = 1000, ["apm-experimental-crashtest"] = 1000, ["apm-motorsport"] = 1000,
                            ["apm-motorsport-dragracing"] = 1000, ["apm-motorsport-drift"] = 1000, ["apm-motorsport-timeTrial"] = 1000,
                            ["apm-special"] = 1000, ["apm-special-chase"] = 1000, ["apm-special-evade"] = 1000,
                            ["bmra"] = 1000, ["bmra-dragracing"] = 1000, ["bmra-drift"] = 1000, ["bmra-gridRacing"] = 1000, ["bmra-timeTrial"] = 1000,
                            ["logistics"] = 1000, ["logistics-delivery"] = 1000, ["logistics-materials"] = 1000, ["logistics-vehicleDelivery"] = 1000,
                            ["freestyle"] = 1000, ["freestyle-crawl"] = 1000, ["freestyle-evade"] = 1000, ["freestyle-miniGames"] = 1000, ["freestyle-police"] = 1000
                        }, {tags={"cheat"}})
                    end
                end

                if im.Button("Unlock All Career Branches Deeply") then
                    local function findAndModifyBranches(tbl)
                        if type(tbl) ~= "table" then return false end
                        if tbl["apm"] and type(tbl["apm"]) == "table" then
                            for name, branch in pairs(tbl) do
                                if type(branch) == "table" then
                                    branch.unlocked = true
                                    branch.wip = false
                                    branch.isWIPVar = false
                                    if branch.prerequisites then branch.prerequisites = {} end
                                    if type(branch.isUnlocked) == "function" then branch.isUnlocked = function() return true end end
                                    if type(branch.getUnlocked) == "function" then branch.getUnlocked = function() return true end end
                                end
                            end
                            return true
                        end
                        for k, v in pairs(tbl) do
                            if type(v) == "table" and k ~= "__parent" and k ~= "_G" then
                                if findAndModifyBranches(v) then return true end
                            end
                        end
                        return false
                    end
                    if career_modules_branches then findAndModifyBranches(career_modules_branches) end
                    if career_branches then findAndModifyBranches(career_branches) end
                    if career_modules_licenses then
                        for k, v in pairs(career_modules_licenses) do
                            if type(v) == "table" then v.unlocked = true; v.owned = true end
                        end
                    end
                end
                im.SameLine()
                
                if im.Button("Unlock All Map Missions Once") then
                    if gameplay_missions_missions then
                        for _, m in ipairs(gameplay_missions_missions.getFilesData()) do
                            local instance = gameplay_missions_missions.getMissionById(m.id)
                            if instance then
                                instance.unlocks.startable = true
                                instance.unlocks.visible = true
                            end
                        end
                        gameplay_rawPois.clear()
                    end
                end
                -- Новая галочка постоянного и надежного взлома миссий
                local permUnlockPtr = syncPtr(vehId, "perm_mission_unlock", _G.CheatMenu_PermanentMissionUnlock or false, "BoolPtr")
                if im.Checkbox("Permanent Unlock of All Map Missions(2)##perm_unlock", permUnlockPtr) then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".perm_mission_unlock"] = os.clock()
                    _G.CheatMenu_PermanentMissionUnlock = permUnlockPtr[0]
                    applyPermanentMissionUnlock(permUnlockPtr[0])
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Permanently overrides the game's unlocks.lua logic, ensuring absolutely all missions on the map remain startable and visible at all times.")
                end
                
                if im.Button("Prepare Milestones for Claims") then
                    local function findAndModifyMilestones(tbl)
                        if type(tbl) ~= "table" then return false end
                        if tbl.general and type(tbl.general) == "table" then
                            for name, milestone in pairs(tbl.general) do
                                if type(milestone) == "table" then
                                    milestone.claimedStep = 0
                                    milestone.notificationStep = 10
                                    if milestone.triggerCount then milestone.triggerCount = 9999 end
                                end
                            end
                            tbl.unclaimedMilestonesCount = 10
                            return true
                        end
                        for k, v in pairs(tbl) do
                            if type(v) == "table" and k ~= "__parent" and k ~= "_G" then
                                if findAndModifyMilestones(v) then return true end
                            end
                        end
                        return false
                    end
                    if career_modules_milestones then findAndModifyMilestones(career_modules_milestones) end
                end
                im.SameLine()
                if im.Button("Reset Progress to 0") then
                    if career_modules_playerAttributes then
                        local resetAttr = {}
                        local keys = {
                            "apm", "apm-aiRacing", "apm-commercial", "apm-commercial-delivery", "apm-experimental",
                            "apm-experimental-crashtest", "apm-motorsport", "apm-motorsport-dragracing",
                            "apm-motorsport-drift", "apm-motorsport-timeTrial", "apm-special", "apm-special-chase",
                            "apm-special-evade", "bmra", "bmra-dragracing", "bmra-drift", "bmra-gridRacing",
                            "bmra-timeTrial", "logistics", "logistics-delivery", "logistics-materials",
                            "logistics-vehicleDelivery", "freestyle", "freestyle-crawl", "freestyle-evade",
                            "freestyle-miniGames", "freestyle-police", "vouchers", "belascoAutoReputation",
                            "belascoCityConstructionReputation", "belascoCityExhaustReputation", "belascoCityGarageReputation",
                            "commercialVehicleSalesReputation", "fastAutomotiveReputation", "hotRolledReputation",
                            "industrialWarehouseReputation", "jeffersonMotorsReputation", "jerryRiggsReputation",
                            "lensflareStudiosReputation", "quarrysideAutoSalesReputation", "rentaboxReputation",
                            "richsMotorCompanyReputation", "sealbrikReputation", "shuffleboardLogisticsReputation",
                            "smashAutoRepairsReputation", "spearleafLogisticsReputation", "spearleafRefineryReputation",
                            "torresTiresReputation"
                        }
                        for _, k in ipairs(keys) do
                            local attr = career_modules_playerAttributes.getAttribute(k)
                            if attr and attr.value then resetAttr[k] = -attr.value end
                        end
                        if next(resetAttr) then
                            career_modules_playerAttributes.addAttributes(resetAttr, {tags={"cheat"}})
                        end
                    end
                end
            end
            if im.CollapsingHeader1("RLS Career Overhaul##rls_reward_panel") then
                -- ПАНЕЛЬ НАЧИСЛЕНИЯ НАГРАД RLS CAREER JOBS & PAYOUTS
                if im.CollapsingHeader1("RLS / Career Reward Spawner##rls_reward_panel") then
                    -- Безопасный индикатор активности карьеры
                    local isCareerActive = (career_career and career_career.isActive and career_career.isActive())
                    if not isCareerActive then
                        im.TextColored(im.ImVec4(1.0, 0.4, 0.4, 1.0), "WARNING: You must be in Career Mode to use this panel!")
                    else
                        im.TextColored(im.ImVec4(0.4, 1.0, 0.4, 1.0), "Career Mode Connection: ONLINE (Ready to pay)")
                    end
                    
                    im.Spacing()
                    
                    -- Выбор категории работы/активности
                    local categoriesList = { "Admin/Cheat Payout", "Laborer / Delivery Job", "Taxi Fare Payment", "Facility / Work Order", "Gambling Cards Refund" }
                    local currentCategory = categoriesList[_G.CheatMenu_RLS_TagIdx + 1] or "Admin/Cheat Payout"
                    
                    im.SetNextItemWidth(250)
                    if im.BeginCombo("Reward Type Preset##combo_rls_tags", currentCategory) then
                        for idx, cName in ipairs(categoriesList) do
                            local isSelected = (_G.CheatMenu_RLS_TagIdx == idx - 1)
                            if im.Selectable1(cName, isSelected) then
                                _G.CheatMenu_RLS_TagIdx = idx - 1
                            end
                        end
                        im.EndCombo()
                    end
                    if im.IsItemHovered() then 
                        im.SetTooltip("Configures specific game tags. For example, Taxi Fare triggers stats for Taxi drivers, and Laborer triggers delivery points.") 
                    end

                    -- Ползунки настройки объемов начисления
                    im.SetNextItemWidth(250)
                    im.DragInt("Money Amount ($)##rls_money_val", _G.CheatMenu_RLS_Money, 50, 0, 10000000)
                    
                    im.SetNextItemWidth(250)
                    im.DragInt("BeamXP Amount##rls_xp_val", _G.CheatMenu_RLS_XP, 10, 0, 100000)
                    
                    im.SetNextItemWidth(250)
                    im.DragInt("Labourer Rep Points##rls_lab_val", _G.CheatMenu_RLS_Labourer, 5, 0, 50000)
                    if im.IsItemHovered() then 
                        im.SetTooltip("Labor points / reputation. Essential for Level Progression in RLS Laborer Career.") 
                    end

                    -- Галочка масштабирования опыта и очков от сложности
                    im.Checkbox("Scale XP/Rep by Difficulty Multiplier##chk_rls_scale", _G.CheatMenu_RLS_ScalePayment)
                    if im.IsItemHovered() then 
                        im.SetTooltip("If enabled, final XP and Laborer points are scaled based on the selected career difficulty profile (Money is never scaled).") 
                    end

                    im.Spacing()
                    
                    -- Кнопка произведения выплаты
                    if not isCareerActive then im.BeginDisabled() end
                    
                    im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.6, 0.2, 1.0))
                    if im.Button("Payout Job Reward & Save Career Progress##btn_payout_rls", im.ImVec2(-1, 28)) then
                        payoutRLSCareerReward()
                    end
                    im.PopStyleColor()
                    
                    if not isCareerActive then im.EndDisabled() end
                end
            end
            im.Separator()
            
            im.Text("Career Inventory:")
            if im.Button("Save Vehicle to Career Inventory") then
                if career_modules_inventory then
                    local inventoryId = career_modules_inventory.addVehicle(vehId)
                    if inventoryId then career_modules_inventory.enterVehicle(inventoryId) end
                end
            end
            
            im.Separator()
            if im.CollapsingHeader1("Traffic Control Center") then
                -- ИНТЕРАКТИВНЫЙ ЦЕНТР УПРАВЛЕНИЯ ТРАФИКОМ (traffic.lua)
                local tVars = gameplay_traffic and gameplay_traffic.getTrafficVars()
                
                if gameplay_traffic and tVars then
                    local tState = gameplay_traffic.getState()
                    local activeCount = gameplay_traffic.getTrafficAmount(true)
                    local totalCount = gameplay_traffic.getTrafficAmount()
                    
                    im.Text(string.format("Traffic State: %s | Active/Total: %d / %d", tostring(tState):upper(), activeCount, totalCount))

                    -- Рекомендация по количеству машин на базе вашего процессора
                    local recommendedMax = getMaxVehicleAmount(32)
                    im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), string.format("Recommended Max Active Vehicles (CPU Cores): %d", recommendedMax))

                    -- 1. БЫСТРЫЙ СПАВН И ОЧИСТКА
                    im.Spacing()
                    im.Text("Spawn & Despawn:")
                    
                    -- Настройка количества спавна машин
                    
                    -- Оставляем получение указателя, чтобы строка 1518 не выдавала ошибку:
                    local spawnAmountPtr = getPtr(vehId, "traffic_spawn_amount", 5, "IntPtr")

                    im.BeginGroup()
                    im.SetNextItemWidth(350)
                    -- Вызываем новый слайдер (в sendFunc передаем вашу функцию отправки, например sendVar)
                    renderSliderIntWithResetTraffic("Amount to Spawn AI Cars", "traffic_spawn_amount", 1, 100, 5, sendVar)
                    im.EndGroup()

                    im.Text("Actions:")
                    if im.Button("Spawn Normal Traffic##btn_tr_normal") then
                        gameplay_traffic.setupTraffic(spawnAmountPtr[0], 0)
                    end
                    im.SameLine()
                    if im.Button("Spawn Police & Traffic##btn_tr_cop") then
                        gameplay_traffic.setupTraffic(spawnAmountPtr[0], 0.25) -- С патрульными машинами (25%)
                    end
                    
                    if im.Button("Scatter Traffic (Instant)##btn_tr_scatter") then
                        gameplay_traffic.scatterTraffic()
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("Teleports all active traffic cars away from your immediate path without deleting them.")
                    end
                    im.SameLine()
                    if im.Button("Disable & Clear Traffic##btn_tr_clear") then
                        gameplay_traffic.deactivate(true)
                    end
                    
                    -- Вспомогательные очистки
                    if im.Button("Clean Non-Traffic Cars") then
                        if gameplay_traffic and gameplay_parking then
                            local safeIds = gameplay_traffic.getTrafficList(true) or {}
                            local parkedIds = gameplay_parking.getParkedCarsList(true) or {}
                            local allSafe = {}
                            for _, id in ipairs(safeIds) do allSafe[id] = true end
                            for _, id in ipairs(parkedIds) do allSafe[id] = true end
                            allSafe[vehId] = true
                            for i = be:getObjectCount() - 1, 0, -1 do
                                local obj = be:getObject(i)
                                if obj then
                                    local objId = obj:getID()
                                    if not allSafe[objId] then obj:delete() end
                                end
                            end
                        end
                    end
                    im.SameLine()
                    if im.Button("Force Despawn All AI Vehicles") then
                        for i = be:getObjectCount() - 1, 0, -1 do
                            local obj = be:getObject(i)
                            if obj and obj:getID() ~= vehId then
                                obj:delete()
                            end
                        end
                        gameplay_traffic.deactivate(true)
                    end

                    im.Text("Career:")
                    if im.Button("Activate Career Traffic") then
                        if gameplay_traffic then gameplay_traffic.activate() end
                    end
                    im.SameLine()
                    if im.Button("Disable & Clear Traffic") then
                        if gameplay_traffic then gameplay_traffic.deactivate(true) end
                    end
                    if im.Button("Clean Non-Traffic Cars") then
                        if gameplay_traffic and gameplay_parking then
                            local safeIds = gameplay_traffic.getTrafficList(true) or {}
                            local parkedIds = gameplay_parking.getParkedCarsList(true) or {}
                            local allSafe = {}
                            for _, id in ipairs(safeIds) do allSafe[id] = true end
                            for _, id in ipairs(parkedIds) do allSafe[id] = true end
                            allSafe[vehId] = true
                            for i = be:getObjectCount() - 1, 0, -1 do
                                local obj = be:getObject(i)
                                if obj then
                                    local objId = obj:getID()
                                    if not allSafe[objId] then obj:delete() end
                                end
                            end
                        end
                    end
                    im.SameLine()
                    if im.Button("Force Despawn All AI Vehicles") then
                        for i = be:getObjectCount() - 1, 0, -1 do
                            local obj = be:getObject(i)
                            if obj and obj:getID() ~= vehId then
                                obj:delete()
                            end
                        end
                        if gameplay_traffic then gameplay_traffic.deactivate(true) end
                    end

                    im.Separator()
                    
                    -- 2. ПРИНУДИТЕЛЬНОЕ ИЗМЕНЕНИЕ ПОВЕДЕНИЯ ИИ (AI Mode Override)
                    im.Text("Override AI Behavior for All Cars:")
                    
                    local currentAiMode = tVars.aiMode or "traffic"
                    im.Text(string.format("Current AI Mode: %s", currentAiMode:upper()))
                    
                    if im.Button("Normal Traffic##mode_traffic") then
                        gameplay_traffic.trackAIAllVeh("traffic")
                    end
                    im.SameLine()
                    if im.Button("Flee from Me##mode_flee") then
                        gameplay_traffic.trackAIAllVeh("flee")
                    end
                    im.SameLine()
                    if im.Button("Chase Player (Me)##mode_chase") then
                        gameplay_traffic.trackAIAllVeh("chase")
                    end
                    im.SameLine()
                    if im.Button("Stop Vehicles##mode_stop") then
                        gameplay_traffic.trackAIAllVeh("stop")
                    end

                    im.Separator()
                    
                    -- 3. ТОНКИЕ РЕГУЛИРОВКИ ПЕРЕМЕННЫХ ТРАФИКА
                    im.Text("Traffic Fine-Tuning:")
                    -- Частота респавна (spawnValue)
                    tsSpawnValuePtr = syncPtr(vehId, "traffic_spawnValue", tVars.spawnValue or 1.0, "FloatPtr")
                    im.SetNextItemWidth(200)
                    if im.SliderFloat("Respawn Frequency##tr_spawnVal", tsSpawnValuePtr, 0.0, 3.0, "Rate: %.2f") then
                        _G.CheatMenu_LastWriteTimes[vehId .. ".traffic_spawnValue"] = os.clock()
                        gameplay_traffic.setTrafficVars({spawnValue = tsSpawnValuePtr[0]})
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("Controls how quickly new traffic vehicles spawn in front of you.")
                    end
                    
                    -- Направление респавна (spawnDirBias)
                    tsDirBiasPtr = syncPtr(vehId, "traffic_spawnDirBias", tVars.spawnDirBias or 0.2, "FloatPtr")
                    im.SetNextItemWidth(200)
                    if im.SliderFloat("Spawn Direction Bias##tr_dirBias", tsDirBiasPtr, -1.0, 1.0, "Bias: %.2f") then
                        _G.CheatMenu_LastWriteTimes[vehId .. ".traffic_spawnDirBias"] = os.clock()
                        gameplay_traffic.setTrafficVars({spawnDirBias = tsDirBiasPtr[0]})
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("Negative values spawn cars driving AWAY from you. Positive values spawn them driving TOWARDS you.")
                    end
                    
                    -- Базовая агрессивность водителей (baseAggression)
                    tsAggPtr = syncPtr(vehId, "traffic_baseAggression", tVars.baseAggression or 0.35, "FloatPtr")
                    im.SetNextItemWidth(200)
                    if im.SliderFloat("Driver Aggression##tr_agg", tsAggPtr, 0.2, 1.0, "Aggression: %.2f") then
                        _G.CheatMenu_LastWriteTimes[vehId .. ".traffic_baseAggression"] = os.clock()
                        gameplay_traffic.setTrafficVars({baseAggression = tsAggPtr[0]})
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("Controls how fast, closely and aggressively the AI drivers will travel.")
                    end
                    
                    -- Ограничение скорости (speedLimit)
                    local speedLimitKMH = (tVars.speedLimit and tVars.speedLimit > 0) and math.floor(tVars.speedLimit * 3.6 + 0.5) or -1
                    local tsSpeedLimitPtr = getPtr(vehId, "traffic_speedLimit", speedLimitKMH, "IntPtr")
                    if not im.IsItemActive() then
                        tsSpeedLimitPtr[0] = speedLimitKMH
                    end
                    im.SetNextItemWidth(150)
                    if im.InputInt("Speed Limit (km/h, -1 = default)##tr_speedLimit", tsSpeedLimitPtr) then
                        local finalMS = tsSpeedLimitPtr[0] > 0 and (tsSpeedLimitPtr[0] / 3.6) or -1
                        gameplay_traffic.setTrafficVars({speedLimit = finalMS})
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("Overwrites the default road speed limits. Set to -1 to use standard map speed limits.")
                    end
                    
                    im.Spacing()
                    
                    -- Случайные криминальные погони ИИ за ИИ (enableRandomEvents)
                    tsEventsPtr = syncPtr(vehId, "traffic_randomEvents", tVars.enableRandomEvents or false, "BoolPtr")
                    if im.Checkbox("Enable Random Police Chases##tr_events", tsEventsPtr) then
                        _G.CheatMenu_LastWriteTimes[vehId .. ".traffic_randomEvents"] = os.clock()
                        gameplay_traffic.setTrafficVars({enableRandomEvents = tsEventsPtr[0]})
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("Enables random events, such as police cars automatically turning on sirens and chasing AI suspects.")
                    end
                    
                    -- Линии отладки (debugMode)
                    tsDebugPtr = syncPtr(vehId, "traffic_debugMode", gameplay_traffic.debugMode or false, "BoolPtr")
                    if im.Checkbox("Show ESP Trails & Info##tr_debug", tsDebugPtr) then
                        _G.CheatMenu_LastWriteTimes[vehId .. ".traffic_debugMode"] = os.clock()
                        gameplay_traffic.setDebugMode(tsDebugPtr[0])
                    end
                    if im.IsItemHovered() then
                        im.SetTooltip("Draws colored trails showing AI paths, target nodes, distances and current speed readouts on top of cars.")
                    end
                end
            end

            im.Separator()
            if im.CollapsingHeader1("Teleport##veh_specs_header") then
                if im.Button("Teleport to Active GPS Finishing Point (cheat metod)") then
                    local targetPos = core_groundMarkers and core_groundMarkers.getTargetPos()
                    if targetPos then
                        local x, y, z = targetPos.x, targetPos.y, targetPos.z
                        local castOrigin = vec3(x, y, z + 50)
                        local castDest = vec3(x, y, -500)
                        local rayRes = Engine.castRay(castOrigin, castDest, true, true)
                        if rayRes and rayRes.pt then
                            z = rayRes.pt.z + 1.2
                        else
                            z = z + 1.5
                        end
                        v:setPosition(vec3(x, y, z))
                    end
                end
                
                -- 1. Безопасный телепорт к финишу GPS (с помощью spawn.safeTeleport)
                if im.Button("Teleport to Active GPS Finishing Point (dev method)") then
                    local targetPos = core_groundMarkers and core_groundMarkers.getTargetPos()
                    if targetPos and v then
                        -- Используем системный безопасный телепорт
                        spawn.safeTeleport(v, targetPos, nil, nil, nil, nil, true, true)
                    end
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Safely teleports your car to the GPS waypoint on the ground, pushing traffic away.")
                end

                -- 2. Безопасный телепорт на ближайшую дорогу (с учетом стороны движения)
                if im.Button("Teleport to Nearest Road") then
                    if v and spawn.teleportToLastRoad then
                        spawn.teleportToLastRoad(v)
                    end
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Places your car on the nearest asphalt road, facing the correct driving direction.")
                end
                
                if im.Button("Free Camera") then
                    commands.toggleCamera()
                end
                im.SameLine()

                -- 1. Переключение режима ходьбы (Exit / Enter Vehicle) и проверка состояния
                local isWalking = gameplay_walk and gameplay_walk.isWalking and gameplay_walk.isWalking()
                local walkBtnLabel = isWalking and "Enter Vehicle (Seat In)##btn_walk" or "Exit Vehicle (Walk on Foot)##btn_walk"
                
                if im.Button(walkBtnLabel) then
                    if gameplay_walk and gameplay_walk.toggleWalkingMode then
                        gameplay_walk.toggleWalkingMode()
                    elseif commands and commands.toggleWalkingMode then
                        commands.toggleWalkingMode()
                    end
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Toggle walking mode: exit the car on foot or return to the driver seat")
                end

                im.SameLine()
                -- 2. Открытие всплывающего урока ходьбы (Walking Lesson Popup)
                if im.Button("Walking Lesson Popup##btn_walk_popup") then
                    if ui_popup and ui_popup.openPopupById then
                        ui_popup.openPopupById("walking", { root = "/gameplay/discover/freeroamTutorial/lessons/" })
                    end
                end
            end
            
            if im.CollapsingHeader1("Teleport and Coordinates") then

                -- 1. Телепорт по координатам
                im.Text("Teleport to Coordinates:")
            
                -- Вывод текущих координат в реальном времени для удобства
                local currentPos = v:getPosition()
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), 
                    string.format("My Position: X: %.2f | Y: %.2f | Z: %.2f", currentPos.x, currentPos.y, currentPos.z))
                
                -- Удобные кнопки копирования и телепортации
                if im.Button("Copy my Position##tp_get_coords") then
                    _G.CheatMenu_TeleportX[0] = currentPos.x
                    _G.CheatMenu_TeleportY[0] = currentPos.y
                    _G.CheatMenu_TeleportZ[0] = currentPos.z
                end
                if im.IsItemHovered() then im.SetTooltip("Copy your vehicle's current position to inputs below") end
                im.SameLine()
                
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.5, 0.3, 0.1, 1.0))
                if im.Button("Teleport##tp_coord_btn", im.ImVec2(100, 24)) then
                    v:setPosition(vec3(_G.CheatMenu_TeleportX[0], _G.CheatMenu_TeleportY[0], _G.CheatMenu_TeleportZ[0]))
                end
                im.PopStyleColor()
                if im.IsItemHovered() then im.SetTooltip("Teleport to coordinates specified in the inputs below") end
                
                -- Поля ручного ввода с шаговой регулировкой
                im.SetNextItemWidth(200)
                im.InputFloat("Target X##tp_x", _G.CheatMenu_TeleportX, 1.0, 10.0, "%.2f")
                im.SetNextItemWidth(200)
                im.InputFloat("Target Y##tp_y", _G.CheatMenu_TeleportY, 1.0, 10.0, "%.2f")
                im.SetNextItemWidth(200)
                im.InputFloat("Target Z##tp_z", _G.CheatMenu_TeleportZ, 1.0, 10.0, "%.2f")
                
                im.Separator()
                
                -- 2. Направленный телепорт относительно машины (D-Pad крестовина)
                im.Text("Directional Movement (D-Pad Layout):")
                im.SetNextItemWidth(250)
                im.SliderFloat("Step Distance##tp_dist_slider", _G.CheatMenu_TeleportDistance, 1.0, 300.0, "Step: %.1f m")
                im.Spacing()
                
                local distVal = _G.CheatMenu_TeleportDistance[0]
                local forwardVec = v:getDirectionVector()
                local rightVec = forwardVec:cross(vec3(0, 0, 1)):normalized()
                
                -- Ряд 1: Вперед
                im.SetCursorPosX(im.GetCursorPosX() + 41)
                if im.Button("  ^  ##tp_fwd", im.ImVec2(35, 30)) then
                    -- v:setPosition(currentPos + forwardVec * distVal)
                    spawn.safeTeleport(v, currentPos + forwardVec * distVal, nil, nil, nil, nil, true, true)
                end
                if im.IsItemHovered() then im.SetTooltip("Move Forward") end
                
                -- Ряд 2: Влево | Назад | Вправо
                if im.Button(" <  ##tp_lft", im.ImVec2(35, 30)) then
                    -- v:setPosition(currentPos - rightVec * distVal)
                    spawn.safeTeleport(v, currentPos - rightVec * distVal, nil, nil, nil, nil, true, true)
                end
                if im.IsItemHovered() then im.SetTooltip("Move Left") end
                im.SameLine()
                if im.Button("  v  ##tp_bwd", im.ImVec2(35, 30)) then
                    -- v:setPosition(currentPos - forwardVec * distVal)
                    spawn.safeTeleport(v, currentPos - forwardVec * distVal, nil, nil, nil, nil, true, true)
                end
                if im.IsItemHovered() then im.SetTooltip("Move Backward") end
                im.SameLine()
                if im.Button("  >  ##tp_rgt", im.ImVec2(35, 30)) then
                    -- v:setPosition(currentPos + rightVec * distVal)
                    spawn.safeTeleport(v, currentPos + rightVec * distVal, nil, nil, nil, nil, true, true)
                end
                if im.IsItemHovered() then im.SetTooltip("Move Right") end
                
                -- Вертикальное положение (Вверх | Вниз)
                im.SameLine()
                im.Spacing()
                im.SameLine()
                if im.Button("Up##tp_up", im.ImVec2(45, 30)) then
                    v:setPosition(currentPos + vec3(0, 0, distVal))
                end
                if im.IsItemHovered() then im.SetTooltip("Move Up") end
                im.SameLine()
                if im.Button("Down##tp_dwn", im.ImVec2(45, 30)) then
                    v:setPosition(currentPos + vec3(0, 0, -distVal))
                end
                if im.IsItemHovered() then im.SetTooltip("Move Down") end

                -- Использование getCameraMouseRay для телепортации под прицел
                if im.Button("Teleport Car to Crosshair (CameraMouseRay)", im.ImVec2(-1, 24)) then
                    local ray = getCameraMouseRay()
                    if ray and ray.pos and ray.dir then
                        local castOrigin = vec3(ray.pos)
                        local castDest = castOrigin + vec3(ray.dir) * 1500
                        local rayRes = Engine.castRay(castOrigin, castDest, true, true)
                        if rayRes and rayRes.pt then
                            v:setPosition(rayRes.pt + vec3(0, 0, 1.2))
                        end
                    end
                end
                if im.Button("Teleport to Active GPS Finishing Point (cheat metod)") then
                    local targetPos = core_groundMarkers and core_groundMarkers.getTargetPos()
                    if targetPos then
                        local x, y, z = targetPos.x, targetPos.y, targetPos.z
                        local castOrigin = vec3(x, y, z + 50)
                        local castDest = vec3(x, y, -500)
                        local rayRes = Engine.castRay(castOrigin, castDest, true, true)
                        if rayRes and rayRes.pt then
                            z = rayRes.pt.z + 1.2
                        else
                            z = z + 1.5
                        end
                        v:setPosition(vec3(x, y, z))
                    end
                end
                
                -- 1. Безопасный телепорт к финишу GPS (с помощью spawn.safeTeleport)
                if im.Button("Teleport to Active GPS Finishing Point (dev method)") then
                    local targetPos = core_groundMarkers and core_groundMarkers.getTargetPos()
                    if targetPos and v then
                        -- Используем системный безопасный телепорт
                        spawn.safeTeleport(v, targetPos, nil, nil, nil, nil, true, true)
                    end
                end
                if im.IsItemHovered() then
                    im.SetTooltip("Safely teleports your car to the GPS waypoint on the ground, pushing traffic away.")
                end

                -- 2. Безопасный телепорт на ближайшую дорогу (с учетом стороны движения)
                if im.Button("Teleport to Nearest Road") then
                    if v and spawn.teleportToLastRoad then
                        spawn.teleportToLastRoad(v)
                    end
                end
            end

            im.Separator()
            
            if im.CollapsingHeader1("AI Drive Autopilot##veh_specs_header") then

                -- ПАНЕЛЬ УПРАВЛЕНИЯ ИИ-АВТОПИЛОТОМ (AI Autopilot & Navigation Panel)
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "AI Autopilot Control Center:")
                
                local aiModesList = { "Disabled", "Traffic (Standard)", "Random Wander", "Manual (GPS Follow)", "Flee Mode", "Chase Target", "Follow Target", "Stop", "Custom Script Mode" }
                local currentAiMode = aiModesList[_G.CheatMenu_Ai_ModeIdx + 1] or "Disabled"
                
                -- 1. Выбор активного режима ИИ
                im.SetNextItemWidth(250)
                if im.BeginCombo("Active AI Mode##combo_ai_modes", currentAiMode) then
                    for idx, modeName in ipairs(aiModesList) do
                        local isSelected = (_G.CheatMenu_Ai_ModeIdx == idx - 1)
                        if im.Selectable1(modeName .. "##ai_" .. idx, isSelected) then
                            _G.CheatMenu_Ai_ModeIdx = idx - 1
                        end
                    end
                    im.EndCombo()
                end
                
                -- Контекстные параметры в зависимости от выбранного режима
                im.Indent(10)
                
                -- Параметры преследования/следования (для flee, chase, follow)
                if _G.CheatMenu_Ai_ModeIdx >= 4 and _G.CheatMenu_Ai_ModeIdx <= 6 then
                    im.SetNextItemWidth(150)
                    im.InputInt("Target Vehicle ID##ai_target_veh_id", _G.CheatMenu_Ai_TargetVehId)
                    if im.IsItemHovered() then 
                        im.SetTooltip("Enter the ID of the vehicle to chase, follow, or flee from (can be found in the Map List / Vehicles Tab)") 
                    end
                end
                
                -- Настройка кастомного режима (свободный ввод команд для ИИ-модуля)
                if _G.CheatMenu_Ai_ModeIdx == 8 then
                    im.Text("Type Custom AI Lua Command:")
                    im.SetNextItemWidth(-1)
                    im.InputText("##ai_custom_cmd_input", _G.CheatMenu_Ai_CustomCmd)
                    if im.IsItemHovered() then 
                        im.SetTooltip("Executed on the vehicle's Lua environment. E.g., ai.setMode('manual') ai.setTarget('node_name')") 
                    end
                end
                
                -- 2. Тонкие настройки поведения автопилота (если режим не "Disabled" и не "Stop")
                if _G.CheatMenu_Ai_ModeIdx ~= 0 and _G.CheatMenu_Ai_ModeIdx ~= 7 then
                    im.Spacing()
                    im.Text("Autopilot Tweaks:")
                    
                    -- Режим ограничения скорости
                    local speedModes = { "Legal Limits", "Target Speed Value", "Off (Maximum Power)" }
                    local curSpeedMode = speedModes[_G.CheatMenu_Ai_SpeedModeIdx + 1] or "Legal Limits"
                    im.SetNextItemWidth(200)
                    if im.BeginCombo("Speed Control Mode##combo_ai_speed", curSpeedMode) then
                        for idx, sName in ipairs(speedModes) do
                            local isSelected = (_G.CheatMenu_Ai_SpeedModeIdx == idx - 1)
                            if im.Selectable1(sName, isSelected) then
                                _G.CheatMenu_Ai_SpeedModeIdx = idx - 1
                            end
                        end
                        im.EndCombo()
                    end
                    
                    -- Ползунок скорости (активен только если выбран фиксированный лимит)
                    if _G.CheatMenu_Ai_SpeedModeIdx == 1 then
                        im.SetNextItemWidth(200)
                        im.SliderFloat("Target Speed (km/h)##ai_target_speed", _G.CheatMenu_Ai_SpeedLimit, 1.0, 350.0, "%.0f km/h")
                    end
                    
                    -- Агрессия / Степень риска (setAggression)
                    im.SetNextItemWidth(200)
                    im.SliderFloat("Driving Risk (Aggression)##ai_aggression_slider", _G.CheatMenu_Ai_Aggression, 0.1, 2.0, "Risk: %.2f")
                    if im.IsItemHovered() then 
                        im.SetTooltip("Lower values represent defensive driving. Higher values (1.0+) allow high speeds, drifting, and risky overtaking.") 
                    end
                    
                    -- Дополнительные флаги
                    im.Checkbox("Stay in Proper Lane (driveInLane)##ai_in_lane", _G.CheatMenu_Ai_InLane)
                    im.SameLine()
                    im.Checkbox("Avoid Collisions (avoidCars)##ai_avoid_cars", _G.CheatMenu_Ai_AvoidCars)
                end
                
                im.Unindent(10)
                im.Spacing()
                
                -- КНОПКИ УПРАВЛЕНИЯ: ЗАПУСК И СБРОС (Apply / Stop / Reset)
                local availX = im.GetContentRegionAvail().x
                local spacing = im.GetStyle().ItemSpacing.x
                local btnWidth = (availX - spacing) / 2
                
                -- Кнопка применения настроек (Зеленая)
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.6, 0.2, 1.0))
                if im.Button("Apply & Run##btn_apply_ai_autopilot", im.ImVec2(btnWidth, 25)) then
                    local modeIdx = _G.CheatMenu_Ai_ModeIdx
                    local speedModeKeys = { "legal", "limit", "off" }
                    local speedMode = speedModeKeys[_G.CheatMenu_Ai_SpeedModeIdx + 1] or "legal"
                    local speedVal = _G.CheatMenu_Ai_SpeedLimit[0] / 3.6
                    local inLaneStr = _G.CheatMenu_Ai_InLane[0] and "on" or "off"
                    local avoidCarsStr = _G.CheatMenu_Ai_AvoidCars[0] and "on" or "off"
                    local risk = _G.CheatMenu_Ai_Aggression[0]
                    
                    local cmd = "if ai then "
                    
                    cmd = cmd .. string.format("ai.setSpeedMode('%s') ", speedMode)
                    if speedMode == "limit" then
                        cmd = cmd .. string.format("ai.setSpeed(%f) ", speedVal)
                    end
                    cmd = cmd .. string.format("ai.driveInLane('%s') ", inLaneStr)
                    cmd = cmd .. string.format("ai.setAvoidCars('%s') ", avoidCarsStr)
                    cmd = cmd .. string.format("ai.setAggression(%f) ", risk)
                    
                    if modeIdx == 0 then
                        cmd = cmd .. "ai.setMode('disabled') "
                    elseif modeIdx == 1 then
                        cmd = cmd .. "ai.setMode('traffic') "
                    elseif modeIdx == 2 then
                        cmd = cmd .. "ai.setMode('random') "
                    elseif modeIdx == 3 then
                        local targetPos = core_groundMarkers and core_groundMarkers.getTargetPos()
                        local bestNodeName = nil
                        if targetPos and map and map.getMap then
                            local minDist = 99999
                            for nId, node in pairs(map.getMap().nodes) do
                                local dist = targetPos:distance(node.pos)
                                if dist < minDist then
                                    minDist = dist
                                    bestNodeName = nId
                                end
                            end
                        end
                        if bestNodeName then
                            if gameplay_traffic and gameplay_traffic.activate then
                                gameplay_traffic.activate({v:getID()})
                            end
                            cmd = cmd .. string.format("ai.setMode('manual') ai.setTarget('%s') ", bestNodeName)
                        else
                            cmd = cmd .. "ai.setMode('disabled') "
                        end
                    elseif modeIdx == 4 then
                        local targetId = _G.CheatMenu_Ai_TargetVehId[0]
                        cmd = cmd .. string.format("ai.setTargetObjectID(%d) ai.setMode('flee') ", targetId)
                    elseif modeIdx == 5 then
                        local targetId = _G.CheatMenu_Ai_TargetVehId[0]
                        cmd = cmd .. string.format("ai.setTargetObjectID(%d) ai.setMode('chase') ", targetId)
                    elseif modeIdx == 6 then
                        local targetId = _G.CheatMenu_Ai_TargetVehId[0]
                        cmd = cmd .. string.format("ai.setTargetObjectID(%d) ai.setMode('follow') ", targetId)
                    elseif modeIdx == 7 then
                        cmd = cmd .. "ai.setMode('stop') "
                    elseif modeIdx == 8 then
                        cmd = ffi.string(_G.CheatMenu_Ai_CustomCmd)
                    end
                    
                    cmd = cmd .. "end"
                    v:queueLuaCommand(cmd)
                end
                im.PopStyleColor()
                
                im.SameLine()
                
                -- Кнопка полной остановки и сброса ИИ в потоке (Красная)
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.75, 0.2, 0.2, 1.0))
                if im.Button("Stop / Reset AI##btn_reset_ai_autopilot", im.ImVec2(btnWidth, 25)) then
                    _G.CheatMenu_Ai_ModeIdx = 0 -- Сбрасываем режим на "Disabled" в графическом интерфейсе
                    v:queueLuaCommand("if ai then ai.setMode('disabled') end") -- Мгновенно отключаем ИИ в машине
                end
                im.PopStyleColor()
            end

            im.EndTabItem()
        end
        -- РАЗМЕРЫ МАШИНЫ И КОЛЕСА
        if im.BeginTabItem("Size") then
            if _G.CheatMenu_VehSpecs and _G.CheatMenu_VehSpecs[vehId] then
                local specs = _G.CheatMenu_VehSpecs[vehId]
                
                if specs == "PENDING" then
                    im.Text("Scanning vehicle specifications...")
                else
                    if im.CollapsingHeader1("Car info##veh_specs_header") then
                        im.BeginGroup()
                        
                        -- Колонка 1: Габариты и Аэродинамика
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Body & Dimensions:")
                        im.Text(string.format("Weight: %d kg", specs.weight or 0))
                        im.Text(string.format("Front/Rear: %d%%/%d%%", specs.frontWeight or 50, specs.rearWeight or 50))
                        im.Text(string.format("Length: %.2f m", specs.length or 0))
                        im.Text(string.format("Width:  %.2f m", specs.width or 0))
                        im.Text(string.format("Height: %.2f m", specs.height or 0))
                        im.Text(string.format("Steer Angle:  %d deg", specs.maxSteer or 35))
                        im.Text(string.format("Drag Coeff (Cd): %.2f", specs.cd or 0.32))
                        
                        im.EndGroup()
                        im.SameLine(150)
                        im.BeginGroup()
                        
                        -- Колонка 2: Двигатель и Трансмиссия
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Powertrain Layout:")
                        im.Text(string.format("Drivetrain: %s", tostring(specs.drivetrain)))
                        im.Text(string.format("Gearbox: %s", tostring(specs.transmission)))
                        im.Text(string.format("Induction: %s", tostring(specs.induction)))
                        im.Text(string.format("Propulsion: %s", tostring(specs.propulsion)))
                        
                        if specs.displacement and specs.displacement > 0.05 then
                            im.Text(string.format("Displacement: %.1f L", specs.displacement))
                        else
                            im.Text("Displacement: N/A")
                        end
                        
                        im.Text(string.format("Fuel Type: %s", tostring(specs.fuel)))
                        im.Text(string.format("Brake Pads: %s", tostring(specs.brakeType)))
                        
                        im.EndGroup()
                        im.SameLine(280)
                        im.BeginGroup()
                        
                        -- Колонка 3: Массы, Сила, Тормоза
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Performance:")
                        
                        if specs.power and specs.power > 0 then
                            im.Text(string.format("Power: %d HP (%d RPM)", specs.power, specs.powerRPM or 0))
                        else
                            im.Text("Power: N/A")
                        end
                        
                        if specs.torque and specs.torque > 0 then
                            im.Text(string.format("Torque: %d Nm (%d RPM)", specs.torque, specs.torqueRPM or 0))
                        else
                            im.Text("Torque: N/A")
                        end

                        if specs.power and specs.power > 0 then
                            local pwRatio = specs.weight / specs.power
                            im.Text(string.format("Weight/HP: %.2f kg/HP", pwRatio))
                        else
                            im.Text("Weight/HP:  N/A")
                        end
                        -- Обороты и Лимиты
                        im.Text(string.format("RPM/Max: %d/%d", specs.outputRPM or 0, specs.maxRPM or 0))
                        
                        
                        im.EndGroup()
                        im.SameLine(475)
                        im.BeginGroup()
                        
                        -- Колонка 3: Массы, Сила, Тормоза
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Live:")
                        
                        -- Мощность и Крутящий момент (из engineInfo)
                        im.Text(string.format("Engine: %.1f HP", vehState.enginePowerHP or 0.0))
                        im.Text(string.format("Engine: %.1f Nm", vehState.flywheelTorque or 0.0))
                        im.Text(string.format("Wheel:  %.1f HP", vehState.wheelPowerHP or 0.0))
                        im.Text(string.format("Wheel:  %.1f Nm", vehState.wheelTorque or 0.0))
                        
                        -- Двигатель и Охлаждение
                        im.Text(string.format("Engine Load:         %.1f%%", (vehState.engineLoad or 0.0) * 100))
                        im.Text(string.format("Engine Throttle:    %.1f%%", (vehState.engineThrottle or 0.0) * 100))
                        
                        -- Положение педалей в реальном времени
                        im.Text(string.format("Throttle: %.0f%% Brake: %.0f%% Clutch: %.0f%%", 
                            (vehState.pedalThrottle or 0.0) * 100, 
                            (vehState.pedalBrake or 0.0) * 100, 
                            (vehState.pedalClutch or 0.0) * 100))
                        
                        -- Коробка передач и сцепление
                        im.Text(string.format("Gear: %s", tostring(vehState.gearName)))
                        
                        im.SameLine()
                        -- Статус
                        if vehState.gearboxMode then
                            im.Text(string.format("(%s)", tostring(vehState.gearboxMode):upper()))
                        end
                        im.EndGroup()
                    end
                end
            end
            im.Separator()
            if im.CollapsingHeader1("Size Editor") then
                im.Text("Ctrl + Click to type a specific value")

                im.Text("Scaling of the size of any object:")
                renderSliderWithReset("Size Multiplier", "carScaleMultiplier", 0.1, 100.0, 1.0, "applyCarScaleInstant", "%.2f")
                renderSliderWithReset("Scale Width (X)", "carWidthMultiplier", 0.1, 100.0, 1.0, "applyCarWidthInstant", "%.2f", true)
                renderSliderWithReset("Scale Length (Y)", "carLengthMultiplier", 0.1, 100.0, 1.0, "applyCarLengthInstant", "%.2f", true)
                renderSliderWithReset("Scale Height (Z)", "carThicknessMultiplier", 0.1, 100.0, 1.0, "applyCarThicknessInstant", "%.2f", true)
            end

            if im.CollapsingHeader1("Size Editor (Real time)") then
                im.Text("Suspension Height & Alignment:")
                renderSliderWithReset("Suspension Height", "suspensionHeightMultiplier", 0.1, 50.0, 1.0, nil, "%.2f")
                
                -- СЛАЙДЕР РАЗВАЛА КОЛЕС (Camber/Stance)
                local camberPtr = syncPtr(vehId, "camber_offset", vehState.camberOffset or 0.0, "FloatPtr")
                if im.Button("RES##res_camber", im.ImVec2(30, 0)) then
                    camberPtr[0] = 0.0
                    _G.CheatMenu_LastWriteTimes[vehId .. ".camber_offset"] = os.clock()
                    v:queueLuaCommand(string.format("applyCamberAndOffset(0.0, %f)", vehState.wheelOffset or 0.0))
                end
                im.SameLine()
                im.SetNextItemWidth(200)
                if im.SliderFloat("Wheel Camber (Stance)##slider_camber", camberPtr, -0.15, 0.35, "Camber: %.3f") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".camber_offset"] = os.clock()
                    v:queueLuaCommand(string.format("applyCamberAndOffset(%f, %f)", camberPtr[0], vehState.wheelOffset or 0.0))
                end

                -- СЛАЙДЕР ВЫЛЕТА КОЛЕС (Wheel Offset / Track Width)
                local offsetPtr = syncPtr(vehId, "wheel_offset", vehState.wheelOffset or 0.0, "FloatPtr")
                if im.Button("RES##res_offset", im.ImVec2(30, 0)) then
                    offsetPtr[0] = 0.0
                    _G.CheatMenu_LastWriteTimes[vehId .. ".wheel_offset"] = os.clock()
                    v:queueLuaCommand(string.format("applyCamberAndOffset(%f, 0.0)", vehState.camberOffset or 0.0))
                end
                im.SameLine()
                im.SetNextItemWidth(200)
                if im.SliderFloat("Wheel Offset (Track Width)##slider_offset", offsetPtr, -0.10, 0.45, "Offset: %.3f") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".wheel_offset"] = os.clock()
                    v:queueLuaCommand(string.format("applyCamberAndOffset(%f, %f)", vehState.camberOffset or 0.0, offsetPtr[0]))
                end

                im.Separator()
                im.Text("Suspension Stiffness & Dampening:")

                -- СЛАЙДЕР ЖЕСТКОСТИ ПОДВЕСКИ (Springs Stiffness)
                local springPtr = syncPtr(vehId, "suspension_spring_mult", vehState.suspensionSpringMultiplier or 1.0, "FloatPtr")
                if im.Button("RES##res_spring", im.ImVec2(30, 0)) then
                    springPtr[0] = 1.0
                    _G.CheatMenu_LastWriteTimes[vehId .. ".suspension_spring_mult"] = os.clock()
                    v:queueLuaCommand(string.format("applySuspensionTuning(1.0, %f)", vehState.suspensionDampMultiplier or 1.0))
                end
                im.SameLine()
                im.SetNextItemWidth(200)
                if im.SliderFloat("Suspension Stiffness##slider_spring", springPtr, 0.1, 20.0, "Stiffness: %.2fx") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".suspension_spring_mult"] = os.clock()
                    v:queueLuaCommand(string.format("applySuspensionTuning(%f, %f)", springPtr[0], vehState.suspensionDampMultiplier or 1.0))
                end

                -- СЛАЙДЕР ДЕМПФИРОВАНИЯ АМОРТИЗАТОРОВ (Dampening)
                local dampPtr = syncPtr(vehId, "suspension_damp_mult", vehState.suspensionDampMultiplier or 1.0, "FloatPtr")
                if im.Button("RES##res_damp", im.ImVec2(30, 0)) then
                    dampPtr[0] = 1.0
                    _G.CheatMenu_LastWriteTimes[vehId .. ".suspension_damp_mult"] = os.clock()
                    v:queueLuaCommand(string.format("applySuspensionTuning(%f, 1.0)", vehState.suspensionSpringMultiplier or 1.0))
                end
                im.SameLine()
                im.SetNextItemWidth(200)
                if im.SliderFloat("Suspension Dampening##slider_damp", dampPtr, 0.1, 20.0, "Damp: %.2fx") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".suspension_damp_mult"] = os.clock()
                    v:queueLuaCommand(string.format("applySuspensionTuning(%f, %f)", vehState.suspensionSpringMultiplier or 1.0, dampPtr[0]))
                end

                im.Separator()
                im.Text("Wheels & Tires:")
                renderSliderIntWithReset("Wheel Diameter (Inches)", "wheelSize", 5, 100, 21, sendElec)
                renderSliderIntWithReset("Wheel Width (mm)", "wheelWidth", 50, 1000, 300, sendElec)
                
                -- НАСТРОЙКА ДАВЛЕНИЯ В ШИНАХ (Tire Pressure)
                local pressurePtr = syncPtr(vehId, "tire_pressure_psi", vehState.tirePressurePSI or 30.0, "FloatPtr")
                if im.Button("RES##res_pressure", im.ImVec2(30, 0)) then
                    pressurePtr[0] = 30.0
                    _G.CheatMenu_LastWriteTimes[vehId .. ".tire_pressure_psi"] = os.clock()
                    v:queueLuaCommand("applyTirePressure(30.0)")
                end
                im.SameLine()
                im.SetNextItemWidth(200)
                if im.SliderFloat("Tire Pressure (PSI)##slider_pressure", pressurePtr, -100, 500.0, "%.1f PSI") then
                    _G.CheatMenu_LastWriteTimes[vehId .. ".tire_pressure_psi"] = os.clock()
                    v:queueLuaCommand(string.format("applyTirePressure(%f)", pressurePtr[0]))
                end

                -- УЛЬТИМАТИВНЫЙ РЕДАКТОР ФИЗИКИ И СТРУКТУРЫ ШИН (PressureWheels JBeam Editor) [2.1.1, 2.4.1]
                if vehState.hasTires then
                    im.Separator()
                    im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Advanced JBeam pressureWheels Editor:")

                    -- КНОПКА ПОЛНОГО СБРОСА ВСЕГО КОНСТРУКТОРА В 1.0 [2]
                    if im.Button("Reset Entire Tire JBeam Constructor to Default##btn_tReset", im.ImVec2(-1, 24)) then
                        local params = {"tireRadiusMult", "tireWidthMult", "tireSideSpring", "tireSideDamp", "tireSideExpSpring", "tireSideExpDamp", "tireSidePre", "tireSideDeform", "tireSideStrength", "tireReinfSpring", "tireReinfDamp", "tireReinfPre", "tireTreadSpring", "tireTreadDamp", "tireTreadPre", "tireTreadDeform", "tireTreadStrength", "tireTreadReinfSpring", "tireTreadReinfDamp", "tireTreadPre", "tirePeriSpring", "tirePeriDamp", "tirePeriPre", "tirePeriDeform", "tirePeriStrength", "tirePeriReinfSpring", "tirePeriReinfDamp", "tirePeriReinfPre", "tireNodeWeight", "tireFriction", "tireSliding"}
                        for _, pName in ipairs(params) do
                            vehState[pName] = 1.0
                            _G.CheatMenu_LastWriteTimes[vehId .. "." .. pName] = os.clock()
                        end
                        sendAdvancedTireTuning(vehId, v, vehState, "tireRadiusMult", 1.0)
                    end
                    
                    im.Spacing()

                    -- Группа 1: Размеры и Сцепление (Nodes & Contact) [2]
                    if im.TreeNode1("1. Tire Dimensions & Contact Grip##tree_tContact") then
                        -- Трение статика (frictionCoef)
                        local ptr = syncPtr(vehId, "tireFriction", vehState.tireFriction or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Static Friction (Grip)##s_tGrip", ptr, 0.1, 50.0, "Grip: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireFriction", ptr[0])
                        end

                        -- Трение скольжения (slidingFrictionCoef)
                        local ptr = syncPtr(vehId, "tireSliding", vehState.tireSliding or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Sliding Friction (Slide)##s_tSlide", ptr, 0.1, 50.0, "Sliding: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireSliding", ptr[0])
                        end

                        -- Масса шины (nodeWeight)
                        local ptr = syncPtr(vehId, "tireNodeWeight", vehState.tireNodeWeight or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Tire Node Weight##s_tWeight", ptr, 0.1, 10.0, "Weight: %.2fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireNodeWeight", ptr[0])
                        end

                        -- Физический радиус шины (radius)
                        local ptr = syncPtr(vehId, "tireRadiusMult", vehState.tireRadiusMult or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Physical Tire Radius##s_tRadius", ptr, 0.5, 3.0, "Radius: %.3fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireRadiusMult", ptr[0])
                        end

                        -- Физическая ширина протектора (tireWidth)
                        local ptr = syncPtr(vehId, "tireWidthMult", vehState.tireWidthMult or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Physical Tire Width##s_tWidth", ptr, 0.5, 3.0, "Width: %.3fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireWidthMult", ptr[0])
                        end

                        im.TreePop()
                    end

                    -- Группа 2: Боковины шины (wheelSideBeams) [2]
                    if im.TreeNode1("2. Tire Sidewall (wheelSideBeams)##tree_tSide") then
                        -- Жесткость (Spring)
                        local ptr = syncPtr(vehId, "tireSideSpring", vehState.tireSideSpring or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Spring Stiffness##s_tSideSpr", ptr, 0.05, 50.0, "Stiffness: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireSideSpring", ptr[0])
                        end

                        -- Демпфирование (Damp)
                        local ptr = syncPtr(vehId, "tireSideDamp", vehState.tireSideDamp or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Dampening##s_tSideDmp", ptr, 0.05, 50.0, "Damp: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireSideDamp", ptr[0])
                        end

                        -- Жесткость на растяжение (SpringExpansion)
                        local ptr = syncPtr(vehId, "tireSideExpSpring", vehState.tireSideExpSpring or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Expansion Stiffness##s_tSideExpSpr", ptr, 0.05, 50.0, "Stiffness: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireSideExpSpring", ptr[0])
                        end

                        -- Демпфирование на растяжение (DampExpansion)
                        local ptr = syncPtr(vehId, "tireSideExpDamp", vehState.tireSideExpDamp or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Expansion Dampening##s_tSideExpDmp", ptr, 0.05, 50.0, "Damp: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireSideExpDamp", ptr[0])
                        end

                        -- Прекомпрессия боковины (Precompression)
                        local ptr = syncPtr(vehId, "tireSidePre", vehState.tireSidePre or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Precompression##s_tSidePre", ptr, 0.5, 2.0, "Precomp: %.3fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireSidePre", ptr[0])
                        end

                        -- Прочность деформации (Deform)
                        local ptr = syncPtr(vehId, "tireSideDeform", vehState.tireSideDeform or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Deform Limit##s_tSideDef", ptr, 0.1, 1000.0, "Deform: %.1fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireSideDeform", ptr[0])
                        end

                        -- Прочность на разрыв (Strength)
                        local ptr = syncPtr(vehId, "tireSideStrength", vehState.tireSideStrength or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Strength Limit##s_tSideStr", ptr, 0.1, 1000.0, "Strength: %.1fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireSideStrength", ptr[0])
                        end

                        im.TreePop()
                    end

                    -- Группа 3: Внутренний корд (wheelReinfBeams) [2]
                    if im.TreeNode1("3. Tire Reinforcements (wheelReinfBeams)##tree_tReinf") then
                        -- Жесткость (Spring)
                        local ptr = syncPtr(vehId, "tireReinfSpring", vehState.tireReinfSpring or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Spring Stiffness##s_tReinfSpr", ptr, 0.05, 50.0, "Stiffness: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireReinfSpring", ptr[0])
                        end

                        -- Демпфирование (Damp)
                        local ptr = syncPtr(vehId, "tireReinfDamp", vehState.tireReinfDamp or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Dampening##s_tReinfDmp", ptr, 0.05, 50.0, "Damp: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireReinfDamp", ptr[0])
                        end

                        -- Прекомпрессия (Precompression)
                        local ptr = syncPtr(vehId, "tireReinfPre", vehState.tireReinfPre or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Precompression##s_tReinfPre", ptr, 0.5, 2.0, "Precomp: %.3fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireReinfPre", ptr[0])
                        end

                        im.TreePop()
                    end

                    -- Группа 4: Протекторные балки (wheelTreadBeams) [2]
                    if im.TreeNode1("4. Tire Tread (wheelTreadBeams)##tree_tTread") then
                        -- Жесткость (Spring)
                        local ptr = syncPtr(vehId, "tireTreadSpring", vehState.tireTreadSpring or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Spring Stiffness##s_tTreadSpr", ptr, 0.05, 50.0, "Stiffness: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireTreadSpring", ptr[0])
                        end

                        -- Демпфирование (Damp)
                        local ptr = syncPtr(vehId, "tireTreadDamp", vehState.tireTreadDamp or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Dampening##s_tTreadDmp", ptr, 0.05, 50.0, "Damp: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireTreadDamp", ptr[0])
                        end

                        -- Прекомпрессия (Precompression)
                        local ptr = syncPtr(vehId, "tireTreadPre", vehState.tireTreadPre or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Precompression##s_tTreadPre", ptr, 0.5, 2.0, "Precomp: %.3fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireTreadPre", ptr[0])
                        end

                        -- Прочность деформации (Deform)
                        local ptr = syncPtr(vehId, "tireTreadDeform", vehState.tireTreadDeform or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Deform Limit##s_tTreadDef", ptr, 0.1, 1000.0, "Deform: %.1fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireTreadDeform", ptr[0])
                        end

                        -- Прочность на разрыв (Strength)
                        local ptr = syncPtr(vehId, "tireTreadStrength", vehState.tireTreadStrength or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Strength Limit##s_tTreadStr", ptr, 0.1, 1000.0, "Strength: %.1fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireTreadStrength", ptr[0])
                        end

                        im.TreePop()
                    end

                    -- Группа 5: Усиление протектора (wheelTreadReinfBeams) [2]
                    if im.TreeNode1("5. Tire Tread Reinforcement (wheelTreadReinfBeams)##tree_tTreadReinf") then
                        -- Жесткость (Spring)
                        local ptr = syncPtr(vehId, "tireTreadReinfSpring", vehState.tireTreadReinfSpring or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Spring Stiffness##s_tTreadReinfSpr", ptr, 0.05, 50.0, "Stiffness: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireTreadReinfSpring", ptr[0])
                        end

                        -- Демпфирование (Damp)
                        local ptr = syncPtr(vehId, "tireTreadReinfDamp", vehState.tireTreadReinfDamp or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Dampening##s_tTreadReinfDmp", ptr, 0.05, 50.0, "Damp: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireTreadReinfDamp", ptr[0])
                        end

                        -- Прекомпрессия (Precompression)
                        local ptr = syncPtr(vehId, "tireTreadReinfPre", vehState.tireTreadReinfPre or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Precompression##s_tTreadReinfPre", ptr, 0.5, 2.0, "Precomp: %.3fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tireTreadReinfPre", ptr[0])
                        end

                        im.TreePop()
                    end

                    -- Группа 6: Окружные балки шины (wheelPeripheryBeams) [2]
                    if im.TreeNode1("6. Tire Periphery (wheelPeripheryBeams)##tree_tPeri") then
                        -- Жесткость (Spring)
                        local ptr = syncPtr(vehId, "tirePeriSpring", vehState.tirePeriSpring or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Spring Stiffness##s_tPeriSpr", ptr, 0.05, 50.0, "Stiffness: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tirePeriSpring", ptr[0])
                        end

                        -- Демпфирование (Damp)
                        local ptr = syncPtr(vehId, "tirePeriDamp", vehState.tirePeriDamp or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Dampening##s_tPeriDmp", ptr, 0.05, 50.0, "Damp: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tirePeriDamp", ptr[0])
                        end

                        -- Прекомпрессия (Precompression)
                        local ptr = syncPtr(vehId, "tirePeriPre", vehState.tirePeriPre or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Precompression##s_tPeriPre", ptr, 0.5, 2.0, "Precomp: %.3fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tirePeriPre", ptr[0])
                        end

                        -- Прочность деформации (Deform)
                        local ptr = syncPtr(vehId, "tirePeriDeform", vehState.tirePeriDeform or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Deform Limit##s_tPeriDef", ptr, 0.1, 1000.0, "Deform: %.1fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tirePeriDeform", ptr[0])
                        end

                        -- Прочность на разрыв (Strength)
                        local ptr = syncPtr(vehId, "tirePeriStrength", vehState.tirePeriStrength or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Strength Limit##s_tPeriStr", ptr, 0.1, 1000.0, "Strength: %.1fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tirePeriStrength", ptr[0])
                        end

                        im.TreePop()
                    end

                    -- Группа 7: Усиление окружности шины (wheelPeripheryReinfBeams) [2]
                    if im.TreeNode1("7. Tire Periphery Reinforcement (wheelPeripheryReinfBeams)##tree_tPeriReinf") then
                        -- Жесткость (Spring)
                        local ptr = syncPtr(vehId, "tirePeriReinfSpring", vehState.tirePeriReinfSpring or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Spring Stiffness##s_tPeriReinfSpr", ptr, 0.05, 50.0, "Stiffness: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tirePeriReinfSpring", ptr[0])
                        end

                        -- Демпфирование (Damp)
                        local ptr = syncPtr(vehId, "tirePeriReinfDamp", vehState.tirePeriReinfDamp or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Dampening##s_tPeriReinfDmp", ptr, 0.05, 50.0, "Damp: %.2fx", im.SliderFlags_Logarithmic) then
                            sendAdvancedTireTuning(vehId, v, vehState, "tirePeriReinfDamp", ptr[0])
                        end

                        -- Прекомпрессия (Precompression)
                        local ptr = syncPtr(vehId, "tirePeriReinfPre", vehState.tirePeriReinfPre or 1.0, "FloatPtr")
                        im.SetNextItemWidth(180)
                        if im.SliderFloat("Precompression##s_tPeriReinfPre", ptr, 0.5, 2.0, "Precomp: %.3fx") then
                            sendAdvancedTireTuning(vehId, v, vehState, "tirePeriReinfPre", ptr[0])
                        end

                        im.TreePop()
                    end
                end
            end
            
            if im.CollapsingHeader1("Part Resizer & Part Mover##part_scale_mover_hdr") then
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Ctrl + Click to type a specific value")
                local parts = _G.CheatMenuWindow_Data.parts[vehId] or {}
                if #parts == 0 then
                    im.Text("No physical part list found. Re-spawn or drive the car first.")
                else
                    im.Text("Search Vehicle Part:")
                    im.InputText("##PartSearch", partFilterText)
                    local searchStr = string.lower(ffi.string(partFilterText))
                    
                    -- Прокручиваемый список деталей (С ЗАЩИТОЙ ОТ ОТСКОКОВ XYZ) [2]
                    im.BeginChild1("PartsScroll", im.ImVec2(0, 500), true, 0)
                    for _, partInfo in ipairs(parts) do
                        local match = true
                        if searchStr ~= "" then
                            local nameLower = string.lower(partInfo.name or "")
                            local friendlyLower = string.lower(partInfo.friendly or "")
                            if not string.find(nameLower, searchStr) and not string.find(friendlyLower, searchStr) then
                                match = false
                            end
                        end
                        
                        if match then
                            local partName = partInfo.name
                            local displayName = partInfo.friendly ~= "" and partInfo.friendly or partName
                            
                            -- Считываем актуальный масштаб и смещение из состояния машины
                            local currentScale = (vehState.partScaleTargets and vehState.partScaleTargets[partName]) or 1.0
                            local currentOffset = (vehState.partOffsetTargets and vehState.partOffsetTargets[partName]) or { x = 0.0, y = 0.0, z = 0.0 }
                            
                            local isModified = math.abs(currentScale - 1.0) > 0.001 or 
                                               math.abs(currentOffset.x or 0.0) > 0.001 or 
                                               math.abs(currentOffset.y or 0.0) > 0.001 or 
                                               math.abs(currentOffset.z or 0.0) > 0.001
                            
                            -- Подсвечиваем измененные детали красивым оранжевым цветом
                            if isModified then
                                im.TextColored(im.ImVec4(1.0, 0.6, 0.2, 1.0), displayName .. " *")
                            else
                                im.Text(displayName)
                            end
                            
                            -- 1. Слайдер изменения МАСШТАБА (Размера)
                            local partScalePtr = syncPtr(vehId, "part_scale_" .. partName, currentScale, "FloatPtr")
                            im.SetNextItemWidth(-150)
                            local scaleChanged = im.SliderFloat("Scale##" .. partName, partScalePtr, 0.1, 15.0, "Scale: %.3f")
                            
                            im.SameLine()
                            if im.Button("Reset Scale##" .. partName) then
                                partScalePtr[0] = 1.0
                                _G.CheatMenu_LastWriteTimes[vehId .. ".part_scale_" .. partName] = os.clock()
                                v:queueLuaCommand(string.format("CheatMenuM.applyPartScaleInstant('%s', 1.0)", partName))
                            elseif scaleChanged then
                                _G.CheatMenu_LastWriteTimes[vehId .. ".part_scale_" .. partName] = os.clock()
                                v:queueLuaCommand(string.format("CheatMenuM.applyPartScaleInstant('%s', %f)", partName, partScalePtr[0]))
                            end
                            
                            -- 2. Вложенный выпадающий список для СМЕЩЕНИЯ детали (TreeNode)
                            if im.TreeNode1("Offset Controls (XYZ Move)##tree_offset_" .. partName) then
                                -- Применяем syncPtr для каждой координатной оси индивидуально [2]
                                local offsetXPtr = syncPtr(vehId, "part_offsetX_" .. partName, currentOffset.x or 0.0, "FloatPtr")
                                local offsetYPtr = syncPtr(vehId, "part_offsetY_" .. partName, currentOffset.y or 0.0, "FloatPtr")
                                local offsetZPtr = syncPtr(vehId, "part_offsetZ_" .. partName, currentOffset.z or 0.0, "FloatPtr")
                                
                                local offsetChanged = false
                                
                                -- Ползунки X, Y, Z с троттлингом времени записи для предотвращения сброса осей [2]
                                im.SetNextItemWidth(130)
                                if im.SliderFloat("X (Width)##s_x_" .. partName, offsetXPtr, -3.0, 3.0, "X: %.3f m") then 
                                    _G.CheatMenu_LastWriteTimes[vehId .. ".part_offsetX_" .. partName] = os.clock()
                                    offsetChanged = true 
                                end
                                im.SameLine()
                                im.SetNextItemWidth(130)
                                if im.SliderFloat("Y (Length)##s_y_" .. partName, offsetYPtr, -3.0, 3.0, "Y: %.3f m") then 
                                    _G.CheatMenu_LastWriteTimes[vehId .. ".part_offsetY_" .. partName] = os.clock()
                                    offsetChanged = true 
                                end
                                im.SameLine()
                                im.SetNextItemWidth(130)
                                if im.SliderFloat("Z (Height)##s_z_" .. partName, offsetZPtr, -3.0, 3.0, "Z: %.3f m") then 
                                    _G.CheatMenu_LastWriteTimes[vehId .. ".part_offsetZ_" .. partName] = os.clock()
                                    offsetChanged = true 
                                end
                                
                                if offsetChanged then
                                    v:queueLuaCommand(string.format("CheatMenuM.applyPartOffsetInstant('%s', %f, %f, %f)", partName, offsetXPtr[0], offsetYPtr[0], offsetZPtr[0]))
                                end
                                
                                im.SameLine()
                                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.4, 0.4, 0.4, 1.0))
                                if im.Button("Reset Offset##btn_res_offset_" .. partName) then
                                    offsetXPtr[0], offsetYPtr[0], offsetZPtr[0] = 0.0, 0.0, 0.0
                                    _G.CheatMenu_LastWriteTimes[vehId .. ".part_offsetX_" .. partName] = os.clock()
                                    _G.CheatMenu_LastWriteTimes[vehId .. ".part_offsetY_" .. partName] = os.clock()
                                    _G.CheatMenu_LastWriteTimes[vehId .. ".part_offsetZ_" .. partName] = os.clock()
                                    v:queueLuaCommand(string.format("CheatMenuM.applyPartOffsetInstant('%s', 0.0, 0.0, 0.0)", partName))
                                end
                                im.PopStyleColor()
                                
                                im.TreePop()
                            end
                            im.Separator()
                        end
                    end
                    im.EndChild()
                end
            end

            if im.CollapsingHeader1("Size Map & World Dimensions Resizer (FAST)##map_scale_hdr") then
                im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), "Real-time World & Terrain Resizer:")
                im.Text("Resizes map length, width, and height/relief thickness (Z-axis).")
                im.Spacing()

                local mapChanged = false

                -- Общий пропорциональный масштаб (XYZ)
                im.SetNextItemWidth(220)
                if im.SliderFloat("Overall Map Size (XYZ)##map_sz_all", _G.CheatMenu_MapScaleUniform, 0.01, 10.0, "Overall: %.2fx", im.SliderFlags_Logarithmic) then
                    _G.CheatMenu_MapScaleX[0] = _G.CheatMenu_MapScaleUniform[0]
                    _G.CheatMenu_MapScaleY[0] = _G.CheatMenu_MapScaleUniform[0]
                    _G.CheatMenu_MapScaleZ[0] = _G.CheatMenu_MapScaleUniform[0]
                    mapChanged = true
                end

                im.Separator()
                im.Text("Independent Axis Scaling:")

                -- Ширина карты (X)
                im.SetNextItemWidth(220)
                if im.SliderFloat("Map Width (X)##map_sz_x", _G.CheatMenu_MapScaleX, 0.01, 10.0, "Width: %.2fx", im.SliderFlags_Logarithmic) then
                    mapChanged = true
                end

                -- Длина карты (Y)
                im.SetNextItemWidth(220)
                if im.SliderFloat("Map Length (Y)##map_sz_y", _G.CheatMenu_MapScaleY, 0.01, 10.0, "Length: %.2fx", im.SliderFlags_Logarithmic) then
                    mapChanged = true
                end

                -- Толщина / Высота гор и рельефа (Z)
                im.SetNextItemWidth(220)
                if im.SliderFloat("Terrain Height / Relief (Z)##map_sz_z", _G.CheatMenu_MapScaleZ, 0.01, 10.0, "Height: %.2fx", im.SliderFlags_Logarithmic) then
                    mapChanged = true
                end

                im.Spacing()
                
                -- Кнопка принудительного применения
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.2, 0.6, 0.2, 1.0))
                if im.Button("Apply Map Scale & Reload Collisions##btn_apply_map_scale", im.ImVec2(270, 28)) or mapChanged then
                    applyMapScaleGE(_G.CheatMenu_MapScaleX[0], _G.CheatMenu_MapScaleY[0], _G.CheatMenu_MapScaleZ[0], false)
                end
                im.PopStyleColor()

                im.SameLine()
                -- Кнопка сброса к заводским параметрам
                if im.Button("Reset Map to Stock##btn_reset_map_scale", im.ImVec2(160, 28)) then
                    _G.CheatMenu_MapScaleX[0] = 1.0
                    _G.CheatMenu_MapScaleY[0] = 1.0
                    _G.CheatMenu_MapScaleZ[0] = 1.0
                    _G.CheatMenu_MapScaleUniform[0] = 1.0
                    applyMapScaleGE(1.0, 1.0, 1.0, true)
                end
            end
            im.EndTabItem()
        end

        if im.BeginTabItem("Vehicles") then
            im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Active Vehicles & Objects Manager (Map List)")
            
            im.Separator()
                _G.CheatMenu_SpecsTimer = (_G.CheatMenu_SpecsTimer or 0) + 1

                local playerVeh = be:getPlayerVehicle(0)
                local playerVehId = playerVeh and playerVeh:getID() or -1
                local playerPos = playerVeh and playerVeh:getPosition() or core_camera.getPosition()
                
                -- Инициализация глобального хранилища телеметрии
                if not _G.CheatMenu_VehTelemetry then _G.CheatMenu_VehTelemetry = {} end

                
                -- СБОР ВСЕХ ОБЪЕКТОВ (АВТО + ПРИЦЕПЫ + ПРОПСЫ + ПРЕДМЕТЫ)
                -- И РАСЧЕТ ИХ НАГРУЗКИ НА ЦПУ И ВЛИЯНИЯ НА FPS
                
                local allObjectsList = {}
                local totalPhysicsComplexity = 0

                -- 1. Сканируем физические объекты из движка (авто, прицепы, физические предметы, бочки, трамплины)
                local numObj = be:getObjectCount()
                for i = 0, numObj - 1 do
                    local targetObj = be:getObject(i)
                    if targetObj then
                        local oId = targetObj:getID()
                        local className = targetObj:getClassName()
                        local jbeamName = targetObj.JBeam or className
                        
                        local nodes = (targetObj.getNodeCount and targetObj:getNodeCount()) or 0
                        local beams = (targetObj.getBeamCount and targetObj:getBeamCount()) or 0
                        local complexity = nodes + beams
                        
                        totalPhysicsComplexity = totalPhysicsComplexity + complexity
                        
                        table.insert(allObjectsList, {
                            id = oId,
                            obj = targetObj,
                            isPhysics = true,
                            isVehicle = (className == "BeamNGVehicle"),
                            name = jbeamName,
                            nodes = nodes,
                            beams = beams,
                            complexity = complexity,
                            pos = targetObj:getPosition()
                        })
                    end
                end

                -- 2. Сканируем статические спавненные предметы (TSStatic декорации, рампы, блоки)
                if _G.CheatMenu_SpawnedObjectsList then
                    for _, sId in ipairs(_G.CheatMenu_SpawnedObjectsList) do
                        local staticObj = scenetree.findObject(sId)
                        if staticObj then
                            local alreadyAdded = false
                            for _, existing in ipairs(allObjectsList) do
                                if existing.id == sId then alreadyAdded = true; break end
                            end
                            if not alreadyAdded then
                                local shapeName = staticObj:getField("shapeName", 0) or "Static Prop"
                                local fileName = shapeName:match("([^/]+)$") or shapeName
                                table.insert(allObjectsList, {
                                    id = sId,
                                    obj = staticObj,
                                    isPhysics = false,
                                    isVehicle = false,
                                    name = "Prop: " .. fileName,
                                    nodes = 0,
                                    beams = 0,
                                    complexity = 0,
                                    pos = staticObj:getPosition()
                                })
                            end
                        end
                    end
                end

                -- 3. Вычисляем процент нагрузки на процессор (CPU %) и примерный расход FPS для каждого объекта
                local fpsReal = (Engine and Engine.getFPS) and Engine.getFPS() or 60.0
                for _, item in ipairs(allObjectsList) do
                    if totalPhysicsComplexity > 0 and item.complexity > 0 then
                        item.cpuLoadPercent = (item.complexity / totalPhysicsComplexity) * 100.0
                        local estFpsLoss = (item.complexity / 180.0) * (60.0 / math.max(30.0, fpsReal))
                        item.fpsImpact = math.max(0.1, estFpsLoss)
                    else
                        item.cpuLoadPercent = 0.0
                        item.fpsImpact = 0.0
                    end
                end

                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), 
                    string.format("Total Active Objects: %d (Vehicles & Props) | Total Physics Complexity: %d nodes/beams", 
                    #allObjectsList, totalPhysicsComplexity))

                
                -- 1. ИНТЕРАКТИВНЫЙ КАТАЛОГ И ПОИСК АВТОМОБИЛЕЙ
                
                if im.CollapsingHeader1("Universal Vehicle Spawner Catalog##veh_catalog_header") then
                    local models = getCachedModelList()
                    if models and #models > 0 then
                        im.Text("Search Vehicle Model:")
                        im.InputText("##ModelFilter", _G.CheatMenu_Spawn_ModelFilter)
                        local mSearch = string.lower(ffi.string(_G.CheatMenu_Spawn_ModelFilter))

                        local filteredModels = {}
                        for _, m in ipairs(models) do
                            if mSearch == "" or string.find(string.lower(m.name .. " " .. m.key), mSearch) then
                                table.insert(filteredModels, m)
                            end
                        end

                        if _G.CheatMenu_Spawn_SelModelIdx >= #filteredModels then
                            _G.CheatMenu_Spawn_SelModelIdx = 0
                        end

                        local chosenModel = filteredModels[_G.CheatMenu_Spawn_SelModelIdx + 1]
                        local chosenModelLabel = chosenModel and chosenModel.name or "Select Vehicle Model..."
                        im.SetNextItemWidth(-1)
                        if im.BeginCombo("Select Model##combo_veh_models", chosenModelLabel) then
                            for idx, m in ipairs(filteredModels) do
                                local isSelected = (_G.CheatMenu_Spawn_SelModelIdx == idx - 1)
                                if im.Selectable1(m.name .. " (" .. m.key .. ")##model_" .. idx, isSelected) then
                                    _G.CheatMenu_Spawn_SelModelIdx = idx - 1
                                    _G.CheatMenu_Spawn_SelConfigIdx = 0
                                end
                            end
                            im.EndCombo()
                        end

                        if chosenModel then
                            local configs = getModelConfigs(chosenModel.key)
                            im.Text("Search Configuration:")
                            im.InputText("##ConfigFilter", _G.CheatMenu_Spawn_ConfigFilter)
                            local cSearch = string.lower(ffi.string(_G.CheatMenu_Spawn_ConfigFilter))

                            local filteredConfigs = {}
                            for _, c in ipairs(configs) do
                                if cSearch == "" or string.find(string.lower(c.name .. " " .. c.key), cSearch) then
                                    table.insert(filteredConfigs, c)
                                end
                            end

                            if _G.CheatMenu_Spawn_SelConfigIdx >= #filteredConfigs then
                                _G.CheatMenu_Spawn_SelConfigIdx = 0
                            end

                            local chosenConfig = filteredConfigs[_G.CheatMenu_Spawn_SelConfigIdx + 1]
                            local chosenConfigLabel = chosenConfig and chosenConfig.name or "Select Configuration..."
                            
                            im.SetNextItemWidth(-1)
                            if im.BeginCombo("Select Config##combo_veh_configs", chosenConfigLabel) then
                                for idx, c in ipairs(filteredConfigs) do
                                    local isSelected = (_G.CheatMenu_Spawn_SelConfigIdx == idx - 1)
                                    if im.Selectable1(c.name .. "##config_" .. idx, isSelected) then
                                        _G.CheatMenu_Spawn_SelConfigIdx = idx - 1
                                    end
                                end
                                im.EndCombo()
                            end

                            im.Spacing()
                            im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Spawn Configuration:")
                            im.SetNextItemWidth(250)
                            im.SliderInt("Quantity to Spawn##catalog_qty", _G.CheatMenu_Spawn_Amount, 1, 30, "%d cars")
                            
                            im.Spacing()
                            if chosenConfig then
                                if im.Button("Spawn Selected as New##spawn_selected_new", im.ImVec2(180, 26)) then
                                    guihooks.trigger("app:waiting", true)
                                    local spawnCount = _G.CheatMenu_Spawn_Amount[0]
                                    if spawnCount < 1 then spawnCount = 1 end
                                    for i = 1, spawnCount do
                                        core_vehicles.spawnNewVehicle(chosenModel.key, { config = chosenConfig.key })
                                    end
                                    guihooks.trigger("app:waiting", false)
                                end
                                im.SameLine()
                                if im.Button("Replace Current with Selected##replace_selected_cur", im.ImVec2(240, 26)) then
                                    guihooks.trigger("app:waiting", true)
                                    core_vehicles.replaceVehicle(chosenModel.key, { config = chosenConfig.key })
                                    guihooks.trigger("app:waiting", false)
                                end
                            else
                                if im.Button("Spawn Model Default as New##spawn_model_new", im.ImVec2(180, 26)) then
                                    guihooks.trigger("app:waiting", true)
                                    local spawnCount = _G.CheatMenu_Spawn_Amount[0]
                                    if spawnCount < 1 then spawnCount = 1 end
                                    for i = 1, spawnCount do
                                        core_vehicles.spawnNewVehicle(chosenModel.key, {})
                                    end
                                    guihooks.trigger("app:waiting", false)
                                end
                                im.SameLine()
                                if im.Button("Replace Current with Model Default##replace_model_cur", im.ImVec2(240, 26)) then
                                    guihooks.trigger("app:waiting", true)
                                    core_vehicles.replaceVehicle(chosenModel.key, {})
                                    guihooks.trigger("app:waiting", false)
                                end
                            end
                        end
                    else
                        im.Text("Scanning vehicle catalog model list...")
                    end
                end

                
                -- 2. ПОДМЕНЮ: СПАВН И ПОСТРОЕНИЕ ГРУПП МАШИН (Vehicle Group Spawner)
                
                if im.CollapsingHeader1("Vehicle Group Spawner & Arranger") then
                    if not multiSpawn then
                        im.TextColored(im.ImVec4(1.0, 0.3, 0.3, 1.0), "Error: core_multiSpawn extension is not loaded.")
                        im.Text("Please ensure the game's multiSpawn system is active.")
                    else
                        im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Vehicle Group Spawner & Arranger:")
                        im.Spacing()

                        local gAmountPtr = getPtr(vehId, "group_amount", 5, "IntPtr")
                        im.SetNextItemWidth(220)
                        if im.InputInt("Amount of Vehicles##group_amt", gAmountPtr, 1, 5) then
                            if gAmountPtr[0] < 1 then gAmountPtr[0] = 1 end
                        end

                        local gGapPtr = getPtr(vehId, "group_gap", 15.0, "FloatPtr")
                        im.SetNextItemWidth(220)
                        im.SliderFloat("Spacing / Gap##group_gap", gGapPtr, 2.0, 100.0, "%.1f meters")

                        local modeIdxPtr = getPtr(vehId, "group_spawn_mode_idx", 0, "IntPtr")
                        local currentMode = spawnModesList[modeIdxPtr[0] + 1] or "roadAhead"
                        im.SetNextItemWidth(220)
                        if im.BeginCombo("Formation Mode##group_mode", currentMode) then
                            for idx, modeName in ipairs(spawnModesList) do
                                local isSelected = (modeIdxPtr[0] == idx - 1)
                                if im.Selectable1(modeName, isSelected) then
                                    modeIdxPtr[0] = idx - 1
                                end
                                if isSelected then im.SetItemDefaultFocus() end
                            end
                            im.EndCombo()
                        end

                        local countryIdxPtr = getPtr(vehId, "group_country_idx", 0, "IntPtr")
                        local currentCountry = countriesList[countryIdxPtr[0] + 1] or "All"
                        im.SetNextItemWidth(220)
                        if im.BeginCombo("Country Filter##group_country", currentCountry) then
                            for idx, cName in ipairs(countriesList) do
                                local isSelected = (countryIdxPtr[0] == idx - 1)
                                if im.Selectable1(cName, isSelected) then countryIdxPtr[0] = idx - 1 end
                            end
                            im.EndCombo()
                        end

                        im.Text("Generation Options:")
                        local gShufflePtr = getPtr(vehId, "group_shuffle", false, "BoolPtr")
                        im.Checkbox("Shuffle Vehicle Order##group_shuf", gShufflePtr)

                        local gRandomPaintsPtr = getPtr(vehId, "group_random_paints", true, "BoolPtr")
                        im.Checkbox("Use Random Factory Paints##group_paints", gRandomPaintsPtr)

                        local gAllModsPtr = getPtr(vehId, "group_all_mods", false, "BoolPtr")
                        im.Checkbox("Include Mod Vehicles##group_mods", gAllModsPtr)

                        local gAllConfigsPtr = getPtr(vehId, "group_all_configs", true, "BoolPtr")
                        im.Checkbox("Include All Configs (Unchecked = default only)##group_configs", gAllConfigsPtr)
                        
                        if im.Button("Spawn Group Vehicles##btn_spawn_group", im.ImVec2(220, 30)) then
                            local selectedCountry = countriesList[countryIdxPtr[0] + 1]
                            if selectedCountry == "All" then selectedCountry = nil end

                            local params = {
                                allMods = gAllModsPtr[0],
                                allConfigs = gAllConfigsPtr[0],
                                country = selectedCountry,
                                modelPopPower = 1.5,
                                configPopPower = 1.5
                            }
                            local group = multiSpawn.createGroup(gAmountPtr[0], params)
                            local options = {
                                mode = spawnModesList[modeIdxPtr[0] + 1],
                                gap = gGapPtr[0],
                                shuffle = gShufflePtr[0],
                                randomPaints = gRandomPaintsPtr[0],
                                name = "custom"
                            }
                            multiSpawn.spawnGroup(group, gAmountPtr[0], options)
                        end

                        im.SameLine()
                        if im.Button("Arrange Active Cars##btn_place_group", im.ImVec2(220, 30)) then
                            local ignorePlayerPtr = getPtr(vehId, "group_ignore_player", false, "BoolPtr")
                            local vehIds = {}
                            for _, val in ipairs(getAllVehiclesByType()) do
                                if not (ignorePlayerPtr[0] and val:getID() == be:getPlayerVehicleID(0)) then
                                    table.insert(vehIds, val:getID())
                                end
                            end
                            local options = {
                                mode = spawnModesList[modeIdxPtr[0] + 1],
                                gap = gGapPtr[0],
                                ignoreSafe = false,
                                ignoreAdjust = false
                            }
                            multiSpawn.placeGroup(vehIds, options)
                        end

                        local ignorePlayerPtr = getPtr(vehId, "group_ignore_player", false, "BoolPtr")
                        im.Checkbox("Do not move player's vehicle during arrangement", ignorePlayerPtr)

                        im.Spacing()
                        im.Text("Despawn Operations:")

                        local delAmtPtr = getPtr(vehId, "group_del_amt", 1, "IntPtr")
                        im.SetNextItemWidth(120)
                        im.InputInt("Amount to Delete##group_del_amt_inp", delAmtPtr)
                        if delAmtPtr[0] < 1 then delAmtPtr[0] = 1 end

                        if im.Button("Delete N Group Cars##btn_del_n") then
                            multiSpawn.deleteVehicles(delAmtPtr[0], "custom")
                        end
                        im.SameLine()
                        if im.Button("Clear All Group Cars##btn_del_all") then
                            multiSpawn.deleteVehicles(nil, "custom")
                        end
                    end
                end

                
                -- 3. УТИЛИТЫ УПРАВЛЕНИЯ И ОЧИСТКИ ТРАНСПОРТА
                
                im.TextColored(im.ImVec4(1.0, 0.8, 0.4, 1.0), "Vehicle Management & Spawn Utilities:")
                
                if im.Button("Clone Current Vehicle##mgmt_clone") then
                    guihooks.trigger("app:waiting", true)
                    core_vehicles.cloneCurrent()
                    guihooks.trigger("app:waiting", false)
                end
                im.SameLine()
                
                if im.Button("Save Config Menu##mgmt_save_config") then
                    guihooks.trigger("ChangeState", "vehicle-config/save")
                end
                im.SameLine()

                if im.Button("Spawn Random Vehicle##mgmt_spawn_rand") then
                    local listData = core_vehicles.getModelList and core_vehicles.getModelList(true)
                    local models = listData and listData.models
                    if models and #models > 0 then
                        local randomModelData = models[math.random(1, #models)]
                        local randomModel = randomModelData.key
                        local model = core_vehicles.getModel(randomModel)
                        if model and model.configs then
                            local configsList = {}
                            for k, _ in pairs(model.configs) do table.insert(configsList, k) end
                            if #configsList > 0 then
                                local randomConfig = configsList[math.random(1, #configsList)]
                                core_vehicles.spawnNewVehicle(randomModel, { config = randomConfig })
                            end
                        end
                    end
                end
                
                if im.Button("Save default.pc##mgmt_save_def") then
                    if extensions.core_vehicle_partmgmt and extensions.core_vehicle_partmgmt.savedefault then
                        extensions.core_vehicle_partmgmt.savedefault()
                    end
                end
                im.SameLine()
                if im.Button("Load default.pc##mgmt_load_def") then
                    guihooks.trigger("app:waiting", true)
                    core_vehicles.spawnDefault()
                    guihooks.trigger("app:waiting", false)
                end
                im.SameLine()
                if im.Button("Reset Gameplay Objects##mgmt_res_gameplay") then
                    resetGameplay(-1)
                    guihooks.trigger("ChangeState", "play")
                end

                im.Spacing()
                im.PushStyleColor2(im.Col_Button, im.ImVec4(0.75, 0.2, 0.2, 1.0))
                if im.Button("Remove Current Car##mgmt_rem_cur") then
                    core_vehicles.removeCurrent()
                    extensions.hook("trackNewVeh")
                end
                im.SameLine()
                if im.Button("Remove Others##mgmt_rem_oth") then
                    core_vehicles.removeAllExceptCurrent()
                    extensions.hook("trackNewVeh")
                end
                im.SameLine()
                if im.Button("Remove Absolutely All AI##mgmt_rem_all") then
                    core_vehicles.removeAll()
                    extensions.hook("trackNewVeh")
                end
                im.PopStyleColor()

                im.Separator()
                im.Spacing()

                
                -- 4. ГЛОБАЛЬНЫЕ КНОПКИ УПРАВЛЕНИЯ ВСЕМ ТРАНСПОРТОМ НА КАРТЕ
                
                if im.Button("Repair All Cars##glob_rep") then
                    for _, item in ipairs(allObjectsList) do
                        if item.isVehicle then item.obj:queueLuaCommand("recovery.recoverInPlace()") end
                    end
                end
                if im.IsItemHovered() then im.SetTooltip("Instantly repair and clean every vehicle on the map") end
                im.SameLine()
                
                if im.Button("Explode All Cars##glob_exp") then
                    for _, item in ipairs(allObjectsList) do
                        if item.isVehicle then
                            item.obj:queueLuaCommand("if fire then if type(fire.explodeVehicle) == 'function' then fire.explodeVehicle() elseif type(fire.explode) == 'function' then fire.explode() end end")
                        end
                    end
                end
                if im.IsItemHovered() then im.SetTooltip("Explode all active vehicles on the map simultaneously") end
                im.SameLine()

                if im.Button("Start All Engines##glob_start") then
                    for _, item in ipairs(allObjectsList) do
                        if item.isVehicle then
                            item.obj:queueLuaCommand("electrics.setIgnitionLevel(3); local eng = powertrain.getDevice('mainEngine'); if eng and eng.enable then eng:enable() end")
                            item.obj:queueLuaCommand("electrics.setIgnitionLevel(3); local eng = powertrain.getDevice('mainEngine'); if eng and eng.enable then eng:enable() end")
                        end
                    end
                end
                if im.IsItemHovered() then im.SetTooltip("Start ignition and engines of all vehicles on the map") end
                im.SameLine()

                if im.Button("Stop All Engines##glob_stop") then
                    for _, item in ipairs(allObjectsList) do
                        if item.isVehicle then
                            item.obj:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.disable then eng:disable() end; electrics.setIgnitionLevel(0)")
                        end
                    end
                end
                if im.IsItemHovered() then im.SetTooltip("Turn off engines and electronics of all vehicles on the map") end
                im.SameLine()

                if im.Button("Deflate All Tires##glob_deflate") then
                    for _, item in ipairs(allObjectsList) do
                        if item.isVehicle then
                            item.obj:queueLuaCommand("if beamstate and type(beamstate.deflateTires) == 'function' then beamstate.deflateTires() end")
                        end
                    end
                end
                if im.IsItemHovered() then im.SetTooltip("Remotely deflate all tires on all vehicles on the map") end
                
                im.Separator()

                
                -- 5. ИНТЕРАКТИВНЫЙ СПИСОК ВСЕХ ОБЪЕКТОВ И МАШИН С ЗАЩИЩЕННОЙ ТЕЛЕМЕТРИЕЙ
                
                for _, item in ipairs(allObjectsList) do
                    local tId = item.id
                    local isPlayer = (tId == playerVehId)
                    local targetObj = item.obj
                    local targetPos = item.pos or vec3(0,0,0)
                    
                    local dist = playerPos and playerPos:distance(targetPos) or 0
                    local speedKMH = (item.isPhysics and targetObj.getVelocity) and (targetObj:getVelocity():length() * 3.6) or 0.0

                    -- Опрос телеметрии каждые 3 кадра ТОЛЬКО для авто (Защищен от отсутствия electrics/powertrain)
                    if item.isVehicle and (_G.CheatMenu_SpecsTimer % 3 == 0) then
                        targetObj:queueLuaCommand(string.format([[
                            local flatCount = 0
                            if wheels and wheels.wheels then
                                for _, w in pairs(wheels.wheels) do
                                    if w.isTireDeflated then flatCount = flatCount + 1 end
                                end
                            end

                            local isBroken = 0
                            if powertrain and type(powertrain.getDevice) == "function" then
                                local eng = powertrain.getDevice('mainEngine')
                                if eng and eng.isBroken then isBroken = 1 end
                            end

                            local gear = 0
                            local rpm = 0
                            local fuel = 0
                            local soc = 0
                            local checkEngine = 0
                            local engineRunning = 0

                            if electrics and electrics.values then
                                gear = electrics.values.gear or electrics.values.gearIndex or 0
                                rpm = tonumber(electrics.values.rpm) or 0
                                fuel = tonumber(electrics.values.fuel) or 0
                                soc = tonumber(electrics.values.stateOfCharge) or 0
                                if electrics.values.checkengine == true or electrics.values.checkengine == 1 then checkEngine = 1 end
                                if electrics.values.engineRunning == true or electrics.values.engineRunning == 1 then engineRunning = 1 end
                            end

                            local cmd = "if not _G.CheatMenu_VehTelemetry then _G.CheatMenu_VehTelemetry = {} end _G.CheatMenu_VehTelemetry[" .. %d .. "] = { " ..
                                "rpm = " .. rpm .. ", " ..
                                "gear = '" .. tostring(gear) .. "', " ..
                                "fuel = " .. fuel .. ", " ..
                                "soc = " .. soc .. ", " ..
                                "checkEngine = " .. checkEngine .. ", " ..
                                "engineRunning = " .. engineRunning .. ", " ..
                                "flatTires = " .. flatCount .. ", " ..
                                "isBroken = " .. isBroken .. " }"
                            obj:queueGameEngineLua(cmd)
                        ]], tId))
                    end

                    -- ВЫВОД ИМЕНИ, ИДЕНТИФИКАТОРА И СКОРОСТИ
                    if isPlayer then
                        im.TextColored(im.ImVec4(0.2, 1.0, 0.2, 1.0), 
                            string.format("(Current) %s [%d] | Speed: %d km/h", item.name, tId, math.floor(speedKMH)))
                    elseif item.isVehicle then
                        im.Text(string.format("%s [%d] | Distance: %d m | Speed: %d km/h", 
                            item.name, tId, math.floor(dist), math.floor(speedKMH)))
                    else
                        im.TextColored(im.ImVec4(0.4, 0.8, 1.0, 1.0), 
                            string.format("Item/Prop: %s [%d] | Distance: %d m", item.name, tId, math.floor(dist)))
                    end

                    -- ВЫВОД ОЦЕНКИ НАГРУЗКИ НА ЦПУ И РАСХОДА FPS
                    local cpuColor = im.ImVec4(0.2, 1.0, 0.4, 1.0)
                    if item.cpuLoadPercent > 35.0 then
                        cpuColor = im.ImVec4(1.0, 0.3, 0.2, 1.0)
                    elseif item.cpuLoadPercent > 15.0 then
                        cpuColor = im.ImVec4(1.0, 0.8, 0.2, 1.0)
                    end

                    if item.isPhysics then
                        im.TextColored(cpuColor, string.format("Physics CPU Load: %.1f%% (-%.1f FPS) | JBeam Nodes: %d, Beams: %d", 
                            item.cpuLoadPercent, item.fpsImpact, item.nodes, item.beams))
                    else
                        im.TextColored(im.ImVec4(0.6, 0.6, 0.6, 1.0), "Static Map Object (0% Physics CPU Load)")
                    end

                    -- ТЕЛЕМЕТРИЯ И СТАТУС ДЛЯ АВТОМОБИЛЕЙ (С Резервным чтением для игрока)
                    if item.isVehicle then
                        local tel = _G.CheatMenu_VehTelemetry[tId]
                        
                        -- Резервная телеметрия для машины игрока из vehState
                        if not tel and isPlayer and vehState then
                            tel = {
                                rpm = vehState.outputRPM or vehState.rpm or 0,
                                gear = vehState.gearName or vehState.gear or "N",
                                fuel = vehState.fuelRatio or 0,
                                soc = 0,
                                checkEngine = vehState.checkEngine and 1 or 0,
                                engineRunning = vehState.isEngineRunning or 0,
                                flatTires = 0,
                                isBroken = 0
                            }
                        end
                        tel = tel or { rpm = 0, gear = "N", fuel = 0, soc = 0, checkEngine = 0, engineRunning = 0, flatTires = 0, isBroken = 0 }

                        local gearStr = tostring(tel.gear or "N")
                        if gearStr == "0" then gearStr = "N" end
                        if gearStr == "-1" then gearStr = "R" end
                        
                        local fuelPercent = math.floor(((tel.soc and tel.soc > 0) and tel.soc or tel.fuel or 0) * 100)
                        local fuelLabel = (tel.soc and tel.soc > 0) and "Battery" or "Fuel"
                        
                        local engineStatus = (tel.isBroken == 1 and "Engine: BROKEN") or (tel.checkEngine == 1 and "Engine: DAMAGED") or "Engine: OK"
                        local statusColor = (tel.isBroken == 1 and im.ImVec4(1.0, 0.2, 0.2, 1.0)) or (tel.checkEngine == 1 and im.ImVec4(1.0, 0.6, 0.2, 1.0)) or im.ImVec4(0.2, 1.0, 0.2, 1.0)
                        
                        local tireStatus = (tel.flatTires and tel.flatTires > 0 and string.format("Tires: %d FLAT", tel.flatTires)) or "Tires: OK"
                        local tireColor = (tel.flatTires and tel.flatTires > 0 and im.ImVec4(1.0, 0.4, 0.2, 1.0)) or im.ImVec4(0.2, 1.0, 0.2, 1.0)

                        im.Text(string.format("%.0f RPM | Gear: %s | %s: %d%%", tel.rpm or 0, gearStr, fuelLabel, fuelPercent))
                        im.SameLine()
                        im.TextColored(statusColor, "| " .. engineStatus)
                        im.SameLine()
                        im.TextColored(tireColor, " | " .. tireStatus)
                    end

                    -- ================== КНОПКИ ДЕЙСТВИЙ ДЛЯ КАЖДОГО ОБЪЕКТА ==================
                    if not isPlayer then
                        if item.isVehicle then
                            if im.Button("Switch##switch_" .. tId) then be:enterVehicle(0, targetObj) end
                            if im.IsItemHovered() then im.SetTooltip("Switch control to this vehicle (Tab)") end
                            im.SameLine()
                        end
                        
                        if im.Button("Teleport To##tp_" .. tId) then
                            if playerVeh then spawn.safeTeleport(playerVeh, targetPos) end
                        end
                        if im.IsItemHovered() then im.SetTooltip("Teleport your vehicle to this vehicle's location") end
                        im.SameLine()
                        
                        if im.Button("Teleport to Me##bring_" .. tId) then
                            if playerVeh then 
                                if item.isVehicle then
                                    spawn.safeTeleport(targetObj, playerPos)
                                else
                                    targetObj:setPosition(playerPos + vec3(0, 2, 0))
                                    be:reloadCollision()
                                end
                            end
                        end
                        if im.IsItemHovered() then im.SetTooltip("Teleport this vehicle or object to your current location") end
                        im.SameLine()
                    end

                    if im.Button("Teleport All Here##tp_all_here_" .. tId) then
                        for _, other in ipairs(allObjectsList) do
                            if other.id ~= tId then 
                                if other.isVehicle then
                                    spawn.safeTeleport(other.obj, targetPos) 
                                else
                                    other.obj:setPosition(targetPos + vec3(0, 2, 0))
                                end
                            end
                        end
                        be:reloadCollision()
                    end
                    if im.IsItemHovered() then im.SetTooltip("Teleport absolutely all other vehicles and objects to this position") end

                    if item.isVehicle then
                        local tel = _G.CheatMenu_VehTelemetry[tId] or { engineRunning = 0 }
                        local isRunning = (tel.engineRunning and tel.engineRunning > 0.1)
                        local btnEngineLabel = isRunning and "Stop Engine##eng_" or "Start Engine##eng_"
                        if im.Button(btnEngineLabel .. tId) then
                            if isRunning then 
                                targetObj:queueLuaCommand("local eng = powertrain.getDevice('mainEngine'); if eng and eng.disable then eng:disable() end; electrics.setIgnitionLevel(0)")
                            else 
                                targetObj:queueLuaCommand("electrics.setIgnitionLevel(3); local eng = powertrain.getDevice('mainEngine'); if eng and eng.enable then eng:enable() end")
                                targetObj:queueLuaCommand("electrics.setIgnitionLevel(3); local eng = powertrain.getDevice('mainEngine'); if eng and eng.enable then eng:enable() end") 
                            end
                        end
                        if im.IsItemHovered() then im.SetTooltip("Remotely start or stop the engine") end
                        im.SameLine()
                        
                        if im.Button("Repair##rep_" .. tId) then targetObj:queueLuaCommand("recovery.recoverInPlace()") end
                        if im.IsItemHovered() then im.SetTooltip("Instantly repair and clean this vehicle") end
                        im.SameLine()
                        
                        if im.Button("Explode##exp_" .. tId) then
                            targetObj:queueLuaCommand("if fire then if type(fire.explodeVehicle) == 'function' then fire.explodeVehicle() elseif type(fire.explode) == 'function' then fire.explode() end end")
                        end
                        if im.IsItemHovered() then im.SetTooltip("Instantly explode the fuel tank") end
                        im.SameLine()
                        
                        if im.Button("Dismantle##strip_" .. tId) then
                            targetObj:queueLuaCommand("if beamstate then if type(beamstate.breakAllCouplers) == 'function' then beamstate.breakAllCouplers() end if type(beamstate.breakCouplers) == 'function' then beamstate.breakCouplers() end end local beamCount = obj:getBeamCount() for i = 0, beamCount - 1 do obj:breakBeam(i) end")
                        end
                        if im.IsItemHovered() then im.SetTooltip("Shatter vehicle structure and strip all parts") end
                        im.SameLine()
                        
                        if im.Button("Clone##clone_" .. tId) then
                            local vData = core_vehicle_manager and core_vehicle_manager.getVehicleData(tId)
                            local options = {}
                            if vData then
                                options.config = vData.config
                                options.paints = vData.paints
                            end
                            if core_vehicles and core_vehicles.spawnNewVehicle then
                                core_vehicles.spawnNewVehicle(targetObj.JBeam, options)
                            end
                        end
                        if im.IsItemHovered() then im.SetTooltip("Duplicate this vehicle with its current configurations") end
                        im.SameLine()
                    end

                    if not isPlayer then
                        im.PushStyleColor2(im.Col_Button, im.ImVec4(0.75, 0.2, 0.2, 1.0))
                        if im.Button("Delete##del_" .. tId) then 
                            if item.isVehicle then
                                if core_vehicles and core_vehicles.removeVehicle then
                                    core_vehicles.removeVehicle(tId)
                                elseif targetObj and targetObj.delete then
                                    targetObj:delete()
                                end
                            else
                                if targetObj and targetObj.delete then
                                    targetObj:delete()
                                end
                            end
                            be:reloadCollision()
                        end
                        im.PopStyleColor()
                        if im.IsItemHovered() then im.SetTooltip("Completely remove this vehicle or object from the map") end
                    end
                    
                    im.Separator()
                end

            im.EndTabItem()
        end

        -- ONGLET PRESETS
        if im.BeginTabItem("Presets") then
            local playerVeh2 = be:getPlayerVehicle(0)
            local vehId2 = playerVeh2 and playerVeh2:getID() or 0
            renderPresetsTab(vehId2, dtReal)
            im.EndTabItem()
        end

        im.EndTabBar()
    end

    im.End()
        popThemeColors() -- Очищаем стек цветов после отрисовки
    
    -- ОТРИСОВКА 5-СЕКУНДНОГО ТЕКСТА ЗАЩИТЫ ОТ НЕСТАБИЛЬНОСТИ СВЕРХУ ЭКРАНА
    
    if _G.CheatMenu_InstabilityAlertTimer and _G.CheatMenu_InstabilityAlertTimer > 0 then
        _G.CheatMenu_InstabilityAlertTimer = _G.CheatMenu_InstabilityAlertTimer - dtReal

        local displaySize = im.GetIO().DisplaySize
        local screenW = displaySize.x

        -- Позиционируем окно ровно по центру вверху экрана (Y = 35px)
        im.SetNextWindowPos(im.ImVec2(screenW * 0.5, 35.0), im.Cond_Always, im.ImVec2(0.5, 0.0))
        im.SetNextWindowBgAlpha(0.85)

        local windowFlags = im.WindowFlags_NoDecoration +
                            im.WindowFlags_AlwaysAutoResize +
                            im.WindowFlags_NoSavedSettings +
                            im.WindowFlags_NoFocusOnAppearing +
                            im.WindowFlags_NoNav +
                            im.WindowFlags_NoMove

        if im.Begin("##InstabilityTopAlertOverlay", nil, windowFlags) then
            im.TextColored(im.ImVec4(1.0, 0.25, 0.25, 1.0), string.format("INSTABILITY DETECTION (%.1fs)", math.max(0, _G.CheatMenu_InstabilityAlertTimer)))
            im.TextColored(im.ImVec4(1.0, 0.9, 0.4, 1.0), "Vehicle respawned & cheats reset to 1.0x")
            im.End()
        end
    end
end


-- Функция отрисовки кадра (ESP, 3D виртуальные объекты и песок)
function M.onPreRender(dtReal, dtSim, dtRaw)
    local playerVeh = be:getPlayerVehicle(0)
    local playerPos = nil
    
    if playerVeh then
        playerPos = playerVeh:getPosition()
    elseif core_camera and type(core_camera.getPosition) == "function" then
        playerPos = core_camera.getPosition()
    end
    
    -- Строгая защита от nil-координат камеры и игрока
    if not playerPos or type(playerPos) ~= "userdata" then return end

    -- Отрисовка 3D частиц
    if _G.CheatMenu_VirtSand_Enabled and _G.CheatMenu_VirtSand_Enabled[0] then
        local playerVeh = be:getPlayerVehicle(0)
        local vehId = playerVeh and playerVeh:getID()
        local vehState = vehId and _G.CheatMenuWindow_Data and _G.CheatMenuWindow_Data.vehicleStates and _G.CheatMenuWindow_Data.vehicleStates[vehId]
        local items = vehState and vehState.sandParticles
        
        if items and #items > 0 then
            local sc = _G.CheatMenu_Sand_Color
            local objectColor = ColorF(sc[0] or 0.9, sc[1] or 0.75, sc[2] or 0.3, 0.9)
            
            for i = 1, #items do
                local c = items[i]
                local pos = vec3(c.x, c.y, c.z)
                
                if c.shape == 0 then
                    -- 1. КУБЫ
                    local sz = (c.sz or 0.12) * 0.5
                    local minPt = (pos - vec3(sz, sz, sz)):toPoint3F()
                    local maxPt = (pos + vec3(sz, sz, sz)):toPoint3F()
                    debugDrawer:drawBox(minPt, maxPt, objectColor)
                    
                elseif c.shape == 1 then
                    -- 2. СФЕРЫ
                    debugDrawer:drawSphere(pos:toPoint3F(), (c.sz or 0.12) * 0.5, objectColor)
                    
                elseif c.shape == 2 then
                    -- 3. ПАЛОЧКИ / ЦИЛИНДРЫ
                    local dir = vec3(c.dirX or 0, c.dirY or 0, c.dirZ or 1):normalized()
                    local halfLen = (c.len or 0.6) * 0.5
                    local p1 = (pos - dir * halfLen):toPoint3F()
                    local p2 = (pos + dir * halfLen):toPoint3F()
                    debugDrawer:drawCylinder(p1, p2, (c.sz or 0.12) * 0.25, objectColor)
                end
            end
        end
    end

    -- 1. Отрисовка 3D виртуальной кучи песка из мелких квадратиков/кубиков
    if _G.CheatMenu_Sand_Enabled and _G.CheatMenu_Sand_Enabled[0] and _G.CheatMenu_Sand_Cubes and #_G.CheatMenu_Sand_Cubes > 0 then
        local sc = _G.CheatMenu_Sand_Color
        local sandColor = ColorF(sc[0] or 0.9, sc[1] or 0.75, sc[2] or 0.3, 0.9)
        
        for i = 1, #_G.CheatMenu_Sand_Cubes do
            local cube = _G.CheatMenu_Sand_Cubes[i]
            -- Принудительно передаем Point3F для гарантированной работы C++ графики
            debugDrawer:drawBox(cube.minPt:toPoint3F(), cube.maxPt:toPoint3F(), sandColor)
        end
    end

    -- 2. Отрисовка ESP-радара (выполняется только если включена галочка ESP)
    if not _G.CheatMenu_AllVehiclesESP then return end
    
    local playerVeh = be:getPlayerVehicle(0)
    local playerPos = playerVeh and playerVeh:getPosition() or core_camera.getPosition()
    
    -- Безопасное получение цвета линии из ImGui ArrayFloat
    local lCol = _G.CheatMenu_ESP_LineColor
    local lineColor = ColorF(lCol[0] or 0.2, lCol[1] or 1.0, lCol[2] or 0.2, lCol[3] or 1.0)
    
    -- Безопасное получение цвета текста (ColorF)
    local tCol = _G.CheatMenu_ESP_TextColor or {1.0, 1.0, 1.0, 1.0}
    local txtColor = ColorF(tCol[0] or 1.0, tCol[1] or 1.0, tCol[2] or 1.0, tCol[3] or 1.0)
    
    -- Безопасное получение и конвертация цвета фона (ColorI от 0 до 255)
    local bCol = _G.CheatMenu_ESP_BgColor or {0.0, 0.0, 0.0, 0.7}
    local bgColor = ColorI(
        math.floor((bCol[0] or 0.0) * 255),
        math.floor((bCol[1] or 0.0) * 255),
        math.floor((bCol[2] or 0.0) * 255),
        math.floor((bCol[3] or 0.7) * 255)
    )
    
    local maxDist = _G.CheatMenu_ESP_MaxDistance or 1000.0
    local drawLines = _G.CheatMenu_ESP_ShowLines and _G.CheatMenu_ESP_ShowLines[0]
    local drawText = _G.CheatMenu_ESP_ShowText and _G.CheatMenu_ESP_ShowText[0]
    local showModel = _G.CheatMenu_ESP_ShowModel and _G.CheatMenu_ESP_ShowModel[0]
    local showSpeed = _G.CheatMenu_ESP_ShowSpeed and _G.CheatMenu_ESP_ShowSpeed[0]
    local thickness = _G.CheatMenu_ESP_LineThickness or 1.0
    
    for i = 0, be:getObjectCount() - 1 do
        local obj = be:getObject(i)
        if obj and obj:getClassName() == "BeamNGVehicle" then
            local vehId = obj:getID()
            
            if not playerVeh or vehId ~= playerVeh:getID() then
                local pos = obj:getPosition()
                local dist = playerPos:distance(pos)
                
                if dist < maxDist then
                    -- Отрисовка лазерной линии
                    if drawLines then
                        if thickness > 1.0 then
                            local radius = 0.005 * thickness
                            debugDrawer:drawCylinder(playerPos:toPoint3F(), pos:toPoint3F(), radius, lineColor)
                        else
                            debugDrawer:drawLine(playerPos:toPoint3F(), pos:toPoint3F(), lineColor)
                        end
                    end
                    
                    -- Отрисовка текстовой таблицы данных
                    if drawText then
                        local labelPos = vec3(pos.x, pos.y, pos.z + 1.8):toPoint3F()
                        
                        local titleStr = string.format("[%d]", vehId)
                        if showModel then
                            titleStr = titleStr .. " " .. (obj.JBeam or "Vehicle")
                        end
                        
                        local infoStr = string.format("Dist: %d m", math.floor(dist))
                        if showSpeed then
                            local speedKMH = obj:getVelocity():length() * 3.6
                            infoStr = infoStr .. string.format(" | Speed: %d km/h", math.floor(speedKMH))
                        end
                        
                        local labelText = titleStr .. "\n" .. infoStr
                        debugDrawer:drawTextAdvanced(labelPos, labelText, txtColor, true, false, bgColor)
                    end
                end
            end
        end
    end
end

-- Автоматическая очистка кэша графика при респавне автомобиля (Ctrl+R / Восстановление)
local _driveCheatReapplyCooldown = {}

local function onVehicleResetted(vid)
    if _G.CheatMenuWindow_Data and _G.CheatMenuWindow_Data.torqueCurve then
        _G.CheatMenuWindow_Data.torqueCurve[vid] = nil
    end

    if _G.CheatMenu_DrivePresetSuppressResetHook then
        _G.CheatMenu_DrivePresetSuppressResetHook = false
    elseif _G.CheatMenu_DriveCheatEnabled and cheatMenuIsMyVehicle(nil, vid) then
        local now = os.clock()
        local last = _driveCheatReapplyCooldown[vid] or 0
        if (now - last) > 10.0 then
            _driveCheatReapplyCooldown[vid] = now
            scheduleDriveCheatApply(vid, 2.5, { softReapply = true })
        end
    end

    -- Добавьте этот блок восстановления прочности при респавне:
    if _G.CheatMenu_Freeze_globalStrengthMult and _G.CheatMenu_Freeze_globalStrengthMult[0] then
        local targetVeh = be:getObjectByID(vid) or be:getPlayerVehicle(0)
        if targetVeh then
            local val = getPtr(vid, "globalStrengthMult", 1.0, "FloatPtr")[0]
            targetVeh:queueLuaCommand(string.format("if CheatMenuM and CheatMenuM.applyGlobalBeamStrengthMult then CheatMenuM.applyGlobalBeamStrengthMult(%f) end", val))
        end
    end

    -- Если включена галочка, при респавне машины убираем старые осколки с земли
    if _G.CheatMenu_InfiniteDebris and _G.CheatMenu_InfiniteDebris[0] then
        if Engine and Engine.Render and Engine.Render.clearDecals then
            Engine.Render.clearDecals()
        end
    end
end

-- Автоматическая очистка кэша графика при пересадке между машинами
local function onVehicleSwitched(oldId, newId, player)
    if player == 0 then -- 0 обозначает текущего игрока
        if _G.CheatMenuWindow_Data and _G.CheatMenuWindow_Data.torqueCurve then
            _G.CheatMenuWindow_Data.torqueCurve[oldId] = nil
            _G.CheatMenuWindow_Data.torqueCurve[newId] = nil
        end
    end
end

local function onVehicleDestroyed(vid)
    -- Действие при уничтожении машины (можно очистить кэш телеметрии этого ID)
    if _G.CheatMenu_VehTelemetry then
        _G.CheatMenu_VehTelemetry[vid] = nil
    end
end

-- Регистрация функции настройки темы в глобальном редакторе, если он инициализирован
if editor then
    editor.setupEditorGuiTheme = setupEditorGuiTheme
end

-- Регистрируем новые системные хуки
M.onVehicleDestroyed = onVehicleDestroyed

-- Регистрируем функции в системных хуках игры
M.onVehicleResetted = onVehicleResetted
M.onVehicleSwitched = onVehicleSwitched


-- СОХРАНЕНИЕ БЕЗОПАСНЫХ КООРДИНАТ (5 СЕК) И ВОССТАНОВЛЕНИЕ ПРИ НЕСТАБИЛЬНОСТИ
local instabilityCooldownTime = 0
local fallWatchTimer = 0.0
local speedRecoveryCooldown = 0.0
local recoverBusyUntil = 0
local motionStopCooldownByVid = {}

local function cheatMenuSafeSpeed(vel)
    if not vel then return 0 end
    local s = vel:length()
    if s ~= s or s == math.huge then return 0 end
    return s
end

local function cheatMenuSafeVehicleQuat(veh)
    if not veh then return quat(0, 0, 0, -1) end
    local vel = veh:getVelocity()
    if vel then
        local vx, vy, vz = vel.x, vel.y, vel.z
        if vx ~= vx or vy ~= vy or vz ~= vz or cheatMenuSafeSpeed(vel) > 250 then
            return quat(0, 0, 0, -1)
        end
    end
    local dv = veh:getDirectionVector()
    local du = veh:getDirectionVectorUp()
    if dv and du and dv:length() > 1e-4 then
        return quatFromDir(dv, du)
    end
    return quat(0, 0, 0, -1)
end

if _G.CheatMenu_LastValidPos == nil then _G.CheatMenu_LastValidPos = {} end
if _G.CheatMenu_PosSaveTimer == nil then _G.CheatMenu_PosSaveTimer = 0.0 end
if _G.CheatMenu_RecoveryActive == nil then _G.CheatMenu_RecoveryActive = false end

local function cheatMenuClearDelayedInstabilityTeleport()
    _G.CheatMenu_InstabilityHomeDelay = 0
    _G.CheatMenu_InstabilityTargetVid = 0
    _G.CheatMenu_TargetRespawnPos = false
end

local function cheatMenuStopVehicleMotionGE(veh)
    if not veh then return end
    local vid = veh:getID()
    local now = os.clock()
    if (motionStopCooldownByVid[vid] or 0) > now - 0.5 then return end
    motionStopCooldownByVid[vid] = now

    if veh.applyClusterVelocityScaleAdd then
        local ref = veh:getRefNodeId()
        if ref then
            veh:applyClusterVelocityScaleAdd(ref, 0, 0, 0, 0)
        end
    end
    veh:queueLuaCommand([[
      if CheatMenuM and CheatMenuM.hardStopVehiclePhysics then CheatMenuM.hardStopVehiclePhysics() end
    ]])
end

local function cheatMenuRecoverVehiclePosition(veh, vehId)
    if not veh then return end
    if _G.CheatMenu_RecoveryActive then return end
    local now = os.clock()
    if now < recoverBusyUntil then return end
    recoverBusyUntil = now + 1.25

    cheatMenuClearDelayedInstabilityTeleport()

    local pos = veh:getPosition()
    local vel = veh:getVelocity()
    local speed = cheatMenuSafeSpeed(vel)
    local savedPos = vehId and _G.CheatMenu_LastValidPos[vehId]
    local badPos = not pos or pos.z ~= pos.z or pos.z < 8.0
    local drivePresetOn = _G.CheatMenu_DriveCheatEnabled == true
    local insaneSpeed = drivePresetOn and (speed > 420.0) or (speed > 90.0)

    local targetPos = nil
    if drivePresetOn then
        if badPos and savedPos then
            targetPos = savedPos
        elseif not badPos then
            targetPos = vec3(pos)
        elseif savedPos then
            targetPos = savedPos
        end
    elseif (badPos or insaneSpeed) and savedPos then
        targetPos = savedPos
    elseif not badPos then
        targetPos = vec3(pos)
    elseif savedPos then
        targetPos = savedPos
    end

    if targetPos and spawn and type(spawn.safeTeleport) == "function" then
        local rot = cheatMenuSafeVehicleQuat(veh)
        spawn.safeTeleport(veh, targetPos, rot, nil, nil, nil, nil, true)
    elseif veh then
        veh:queueLuaCommand("if recovery and recovery.recoverInPlace then recovery.recoverInPlace() end")
    end

    cheatMenuStopVehicleMotionGE(veh)
end

function M.onInstabilityDetected(vehId, returnData)
    if not _G.CheatMenu_EnableInstabilityProtection or not _G.CheatMenu_EnableInstabilityProtection[0] then
        return
    end
    if _G.CheatMenu_RecoveryActive then
        if returnData then returnData.instabilityHandled = false end
        return
    end

    local playerVeh = be:getPlayerVehicle(0)
    if not playerVeh or playerVeh:getID() ~= vehId then
        return
    end

    local now = os.clock()
    if (now - instabilityCooldownTime) < 5.0 then
        if returnData then returnData.instabilityHandled = true end
        return
    end
    instabilityCooldownTime = now
    speedRecoveryCooldown = 3.0

    if returnData then returnData.instabilityHandled = true end

    _G.CheatMenu_InstabilityAlertTimer = 4.0
    log('W', 'CheatMenu', 'Instability intercepted on vehicle ID: ' .. tostring(vehId))

    cheatMenuRecoverVehiclePosition(playerVeh, vehId)

    local drivePresetOn = _G.CheatMenu_DriveCheatEnabled == true
    if drivePresetOn then
        if guihooks and guihooks.message then
            guihooks.message("Instabilité — récupération (preset inchangé, vitesse à 0)", 3, "instability_alert")
        end
    else
        if guihooks and guihooks.message then
            guihooks.message("INSTABILITY — cheats reset 1.0x + reload", 5, "instability_alert")
        end
        playerVeh:queueLuaCommand("if CheatMenuM then CheatMenuM.resetCheats() end")
        if core_vehicle_partmgmt then
            core_vehicle_partmgmt.setConfig({carscaler = {}, partscaler = {}, partmover = {}}, true)
        end
        be:reloadVehicle(vehId)
        be:reloadCollision()
        if _G.CheatMenu_InstabilityAutoRepair and _G.CheatMenu_InstabilityAutoRepair[0] then
            _G.CheatMenu_InstabilityHomeDelay = 5
            _G.CheatMenu_InstabilityTargetVid = vehId
            _G.CheatMenu_TargetRespawnPos = _G.CheatMenu_LastValidPos[vehId]
        end
    end

    if core_camera and type(core_camera.resetCamera) == "function" then
        core_camera.resetCamera(0)
    end
end

-- Обработка сохранения координат и отложенного восстановления
local origOnUpdate = M.onUpdate
M.onUpdate = function(dtReal, dtSim, dtRaw)
    if type(origOnUpdate) == "function" then 
        origOnUpdate(dtReal, dtSim, dtRaw) 
    end

    pollDriveCheatHotkey()
    processDriveCheatPendingApply()

    -- 1. ЦИКЛ СОХРАНЕНИЯ БЕЗОПАСНЫХ КООРДИНАТ ТЕКУЩЕГО АВТО (КАЖДЫЕ 5 СЕК)
    local playerVeh = be:getPlayerVehicle(0)
    if playerVeh then
        local vid = playerVeh:getID()
        local pos = playerVeh:getPosition()
        local vel = playerVeh:getVelocity()

        -- Сразу запоминаем стартовые координаты при появлении авто
        if pos and pos.z and pos.z > 12.0 and pos.z == pos.z and not _G.CheatMenu_LastValidPos[vid] then
            _G.CheatMenu_LastValidPos[vid] = vec3(pos.x, pos.y, pos.z + 0.35)
        end

        _G.CheatMenu_PosSaveTimer = (_G.CheatMenu_PosSaveTimer or 0.0) + (dtReal or 0.016)
        if _G.CheatMenu_PosSaveTimer >= 4.0 then
            _G.CheatMenu_PosSaveTimer = 0.0
            local speed = vel and vel:length() or 999
            if pos and pos.z and pos.z > 12.0 and pos.z == pos.z and speed < 35.0 then
                _G.CheatMenu_LastValidPos[vid] = vec3(pos.x, pos.y, pos.z + 0.35)
            end
        end

        if speedRecoveryCooldown > 0 then
            speedRecoveryCooldown = speedRecoveryCooldown - (dtReal or 0.016)
        end

        if not _G.CheatMenu_RecoveryActive
            and _G.CheatMenu_EnableInstabilityProtection and _G.CheatMenu_EnableInstabilityProtection[0] then
            local speed = cheatMenuSafeSpeed(vel)
            local speedLimit = (_G.CheatMenu_DriveCheatEnabled == true) and 450.0 or 220.0
            if speedRecoveryCooldown <= 0 and speed > speedLimit and _G.CheatMenu_LastValidPos[vid]
                and _G.CheatMenu_DriveCheatEnabled ~= true then
                log('W', 'CheatMenu', string.format('Speed guard: %.0f m/s — stop + safe TP', speed))
                speedRecoveryCooldown = 4.0
                instabilityCooldownTime = os.clock()
                cheatMenuRecoverVehiclePosition(playerVeh, vid)
            end

            fallWatchTimer = fallWatchTimer + (dtReal or 0.016)
            if fallWatchTimer >= 0.5 then
                fallWatchTimer = 0
                if pos and pos.z and pos.z < -8.0 then
                    log('W', 'CheatMenu', 'Fall-through guard: vehicle below map, recovering')
                    speedRecoveryCooldown = 4.0
                    cheatMenuRecoverVehiclePosition(playerVeh, vid)
                end
            end
        end
    end

    -- 3. ВЫПОЛНЕНИЕ ТЕЛЕПОРТАЦИИ (sans preset F9 : ancien reload seulement)
    if _G.CheatMenu_InstabilityHomeDelay and _G.CheatMenu_InstabilityHomeDelay > 0
        and not _G.CheatMenu_DriveCheatEnabled then
        _G.CheatMenu_InstabilityHomeDelay = _G.CheatMenu_InstabilityHomeDelay - 1
        if _G.CheatMenu_InstabilityHomeDelay <= 0 then
            local vid = _G.CheatMenu_InstabilityTargetVid or (playerVeh and playerVeh:getID())
            local savedPos = _G.CheatMenu_TargetRespawnPos

            if playerVeh and savedPos then
                if spawn and type(spawn.safeTeleport) == "function" then
                    spawn.safeTeleport(playerVeh, savedPos)
                else
                    playerVeh:setPosition(savedPos)
                end
                cheatMenuStopVehicleMotionGE(playerVeh)
            elseif playerVeh then
                playerVeh:queueLuaCommand("recovery.recoverInPlace()")
            end

            -- Восстанавливаем камеру
            if core_camera then
                if type(core_camera.resetCamera) == "function" then
                    core_camera.resetCamera(0)
                end
                if type(core_camera.setVehicle) == "function" and playerVeh then
                    core_camera.setVehicle(playerVeh)
                end
            end
        end
    end
end

_G.onInstabilityDetected = M.onInstabilityDetected
M.onInstabilityDetected = M.onInstabilityDetected

function M.onStartRecovering()
    _G.CheatMenu_RecoveryActive = true
    _G.CheatMenu_DrivePresetSuppressResetHook = true
end

function M.onStopRecovering(recoverTimer)
    _G.CheatMenu_RecoveryActive = false
    local playerVeh = be:getPlayerVehicle(0)
    if playerVeh then
        local vid = playerVeh:getID()
        local p = playerVeh:getPosition()
        if p and p.z == p.z and p.z > -50 then
            _G.CheatMenu_LastValidPos[vid] = vec3(p.x, p.y, p.z + 0.35)
        end
        cheatMenuStopVehicleMotionGE(playerVeh)
    end
    speedRecoveryCooldown = 2.5
end



M.dependencies = {"ui_imgui"}

-- ============================================================
-- API PRESETS (appelée depuis vehicle lua via queueGameEngineLua)
-- ============================================================
local function getSlots()
    local data = loadPresets()
    if not data.slots then data.slots = {} end
    return data.slots
end

local function pushSlotInfoToVehicle(vehId)
    local slots = getSlots()
    -- Construit une table index -> {name} pour que vehicle lua puisse lire
    local info = {}
    for i = 1, NUM_PRESET_SLOTS do
        local s = slots[i]
        info[i] = { name = (s and s._name) or "" }
    end
    local encoded = jsonEncode(info)
    local v = be:getObjectByID(vehId)
    if v then
        v:queueLuaCommand(string.format(
            "_G.CheatMenu_PresetSlotsInfo = jsonDecode([===[%s]===])", encoded))
    end
end

function M.savePresetSlot(slotIdx, stateJson)
    local slots = getSlots()
    local stateData = jsonDecode(stateJson) or {}

    -- Génère un nom automatique descriptif basé sur les valeurs non-stock
    local parts = {}
    local labels = {
        powerMultiplier = "Power",
        gripMultiplier  = "Grip",
        brakeMultiplier = "Brake",
        gravityMultiplier = "Grav",
        massMultiplier  = "Mass",
        gearMultiplier  = "Gear",
        invulnerableMultiplier = "God",
    }
    for key, label in pairs(labels) do
        local v = stateData[key]
        if v and math.abs(v - 1.0) > 0.01 then
            table.insert(parts, label .. " x" .. string.format("%g", v))
        end
    end
    local autoName = #parts > 0 and table.concat(parts, " | ") or ("Slot " .. slotIdx)

    stateData._name = autoName
    stateData._date = os.date("%d/%m %H:%M")
    slots[slotIdx] = stateData
    _presets.slots = slots
    savePresetsFile()

    -- Met à jour tous les véhicules du joueur
    local pv = be:getPlayerVehicle(0)
    if pv then pushSlotInfoToVehicle(pv:getID()) end
end

function M.loadPresetSlot(slotIdx, vehId)
    local slots = getSlots()
    local slot = slots[slotIdx]
    if not slot then return end

    local v = be:getObjectByID(vehId)
    if not v then return end

    -- Applique chaque valeur connue
    local fnMap = {
        powerMultiplier     = "applyPowerMultiplier",
        gripMultiplier      = "applyGripMultiplier",
        brakeMultiplier     = "applyBrakeMultiplier",
        gravityMultiplier   = "applyGravityMultiplier",
        massMultiplier      = "applyWeightMultiplier",
        engineBrakeMultiplier = "applyEngineBrakeMult",
        dragMultiplier      = "applyAirDragMult",
        gearMultiplier      = "applyGearingMultiplier",
        rpmMultiplier       = "applyRPMMultiplier",
        invulnerableMultiplier = "applyGlobalBeamStrengthMult",
        jatoMultiplier      = "applyJatoMultiplier",
        timeScale           = "applyTimeScale",
        suspensionHeightMultiplier = "applySuspensionHeight",
    }
    for key, fn in pairs(fnMap) do
        local val = slot[key]
        if val then
            v:queueLuaCommand(string.format(
                "state.%s = %f; if CheatMenuM and CheatMenuM.%s then CheatMenuM.%s(%f) end",
                key, val, fn, fn, val))
        end
    end
end

function M.clearPresetSlot(slotIdx)
    local slots = getSlots()
    slots[slotIdx] = nil
    _presets.slots = slots
    savePresetsFile()
    local pv = be:getPlayerVehicle(0)
    if pv then pushSlotInfoToVehicle(pv:getID()) end
end

-- Envoie les infos de slots au véhicule dès qu'il spawne
local _origOnVehicleLoaded = M.onVehicleLoaded
function M.onVehicleLoaded(vehId)
    if _origOnVehicleLoaded then _origOnVehicleLoaded(vehId) end
    if cheatMenuIsMyVehicle(nil, vehId) then
        pushSlotInfoToVehicle(vehId or 0)
        if _G.CheatMenu_DriveCheatEnabled then
            scheduleDriveCheatApply(vehId, 0.75, { freshSpawn = true })
        end
    end
end
-- ============================================================

return M