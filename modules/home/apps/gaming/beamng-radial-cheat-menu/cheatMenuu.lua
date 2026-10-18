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
    _G.CheatMenu_Ai_CustomCmd = im.ArrayChar(256, "if ai then ai.setMode('manual') ai.setTarget('wpTargetName') end") 
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
      brakeMultiplier = 14,
      massMultiplier = 0.93,
      stickyGrip = true,
      stickyGripForce = 0.48,
      disableTireTreadMorph = true,
      engineBrakeMultiplier = 1.12,
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
    hint = "ETK: x9, grip 1.95, freins x14, rapports longs, anti-burn + sticky",
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

  if im.BeginTabBar("CheatMenuCleanTabs") then
    if im.BeginTabItem("Principal") then
      im.Spacing()
      
      -- État du véhicule
      im.Text("Véhicule : ")
      im.SameLine()
      if modelKey == "?" or not modelKey or modelKey == "" then
        im.TextColored(im.ImVec4(1.0, 0.25, 0.25, 1.0), "Aucun véhicule détecté")
      elseif preset then
        im.TextColored(im.ImVec4(0.25, 1.0, 0.35, 1.0), string.format("%s (%s)", preset.label, modelKey))
      else
        im.TextColored(im.ImVec4(1.0, 0.45, 0.25, 1.0), string.format("%s (aucun preset dédié)", modelKey))
      end

      im.Spacing()
      im.Separator()
      im.Spacing()

      -- Case à cocher Preset
      local isEnabled = _G.CheatMenu_DriveCheatEnabled == true
      if im.Checkbox("Activer le preset de conduite (F9)##drive_preset_enable", enabledPtr) then
        if enabledPtr[0] ~= isEnabled then
          M.toggleDriveCheatPreset()
        end
      end

      im.SameLine()
      if isEnabled then
        im.TextColored(im.ImVec4(0.25, 1.0, 0.35, 1.0), "[ACTIF]")
      else
        im.TextColored(im.ImVec4(0.7, 0.7, 0.7, 1.0), "[INACTIF]")
      end

      -- Diagnostic & Statut Moteur en direct si actif
      if preset then
        im.Spacing()
        local vs = _G.CheatMenuWindow_Data and _G.CheatMenuWindow_Data.vehicleStates
            and _G.CheatMenuWindow_Data.vehicleStates[vehId]
        if vs and isEnabled then
          local pwr = vs.powerMultiplier or 1
          local rpm = vs.rpmMultiplier or 1
          local motorOk = drivePresetMotorMatches(preset, vs)
          if motorOk then
            im.TextColored(im.ImVec4(0.25, 1.0, 0.35, 1.0), "● Preset moteur appliqué avec succès")
          else
            im.TextColored(im.ImVec4(1.0, 0.75, 0.25, 1.0), "▲ En attente d'application moteur... (Respawn ou F9 OFF/ON)")
          end
          im.TextDisabled(string.format("  Puissance: x%.1f | Régime: x%.1f RPM", pwr, rpm))
        end
        if preset.hint then
          im.Spacing()
          im.TextDisabled(preset.hint)
        end
      else
        im.Spacing()
        im.TextColored(im.ImVec4(1.0, 0.75, 0.25, 1.0), "Note: Un preset générique sera appliqué si activé.")
      end

      im.Spacing()
      im.EndTabItem()
    end
    im.EndTabBar()
  end
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
        local buf = im.ArrayChar(128, tostring(defaultVal or ""))
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
        im.Begin("Cheat Menu", open, windowFlags)
        im.TextColored(im.ImVec4(1.0, 0.25, 0.25, 1.0), "Erreur : Aucun vehicule actif detecte")
        im.End()
        popThemeColors()
        return
    end
    
    pushThemeColors(_G.CheatMenu_GuiStyleIdx)
    im.SetNextWindowSizeConstraints(im.ImVec2(380, 220), im.ImVec2(600, 450))
    im.Begin("Cheat Menu", open, windowFlags)



    


    
    
    local vehId = v:getID()
    local vehState = _G.CheatMenuWindow_Data.vehicleStates[vehId]
    if not vehState then
        im.TextColored(im.ImVec4(1.0, 0.75, 0.25, 1.0), "Connexion au vehicule en cours...")
        im.TextDisabled("Verifiez que le vehicule est pret.")
        if im.Button("Forcer la connexion") then
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
        _G.CheatMenu_OBD_Port = im.ArrayChar(16, "com12")
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
    renderDriveCheatBar(v, vehId)

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

-- Envoie les infos de slots au véhicule dès qu'il spawne et charge l'extension véhicule
local _origOnVehicleLoaded = M.onVehicleLoaded
function M.onVehicleLoaded(vehId)
    if _origOnVehicleLoaded then _origOnVehicleLoaded(vehId) end
    local v = be:getPlayerVehicle(0)
    if v then
        v:queueLuaCommand("if not extensions.codeCheatMenu then extensions.load('codeCheatMenu') end")
    end
    if cheatMenuIsMyVehicle(nil, vehId) then
        pushSlotInfoToVehicle(vehId or 0)
        if _G.CheatMenu_DriveCheatEnabled then
            scheduleDriveCheatApply(vehId, 0.75, { freshSpawn = true })
        end
    end
end
-- ============================================================

return M