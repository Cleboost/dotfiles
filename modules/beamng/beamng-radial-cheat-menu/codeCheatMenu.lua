-- BeamNG.drive\lua\vehicle\extensions\auto\codeCheatMenu.lua (RADIAL MENU)
log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = starting... ==========')

local M = {}
M.dependencies = {"core_quickAccess"}
-- mod page: https://www.beamng.com/resources/radial-cheat-menu.37823/
-- mod page: https://www.beamng.com/resources/radial-cheat-menu.37823/
local CHEAT = {
  ROOT = "/root/playerVehicle/cheats/",
  POWER = "/root/playerVehicle/cheats/power/",
  GRIP = "/root/playerVehicle/cheats/grip/",
  GRAVITY = "/root/playerVehicle/cheats/gravity/",
  BRAKES = "/root/playerVehicle/cheats/brakes/",
  MASS = "/root/playerVehicle/cheats/mass/",
  ENG_BRAKE = "/root/playerVehicle/cheats/engbrake/",
  DRAG = "/root/playerVehicle/cheats/drag/",
  GEAR = "/root/playerVehicle/cheats/gears/",
  TIMESCALE = "/root/playerVehicle/cheats/timescale/",
  INVULN = "/root/playerVehicle/cheats/invulnerable/",
  JATO = "/root/playerVehicle/cheats/jato/",
  RPM = "/root/playerVehicle/cheats/rpm/",
  WHEEL_SIZE = "/root/playerVehicle/cheats/wheelsize/",
  WHEEL_WIDTH = "/root/playerVehicle/cheats/wheelwidth/",
  CAR_SCALE = "/root/playerVehicle/cheats/carscale/",
  SUSP = "/root/playerVehicle/cheats/suspension/",
  CAREER = "/root/playerVehicle/cheats/career/",
  CAREER_STATS = "/root/playerVehicle/cheats/career/stats/",
  VISUALS = "/root/playerVehicle/cheats/visuals/",
  DEBRIS = "/root/playerVehicle/cheats/visuals/debris/",
  SHADOW = "/root/playerVehicle/cheats/visuals/ShadowQuality/",
}

local PRESET = {
  POWER = {1, 1.1, 1.2, 1.3, 1.5, 1.7, 2, 2.5, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30, 40, 50, 60, 70, 80, 90, 100, 150, 300, 500, 750, 1000, 100000},
  GRIP = {-10, -5, -1, 0, 0.1, 0.3, 0.5, 0.7, 1, 1.1, 1.2, 1.3, 1.5, 1.7, 2, 2.5, 3, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 75, 100, 500, 5000, 100000, 1e30},
  GRAVITY = {-3000, -1000, -500, -300, -200, -100, -10, -1, 0, 0.1, 0.3, 0.5, 0.7, 1, 1.1, 1.2, 1.3, 1.5, 1.7, 2, 2.5, 3, 5, 10, 100, 500, 1000, 3000},
  BRAKE = {-10, -5, -1, 0, 0.5, 1, 1.1, 1.2, 1.3, 1.5, 1.7, 2, 3, 5, 7, 10, 25, 50, 75, 100, 1000, 10000},
  MASS = {0.75, 0.8, 0.85, 0.9, 0.95, 1, 1.5, 2, 3, 5, 10, 20, 30, 40, 50, 75, 100, 300, 500, 1000, 10000},
  ENG_BRAKE = {-10, -7, -5, -3, -1, 0, 1, 1.1, 1.2, 1.3, 1.5, 1.7, 2, 3, 5, 10, 50, 100},
  DRAG = {0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 1, 1.1, 1.2, 1.3, 1.5, 1.7, 2, 3, 5, 10, 50},
  GEAR = {0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 1, 1.2, 1.5, 2, 3, 5, 10, 25, 50, 75, 100, 300, 500, 1000},
  TIMESCALE = {0.001, 0.01, 0.1, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10},
  INVULN = {0, 0.01, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.5, 2, 3, 5, 7, 10, 25, 50, 100, 1000, 10000, 100000, 1e10, 1e30, 1e90},
  SHADOW = {0.1, 0.2, 0.5, 1, 2},
  JATO = {1, 3, 5, 7, 10, 12, 15, 20, 30, 40, 50, 60, 70, 80, 90, 100, 125, 150, 175, 200, 250, 300, 400, 500, 650, 800, 1150, 1500, 10000, 50000, 100000},
  DEBRIS = {1, 2, 3, 10, 25, 50, 100, 250, 500, 750, 1500, 10000, 900000},
  RPM = {0, 0.3, 0.5, 0.7, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 3, 4, 5, 7, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 150, 500, 750, 1000, 1250, 1500, 3000, 5000, 10000},
  CAR_SCALE = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 10, 15, 20, 30, 40, 50, 75, 100, 200, 300, 500, 1000, 10000, 100000},
  SUSP = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 10, 15, 20, 30, 40, 50},
}





local PS_TO_WATT = 735.499
local INVULNERABLE_BEAM_LIMIT = 1e10
local WHEEL_STIFFNESS_LIMIT = 1e5    -- Для колес (прочно, но гибко)

-- Внутренние переменные динамического морфинга подвески
local suspensionBeams = {}
local currentSuspensionHeight = 1.0
local isSuspensionMorphingActive = false

-- Внутренние переменные динамического морфинга колес
local baseInches = 21 -- Определится автоматически при спавне
local currentScaleRatio = 1.0
local currentWidthScale = 1.0
local isMorphingActive = false

local beamLFin = true
local beamWFin = true

local hubBeamTable = {}
local tyreTreadTable = {}
local wheelTreadTable = {}
local rimBeamLength = {}
local rimBeamLengthS = {}
local rimBeamPeri = {}
local rimSideR = {}

local vectorForward = nil
local vectorUp = nil
local vectorRight = nil

local tempVec = nil
local tempVec2 = nil



-- Внутренние переменные динамического морфинга автомобиля
local currentCarScale = 1.0
local isCarMorphingActive = false
local wheelBeamsSet = {} -- Таблица для исключения балок колес из общего масштабирования


local state = {
  underwaterMode = false,
  indestructibleEngine = false,
  freezeThermals = false,
  infiniteFuel = false,
  infiniteN2O = false,
  infiniteJato = false,
  awdMode = false,
  rainbowMode = false,
  espMode2 = false,
  carScaleMultiplier = 1.0, -- Значение по умолчанию
  carLengthMultiplier = 1.0,      -- Добавлено: масштаб длины машины (Y)
  carWidthMultiplier = 1.0,       -- Инициализация масштаба ширины (X)
  carThicknessMultiplier = 1.0,   -- Инициализация масштаба высоты (Z)
  followGPSMode = false,          -- Добавлено: режим следования по GPS
  invulnerableMultiplier = 1,
  shadowMultiplier = 1,
  powerMultiplier = 1,
  gripMultiplier = 1,
  gravityMultiplier = 1,
  brakeMultiplier = 1,
  massMultiplier = 1,
  engineBrakeMultiplier = 1,
  dragMultiplier = 1,
  gearMultiplier = 1,
  timeScale = 1,
  jatoMultiplier = 1,
  dynamicRain = false,
  dynamicSnow = false,
  debrisMultiplier = 1,
  rpmMultiplier = 1,
  drivePresetActive = false,
  drivePresetTorqueProfile = nil,
  drivePresetStabilityAssist = false,
  superTires = false,
  suspensionHeightMultiplier = 1.0,
  camberOffset = 0.0,
  wheelOffset = 0.0,
  suspensionSpringMultiplier = 1.0,
  suspensionDampMultiplier = 1.0,
  tireStiffnessMult = 1.0,
  tireDampMult = 1.0,
  tireFrictionMult = 1.0,
  tireSlidingMult = 1.0,

  tireRadiusMult = 1.0,
  tireWidthMult = 1.0,
  
  tireSideSpring = 1.0,
  tireSideDamp = 1.0,
  tireSideExpSpring = 1.0,
  tireSideExpDamp = 1.0,
  tireSidePre = 1.0,
  tireSideDeform = 1.0,
  tireSideStrength = 1.0,
  
  tireReinfSpring = 1.0,
  tireReinfDamp = 1.0,
  tireReinfPre = 1.0,
  
  tireTreadSpring = 1.0,
  tireTreadDamp = 1.0,
  tireTreadPre = 1.0,
  tireTreadDeform = 1.0,
  tireTreadStrength = 1.0,
  
  tireTreadReinfSpring = 1.0,
  tireTreadReinfDamp = 1.0,
  tireTreadReinfPre = 1.0,
  
  tirePeriSpring = 1.0,
  tirePeriDamp = 1.0,
  tirePeriPre = 1.0,
  tirePeriDeform = 1.0,
  tirePeriStrength = 1.0,
  
  tirePeriReinfSpring = 1.0,
  tirePeriReinfDamp = 1.0,
  tirePeriReinfPre = 1.0,
  
  tireNodeWeight = 1.0,
  tireFriction = 1.0,
  tireSliding = 1.0,
  pedalThrustForce = 0.0,
  pedalBrakeForce = 0.0,
  thrustX = 0.0,
  thrustY = 0.0,
  thrustZ = 0.0,
  stickyGrip = false,
  stickyGripForce = 0.2,

  flyMode = false,
  flyHover = true,
  flySpeed = 15.0,
  flyPitch = 0.0,
  flyYaw = 0.0,
  flyRoll = 0.0,
  globalStrengthMult = 1.0,
  partStrengthMults = {}
}
local tireBeams = {}

local activeFlags = {
  invulnerable = false,
  power = false,
  grip = false,
  gravity = false,
  brakes = false,
  mass = false,
  engineBrake = false,
  environment = false,
  gearing = false,
  rpm = false,
  superTires = false,
  awdMode = false
}

local menuRegistered = false
local pendingReapplyFrames = 0
local needsPowerBaseRefresh = true

local rainCooldown = 0
local rainNextToggle = math.random(5000, 6000)
local rainActive = false

local snowCooldown = 0
local snowNextToggle = math.random(5000, 6000)
local snowActive = false

-- ПЕРЕМЕННЫЕ РЕГЕНЕРАТОРА
local regenEnabled = false
local regenRate = 0.05 -- (Увеличил с 0.025 до 0.05 для чуть более быстрой починки, можешь вернуть если хочешь)
local repairErrorMargin = 0.0015
local regenTime = 0
local regenBeamStates = {}
local regenBeamCache = {}
local regenProgress = 0
local regenCancelled = false

-- Базовые данные
local powerBaseData = {}
local wheelGripBaseData = {}
local wheelBurstBaseData = {}
local transmissionBaseData = {}
local wheelBrakeBaseData = {}
local nodeMassBaseData = {}
local beamBaseData = {}
local diffBaseData = {}
local gearingBaseData = {}
local torsionBaseData = {}
local gravityBaseValue = nil
local vehicleControllerBaseData = {
  captured = false,
  topSpeedLimit = nil,
  topSpeedLimitReverse = nil
}
local originalGuihooksMessage = nil


-- Сверхстрогий фильтр только для одной главной детали (несущего кузова)
local function isBodyNode(node)
  if not node then return false end

  -- Метод 1: Строгая проверка по имени JBeam-детали (только кузов и кабина)
  local part = (node.partPath or node.partOrigin or ""):lower()
  if part ~= "" then
    -- Пропускаем ТОЛЬКО основную несущую деталь кузова/кабины. 
    -- Рама (frame) и шасси (chassis) исключены.
    if part:match("_body$") or part == "body" or
       part:match("_cab$") or part == "cab" then
      
      -- На всякий случай отсекаем узлы подвески, если они объявлены в этом же JBeam
      local name = (node.name or ""):lower()
      if name:match("^fx") or name:match("^rx") or name:match("^fh") or name:match("^rh") or name:match("^wh") then
        return false
      end
      return true
    end
  end

  -- Метод 2: Строгий fallback по имени узла (только силовые узлы кузова "b")
  local name = (node.name or ""):lower()
  if name ~= "" then
    -- b%d — основные узлы несущего кузова (body).
    -- f%d (узлы рамы) исключены.
    if name:match("^b%d") then
      -- Исключаем элементы подвески (fx/rx, fh/rh)
      if not (name:match("^fx") or name:match("^rx") or name:match("^fh") or name:match("^rh")) then
        return true
      end
    end
  end

  return false
end

local function cacheSuspensionBeams()
  suspensionBeams = {}
  if not v or not v.data or not v.data.beams then return end
  for cid, beam in pairs(v.data.beams) do
    if type(cid) == "number" then
      local part = (beam.partOrigin or ""):lower()
      -- Ищем только упругие элементы (пружины, стойки, амортизаторы)
      if part:find("coilover") or part:find("spring") or part:find("shock") or part:find("strut") then
        -- Строго исключаем рычаги, рулевые тяги и стабилизаторы поперечной устойчивости
        if not part:find("arm") and 
           not part:find("wishbone") and 
           not part:find("link") and 
           not part:find("swaybar") and 
           not part:find("steering") then
          -- Сохраняем исходные параметры упругости
          suspensionBeams[cid] = {
            beamSpring = beam.beamSpring or 0,
            beamDamp = beam.beamDamp or 0,
            springExpansion = beam.springExpansion or -1,
            dampExpansion = beam.dampExpansion or -1
          }
        end
      end
    end
  end
end



-- ОПТИМИЗИРОВАННЫЙ МОДУЛЬ ФИЗИКИ (С НУЛЕВЫМ РАСХОДОМ ЛОКАЛЬНЫХ ПЕРЕМЕННЫХ)

M.sandParticles = {}
M.surfaceNodesCache = nil

M.spawnParticles = function(jsonStr)
  local data = jsonDecode(jsonStr)
  M.sandParticles = data or {}
end

M.setVirtualBricks = M.spawnParticles

-- Кэширование внешних верхних нод кузова
M.getSurfaceNodes = function()
  if M.surfaceNodesCache then return M.surfaceNodesCache end
  M.surfaceNodesCache = {}
  if not v or not v.data or not v.data.nodes then return M.surfaceNodesCache end

  local minZ, maxZ = 1000, -1000
  for cid, n in pairs(v.data.nodes) do
    if type(cid) == "number" and n.pos then
      if n.pos.z > maxZ then maxZ = n.pos.z end
      if n.pos.z < minZ then minZ = n.pos.z end
    end
  end
  
  local cutoffZ = minZ + (maxZ - minZ) * 0.40

  for cid, n in pairs(v.data.nodes) do
    if type(cid) == "number" and n.pos and n.pos.z >= cutoffZ then
      local name = (n.name or ""):lower()
      local part = (n.partOrigin or ""):lower()
      if not name:match("^wh") and not part:find("wheel") and not part:find("tire") then
        table.insert(M.surfaceNodesCache, cid)
      end
    end
  end

  return M.surfaceNodesCache
end

M.updateVirtualSandPhysics = function(dt)
  if not M.sandParticles or #M.sandParticles == 0 then return end
  if not v or not v.data or not obj then return end

  local surfaceNodes = M.getSurfaceNodes()
  local nodeCount = #surfaceNodes
  if nodeCount == 0 then return end

  local vehPos = obj:getPosition()
  local vehX, vehY, vehZ = vehPos.x, vehPos.y, vehPos.z
  local subDt = math.min(dt, 0.033)

  for i = 1, #M.sandParticles do
    local c = M.sandParticles[i]

    -- 1. СИСТЕМА СНА
    if c.isSleeping then
      local dxCar = c.x - vehX
      local dyCar = c.y - vehY
      local dzCar = c.z - vehZ
      if (dxCar * dxCar + dyCar * dyCar + dzCar * dzCar) < 16.0 then
        c.isSleeping = false
      else
        goto continue_particle
      end
    end

    -- 2. Гравитация и сопротивление воздуха
    c.velZ = (c.velZ or -1.5) - 9.81 * subDt
    c.velX = (c.velX or 0) * (1.0 - 0.25 * subDt)
    c.velY = (c.velY or 0) * (1.0 - 0.25 * subDt)
    c.velZ = c.velZ * (1.0 - 0.10 * subDt)

    local nextX = c.x + c.velX * subDt
    local nextY = c.y + c.velY * subDt
    local nextZ = c.z + c.velZ * subDt

    local dxCar = nextX - vehX
    local dyCar = nextY - vehY
    local dzCar = nextZ - vehZ
    local distCarSq = dxCar * dxCar + dyCar * dyCar + dzCar * dzCar

    -- 3. ТОЧНАЯ КОЛЛИЗИЯ С КУЗОВОМ (Broadphase 4 м)
    if distCarSq < 16.0 then
      local baseSz = c.sz or 0.12
      local radius = baseSz * 0.65
      if c.shape == 2 then radius = math.max(baseSz * 0.5, (c.len or 0.6) * 0.25) end
      local colRadius = radius + 0.18
      local colRadiusSq = colRadius * colRadius

      for k = 1, nodeCount do
        local nodeCid = surfaceNodes[k]
        local nLoc = obj:getNodePosition(nodeCid)
        local nwX = vehX + nLoc.x
        local nwY = vehY + nLoc.y
        local nwZ = vehZ + nLoc.z

        local dx = nextX - nwX
        local dy = nextY - nwY
        local dz = nextZ - nwZ
        local distSq = dx * dx + dy * dy + dz * dz

        if distSq < colRadiusSq and distSq > 0.00001 then
          local dist = math.sqrt(distSq)
          local overlap = colRadius - dist

          local nx = dx / dist
          local ny = dy / dist
          local nz = dz / dist

          nextX = nextX + nx * overlap
          nextY = nextY + ny * overlap
          nextZ = nextZ + nz * overlap

          local vDotN = c.velX * nx + c.velY * ny + c.velZ * nz
          if vDotN < 0 then
            c.velX = (c.velX - nx * (vDotN * 1.4)) * 0.70
            c.velY = (c.velY - ny * (vDotN * 1.5)) * 0.70
            c.velZ = (c.velZ - nz * (vDotN * 1.4)) * 0.70
          end

          local nodeMass = obj:getNodeMass(nodeCid) or 10.0
          local pushForce = vec3(-nx, -ny, -nz) * (overlap * 12000.0 + math.abs(vDotN) * 500.0) * nodeMass
          obj:applyForceVector(nodeCid, pushForce)
        end
      end
    end

    -- 4. Коллизия с землей (Terrain)
    local groundZ = -100
    if obj.getSurfaceHeightBelow then
      groundZ = obj:getSurfaceHeightBelow(vec3(nextX, nextY, nextZ)) or -100
    end

    local minZ = groundZ + (c.sz or 0.12) * 0.5
    if nextZ <= minZ then
      nextZ = minZ
      if c.velZ < 0 then c.velZ = -c.velZ * 0.15 end
      c.velX = c.velX * 0.6
      c.velY = c.velY * 0.6

      if (c.velX * c.velX + c.velY * c.velY + c.velZ * c.velZ) < 0.01 then
        c.isSleeping = true
      end
    end

    c.x, c.y, c.z = nextX, nextY, nextZ

    ::continue_particle::
  end
end

M.updateVirtualBrickPhysics = M.updateVirtualSandPhysics

-- Динамическая инициализация колес при загрузке любой машины
local function initWheelSizing()
  if not v or not v.data or not wheels or not wheels.wheels then return end

  vectorForward = obj:getDirectionVector()
  vectorUp = obj:getDirectionVectorUp()
  vectorRight = vectorForward:cross(vectorUp)

  if not tempVec then tempVec = vec3() end
  if not tempVec2 then tempVec2 = vec3() end
  
  hubBeamTable = {}
  tyreTreadTable = {}
  wheelTreadTable = {}
  rimBeamLength = {}
  rimBeamLengthS = {}
  rimBeamPeri = {}
  rimSideR = {}

  -- Физическое измерение исходного диаметра колес при спавне
  local tV1s = vec3()
  local tV2s = vec3()
  local measuredDiam = 21
  
  -- БЕЗОПАСНАЯ ИНИЦИАЛИЗАЦИЯ: Проверяем, существует ли опорный узел на случай сбоев загрузки
  local initRefNodePos = vec3(0, 0, 0)
  if v.data.refNodes and v.data.refNodes[0] and v.data.nodes and v.data.nodes[v.data.refNodes[0].ref] then
    initRefNodePos = v.data.nodes[v.data.refNodes[0].ref].pos
  end
  
  -- Индексирование структуры балок колес
  wheelBeamsSet = {} -- Очищаем таблицу перед заполнением

  for id, _ in pairs(wheels.wheels) do
    if v.data.wheels[id] then
      -- Регистрируем стандартные балки колес
      if v.data.wheels[id].peripheryBeams then
        for _, beamId in pairs(v.data.wheels[id].peripheryBeams) do
          wheelBeamsSet[beamId] = true
        end
      end
      if v.data.wheels[id].sideBeams then
        for _, beamId in pairs(v.data.wheels[id].sideBeams) do
          wheelBeamsSet[beamId] = true
        end
      end
      if v.data.wheels[id].reinfBeams then
        for _, beamId in pairs(v.data.wheels[id].reinfBeams) do
          wheelBeamsSet[beamId] = true
        end
      end

      for tip, cid in pairs(v.data.wheels[id].nodes) do
        local cid1 = cid
        local cid2 = cid + 1
        if tip == 1 then
          for name, value in pairs(v.data.beams) do
            if value.id1 == cid1 and value.id2 == (cid1 + 31) then
              wheelTreadTable[value.cid] = obj:getBeamLength(value.cid)
              wheelBeamsSet[value.cid] = true
            end
          end
        end
        for name, value in pairs(v.data.beams) do
          if value.id1 == cid1 and value.id2 == cid2 then
            wheelTreadTable[value.cid] = obj:getBeamLength(value.cid)
            wheelBeamsSet[value.cid] = true
          end
        end

        local pcid1 = cid
        local pcid2 = cid + 2
        if (tip == 1) or (tip == 2) then
          for name, value in pairs(v.data.beams) do
            if value.id1 == pcid1 and value.id2 == (pcid1 + 30) then
              rimBeamPeri[value.cid] = obj:getBeamLength(value.cid)
              wheelBeamsSet[value.cid] = true
            end
          end
        end
        for name, value in pairs(v.data.beams) do
          if value.id1 == pcid1 and value.id2 == pcid2 then
            rimBeamPeri[value.cid] = obj:getBeamLength(value.cid)
            wheelBeamsSet[value.cid] = true
          end
        end
      end

      if v.data.wheels[id].treadNodes then
        for tip, cid in pairs(v.data.wheels[id].treadNodes) do
          local pcid1 = cid
          local pcid2 = cid + 4
          if (tip == 1) or (tip == 2) or (tip == 3) or (tip == 4) then
            for name, value in pairs(v.data.beams) do
              if value.id1 == pcid1 and value.id2 == (pcid1 + 28) then
                rimSideR[value.cid] = obj:getBeamLength(value.cid)
                wheelBeamsSet[value.cid] = true
              end
            end
          end
          for name, value in pairs(v.data.beams) do
            if value.id1 == pcid1 and value.id2 == pcid2 then
              rimSideR[value.cid] = obj:getBeamLength(value.cid)
              wheelBeamsSet[value.cid] = true
            end
          end
        end
      end

      if v.data.wheels[id].treadBeams then
        for _, beamId in pairs(v.data.wheels[id].treadBeams) do
          tyreTreadTable[beamId] = obj:getBeamLength(beamId)
          wheelBeamsSet[beamId] = true
        end
      end

      if v.data.wheels[id].rimBeams then
        for _, beamId in pairs(v.data.wheels[id].rimBeams) do
          local rBeam = obj:getBeamLength(beamId)
          if rBeam >= 0.3 then
            rimBeamLength[beamId] = rBeam
          else
            rimBeamLengthS[beamId] = rBeam
          end
          wheelBeamsSet[beamId] = true
        end
      end
    end
  end

  if measuredDiam > 5 and measuredDiam < 100 then
    baseInches = measuredDiam
  else
    baseInches = 21
  end

  -- Принудительно устанавливаем родные размеры машины как стартовые, если чит еще не выбран
  electrics.values['wheelSize'] = electrics.values['wheelSize'] or baseInches
  electrics.values['wheelWidth'] = electrics.values['wheelWidth'] or 300

  -- Физические балки при спавне/сбросе всегда равны 1.0 (сток).
  currentScaleRatio = 1.0
  currentWidthScale = 1.0

  -- Индексирование структуры балок колес
  for id, _ in pairs(wheels.wheels) do
    if v.data.wheels[id] then
      for tip, cid in pairs(v.data.wheels[id].nodes) do
        local cid1 = cid
        local cid2 = cid + 1
        if tip == 1 then
          for name, value in pairs(v.data.beams) do
            if value.id1 == cid1 and value.id2 == (cid1 + 31) then
              wheelTreadTable[value.cid] = obj:getBeamLength(value.cid)
            end
          end
        end
        for name, value in pairs(v.data.beams) do
          if value.id1 == cid1 and value.id2 == cid2 then
            wheelTreadTable[value.cid] = obj:getBeamLength(value.cid)
          end
        end

        local pcid1 = cid
        local pcid2 = cid + 2
        if (tip == 1) or (tip == 2) then
          for name, value in pairs(v.data.beams) do
            if value.id1 == pcid1 and value.id2 == (pcid1 + 30) then
              rimBeamPeri[value.cid] = obj:getBeamLength(value.cid)
            end
          end
        end
        for name, value in pairs(v.data.beams) do
          if value.id1 == pcid1 and value.id2 == pcid2 then
            rimBeamPeri[value.cid] = obj:getBeamLength(value.cid)
          end
        end
      end

      if v.data.wheels[id].treadNodes then
        for tip, cid in pairs(v.data.wheels[id].treadNodes) do
          local pcid1 = cid
          local pcid2 = cid + 4
          if (tip == 1) or (tip == 2) or (tip == 3) or (tip == 4) then
            for name, value in pairs(v.data.beams) do
              if value.id1 == pcid1 and value.id2 == (pcid1 + 28) then
                rimSideR[value.cid] = obj:getBeamLength(value.cid)
              end
            end
          end
          for name, value in pairs(v.data.beams) do
            if value.id1 == pcid1 and value.id2 == pcid2 then
              rimSideR[value.cid] = obj:getBeamLength(value.cid)
            end
          end
        end
      end

      if v.data.wheels[id].treadBeams then
        for _, beamId in pairs(v.data.wheels[id].treadBeams) do
          tyreTreadTable[beamId] = obj:getBeamLength(beamId)
        end
      end

      if v.data.wheels[id].rimBeams then
        for _, beamId in pairs(v.data.wheels[id].rimBeams) do
          local rBeam = obj:getBeamLength(beamId)
          if rBeam >= 0.3 then
            rimBeamLength[beamId] = rBeam
          else
            rimBeamLengthS[beamId] = rBeam
          end
        end
      end
    end
  end

  beamLFin = true
  beamWFin = true
  isMorphingActive = false
end

-- Временная неуязвимость всей подвески и кузова на время морфинга
local function setTemporaryInvulnerability(enable)
  if not v or not v.data or not v.data.beams then return end
  
  if next(beamBaseData) == nil then
    for _, beam in pairs(v.data.beams) do
      if beam and beam.cid ~= nil then
        beamBaseData[beam.cid] = { 
          strength = beam.beamStrength or math.huge, 
          deform = beam.beamDeform or math.huge
        }
      end
    end
  end

  for cid, base in pairs(beamBaseData) do
    if enable then
      -- Полная неразрушимость на время процесса
      obj:setBeamStrength(cid, 1000000000)
      obj:setBeamDeform(cid, 1000000000)
    else
      -- Возвращаем обратно к уровню игрока
      local mult = state.invulnerableMultiplier or 1
      local isGodMode = (mult >= 10)
      local tStrength = isGodMode and 1e10 or (base.strength * mult)
      local tDeform = isGodMode and 1e10 or (base.deform * mult)
      obj:setBeamStrength(cid, tStrength)
      obj:setBeamDeform(cid, tDeform)
    end
  end
end

local function updateWheelMorphing(dt)
  local targetInches = electrics.values['wheelSize'] or 21
  local targetWidth = electrics.values['wheelWidth'] or 300

  local targetScale = targetInches / baseInches
  local targetWidthScale = targetWidth / 300

  local diffSize = targetScale - currentScaleRatio
  local diffWidth = targetWidthScale - currentWidthScale

  local changingSize = math.abs(diffSize) > 0.001
  local changingWidth = math.abs(diffWidth) > 0.001
  local carScaling = isCarMorphingActive

  if changingSize or changingWidth or carScaling then
    -- Запускаем защиту от повреждений
    if not isMorphingActive then
      setTemporaryInvulnerability(true)
      isMorphingActive = true
    end

    -- Плавный расчет диаметра
    if changingSize then
      local step = ((diffSize >= 0) and 1 or -1) * dt * 0.35
      if math.abs(step) > math.abs(diffSize) then
        currentScaleRatio = targetScale
      else
        currentScaleRatio = currentScaleRatio + step
      end
      beamLFin = false
    else
      beamLFin = true
    end

    -- Плавный расчет ширины
    if changingWidth then
      local step = ((diffWidth >= 0) and 1 or -1) * dt * 0.35
      if math.abs(step) > math.abs(diffWidth) then
        currentWidthScale = targetWidthScale
      else
        currentWidthScale = currentWidthScale + step
      end
      beamWFin = false
    else
      beamWFin = true
    end

    -- Применяем диаметр (с учетом масштаба кузова)
    for id, _ in pairs(wheels.wheels) do
      if v.data.wheels[id] then
        for _, beamId in pairs(v.data.wheels[id].peripheryBeams) do
          obj:setBeamLengthRefRatio(beamId, currentScaleRatio * currentCarScale)
        end
        for _, beamId in pairs(v.data.wheels[id].sideBeams) do
          obj:setBeamLengthRefRatio(beamId, currentScaleRatio * currentCarScale)
        end
      end
    end
    for id, _ in pairs(rimBeamPeri) do
      obj:setBeamLengthRefRatio(id, currentScaleRatio * currentCarScale)
    end
    for id, _ in pairs(rimSideR) do
      obj:setBeamLengthRefRatio(id, currentScaleRatio * currentCarScale)
    end
    for beamId, _ in pairs(rimBeamLength) do
      obj:setBeamLengthRefRatio(beamId, currentScaleRatio * currentCarScale)
    end
    for beamId, _ in pairs(rimBeamLengthS) do
      obj:setBeamLengthRefRatio(beamId, currentScaleRatio * currentCarScale)
    end

    -- Применяем ширину (с учетом масштаба кузова)
    for beamId, _ in pairs(tyreTreadTable) do
      obj:setBeamLengthRefRatio(beamId, currentWidthScale * currentCarScale)
    end
    for beamId, _ in pairs(rimBeamLength) do
      obj:setBeamLengthRefRatio(beamId, currentScaleRatio * currentWidthScale * currentCarScale)
    end
    for id, _ in pairs(wheels.wheels) do
      if v.data.wheels[id] and v.data.wheels[id].reinfBeams then
        for _, beamId in pairs(v.data.wheels[id].reinfBeams) do
          obj:setBeamLengthRefRatio(beamId, currentWidthScale * currentCarScale)
        end
      end
    end
    for beamId, _ in pairs(wheelTreadTable) do
      obj:setBeamLengthRefRatio(beamId, currentWidthScale * currentCarScale)
    end

  else
    -- Завершено! Выключаем защиту и моментально чиним всю трансмиссию/карданы
    if isMorphingActive then
      setTemporaryInvulnerability(false)
      if M.healDrivetrain then
        M.healDrivetrain()
      end
      isMorphingActive = false
      beamLFin = true
      beamWFin = true
      guihooks.message("Cheat completed", 4, "codeCheatMenu")
    end
  end
end

local function updateSuspensionMorphing(dt)
  local targetHeight = state.suspensionHeightMultiplier or 1.0
  local diff = targetHeight - currentSuspensionHeight

  local changingSuspension = math.abs(diff) > 0.001
  local carScaling = isCarMorphingActive

  if changingSuspension or carScaling then
    -- Запускаем временную защиту от повреждений на время деформации
    if not isSuspensionMorphingActive then
      setTemporaryInvulnerability(true)
      isSuspensionMorphingActive = true
    end

    -- Рассчитываем плавный шаг изменения высоты
    if changingSuspension then
      local step = ((diff >= 0) and 1 or -1) * dt * 0.75 -- Скорость морфинга высоты
      if math.abs(step) > math.abs(diff) then
        currentSuspensionHeight = targetHeight
      else
        currentSuspensionHeight = currentSuspensionHeight + step
      end
    end

    if next(suspensionBeams) == nil then
      cacheSuspensionBeams()
    end

    -- Вычисляем коэффициенты жесткости и демпфирования на основе высоты
    local height = currentSuspensionHeight
    local springScale = 1.0
    if height > 1.0 then
      -- Чем выше подвеска, тем мягче делаем пружину, чтобы компенсировать перенатяжение рычагов
      springScale = 1.0 / (height ^ 1.8) 
    else
      -- Чем ниже подвеска (стенс/занижение), тем жестче пружина, чтобы избежать пробоев в кузов
      springScale = 1.0 / (math.max(0.1, height) ^ 1.5)
    end
    -- Демпфирование настраиваем пропорционально квадратному корню из жесткости для сохранения баланса
    local dampScale = math.sqrt(springScale)

    -- Применяем высоту и новые параметры упругости
    for cid, original in pairs(suspensionBeams) do
      obj:setBeamLengthRefRatio(cid, height * currentCarScale)
      
      if type(original) == "table" then
        local newSpring = original.beamSpring * springScale
        local newDamp = original.beamDamp * dampScale
        obj:setBeamSpringDamp(cid, newSpring, newDamp, original.springExpansion, original.dampExpansion)
      end
    end
  else
    -- Завершено! Выключаем защиту и чиним трансмиссию
    if isSuspensionMorphingActive then
      setTemporaryInvulnerability(false)
      if M.healDrivetrain then
        M.healDrivetrain()
      end
      isSuspensionMorphingActive = false
      guihooks.message("Cheat completed", 4, "codeCheatMenu")
    end
  end
end


local function hasActiveCheat()
  return math.abs(state.invulnerableMultiplier - 1) > 0.001
    or state.freezeThermals
    or state.infiniteFuel
    or state.infiniteN2O
    or state.infiniteJato
    or state.rainbowMode
    or math.abs(state.powerMultiplier - 1) > 0.001
    or math.abs(state.gripMultiplier - 1) > 0.001
    or math.abs(state.gravityMultiplier - 1) > 0.001
    or math.abs(state.brakeMultiplier - 1) > 0.001
    or math.abs(state.massMultiplier - 1) > 0.001
    or math.abs(state.engineBrakeMultiplier - 1) > 0.001
    or math.abs(state.dragMultiplier - 1) > 0.001
    or math.abs(state.gearMultiplier - 1) > 0.001
    or math.abs(state.timeScale - 1) > 0.001
    or math.abs(state.jatoMultiplier - 1) > 0.001
end

local function showStatusMessage(message, id)
  guihooks.message(message, 4, id or "codeCheatMenu")
end

local function scheduleReapply(frameCount)
  pendingReapplyFrames = math.max(pendingReapplyFrames, frameCount or 2)
end

local function setVehiclePaint(r, g, b)
  local vid = obj:getID()
  -- Преобразуем r, g, b (0-1) в формат (0-255)
  local ri, gi, bi = math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
  
  local geCode = string.format([[
    local veh = be:getObjectByID(%d)
    if veh then
      veh:setField("color", "", "%d %d %d 255")
      veh:postApply()
    end
  ]], vid, ri, gi, bi)
  
  obj:queueGameEngineLua(geCode)
end

local function applyWeatherEffect(typeStr, active, amount)
  local pos = obj:getPosition() -- Берем координаты машины
  local geCode = string.format([[
    local objWeather = scenetree.findObject("cheat_precipitation")
    
    if %s and not objWeather then
      objWeather = createObject("Precipitation")
      objWeather:registerObject("cheat_precipitation")
      -- Привязываем к игровому миру
      local root = scenetree.findObject("MissionGroup")
      if root then root:addObject(objWeather) end
      
      objWeather:setField("boxWidth", 0, "80")
      objWeather:setField("boxHeight", 0, "50")
    end

    if objWeather then
      if %s then
        objWeather:setPosition(vec3(%f, %f, %f + 10)) -- Ставим над машиной
        
        if "%s" == "snow" then
          objWeather:setField("dataBlock", 0, "Snow_menu")
          objWeather:setField("minSpeed", 0, "0.01")
          objWeather:setField("maxSpeed", 0, "0.25")
          objWeather:setField("dropSize", 0, "2.5")
          objWeather:setField("useTrueBillboards", 0, "1")
          objWeather:setField("renderPriority", 0, "10")
        else
          -- Вместо поиска dataBlock, мы просто сбрасываем его, 
          -- тогда объект Precipitation использует настройки по умолчанию (обычно это дождь)
          objWeather:setField("dataBlock", 0, "") 
          
          -- Настройки ДОЖДЯ (убеждаемся, что параметры визуализации заданы)
          objWeather:setField("minSpeed", 0, "0.1")
          objWeather:setField("maxSpeed", 0, "0.5")
          objWeather:setField("dropSize", 0, "1")
          objWeather:setField("useTrueBillboards", 0, "1") -- Линии
          objWeather:setField("renderPriority", 0, "10")   -- Чтобы был поверх всего
        end
        
        objWeather:setField("numDrops", 0, "%d")
        objWeather:postApply()
      else
        objWeather:setField("numDrops", 0, "0")
        objWeather:postApply()
      end
    end
  ]], tostring(active), tostring(active), pos.x, pos.y, pos.z, typeStr, math.min(amount or 0, 10000))
  
  obj:queueGameEngineLua(geCode)
end

local function setupMessageHook()
  if originalGuihooksMessage == nil and guihooks and type(guihooks.message) == "function" then
    originalGuihooksMessage = guihooks.message
    guihooks.message = function(msg, time, category, icon)
      -- ИЗМЕНЕНА СТРОКА НИЖЕ:
      if state.powerMultiplier > 1.001 or state.invulnerableMultiplier > 1.001 or state.indestructibleEngine then
        local catStr = type(category) == "string" and category:lower() or ""
        local msgStr = type(msg) == "string" and msg:lower() or ""

        local isDamageMsg = catStr:find("damage") or catStr:find("engine")
          or msgStr:find("грм") or msgStr:find("оборотами") or msgStr:find("радиатор")
          or msgStr:find("двигател") or msgStr:find("engine") or msgStr:find("valvetrain")
          or msgStr:find("radiator") or msgStr:find("oil") or msgStr:find("coolant")
          or msgStr:find("поврежден") or msgStr:find("перегрев")

        if isDamageMsg then return end
      end
      return originalGuihooksMessage(msg, time, category, icon)
    end
  end
end



-- УПРАВЛЕНИЕ ДВИГАТЕЛЕМ

local function capturePowerBaseData()
  powerBaseData = {}
  -- Собираем и ДВС и Электромоторы
  local allMotors = {}
  for _, v in ipairs(powertrain.getDevicesByCategory("engine") or {}) do table.insert(allMotors, v) end
  for _, v in ipairs(powertrain.getDevicesByCategory("electricMotor") or {}) do table.insert(allMotors, v) end

  for _, device in ipairs(allMotors) do
    powerBaseData[device.name] = {
      torqueCurve = deepcopy(device.torqueCurve or {}),
      maxTorqueRating = device.maxTorqueRating,
      maxRPM = device.maxRPM,
      maxAV = device.maxAV,
      maxAvailableRPM = device.maxAvailableRPM,
      maxSoundRPM = device.maxSoundRPM,
      revLimiterRPM = device.revLimiterRPM,
      revLimiterAV = device.revLimiterAV,
      revLimiterMaxAV = device.revLimiterMaxAV,
      invRevLimiterRange = device.invRevLimiterRange,
      revLimiterMaxAVOvershoot = device.revLimiterMaxAVOvershoot,
      hasRevLimiter = device.hasRevLimiter,
      revLimiterType = device.revLimiterType,
      redlineTorqueDropOffRange = device.redlineTorqueDropOffRange,
      
      valvetrainOverrevDamageAV = device.valvetrainOverrevDamageAV,
      
      dynamicFriction = device.dynamicFriction or 0,
      friction = device.friction or 0,
      brakingCoef = device.brakingCoef or 0,

      -- Новые сохраненные оригинальные параметры во избежание изменения стоковой физики
      maxPowerThrottleMap = device.maxPowerThrottleMap,
      idleTorque = device.idleTorque,
      torqueData = device.torqueData and deepcopy(device.torqueData) or nil,
      maxPower = device.maxPower,
      maxTorque = device.maxTorque
    }
  end
  needsPowerBaseRefresh = false
end



local function refreshDevicePerformanceData(device)
  if not device.getTorqueData then return end
  device.torqueData = device:getTorqueData()
  device.maxPower = device.torqueData.maxPower
  device.maxTorque = device.torqueData.maxTorque

  if device.maxPowerThrottleMap ~= nil then
    device.maxPowerThrottleMap = device.torqueData.maxPower * PS_TO_WATT
  end
  if device.idleRPM ~= nil then
    device.idleTorque = device.torqueCurve[math.floor(device.idleRPM or 0)] or device.idleTorque or 0
  end
  if device.resetTempRevLimiter then device:resetTempRevLimiter() end
end

local function restoreEngineDevice(device, baseData)
  device.torqueCurve = deepcopy(baseData.torqueCurve or {})
  device.maxTorqueRating = baseData.maxTorqueRating
  device.maxRPM = baseData.maxRPM
  device.maxAV = baseData.maxAV
  device.maxAvailableRPM = baseData.maxAvailableRPM
  device.maxSoundRPM = baseData.maxSoundRPM
  device.revLimiterRPM = baseData.revLimiterRPM
  device.revLimiterAV = baseData.revLimiterAV
  device.revLimiterMaxAV = baseData.revLimiterMaxAV
  device.invRevLimiterRange = baseData.invRevLimiterRange
  device.revLimiterMaxAVOvershoot = baseData.revLimiterMaxAVOvershoot
  device.hasRevLimiter = baseData.hasRevLimiter
  device.revLimiterType = baseData.revLimiterType
  device.redlineTorqueDropOffRange = baseData.redlineTorqueDropOffRange
  
  device.valvetrainOverrevDamageAV = baseData.valvetrainOverrevDamageAV

  -- Точный возврат характеристик мощности к исходным значениям
  device.maxPowerThrottleMap = baseData.maxPowerThrottleMap
  device.idleTorque = baseData.idleTorque
  device.torqueData = baseData.torqueData and deepcopy(baseData.torqueData) or nil
  device.maxPower = baseData.maxPower
  device.maxTorque = baseData.maxTorque
  
  if device.resetTempRevLimiter then device:resetTempRevLimiter() end
end

local function buildScaledTorqueCurve(baseData)
  local scaledCurve = {}
  local baseCurve = baseData.torqueCurve or {}
  
  -- Компенсация мощности двигателя при отсутствии воздуха
  local dragCompensation = 1
  if state.dragMultiplier < 1 then
    dragCompensation = 1 / math.max(state.dragMultiplier, 0.01)
  end
  
  local totalPowerMultiplier = state.powerMultiplier * dragCompensation
  if state.drivePresetActive and M._drivePresetLaunchRampSec and M._drivePresetLaunchRampSec > 0 then
    local lb = M._drivePresetLaunchBlend or 0
    local lmin = M._drivePresetLaunchMinFactor or 0.35
    totalPowerMultiplier = totalPowerMultiplier * (lmin + (1 - lmin) * lb)
  end
  if state.drivePresetActive and M._drivePresetTorqueBlend and M._drivePresetTorqueBlend < 1 then
    local b = M._drivePresetTorqueBlend
    totalPowerMultiplier = 1 + (totalPowerMultiplier - 1) * b
  end
  local rpmMult = state.rpmMultiplier or 1

  -- 1. Вычисляем максимальный крутящий момент мотора в стоке
  local maxBaseTorque = 0
  for _, tq in pairs(baseCurve) do
    if type(tq) == "number" and tq > maxBaseTorque then
      maxBaseTorque = tq
    end
  end

  -- Безопасно определяем максимальные обороты ДВС
  local originalMaxRPM = baseData.maxRPM or #baseCurve
  if not originalMaxRPM or originalMaxRPM <= 0 then
    originalMaxRPM = 6000
  end
  local newMaxRPM = math.floor(originalMaxRPM * rpmMult)
  if newMaxRPM > 12500 then newMaxRPM = 12500 end
  local effectiveRpmMult = newMaxRPM / originalMaxRPM

  -- 2. Генерируем абсолютно плотный массив без пропусков индексов для UI-приложений
  for i = 0, newMaxRPM do
    -- Находим соответствующий индекс в исходном графике
    local origRPM = math.max(0, math.min(originalMaxRPM, math.floor(i / effectiveRpmMult + 0.5)))
    local baseValue = baseCurve[origRPM] or 0
    
    -- Preset conduite : jamais courbe plate max au ralenti (ça fige boîte + roues)
    local useFlatMaxTorque = state.powerMultiplier > 1.5 and not state.drivePresetActive
    local torque
    if useFlatMaxTorque then
      torque = maxBaseTorque * totalPowerMultiplier
    else
      torque = baseValue * totalPowerMultiplier
    end
    -- Profil circuit ETK : assez de Nm pour démarrer, fusée seulement haut régime
    if state.drivePresetActive and state.drivePresetTorqueProfile == "circuit" and newMaxRPM > 0 then
      local rpmNorm = i / newMaxRPM
      local fullScaled = baseValue * totalPowerMultiplier
      local shape
      local scintillaGrip = M._drivePresetLastCfgId == "scintilla"
      if scintillaGrip then
        if rpmNorm < 0.35 then
          shape = 0.32 + 0.26 * (rpmNorm / 0.35)
        elseif rpmNorm < 0.62 then
          local t = (rpmNorm - 0.35) / 0.27
          shape = 0.56 + 0.34 * t
        else
          local t = (rpmNorm - 0.62) / 0.38
          shape = 0.88 + 0.22 * (t ^ 1.35)
          if shape > 1.14 then shape = 1.14 end
        end
      elseif rpmNorm < 0.28 then
        shape = 0.48 + 0.28 * (rpmNorm / 0.28)
      elseif rpmNorm < 0.58 then
        local t = (rpmNorm - 0.28) / 0.30
        shape = 0.74 + 0.22 * t
      else
        local t = (rpmNorm - 0.58) / 0.42
        shape = 0.94 + 0.18 * (t ^ 1.45)
        if shape > 1.12 then shape = 1.12 end
      end
      torque = fullScaled * shape
      local lowScaleCfg = M._drivePresetTorqueLowScale
      if lowScaleCfg and lowScaleCfg < 0.999 and rpmNorm < 0.58 then
        local lowMix = lowScaleCfg + (1 - lowScaleCfg) * (rpmNorm / 0.58)
        torque = torque * lowMix
      end
    end
    scaledCurve[i] = torque
  end
  
  if state.powerMultiplier > 1.5 and not state.drivePresetActive then
    scaledCurve[0] = maxBaseTorque * totalPowerMultiplier
  end

  if state.drivePresetActive and newMaxRPM > 0 then
    local peakTq = maxBaseTorque * totalPowerMultiplier
    for i = 0, newMaxRPM do
      local t = scaledCurve[i]
      if type(t) == "number" and t > peakTq then peakTq = t end
    end
    local idleRpm = math.floor(baseData.idleRPM or 900)
    local floorEnd = math.min(newMaxRPM, idleRpm + 2600)
    local isScintilla = M._drivePresetLastCfgId == "scintilla"
    local minPeakFrac = state.drivePresetTorqueProfile == "circuit"
        and (isScintilla and 0.045 or 0.1) or 0.16
    local minPeak = peakTq * minPeakFrac
    for i = 0, floorEnd do
      local t = scaledCurve[i] or 0
      local rpmBlend = floorEnd > 0 and (i / floorEnd) or 1
      local lowBlend
      if state.drivePresetTorqueProfile == "circuit" and isScintilla then
        lowBlend = 0.34 + 0.52 * rpmBlend
      elseif state.drivePresetTorqueProfile == "circuit" then
        lowBlend = 0.52 + 0.42 * rpmBlend
      else
        lowBlend = 0.65 + 0.35 * rpmBlend
      end
      local minTq = minPeak * lowBlend
      if t < minTq then scaledCurve[i] = minTq end
    end
  end

  -- 4. Переносим метаданные и строковые ключи (если они есть)
  for key, value in pairs(baseCurve) do
    if type(key) ~= "number" then
      scaledCurve[key] = deepcopy(value)
    end
  end

  return scaledCurve
end

-- ПРИМЕНЕНИЕ ЧИТОВ

local function applyShadowQuality(multiplier)
  -- Если множитель 0, просто выходим, чтобы не менять ничего
  if multiplier == 0 then
    -- Возможно, стоит добавить возврат к стоку здесь, если 0 означает "выключить"
    -- Но для начала оставим так, чтобы понять логику
    return
  end
-- local classes = {'PointLight', 'ScatterSky', 'SpotLight', 'Sun'}
  local geCode = string.format([[
    if not _G.shadow_defaults_map then _G.shadow_defaults_map = {} end
    local classes = {
      'PointLight',
      'SpotLight',
      'Sun',
      'ScatterSky',
      'ProjectedShadow',
      'EnvironmentProbe'
    }
    local multiplier = %g
    
    for _, className in ipairs(classes) do
      local names = scenetree.findClassObjects(className)
      for i = 1, #names do
        local obj = scenetree.findObject(names[i])
        if obj then
          local id = obj:getID()
          
          if not _G.shadow_defaults_map[id] then
            _G.shadow_defaults_map[id] = obj.texSize or 512
          end
          
          if multiplier > 0 then
            obj.texSize = _G.shadow_defaults_map[id] * multiplier
          else
            obj.texSize = _G.shadow_defaults_map[id]
          end
          obj:postApply() 
        end
      end
    end
    log('I', 'CheatMenu', 'Shadow Quality Multiplier: ' .. multiplier)
  ]], multiplier)
  
  obj:queueGameEngineLua(geCode)
end
local function addShadowQualityPresets(entries)
  for _, preset in ipairs(PRESET.SHADOW) do
    local isSelected = math.abs(state.shadowMultiplier - preset) < 0.001
    local title = string.format("Shadow Quality: x%g", preset)
    
    -- Особый случай для 1, который означает "выключить" или "стандарт"
    if preset == 1 then 
      title = "Shadow Quality: Stock"
    end

    table.insert(entries, {
      title = title,
      desc = "Multiplies the shadow resolution of all light sources (PointLight, SpotLight, Sun, ScatterSky, ProjectedShadow, EnvironmentProbe)",
      icon = "badge",
      uniqueID = "codeCheatShadowRes_" .. preset, -- Уникальный ID для каждого пресета
      color = isSelected and "#4cff93" or nil,
      onSelect = function()
        state.shadowMultiplier = preset
        -- Если множитель 0, вызываем с 0, иначе с самим значением
        applyShadowQuality(preset > 0 and preset or 0) 
        showStatusMessage("Graphics: Shadow multiplier set to " .. preset)
        return {"reload"}
      end
    })
  end
end
local function applyUnderwaterMode(enabled)
  local engines = powertrain.getDevicesByCategory and powertrain.getDevicesByCategory("engine") or {}
  for _, device in ipairs(engines) do
    if enabled then
      device.canFlood = false
      device.isHydrolocked = false -- На всякий случай сбрасываем, если уже залило
      device.engineDisabled = false
    else
      -- Возвращаем стандартное поведение (обычно true для ДВС)
      device.canFlood = true
    end
  end
end

local function applyAWD(enabled)
  if not enabled and not activeFlags.awdMode then return end

  local gearboxes = powertrain.getDevicesByCategory and powertrain.getDevicesByCategory("differential") or {}
  
  if next(diffBaseData) == nil then
    for _, device in ipairs(gearboxes) do
      diffBaseData[device.name] = {
        torqueSplit = device.torqueSplit or 0.5,
        lockTorque = device.lockTorque or 0
      }
    end
  end

  for _, device in ipairs(gearboxes) do
    if enabled then
      device.torqueSplit = 0.5 
      device.lockTorque = 9000000
    else
      local base = diffBaseData[device.name]
      if base then
        device.torqueSplit = base.torqueSplit
        device.lockTorque = base.lockTorque
      end
    end
  end

  local trCase = powertrain.getDevice("transfercase")
  if trCase then
    if enabled then
      trCase.isBroken = false
      if trCase.activeLockTorque then trCase.activeLockTorque = 9000000 end
    else
      trCase.isBroken = false
    end
  end

  if electrics and electrics.values then
    if enabled then
      electrics.values.tcclock = 1
      locked = true
      
      if electrics.values.lockupClutchRatio == 0 then
        electrics.values.lockupClutchRatio = 1
      end
    else
      if locked then
        electrics.values.tcclock = 0
        gui.message("TCC Forced UNLOCKED", 0, "^tcclock\\.")
        locked = false
      end
    end
  end

  activeFlags.awdMode = enabled
end

local function applyVehicleControllerSpeedOverride(enabled)
  if not enabled and not vehicleControllerBaseData.captured then return false end
  local vehicleController = controller and controller.getController and controller.getController("vehicleController")
  if not vehicleController then return false end
  
  if not vehicleControllerBaseData.captured then
    vehicleControllerBaseData.topSpeedLimit = vehicleController.topSpeedLimit
    vehicleControllerBaseData.topSpeedLimitReverse = vehicleController.topSpeedLimitReverse
    vehicleControllerBaseData.captured = true
  end
  vehicleController.topSpeedLimit = enabled and 9999 or vehicleControllerBaseData.topSpeedLimit
  vehicleController.topSpeedLimitReverse = enabled and 9999 or vehicleControllerBaseData.topSpeedLimitReverse
  return true
end

local function applyTireBurstFix(enabled)
  if not wheels or not wheels.wheels then return end
  
  for i, wheel in pairs(wheels.wheels) do
    if enabled then
      -- 1. Запрещаем программный взрыв
      wheel.tireBurstAV = math.huge
      -- 2. Накачиваем шину до безумного давления (чтобы она не слетала)
      if wheel.setPressure then
        wheel:setPressure(400000) -- 2 миллиона Паскалей (шина станет "литой")
      end
      wheel.isInflated = true
    else
      -- Возвращаем стандартные настройки (приблизительно)
      wheel.tireBurstAV = wheelBurstBaseData[i] or nil
      if wheel.setPressure then
        wheel:setPressure(200000) 
      end
    end
  end
end

local function applyTransmissionFix(enabled)
  if not enabled and next(transmissionBaseData) == nil then return end
  if not powertrain or type(powertrain.getDevices) ~= "function" then return end
  
  if next(transmissionBaseData) == nil then
    for name, device in pairs(powertrain.getDevices()) do
      transmissionBaseData[name] = {
        clutchTorque = device.clutchTorque,
        baseClutchTorque = device.baseClutchTorque,
        lockTorque = device.lockTorque, -- Кэшируем сцепление АКПП
        capacityFactor = device.capacityFactor,         -- Кэшируем вязкость трансформатора
        maxTorqueRating = device.maxTorqueRating,
        maxSafeTemp = device.maxSafeTemperature,
        effEnd = device.efficiencyScaleEnd
      }
    end
  end

  for name, device in pairs(powertrain.getDevices()) do
    local base = transmissionBaseData[name]
    if base then
      if enabled then
        -- Делаем любое сцепление монолитным (1 миллиард Нм)
        local multi = 1e9 
        
        -- Фикс для механики и DCT
        if device.clutchTorque then device.clutchTorque = (base.clutchTorque or 1000) * multi end
        if device.baseClutchTorque then device.baseClutchTorque = (base.baseClutchTorque or 1000) * multi end
        
        -- ФИКС ДЛЯ АВТОМАТОВ (Гидротрансформаторы)
        if device.lockTorque then device.lockTorque = (base.lockTorque or 1000) * multi end
        if device.capacityFactor then device.capacityFactor = (base.capacityFactor or 1) * multi end
        
        device.maxTorqueRating = math.huge
        
        -- Фикс температурного разрушения сцепления
        if device.clutchTemperature ~= nil then
          device.maxSafeTemperature = 1e14  
          device.efficiencyScaleEnd = 1e14  
          device.efficiencyScaleStart = 1e30 
          device.clutchTemperature = 20     
          device.clutchEfficiency = 1       
          device.energyBuiltup = 0
          device.clutchRatio = 1
          device.isBroken = false
        end

        -- 3. Защита вязкостных муфт (актуально для дифференциалов)
        if device.viscousTorque ~= nil then
           device.viscousTorque = (base.viscousTorque or 1000) * multi
        end
        
        -- 4. Защита от физического разрыва (деформации)
        device.isBroken = false
        device.damage = 0
        
        -- 5. Для DCT (Dual Clutch Transmission)
        if device.clutchRatio then device.clutchRatio = 1 end
        
      else
        -- Возврат к стоку
        if device.clutchTorque then device.clutchTorque = base.clutchTorque end
        if device.baseClutchTorque then device.baseClutchTorque = base.baseClutchTorque end
        if device.lockTorque then device.lockTorque = base.lockTorque end
        if device.capacityFactor then device.capacityFactor = base.capacityFactor end
        device.maxTorqueRating = base.maxTorqueRating
        
        if device.clutchTemperature ~= nil then
          device.maxSafeTemperature = base.maxSafeTemp or 150
          device.efficiencyScaleEnd = base.effEnd or 250
        end
      end
    end
  end
end

local function drivePresetWaitingForPower()
  if not state.drivePresetActive then return false end
  if M._drivePresetPendingPower then return true end
  local fr = M._drivePresetPowerUnlockFrames or 0
  return fr > 0
end

local function applyPowerMultiplier()
  -- Мощность должна модифицироваться, если изменен Power ИЛИ если изменен Drag (нужна компенсация)
  -- БЫЛО ДО RPM local isPowerModified = state.powerMultiplier > 1.001 or state.dragMultiplier < 0.999
  local isEngineBrakeModified = math.abs(state.engineBrakeMultiplier - 1) > 0.001
  
  -- Мощность должна модифицироваться, если изменен Power ИЛИ Drag ИЛИ лимитер оборотов RPM
  local isPowerModified = state.powerMultiplier > 1.001 or state.dragMultiplier < 0.999 or state.rpmMultiplier > 1.001
  if drivePresetWaitingForPower() and not isPowerModified then
    return false
  end
  if not isPowerModified and not activeFlags.power and not activeFlags.engineBrake then return false end
  
  -- БЫЛО ДО RPM if not isPowerModified and not isEngineBrakeModified and not activeFlags.power and not activeFlags.engineBrake then return false end

  -- Собираем ВСЕ силовые установки: и ДВС, и Электромоторы
  local allPowerDevices = {}
  local engines = powertrain.getDevicesByCategory and powertrain.getDevicesByCategory("engine") or {}
  local motors = powertrain.getDevicesByCategory and powertrain.getDevicesByCategory("electricMotor") or {}
  
  for _, d in ipairs(engines) do table.insert(allPowerDevices, d) end
  for _, d in ipairs(motors) do table.insert(allPowerDevices, d) end

  applyVehicleControllerSpeedOverride(isPowerModified)
  -- Preset conduite : pas de clutch 1e9 ni pneus à 400 kPa au déblocage puissance
  local hardPowertrainHack = isPowerModified and not state.drivePresetActive
  applyTireBurstFix(hardPowertrainHack)
  applyTransmissionFix(hardPowertrainHack)

  -- Если моторов вообще нет — выходим
  if #allPowerDevices == 0 then return false end
  
  if needsPowerBaseRefresh or next(powerBaseData) == nil then capturePowerBaseData() end

  for _, device in ipairs(allPowerDevices) do
    local baseData = powerBaseData[device.name]
    if not baseData then
      needsPowerBaseRefresh = true
      capturePowerBaseData()
      baseData = powerBaseData[device.name]
    end

    if baseData then
      if not isPowerModified then 
        restoreEngineDevice(device, baseData)
      else
        device.torqueCurve = buildScaledTorqueCurve(baseData)
        if state.drivePresetActive then
          device.maxTorqueRating = math.huge
        else
          device.maxTorqueRating = math.huge
        end
        refreshDevicePerformanceData(device)
      end

      -- Применяем торможение двигателем/рекуперацию (актуально и для электро)
      if isEngineBrakeModified then
        device.dynamicFriction = (baseData.dynamicFriction or 0) * state.engineBrakeMultiplier
        device.friction = (baseData.friction or 0) * state.engineBrakeMultiplier
        if device.brakingCoef then 
          device.brakingCoef = (baseData.brakingCoef or 0) * state.engineBrakeMultiplier 
        end
      else
        device.dynamicFriction = baseData.dynamicFriction
        device.friction = baseData.friction
        if device.brakingCoef then device.brakingCoef = baseData.brakingCoef end
      end
    end
  end
  
  if powertrain.sendTorqueData then powertrain.sendTorqueData() end
  
  activeFlags.power = isPowerModified
  activeFlags.engineBrake = isEngineBrakeModified
  return true
end

local function applyRPMMultiplier()
  local isModified = math.abs(state.rpmMultiplier - 1) > 0.001
  if drivePresetWaitingForPower() and not isModified then
    return
  end
  if not isModified and not activeFlags.rpm then return end

  local engines = powertrain.getDevicesByCategory("engine") or {}
  if #engines == 0 then return end

  if needsPowerBaseRefresh or next(powerBaseData) == nil then capturePowerBaseData() end

  for _, device in ipairs(engines) do
    local baseData = powerBaseData[device.name]
    if not baseData then
      needsPowerBaseRefresh = true
      capturePowerBaseData()
      baseData = powerBaseData[device.name]
    end

    if baseData then
      if not isModified then
        restoreEngineDevice(device, baseData)
      else
        local mult = state.rpmMultiplier
        local cappedMaxRpm = math.min((baseData.maxRPM or 6000) * mult, 12500)
        if baseData.maxRPM and baseData.maxRPM > 0 then
          mult = cappedMaxRpm / baseData.maxRPM
        end
        
        device.maxRPM = cappedMaxRpm
        if baseData.maxAV and baseData.maxRPM and baseData.maxRPM > 0 then
          device.maxAV = device.maxRPM * (baseData.maxAV / baseData.maxRPM)
        end
        
        if baseData.revLimiterRPM then
          device.revLimiterRPM = math.min(math.floor(baseData.revLimiterRPM * mult), 12500)
        end
        if state.drivePresetActive and M._drivePresetWl40BypassGovernor and device.maxRPM then
          device.revLimiterRPM = device.maxRPM
        end
        if baseData.revLimiterAV and baseData.revLimiterRPM and baseData.revLimiterRPM > 0 then
          device.revLimiterAV = device.revLimiterRPM * (baseData.revLimiterAV / baseData.revLimiterRPM)
        end
        if baseData.revLimiterMaxAV and baseData.revLimiterRPM and baseData.revLimiterRPM > 0 then
          device.revLimiterMaxAV = device.revLimiterRPM * (baseData.revLimiterMaxAV / baseData.revLimiterRPM)
        end
        if baseData.invRevLimiterRange then
          device.invRevLimiterRange = baseData.invRevLimiterRange / mult
        end
        if baseData.revLimiterMaxAVOvershoot and baseData.revLimiterRPM and baseData.revLimiterRPM > 0 then
          device.revLimiterMaxAVOvershoot = device.revLimiterRPM * (baseData.revLimiterMaxAVOvershoot / baseData.revLimiterRPM)
        end
        
        device.valvetrainOverrevDamageAV = math.huge
        if device.resetTempRevLimiter then device:resetTempRevLimiter() end

        device.torqueCurve = buildScaledTorqueCurve(baseData)
        refreshDevicePerformanceData(device)
      end
    end
  end
  if powertrain.sendTorqueData then powertrain.sendTorqueData() end
  activeFlags.rpm = isModified
end

local function applyGripMultiplier()
  local isModified = math.abs(state.gripMultiplier - 1) > 0.001
  if not isModified and not activeFlags.grip then return end

  if next(wheelGripBaseData) == nil then
    for _, wheel in pairs(wheels.wheels or {}) do
      local wheelNodes = wheel.treadNodes or wheel.nodes or {}
      for _, nodeCID in ipairs(wheelNodes) do
        local nodeData = v and v.data and v.data.nodes and v.data.nodes[nodeCID]
        if nodeData and not wheelGripBaseData[nodeCID] then
          wheelGripBaseData[nodeCID] = { friction = nodeData.frictionCoef or 1, slidingFriction = nodeData.slidingFrictionCoef or (nodeData.frictionCoef or 1) }
        end
      end
    end
  end

  for nodeCID, baseData in pairs(wheelGripBaseData) do
    obj:setNodeFrictionSlidingCoefs(nodeCID, baseData.friction * state.gripMultiplier, baseData.slidingFriction * state.gripMultiplier)
  end
  activeFlags.grip = isModified
end

local function findJbeamWheelData(wheelID)
  if not v or not v.data or not v.data.wheels or wheelID == nil then return nil end
  for _, jb in pairs(v.data.wheels) do
    if type(jb) == "table" and jb.wheelID == wheelID then return jb end
  end
  return nil
end

local function ensureWheelBrakeBase(wd, idx)
  if not wd then return nil end
  local jb = findJbeamWheelData(wd.wheelID)
  local jbBrake = jb and jb.brakeTorque
  local cached = wheelBrakeBaseData[idx]
  if cached and (cached.brakeTorque or 0) > 0.001 then
    if jbBrake and jbBrake > 0.001 and math.abs(cached.brakeTorque - jbBrake) > 0.5 then
      cached.brakeTorque = jbBrake
      cached.parkingTorque = (jb and jb.parkingTorque) or cached.parkingTorque or 0
    else
      return cached
    end
  end
  local stockBrake = jbBrake
  if not stockBrake or stockBrake <= 0.001 then
    stockBrake = wd.brakeTorque or wd.initialBrakeTorque or 0
    local peel = state.brakeMultiplier or 1
    if peel > 1.05 and stockBrake > 0 then
      stockBrake = stockBrake / peel
    end
  end
  local stockPark = (jb and jb.parkingTorque) or wd.parkingTorque or wd.initialParkingTorque or 0
  wheelBrakeBaseData[idx] = {
    brakeTorque = stockBrake,
    parkingTorque = stockPark,
    brakeSpring = (jb and jb.brakeSpring) or wd.brakeSpring or 10,
    pressureInDelay = (jb and jb.brakePressureInDelay) or 0.04,
    pressureOutDelay = (jb and jb.brakePressureOutDelay) or 0.04,
    wheelID = wd.wheelID,
  }
  return wheelBrakeBaseData[idx]
end

local function applyBrakeTorqueToWheel(wd, base, mult)
  if not wd or not base then return end
  mult = tonumber(mult) or 1
  local pressureGain = M._drivePresetBrakePressureGain or 1
  local pedal = M._drivePresetCurrentPedalBrakeScale or 1
  if pedal > 1.001 and M._drivePresetHardBrakePressureBoost then
    pressureGain = pressureGain * (1 + (pedal - 1) * (M._drivePresetHardBrakePressureBoost - 1))
  end
  local springGain = M._drivePresetBrakeSpringGain or 1
  local newBrake = base.brakeTorque * mult
  local newPark = base.parkingTorque * mult
  -- wheels.lua recalcule depuis initialBrakeTorque : les deux doivent être boostés
  wd.initialBrakeTorque = newBrake
  wd.initialParkingTorque = newPark
  wd.brakeTorque = newBrake
  wd.parkingTorque = newPark
  if newBrake > 0 then
    wd.invInitialBrakeTorque = 1 / newBrake
  else
    wd.invInitialBrakeTorque = 0
  end
  if newBrake > 0 then
    wd.invRelativeBrakingTorqueCoef = 1 / newBrake
  end
  if wd.wheelID and obj.getWheel then
    local wobj = obj:getWheel(wd.wheelID)
    if wobj and wobj.setBrakeSpring then
      local spring = base.brakeSpring or 10
      wobj:setBrakeSpring(math.max(newBrake, newPark, 1) * spring * springGain)
    end
  end
  local maxT = math.max(newBrake, newPark, 1)
  local inD = math.max(0.002, (base.pressureInDelay or 0.04) / (math.max(mult, 1) * pressureGain))
  local outD = base.pressureOutDelay or 0.04
  local dtPhys = (obj.getPhysicsDt and obj:getPhysicsDt()) or 0.002
  local inRate = maxT / (inD + 1e-30)
  local outRate = maxT / (outD + 1e-30)
  if newLinearSmoothing then
    wd.brakePressureDelay = newLinearSmoothing(dtPhys, inRate, outRate)
  elseif wd.brakePressureDelay and wd.brakePressureDelay.reset then
    wd.brakePressureDelay:reset()
  end
end

local function foreachWheelRotator(fn)
  if not wheels or not fn then return end
  local rotCount = wheels.wheelRotatorCount or 0
  if rotCount > 0 and wheels.wheelRotators then
    for i = 0, rotCount - 1 do
      fn(wheels.wheelRotators[i], i)
    end
  elseif wheels.wheels then
    for i, wd in pairs(wheels.wheels) do
      fn(wd, i)
    end
  end
end

local function getDrivePresetHardBrakePedalScale()
  local gain = M._drivePresetHardBrakeGain
  if not gain or gain <= 0 or not _G.CheatMenu_DriveCheatEnabled then return 1 end
  local brake = electrics.values and electrics.values.brake or 0
  local th = M._drivePresetHardBrakeThreshold or 0.38
  if brake <= th then return 1 end
  local t = math.min(1, (brake - th) / math.max(0.1, 1 - th))
  return 1 + t * gain
end

local function applyDrivePresetHardEngineBrake()
  local boost = M._drivePresetHardEngineBrakeBoost
  if not boost or boost <= 1.001 or not _G.CheatMenu_DriveCheatEnabled then return end
  local base = M._drivePresetBaseEngineBrake or state.engineBrakeMultiplier or 1
  local brake = electrics.values and electrics.values.brake or 0
  local th = M._drivePresetHardBrakeThreshold or 0.38
  local target = base
  if brake > th then
    local t = math.min(1, (brake - th) / math.max(0.1, 1 - th))
    target = base * (1 + t * (boost - 1))
  end
  if math.abs((state.engineBrakeMultiplier or 1) - target) < 0.015 then return end
  state.engineBrakeMultiplier = target
  if applyPowerMultiplier then applyPowerMultiplier() end
end

local function applyBrakeMultiplier()
  local isModified = math.abs(state.brakeMultiplier - 1) > 0.001
  if not isModified and not activeFlags.brakes then return end
  if not wheels then return end

  M._drivePresetCurrentPedalBrakeScale = getDrivePresetHardBrakePedalScale()
  local mult = (state.brakeMultiplier or 1) * (M._drivePresetBrakeExtraMult or 1)
      * (M._drivePresetCurrentPedalBrakeScale or 1)
  foreachWheelRotator(function(wd, idx)
    local base = ensureWheelBrakeBase(wd, idx)
    if base then
      applyBrakeTorqueToWheel(wd, base, isModified and mult or 1)
    end
  end)

  activeFlags.brakes = isModified
end

local function applyMassMultiplier()
  local isModified = math.abs(state.massMultiplier - 1) > 0.001
  if not isModified and not activeFlags.mass then return end

  -- БЕЗОПАСНЫЙ ДИАПАЗОН МАССЫ (от 0.75x до 50.0x)
  -- Ниже 0.75x рвутся пружины, выше 50.0x (75 тонн) расплющиваются шины под гравитацией
  if state.massMultiplier < 0.75 then
    state.massMultiplier = 0.75
  elseif state.massMultiplier > 50.0 then
    state.massMultiplier = 50.0
  end

  if next(nodeMassBaseData) == nil then
    if not v or not v.data or not v.data.nodes then return end
    for cid, node in pairs(v.data.nodes) do 
      if type(cid) == "number" and isBodyNode(node) then 
        nodeMassBaseData[cid] = node.nodeWeight or 1 
      end 
    end
  end

  for cid, baseMass in pairs(nodeMassBaseData) do 
    local safeMass = baseMass * state.massMultiplier
    obj:setNodeMass(cid, safeMass) 
  end
  activeFlags.mass = isModified
end

local function applyGravityMultiplier()
  local isModified = math.abs(state.gravityMultiplier - 1) > 0.001
  if not isModified and not activeFlags.gravity then return end
  if gravityBaseValue == nil then gravityBaseValue = obj:getGravity() end
  obj:setGravity(gravityBaseValue * state.gravityMultiplier)
  activeFlags.gravity = isModified
end

-- new gear multiplier
local function applyGearingMultiplier()
  local isModified = math.abs(state.gearMultiplier - 1) > 0.001
  if not isModified and not activeFlags.gearing then return end

  local gearboxes = {}
  local motors = {}
  
  -- Собираем все нужные компоненты из powertrain, вместо поиска только по категории "gearbox"
  if powertrain and powertrain.getDevices then
    for _, device in pairs(powertrain.getDevices()) do
      -- Подхватываем любые коробки и редукторы электромоторов (singleSpeedGearbox, reductionGearbox и т.д.)
      if device.gearRatios or device.gearRatio then
        table.insert(gearboxes, device)
      end
      -- Собираем моторы для изменения cumulativeGearRatio (важно для силы рекуперации в EV)
      if device.cumulativeGearRatio then
         table.insert(motors, device)
      end
    end
  end

  -- Инициализация базовых значений, если они еще не записаны
  if next(gearingBaseData) == nil then
    for _, device in ipairs(gearboxes) do
      gearingBaseData[device.name] = {
        gearRatios = device.gearRatios and deepcopy(device.gearRatios) or nil,
        minGearRatio = device.minGearRatio,
        maxGearRatio = device.maxGearRatio,
        gearRatio = device.gearRatio
      }
    end
    for _, motor in ipairs(motors) do
      gearingBaseData[motor.name .. "_motor"] = {
        cumulativeGearRatio = motor.cumulativeGearRatio
      }
    end
  end

  -- Применяем множитель к коробкам и редукторам
  for _, device in ipairs(gearboxes) do
    local base = gearingBaseData[device.name]
    if base then
      if base.gearRatios and device.gearRatios then
        for i, ratio in pairs(base.gearRatios) do
          device.gearRatios[i] = ratio * state.gearMultiplier
        end
      end
      if base.minGearRatio then device.minGearRatio = base.minGearRatio * state.gearMultiplier end
      if base.maxGearRatio then device.maxGearRatio = base.maxGearRatio * state.gearMultiplier end
      if base.gearRatio then device.gearRatio = base.gearRatio * state.gearMultiplier end
    end
  end
  
  -- Применяем множитель к моторам, чтобы электромобили не сходили с ума при торможении двигателем
  for _, motor in ipairs(motors) do
    local base = gearingBaseData[motor.name .. "_motor"]
    if base and base.cumulativeGearRatio then
      motor.cumulativeGearRatio = base.cumulativeGearRatio * state.gearMultiplier
    end
  end
  
  activeFlags.gearing = isModified
end

local function applyTimeScale()
  local isModified = math.abs(state.timeScale - 1) > 0.001
  
  -- Изменяем скорость игры ТОЛЬКО если чит реально включен (не равен 1)
  -- ИЛИ если мы явно отключаем ранее активный чит (сбрасываем activeFlags)
  if isModified or activeFlags.timeScale then
    obj:queueGameEngineLua(string.format("be:setSimulationTimeScale(%g)", state.timeScale))
  end
  
  activeFlags.timeScale = isModified
end

local function applyInvulnerability()
  local isModified = math.abs(state.invulnerableMultiplier - 1) > 0.001
  if not isModified and not activeFlags.invulnerable then return end
  if not v or not v.data then return end

  -- 1. Инициализация кэша балок (Beams)
  if next(beamBaseData) == nil and v.data.beams then
    for _, beam in pairs(v.data.beams) do
      if beam and beam.cid ~= nil then
        beamBaseData[beam.cid] = { 
          strength = beam.beamStrength or math.huge, 
          deform = beam.beamDeform or math.huge
        }
      end
    end
  end

  -- 2. Инициализация кэша торсионов (Torsionbars)
  if next(torsionBaseData) == nil and v.data.torsionbars then
    for _, tor in pairs(v.data.torsionbars) do
      if tor and tor.cid ~= nil then
        torsionBaseData[tor.cid] = {
          strength = tor.strength or math.huge,
          deform = tor.deform or math.huge
        }
      end
    end
  end

  -- ИСПРАВЛЕНИЕ ВЗРЫВА: Безопасное умножение с защитой от переполнения физики
  local function getSafeValues(baseVal, multiplier, isGodMode)
    if isGodMode then
      return INVULNERABLE_BEAM_LIMIT
    end
    
    if baseVal >= 1e15 or baseVal == math.huge then 
      return baseVal 
    end
    
    local target = baseVal * multiplier
    return math.min(target, INVULNERABLE_BEAM_LIMIT)
  end

  local isGodMode = (state.invulnerableMultiplier >= 10)

  -- 3. Применение брони к балкам
  for cid, base in pairs(beamBaseData) do
    if isModified then
      local tStrength = getSafeValues(base.strength, state.invulnerableMultiplier, isGodMode)
      local tDeform = getSafeValues(base.deform, state.invulnerableMultiplier, isGodMode)
      obj:setBeamStrength(cid, tStrength)
      obj:setBeamDeform(cid, tDeform)
    else
      obj:setBeamStrength(cid, base.strength)
      obj:setBeamDeform(cid, base.deform)
    end
  end

  -- 4. Применение брони к торсионам (руль, стабилизаторы)
  if type(obj.setTorsionbarStrength) == "function" then
    for cid, base in pairs(torsionBaseData) do
      if isModified then
        local tStrength = getSafeValues(base.strength, state.invulnerableMultiplier, isGodMode)
        local tDeform = getSafeValues(base.deform, state.invulnerableMultiplier, isGodMode)
        obj:setTorsionbarStrength(cid, tStrength)
        obj:setTorsionbarDeform(cid, tDeform)
      else
        obj:setTorsionbarStrength(cid, base.strength)
        obj:setTorsionbarDeform(cid, base.deform)
      end
    end
  end
  activeFlags.invulnerable = isModified
end

local function applySuperTires(enabled)
  state.superTires = enabled
  if not enabled and not activeFlags.superTires then return end
  if not wheels or not wheels.wheels then return end

  if beamstate and type(beamstate.deflateTire) == "function" then
    if not beamstate._origDeflateTire then
      beamstate._origDeflateTire = beamstate.deflateTire
    end
    if enabled then
      beamstate.deflateTire = function(wheelid, energy)
        return
      end
    else
      beamstate.deflateTire = beamstate._origDeflateTire
    end
  end

  if enabled and next(tireBeams) == nil then
    local nodeToWheel = {}
    local treadNodes = {}
    local wheelNodes = {}
    
    for wIdx, wheel in pairs(wheels.wheels or {}) do
      local tNodes = wheel.treadNodes or wheel.nodes or {}
      for _, nid in ipairs(tNodes) do 
        treadNodes[nid] = true 
        wheelNodes[nid] = true
        nodeToWheel[nid] = wIdx
      end
      if wheel.node1 then 
        wheelNodes[wheel.node1] = true 
        nodeToWheel[wheel.node1] = wIdx
      end
      if wheel.node2 then 
        wheelNodes[wheel.node2] = true 
        nodeToWheel[wheel.node2] = wIdx
      end
      if wheel.nodeS then 
        wheelNodes[wheel.nodeS] = true 
        nodeToWheel[wheel.nodeS] = wIdx
      end
    end
    
    if v.data.beams then
      for _, beam in pairs(v.data.beams) do
        if beam.cid ~= nil then
          local isTireTread = treadNodes[beam.id1] and treadNodes[beam.id2]
          local isWheelAssembly = wheelNodes[beam.id1] or wheelNodes[beam.id2]
          
          if isWheelAssembly then
            local wIdx = nodeToWheel[beam.id1] or nodeToWheel[beam.id2]
            tireBeams[beam.cid] = {
              strength = beam.beamStrength or math.huge,
              deform = beam.beamDeform or math.huge,
              isTireTread = isTireTread,
              wheelIdx = wIdx
            }
          end
        end
      end
    end
  end

  for cid, base in pairs(tireBeams) do
    if enabled then
      obj:setBeamStrength(cid, math.huge)
      obj:setBeamDeform(cid, math.huge)
    else
      obj:setBeamStrength(cid, base.strength)
      obj:setBeamDeform(cid, base.deform)
      obj:setBeamLengthRefRatio(cid, 1.0)
    end
  end

  for _, wheel in pairs(wheels.wheels) do
    if enabled then
      wheel.tireBurstAV = math.huge
      wheel.tireStrength = math.huge
      wheel.tireDeform = math.huge
      wheel.isBroken = false
      wheel.isInflated = true
      if wheel.setPressure then
        wheel:setPressure(220000)
      end
    else
      wheel.tireBurstAV = nil
      wheel.tireStrength = nil
      wheel.tireDeform = nil
    end
  end

  activeFlags.superTires = enabled
end

local function applyEnvironment()
  local isModified = math.abs(state.dragMultiplier - 1) > 0.001
  if not isModified and not activeFlags.environment then return end

  local targetAirDensity = 1.204 * state.dragMultiplier
  
  local geCode = string.format([[
    local li = scenetree.findObject("LevelInfo")
    if li then
      li:setField("airDensity", "", "%g")
      li:postApply()
    end
  ]], targetAirDensity)
  
  obj:queueGameEngineLua(geCode)
  activeFlags.environment = isModified
end

local function applyDragAndCompensate()
  applyEnvironment()
  applyPowerMultiplier() -- Перезапускаем расчет мощности для компенсации кислорода
end

-- Freins "chauds" : freezeThermals à 20°C = efficacité ~0 (ABS oui, freinage non)
local DRIVE_PRESET_BRAKE_OPT_TEMP = 420
local DRIVE_PRESET_BRAKE_OPT_TEMP_SCINTILLA = 520

local function enforceBrakeThermalEfficiency()
  if not wheels then return end
  local n = wheels.wheelRotatorCount or 0
  if not wheels.wheelRotators or n <= 0 then return end
  for i = 0, n - 1 do
    local wd = wheels.wheelRotators[i]
    if wd then
      wd.brakeThermalEfficiency = 1
      wd.padGlazingFactor = 0
      wd.isBrakeMolten = false
      if wd.enableBrakeThermals then
        local t = (M._drivePresetLastCfgId == "scintilla") and DRIVE_PRESET_BRAKE_OPT_TEMP_SCINTILLA
            or DRIVE_PRESET_BRAKE_OPT_TEMP
        wd.brakeSurfaceTemperature = t
        wd.brakeCoreTemperature = t - 25
      end
      if wd.padTemperature ~= nil then
        wd.padTemperature = DRIVE_PRESET_BRAKE_OPT_TEMP
      end
    end
  end
end

function M.enforceDrivePresetBrakes()
  if not _G.CheatMenu_DriveCheatEnabled or not M._drivePresetLastCfg then return end
  enforceBrakeThermalEfficiency()
  if applyBrakeMultiplier and math.abs(state.brakeMultiplier - 1) > 0.001 then
    applyBrakeMultiplier()
  end
  applyDrivePresetHardEngineBrake()
  if M._drivePresetAbsOff and wheels and wheels.setABSBehavior then
    wheels.setABSBehavior("off")
  end
end

-- БЕСКОНЕЧНОЕ ОХЛАЖДЕНИЕ (Заморозка)
local function forceThermalsCooldown()
  if not powertrain then return end
  
  local devices = powertrain.getDevices()
  for _, device in pairs(devices) do
  
  local gb = devices.gearbox
  if gb then
    gb.isBroken = false
    gb.gearDamageThreshold = 999999
    gb.grindingTorque = 0
  end

  local clutch = devices.clutch
  if clutch then
    clutch.isBroken = false
    clutch.clutchRatio = 1 -- Замыкаем сцепление
    clutch.clutchTemperature = 20
    clutch.lockTorque = 9000000 -- Монолит
  end

    -- 1. Охлаждение Двигателя (У него данные хранятся в .thermals)
    if device.thermals then
      device.thermals.coolantTemperature = 20
      device.thermals.oilTemperature = 20
      device.thermals.engineBlockTemperature = 20
      device.thermals.cylinderWallTemperature = 80
      device.thermals.exhaustTemperature = 200
      
      local targetOil = device.oilVolume or device.thermals.oilCapacity or 5
      device.thermals.oilVolume = targetOil
      device.thermals.oilMass = targetOil
      device.thermals.oilLevel = 1
      device.thermals.oilStarvationStatus = 0 
      device.thermals.radiatorFanType = "active"
      device.thermals.isBroken = false
      device.thermals.oilPanBroken = false
      device.thermals.oilRadiatorBroken = false
      device.thermals.lowOilPressure = false
      device.thermals.coolantEfficiency = 1
      device.thermals.pistonRingsDamaged = false


      device.thermals.oilStarvingSevernessZ = 0
      device.thermals.oilStarvingSevernessXY = 0
      device.thermals.oilLubricationCoef = 1
      device.thermals.oilLeakRateOverall = 0
      device.thermals.oilLeakRateGravity = 0
      device.thermals.missingOilDamage = 0

      device.thermals.oilStarvationDamage = 0
      device.thermals.oilStarvationTimer = 0
      device.thermals.engineBlockOutputAV = device.inputAV
        
      electrics.values.oilLevel = 1
      electrics.values.oilLowPressure = 0
      electrics.values.engineRunning = 1
      electrics.values.hasEngine = 1

      device.oilStarvationTimer = 0
      device.oilPanDamage = 0

      -- А ТЕПЕРЬ ЗАМОРАЖИВАЕМ (перенесено внутрь цикла)
      -- Это не даст игре пересчитать эти значения обратно
      device.thermals.updateGFX = function() end 
      device.thermals.update = function() end
    end

    -- из чита
    device.clutchPermanentDamageTempThreshold = 1234567890
    device.clutchCoolingCoef = 1234567890
    device.clutchWarningTemp = 1234567890
    device.clutchMaxSafeTemp = 1234567890

    if device.clutchTemperature ~= nil then
      device.clutchTemperature = 20
      device.clutchEfficiency = 1
      device.energyBuiltup = 0
      
      -- Принудительно удерживаем лимиты, чтобы игра их не сбросила
      device.maxSafeTemperature = 1e14
      device.efficiencyScaleEnd = 1e14
      device.isBroken = false
    end
    if device.clutchWarningTimer then device.clutchWarningTimer = 0 end

  end
  local clutches = powertrain.getDevicesByCategory and powertrain.getDevicesByCategory("clutch") or {}
  for _, device in pairs(clutches) do
    if device.thermals then device.thermals.clutchTemperature = 20 end
  end
  if state.drivePresetActive or state.freezeThermals then
    enforceBrakeThermalEfficiency()
  else
    for _, wheel in pairs(wheels.wheels or {}) do
      wheel.brakeSurfaceTemperature = 20
      wheel.brakeCoreTemperature = 20
      wheel.padTemperature = 20
    end
  end
end

local function applyInfiniteFuel()
  if not energyStorage then return end
  for _, storage in pairs(energyStorage.getStorages() or {}) do
    -- Восполняем бензобаки и электрические батареи
    if storage.type == "fuelTank" or storage.type == "electricBattery" then
      storage:setRemainingRatio(1)
    end
  end
end

local function applyInfiniteN2O()
  if not energyStorage then return end
  for _, storage in pairs(energyStorage.getStorages() or {}) do
    -- Восполняем баллоны с закисью азота
    if storage.type == "n2oTank" then
      storage:setRemainingRatio(1)
    end
  end
end

local function onBeamBroke(id, energy)
  local beam = v.data.beams[id]
  if not beam then return end

  if M._drivePresetCollisionArmor and _G.CheatMenu_DriveCheatEnabled and beam.cid then
    local baseStr = beam.beamStrength or beam.beamDeform or 1e5
    if baseStr <= 0 or baseStr ~= baseStr then baseStr = 1e5 end
    local mult = math.min(state.globalStrengthMult or 85000, 100000)
    local str = math.min(5e8, math.max(2e6, baseStr * mult))
    obj:setBeamStrength(beam.cid, str)
    if obj.setBeamDeform then
      local partName = tostring(beam.partOrigin or "body")
      local baseDef = M.partBeamDeformCache and M.partBeamDeformCache[beam.cid]
      local lim = M.drivePresetCollisionDeformLimit
      if lim then
        obj:setBeamDeform(beam.cid, lim(partName, baseDef, baseStr))
      elseif baseDef and baseDef > 0 then
        obj:setBeamDeform(beam.cid, math.min(baseDef * 1.2, 250000))
      end
    end
    return
  end

  if not state.debrisMultiplier or state.debrisMultiplier <= 1.001 then return end

  local node1 = beam.id1
  local node2 = beam.id2

  -- Преобразуем текстовые имена узлов в числовые индексы (CIDs)
  if type(node1) == "string" and v.data.nodes[node1] then node1 = v.data.nodes[node1].cid end
  if type(node2) == "string" and v.data.nodes[node2] then node2 = v.data.nodes[node2].cid end

  if type(node1) == "number" and type(node2) == "number" then
    local multiplier = math.floor(state.debrisMultiplier) - 1
    if multiplier <= 0 then return end
    
    -- Ограничиваем спавн на одну балку, чтобы избежать зависания игры на слабых ПК
    local maxSpawns = math.min(multiplier, 50)

    -- Генерируем частицы:
    -- ID 1: Sparks (Искры)
    -- ID 12: Splinters (Куски пластика/металла)
    -- ID 68: Glass shards (Осколки стекла)
    obj:addParticleByNodes(node1, node2, -1, 1, 0.5, maxSpawns * 2)  -- Множество искр
    obj:addParticleByNodes(node1, node2, -1, 12, 0.7, maxSpawns * 2) -- Осколки обшивки
    obj:addParticleByNodes(node1, node2, -1, 68, 0.6, maxSpawns)     -- Бьющееся стекло
  end
end

local function healDrivetrain()
  local noop = function() end -- Безопасная заглушка
  if not powertrain or not powertrain.getDevices then return end
  
  local devices = powertrain.getDevices()
  for _, device in pairs(devices) do
    -- 1. Глобальный сброс флагов разрушения для любого устройства (shaft, diff, engine)
    device.isBroken = false
    device.isPhysicallyDisconnected = false
    if device.damage then device.damage = 0 end
    if device.wear then device.wear = 0 end
    
    -- БЕССМЕРТНЫЕ КАРДАНЫ И ПРИВОДА (shaft, halfshaft, driveshaft)
    if device.type == "shaft" or device.type == "splitShaft" or device.type == "multiShaft" then
      -- Сохраняем оригинальный триггер поломки и отключаем его действие
      if device.onBreak and device._origOnBreak == nil then
        device._origOnBreak = device.onBreak
        device.onBreak = function() end
      end
      -- Принудительно подключаем вал обратно в симуляцию трансмиссии (если он был отключен)
      if type(device.setMode) == "function" then
        device:setMode("connected")
      end
    end

    -- Очистка деформационных групп (предотвращает отрыв деталей)
    if device.deformGroupDamages then
      for k in pairs(device.deformGroupDamages) do device.deformGroupDamages[k] = 0 end
    end
    if device.deformGroupLastDamages then
      for k in pairs(device.deformGroupLastDamages) do device.deformGroupLastDamages[k] = 0 end
    end
    -- Используем заглушку вместо kek
    device.applyDeformGroupDamageRadiator = noop
    device.applyDeformGroupDamageOilpan = noop
    device.applyDeformGroupDamageOilRadiator = noop
    device.setPartConditionRadiator = noop
    device.setPartConditionExhaust = noop
    
    if device.thermals then
      device.thermals.applyDeformGroupDamageRadiator = noop
    end
    
    device.stallTimerReached = false          -- Дополнительный флаг, который иногда проверяет игра
    device.engineDisabled = false             -- Явно разрешаем работу
    device.engineRunning = true               -- Принудительно ставим статус "работает"

    device.maxPhysicalAV = 1234567890
    device.maxTorqueRating = 1234567890
    device.maxOverTorqueDamage = 1234567890
    device.gearDamageThreshold = 1234567890
    device.canFlood = false

    -- 2. Улучшенный фикс двигателя
    if device.category == "engine" then
      
      -- 2. Принудительное подавление воды
      if device.waterDamageNodes then
        -- Обнуляем данные о попадании воды в узлы
        for _, node in pairs(device.waterDamageNodes) do
           -- В некоторых версиях физики это просто сбрасывает состояние
        end
      end
      
      -- 3. Принудительная работа двигателя
      if device.thermals then
        device.thermals.isBroken = false
        device.thermals.cylinderWallsMelted = false
        -- Сброс состояния "залитости"
        device.thermals.oilStarvationDamage = 0
        device.thermals.oilStarvationTimer = 0
      end

      device.ignitionCoef = 1
      device.engineDisabled = false
      device.airIntakeBlocked = false
      device.catastrophicFailure = false
      device.isHydrolocked = false
      device.isDisabled = false
      device.starterDisabled = false      -- Разрешаем стартер
      
      -- Принудительное обнуление всех полей, отвечающих за поломки
      device.rodBearingsDamaged = false
      device.connectingRodBearingsDamaged = false
      device.pistonRingsDamaged = false
      device.pistonRingsBroken = false
      device.headGasketBlown = false
      device.oilPanBroken = false
      
      -- 3. Полная очистка Термостата и Термальных повреждений
      if device.thermals then
        local t = device.thermals
        t.isBroken = false
        t.cylinderWallsMelted = false
        t.engineBlockMelted = false
        t.coolantLeakRateHeadGasket = 0
        t.coolantLeakRateRadiator = 0
        t.oilLeakRateOverall = 0
        t.oilStarvationDamage = 0
        t.oilStarvationTimer = 0
        t.oilStarvationStatus = 0
        t.cylinderWallOverheatDamage = 0
        t.engineBlockOverheatDamage = 0
        
        -- Стабилизация жидкостей
        t.oilMass = t.oilCapacity or 5
        t.oilVolume = t.oilCapacity or 5
        t.coolantTemperature = 20
        t.oilTemperature = 20
        t.engineBlockTemperature = 20
        t.exhaustTemperature = 200
      end

      -- Сброс штрафов трения
      device.damageFrictionCoef = 1
      device.damageDynamicFrictionCoef = 1
      device.wearFrictionPenalty = 0
      
      -- Принудительная работа
      if device.starterDisabled then device.starterDisabled = false end
      if device.inputAV < 50 and not state.drivePresetActive then device.inputAV = 100 end
    end
    
    -- 4. Фикс дифференциалов и валов (LS-блокировки и поломки)
    if device.type == "differential" or device.type == "shaft" then
       device.isPhysicallyDisconnected = false
       if device.lockTorque then device.lockTorque = device.lockTorque end -- Фикс для Lsd
    end
  end
  
  -- 5. Электрика (Dashboard)
  if electrics and electrics.values then
    electrics.values.oilLevel = 1
    electrics.values.engineRunning = 1
    electrics.values.oilLowPressure = 0
    electrics.values.checkEngine = 0
    if electrics.values.ignitionLevel and electrics.values.ignitionLevel < 2 then 
        electrics.values.ignitionLevel = 2 
    end
  end
end

local function applyCheatState()
  applySuperTires(state.superTires)
  applyInvulnerability()
  local powerApplied = applyPowerMultiplier()
  applyGripMultiplier()
  applyBrakeMultiplier()
  applyMassMultiplier()
  applyGravityMultiplier()
  applyGearingMultiplier()
  applyEnvironment()
  applyAWD(state.awdMode)
  applyTimeScale()
  applyRPMMultiplier()
  return powerApplied
end

-- ИНТЕРФЕЙС И СОСТОЯНИЯ

local function resetCheats()


  state.indestructibleEngine = false
  state.invulnerableMultiplier = 1
  state.freezeThermals = false
  state.infiniteFuel = false
  state.infiniteN2O = false
  state.awdMode = false
  state.rainbowMode = false
  state.highShadows = false
  state.underwaterMode = false
  state.infiniteJato = false
  state.superTires = false
  state.espMode2 = false
  state.powerMultiplier = 1
  state.gripMultiplier = 1
  state.gravityMultiplier = 1
  state.brakeMultiplier = 1
  state.massMultiplier = 1
  state.engineBrakeMultiplier = 1
  state.dragMultiplier = 1
  state.gearMultiplier = 1
  state.timeScale = 1
  state.shadowMultiplier = 1
  state.jatoMultiplier = 1
  state.rpmMultiplier = 1
  state.drivePresetActive = false
  state.drivePresetTorqueProfile = nil
  state.drivePresetStabilityAssist = false
  M._drivePresetStabilityGain = 1.0
  M._drivePresetYawDampGain = 0
  M._drivePresetTcsMaxSpeed = 32
  M._drivePresetLastCfgId = nil
  M._drivePresetStabilitySteerMax = 0.3
  M._drivePresetLaunchRampSec = 0
  M._drivePresetLaunchBlend = 0
  M._drivePresetLaunchPowerAcc = 0
  M._drivePresetTorqueLowScale = 1.0
  M._drivePresetTcsStrength = 1.0
  M._drivePresetDownforceGain = 0
  M._drivePresetDisableTireMorph = false
  M._drivePresetPauseEsc = false
  M._drivePresetGripRefreshAcc = 0
  M._drivePresetAbsOff = false
  M._drivePresetBrakeExtraMult = 1
  M._drivePresetBrakePressureGain = 1
  M._drivePresetBrakeSpringGain = 1
  M._drivePresetHardBrakeThreshold = nil
  M._drivePresetHardBrakeGain = nil
  M._drivePresetHardBrakePressureBoost = nil
  M._drivePresetHardEngineBrakeBoost = nil
  M._drivePresetBaseEngineBrake = nil
  M._drivePresetCurrentPedalBrakeScale = 1
  M._drivePresetCollisionArmor = false
  M._drivePresetCollisionRefreshAcc = 0
  M._drivePresetDisableTcs = false
  M._drivePresetWl40BypassGovernor = false
  M._drivePresetTorqueBlend = 1
  M._drivePresetWheelClampFrames = 0
  M._drivePresetPendingPower = nil
  M._drivePresetPowerUnlockFrames = 0
  M._drivePresetInputReleaseFrames = 0
  if M.releaseDrivePresetPlayerInput then M.releaseDrivePresetPlayerInput() end
  if M._drivePresetAbsOff and wheels and wheels.resetABSBehavior then
    wheels.resetABSBehavior()
  end
  M._drivePresetAbsOff = false
  state.debrisMultiplier = 1
  state.carScaleMultiplier = 1.0
  state.carLengthMultiplier = 1.0      -- Добавлено
  state.carWidthMultiplier = 1.0       -- Добавлено
  state.carThicknessMultiplier = 1.0   -- Добавлено
  state.camberOffset = 0.0
  state.wheelOffset = 0.0
  state.suspensionSpringMultiplier = 1.0
  state.suspensionDampMultiplier = 1.0
  state.pedalThrustForce = 0.0
  state.thrustX = 0.0
  state.thrustY = 0.0
  state.thrustZ = 0.0
  state.stickyGrip = false
  state.stickyGripForce = 0.2
  state.pedalBrakeForce = 0.0

  state.flyMode = false
  state.flyHover = true
  state.flySpeed = 15.0
  state.flyPitch = 0.0
  state.flyYaw = 0.0
  state.flyRoll = 0.0
  
  state.suspensionHeightMultiplier = 1.0
  state.suspensionDampMultiplier = 1.0
  
  M.partScaleTargets = {}
  M.partOffsetTargets = {}


  M.scanCamberBeams()

  -- Отключаем ИИ следования по GPS, если он был активен
  if state.followGPSMode then
    local geCode = [[
      local playerVeh = be:getPlayerVehicle(0)
      if playerVeh then 
        playerVeh:queueLuaCommand("if ai then ai.setState({mode = 'disabled'}) end") 
      end
    ]]
    obj:queueGameEngineLua(geCode)
    state.followGPSMode = false
  end

  state.suspensionHeightMultiplier = 1.0
  currentSuspensionHeight = 1.0
  isSuspensionMorphingActive = false

  applyShadowQuality(1) 

  -- Сброс масштаба машины через carscaler к исходному
  local geCode = [[
    if core_vehicle_partmgmt then
      core_vehicle_partmgmt.setConfig({carscaler = {}, partscaler = {}}, true)
    end
  ]]
  obj:queueGameEngineLua(geCode)




  -- ВОССТАНОВЛЕНИЕ ОРИГИНАЛЬНЫХ ТРИГГЕРОВ ПОЛОМКИ ВАЛОВ
  if powertrain and powertrain.getDevices then
    for _, device in pairs(powertrain.getDevices()) do
      if device._origOnBreak then
        device.onBreak = device._origOnBreak
        device._origOnBreak = nil
      end
    end
  end

  if rainActive then applyWeatherEffect("rain", false, 0); rainActive = false end
  if snowActive then applyWeatherEffect("snow", false, 0); snowActive = false end
  state.dynamicRain = false
  state.dynamicSnow = false
  
  -- Возвращаем нормальный расход JATO
  if controller and controller.getController then
    local jatoCtrl = controller.getController("jato")
    if jatoCtrl then jatoCtrl.fuelCoef = 1 end
  end
  


  regenEnabled = false
  regenCancelled = false
  regenTime = 0
  regenBeamStates = {}
  regenBeamCache = {}
  local regenEnabled = false
  local regenRate = 0.05 -- (Увеличил с 0.025 до 0.05 для чуть более быстрой починки, можешь вернуть если хочешь)
  local repairErrorMargin = 0.0015
  local regenTime = 0
  local regenBeamStates = {}
  local regenBeamCache = {}
  local regenProgress = 0
  local regenCancelled = false



  applyCheatState()
  showStatusMessage("Cheat Menu: All cheats reset to NORMAL", "codeCheatMenuReset")
end

local jatoReinforced = false

-- Функция для поиска JATO балок и установки им бесконечной прочности (безопасно, без изменения жесткости)
local function makeJatoIndestructible()
  if jatoReinforced then return end
  if not v.data or not v.data.nodes or not obj then return end

  local jatoNodes = {}

  -- 1. Находим все узлы конструкции JATO
  for name, node in pairs(v.data.nodes) do
    if string.find(string.lower(name), "jato") then
      jatoNodes[node.cid] = true
    end
  end

  -- 2. Дополнительно сканируем узлы, указанные в thrusters
  if v.data.thrusters then
    for _, t in pairs(v.data.thrusters) do
      if t.control == "jato" then
        local cid1 = t.id1
        local cid2 = t.id2
        if type(cid1) == "string" and v.data.nodes[cid1] then cid1 = v.data.nodes[cid1].cid end
        if type(cid2) == "string" and v.data.nodes[cid2] then cid2 = v.data.nodes[cid2].cid end
        if type(cid1) == "number" then jatoNodes[cid1] = true end
        if type(cid2) == "number" then jatoNodes[cid2] = true end
      end
    end
  end

  -- Если узлы JATO не найдены, прекращаем выполнение
  if next(jatoNodes) == nil then return end

  -- 3. Проходим по всем балкам машины. Если балка соединена с узлом JATO, делаем её неразрушимой
  if v.data.beams then
    for _, b in pairs(v.data.beams) do
      local cid1 = b.id1
      local cid2 = b.id2
      if type(cid1) == "string" and v.data.nodes[cid1] then cid1 = v.data.nodes[cid1].cid end
      if type(cid2) == "string" and v.data.nodes[cid2] then cid2 = v.data.nodes[cid2].cid end

      if (type(cid1) == "number" and jatoNodes[cid1]) or (type(cid2) == "number" and jatoNodes[cid2]) then
        if b.cid then
          -- Делаем балку бесконечно прочной на разрыв и деформацию.
          -- Это на 100% безопасно и не вызывает багов/вылетов физики.
          obj:setBeamStrength(b.cid, 1e20)
          obj:setBeamDeform(b.cid, 1e20)
        end
      end
    end
    jatoReinforced = true
  end
end

-- Функция ручного применения физической силы для обхода лимитов JATO
local function applyExtraJatoThrust()
  if state.jatoMultiplier <= 1.001 then return end
  local jatoVal = electrics.values.jato or 0
  if jatoVal <= 0.01 then return end
  
  -- Упрочняем JATO при первом применении силы
  makeJatoIndestructible()
  
  if v.data and v.data.thrusters then
    local extraMult = state.jatoMultiplier - 1
    for _, t in pairs(v.data.thrusters) do
      if t.control == "jato" then
        local factor = t.factor or t.engineForce or 0
        -- Считаем, сколько "сверх-силы" нужно добавить машине
        local force = factor * jatoVal * extraMult
        
        if force ~= 0 then
          local cid1 = t.id1
          local cid2 = t.id2
          -- Преобразуем текстовые ID узлов в числовые (CIDs)
          if type(cid1) == "string" and v.data.nodes[cid1] then cid1 = v.data.nodes[cid1].cid end
          if type(cid2) == "string" and v.data.nodes[cid2] then cid2 = v.data.nodes[cid2].cid end
          
          if type(cid1) == "number" and type(cid2) == "number" then
            -- Физически толкаем машину вперед по оси сопел JATO
            if obj and obj.applyForce then
              obj:applyForce(cid2, cid1, force)
            end
          end
        end
      end
    end
  end
end

-- ФУНКЦИИ РЕГЕНЕРАЦИИ МАШИНЫ
local function getBeamPartOrigin(beam, getEndNode)
  local partOrigin = nil
  if not getEndNode then
    if v.data.nodes[beam.id1] then partOrigin = v.data.nodes[beam.id1].partOrigin end
  else
    if v.data.nodes[beam.id2] then partOrigin = v.data.nodes[beam.id2].partOrigin end
  end
  return partOrigin or ""
end

local function validRegenPart(partName)
  local isValid = true
  local po = partName:lower()
  if po:find("driveshaft") or po:find("coilover") or po:find("suspension") or po:find("steering") or po:find("swaybar") or po:find("brake") or po:find("spring") or po:find("wheel") then isValid = false end
  return isValid
end

local function cancelRegenerate()
  regenEnabled = false
  regenCancelled = true
  showStatusMessage("Cheat Menu: Regeneration Cancelled.")
end

local function startRegenerate()
  if regenEnabled then return end
  regenCancelled = false
  
  -- Сброс характеристик балок (пропускаем активные балки подвески, чтобы не ломать высоту/жесткость)
  for _, beam in pairs(v.data.beams) do
    if not suspensionBeams[beam.cid] then
      obj:setBeamSpringDamp(beam.cid, beam.beamSpring or -1, beam.beamDamp or -1, beam.springExpansion or -1, beam.dampExpansion or -1)
    end
  end
  
  regenBeamStates = {}
  regenBeamCache = {}
  regenTime = 0
  
  -- Собираем кэш деформированных деталей
  for _, beam in pairs(v.data.beams) do
    local isValid = validRegenPart(getBeamPartOrigin(beam, false)) and validRegenPart(getBeamPartOrigin(beam, true)) and (beam.beamType == 0 or beam.beamType == 2)
    if not isValid or obj:beamIsBroken(beam.cid) then goto nextBeam end
    
    local currentLengthRatio = obj:getBeamLengthRefRatio(beam.cid)
    if currentLengthRatio < 0.001 then goto nextBeam end
    
    local currentLength = obj:getBeamLength(beam.cid)
    if currentLength < 0.001 then goto nextBeam end
    
    table.insert(regenBeamCache, beam)
    
    ::nextBeam::
  end
  
  regenEnabled = true
  showStatusMessage("Cheat Menu: Regeneration Started...")
end

local function doRegen(dt)
    local bt = 1
    if bullettime and bullettime.get then bt = bullettime.get() end
    local timeScaledRate = (regenRate * bt) * dt
    local numFull = 0
    local numTotal = 0
    
    for _, beam in pairs(regenBeamCache) do
      numTotal = numTotal + 1
      
      local currentLengthRatio = obj:getBeamLengthRefRatio(beam.cid)
      local currentLength = obj:getBeamLength(beam.cid)
      local targetLength = (currentLength / currentLengthRatio)
      local remainingLengthChange = math.abs(targetLength - currentLength)
      local lengthScaledRate = math.min(timeScaledRate / targetLength, math.abs(1 - currentLengthRatio))
      
      if remainingLengthChange < math.max(repairErrorMargin, repairErrorMargin * (regenTime / 30)) then
        regenBeamStates[beam.cid] = true
        numFull = numFull + 1
        goto nextBeam
      end
      
      if currentLength < targetLength then
        obj:setBeamLengthRefRatio(beam.cid, currentLengthRatio + lengthScaledRate)
      else
        obj:setBeamLengthRefRatio(beam.cid, currentLengthRatio - lengthScaledRate)
      end
      
      ::nextBeam::
    end
    
    regenProgress = numFull / numTotal
    if numFull == numTotal then 
      regenEnabled = false 
      if material and material.reset then material.reset() end -- Восстанавливает разбитые стекла
      showStatusMessage("Cheat Menu: Regeneration Complete!")
    end
end


-- ГЕНЕРАТОРЫ МЕНЮ

local function addRootCategory(entries)
  local entry = { title = "Cheat Menu", ["goto"] = CHEAT.ROOT, icon = "infinity", uniqueID = "codeCheatMenuRoot", categoryOrder = 30, ignoreAsRecentAction = true }
  if hasActiveCheat() then entry.color = "#ff9d2f" end
  table.insert(entries, entry)
end


-- PRESETS (no new locals - functions in M table to stay under 200 local limit)
function M._getSlotLabel(i)
  if _G and _G.CheatMenu_PresetSlotsInfo then
    local info = _G.CheatMenu_PresetSlotsInfo[i]
    if info and info.name and info.name ~= "" then return info.name end
  end
  return nil
end

function M._presetsGenerator(entries)
  for i = 1, 5 do
    local label = M._getSlotLabel(i)
    table.insert(entries, {
      title = label and ("Slot " .. i .. ": " .. label) or ("Slot " .. i .. " (empty)"),
      desc = "Save / Load config preset",
      icon = "star",
      uniqueID = "codeCheatPresetSlot" .. i,
      ["goto"] = CHEAT.ROOT .. "presets/slot" .. i .. "/",
      color = label and "#4cff93" or nil,
    })
  end
end

function M._presetSlotGenerator(slotIdx, entries)
  local label = M._getSlotLabel(slotIdx)
  table.insert(entries, {
    title = "Save here",
    desc = "Save current vehicle config to this slot",
    icon = "wrench",
    uniqueID = "codeCheatPresetSave" .. slotIdx,
    onSelect = function()
      local keys = {"powerMultiplier","gripMultiplier","brakeMultiplier","gravityMultiplier","massMultiplier","engineBrakeMultiplier","dragMultiplier","gearMultiplier","rpmMultiplier","invulnerableMultiplier","jatoMultiplier","timeScale","suspensionHeightMultiplier"}
      local snap = {}
      for _, k in ipairs(keys) do snap[k] = state[k] end
      obj:queueGameEngineLua(string.format(
        "if extensions.cheatMenuu and extensions.cheatMenuu.savePresetSlot then extensions.cheatMenuu.savePresetSlot(%d, [===[%s]===]) end",
        slotIdx, jsonEncode(snap)))
      showStatusMessage("Preset Slot " .. slotIdx .. " saved!")
      return {"reload"}
    end
  })
  if label then
    table.insert(entries, {
      title = "Load: " .. label,
      desc = "Apply this preset to the current vehicle",
      icon = "play",
      uniqueID = "codeCheatPresetLoad" .. slotIdx,
      color = "#4cff93",
      onSelect = function()
        obj:queueGameEngineLua(string.format(
          "if extensions.cheatMenuu and extensions.cheatMenuu.loadPresetSlot then extensions.cheatMenuu.loadPresetSlot(%d, %d) end",
          slotIdx, obj:getID()))
        showStatusMessage("Preset Slot " .. slotIdx .. " loaded!")
        return {"reload"}
      end
    })
    table.insert(entries, {
      title = "Clear slot",
      desc = "Delete the saved config from this slot",
      icon = "vehicleFeatures03",
      uniqueID = "codeCheatPresetClear" .. slotIdx,
      onSelect = function()
        obj:queueGameEngineLua(string.format(
          "if extensions.cheatMenuu and extensions.cheatMenuu.clearPresetSlot then extensions.cheatMenuu.clearPresetSlot(%d) end",
          slotIdx))
        showStatusMessage("Slot " .. slotIdx .. " cleared.")
        return {"reload"}
      end
    })
  end
end

local function addCheatEntries(entries)
  table.insert(entries, {
    title = "Mes Presets",
    desc = "Save / Load your favorite configs",
    icon = "star",
    uniqueID = "codeCheatPresetsMenu",
    ["goto"] = CHEAT.ROOT .. "presets/",
    color = "#a0d8ff",
  })
  table.insert(entries, {
    title = "Career Mode Cheats",
    desc = "Cheats for Career Mode (Money, XP, Free Recovery, etc.)",
    icon = "star",
    uniqueID = "codeCheatCareerMenu",
    ["goto"] = CHEAT.CAREER,
    color = "#ffd700" -- Золотистый цвет кнопки
  })
  table.insert(entries, {
    title = "Visual effects",
    desc = "Rain, Snow, ESP, Rainbow colors, Shadows, and Particles",
    icon = "star", -- Можно использовать любую иконку, поддерживаемую игрой
    uniqueID = "codeCheatVisualsMenuButton",
    ["goto"] = CHEAT.VISUALS,
    color = "#ffffff" -- Золотистый цвет кнопки
  })
  table.insert(entries, {
    title = state.awdMode and "lock AWD RWD: ON" or "lock AWD RWD: OFF",
    desc = "Forces 50/50 torque split and locks differentials",
    icon = "carToWheels",
    uniqueID = "codeCheatAWD",
    color = state.awdMode and "#4cff93" or nil,
    onSelect = function()
      state.awdMode = not state.awdMode
      applyAWD(state.awdMode)
      showStatusMessage("Cheat Menu: AWD " .. (state.awdMode and "ON" or "OFF"))
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = regenEnabled and "Regeneration: ON" or "Regeneration: OFF",
    desc = "ATTENTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! This feature may not work on all vehicles and may cause errors. Press the key combination Ctrl+R if errors occur.",
    icon = "wrench",
    uniqueID = "codeCheatRegen",
    color = regenEnabled and "#ff9d2f" or nil,
    onSelect = function()
      if regenEnabled then
        cancelRegenerate()
      else
        startRegenerate()
      end
      return {"reload"}
    end
  })
  table.insert(entries, { title = string.format("Strength Multiplier: x%g", state.invulnerableMultiplier), desc = "(GOD MODE) Multiply vehicle durability.", icon = "wrench", uniqueID = "codeCheatInvulnMenu", ["goto"] = CHEAT.INVULN, color = (math.abs(state.invulnerableMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, {
    title = state.superTires and "Durable tires: ON" or "Durable tires: OFF",
    desc = "(Experimental) Tires become stronger.",
    icon = "carToWheels",
    uniqueID = "codeCheatSuperTires",
    color = state.superTires and "#4cff93" or nil,
    onSelect = function()
      state.superTires = not state.superTires
      applySuperTires(state.superTires)
      showStatusMessage("Cheat Menu: Super Tires " .. (state.superTires and "ON" or "OFF"))
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = state.indestructibleEngine and "God Mode (Engine + Transmission): ON" or "God Mode (Engine + Transmission): OFF",
    desc = "Engine + Transmission God Mode",
    icon = "wrench",
    uniqueID = "codeCheatIndestructibleEngine",
    color = state.indestructibleEngine and "#4cff93" or nil,
    onSelect = function()
      state.indestructibleEngine = not state.indestructibleEngine
      if state.indestructibleEngine then
        healDrivetrain()
      end
      showStatusMessage("Cheat Menu: Engine + Transmission God Mode " .. (state.indestructibleEngine and "ON" or "OFF"))
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = state.freezeThermals and "Anti-Overheat: ON" or "Anti-Overheat: OFF",
    desc = "Locks all engine & brake temps at 20°C", icon = "snowflake", uniqueID = "codeCheatFreezeThermals", color = state.freezeThermals and "#4cff93" or nil,
    onSelect = function()
      state.freezeThermals = not state.freezeThermals
      forceThermalsCooldown()
      showStatusMessage("Cheat Menu: Anti-Overheat " .. (state.freezeThermals and "ON" or "OFF"))
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = state.underwaterMode and "Drive underwater: ON" or "Drive underwater: OFF",
    desc = "The engine does not stall or break down in water",
    icon = "snowflake",
    uniqueID = "codeCheatUnderwater",
    color = state.underwaterMode and "#4cff93" or nil,
    onSelect = function()
      state.underwaterMode = not state.underwaterMode
      applyUnderwaterMode(state.underwaterMode)
      showStatusMessage("Cheat Menu: Underwater Mode " .. (state.underwaterMode and "ON" or "OFF"))
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = state.infiniteFuel and "Infinite Fuel: ON" or "Infinite Fuel: OFF",
    desc = "Keeps fuel tank / battery at 100%", 
    icon = "charge", 
    uniqueID = "codeCheatInfiniteFuel", 
    color = state.infiniteFuel and "#4cff93" or nil,
    onSelect = function()
      state.infiniteFuel = not state.infiniteFuel
      showStatusMessage("Cheat Menu: Infinite Fuel " .. (state.infiniteFuel and "ON" or "OFF"))
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = state.infiniteN2O and "Infinite N2O: ON" or "Infinite N2O: OFF",
    desc = "Keeps Nitrous Oxide bottle at 100%", 
    icon = "charge", 
    uniqueID = "codeCheatInfiniteN2O", 
    color = state.infiniteN2O and "#4cff93" or nil,
    onSelect = function()
      state.infiniteN2O = not state.infiniteN2O
      showStatusMessage("Cheat Menu: Infinite N2O " .. (state.infiniteN2O and "ON" or "OFF"))
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = state.infiniteJato and "Infinite JATO: ON" or "Infinite JATO: OFF",
    desc = "Keeps JATO rockets fuel at 100% and prevents drain", 
    icon = "charge", 
    uniqueID = "codeCheatInfiniteJato", 
    color = state.infiniteJato and "#4cff93" or nil,
    onSelect = function()
      state.infiniteJato = not state.infiniteJato
      
      -- Если чит выключается, возвращаем стандартный расход JATO (fuelCoef = 1)
      if not state.infiniteJato and controller and controller.getController then
        local jatoCtrl = controller.getController("jato")
        if jatoCtrl then jatoCtrl.fuelCoef = 1 end
      end
      
      showStatusMessage("Cheat Menu: Infinite JATO " .. (state.infiniteJato and "ON" or "OFF"))
      return {"reload"}
    end
  })
  table.insert(entries, { title = string.format("JATO Power: x%g", state.jatoMultiplier), desc = "Multiply JATO rockets thrust", icon = "charge", uniqueID = "codeCheatJatoPowerMenu", ["goto"] = CHEAT.JATO, color = (math.abs(state.jatoMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Engine Power: x%g", state.powerMultiplier), desc = "Multiply the engine power", icon = "engine", uniqueID = "codeCheatPowerMenu", ["goto"] = CHEAT.POWER, color = (math.abs(state.powerMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("RPM Limit Multiplier: x%g", state.rpmMultiplier), desc = "Multiply the engine redline and maximum RPM limits", icon = "engine", uniqueID = "codeCheatRPMMenu", ["goto"] = CHEAT.RPM, color = (math.abs(state.rpmMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Gear Ratio: x%g", state.gearMultiplier), desc = "x0.5 = High Speed | x2.0 = High Accel", icon = "cogs", uniqueID = "codeCheatGearsMenu", ["goto"] = CHEAT.GEAR, color = (math.abs(state.gearMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Tire Grip: x%g", state.gripMultiplier), desc = "From drift to 100% grip", icon = "carToWheels", uniqueID = "codeCheatGripMenu", ["goto"] = CHEAT.GRIP, color = (math.abs(state.gripMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Brakes Strength: x%g", state.brakeMultiplier), desc = "Brake pad strength", icon = "carToWheels", uniqueID = "codeCheatBrakesMenu", ["goto"] = CHEAT.BRAKES, color = (math.abs(state.brakeMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Air Drag/Wind: x%g", state.dragMultiplier), desc = "Removes air drag (auto-compensates engine)", icon = "carToWheels", uniqueID = "codeCheatDragMenu", ["goto"] = CHEAT.DRAG, color = (math.abs(state.dragMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Engine Brake: x%g", state.engineBrakeMultiplier), desc = "Engine braking force", icon = "carToWheels", uniqueID = "codeCheatEngBrakesMenu", ["goto"] = CHEAT.ENG_BRAKE, color = (math.abs(state.engineBrakeMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Gravity: x%g", state.gravityMultiplier), desc = "Just your car", icon = "weight", uniqueID = "codeCheatGravityMenu", ["goto"] = CHEAT.GRAVITY, color = (math.abs(state.gravityMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Car Weight(Body): x%g", state.massMultiplier), desc = "Just your car", icon = "weight", uniqueID = "codeCheatMassMenu", ["goto"] = CHEAT.MASS, color = (math.abs(state.massMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Simulation Speed: x%g", state.timeScale), desc = "FAST simulation (up to 10x)", icon = "play", uniqueID = "codeCheatTimeScaleMenu", ["goto"] = CHEAT.TIMESCALE, color = (math.abs(state.timeScale - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Suspension Height: x%g", state.suspensionHeightMultiplier), desc = "(Experimental) Change suspension height beyond game limits", icon = "carToWheels", uniqueID = "codeCheatSuspensionMenu", ["goto"] = CHEAT.SUSP, color = (math.abs(state.suspensionHeightMultiplier - 1) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Wheel Diameter: %d\"", electrics.values['wheelSize'] or baseInches), desc = "(Experimental) Change wheel diameter (5 or 100). LIFE HACK!!! If the wheels fly off or explode, you can simultaneously increase the durability multiplier to 100,000x to prevent this", icon = "carToWheels", uniqueID = "codeCheatWheelSizeMenu", ["goto"] = CHEAT.WHEEL_SIZE, color = ((electrics.values['wheelSize'] or baseInches) ~= baseInches) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Wheel Width: %d", electrics.values['wheelWidth'] or 300), desc = "(Experimental) Change wheel width (50 or 1000). LIFE HACK!!! If the wheels fly off or explode, you can simultaneously increase the durability multiplier to 100,000x to prevent this", icon = "carToWheels", uniqueID = "codeCheatWheelWidthMenu", ["goto"] = CHEAT.WHEEL_WIDTH, color = ((electrics.values['wheelWidth'] or 300) ~= 300) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Size Multiplier: x%g", state.carScaleMultiplier), desc = "(Experimental) Scaling of the size of any object. Caution! Don't change values ​​too quickly! Very low or high values ​​may cause errors.", icon = "carToWheels", uniqueID = "codeCheatCarScaleMenu", ["goto"] = CHEAT.CAR_SCALE, color = (math.abs(state.carScaleMultiplier - 1) > 0.001) and "#4cff93" or nil })
  local isPartScaleModified = false
  for _, target in pairs(M.partScaleTargets) do
    if math.abs(target - 1.0) > 0.001 then isPartScaleModified = true; break end
  end
  table.insert(entries, { title = "Part Resizer", desc = "Interactively resize individual vehicle parts(any detail)", icon = "carToWheels", uniqueID = "codeCheatPartScaleMenu", ["goto"] = M.CHEAT_PART_SCALE_ROOT, color = isPartScaleModified and "#4cff93" or nil })
  
  table.insert(entries, { title = string.format("Width Multiplier: x%g", state.carWidthMultiplier or 1.0), desc = "Resize vehicle width independently (X-axis)", icon = "carToWheels", uniqueID = "codeCheatCarWidthMenu", ["goto"] = M.CHEAT_CAR_WIDTH_ROOT, color = (math.abs((state.carWidthMultiplier or 1.0) - 1.0) > 0.001) and "#4cff93" or nil })
  table.insert(entries, { title = string.format("Height Multiplier: x%g", state.carThicknessMultiplier or 1.0), desc = "Resize vehicle thickness independently (Z-axis)", icon = "carToWheels", uniqueID = "codeCheatCarThicknessMenu", ["goto"] = M.CHEAT_CAR_THICKNESS_ROOT, color = (math.abs((state.carThicknessMultiplier or 1.0) - 1.0) > 0.001) and "#4cff93" or nil })
  
  table.insert(entries, { 
    title = string.format("Length Multiplier: x%g", state.carLengthMultiplier or 1.0), 
    desc = "Resize vehicle length independently (Y-axis)", 
    icon = "carToWheels", 
    uniqueID = "codeCheatCarLengthMenu", 
    ["goto"] = M.CHEAT_CAR_LENGTH_ROOT, 
    color = (math.abs((state.carLengthMultiplier or 1.0) - 1.0) > 0.001) and "#4cff93" or nil 
  })
  
  table.insert(entries, {
    title = "Preset conduite (F9): " .. ((_G.CheatMenu_DriveCheatEnabled == true) and "ON" or "OFF"),
    desc = "Toggle preset auto au spawn — ETK & Scintilla (F9)",
    icon = "infinity",
    uniqueID = "codeCheatDrivePresetToggle",
    color = (_G.CheatMenu_DriveCheatEnabled == true) and "#4cff93" or nil,
    onSelect = function()
      obj:queueGameEngineLua("if extensions.cheatMenuu and extensions.cheatMenuu.toggleDriveCheatPreset then extensions.cheatMenuu.toggleDriveCheatPreset() end")
      return {"reload"}
    end
  })
  table.insert(entries, { title = "Open GUI MENU", desc = "Return vehicle to stock parameters", icon = "star", uniqueID = "codeCheatGuiOpen", color = "#44ffe9", onSelect = function() obj:queueGameEngineLua("_G.CheatMenu_NeedsCollapseTrigger = true; extensions.reload('cheatMenuu')"); return {"reload"} end })
  table.insert(entries, { title = "Reset All", desc = "Return vehicle to stock parameters", icon = "vehicleFeatures03", uniqueID = "codeCheatReset", color = "#ffb5b5", onSelect = function() resetCheats(); return {"reload"} end })
end

local function generateSubMenu(entries, presets, stateKey, titlePrefix, valSuffix, applyFunc, statusMsg, iconName)
  for _, preset in ipairs(presets) do
    local presetStr = string.format("%g", preset)
    local isSelected = math.abs(state[stateKey] - preset) < 0.001
    local displayVal = (valSuffix == "x") and ("x" .. presetStr) or (presetStr .. valSuffix)
    local isStock = (valSuffix == "x" and preset == 1)
    
    table.insert(entries, {
      title = titlePrefix .. " " .. displayVal,
      desc = isStock and "Restore to Stock" or "Set " .. titlePrefix .. " to " .. displayVal,
      icon = iconName,
      uniqueID = "codeCheat_" .. stateKey .. "_" .. presetStr:gsub("-", "M"),
      color = isSelected and "#4cff93" or nil,
      onSelect = function()
        state[stateKey] = preset
        applyFunc()
        showStatusMessage("Cheat Menu: " .. statusMsg .. " set to " .. displayVal)
        return {"reload"}
      end
    })
  end
end



-- Генератор элементов для раздела Карьеры
local function addCareerEntries(entries)

  table.insert(entries, {
    title = state.followGPSMode and "AI Route Follow: ON" or "AI Route Follow: OFF",
    desc = "Enables built-in AI to drive the vehicle along your current active GPS route. (AI in manual mode can look stupid)",
    icon = "play",
    uniqueID = "codeCheatFollowGPS",
    color = state.followGPSMode and "#4cff93" or nil,
    onSelect = function()
      state.followGPSMode = not state.followGPSMode
      if state.followGPSMode then
        local geCode = [[
          local playerVeh = be:getPlayerVehicle(0)
          if playerVeh and map and map.getMap and map.getMap().nodes then
            -- 1. Получаем координаты конечной цели GPS
            local targetPos = core_groundMarkers and core_groundMarkers.getTargetPos()
            if targetPos then
              local minDist = 99999
              local bestNodeName = nil
              
              -- 2. Находим имя ближайшего дорожного узла (Node) к координатам GPS
              for nId, node in pairs(map.getMap().nodes) do
                local dist = targetPos:distance(node.pos)
                if dist < minDist then
                  minDist = dist
                  bestNodeName = nId
                end
              end
              
              -- 3. Если узел найден, отдаем машине классические команды ИИ
              if bestNodeName then
                -- Активируем систему трафика для игрока, чтобы включить логику светофоров и знаков
                if gameplay_traffic and gameplay_traffic.activate then
                  gameplay_traffic.activate({playerVeh:getID()})
                end

                -- Отправляем точные настройки ИИ со скриншота
                local cmd = string.format("if ai then ai.setMode('manual') ai.setTarget('%s') ai.driveInLane('on') ai.setAvoidCars('on') ai.setAggression(0.35) ai.setCutOffDrivability(0) ai.setSpeedMode('legal') end", bestNodeName)
                playerVeh:queueLuaCommand(cmd)
                guihooks.trigger('showNotification', {title = "AI Route Following", text = "AI activated! Driving to GPS waypoint...", icon = "play"})
              else
                guihooks.trigger('showNotification', {title = "AI Error", text = "No drivable road found near GPS target!", icon = "alert"})
                playerVeh:queueLuaCommand("if codeCheatMenu and codeCheatMenu.disableFollowGPS then codeCheatMenu.disableFollowGPS() end")
              end
            else
              guihooks.trigger('showNotification', {title = "AI Error", text = "Please set a GPS destination route on your map first!", icon = "alert"})
              playerVeh:queueLuaCommand("if codeCheatMenu and codeCheatMenu.disableFollowGPS then codeCheatMenu.disableFollowGPS() end")
            end
          end
        ]]
        obj:queueGameEngineLua(geCode)
      else
        -- Корректное отключение ИИ и возврат управления игроку
        local geCode = [[
          local playerVeh = be:getPlayerVehicle(0)
          if playerVeh then
            playerVeh:queueLuaCommand("if ai then ai.setMode('disabled') end")
            guihooks.trigger('showNotification', {title = "AI Deactivated", text = "Direct control restored.", icon = "play"})
          end
        ]]
        obj:queueGameEngineLua(geCode)
      end
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = "Teleport to GPS Waypoint",
    desc = "Instantly teleports your vehicle to the active GPS destination route set on your map",
    icon = "wrench",
    uniqueID = "codeCheatCareer_TeleportToGPS",
    onSelect = function()
      local geCode = [[
        local playerVeh = be:getPlayerVehicle(0)
        if not playerVeh then
          log("E", "CheatMenu", "No player vehicle found")
          return
        end
        
        -- Пытаемся получить координаты финиша из системы навигации
        local targetPos = nil
        if core_groundMarkers and type(core_groundMarkers.getTargetPos) == "function" then
          targetPos = core_groundMarkers.getTargetPos()
        end
        
        -- Если маршрут не проложен
        if not targetPos then
          guihooks.trigger('showNotification', {title = "Teleport Error", text = "Please set a GPS destination route on your map first (double click)!", icon = "place"})
          return
        end

        local x = targetPos.x
        local y = targetPos.y
        local z = targetPos.z

        -- Трассировка луча (Raycast) сверху вниз для точного определения высоты дорожного покрытия
        local castOrigin = vec3(x, y, z + 50)
        local castDest = vec3(x, y, -500)
        local rayRes = Engine.castRay(castOrigin, castDest, true, true)
        
        if rayRes and rayRes.pt then
          z = rayRes.pt.z + 1.2 -- Мягко приземляем машину на 1.2 метра выше точки пересечения луча
        else
          z = z + 1.5 -- Резервная высота на случай, если трассировка завершилась ошибкой
        end

        -- Осуществляем перемещение и сброс физики
        playerVeh:setPosition(vec3(x, y, z))
        
        guihooks.trigger('showNotification', {title = "Teleport Successful", text = "Teleported directly to your GPS route destination!", icon = "place"})
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Teleporting to GPS destination...")
      return {"hide"}
    end
  })
  table.insert(entries, { 
    title = "Resources & Reputations & Branch Progress", 
    desc = "Max out progression branches, dealership reputations and modify vouchers", 
    icon = "star", 
    uniqueID = "codeCheatCareerStatsMenu", 
    ["goto"] = CHEAT.CAREER_STATS, 
    color = "#fff34c" 
  })

  -- Возврат на точку спавна / домой (recovery.loadHome)
  table.insert(entries, {
    title = "Teleport Home and Repair",
    desc = "Teleports the vehicle back to its career home or garage point",
    icon = "wrench",
    uniqueID = "codeCheatCareer_LoadHome",
    onSelect = function()
      if recovery and type(recovery.loadHome) == "function" then
        recovery.loadHome()
        showStatusMessage("Career: Teleported to Home Point")
      else
        showStatusMessage("Error: Recovery system not available")
      end
      return {"hide"}
    end
  })

  -- Поставить машину на колеса (Flip Upright)
  table.insert(entries, {
    title = "Repair and Flip Upright",
    desc = "Flips the vehicle back onto its wheels on the spot (Free recovery)",
    icon = "wrench",
    uniqueID = "codeCheatCareer_FlipUpright",
    onSelect = function()
      if recovery and type(recovery.recoverInPlace) == "function" then
        recovery.recoverInPlace()
        showStatusMessage("Career: Vehicle flipped upright")
      else
        showStatusMessage("Error: Recovery system not available")
      end
      return {"hide"}
    end
  })
  
  table.insert(entries, {
    title = "Warp to Nearest Road",
    desc = "Warp and snap the vehicle cleanly onto the closest road node on the map",
    icon = "wrench",
    uniqueID = "codeCheatCareer_SnapToRoad",
    onSelect = function()
      local geCode = [[
        local playerVeh = be:getPlayerVehicle(0)
        if playerVeh and map and map.getMap and map.getMap().nodes then
          local pPos = playerVeh:getPosition()
          local minDist = 99999
          local bestNodePos = nil
          
          -- Поиск ближайшей точки дорожной карты
          for nId, node in pairs(map.getMap().nodes) do
            local dist = pPos:distance(node.pos)
            if dist < minDist then
              minDist = dist
              bestNodePos = node.pos
            end
          end
          
          if bestNodePos then
            -- Ставим чуть выше уровня дороги, чтобы избежать провала под текстуры
            playerVeh:setPosition(bestNodePos + vec3(0, 0, 1.2))
            guihooks.trigger('showNotification', {title = "Warp Node", text = "Snapped to nearest road path!", icon = "place"})
          else
            log("E", "CheatMenu", "No navigation nodes found on this map")
          end
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Warping to the nearest road...")
      return {"hide"}
    end
  })
  -- Добавление текущего авто в инвентарь гаража карьеры
  table.insert(entries, {
    title = "Add Vehicle to Garage",
    desc = "Saves your currently spawned vehicle into your career inventory",
    icon = "wrench",
    uniqueID = "codeCheatCareer_AddVehToGarage",
    onSelect = function()
      local geCode = [[
        local playerVehId = be:getPlayerVehicleID(0)
        if playerVehId and playerVehId ~= -1 then
          if career_modules_inventory then
            local inventoryId = career_modules_inventory.addVehicle(playerVehId)
            if inventoryId then
              career_modules_inventory.enterVehicle(inventoryId)
              guihooks.trigger('showNotification', {title = "Garage Cheat", text = "Vehicle added to your inventory!", icon = "star"})
            else
              log("E", "CheatMenu", "Failed to add vehicle to inventory - check console logs")
            end
          else
            log("E", "CheatMenu", "career_modules_inventory system not found")
          end
        else
          log("E", "CheatMenu", "No active player vehicle found")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Adding vehicle to garage inventory...")
      return {"hide"}
    end
  })
  table.insert(entries, {
    title = "Instant Free Refuel",
    desc = "Instantly fills up your fuel tank or fully charges your EV battery to 100% for free",
    icon = "charge",
    uniqueID = "codeCheatCareer_InstantRefuel",
    onSelect = function()
      if energyStorage then
        local storages = energyStorage.getStorages()
        local refueled = false
        if storages then
          for _, storage in pairs(storages) do
            if storage.type == "fuelTank" or storage.type == "electricBattery" then
              storage:setRemainingRatio(1)
              refueled = true
            end
          end
        end
        if refueled then
          showStatusMessage("Career: Fuel tank / battery topped up to 100%!")
        else
          showStatusMessage("No fuel storage found on this vehicle")
        end
      end
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = "Plate: Anti-Radar (OUTLAW)",
    desc = "Changes your license plate text to 'OUTLAW' to hide from speed cameras",
    icon = "badge",
    uniqueID = "codeCheatCareer_PlateOutlaw",
    onSelect = function()
      if obj and type(obj.setPlateText) == "function" then
        obj:setPlateText("OUTLAW")
        showStatusMessage("Career: License plate changed to 'OUTLAW'")
      else
        showStatusMessage("Error: Could not change plate text")
      end
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = "Plate: Remove Text",
    desc = "Completely clears the text on your license plate for complete stealth",
    icon = "badge",
    uniqueID = "codeCheatCareer_PlateRemove",
    onSelect = function()
      if obj and type(obj.setPlateText) == "function" then
        obj:setPlateText("")
        showStatusMessage("Career: License plate text removed")
      else
        showStatusMessage("Error: Could not clear plate text")
      end
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = "Repair Transmission & Clutch",
    desc = "Instantly clears all clutch wear/overheating and fixes broken transmission gears",
    icon = "cogs",
    uniqueID = "codeCheatCareer_RepairClutchGearbox",
    onSelect = function()
      if powertrain and powertrain.getDevices then
        for _, device in pairs(powertrain.getDevices()) do
          device.isBroken = false
          if device.clutchTemperature ~= nil then
            device.clutchTemperature = 20
            device.clutchEfficiency = 1
            device.energyBuiltup = 0
            device.isBroken = false
          end
          if device.type == "shaft" or device.type == "splitShaft" then
            if type(device.setMode) == "function" then device:setMode("connected") end
          end
        end
      end
      showStatusMessage("Career: Transmission and clutch have been restored!")
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = "Set Time of Day: 0.3",
    desc = "Changes the map environment time instantly",
    icon = "play",
    uniqueID = "codeCheatCareer_SetNoon",
    onSelect = function()
      local geCode = [[
        if core_environment then
          core_environment.setTimeOfDay({time = 0.3, play = true})
          guihooks.trigger('showNotification', {title = "World Settings", text = "Time", icon = "play"})
        else
          log("E", "CheatMenu", "core_environment module not found")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Setting time to Noon...")
      return {"reload"}
    end
  })
  table.insert(entries, {
    title = "Set Time of Day: 1.0",
    desc = "Changes the map environment time instantly",
    icon = "play",
    uniqueID = "codeCheatCareer_SetNoon",
    onSelect = function()
      local geCode = [[
        if core_environment then
          core_environment.setTimeOfDay({time = 1.0, play = true})
          guihooks.trigger('showNotification', {title = "World Settings", text = "Time", icon = "play"})
        else
          log("E", "CheatMenu", "core_environment module not found")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Setting time to Noon...")
      return {"reload"}
    end
  })
  
  -- Включение трафика (для возможности вернуть его обратно при необходимости)
  table.insert(entries, {
    title = "Enable Traffic",
    desc = "Spawns and activates career AI traffic again",
    icon = "carToWheels",
    uniqueID = "codeCheatCareer_EnableTraffic",
    onSelect = function()
      local geCode = [[
        if gameplay_traffic then
          gameplay_traffic.activate()
          guihooks.trigger('showNotification', {title = "Traffic Cheat", text = "Traffic activated!", icon = "carToWheels"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Starting traffic...")
      return {"hide"}
    end
  })

  -- Отключение трафика (полная остановка и удаление машин ИИ)
  table.insert(entries, {
    title = "Disable Traffic",
    desc = "Despawns all traffic vehicles and deactivates the traffic system",
    icon = "carToWheels",
    uniqueID = "codeCheatCareer_DisableTraffic",
    onSelect = function()
      local geCode = [[
        if gameplay_traffic then
          gameplay_traffic.deactivate(true)
          guihooks.trigger('showNotification', {title = "Traffic Cheat", text = "Traffic disabled and cleared!", icon = "carToWheels"})
        else
          log("E", "CheatMenu", "gameplay_traffic module not found")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Stopping and clearing traffic...")
      return {"hide"}
    end
  })

  -- ПРИНУДИТЕЛЬНОЕ УДАЛЕНИЕ ВСЕХ ИИ (Решает проблему оставшихся на карте ботов)
  table.insert(entries, {
    title = "Force Despawn All AI",
    desc = "Instantly and forcefully deletes every vehicle on the map except yours",
    icon = "carToWheels",
    uniqueID = "codeCheatCareer_ForceDespawnAI",
    onSelect = function()
      local geCode = [[
        local playerVehId = be:getPlayerVehicleID(0)
        local deletedCount = 0
        for i = be:getObjectCount() - 1, 0, -1 do
          local obj = be:getObject(i)
          if obj then
            local objId = obj:getID()
            if objId ~= playerVehId then
              obj:delete()
              deletedCount = deletedCount + 1
            end
          end
        end
        -- Сбрасываем внутренние списки трафика, чтобы система знала, что они удалены
        if gameplay_traffic then gameplay_traffic.deactivate(true) end
        guihooks.trigger('showNotification', {title = "Map Cleared", text = "Forcefully deleted " .. deletedCount .. " AI vehicles", icon = "trash"})
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Force deleting all AI cars...")
      return {"hide"}
    end
  })

  -- Безопасное удаление лишнего транспорта (removeNonTrafficVehicles с защитой игрока)
  table.insert(entries, {
    title = "Clean Non-Traffic Cars",
    desc = "Removes all auxiliary and test vehicles except official traffic, parked cars, and your vehicle",
    icon = "carToWheels",
    uniqueID = "codeCheatCareer_RemoveNonTraffic",
    onSelect = function()
      local geCode = [[
        if gameplay_traffic and gameplay_parking then
          local playerVehId = be:getPlayerVehicleID(0)
          local safeIds = gameplay_traffic.getTrafficList(true) or {}
          local parkedIds = gameplay_parking.getParkedCarsList(true) or {}
          
          -- Объединяем списки разрешенных машин
          local allSafe = {}
          for _, id in ipairs(safeIds) do allSafe[id] = true end
          for _, id in ipairs(parkedIds) do allSafe[id] = true end
          
          -- Защищаем машину игрока от случайного удаления!
          if playerVehId and playerVehId ~= -1 then 
            allSafe[playerVehId] = true 
          end

          local deletedCount = 0
          for i = be:getObjectCount() - 1, 0, -1 do
            local obj = be:getObject(i)
            if obj then
              local objId = obj:getID()
              if not allSafe[objId] then
                obj:delete()
                deletedCount = deletedCount + 1
              end
            end
          end
          guihooks.trigger('showNotification', {title = "Clean Up", text = "Removed " .. deletedCount .. " non-traffic vehicles", icon = "trash"})
        else
          log("E", "CheatMenu", "Traffic or Parking modules not active")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Cleaning non-traffic vehicles...")
      return {"hide"}
    end
  })

  -- Управление паузой физики через авторитет времени карьеры (simTimeAuthority / requestPause)
  table.insert(entries, {
    title = "Toggle Career Pause",
    desc = "Pause or resume physics simulation cleanly via Career Time Authority",
    icon = "play",
    uniqueID = "codeCheatCareer_TogglePause",
    onSelect = function()
      local geCode = [[
        if simTimeAuthority then
          local isCurrentlyPaused = simTimeAuthority.getPause()
          -- Инвертируем состояние паузы
          simTimeAuthority.pause(not isCurrentlyPaused)
          
          local statusText = isCurrentlyPaused and "Physics Resumed" or "Physics Paused"
          guihooks.trigger('showNotification', {title = "Time Authority", text = statusText, icon = "play"})
        else
          log("E", "CheatMenu", "simTimeAuthority module not found")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Toggling physics pause state...")
      return {"hide"}
    end
  })
end



-- Генератор элементов для подраздела Репутации и Веток Прогресса
local function addCareerStatsEntries(entries)
  
  -- Добавление $20,000 на счет
  table.insert(entries, {
    title = "Add $20,000 Cash",
    desc = "Add $20,000 to your career money balance",
    icon = "charge",
    uniqueID = "codeCheatCareer_AddMoney20k",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          career_modules_playerAttributes.addAttributes({money = 20000}, {tags={"cheat"}, label="Cheat Money"})
          guihooks.trigger('showNotification', {title = "Cheat Activated", text = "Added $20,000!", icon = "star"})
        else
          log("E", "CheatMenu", "career_modules_playerAttributes not found - are you in Career Mode?")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Request to add $20,000 sent")
      return {"reload"}
    end
  })

  -- Добавление BeamXP (1,000 XP)
  table.insert(entries, {
    title = "Add 1,000 BeamXP",
    desc = "Add 1,000 BeamXP points to your player career stats",
    icon = "badge",
    uniqueID = "codeCheatCareer_AddXP",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          career_modules_playerAttributes.addAttributes({beamXP = 1000}, {tags={"cheat"}, label="Cheat XP"})
          guihooks.trigger('showNotification', {title = "Cheat Activated", text = "Added 1,000 BeamXP!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Request to add 1,000 XP sent")
      return {"reload"}
    end
  })

  -- Добавление Bonus Stars (10 звезд)
  table.insert(entries, {
    title = "Add 10 Bonus Stars",
    desc = "Add 10 Bonus Stars to your career stats",
    icon = "badge",
    uniqueID = "codeCheatCareer_AddStars",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          career_modules_playerAttributes.addAttributes({bonusStars = 10}, {tags={"cheat"}, label="Cheat Stars"})
          guihooks.trigger('showNotification', {title = "Cheat Activated", text = "Added 10 Stars!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Request to add 10 Stars sent")
      return {"reload"}
    end
  })

  -- Открыть все миссии на карте (сделать видимыми и активными)
  table.insert(entries, {
    title = "Unlock All Missions",
    desc = "Make all map missions startable and visible on the POI list",
    icon = "star",
    uniqueID = "codeCheatCareer_UnlockMissions",
    onSelect = function()
      local geCode = [[
        if gameplay_missions_missions then
          for _, m in ipairs(gameplay_missions_missions.getFilesData()) do
            local instance = gameplay_missions_missions.getMissionById(m.id)
            if instance then
              instance.unlocks.startable = true
              instance.unlocks.visible = true
            end
          end
          gameplay_rawPois.clear()
          guihooks.trigger('showNotification', {title = "Cheat Activated", text = "All missions unlocked!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Opening all missions...")
      return {"reload"}
    end
  })
  -- 1. Максимальная прокачка всех веток APM (+10,000 XP на каждую подветку)
  table.insert(entries, {
    title = "Max All APM Branches (+10k XP)",
    desc = "Instantly maxes out all APM branches (AI Racing, Commercial, Experimental, Special)",
    icon = "badge",
    uniqueID = "codeCheatCareerStats_MaxAPM",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          local apmAttributes = {
            ["apm"] = 10000,
            ["apm-aiRacing"] = 10000,
            ["apm-commercial"] = 10000,
            ["apm-commercial-delivery"] = 10000,
            ["apm-experimental"] = 10000,
            ["apm-experimental-crashtest"] = 10000,
            ["apm-motorsport"] = 10000,
            ["apm-motorsport-dragracing"] = 10000,
            ["apm-motorsport-drift"] = 10000,
            ["apm-motorsport-timeTrial"] = 10000,
            ["apm-special"] = 10000,
            ["apm-special-chase"] = 10000,
            ["apm-special-evade"] = 10000
          }
          career_modules_playerAttributes.addAttributes(apmAttributes, {tags={"cheat"}, label="Cheat APM"})
          guihooks.trigger('showNotification', {title = "Stats Cheat", text = "All APM Branches Maxed!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Maxing all APM branches...")
      return {"reload"}
    end
  })

  -- 2. Максимальная прокачка автоспорта BMRA (+10,000 XP)
  table.insert(entries, {
    title = "Max All BMRA Motorsport (+10k XP)",
    desc = "Instantly maxes out all BMRA branches (Drag, Drift, Grid Racing, Time Trial)",
    icon = "badge",
    uniqueID = "codeCheatCareerStats_MaxBMRA",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          local bmraAttributes = {
            ["bmra"] = 10000,
            ["bmra-dragracing"] = 10000,
            ["bmra-drift"] = 10000,
            ["bmra-gridRacing"] = 10000,
            ["bmra-timeTrial"] = 10000
          }
          career_modules_playerAttributes.addAttributes(bmraAttributes, {tags={"cheat"}, label="Cheat BMRA"})
          guihooks.trigger('showNotification', {title = "Stats Cheat", text = "All BMRA Motorsport Maxed!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Maxing all BMRA Motorsport branches...")
      return {"reload"}
    end
  })

  -- 3. Максимальная прокачка логистики и доставок (+10,000 XP)
  table.insert(entries, {
    title = "Max All Logistics (+10k XP)",
    desc = "Instantly maxes out all Logistics branches (Delivery, Materials, Vehicle Delivery)",
    icon = "badge",
    uniqueID = "codeCheatCareerStats_MaxLogistics",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          local logAttributes = {
            ["logistics"] = 10000,
            ["logistics-delivery"] = 10000,
            ["logistics-materials"] = 10000,
            ["logistics-vehicleDelivery"] = 10000
          }
          career_modules_playerAttributes.addAttributes(logAttributes, {tags={"cheat"}, label="Cheat Logistics"})
          guihooks.trigger('showNotification', {title = "Stats Cheat", text = "All Logistics Branches Maxed!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Maxing all Logistics branches...")
      return {"reload"}
    end
  })

  -- 4. Максимальная прокачка Фристайла и бездорожья (+10,000 XP)
  table.insert(entries, {
    title = "Max All Freestyle (+10k XP)",
    desc = "Instantly maxes out all Freestyle branches (Crawl, Evade, Minigames, Police)",
    icon = "badge",
    uniqueID = "codeCheatCareerStats_MaxFreestyle",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          local fsAttributes = {
            ["freestyle"] = 10000,
            ["freestyle-crawl"] = 10000,
            ["freestyle-evade"] = 10000,
            ["freestyle-miniGames"] = 10000,
            ["freestyle-police"] = 10000
          }
          career_modules_playerAttributes.addAttributes(fsAttributes, {tags={"cheat"}, label="Cheat Freestyle"})
          guihooks.trigger('showNotification', {title = "Stats Cheat", text = "All Freestyle Branches Maxed!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Maxing all Freestyle branches...")
      return {"reload"}
    end
  })

  -- 5. Максимальная прокачка репутации всех дилеров и заведений Беласко (+700 репутации)
  table.insert(entries, {
    title = "Max All Reputations (+700)",
    desc = "Set all Dealership, Repair Shop, Warehouse, Construction, and Refinery reputations to maximum",
    icon = "badge",
    uniqueID = "codeCheatCareerStats_MaxReputations",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          local repAttributes = {
            ["belascoAutoReputation"] = 700,
            ["belascoCityConstructionReputation"] = 700,
            ["belascoCityExhaustReputation"] = 700,
            ["belascoCityGarageReputation"] = 700,
            ["commercialVehicleSalesReputation"] = 700,
            ["fastAutomotiveReputation"] = 700,
            ["hotRolledReputation"] = 700,
            ["industrialWarehouseReputation"] = 700,
            ["jeffersonMotorsReputation"] = 700,
            ["jerryRiggsReputation"] = 700,
            ["lensflareStudiosReputation"] = 700,
            ["quarrysideAutoSalesReputation"] = 700,
            ["rentaboxReputation"] = 700,
            ["richsMotorCompanyReputation"] = 700,
            ["sealbrikReputation"] = 700,
            ["shuffleboardLogisticsReputation"] = 700,
            ["smashAutoRepairsReputation"] = 700,
            ["spearleafLogisticsReputation"] = 700,
            ["spearleafRefineryReputation"] = 700,
            ["torresTiresReputation"] = 700
          }
          career_modules_playerAttributes.addAttributes(repAttributes, {tags={"cheat"}, label="Cheat Reputation"})
          guihooks.trigger('showNotification', {title = "Reputation Cheat", text = "All Shop & Dealer Reputations Maxed!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Maxing all reputations...")
      return {"reload"}
    end
  })

  -- 6. Добавить 100 ваучеров на доставку / покупку (Vouchers)
  table.insert(entries, {
    title = "Add 100 Vouchers",
    desc = "Adds 100 career vouchers to your profile",
    icon = "charge",
    uniqueID = "codeCheatCareerStats_AddVouchers",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          career_modules_playerAttributes.addAttributes({vouchers = 100}, {tags={"cheat"}, label="Cheat Vouchers"})
          guihooks.trigger('showNotification', {title = "Vouchers Cheat", text = "Added 100 Vouchers!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Adding 100 vouchers...")
      return {"reload"}
    end
  })

  -- 7. Сбалансированный буст: +1,000 XP ко абсолютно всем веткам прогресса одновременно
  table.insert(entries, {
    title = "Balanced: +1,000 XP to All",
    desc = "Increments every single progression branch and sub-branch by 1,000 XP smoothly",
    icon = "star",
    uniqueID = "codeCheatCareerStats_AddAllBalanced",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          local balancedAttributes = {
            ["apm"] = 1000, ["apm-aiRacing"] = 1000, ["apm-commercial"] = 1000, ["apm-commercial-delivery"] = 1000,
            ["apm-experimental"] = 1000, ["apm-experimental-crashtest"] = 1000, ["apm-motorsport"] = 1000,
            ["apm-motorsport-dragracing"] = 1000, ["apm-motorsport-drift"] = 1000, ["apm-motorsport-timeTrial"] = 1000,
            ["apm-special"] = 1000, ["apm-special-chase"] = 1000, ["apm-special-evade"] = 1000,
            ["bmra"] = 1000, ["bmra-dragracing"] = 1000, ["bmra-drift"] = 1000, ["bmra-gridRacing"] = 1000, ["bmra-timeTrial"] = 1000,
            ["logistics"] = 1000, ["logistics-delivery"] = 1000, ["logistics-materials"] = 1000, ["logistics-vehicleDelivery"] = 1000,
            ["freestyle"] = 1000, ["freestyle-crawl"] = 1000, ["freestyle-evade"] = 1000, ["freestyle-miniGames"] = 1000, ["freestyle-police"] = 1000
          }
          career_modules_playerAttributes.addAttributes(balancedAttributes, {tags={"cheat"}, label="Cheat Balanced"})
          guihooks.trigger('showNotification', {title = "Stats Cheat", text = "Added 1,000 XP to all branches!", icon = "star"})
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Applying balanced +1,000 XP boost...")
      return {"reload"}
    end
  })

  -- 8. БЕЗОПАСНЫЙ СБРОС ПРОГРЕССА И РЕПУТАЦИИ (ИСПРАВЛЕНО)
  table.insert(entries, {
    title = "Reset All Rep & Branches (Reset Progress)",
    desc = "Safely resets all progression branches, reputations, and vouchers back to exactly 0",
    icon = "vehicleFeatures03",
    uniqueID = "codeCheatCareerStats_ResetAll",
    color = "#ff0707",
    onSelect = function()
      local geCode = [[
        if career_modules_playerAttributes then
          local resetAttributes = {}
          local keys = {
            "apm", "apm-aiRacing", "apm-commercial", "apm-commercial-delivery",
            "apm-experimental", "apm-experimental-crashtest", "apm-motorsport",
            "apm-motorsport-dragracing", "apm-motorsport-drift", "apm-motorsport-timeTrial",
            "apm-special", "apm-special-chase", "apm-special-evade",
            "bmra", "bmra-dragracing", "bmra-drift", "bmra-gridRacing", "bmra-timeTrial",
            "logistics", "logistics-delivery", "logistics-materials", "logistics-vehicleDelivery",
            "freestyle", "freestyle-crawl", "freestyle-evade", "freestyle-miniGames", "freestyle-police",
            "vouchers",
            "belascoAutoReputation", "belascoCityConstructionReputation", "belascoCityExhaustReputation", "belascoCityGarageReputation",
            "commercialVehicleSalesReputation", "fastAutomotiveReputation", "hotRolledReputation", "industrialWarehouseReputation",
            "jeffersonMotorsReputation", "jerryRiggsReputation", "lensflareStudiosReputation", "quarrysideAutoSalesReputation",
            "rentaboxReputation", "richsMotorCompanyReputation", "sealbrikReputation", "shuffleboardLogisticsReputation",
            "smashAutoRepairsReputation", "spearleafLogisticsReputation", "spearleafRefineryReputation", "torresTiresReputation"
          }

          -- Считываем текущее значение каждого параметра и вычитаем его, чтобы получить ровно 0
          for _, key in ipairs(keys) do
            local attr = career_modules_playerAttributes.getAttribute(key)
            if attr and attr.value then
              resetAttributes[key] = -attr.value
            end
          end

          if next(resetAttributes) then
            career_modules_playerAttributes.addAttributes(resetAttributes, {tags={"cheat"}, label="Cheat Reset"})
          end
          guihooks.trigger('showNotification', {title = "Stats Cheat", text = "All progress safely reset to 0!", icon = "vehicleFeatures03"})
        else
          log("E", "CheatMenu", "career_modules_playerAttributes not found")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Safely resetting progress to 0...")
      return {"reload"}
    end
  })

  -- 9. РАЗБЛОКИРОВКА ВСЕХ ВЕТОК КАРЬЕРНОГО РОСТА - ГЛУБОКИЙ ОБХОД (ИСПРАВЛЕНО)
  table.insert(entries, {
    title = "Unlock All Career Branches",
    desc = "Instantly unlocks all hidden and locked career branches and sub-branches",
    icon = "star",
    uniqueID = "codeCheatCareerStats_UnlockAllBranches",
    onSelect = function()
      local geCode = [[
        -- Рекурсивная функция глубокого обхода и перезаписи ограничений веток
        local function findAndModifyBranches(tbl)
          if type(tbl) ~= "table" then return false end
          
          -- Проверяем структуру (ищем эталонную ветку 'apm')
          if tbl["apm"] and type(tbl["apm"]) == "table" then
            local count = 0
            for name, branch in pairs(tbl) do
              if type(branch) == "table" then
                -- 1. Снимаем базовые ограничения и WIP-метки
                branch.unlocked = true
                branch.wip = false
                branch.isWIPVar = false
                
                -- 2. Стираем предварительные требования (зависимости)
                if branch.prerequisites then branch.prerequisites = {} end
                if branch.prereqs then branch.prereqs = {} end
                
                -- 3. Переопределяем системные функции-геттеры
                if type(branch.isUnlocked) == "function" then
                  branch.isUnlocked = function() return true end
                end
                if type(branch.getUnlocked) == "function" then
                  branch.getUnlocked = function() return true end
                end
                if type(branch.isWIP) == "function" then
                  branch.isWIP = function() return false end
                end
                if type(branch.isWorkInProgress) == "function" then
                  branch.isWorkInProgress = function() return false end
                end
                
                count = count + 1
              end
            end
            return true, count
          end

          for k, v in pairs(tbl) do
            if type(v) == "table" and k ~= "__parent" and k ~= "_G" then
              local found, count = findAndModifyBranches(v)
              if found then return true, count end
            end
          end
          return false, 0
        end

        local success = false
        local unlockedCount = 0

        -- Сканируем ветки в стандартных системных таблицах
        if career_modules_branches then
          local found, count = findAndModifyBranches(career_modules_branches)
          if found then success = true; unlockedCount = count end
        end
        if career_branches then
          local found, count = findAndModifyBranches(career_branches)
          if found then success = true; unlockedCount = count end
        end

        -- Сканируем кастомные ветки модов
        if career_career and career_career.isActive and career_career.isActive() then
          for extName, extTable in pairs(extensions) do
            if type(extName) == "string" and string.find(extName, "career_modules_") then
              local found, count = findAndModifyBranches(extTable)
              if found then success = true; unlockedCount = count end
            end
          end
        end

        -- 4. Автоматически разблокируем и выдаем все лицензии
        local function unlockLicenses(tbl)
          if type(tbl) ~= "table" then return end
          for k, v in pairs(tbl) do
            if type(v) == "table" then
              if v.unlocked ~= nil then v.unlocked = true end
              if v.owned ~= nil then v.owned = true end
              -- Если у лицензий тоже есть свои функции-проверки, принудительно одобряем их
              if type(v.isUnlocked) == "function" then v.isUnlocked = function() return true end end
              if type(v.isOwned) == "function" then v.isOwned = function() return true end end
            end
          end
        end

        if career_modules_licenses then unlockLicenses(career_modules_licenses) end
        if career_licenses then unlockLicenses(career_licenses) end

        if success then
          guihooks.trigger('showNotification', {title = "Unlock Cheat", text = "Bypassed and unlocked " .. unlockedCount .. " branches & licenses!", icon = "star"})
        else
          log("E", "CheatMenu", "Could not locate branches data table in memory")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Performing deep branch and license unlock...")
      return {"reload"}
    end
  })

  -- 10. ПОДГОТОВИТЬ ВСЕ ВЕХИ (MILESTONES) К ПОЛУЧЕНИЮ НАГРАД
  table.insert(entries, {
    title = "Prepare All Milestones for Claim",
    desc = "Sets all milestone targets to maximum, allowing you to claim massive rewards via game UI",
    icon = "charge",
    uniqueID = "codeCheatCareerStats_PrepareMilestones",
    onSelect = function()
      local geCode = [[
        -- Рекурсивная функция поиска таблицы вех в памяти модуля
        local function findAndModifyMilestones(tbl)
          if type(tbl) ~= "table" then return false end
          
          -- Проверяем структуру (ищем 'general' и одну из дефолтных вех)
          if tbl.general and type(tbl.general) == "table" and (tbl.general.branch_apm or tbl.general.stat_distance) then
            local count = 0
            for name, milestone in pairs(tbl.general) do
              if type(milestone) == "table" then
                milestone.claimedStep = 0
                milestone.notificationStep = 10 -- Делает доступными для получения сразу 10 шагов вехи
                
                -- Подтягиваем физические показатели для бесконфликтной проверки игрой
                if milestone.triggerCount then milestone.triggerCount = 9999 end
                if milestone.maxVelocityReachedByPlayer then milestone.maxVelocityReachedByPlayer = 600 end
                count = count + 1
              end
            end
            tbl.unclaimedMilestonesCount = count
            return true, count
          end

          for k, v in pairs(tbl) do
            if type(v) == "table" and k ~= "__parent" and k ~= "_G" then
              local found, count = findAndModifyMilestones(v)
              if found then return true, count end
            end
          end
          return false, 0
        end

        local success = false
        local modifiedCount = 0

        -- Пробуем применить к стандартным модулям вех
        if career_modules_milestones then
          local found, count = findAndModifyMilestones(career_modules_milestones)
          if found then success = true; modifiedCount = count end
        end
        if career_modules_milestone then
          local found, count = findAndModifyMilestones(career_modules_milestone)
          if found then success = true; modifiedCount = count end
        end

        -- Сканируем дополнительные модули на случай кастомных расширений вех
        if career_career and career_career.isActive and career_career.isActive() then
          for extName, extTable in pairs(extensions) do
            if type(extName) == "string" and string.find(extName, "career_modules_") then
              local found, count = findAndModifyMilestones(extTable)
              if found then success = true; modifiedCount = count end
            end
          end
        end

        if success then
          guihooks.trigger('showNotification', {title = "Milestones Cheat", text = "Prepared " .. modifiedCount .. " milestones! Open career menu to claim rewards.", icon = "star"})
        else
          log("E", "CheatMenu", "Could not locate milestones data table in memory")
        end
      ]]
      obj:queueGameEngineLua(geCode)
      showStatusMessage("Career: Preparing milestones for reward claim...")
      return {"reload"}
    end
  })
end


local function addRPMEntries(entries)
  local engines = powertrain.getDevicesByCategory("engine") or {}
  if #engines == 0 then 
    table.insert(entries, { title = "No engine detected", icon = "vehicleFeatures03", onSelect = function() return {"hide"} end })
    return 
  end
  generateSubMenu(entries, PRESET.RPM, "rpmMultiplier", "RPM Limit Multiplier", "x", applyRPMMultiplier, "RPM Limit Multiplier", "engine")
end

local function addDebrisEntries(entries)
  generateSubMenu(entries, PRESET.DEBRIS, "debrisMultiplier", "Particle Multiplier", "x", function() end, "Particle Multiplier", "wrench")
end

local function addPowerEntries(entries)
  local engines = powertrain.getDevicesByCategory("engine") or {}
  local motors = powertrain.getDevicesByCategory("electricMotor") or {}
  
  -- Если нет ни ДВС, ни электромоторов
  if #engines == 0 and #motors == 0 then 
    table.insert(entries, { title = "No engine/motor detected", icon = "vehicleFeatures03", onSelect = function() return {"hide"} end })
    return 
  end
  
  generateSubMenu(entries, PRESET.POWER, "powerMultiplier", "Power", "x", applyPowerMultiplier, "Power", "engine")
end

local function addGearEntries(entries)
  local hasGearboxOrMotor = false
  
  -- Ищем любую деталь, у которой есть передаточное число (включая редукторы и моторы EV)
  if powertrain and type(powertrain.getDevices) == "function" then
    for _, device in pairs(powertrain.getDevices()) do
      if device.gearRatios or device.gearRatio or device.cumulativeGearRatio then
        hasGearboxOrMotor = true
        break
      end
    end
  end

  if not hasGearboxOrMotor then 
    table.insert(entries, { title = "No gearbox/motor detected", icon = "vehicleFeatures03", onSelect = function() return {"hide"} end })
    return 
  end
  
  generateSubMenu(entries, PRESET.GEAR, "gearMultiplier", "Gear Ratio", "x", applyGearingMultiplier, "Gear Ratio", "cogs")
end

local function addGripEntries(entries) generateSubMenu(entries, PRESET.GRIP, "gripMultiplier", "Tire Grip", "x", applyGripMultiplier, "Tire Grip", "carToWheels") end
local function addGravityEntries(entries) generateSubMenu(entries, PRESET.GRAVITY, "gravityMultiplier", "Gravity", "x", applyGravityMultiplier, "Gravity", "charge") end
local function addBrakesEntries(entries) generateSubMenu(entries, PRESET.BRAKE, "brakeMultiplier", "Brakes Strength", "x", applyBrakeMultiplier, "Brakes Strength", "carToWheels") end
local function addMassEntries(entries) 
  -- Проверка наличия кузова перед генерацией пресетов
  local hasBody = false
  if next(nodeMassBaseData) ~= nil then
    hasBody = true
  else
    if v and v.data and v.data.nodes then
      for cid, node in pairs(v.data.nodes) do
        if type(cid) == "number" and isBodyNode(node) then
          hasBody = true
          break
        end
      end
    end
  end

  if not hasBody then
    table.insert(entries, {
      title = "Body not found",
      desc = "This vehicle does not have a recognizable separate body part or body nodes.",
      icon = "vehicleFeatures03",
      onSelect = function() 
        showStatusMessage("Body not found on this vehicle!", "codeCheatMassMenu")
        return {"hide"} 
      end
    })
    return
  end

  generateSubMenu(entries, PRESET.MASS, "massMultiplier", "Car Weight(Body)", "x", applyMassMultiplier, "Car Weight(Body)", "weight") 
end
local function addEngBrakeEntries(entries) generateSubMenu(entries, PRESET.ENG_BRAKE, "engineBrakeMultiplier", "Engine Brake", "x", applyPowerMultiplier, "Engine Brake", "carToWheels") end
local function addDragEntries(entries) generateSubMenu(entries, PRESET.DRAG, "dragMultiplier", "Air Drag/Wind", "x", applyDragAndCompensate, "Air Drag/Wind", "carToWheels") end
local function addTimeScaleEntries(entries) generateSubMenu(entries, PRESET.TIMESCALE, "timeScale", "Simulation Speed", "x", applyTimeScale, "Simulation Speed", "play") end
local function addInvulnerableEntries(entries) generateSubMenu(entries, PRESET.INVULN, "invulnerableMultiplier", "Strength Multiplier", "x", applyInvulnerability, "Strength Multiplier", "wrench") end
local function addJatoEntries(entries) generateSubMenu(entries, PRESET.JATO, "jatoMultiplier", "JATO Power", "x", function() end, "JATO Power", "charge") end

-- Встроенный автономный обработчик масштабирования (внедряется в Game Engine)
local function injectStandaloneCarscaler()
  local geCode = [[
    if not _G.custom_carscaler_loaded then
      _G.custom_carscaler_loaded = true
      log("I", "custom_carscaler", "Injecting custom standalone carscaler hooks into GE VM...")
      
      local jbeamEvents = require("jbeam/sections/events")
      local jbeamLoader = require("jbeam/loader")
      
      _G.custom_carscaler_nextObjID = nil
      _G.custom_carscaler_nextVehicleConfig = nil
      
      local function scaleJBeam(objID, vehicleObj, vehicle, vehicleConfig)
        
        -- [Дополнение для partscaler] Масштабирование отдельных деталей на спавне
        
        local partscaler = vehicleConfig.partscaler
        if partscaler and next(partscaler) then
          for partName, partScale in pairs(partscaler) do
            if partScale and math.abs(partScale - 1) > 0.001 then
              local sumX, sumY, sumZ = 0, 0, 0
              local nodeCount = 0
              if vehicle.nodes then
                for i = 0, tableSizeC(vehicle.nodes) - 1 do
                  local n = vehicle.nodes[i]
                  if n and n.partOrigin == partName and n.pos then
                    sumX = sumX + (n.pos.x or n.pos[1] or 0)
                    sumY = sumY + (n.pos.y or n.pos[2] or 0)
                    sumZ = sumZ + (n.pos.z or n.pos[3] or 0)
                    nodeCount = nodeCount + 1
                  end
                end
              end

              if nodeCount > 0 then
                local centerX = sumX / nodeCount
                local centerY = sumY / nodeCount
                local centerZ = sumZ / nodeCount
                
                local scaleArea = partScale^2
                local scaleVolume = partScale^3
                local weightScale = scaleVolume
                local stiffnessScale = weightScale / math.max(partScale, 1)
                local strengthScale = weightScale
                
                -- 1. Масштабируем узлы относительно геометрического центра детали
                if vehicle.nodes then
                  for i = 0, tableSizeC(vehicle.nodes) - 1 do
                    local n = vehicle.nodes[i]
                    if n and n.partOrigin == partName and n.pos then
                      local x = n.pos.x or n.pos[1] or 0
                      local y = n.pos.y or n.pos[2] or 0
                      local z = n.pos.z or n.pos[3] or 0
                      
                      local newX = centerX + (x - centerX) * partScale
                      local newY = centerY + (y - centerY) * partScale
                      local newZ = centerZ + (z - centerZ) * partScale
                      
                      if type(n.pos) == "table" then
                        n.pos[1], n.pos[2], n.pos[3] = newX, newY, newZ
                      else
                        n.pos.x, n.pos.y, n.pos.z = newX, newY, newZ
                      end
                      
                      if n.nodeWeight then n.nodeWeight = n.nodeWeight * weightScale end
                    end
                  end
                end

                -- 2. Масштабируем упругость и прочность балок
                if vehicle.beams then
                  for i = 0, tableSizeC(vehicle.beams) - 1 do
                    local b = vehicle.beams[i]
                    if b and b.partOrigin == partName then
                      if b.beamSpring then b.beamSpring = b.beamSpring * stiffnessScale end
                      if b.beamDamp then b.beamDamp = b.beamDamp * stiffnessScale end
                      if b.beamStrength then b.beamStrength = b.beamStrength * strengthScale end
                      if b.beamDeform then b.beamDeform = b.beamDeform * strengthScale end
                    end
                  end
                end

                -- 3. Масштабируем и центрируем визуальные 3D меши (flexbodies) этой детали
                if vehicle.flexbodies then
                  for i = 0, tableSizeC(vehicle.flexbodies) - 1 do
                    local fb = vehicle.flexbodies[i]
                    if fb and fb.partOrigin == partName then
                      fb.pos = fb.pos or {}
                      fb.scale = fb.scale or {}
                      
                      local originalPx = fb.pos.x or fb.pos[1] or 0
                      local originalPy = fb.pos.y or fb.pos[2] or 0
                      local originalPz = fb.pos.z or fb.pos[3] or 0
                      
                      -- Вычисляем новое смещение 3D-модели для совмещения центров
                      local newPx = centerX * (1 - partScale) + originalPx * partScale
                      local newPy = centerY * (1 - partScale) + originalPy * partScale
                      local newPz = centerZ * (1 - partScale) + originalPz * partScale
                      
                      if fb.pos.x ~= nil or fb.pos.y ~= nil or fb.pos.z ~= nil then
                        fb.pos.x, fb.pos.y, fb.pos.z = newPx, newPy, newPz
                      elseif fb.pos[1] ~= nil or fb.pos[2] ~= nil or fb.pos[3] ~= nil then
                        fb.pos[1], fb.pos[2], fb.pos[3] = newPx, newPy, newPz
                      else
                        fb.pos.x, fb.pos.y, fb.pos.z = newPx, newPy, newPz
                      end
                      
                      -- Масштабируем саму трехмерную модель
                      local origSx = fb.scale.x or fb.scale[1] or 1
                      local origSy = fb.scale.y or fb.scale[2] or 1
                      local origSz = fb.scale.z or fb.scale[3] or 1
                      
                      local newSx = origSx * partScale
                      local newSy = origSy * partScale
                      local newSz = origSz * partScale
                      
                      if fb.scale.x ~= nil or fb.scale.y ~= nil or fb.scale.z ~= nil then
                        fb.scale.x, fb.scale.y, fb.scale.z = newSx, newSy, newSz
                      elseif fb.scale[1] ~= nil or fb.scale[2] ~= nil or fb.scale[3] ~= nil then
                        fb.scale[1], fb.scale[2], fb.scale[3] = newSx, newSy, newSz
                      else
                        fb.scale.x, fb.scale.y, fb.scale.z = newSx, newSy, newSz
                      end
                    end
                  end
                end

                -- 4. Масштабируем коллизионные треугольники (аэродинамику меша)
                if vehicle.triangles then
                  for i = 0, tableSizeC(vehicle.triangles) - 1 do
                    local t = vehicle.triangles[i]
                    if t and t.partOrigin == partName then
                      if t.dragCoef then t.dragCoef = t.dragCoef * scaleArea end
                      if t.liftCoef then t.liftCoef = t.liftCoef * scaleArea end
                    end
                  end
                end
                
                -- 5. Масштабируем колеса, если это узел колеса
                if vehicle.wheels then
                  for i = 0, tableSizeC(vehicle.wheels) - 1 do
                    local w = vehicle.wheels[i]
                    if w and w.partOrigin == partName then
                      if w.radius then w.radius = w.radius * partScale end
                      if w.hubRadius then w.hubRadius = w.hubRadius * partScale end
                      if w.tireWidth then w.tireWidth = w.tireWidth * partScale end
                      if w.hubWidth then w.hubWidth = w.hubWidth * partScale end
                      if w.brakeTorque then w.brakeTorque = w.brakeTorque * weightScale * partScale end
                    end
                  end
                end
              end
            end
          end
        end
        

        
        -- [Дополнение для partmover] Сдвиг/Перемещение отдельных деталей на спавне [2]
        
        local partmover = vehicleConfig.partmover
        if partmover and next(partmover) then
          for partName, offset in pairs(partmover) do
            local dx = offset.x or 0
            local dy = offset.y or 0
            local dz = offset.z or 0
            
            if math.abs(dx) > 0.001 or math.abs(dy) > 0.001 or math.abs(dz) > 0.001 then
              -- 1. Сдвигаем все узлы (nodes) этой детали по осям X, Y, Z
              if vehicle.nodes then
                for i = 0, tableSizeC(vehicle.nodes) - 1 do
                  local n = vehicle.nodes[i]
                  if n and n.partOrigin == partName and n.pos then
                    local x = n.pos.x or n.pos[1] or 0
                    local y = n.pos.y or n.pos[2] or 0
                    local z = n.pos.z or n.pos[3] or 0
                    
                    if type(n.pos) == "table" then
                      n.pos[1], n.pos[2], n.pos[3] = x + dx, y + dy, z + dz
                    else
                      n.pos.x, n.pos.y, n.pos.z = x + dx, y + dy, z + dz
                    end
                  end
                end
              end
              
              -- 2. Сдвигаем все flexbodies (3D модели) этой детали
              if vehicle.flexbodies then
                for i = 0, tableSizeC(vehicle.flexbodies) - 1 do
                  local fb = vehicle.flexbodies[i]
                  if fb and fb.partOrigin == partName then
                    fb.pos = fb.pos or {}
                    local originalPx = fb.pos.x or fb.pos[1] or 0
                    local originalPy = fb.pos.y or fb.pos[2] or 0
                    local originalPz = fb.pos.z or fb.pos[3] or 0
                    
                    if fb.pos.x ~= nil or fb.pos.y ~= nil or fb.pos.z ~= nil then
                      fb.pos.x, fb.pos.y, fb.pos.z = originalPx + dx, originalPy + dy, originalPz + dz
                    elseif fb.pos[1] ~= nil or fb.pos[2] ~= nil or fb.pos[3] ~= nil then
                      fb.pos[1], fb.pos[2], fb.pos[3] = originalPx + dx, originalPy + dy, originalPz + dz
                    else
                      fb.pos.x, fb.pos.y, fb.pos.z = originalPx + dx, originalPy + dy, originalPz + dz
                    end
                  end
                end
              end
            end
          end
        end
        

        local vars = vehicleConfig.carscaler
        if not vars or not next(vars) then return end
        
        local baseScale = vars.scale or 1
        local scaleX = (vars.scaleX or 1) * baseScale
        local scaleY = (vars.scaleY or 1) * baseScale
        local scaleZ = (vars.scaleZ or 1) * baseScale
        
        local scaleVolume = scaleX * scaleY * scaleZ
        local scaleArea = (scaleX * scaleY + scaleY * scaleZ + scaleZ * scaleX) / 3
        local avgScale = (scaleX + scaleY + scaleZ) / 3
        local maxScale = math.max(scaleX, scaleY, scaleZ)
        
        local weightScale = scaleVolume * (vars.weightMultiplier or 1)
        local stiffnessScale = weightScale / math.max(avgScale, 1) * (vars.stiffnessMultiplier or 1)
        local strengthScale = weightScale * (vars.strengthMultiplier or 1)
        local powerScale = weightScale * (vars.powerMultiplier or 1)
        local gearRatioScale = avgScale * (vars.gearRatioMultiplier or 1)
        local pressureGroupScale = weightScale / math.max(scaleArea, 1)
        local aeroScale = weightScale / scaleArea * (vars.aeroMultiplier or 1)
        
        -- Динамический буст силы для рулевого управления больших машин (чтобы хватало сил поворачивать тяжелые колеса)
        local steeringBoost = math.max(1, maxScale * 0.8)
        local steeringStiffnessScale = stiffnessScale * steeringBoost
        
        local disablePressureGroups = pressureGroupScale < 0.05
        if vars.disablePressureGroups ~= nil then disablePressureGroups = vars.disablePressureGroups end
        local disableSelfCollision = maxScale < 0.7
        if vars.disableSelfCollision ~= nil then disableSelfCollision = vars.disableSelfCollision end
        
        vehicleObj.renderDistance = 500 * math.max(maxScale, 1)
        
        -- Безопасное масштабирование пропсов (props)
        if vehicle.props then
          local removeProps = maxScale < 0.9 or maxScale > 1.1
          local newCid = 0
          for i = 0, tableSizeC(vehicle.props) - 1 do
            local p = vehicle.props[i]
            if p then
              if p.mesh and (p.mesh == "SPOTLIGHT" or p.mesh == "POINTLIGHT") then
                p.lightRange = (p.lightRange or 10) * avgScale
                p.flareScale = (p.flareScale or 1) * avgScale
                if avgScale > 1 then p.lightCastShadows = false end
                
                if p.nodeMove then
                  p.nodeMove.x = (p.nodeMove.x or 0) * scaleX
                  p.nodeMove.y = (p.nodeMove.y or 0) * scaleY
                  p.nodeMove.z = (p.nodeMove.z or 0) * scaleZ
                end
                if p.nodeOffset then
                  p.nodeOffset.x = (p.nodeOffset.x or 0) * scaleX
                  p.nodeOffset.y = (p.nodeOffset.y or 0) * scaleY
                  p.nodeOffset.z = (p.nodeOffset.z or 0) * scaleZ
                end
                if p.nodeRotate then
                  p.nodeRotate.px = (p.nodeRotate.px or 0) * scaleX
                  p.nodeRotate.py = (p.nodeRotate.py or 0) * scaleY
                  p.nodeRotate.pz = (p.nodeRotate.pz or 0) * scaleZ
                end
                if p.translation then
                  p.translation.x = (p.translation.x or 0) * scaleX
                  p.translation.y = (p.translation.y or 0) * scaleY
                  p.translation.z = (p.translation.z or 0) * scaleZ
                end
                if p.translationGlobal then
                  p.translationGlobal.x = (p.translationGlobal.x or 0) * scaleX
                  p.translationGlobal.y = (p.translationGlobal.y or 0) * scaleY
                  p.translationGlobal.z = (p.translationGlobal.z or 0) * scaleZ
                end
                if p.baseTranslationGlobal then
                  p.baseTranslationGlobal.x = (p.baseTranslationGlobal.x or 0) * scaleX
                  p.baseTranslationGlobal.y = (p.baseTranslationGlobal.y or 0) * scaleY
                  p.baseTranslationGlobal.z = (p.baseTranslationGlobal.z or 0) * scaleZ
                end
                
                if removeProps and i > newCid then
                  p.cid = newCid
                  vehicle.props[newCid] = p
                  vehicle.props[i] = nil
                  vehicle.maxIDs.props = newCid
                  newCid = newCid + 1
                end
              elseif removeProps then
                vehicle.props[i] = nil
              end
            end
          end
        end

        -- Безопасное масштабирование flexbodies
        if vehicle.flexbodies then
          for i = 0, tableSizeC(vehicle.flexbodies) - 1 do
            local fb = vehicle.flexbodies[i]
            if fb then
              if fb.pos then
                fb.pos.x = (fb.pos.x or 0) * scaleX
                fb.pos.y = (fb.pos.y or 0) * scaleY
                fb.pos.z = (fb.pos.z or 0) * scaleZ
              end
              fb.scale = fb.scale or {}
              fb.scale.x = (fb.scale.x or 1) * scaleX
              fb.scale.y = (fb.scale.y or 1) * scaleY
              fb.scale.z = (fb.scale.z or 1) * scaleZ
              
              if fb.nodeMove then
                fb.nodeMove.x = (fb.nodeMove.x or 0) * scaleX
                fb.nodeMove.y = (fb.nodeMove.y or 0) * scaleY
                fb.nodeMove.z = (fb.nodeMove.z or 0) * scaleZ
              end
              if fb.nodeOffset then
                fb.nodeOffset.x = (fb.nodeOffset.x or 0) * scaleX
                fb.nodeOffset.y = (fb.nodeOffset.y or 0) * scaleY
                fb.nodeOffset.z = (fb.nodeOffset.z or 0) * scaleZ
              end
              if fb.nodeRotate then
                fb.nodeRotate.px = (fb.nodeRotate.px or 0) * scaleX
                fb.nodeRotate.py = (fb.nodeRotate.py or 0) * scaleY
                fb.nodeRotate.pz = (fb.nodeRotate.pz or 0) * scaleZ
              end
            end
          end
        end

        -- Безопасное масштабирование узлов (nodes)
        if vehicle.nodes then
          for i = 0, tableSizeC(vehicle.nodes) - 1 do
            local n = vehicle.nodes[i]
            if n then
              if n.pos then
                n.pos.x = (n.pos.x or 0) * scaleX
                n.pos.y = (n.pos.y or 0) * scaleY
                n.pos.z = (n.pos.z or 0) * scaleZ
              end
              if n.nodeWeight then n.nodeWeight = n.nodeWeight * weightScale end
              if n.loadSensitivitySlope then n.loadSensitivitySlope = n.loadSensitivitySlope / weightScale end
              if n.couplerTag or n.tag then
                n.couplerRadius = (n.couplerRadius or 0.3) * avgScale
                n.couplerLatchSpeed = (n.couplerLatchSpeed or 0.3) * avgScale
                n.couplerLockRadius = (n.couplerLockRadius or 0.025) * math.max(avgScale, 1)
                if n.couplerStartRadius then n.couplerStartRadius = n.couplerStartRadius * avgScale end
                n.couplerStrength = (n.couplerStrength or 1000000) * strengthScale
              end
              if disableSelfCollision then n.selfCollision = false end
            end
          end
        end
        
        -- Безопасное масштабирование балок (beams)
        if vehicle.beams then
          for i = 0, tableSizeC(vehicle.beams) - 1 do
            local b = vehicle.beams[i]
            if b then
              if b.precompressionRange then b.precompressionRange = b.precompressionRange * avgScale end
              if b.beamSpring then b.beamSpring = b.beamSpring * stiffnessScale end
              if b.beamDamp then b.beamDamp = b.beamDamp * stiffnessScale end
              if b.deformLimitStress then b.deformLimitStress = b.deformLimitStress * stiffnessScale end
              if b.maxStress then b.maxStress = b.maxStress * stiffnessScale * scaleArea end
              if b.beamStrength then b.beamStrength = b.beamStrength * strengthScale end
              if b.beamDeform then b.beamDeform = b.beamDeform * strengthScale end
              
              if b.beamType == 1 then -- ANISOTROPIC
                b.boundZone = (b.boundZone or 1) * avgScale
                if b.beamLongExtent then b.beamLongExtent = b.beamLongExtent * avgScale end
                if b.transitionZone then b.transitionZone = b.transitionZone * avgScale end
                if b.springExpansion then b.springExpansion = b.springExpansion * stiffnessScale end
                if b.dampExpansion then b.dampExpansion = b.dampExpansion * stiffnessScale end
              elseif b.beamType == 2 then -- BOUNDED
                if b.longBoundRange then b.longBoundRange = b.longBoundRange * avgScale end
                if b.shortBoundRange then b.shortBoundRange = b.shortBoundRange * avgScale end
                if b.beamDampVelocitySplit then b.beamDampVelocitySplit = b.beamDampVelocitySplit * avgScale end
                if b.beamDampVelocitySplitRebound then b.beamDampVelocitySplitRebound = b.beamDampVelocitySplitRebound * avgScale end
                if b.beamLimitSpring then b.beamLimitSpring = (b.beamLimitSpring or 1) * stiffnessScale end
                if b.beamLimitDamp then b.beamLimitDamp = (b.beamLimitDamp or 1) * stiffnessScale end
                if b.beamLimitDampRebound then b.beamLimitDampRebound = b.beamLimitDampRebound * stiffnessScale end
                if b.beamDampRebound then b.beamDampRebound = b.beamDampRebound * stiffnessScale end
                if b.beamDampFast then b.beamDampFast = b.beamDampFast * stiffnessScale end
                if b.beamDampReboundFast then b.beamDampReboundFast = b.beamDampReboundFast * stiffnessScale end
              elseif b.beamType == 7 then -- SUPPORT
                if b.beamLongExtent then b.beamLongExtent = b.beamLongExtent * avgScale end
              elseif b.beamType == 3 then -- PRESSURED
                local pressureBeamScale = stiffnessScale / math.max(avgScale, 1)
                if b.pressure then b.pressure = b.pressure * pressureBeamScale end
                if b.pressurePSI then b.pressurePSI = b.pressurePSI * pressureBeamScale end
                if b.maxPressure then b.maxPressure = b.maxPressure * pressureBeamScale end
                if b.maxPressurePSI then b.maxPressurePSI = b.maxPressurePSI * pressureBeamScale end
                b.surface = (b.surface or 1) * scaleArea
              end
            end
          end
        end
        
        if vehicle.slidenodes then
          for i = 0, tableSizeC(vehicle.slidenodes) - 1 do
            local sn = vehicle.slidenodes[i]
            if sn then
              if sn.tolerance then sn.tolerance = sn.tolerance * avgScale end
              if sn.spring then sn.spring = sn.spring * stiffnessScale end
              if sn.strength then sn.strength = sn.strength * strengthScale end
              if sn.capStrength then sn.capStrength = sn.capStrength * strengthScale end
            end
          end
        end

        -- Масштабирование обычных гидросистем (рулевая рейка большинства авто) с усилением силы (steeringStiffnessScale)
        if vehicle.hydros then
          for i = 0, tableSizeC(vehicle.hydros) - 1 do
            local h = vehicle.hydros[i]
            if h then
              if h.precompressionRange then h.precompressionRange = h.precompressionRange * avgScale end
              h.inRate = (h.inRate or 2) / avgScale
              if h.outRate then h.outRate = h.outRate / avgScale end
              if h.autoCenterRate then h.autoCenterRate = h.autoCenterRate / avgScale end
              if h.beamSpring then h.beamSpring = h.beamSpring * steeringStiffnessScale end
              if h.beamDamp then h.beamDamp = h.beamDamp * steeringStiffnessScale end
              if h.beamStrength then h.beamStrength = h.beamStrength * strengthScale end
              if h.beamDeform then h.beamDeform = h.beamDeform * strengthScale end
            end
          end
        end
        
        local torsionScale = stiffnessScale * scaleArea
        local torsionStrengthScale = strengthScale * scaleArea
        if vehicle.torsionbars then
          for i = 0, tableSizeC(vehicle.torsionbars) - 1 do
            local tb = vehicle.torsionbars[i]
            if tb then
              if tb.spring then tb.spring = tb.spring * torsionScale end
              if tb.damp then tb.damp = tb.damp * torsionScale end
              if tb.strength then tb.strength = tb.strength * torsionStrengthScale end
              if tb.deform then tb.deform = tb.deform * torsionStrengthScale end
            end
          end
        end

        -- Масштабирование torsionHydros (поворотные узлы грузовиков, спецтехники) с усилением силы
        local steeringTorsionScale = torsionScale * steeringBoost
        local steeringTorsionStrengthScale = torsionStrengthScale * steeringBoost
        if vehicle.torsionHydros then
          for i = 0, tableSizeC(vehicle.torsionHydros) - 1 do
            local th = vehicle.torsionHydros[i]
            if th then
              th.inRate = (th.inRate or 2) / avgScale
              if th.outRate then th.outRate = th.outRate / avgScale end
              if th.spring then th.spring = th.spring * steeringTorsionScale end
              if th.damp then th.damp = th.damp * steeringTorsionScale end
              if th.spring2 then th.spring2 = th.spring2 * steeringTorsionScale end
              if th.damp2 then th.damp2 = th.damp2 * steeringTorsionScale end
              if th.strength then th.strength = th.strength * steeringTorsionStrengthScale end
              if th.deform then th.deform = th.deform * steeringTorsionStrengthScale end
            end
          end
        end

        if vehicle.wheels then
          for i = 0, tableSizeC(vehicle.wheels) - 1 do
            local w = vehicle.wheels[i]
            if w then
              local radiusScale = (scaleY + scaleZ) / 2
              local widthScale = scaleX
              if w.hubRadiusSimple then w.hubRadiusSimple = w.hubRadiusSimple * radiusScale end
              if w.hubRadius then w.hubRadius = w.hubRadius * radiusScale end
              if w.radius then w.radius = w.radius * radiusScale end
              if w.tireWidth then w.tireWidth = w.tireWidth * widthScale end
              if w.hubWidth then w.hubWidth = w.hubWidth * widthScale end
              if w.brakeDiameter then w.brakeDiameter = w.brakeDiameter * avgScale end
              if w.brakeMass then w.brakeMass = w.brakeMass * weightScale end
              if w.brakeTorque then w.brakeTorque = w.brakeTorque * weightScale * avgScale end
              if w.parkingTorque then w.parkingTorque = w.parkingTorque * weightScale * avgScale end
            end
          end
        end

        -- Безопасные границы масштабирования для исключения взрыва физики
        scaleX = math.max(0.05, math.min(500.0, scaleX))
        scaleY = math.max(0.05, math.min(500.0, scaleY))
        scaleZ = math.max(0.05, math.min(500.0, scaleZ))
        avgScale = math.max(0.05, math.min(500.0, (scaleX + scaleY + scaleZ) / 3))

        -- Защита масштабирования орбитальных и chase-камер от NaN и улета в никуда
        if vehicle.cameraData then
          for _, camType in ipairs({"orbit", "chase", "external"}) do
            if vehicle.cameraData[camType] then
              local cam = vehicle.cameraData[camType]
              if cam.offset then
                cam.offset.x = (cam.offset.x or 0) * scaleX
                cam.offset.y = (cam.offset.y or 0) * scaleY
                cam.offset.z = (cam.offset.z or 0) * scaleZ
              end
              -- Гарантируем, что дистанция камеры всегда больше 1.0 метра и не равна NaN
              if cam.distance then 
                cam.distance = math.max(1.0, (cam.distance or 5.0) * avgScale) 
              end
              if cam.distanceMin then 
                cam.distanceMin = math.max(0.5, (cam.distanceMin or 1.0) * avgScale) 
              end
            end
          end
        end

        -- Масштабирование сил удержания дверей, багажника и капота
        if vehicle.controller then
          for i = 0, tableSizeC(vehicle.controller) - 1 do
            local c = vehicle.controller[i]
            if c then
              if c.fileName == "advancedCouplerControl" then
                local acc = vehicle[c.name]
                if acc then
                  acc.openForceDuration = (acc.openForceDuration or 0.2) * avgScale
                  acc.closeForceDuration = (acc.closeForceDuration or 0.3) * avgScale
                  acc.openForceMagnitude = (acc.openForceMagnitude or 100) * weightScale
                  acc.closeForceMagnitude = (acc.closeForceMagnitude or 100) * weightScale
                  
                  if acc.couplerNodes then
                    for _, cn in ipairs(acc.couplerNodes) do
                      for ci, entry in ipairs(cn) do
                        if type(entry) == "number" then
                          cn[ci] = entry * weightScale
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end

        if vehicle.powertrain then
          for i = 0, tableSizeC(vehicle.powertrain) - 1 do
            local device = vehicle.powertrain[i]
            if device then
              if device.type == "combustionEngine" or device.type == "electricMotor" then
                local ce = vehicle[device.name]
                if ce then
                  if powerScale > 1 then ce.thermalsEnabled = false end
                  ce.inertia = (ce.inertia or 0.1) * weightScale
                  if ce.friction then ce.friction = ce.friction * weightScale end
                  if ce.dynamicFriction then ce.dynamicFriction = ce.dynamicFriction * weightScale end
                  if ce.maxTorqueRating then ce.maxTorqueRating = ce.maxTorqueRating * powerScale end
                  if ce.torque then
                    for _, entry in ipairs(ce.torque) do
                      if entry[2] and type(entry[2]) == "number" then entry[2] = entry[2] * powerScale end
                    end
                  end
                end
              -- Масштабирование электроусилителей руля (электросервоприводов)
              elseif device.type == "electricServo" then
                local es = vehicle[device.name]
                if es then
                  if es.friction then es.friction = es.friction * weightScale end
                  if es.dynamicFriction then es.dynamicFriction = es.dynamicFriction * weightScale end
                  es.angularSpring = (es.angularSpring or 1) * steeringStiffnessScale
                  es.stallTorque = (es.stallTorque or 1000) * powerScale
                end
              elseif device.type == "frictionClutch" then
                local fc = vehicle[device.name]
                if fc then
                  if fc.additionalEngineInertia then fc.additionalEngineInertia = fc.additionalEngineInertia * weightScale end
                  fc.clutchMass = (fc.clutchMass or 10) * weightScale
                  if fc.lockTorque then fc.lockTorque = fc.lockTorque * powerScale end
                end
              elseif device.type == "differential" then
                local diff = vehicle[device.name] or device
                if diff then
                  if diff.friction then diff.friction = diff.friction * weightScale end
                  if diff.dynamicFriction then diff.dynamicFriction = diff.dynamicFriction * weightScale end
                  diff.lockTorque = (diff.lockTorque or 500) * powerScale
                end
              elseif device.type == "shaft" then
                local shaft = vehicle[device.name] or device
                if shaft then
                  if shaft.friction then shaft.friction = shaft.friction * weightScale end
                  if shaft.dynamicFriction then shaft.dynamicFriction = shaft.dynamicFriction * weightScale end
                  if shaft.connectedWheel then shaft.gearRatio = (shaft.gearRatio or 1) * gearRatioScale end
                end
              end
            end
          end
        end
        
        if vehicle.energyStorage then
            for i = 0, tableSizeC(vehicle.energyStorage) - 1 do
                local storageKey = vehicle.energyStorage[i].name
                local storage = vehicle[storageKey]
                
                if storage then
                    -- Масштабируем вместимость
                    if storage.fuelCapacity then
                        if type(storage.fuelCapacity) == "number" then
                            storage.fuelCapacity = storage.fuelCapacity * scaleVolume
                        end
                    end
                    
                    -- Масштабируем начальный запас (если это число)
                    if storage.startingFuelCapacity then
                        if type(storage.startingFuelCapacity) == "number" then
                            storage.startingFuelCapacity = storage.startingFuelCapacity * scaleVolume
                        end
                    end
                    
                    -- Для электромобилей
                    if storage.batteryCapacity then
                        if type(storage.batteryCapacity) == "number" then
                            storage.batteryCapacity = storage.batteryCapacity * scaleVolume
                        end
                    end
                end
            end
        end
        
        if vehicle.triangles then
          for i = 0, tableSizeC(vehicle.triangles) - 1 do
            local t = vehicle.triangles[i]
            if t then
              if t.pressure then t.pressure = t.pressure * pressureGroupScale end
              if t.pressurePSI then t.pressurePSI = t.pressurePSI * pressureGroupScale end
              if t.dragCoef then t.dragCoef = t.dragCoef * aeroScale end
              if t.liftCoef then t.liftCoef = t.liftCoef * aeroScale end
              if disablePressureGroups then t.pressureGroup = nil end
            end
          end
        end
      end
      
      if jbeamLoader then
        local origLoadVehicleStage1 = jbeamLoader.loadVehicleStage1
        jbeamLoader.loadVehicleStage1 = function(objID, vehicleDir, vehicleConfig, ...)
          _G.custom_carscaler_nextObjID = objID
          _G.custom_carscaler_nextVehicleConfig = vehicleConfig
          return origLoadVehicleStage1(objID, vehicleDir, vehicleConfig, ...)
        end
      end
      
      if jbeamEvents then
        local origProcess = jbeamEvents.process
        jbeamEvents.process = function(objID, vehicleObj, vehicle, ...)
          if objID == _G.custom_carscaler_nextObjID and _G.custom_carscaler_nextVehicleConfig then
            scaleJBeam(objID, vehicleObj, vehicle, _G.custom_carscaler_nextVehicleConfig)
          end
          return origProcess(objID, vehicleObj, vehicle, ...)
        end
      end
    end
  ]]
  obj:queueGameEngineLua(geCode)
end

-- 2. Обычный масштаб (applyCarScaleInstant)
local function applyCarScaleInstant()
  injectStandaloneCarscaler()
  local targetScale = state.carScaleMultiplier or 1.0
  
  -- МГНОВЕННАЯ СИНХРОНИЗАЦИЯ (Отключает старый морфинг)
  currentCarScale = targetScale
  isCarMorphingActive = false

  local geCode = string.format([[
    local wasPaused = bullettime and bullettime.getPause and bullettime.getPause() or false
    if bullettime and bullettime.pause then bullettime.pause(true) end

    local config = core_vehicle_partmgmt and core_vehicle_partmgmt.getConfig()
    if config then
      local vars = config.carscaler or {}
      vars.scale = %f
      core_vehicle_partmgmt.setConfig({carscaler = vars}, true)
    end

    if not wasPaused then
      _G.CheatMenu_PendingUnpause = true
      _G.CheatMenu_UnpauseFrameCount = 2
    end
  ]], targetScale)
  obj:queueGameEngineLua(geCode)
end

local function addCarScaleEntries(entries)
  generateSubMenu(entries, PRESET.CAR_SCALE, "carScaleMultiplier", "Size Multiplier", "x", applyCarScaleInstant, "Size Multiplier", "carToWheels")
end

local function addSuspensionEntries(entries)
  generateSubMenu(entries, PRESET.SUSP, "suspensionHeightMultiplier", "Suspension Height", "x", function() end, "Suspension Height", "carToWheels")
end

local function addWheelSizeEntries(entries)
  -- Огромный выбор размеров колес
  local sizes = {5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 34, 36, 38, 40, 45, 50, 60, 70, 80, 90, 100}
  for _, size in ipairs(sizes) do
    local isSelected = (electrics.values['wheelSize'] or 21) == size
    table.insert(entries, {
      title = "Size: " .. size .. "\"",
      desc = "(Experimental) Morph wheel diameter to " .. size .. " inches smoothly",
      icon = "carToWheels",
      uniqueID = "codeCheatWheelSize_" .. size,
      color = isSelected and "#4cff93" or nil,
      onSelect = function()
        electrics.values['wheelSize'] = size
        beamLFin = false
        guihooks.message("Cheat completed", 4, "codeCheatMenu")
        return {"reload"}
      end
    })
  end
end

local function addWheelWidthEntries(entries)
  -- Огромный выбор ширины колес
  local widths = {50, 60, 80, 90, 100, 120, 150, 180, 200, 220, 250, 280, 300, 320, 350, 380, 400, 420, 450, 480, 500, 520, 550, 580, 600, 650, 700, 750, 800, 850, 900, 950, 1000}
  for _, width in ipairs(widths) do
    local isSelected = (electrics.values['wheelWidth'] or 300) == width
    table.insert(entries, {
      title = "Width: " .. width,
      desc = "(Experimental) Morph wheel width to " .. width .. " mm smoothly",
      icon = "carToWheels",
      uniqueID = "codeCheatWheelWidth_" .. width,
      color = isSelected and "#4cff93" or nil,
      onSelect = function()
        electrics.values['wheelWidth'] = width
        beamWFin = false
        guihooks.message("Cheat completed", 4, "codeCheatMenu")
        return {"reload"}
      end
    })
  end
end

local function addVisualEntries(entries)
  -- 1. Количество осколков / частиц
  table.insert(entries, { 
    title = string.format("Particle Multiplier: x%g", state.debrisMultiplier), 
    desc = "Multiply visual fragments & sparks on crash", 
    icon = "wrench", 
    uniqueID = "codeCheatDebrisMenu", 
    ["goto"] = CHEAT.DEBRIS, 
    color = (math.abs(state.debrisMultiplier - 1) > 0.001) and "#4cff93" or nil 
  })

  -- 2. Динамический дождь
  table.insert(entries, {
    title = state.dynamicRain and "Dynamic Rain: ON" or "Dynamic Rain: OFF",
    desc = "Randomly toggles rain every 20-60 seconds",
    icon = "snowflake",
    uniqueID = "codeCheatDynamicRain",
    color = state.dynamicRain and "#4cff93" or nil,
    onSelect = function()
      state.dynamicRain = not state.dynamicRain
      if state.dynamicRain then
        rainCooldown = 9999
      else
        applyWeatherEffect("rain", false, 0)
        rainActive = false
      end
      showStatusMessage("Cheat Menu: Dynamic Rain " .. (state.dynamicRain and "ON" or "OFF"))
      return {"reload"}
    end
  })

  -- 3. Динамический снег
  table.insert(entries, {
    title = state.dynamicSnow and "Dynamic Snow: ON" or "Dynamic Snow: OFF",
    desc = "Randomly toggles snow every 20-60 seconds",
    icon = "snowflake",
    uniqueID = "codeCheatDynamicSnow",
    color = state.dynamicSnow and "#4cff93" or nil,
    onSelect = function()
      state.dynamicSnow = not state.dynamicSnow
      if state.dynamicSnow then
        snowCooldown = 9999
      else
        applyWeatherEffect("snow", false, 0)
        snowActive = false
      end
      showStatusMessage("Cheat Menu: Dynamic Snow " .. (state.dynamicSnow and "ON" or "OFF"))
      return {"reload"}
    end
  })

  -- 4. ESP + INFO
  table.insert(entries, {
    title = state.espMode2 and "ESP + INFO: ON" or "ESP + INFO: OFF",
    desc = "Information and a pole above the vehicle",
    icon = "badge",
    uniqueID = "codeCheatESP",
    color = state.espMode2 and "#4cff93" or nil,
    onSelect = function()
      state.espMode2 = not state.espMode2
      showStatusMessage("ESP + INFO " .. (state.espMode2 and "ON" or "OFF"))
      return {"reload"}
    end
  })

  -- 5. Радужный режим
  table.insert(entries, {
    title = state.rainbowMode and "Rainbow Mode: ON" or "Rainbow Mode: OFF",
    desc = "Cycles vehicle paint color",
    icon = "badge",
    uniqueID = "codeCheatRainbow",
    color = state.rainbowMode and "#4cff93" or nil,
    onSelect = function()
      state.rainbowMode = not state.rainbowMode
      showStatusMessage("Rainbow Mode " .. (state.rainbowMode and "ON" or "OFF"))
      return {"reload"}
    end
  })

  -- 6. Качество теней (переход во внутреннее подменю)
  table.insert(entries, { 
    title = "Shadow Quality", 
    desc = "Multiplies the shadow resolution of all light sources (PointLight, SpotLight, Sun, ScatterSky, ProjectedShadow, EnvironmentProbe)", 
    icon = "badge", 
    uniqueID = "codeCheatShadowResMenu", 
    ["goto"] = CHEAT.SHADOW, -- ИЗМЕНЕНО: теперь ведет на новый путь внутри visuals
    color = (state.shadowMultiplier ~= 1) and "#4cff93" or nil 
  })
end

local function registerQuickAccessMenu()
  if menuRegistered or not extensions or not extensions.core_quickAccess then return end
  menuRegistered = true

  extensions.core_quickAccess.addEntry({ level = "/root/playerVehicle/", generator = addRootCategory })
  extensions.core_quickAccess.addEntry({ level = "/root/playerVehicle/general/", generator = addRootCategory })
  extensions.core_quickAccess.addEntry({ level = "/root/sandbox/", generator = addRootCategory })
  extensions.core_quickAccess.addEntry({ level = "/root/", generator = addRootCategory })
  extensions.core_quickAccess.addEntry({ level = CHEAT.ROOT, generator = addCheatEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.VISUALS, generator = addVisualEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.POWER, generator = addPowerEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.GEAR, generator = addGearEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.GRIP, generator = addGripEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.GRAVITY, generator = addGravityEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.BRAKES, generator = addBrakesEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.MASS, generator = addMassEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.ENG_BRAKE, generator = addEngBrakeEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.DRAG, generator = addDragEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.TIMESCALE, generator = addTimeScaleEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.INVULN, generator = addInvulnerableEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.SHADOW, generator = addShadowQualityPresets })
  extensions.core_quickAccess.addEntry({ level = CHEAT.JATO, generator = addJatoEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.DEBRIS, generator = addDebrisEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.RPM, generator = addRPMEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.WHEEL_SIZE, generator = addWheelSizeEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.WHEEL_WIDTH, generator = addWheelWidthEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.CAR_SCALE, generator = addCarScaleEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.SUSP, generator = addSuspensionEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.CAREER, generator = addCareerEntries })
  extensions.core_quickAccess.addEntry({ level = CHEAT.CAREER_STATS, generator = addCareerStatsEntries })
  -- Presets
  extensions.core_quickAccess.addEntry({ level = CHEAT.ROOT .. "presets/", generator = M._presetsGenerator })
  for i = 1, 5 do
    local slotRoot = CHEAT.ROOT .. "presets/slot" .. i .. "/"
    local idx = i
    extensions.core_quickAccess.addEntry({ level = slotRoot, generator = function(entries) M._presetSlotGenerator(idx, entries) end })
  end
  extensions.core_quickAccess.addEntry({ level = M.CHEAT_PART_SCALE_ROOT, generator = M.addPartScaleListEntries })
  extensions.core_quickAccess.addEntry({ level = M.CHEAT_CAR_LENGTH_ROOT, generator = M.addCarLengthEntries })
  extensions.core_quickAccess.addEntry({ level = M.CHEAT_CAR_WIDTH_ROOT, generator = M.addCarWidthEntries })
  extensions.core_quickAccess.addEntry({ level = M.CHEAT_CAR_THICKNESS_ROOT, generator = M.addCarThicknessEntries })

end




local function updateCarMorphing(dt)
  local targetScale = state.carScaleMultiplier or 1.0
  local diff = targetScale - currentCarScale

  if math.abs(diff) > 0.001 then
    -- Включаем неуязвимость балок на время изменения размеров
    if not isCarMorphingActive then
      setTemporaryInvulnerability(true)
      isCarMorphingActive = true
    end

    -- Рассчитываем плавный шаг изменения масштаба
    local step = ((diff >= 0) and 1 or -1) * dt * 0.35
    if math.abs(step) > math.abs(diff) then
      currentCarScale = targetScale
    else
      currentCarScale = currentCarScale + step
    end

    -- Масштабируем скорость работы гидросистем (рулевого управления), 
    -- а также их физический диапазон и центр, чтобы колеса поворачивались на любом масштабе
    -- [Адаптация из carscaler] Масштабирование рулевых гидросистем с защитой от резонанса и поломок
    if hydros and hydros.hydros then
      for _, h in pairs(hydros.hydros) do
        -- Инициализируем и сохраняем оригинальные параметры при первом запуске
        if not h._origInRate then
          h._origInRate = h.inRate or 1
          h._origOutRate = h.outRate or 1
          h._origCenter = h.center or 1.0
          h._origFactor = h.factor or 0.0
          h._origInLimit = h.inLimit
          h._origOutLimit = h.outLimit
        end

        -- ПРИНЦИП ИЗ CARSCALER: Делим скорость работы руля на масштаб кузова (currentCarScale)
        -- Это исключает тряску и разрыв рулевых тяг от слишком резких движений тяжелых колес.
        -- Для маленьких машин скорость, напротив, увеличивается для стабильности.
        h.inRate = h._origInRate / currentCarScale
        h.outRate = h._origOutRate / currentCarScale

        -- Пропорционально масштабируем нулевую точку и рабочий диапазон хода рулевой рейки
        h.center = h._origCenter * currentCarScale
        h.factor = h._origFactor * currentCarScale
        
        if h._origInLimit then h.inLimit = h._origInLimit * currentCarScale end
        if h._origOutLimit then h.outLimit = h._origOutLimit * currentCarScale end
      end
    end

    -- Масштабируем все балки автомобиля (кроме балок колес и балок подвески)
    if v.data and v.data.beams then
      for _, beam in pairs(v.data.beams) do
        if beam.cid ~= nil and not wheelBeamsSet[beam.cid] and not suspensionBeams[beam.cid] then
          obj:setBeamLengthRefRatio(beam.cid, currentCarScale)
        end
      end
    end
  else
    if isCarMorphingActive then
      setTemporaryInvulnerability(false)
      if M.healDrivetrain then
        M.healDrivetrain()
      end
      isCarMorphingActive = false
      guihooks.message("Cheat completed", 4, "codeCheatMenu")
    end
  end
end

-- ЖИЗНЕННЫЙ ЦИКЛ
local function onExtensionLoaded()
  log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Started setupMessageHook ==========')
  setupMessageHook()
  log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Finished setupMessageHook ==========')
  log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Started registerQuickAccessMenu ==========')
  registerQuickAccessMenu()
  log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Finished registerQuickAccessMenu ==========')
  log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Started injectStandaloneCarscaler ==========')
  injectStandaloneCarscaler()
  log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Finished injectStandaloneCarscaler ==========')
  needsPowerBaseRefresh = true
  log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Final onExtensionLoaded ==========')
  obj:queueGameEngineLua("_G.CheatMenu_NeedsCollapseTrigger = true; extensions.load('cheatMenuu')")
end

local function onVehicleLoaded()
  needsPowerBaseRefresh = true
  powerBaseData = {}
  wheelGripBaseData = {}
  wheelBurstBaseData = {}
  transmissionBaseData = {}
  wheelBrakeBaseData = {}
  nodeMassBaseData = {}
  beamBaseData = {}
  gearingBaseData = {}
  torsionBaseData = {}
  tireBeams = {}
  M.surfaceNodesCache = nil

  state.followGPSMode = false

  suspensionBeams = {}
  currentSuspensionHeight = 1.0
  isSuspensionMorphingActive = false
  cacheSuspensionBeams()

  state.globalStrengthMult = 1.0
  state.partStrengthMults = {}
  M.scanPartBeamStrengths()
  

  -- Сброс морфинга автомобиля при полной загрузке нового авто
  state.carScaleMultiplier = 1.0
  currentCarScale = 1.0
  isCarMorphingActive = false
  wheelBeamsSet = {}

  -- Кэшируем массу исключительно для узлов основной детали кузова
  nodeMassBaseData = {}
  if v and v.data and v.data.nodes then
    for cid, node in pairs(v.data.nodes) do
      if type(cid) == "number" and isBodyNode(node) then 
        nodeMassBaseData[cid] = node.nodeWeight or 1 
      end
    end
  end

  gravityBaseValue = nil
  vehicleControllerBaseData = { captured = false, topSpeedLimit = nil, topSpeedLimitReverse = nil }

  diffBaseData = {}
  state.awdMode = false
  
  activeFlags = {
    invulnerable = false, power = false, grip = false, gravity = false,
    brakes = false, mass = false, engineBrake = false, environment = false, gearing = false
  }

  -- Сбрасываем настройки колес в дефолт при полной перезагрузке/спавне авто
  if electrics and electrics.values then
    electrics.values['wheelSize'] = nil
    electrics.values['wheelWidth'] = nil
  end

  M.uniqueParts = {}
  M.partScaleTargets = {}
  M.partOffsetTargets = {} -- Сброс сдвигов
  M.menuRegisteredParts = {} -- Сброс кэша подменю деталей для новой машины
  
  -- Запрашиваем из GE текущие активные масштабы и сдвиги деталей для синхронизации меню [2]
  local geCode = string.format([[
    local config = core_vehicle_partmgmt and core_vehicle_partmgmt.getConfig()
    local partscaler = config and config.partscaler or {}
    local partmover = config and config.partmover or {}
    local dataStr = jsonEncode({scaler = partscaler, mover = partmover})
    local veh = be:getObjectByID(%d)
    if veh then
      veh:queueLuaCommand("if CheatMenuM and CheatMenuM.restorePartConfig then CheatMenuM.restorePartConfig('" .. dataStr .. "') end")
    end
  ]], obj:getID())
  obj:queueGameEngineLua(geCode)

  scheduleReapply()
  initWheelSizing()
  injectStandaloneCarscaler()
  state.camberOffset = 0.0
  state.wheelOffset = 0.0
  state.suspensionSpringMultiplier = 1.0
  state.suspensionDampMultiplier = 1.0
  M.scanCamberBeams()

  state.tireStiffnessMult = 1.0
  state.tireDampMult = 1.0
  state.tireFrictionMult = 1.0
  state.tireSlidingMult = 1.0

  M.originalTireBeams = {}
  M.originalTreadFriction = {}




  state.tireRadiusMult = 1.0
  state.tireWidthMult = 1.0

  state.tireSideSpring = 1.0
  state.tireSideDamp = 1.0
  state.tireSideExpSpring = 1.0
  state.tireSideExpDamp = 1.0
  state.tireSidePre = 1.0
  state.tireSideDeform = 1.0
  state.tireSideStrength = 1.0
  
  state.tireReinfSpring = 1.0
  state.tireReinfDamp = 1.0
  state.tireReinfPre = 1.0
  
  state.tireTreadSpring = 1.0
  state.tireTreadDamp = 1.0
  state.tireTreadPre = 1.0
  state.tireTreadDeform = 1.0
  state.tireTreadStrength = 1.0
  
  state.tireTreadReinfSpring = 1.0
  state.tireTreadReinfDamp = 1.0
  state.tireTreadReinfPre = 1.0
  
  state.tirePeriSpring = 1.0
  state.tirePeriDamp = 1.0
  state.tirePeriPre = 1.0
  state.tirePeriDeform = 1.0
  state.tirePeriStrength = 1.0
  
  state.tirePeriReinfSpring = 1.0
  state.tirePeriReinfDamp = 1.0
  state.tirePeriReinfPre = 1.0
  
  state.tireNodeWeight = 1.0
  state.tireFriction = 1.0
  state.tireSliding = 1.0
  M.pressureWheelsCache = {}
  M.scanPressureWheels()

  state.thrustX = 0.0
  state.thrustY = 0.0
  state.thrustZ = 0.0

  if M.pushMinimalGeConnection then M.pushMinimalGeConnection() end
end

local function onReset() 
  state.followGPSMode = false
  if _G.CheatMenu_DriveCheatEnabled then
    M._drivePresetSettleFrames = 180
  end

  -- regenEnabled = false
  -- regenCancelled = false
  -- regenTime = 0
  -- regenBeamStates = {}
  -- regenBeamCache = {}
  jatoReinforced = false
  M.surfaceNodesCache = nil
  
  state.suspensionHeightMultiplier = 1.0

  suspensionBeams = {}
  currentSuspensionHeight = 1.0
  isSuspensionMorphingActive = false
  cacheSuspensionBeams()

  state.globalStrengthMult = 1.0
  state.partStrengthMults = {}
  M.scanPartBeamStrengths()
  
  
  -- Принудительный сброс параметров масштаба автомобиля к стоку (1.0x)
  state.carScaleMultiplier = 1.0
  currentCarScale = 1.0
  isCarMorphingActive = false

  -- Восстановление оригинальных параметров рулевого управления к заводским 1.0x
  if hydros and hydros.hydros then
    for _, h in pairs(hydros.hydros) do
      if h._origInRate then
        h.inRate = h._origInRate
        h.outRate = h._origOutRate
        h.center = h._origCenter
        h.factor = h._origFactor
        h.inLimit = h._origInLimit
        h.outLimit = h._origOutLimit
      end
    end
  end

  
  -- чтобы колеса возвращались к стоку при обычном быстром ремонте на клавишу R:
  if electrics and electrics.values then
    electrics.values['wheelSize'] = nil
    electrics.values['wheelWidth'] = nil
  end

  scheduleReapply()  
  initWheelSizing()
  state.camberOffset = 0.0
  state.wheelOffset = 0.0
  state.suspensionSpringMultiplier = 1.0
  state.suspensionDampMultiplier = 1.0
  M.scanCamberBeams()

  state.tireStiffnessMult = 1.0
  state.tireDampMult = 1.0
  state.tireFrictionMult = 1.0
  state.tireSlidingMult = 1.0
  M.originalTireBeams = {}
  M.originalTreadFriction = {}


  state.tireRadiusMult = 1.0
  state.tireWidthMult = 1.0

  state.tireSideSpring = 1.0
  state.tireSideDamp = 1.0
  state.tireSideExpSpring = 1.0
  state.tireSideExpDamp = 1.0
  state.tireSidePre = 1.0
  state.tireSideDeform = 1.0
  state.tireSideStrength = 1.0
  
  state.tireReinfSpring = 1.0
  state.tireReinfDamp = 1.0
  state.tireReinfPre = 1.0
  
  state.tireTreadSpring = 1.0
  state.tireTreadDamp = 1.0
  state.tireTreadPre = 1.0
  state.tireTreadDeform = 1.0
  state.tireTreadStrength = 1.0
  
  state.tireTreadReinfSpring = 1.0
  state.tireTreadReinfDamp = 1.0
  state.tireTreadReinfPre = 1.0
  
  state.tirePeriSpring = 1.0
  state.tirePeriDamp = 1.0
  state.tirePeriPre = 1.0
  state.tirePeriDeform = 1.0
  state.tirePeriStrength = 1.0
  
  state.tirePeriReinfSpring = 1.0
  state.tirePeriReinfDamp = 1.0
  state.tirePeriReinfPre = 1.0
  
  state.tireNodeWeight = 1.0
  state.tireFriction = 1.0
  state.tireSliding = 1.0
  M.pressureWheelsCache = {}
  M.scanPressureWheels()

  state.thrustX = 0.0
  state.thrustY = 0.0
  state.thrustZ = 0.0
end

local function hsvToRgb(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q end
    return r, g, b
end

local rainbowTimer = 0
local refillTimer = 0
local REFILL_INTERVAL = 0.5

local function applyInfiniteResources()
  -- Обновление топлива и закиси азота
  if energyStorage then
    local storages = energyStorage.getStorages()
    if storages then
      for _, storage in pairs(storages) do
        local type = storage.type
        if state.infiniteFuel and (type == "fuelTank" or type == "electricBattery") then
          storage:setRemainingRatio(1)
        end
        if state.infiniteN2O and type == "n2oTank" then
          storage:setRemainingRatio(1)
        end
      end
    end
  end

  -- БЕСКОНЕЧНЫЙ JATO (Остановка расхода и восполнение)
  if state.infiniteJato and controller and controller.getController then
    local jatoCtrl = controller.getController("jato")
    if jatoCtrl then
      -- Устанавливаем множитель расхода в 0 (топливо не тратится)
      jatoCtrl.fuelCoef = 0 
      
      -- Если бак JATO УЖЕ опустел до того как мы включили чит, 
      -- контроллер глушит ракеты. Перезагружаем его, чтобы заправить до краев.
      if electrics.values.jatofuel and electrics.values.jatofuel <= 0 then
        if type(jatoCtrl.reset) == "function" then
          jatoCtrl.reset()
        end
      end
    end
  end
end

local function drawESP2()
    if not obj then return end

    local pos = obj:getPosition()
    local vel = obj:getVelocity()
    if not pos or not vel then return end
    
    local speedKmh = vel:length() * 3.6
    local vehID = obj:getID()
    
    local arrowColor = "ColorF(1, 0.2, 0, 0.8)"
    local displayLabel = string.format("%d| %.1f km/h", vehID, speedKmh)

    local luaCmd = [[
        (function()
            if not core_camera or not debugDrawer then return end
            local vehPos = vec3(]]..pos.x..[[, ]]..pos.y..[[, ]]..pos.z..[[)
            local camPos = core_camera.getPosition()
            local dist = camPos:distance(vehPos)
            
            -- 1. Рисуем "столб" света (линию вверх), чтобы было видно за холмами
            local beamTop = vehPos + vec3(0, 0, 1500, 0.8) -- Столб высотой 1500 метров
            debugDrawer:drawLine(vehPos, beamTop, ]]..arrowColor..[[)

            -- 3. Текст рисуем только если машина не слишком далеко
                local fullTxt = "]]..displayLabel..[[ | " .. string.format("%.1fm", dist)
                debugDrawer:drawTextAdvanced(
                    vehPos + vec3(0, 0, 3), 
                    String(fullTxt), 
                    ColorF(1, 1, 1, 0.7), 
                    true, false, ColorI(0, 0, 0, 160)
                )
        end)()
    ]]

    obj:queueGameEngineLua(luaCmd)
end


local applyDrivePresetStabilityAssist
local applyDrivePresetTractionControl
local applyDrivePresetDownforce
local updateDrivePresetLaunchRamp

local function updateGFX(dt)
  if not obj then return end -- Самая важная проверка

  -- Обсчет заезда на виртуальные кирпичи и нанесения урона
  if M.updateVirtualSandPhysics then M.updateVirtualSandPhysics(dt) end
  -- Динамическое связывание функции ремонта трансмиссии при первом вызове
  if not M.healDrivetrain and healDrivetrain then
    M.healDrivetrain = healDrivetrain
  end

  updateSuspensionMorphing(dt)
  -- ОБНОВЛЕНИЕ ДИНАМИЧЕСКОГО МОРФИНГА КОЛЕС И КУЗОВА
  updateCarMorphing(dt)
  updateWheelMorphing(dt)

  applyExtraJatoThrust()
  if updateDrivePresetLaunchRamp then updateDrivePresetLaunchRamp(dt) end
  if applyDrivePresetDownforce then applyDrivePresetDownforce(dt) end
  if applyDrivePresetStabilityAssist then applyDrivePresetStabilityAssist(dt) end
  if applyDrivePresetTractionControl then applyDrivePresetTractionControl(dt) end
  if M.applyDrivePresetIndustrialSpeedUnlock then M.applyDrivePresetIndustrialSpeedUnlock(dt) end

  if pendingReapplyFrames > 0 then
    pendingReapplyFrames = pendingReapplyFrames - 1
    if pendingReapplyFrames <= 0 then applyCheatState() end
  end

  if M.ensureDrivePresetMotorApplied then M.ensureDrivePresetMotorApplied() end

  if M.enforceDrivePresetBrakes and _G.CheatMenu_DriveCheatEnabled and M._drivePresetLastCfg then
    M.enforceDrivePresetBrakes()
  end

  if M._drivePresetCollisionArmor and _G.CheatMenu_DriveCheatEnabled and M.applyDrivePresetCollisionArmor then
    M._drivePresetCollisionRefreshAcc = (M._drivePresetCollisionRefreshAcc or 0) + (dt or 0.016)
    if M._drivePresetCollisionRefreshAcc > 1.1 then
      M._drivePresetCollisionRefreshAcc = 0
      M.applyDrivePresetCollisionArmor()
    end
    M._drivePresetBodyShapeAcc = (M._drivePresetBodyShapeAcc or 0) + (dt or 0.016)
    if M._drivePresetBodyShapeAcc > 0.32 then
      M._drivePresetBodyShapeAcc = 0
      if M.enforceDrivePresetFrontBodyShape then M.enforceDrivePresetFrontBodyShape() end
    end
  end

  if state.drivePresetActive and state.indestructibleEngine and healDrivetrain then
    M._drivePresetDrivetrainHealAcc = (M._drivePresetDrivetrainHealAcc or 0) + (dt or 0.016)
    if M._drivePresetDrivetrainHealAcc > 2.5 then
      M._drivePresetDrivetrainHealAcc = 0
      healDrivetrain()
    end
  end

  if state.drivePresetActive and M._drivePresetPauseEsc then
    local escCtrl = controller and controller.getController and controller.getController("esc")
    if escCtrl then escCtrl.pauseESCAction = true end
    if electrics and electrics.values then
      electrics.values.tcsActive = 0
      electrics.values.escActive = 0
    end
  end
  if state.drivePresetActive and M.refreshDrivePresetGrip then
    M._drivePresetGripRefreshAcc = (M._drivePresetGripRefreshAcc or 0) + (dt or 0.016)
    if M._drivePresetGripRefreshAcc > 0.18 then
      M._drivePresetGripRefreshAcc = 0
      M.refreshDrivePresetGrip()
      if M.enforceDrivePresetBrakes then M.enforceDrivePresetBrakes() end
    end
  end

  -- Цикл регенерации кузова
  if regenEnabled then
    doRegen(dt)
    regenTime = regenTime + dt
  end

  -- Цикл динамического дождя
  if state.dynamicRain then
    rainCooldown = rainCooldown + dt
    if rainCooldown >= rainNextToggle then
      rainCooldown = 0
      rainNextToggle = math.random(5000, 6000)
      if not rainActive then
        -- УВЕЛИЧЕНО КОЛИЧЕСТВО КАПЕЛЬ (Густой ливень)
        local drops = math.random(110000, 120000) 
        applyWeatherEffect("rain", true, drops)
        rainActive = true
      else
        applyWeatherEffect("rain", false, 0)
        rainActive = false
      end
    end
  end
  
  -- Цикл динамического снега
  if state.dynamicSnow then
    snowCooldown = snowCooldown + dt
    if snowCooldown >= snowNextToggle then
      snowCooldown = 0
      snowNextToggle = math.random(5000, 6000)
      if not snowActive then
        -- УВЕЛИЧЕНО КОЛИЧЕСТВО СНЕЖИНОК (Густая метель)
        local flakes = math.random(230000, 250000) 
        applyWeatherEffect("snow", true, flakes)
        snowActive = true
      else
        applyWeatherEffect("snow", false, 0)
        snowActive = false
      end
    end
  end

  if state.espMode2 then
    drawESP2()
  end

  if state.freezeThermals or state.indestructibleEngine then
    local engines = powertrain.getDevicesByCategory("engine")
    for _, eng in ipairs(engines) do
      if eng.thermals then
        -- Удерживаем физику масла "силой"
        eng.thermals.oilStarvingSevernessZ = 0
        eng.thermals.oilStarvingSevernessXY = 0
        eng.thermals.oilLubricationCoef = 1
        eng.thermals.oilStarvationStatus = 0
        eng.thermals.oilStarvationDamage = 0
        eng.thermals.oilStarvationTimer = 0
        
        -- Если масло вытекает, затыкаем дыры
        eng.thermals.oilLeakRateOverall = 0
        eng.thermals.oilLeakRateGravity = 0
      end
    end
  end

  -- ЖЕСТКОЕ УДЕРЖАНИЕ ТРАНСМИССИИ И ДРОССЕЛЯ
  local driveSettle = M._drivePresetSettleFrames or 0
  if driveSettle > 0 then
    M._drivePresetSettleFrames = driveSettle - 1
  end

  if M._drivePresetInputReleaseFrames and M._drivePresetInputReleaseFrames > 0 then
    M._drivePresetInputReleaseFrames = M._drivePresetInputReleaseFrames - 1
    if M.releaseDrivePresetPlayerInput then M.releaseDrivePresetPlayerInput() end
  end

  if state.drivePresetActive and state.indestructibleEngine and powertrain and powertrain.getDevicesByCategory then
    M._drivePresetStallGuardAcc = (M._drivePresetStallGuardAcc or 0) + (dt or 0.016)
    local throttle = electrics.values and electrics.values.throttle or 0
    if M._drivePresetStallGuardAcc > 0.35 and throttle > 0.04 then
      M._drivePresetStallGuardAcc = 0
      for _, eng in ipairs(powertrain.getDevicesByCategory("engine") or {}) do
        if eng.isStalled then
          eng.isStalled = false
          eng.stallTimer = 1
        end
        eng.stallTimerReached = false
        eng.engineDisabled = false
      end
    end
  end

  if state.drivePresetActive and M._drivePresetTorqueBlend and M._drivePresetTorqueBlend < 1 then
    M._drivePresetTorqueBlend = math.min(1, M._drivePresetTorqueBlend + (dt or 0.016) * 0.55)
    M._drivePresetTorqueRefreshAcc = (M._drivePresetTorqueRefreshAcc or 0) + (dt or 0.016)
    if M._drivePresetTorqueRefreshAcc > 0.15 then
      M._drivePresetTorqueRefreshAcc = 0
      if state.powerMultiplier > 1.001 and applyPowerMultiplier then applyPowerMultiplier() end
    end
  end

  if state.drivePresetActive and wheels and wheels.wheels and driveSettle > 0 then
    local vel = obj:getVelocity()
    local speed = vel and vel:length() or 999
    if speed < 2.5 then
      for _, w in pairs(wheels.wheels) do
        if math.abs(w.angularVelocity or 0) > 80 then
          w.angularVelocity = 0
        end
      end
    end
  end

  if state.powerMultiplier > 1.001 and powertrain and powertrain.getDevices and driveSettle <= 0 and not state.drivePresetActive then
    local throttleInput = electrics.values and electrics.values.throttle or 0
    if throttleInput < 0.08 then throttleInput = 0 end

    for _, device in pairs(powertrain.getDevices()) do
      
      -- 1. ФИКС МЕХАНИКИ: Принудительная отправка 10 миллиардов Нм в ядро физики
      if device.baseClutchTorque ~= nil then 
        device.baseClutchTorque = 90000000 
        -- Вот эта команда заставляет игру физически применить сцепление:
        if type(device.setBaseTorque) == "function" then
          device:setBaseTorque(9000000)
        end
      end
      
      if device.clutchTorque ~= nil then device.clutchTorque = 9000000 end
      
      -- 2. ФИКС АВТОМАТА: Защита муфты
      if device.lockTorque ~= nil then device.lockTorque = 9000000 end
      if type(device.setLockupTorque) == "function" then device:setLockupTorque(9000000) end
      if device.capacityFactor ~= nil then device.capacityFactor = 9000000 end 
      if device.maxTorqueRating ~= nil then device.maxTorqueRating = math.huge end
      if device.viscousTorque ~= nil then device.viscousTorque = 9000000 end 
      
      -- 3. ПОЛНЫЙ ОБХОД ЭЛЕКТРОНИКИ ИГРЫ ПРИ НАЖАТИИ НА ГАЗ
      if throttleInput > 0.05 then
        if device.clutchRatio ~= nil then device.clutchRatio = 1 end
        if device.lockupClutchRatio ~= nil then device.lockupClutchRatio = 1 end
        if device.category == "engine" and device.controls then
          device.controls.throttle = throttleInput
        end
      end
    end
  end
  
  -- Чиним двигатель и трансмиссию (preset conduite : une fois à l'apply, pas chaque frame)
  if not state.drivePresetActive then
    if state.invulnerableMultiplier > 1.001 or state.powerMultiplier > 1.001 or state.indestructibleEngine then
      healDrivetrain()
    end
  end

  if state.superTires and driveSettle <= 0 then
    if wheels and wheels.wheels then
      for _, wheel in pairs(wheels.wheels) do
        wheel.isBroken = false
        wheel.isInflated = true
        wheel.isTireDeflated = false
        wheel.tireBurstAV = math.huge
      end
    end
    -- Активная центростремительная контракция протекторных балок (Чистый RefRatio)
    for cid, info in pairs(tireBeams) do
      if info.isTireTread and info.wheelIdx and wheels.wheels[info.wheelIdx] then
        if state.drivePresetActive and M._drivePresetDisableTireMorph then
          obj:setBeamLengthRefRatio(cid, 1.0)
        else
        local av = math.abs(wheels.wheels[info.wheelIdx].angularVelocity or 0)
        local avK = state.drivePresetActive and 0.000055 or 0.00015
        local minLen = state.drivePresetActive and 0.93 or 0.88
        if state.drivePresetActive and M._drivePresetLastCfgId == "scintilla" then
          avK = 0.000032
          minLen = 0.968
        end
        local contraction = math.max(minLen, 1.0 - (av * avK))
        obj:setBeamLengthRefRatio(cid, contraction)
        end
      else
        -- Полуоси, элементы подвески и ступицы удерживаются абсолютно жестко в своих заводских параметрах.
        -- Здесь движок гарантированно не вылетит.
        obj:setBeamLengthRefRatio(cid, 1.0)
      end
    end
  end

  -- Постоянная заморозка температур, если включен Anti-Overheat
  if state.freezeThermals then forceThermalsCooldown() end
  if state.underwaterMode then applyUnderwaterMode(true) end
  
  -- Оптимизированное восполнение ресурсов (Топливо, N2O и JATO) по таймеру
  if state.infiniteFuel or state.infiniteN2O or state.infiniteJato then
    refillTimer = refillTimer + dt
    if refillTimer >= REFILL_INTERVAL then
      applyInfiniteResources()
      refillTimer = 0
    end
  end

  -- Умное удержание времени: срабатывает ТОЛЬКО если пользователь изменил скорость времени,
  -- и только в тот момент, когда игра пытается сбросить её (например, при закрытии радиального меню)
  if math.abs(state.timeScale - 1) > 0.001 then
    local currentScale = bullettime.get()
    if math.abs(currentScale - state.timeScale) > 0.01 then
      obj:queueGameEngineLua(string.format("be:setSimulationTimeScale(%g)", state.timeScale))
    end
  end

  if state.rainbowMode then
    rainbowTimer = rainbowTimer + dt
    if rainbowTimer > 1.5 then 
      local r, g, b = hsvToRgb(math.random(), 1, 1)
      setVehiclePaint(r, g, b)
      rainbowTimer = 0
    end
  end
end



-- ИНТЕРАКТИВНОЕ МАСШТАБИРОВАНИЕ ДЕТАЛЕЙ (МГНОВЕННОЕ С ПЕРЕЗАГРУЗКОЙ)
M.CHEAT_PART_SCALE_ROOT = CHEAT.ROOT .. "partscale/"
M.PART_SCALE_PRESETS = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20, 30, 40, 50, 75, 100, 200, 300, 500, 1000, 10000}

M.uniqueParts = {}
M.partScaleTargets = {}
M.menuRegisteredParts = {}

-- Универсальное получение понятного названия детали с поддержкой версий до и после v0.35, а также локализации
local function getPartFriendlyName(part)
  if not part then return "" end
  if v and v.data then
    -- В версиях 0.35+ используется activePartsData, в более старых — activeParts
    local activePartsTable = v.data.activePartsData or v.data.activeParts
    if activePartsTable and activePartsTable[part] then
      local info = activePartsTable[part].information
      if info and info.name then
        local name = info.name
        if type(name) == "string" then
          return name
        elseif type(name) == "table" then
          -- Защита от таблиц локализации (как у автобуса Wentward Citybus)
          if name.txt then
            return tostring(name.txt)
          elseif name[1] then
            return tostring(name[1])
          end
        end
      end
    end
  end
  return tostring(part) -- Возврат технического кода в виде гарантированной строки
end

-- Применение масштаба к детали через сохранение в конфиг и перезапуск машины
function M.applyPartScaleInstant(part, scale)
  injectStandaloneCarscaler() -- Проверяем загрузку хука
  local geCode = string.format([[
    local config = core_vehicle_partmgmt and core_vehicle_partmgmt.getConfig()
    if config then
      local vars = config.partscaler or {}
      vars["%s"] = %f
      core_vehicle_partmgmt.setConfig({partscaler = vars}, true)
    end
  ]], part, scale)
  obj:queueGameEngineLua(geCode)
end

M.partScaleTargets = {}
M.partOffsetTargets = {} -- Таблица смещений деталей

-- Применение сдвига (перемещения) к детали через конфиг (ИСПРАВЛЕНО) [2]
function M.applyPartOffsetInstant(part, dx, dy, dz)
  injectStandaloneCarscaler() -- Вызываем локальную функцию напрямую (без M.) [2]
  local geCode = string.format([[
    local config = core_vehicle_partmgmt and core_vehicle_partmgmt.getConfig()
    if config then
      local vars = config.partmover or {}
      vars["%s"] = { x = %f, y = %f, z = %f }
      core_vehicle_partmgmt.setConfig({partmover = vars}, true)
    end
  ]], part, dx, dy, dz)
  obj:queueGameEngineLua(geCode)
end

-- Восстановление масштабов и сдвигов после перезагрузки
function M.restorePartConfig(jsonStr)
  local data = jsonDecode(jsonStr)
  if data then
    M.partScaleTargets = data.scaler or {}
    M.partOffsetTargets = data.mover or {}
  end
end

-- Экспортируем функцию сдвига деталей
_G.applyPartOffsetInstant = M.applyPartOffsetInstant

-- Получение списка уникальных деталей автомобиля, у которых больше 2 балок
function M.getUniqueParts()
  if next(M.uniqueParts) then return M.uniqueParts end
  if not v or not v.data or not v.data.beams then 
    log('W', 'CheatMenu', 'Incorrect vehicle data structure. Ignoring.')
    return 
  end
  local partsMap = {}
  for _, beam in pairs(v.data.beams) do
    if beam.partOrigin and beam.partOrigin ~= "" then
      partsMap[beam.partOrigin] = (partsMap[beam.partOrigin] or 0) + 1
    end
  end
  for partName, count in pairs(partsMap) do
    if count > 2 then
      table.insert(M.uniqueParts, partName)
    end
  end
  -- Сортируем детали с полной защитой от nil и таблиц локализации
  table.sort(M.uniqueParts, function(a, b)
    local nameA = tostring(getPartFriendlyName(a) or a):lower()
    local nameB = tostring(getPartFriendlyName(b) or b):lower()
    return nameA < nameB
  end)
  return M.uniqueParts
end

-- Динамическая регистрация подменю выбора масштаба для каждой детали
function M.registerPartSubmenus()
  local parts = M.getUniqueParts()
  for _, part in ipairs(parts) do
    local partPath = M.CHEAT_PART_SCALE_ROOT .. part .. "/"
    if not M.menuRegisteredParts[partPath] then
      extensions.core_quickAccess.addEntry({
        level = partPath,
        generator = function(entries)
          local friendlyName = getPartFriendlyName(part)
          for _, preset in ipairs(M.PART_SCALE_PRESETS) do
            local currentTarget = M.partScaleTargets[part] or 1.0
            local isSelected = math.abs(currentTarget - preset) < 0.001
            table.insert(entries, {
              title = string.format("Scale: x%g", preset),
              desc = string.format("Set scale of %s to x%g", friendlyName, preset),
              icon = "carToWheels",
              -- ID формируем на основе системного кода детали для стабильности в UI
              uniqueID = "codeCheat_partscale_" .. part .. "_" .. tostring(preset):gsub("%.", "_"):gsub("-", "M"),
              color = isSelected and "#4cff93" or nil,
              onSelect = function()
                M.partScaleTargets[part] = preset
                M.applyPartScaleInstant(part, preset)
                showStatusMessage(string.format("Scaling %s to x%g...", friendlyName, preset))
                return {"reload"}
              end
            })
          end
        end
      })
      M.menuRegisteredParts[partPath] = true
    end
  end
end

-- Генератор списка деталей для радиального меню
function M.addPartScaleListEntries(entries)
  local parts = M.getUniqueParts()
  M.registerPartSubmenus()
  for _, part in ipairs(parts) do
    local friendlyName = getPartFriendlyName(part)
    local currentTarget = M.partScaleTargets[part] or 1.0
    local isModified = math.abs(currentTarget - 1.0) > 0.001
    table.insert(entries, {
      title = friendlyName .. (isModified and string.format(" (x%g)", currentTarget) or ""),
      desc = string.format("Select to resize %s (%s)", friendlyName, part),
      icon = "carToWheels",
      uniqueID = "codeCheatPartScaleList_" .. part,
      ["goto"] = M.CHEAT_PART_SCALE_ROOT .. part .. "/",
      color = isModified and "#4cff93" or nil
    })
  end
end



-- ИНТЕРАКТИВНОЕ МАСШТАБИРОВАНИЕ ГАБАРИТОВ АВТО (МГНОВЕННОЕ С ПЕРЕЗАГРУЗКОЙ)
M.CHEAT_CAR_WIDTH_ROOT = CHEAT.ROOT .. "carwidth/"
M.CHEAT_CAR_THICKNESS_ROOT = CHEAT.ROOT .. "carthickness/"

M.CAR_WIDTH_PRESETS = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20, 30, 40, 50, 75, 100, 200, 300, 500, 1000, 10000}
M.CAR_THICKNESS_PRESETS = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20, 30, 40, 50, 75, 100, 200, 300, 500, 1000, 10000}

-- Мгновенное применение ширины (X)
function M.applyCarWidthInstant(scale)
  injectStandaloneCarscaler()
  state.carWidthMultiplier = scale
  local geCode = string.format([[
    local config = core_vehicle_partmgmt and core_vehicle_partmgmt.getConfig()
    if config then
      local vars = config.carscaler or {}
      vars.scaleX = %f
      core_vehicle_partmgmt.setConfig({carscaler = vars}, true)
    end
  ]], scale)
  obj:queueGameEngineLua(geCode)
end

-- Мгновенное применение толщины/высоты (Z)
function M.applyCarThicknessInstant(scale)
  injectStandaloneCarscaler()
  state.carThicknessMultiplier = scale
  local geCode = string.format([[
    local config = core_vehicle_partmgmt and core_vehicle_partmgmt.getConfig()
    if config then
      local vars = config.carscaler or {}
      vars.scaleZ = %f
      core_vehicle_partmgmt.setConfig({carscaler = vars}, true)
    end
  ]], scale)
  obj:queueGameEngineLua(geCode)
end

-- Генератор меню выбора ширины автомобиля
function M.addCarWidthEntries(entries)
  for _, preset in ipairs(M.CAR_WIDTH_PRESETS) do
    local isSelected = math.abs((state.carWidthMultiplier or 1.0) - preset) < 0.001
    table.insert(entries, {
      title = string.format("Width: x%g", preset),
      desc = string.format("Set vehicle width to x%g", preset),
      icon = "carToWheels",
      uniqueID = "codeCheat_carwidth_" .. tostring(preset):gsub("%.", "_"):gsub("-", "M"),
      color = isSelected and "#4cff93" or nil,
      onSelect = function()
        M.applyCarWidthInstant(preset)
        showStatusMessage(string.format("Resizing width to x%g...", preset))
        return {"reload"}
      end
    })
  end
end

-- Генератор меню выбора толщины автомобиля
function M.addCarThicknessEntries(entries)
  for _, preset in ipairs(M.CAR_THICKNESS_PRESETS) do
    local isSelected = math.abs((state.carThicknessMultiplier or 1.0) - preset) < 0.001
    table.insert(entries, {
      title = string.format("Height: x%g", preset),
      desc = string.format("Set vehicle height to x%g", preset),
      icon = "carToWheels",
      uniqueID = "codeCheat_carthickness_" .. tostring(preset):gsub("%.", "_"):gsub("-", "M"),
      color = isSelected and "#4cff93" or nil,
      onSelect = function()
        M.applyCarThicknessInstant(preset)
        showStatusMessage(string.format("Resizing height to x%g...", preset))
        return {"reload"}
      end
    })
  end
end

-- ИНТЕРАКТИВНОЕ МАСШТАБИРОВАНИЕ ГАБАРИТОВ АВТО
M.CHEAT_CAR_LENGTH_ROOT = CHEAT.ROOT .. "carlength/"
M.CAR_LENGTH_PRESETS = {0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20, 30, 40, 50, 75, 100, 200, 300, 500, 1000, 10000}

-- Мгновенное применение длины (Y)
function M.applyCarLengthInstant(scale)
  injectStandaloneCarscaler()
  state.carLengthMultiplier = scale
  local geCode = string.format([[
    local config = core_vehicle_partmgmt and core_vehicle_partmgmt.getConfig()
    if config then
      local vars = config.carscaler or {}
      vars.scaleY = %f
      core_vehicle_partmgmt.setConfig({carscaler = vars}, true)
    end
  ]], scale)
  obj:queueGameEngineLua(geCode)
end

-- Генератор меню выбора длины автомобиля
function M.addCarLengthEntries(entries)
  for _, preset in ipairs(M.CAR_LENGTH_PRESETS) do
    local isSelected = math.abs((state.carLengthMultiplier or 1.0) - preset) < 0.001
    table.insert(entries, {
      title = string.format("Length: x%g", preset),
      desc = string.format("Set vehicle length to x%g", preset),
      icon = "carToWheels",
      uniqueID = "codeCheat_carlength_" .. tostring(preset):gsub("%.", "_"):gsub("-", "M"),
      color = isSelected and "#4cff93" or nil,
      onSelect = function()
        M.applyCarLengthInstant(preset)
        showStatusMessage(string.format("Resizing length to x%g...", preset))
        return {"reload"}
      end
    })
  end
end

-- Функция-коллбэк для сброса интерфейсного флага режима GPS, если на карте нет маршрута
function M.disableFollowGPS()
  state.followGPSMode = false
end

-- mod page: https://www.beamng.com/resources/radial-cheat-menu.37823/
M.onExtensionLoaded = onExtensionLoaded
M.onVehicleLoaded = onVehicleLoaded
M.onReset = onReset
M.updateGFX = updateGFX
M.onBeamBroke = onBeamBroke
-- mod page: https://www.beamng.com/resources/radial-cheat-menu.37823/

log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = final code ==========')

log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Export GUI Started ==========')

_G.CheatMenuM = M

-- Экспортируем все локальные функции файла в таблицу M, чтобы ImGui-интерфейс мог их вызывать
M.state = state
M.applyInvulnerability = applyInvulnerability
M.applySuperTires = applySuperTires
M.healDrivetrain = healDrivetrain
M.forceThermalsCooldown = forceThermalsCooldown
M.applyUnderwaterMode = applyUnderwaterMode
M.applyPowerMultiplier = applyPowerMultiplier
M.applyRPMMultiplier = applyRPMMultiplier
M.applyGearingMultiplier = applyGearingMultiplier
M.applyGripMultiplier = applyGripMultiplier
M.applyBrakeMultiplier = applyBrakeMultiplier
M.applyDragAndCompensate = applyDragAndCompensate
M.applyGravityMultiplier = applyGravityMultiplier
M.applyMassMultiplier = applyMassMultiplier
M.applyAWD = applyAWD
M.applyTimeScale = applyTimeScale
M.applyShadowQuality = applyShadowQuality
M.startRegenerate = startRegenerate
M.cancelRegenerate = cancelRegenerate
M.resetCheats = resetCheats
M.applyInfiniteFuel = applyInfiniteFuel
M.applyInfiniteN2O = applyInfiniteN2O
M.applyCarScaleInstant = applyCarScaleInstant

-- Таблицы кэша заводских параметров и замороженных свойств
M.powertrainDefaults = {}
M.frozenProperties = {}
M.frozenThermals = {}

function M.pushMinimalGeConnection()
  if not obj or not jsonEncode then return end
  local vid = obj:getID()
  local mini = {
    powerMultiplier = state.powerMultiplier or 1,
    rpmMultiplier = state.rpmMultiplier or 1,
    gripMultiplier = state.gripMultiplier or 1,
    drivePresetActive = state.drivePresetActive == true,
    cheatMenuConnected = true,
  }
  local payload = jsonEncode(mini)
  obj:queueGameEngineLua(
    "if not _G.CheatMenuWindow_Data then _G.CheatMenuWindow_Data = { vehicleStates = {}, parts = {} } end\n"
    .. "if not _G.CheatMenuWindow_Data.vehicleStates then _G.CheatMenuWindow_Data.vehicleStates = {} end\n"
    .. "local ok, t = pcall(jsonDecode, [===[" .. payload .. "]===])\n"
    .. "if ok and type(t) == 'table' then _G.CheatMenuWindow_Data.vehicleStates[" .. tostring(vid) .. "] = t end")
end

-- Avant sync GE : pression pneus (sinon global nil si appel trop tôt)
function M.getWheelPressure(wheel)
  if not v or not v.data or not v.data.pressureGroups or not v.data.wheels then return 30.0 end
  local wd = nil
  for _, jbWheel in ipairs(v.data.wheels) do
    if jbWheel.wheelID == wheel.wheelID then
      wd = jbWheel
      break
    end
  end
  if not wd or not wd.pressureGroup then return 30.0 end
  local pgId = v.data.pressureGroups[wd.pressureGroup]
  if not pgId then return 30.0 end
  return (obj:getGroupPressure(pgId) or 206842) * 0.00014503773773
end
_G.getWheelPressure = M.getWheelPressure

function M.syncVehicleStateToGe()
  if not obj then return end
local vehicleId = obj:getID()

-- Копируем текущее состояние читов
local stateCopy = {}
if state then
  for k, v in pairs(state) do
    stateCopy[k] = v
  end
end


-- СЮДА (ПОСЛЕ local stateCopy = {}): Сбор и передача прочностей деталей

if not M.partBeamStrengthCache or not next(M.partBeamStrengthCache) then
  M.scanPartBeamStrengths()
end

-- Безопасная передача списка прочностей деталей без nil-значений
local partStrengthsList = {}
if M.partBeamStrengthCache then
  for partName, _ in pairs(M.partBeamStrengthCache) do
    local friendlyName = (type(getPartFriendlyName) == "function") and getPartFriendlyName(partName) or partName
    table.insert(partStrengthsList, {
      name = tostring(partName),
      friendly = tostring(friendlyName or partName),
      mult = (state.partStrengthMults and state.partStrengthMults[partName]) or state.globalStrengthMult or 1.0
    })
  end
end
stateCopy.partStrengthsList = partStrengthsList


-- Дописываем динамические параметры
stateCopy.wheelSize = electrics.values['wheelSize'] or baseInches
stateCopy.wheelWidth = electrics.values['wheelWidth'] or 300
stateCopy.regenEnabled = regenEnabled
stateCopy.partScaleTargets = M.partScaleTargets or {}
stateCopy.partOffsetTargets = M.partOffsetTargets or {}

stateCopy.tireRadiusMult = state.tireRadiusMult or 1.0
stateCopy.tireWidthMult = state.tireWidthMult or 1.0
stateCopy.tireSideSpring = state.tireSideSpring or 1.0
stateCopy.tireSideDamp = state.tireSideDamp or 1.0
stateCopy.tireSideExpSpring = state.tireSideExpSpring or 1.0
stateCopy.tireSideExpDamp = state.tireSideExpDamp or 1.0
stateCopy.tireSidePre = state.tireSidePre or 1.0
stateCopy.tireSideDeform = state.tireSideDeform or 1.0
stateCopy.tireSideStrength = state.tireSideStrength or 1.0
stateCopy.tireReinfSpring = state.tireReinfSpring or 1.0
stateCopy.tireReinfDamp = state.tireReinfDamp or 1.0
stateCopy.tireReinfPre = state.tireReinfPre or 1.0
stateCopy.tireTreadSpring = state.tireTreadSpring or 1.0
stateCopy.tireTreadDamp = state.tireTreadDamp or 1.0
stateCopy.tireTreadPre = state.tireTreadPre or 1.0
stateCopy.tireTreadDeform = state.tireTreadDeform or 1.0
stateCopy.tireTreadStrength = state.tireTreadStrength or 1.0
stateCopy.tireTreadReinfSpring = state.tireTreadReinfSpring or 1.0
stateCopy.tireTreadReinfDamp = state.tireTreadReinfDamp or 1.0
stateCopy.tireTreadReinfPre = state.tireTreadReinfPre or 1.0
stateCopy.tirePeriSpring = state.tirePeriSpring or 1.0
stateCopy.tirePeriDamp = state.tirePeriDamp or 1.0
stateCopy.tirePeriPre = state.tirePeriPre or 1.0
stateCopy.tirePeriDeform = state.tirePeriDeform or 1.0
stateCopy.tirePeriStrength = state.tirePeriStrength or 1.0
stateCopy.tirePeriReinfSpring = state.tirePeriReinfSpring or 1.0
stateCopy.tirePeriReinfDamp = state.tirePeriReinfDamp or 1.0
stateCopy.tirePeriReinfPre = state.tirePeriReinfPre or 1.0
stateCopy.tireNodeWeight = state.tireNodeWeight or 1.0
stateCopy.tireFriction = state.tireFriction or 1.0
stateCopy.tireSliding = state.tireSliding or 1.0

stateCopy.pedalThrustForce = state.pedalThrustForce or 0.0
stateCopy.pedalBrakeForce = state.pedalBrakeForce or 0.0 
stateCopy.thrustX = state.thrustX or 0.0
stateCopy.thrustY = state.thrustY or 0.0
stateCopy.thrustZ = state.thrustZ or 0.0

stateCopy.flyMode = state.flyMode or false
stateCopy.flyHover = state.flyHover or true
stateCopy.flySpeed = state.flySpeed or 15.0
stateCopy.flyPitch = state.flyPitch or 0.0
stateCopy.flyYaw = state.flyYaw or 0.0
stateCopy.flyRoll = state.flyRoll or 0.0
stateCopy.sandParticles = M.sandParticles

-- Вспомогательная функция безопасного чтения локальных переменных турбины (upvalues)
local function getTurboUpvalue(varName)
  local eng = powertrain and powertrain.getDevice("mainEngine")
  local tc = eng and eng.turbocharger
  if not tc then return nil end
  for _, func in pairs(tc) do
    if type(func) == "function" then
      local i = 1
      while true do
        local name, val = debug.getupvalue(func, i)
        if not name then break end
        if name == varName then return val end
        i = i + 1
      end
    end
  end
  return nil
end

-- Безопасный инжектор и обход любых физических лимитов JBeam турбины
local function injectTurboBypass()
  local eng = powertrain and powertrain.getDevice("mainEngine")
  if not eng or not eng.turbocharger or not eng.turbocharger.isExisting then return end
  
  local tc = eng.turbocharger
  _G.CheatMenu_TurboTuner = _G.CheatMenu_TurboTuner or { multiplier = 1.0 }
  
  -- 1. Перехватываем расчет физики и мощности двигателя (каждый шаг симуляции)
  if not tc._originalUpdateFixedStep then
    tc._originalUpdateFixedStep = tc.updateFixedStep
    tc.updateFixedStep = function(dt)
      -- Даем отработать штатной физике игры
      tc._originalUpdateFixedStep(dt)
      
      local mult = _G.CheatMenu_TurboTuner.multiplier or 1.0
      if mult > 1.001 then
        -- Читаем текущее давление из локальной переменной
        local rawPressure = getTurboUpvalue("turboPressure") or 0
        local boostedPressure = rawPressure * mult
        
        -- Пересчитываем итоговую мощность мотора
        local rpm = math.floor(eng.outputRPM or 0)
        local turbo = getTurboUpvalue("turbo")
        local efficiency = (turbo and turbo.turboEfficiencyCurve and turbo.turboEfficiencyCurve[rpm]) or 0.8
        
        -- Откатываем стандартный наддув и накладываем наш чит-наддув
        local baseFactor = (1 + 0.0000087 * rawPressure * efficiency)
        if baseFactor > 0 then
          eng.forcedInductionCoef = (eng.forcedInductionCoef / baseFactor) * (1 + 0.0000087 * boostedPressure * efficiency)
        end
      end
    end
  end
  
  -- 2. Перехватываем приборную панель и датчики интерфейса (каждый кадр)
  if not tc._originalUpdateGFX then
    tc._originalUpdateGFX = tc.updateGFX
    tc.updateGFX = function(dt)
      tc._originalUpdateGFX(dt)
      
      local mult = _G.CheatMenu_TurboTuner.multiplier or 1.0
      if mult > 1.001 then
        -- Масштабируем показатели стрелки наддува на приборке
        local currentBoost = electrics.values.turboBoost or 0
        electrics.values.turboBoost = currentBoost * mult
        electrics.values.turboBoostMax = math.max(electrics.values.turboBoostMax or 0, electrics.values.turboBoost)
      end
    end
  end
end

-- Экспортируем функции в глобальную область машины
_G.getTurboUpvalue = getTurboUpvalue
_G.injectTurboBypass = injectTurboBypass

-- 1. Опрашиваем параметры двигателя mainEngine и его турбины
local eng = powertrain and powertrain.getDevice("mainEngine")
if eng then
  stateCopy.engineBrakeTorque = eng.engineBrakeTorque
  stateCopy.oilTemperature = eng.thermals and eng.thermals.oilTemperature or 0
  stateCopy.coolantTemperature = eng.thermals and eng.thermals.coolantTemperature or 0
  stateCopy.engineBlockTemperature = eng.thermals and eng.thermals.engineBlockTemperature or 0
  
  -- Считываем параметры турбокомпрессора
  if eng.turbocharger and eng.turbocharger.isExisting then
    local tc = eng.turbocharger
    stateCopy.hasTurbo = true
    
    -- Принудительно инжектируем обход лимитов, если он еще не активен
    if not _G.CheatMenu_TurboTuner then
      injectTurboBypass()
    end
    
    -- Настройки множителя из нашего тюнера
    stateCopy.turboMultiplier = (_G.CheatMenu_TurboTuner and _G.CheatMenu_TurboTuner.multiplier) or 1.0
    
    -- Телеметрия давления и оборотов (показывает реальный буст с учетом множителя)
    stateCopy.turboPressurePSI = (electrics.values.turboBoost or 0)
    stateCopy.turboRPM = (tc.turboAV and tc.turboAV * 9.5493) or 0
    
    -- Безопасное чтение настроек из локальных переменных
    stateCopy.antilagCoef = getTurboUpvalue("antilagCoef") or 0
    stateCopy.damageFrictionCoef = getTurboUpvalue("damageFrictionCoef") or 1
    stateCopy.damageExhaustPowerCoef = getTurboUpvalue("damageExhaustPowerCoef") or 1
  else
    stateCopy.hasTurbo = false
  end
  -- Считываем текущее среднее давление в шинах (в PSI)
  local totalPressure = 0
  local wheelCount = 0
  if wheels and wheels.wheels then
    for _, w in pairs(wheels.wheels) do
      if w.wheelID and v.data.wheels then
        local p = 30.0
        local okP, pres = pcall(M.getWheelPressure, w)
        if okP and type(pres) == "number" then p = pres end
        totalPressure = totalPressure + p
        wheelCount = wheelCount + 1
      end
    end
  end
  stateCopy.tirePressurePSI = wheelCount > 0 and (totalPressure / wheelCount) or 30.0
  stateCopy.camberOffset = state.camberOffset or 0.0
  stateCopy.wheelOffset = state.wheelOffset or 0.0
  stateCopy.suspensionSpringMultiplier = state.suspensionSpringMultiplier or 1.0
  stateCopy.suspensionDampMultiplier = state.suspensionDampMultiplier or 1.0

  -- Проверяем, установлены ли на машине шины [2]
  local hasTires = false
  if wheels and wheels.wheels and v.data and v.data.wheels then
    for _, wheel in pairs(wheels.wheels) do
      for _, jbWheel in ipairs(v.data.wheels) do
        if jbWheel.wheelID == wheel.wheelID and jbWheel.treadNodes then
          hasTires = true
          break
        end
      end
      if hasTires then break end
    end
  end
  stateCopy.hasTires = hasTires
  stateCopy.tireStiffnessMult = state.tireStiffnessMult or 1.0
  stateCopy.tireDampMult = state.tireDampMult or 1.0
  stateCopy.tireFrictionMult = state.tireFrictionMult or 1.0
  stateCopy.tireSlidingMult = state.tireSlidingMult or 1.0
end

-- 2. Считываем данные по накопителям энергии (топливные баки, батареи)
local storages = {}
if energyStorage and energyStorage.getStorages then
  for name, storage in pairs(energyStorage.getStorages() or {}) do
    storages[name] = {
      type = storage.type or "unknown",
      remainingRatio = storage.remainingRatio or 0,
      remainingVolume = storage.remainingVolume or 0,
      capacity = storage.capacity or 0,
    }
  end
end
stateCopy.energyStorages = storages

-- 3. Считываем данные по всем компонентам трансмиссии (универсальный сбор + thermals)
local devices = {}
if powertrain and powertrain.getDevices then
  for name, device in pairs(powertrain.getDevices() or {}) do
    local devProps = {}
    for k, v in pairs(device) do
      local t = type(v)
      if t == "number" or t == "boolean" or t == "string" then
        if k ~= "name" and k ~= "type" then
          devProps[k] = v
        end
      end
    end
    -- Сканируем вложенные тепловые свойства деталей (включая РАДИАТОР, прокладки и т.д.)
    if device.thermals and type(device.thermals) == "table" then
      for k, v in pairs(device.thermals) do
        local t = type(v)
        if t == "number" or t == "boolean" or t == "string" then
          devProps["thermals." .. k] = v
        end
      end
    end
    devices[name] = {
      type = device.type or "unknown",
      isBroken = device.isBroken or false,
      props = devProps
    }
  end
end
stateCopy.powertrainDevices = devices

-- 4. Универсальный сбор абсолютно всех температур в машине!
local allTemps = {}
if powertrain and powertrain.getDevices then
  for devName, device in pairs(powertrain.getDevices() or {}) do
    for k, v in pairs(device) do
      if type(v) == "number" and type(k) == "string" and (string.find(k:lower(), "temp") or string.find(k:lower(), "temperature")) then
        allTemps[devName .. "." .. k] = v
      end
    end
    if device.thermals and type(device.thermals) == "table" then
      for k, v in pairs(device.thermals) do
        if type(v) == "number" and type(k) == "string" and (string.find(k:lower(), "temp") or string.find(k:lower(), "temperature")) then
          allTemps[devName .. ".thermals." .. k] = v
        end
      end
    end
  end
end
-- Добавляем температуру тормозных дисков
if wheels and wheels.wheels then
  for i, wi in pairs(wheels.wheels) do
    local name = wi.name or ("wheel_" .. tostring(i))
    if wi.brakeThermal and type(wi.brakeThermal) == "table" then
      for k, v in pairs(wi.brakeThermal) do
        if type(v) == "number" and type(k) == "string" and (string.find(k:lower(), "temp") or string.find(k:lower(), "temperature")) then
          allTemps["wheel." .. name .. ".brakeThermal." .. k] = v
        end
      end
    end
  end
end
stateCopy.engineThermals = allTemps
stateCopy.powertrainDefaults = M.powertrainDefaults

-- 5. Считываем данные из главного контроллера автомобиля (vehicleController.lua)
local mainCtrl = controller and controller.getController("vehicleController")
if mainCtrl then
  stateCopy.gearboxMode = electrics.values.gearboxMode or "unknown"
  stateCopy.freezeState = electrics.values.freezeState or false
  stateCopy.drivingAggression = mainCtrl.drivingAggression or 0
  stateCopy.ignitionLevel = electrics.values.ignitionLevel or 0
  stateCopy.isEngineRunning = electrics.values.engineRunning or 0
  stateCopy.fireEngineTemperature = mainCtrl.fireEngineTemperature or 0
  if mainCtrl.engineInfo then
    stateCopy.flywheelTorque = mainCtrl.engineInfo[9] or 0
    stateCopy.gearboxTorque = mainCtrl.engineInfo[10] or 0
    stateCopy.wheelTorque = mainCtrl.engineInfo[20] or 0
    stateCopy.wheelPowerHP = mainCtrl.engineInfo[21] or 0
    stateCopy.enginePowerHP = mainCtrl.engineInfo[22] or 0
  end
  stateCopy.fuelRatio = electrics.values.fuel or 0
  stateCopy.fuelVolume = electrics.values.fuelVolume or 0
  stateCopy.fuelCapacity = electrics.values.fuelCapacity or 0
  stateCopy.isShifting = electrics.values.isShifting or false
  stateCopy.gearName = electrics.values.gear or "N"
  stateCopy.clutchRatio = electrics.values.clutchRatio or 0
  stateCopy.engineThrottle = electrics.values.engineThrottle or 0
  stateCopy.engineLoad = electrics.values.engineLoad or 0
  stateCopy.radiatorFanSpin = electrics.values.radiatorFanSpin or 0
  stateCopy.checkEngine = electrics.values.checkengine or false
  stateCopy.oiltemp = electrics.values.oiltemp or 0
  stateCopy.watertemp = electrics.values.watertemp or 0
  stateCopy.maxrpm = electrics.values.maxrpm or 0
  stateCopy.idlerpm = electrics.values.idlerpm or 0
  stateCopy.pedalThrottle = electrics.values.throttle or 0
  stateCopy.pedalBrake = electrics.values.brake or 0
  stateCopy.pedalClutch = electrics.values.clutch or 0
end

-- 5. Считываем данные из контроллера ESC & TCS (esc.lua)
-- 5. Считываем данные из систем стабилизации (поддержка старого ESC и нового DriveModes/DSE)
local escCtrl = controller and controller.getController("esc")
local dmCtrl = controller and controller.getController("driveModes")

if escCtrl then
  stateCopy.hasESCSystem = true
  stateCopy.escSystemType = "esc"
  stateCopy.pauseESCAction = escCtrl.pauseESCAction or false
  stateCopy.escActive = electrics.values.escActive or 0
  stateCopy.tcsActive = electrics.values.tcsActive or 0
  
  -- Сбор режимов для классического ESC
  local escConfigsList = {}
  local currentKey = 1
  if escCtrl.setESCMode then
    local i = 1
    while true do
      local name, val = debug.getupvalue(escCtrl.setESCMode, i)
      if not name then break end
      if name == "escConfigurations" then
        for idx, config in ipairs(val or {}) do
          table.insert(escConfigsList, {key = idx, name = config.name})
        end
      elseif name == "currentESCConfigurationKey" then
        currentKey = val
      end
      i = i + 1
    end
  end
  stateCopy.escConfigs = escConfigsList
  stateCopy.currentESCKey = currentKey
  
  local escFailureVal = false
  if escCtrl.updateWheelsIntermediate then
    local idx = 1
    while true do
      local name, val = debug.getupvalue(escCtrl.updateWheelsIntermediate, idx)
      if not name then break end
      if name == "escFailure" then
        escFailureVal = val
      end
      idx = idx + 1
    end
  end
  stateCopy.escFailure = escFailureVal
  
  local currentConfig = escCtrl.getCurrentConfigData and escCtrl.getCurrentConfigData()
  if currentConfig then
    stateCopy.escName = currentConfig.name or "Unknown"
    stateCopy.slipThreshold = currentConfig.slipThreshold or 0
    stateCopy.escThreshold = currentConfig.escThreshold or 0
  end
  
elseif dmCtrl then
  stateCopy.hasESCSystem = true
  stateCopy.escSystemType = "driveModes"
  stateCopy.pauseESCAction = false
  stateCopy.escActive = electrics.values.escActive or 0
  stateCopy.tcsActive = electrics.values.tcsActive or 0
  stateCopy.escFailure = false
  
  -- Получаем текущий активный профиль вождения
  local activeModeKey = dmCtrl.serialize and dmCtrl.serialize().activeDriveModeKey
  stateCopy.currentESCKey = activeModeKey or "unknown"
  
  -- Считываем все доступные режимы вождения из jbeam автомобиля
  local escConfigsList = {}
  if v.data and v.data.driveModes and v.data.driveModes.modes then
    for modeKey, modeData in pairs(v.data.driveModes.modes) do
      table.insert(escConfigsList, {key = modeKey, name = modeData.name or modeKey})
    end
  end
  stateCopy.escConfigs = escConfigsList
  stateCopy.escName = (v.data and v.data.driveModes and v.data.driveModes.modes[activeModeKey] and v.data.driveModes.modes[activeModeKey].name) or activeModeKey or "Unknown"
  stateCopy.slipThreshold = 0
  stateCopy.escThreshold = 0
else
  stateCopy.hasESCSystem = false
end

local stateJson = jsonEncode(stateCopy)

-- Собираем список уникальных деталей с их понятными именами
local uniquePartsList = {}
if M.getUniqueParts then
  for _, part in ipairs(M.getUniqueParts() or {}) do
    table.insert(uniquePartsList, {
      name = part,
      friendly = getPartFriendlyName(part)
    })
  end
end
local uniquePartsList = uniquePartsList or {}
local uniquePartsJson = jsonEncode(uniquePartsList)

-- Изолируем JSON-массив с помощью [===[ %s ]===], чтобы избежать ложного закрытия скобок
local geCommand = string.format([=[
  if not _G.CheatMenuWindow_Data then _G.CheatMenuWindow_Data = { vehicleStates = {}, parts = {} } end
  _G.CheatMenuWindow_Data.vehicleStates[%d] = jsonDecode([===[%s]===])
  _G.CheatMenuWindow_Data.parts[%d] = jsonDecode([===[%s]===])
]=], vehicleId, stateJson, vehicleId, uniquePartsJson)

  obj:queueGameEngineLua(geCommand)
end

-- Универсальная функция записи свойств девайсов трансмиссии (поддерживает вложенность)
function M.setDeviceProperty(devName, propName, value)
  local d = powertrain and powertrain.getDevice(devName)
  if d then
    if string.find(propName, "%.") then
      local parts = {}
      for part in string.gmatch(propName, "[^%.]+") do
        table.insert(parts, part)
      end
      local sub = parts[1]
      local key = parts[2]
      if sub and key and d[sub] then
        d[sub][key] = value
      end
    else
      d[propName] = value
    end
  end
end

-- Универсальная функция парсинга путей и изменения температур
function M.setVehicleThermal(path, value)
  local parts = {}
  for part in string.gmatch(path, "[^%.]+") do
    table.insert(parts, part)
  end
  
  if parts[1] == "wheel" then
    local wheelName = parts[2]
    local sub = parts[3]
    local key = parts[4]
    if wheelName and sub and key and wheels and wheels.wheels then
      for _, wi in pairs(wheels.wheels) do
        if wi.name == wheelName and wi[sub] then
          wi[sub][key] = value
        end
      end
    end
  else
    local devName = parts[1]
    local subOrKey = parts[2]
    local key = parts[3]
    if devName then
      local d = powertrain and powertrain.getDevice(devName)
      if d then
        if key then
          if d[subOrKey] then
            d[subOrKey][key] = value
          end
        else
          d[subOrKey] = value
        end
      end
    end
  end
end









-- Хранилище поперечных рычагов для динамического развала колес (camber)
M.camberBeams = {}

-- Функция автоматического поиска поперечных рычагов подвески
function M.scanCamberBeams()
  M.camberBeams = {}
  if not v or not v.data or not v.data.beams or not wheels or not wheels.wheels then return end
  
  -- Собираем физические узлы ступиц и колес
  local wheelHubNodes = {}
  for _, wheel in pairs(wheels.wheels) do
    if wheel.node1 then wheelHubNodes[wheel.node1] = true end
    if wheel.node2 then wheelHubNodes[wheel.node2] = true end
    if wheel.nodeS then wheelHubNodes[wheel.nodeS] = true end
    if v.data.wheels and v.data.wheels[wheel.wheelID] then
      local wData = v.data.wheels[wheel.wheelID]
      if wData.nodes then
        for _, nid in pairs(wData.nodes) do wheelHubNodes[nid] = true end
      end
    end
  end
  
  for cid, beam in pairs(v.data.beams) do
    if type(cid) == "number" and beam.cid then
      local n1 = v.data.nodes[beam.id1]
      local n2 = v.data.nodes[beam.id2]
      
      if n1 and n2 then
        local isN1Wheel = wheelHubNodes[beam.id1]
        local isN2Wheel = wheelHubNodes[beam.id2]
        
        -- Нам нужны только балки, соединяющие колесо/ступицу с подвеской или кузовом
        if (isN1Wheel and not isN2Wheel) or (isN2Wheel and not isN1Wheel) then
          local hubNode = isN1Wheel and n1 or n2
          local chassisNode = isN1Wheel and n2 or n1
          
          local dx = math.abs(hubNode.pos.x - chassisNode.pos.x)
          local dy = math.abs(hubNode.pos.y - chassisNode.pos.y)
          
          -- Если балка идет в основном по оси X (поперечно) — это рычаг подвески
          if dx > dy and dx > 0.1 then
            -- ТОЧНОЕ ОПРЕДЕЛЕНИЕ: если крепление на кузове выше оси колеса, это верхний рычаг/стойка!
            local isUpper = (chassisNode.pos.z > hubNode.pos.z)
            
            table.insert(M.camberBeams, {
              cid = beam.cid,
              isUpper = isUpper,
              baseLength = obj:getBeamLength(beam.cid) or 1.0
            })
          end
        end
      end
    end
  end
end

-- Единая функция расчета развала колес (camber) и вылета (wheel offset) [2]
function M.applyCamberAndOffset(camberVal, offsetVal)
  state.camberOffset = camberVal
  state.wheelOffset = offsetVal

  if not M.camberBeams or #M.camberBeams == 0 then
    M.scanCamberBeams()
  end
  M.camberBeams = M.camberBeams or {}
  
  for _, b in ipairs(M.camberBeams) do
    if b.isUpper then
      -- Верхний рычаг: развал укорачивает, вылет удлиняет [2]
      obj:setBeamLengthRefRatio(b.cid, 1.0 + offsetVal - camberVal)
    else
      -- Нижний рычаг: развал удлиняет, вылет удлиняет [2]
      obj:setBeamLengthRefRatio(b.cid, 1.0 + offsetVal + camberVal)
    end
  end
end

-- Функция применения давления во всех шинах в реальном времени (физическая регулировка)
function M.applyTirePressure(pressurePSI)
  if not wheels or not wheels.wheels or not v or not v.data or not v.data.pressureGroups or not v.data.wheels then return end
  
  -- Переводим относительные PSI в абсолютные Паскали (прибавляя 1 атмосферу = 101325 Па)
  local pascalAbsolute = (pressurePSI * 6894.757293178) + 101325
  
  for _, wheel in pairs(wheels.wheels) do
    local wd = nil
    for _, jbWheel in ipairs(v.data.wheels) do
      if jbWheel.wheelID == wheel.wheelID then
        wd = jbWheel
        break
      end
    end
    
    if wd and wd.pressureGroup then
      local pgId = v.data.pressureGroups[wd.pressureGroup]
      if pgId then
        -- Выставляем абсолютное давление в группе шины
        obj:setGroupPressure(pgId, pascalAbsolute)
      end
    end
  end
end

-- Функция изменения жесткости и демпфирования подвески в реальном времени
function M.applySuspensionTuning(springMult, dampMult)
  state.suspensionSpringMultiplier = springMult
  state.suspensionDampMultiplier = dampMult
  
  if next(suspensionBeams) == nil then
    cacheSuspensionBeams()
  end
  
  for cid, original in pairs(suspensionBeams) do
    if type(original) == "table" then
      local newSpring = original.beamSpring * springMult
      local newDamp = original.beamDamp * dampMult
      obj:setBeamSpringDamp(cid, newSpring, newDamp, original.springExpansion, original.dampExpansion)
    end
  end
end

-- Экспортируем функции в глобальную область машины
_G.applyCamberAndOffset = M.applyCamberAndOffset
_G.applyTirePressure = M.applyTirePressure
_G.applySuspensionTuning = M.applySuspensionTuning









-- Хранилища оригинальных параметров балок и узлов шин для безопасного масштабирования [2]
M.originalTireBeams = {}
M.originalTreadFriction = {}

-- Функция изменения жесткости и демпфирования балок шин в реальном времени [2.1.1, 2.4.1]
function M.applyTireStiffness(stiffnessMult, dampMult)
  state.tireStiffnessMult = stiffnessMult
  state.tireDampMult = dampMult
  
  if not wheels or not wheels.wheels or not v or not v.data or not v.data.wheels then return end
  
  for _, wheel in pairs(wheels.wheels) do
    local wd = nil
    for _, jbWheel in ipairs(v.data.wheels) do
      if jbWheel.wheelID == wheel.wheelID then
        wd = jbWheel
        break
      end
    end
    
    if wd then
      -- Собираем все балки боковины, протектора и корда колеса [2]
      local beamsToScale = {}
      if wd.peripheryBeams then
        for _, bid in ipairs(wd.peripheryBeams) do beamsToScale[bid] = true end
      end
      if wd.sideBeams then
        for _, bid in ipairs(wd.sideBeams) do beamsToScale[bid] = true end
      end
      if wd.reinfBeams then
        for _, bid in ipairs(wd.reinfBeams) do beamsToScale[bid] = true end
      end
      if wd.treadBeams then
        for _, bid in ipairs(wd.treadBeams) do beamsToScale[bid] = true end
      end
      
      for bid, _ in pairs(beamsToScale) do
        -- Кэшируем оригинальные характеристики балок из JBeam при первом изменении [2]
        if not M.originalTireBeams[bid] then
          local jbBeam = v.data.beams[bid]
          if jbBeam then
            M.originalTireBeams[bid] = {
              spring = jbBeam.beamSpring or 40000,
              damp = jbBeam.beamDamp or 100
            }
          end
        end
        
        local orig = M.originalTireBeams[bid]
        if orig then
          -- Применяем жесткость и демпфирование к балкам шины в реальном времени [2]
          obj:setBeamSpringDamp(bid, orig.spring * stiffnessMult, orig.damp * dampMult, -1, -1)
        end
      end
    end
  end
end

-- Функция регулирования статического и скользящего трения шин в реальном времени [2.4.1]
function M.applyTireFriction(frictionMult, slidingMult)
  state.tireFrictionMult = frictionMult
  state.tireSlidingMult = slidingMult
  
  if not wheels or not wheels.wheels or not v or not v.data or not v.data.wheels then return end
  
  for _, wheel in pairs(wheels.wheels) do
    local wd = nil
    for _, jbWheel in ipairs(v.data.wheels) do
      if jbWheel.wheelID == wheel.wheelID then
        wd = jbWheel
        break
      end
    end
    
    if wd and wd.treadNodes then
      for _, nodecid in ipairs(wd.treadNodes) do
        -- Кэшируем оригинальное трение протектора из JBeam [2]
        if not M.originalTreadFriction[nodecid] then
          local nodeData = v.data.nodes[nodecid]
          if nodeData then
            M.originalTreadFriction[nodecid] = {
              friction = nodeData.frictionCoef or 1.0,
              slidingFriction = nodeData.slidingFrictionCoef or 1.0
            }
          end
        end
        
        local orig = M.originalTreadFriction[nodecid]
        if orig then
          -- Применяем умноженное сцепление напрямую к узлам протектора [2.4.1]
          obj:setNodeFrictionSlidingCoefs(nodecid, orig.friction * frictionMult, orig.slidingFriction * slidingMult)
        end
      end
    end
  end
end

-- Экспортируем функции в глобальную область машины
_G.applyTireStiffness = M.applyTireStiffness
_G.applyTireFriction = M.applyTireFriction






-- СВЕРХНАДЕЖНЫЙ СКАНЕР И РЕДАКТОР ПРОЧНОСТИ (С АДАПТАЦИЕЙ ПОД НОВУЮ ВЕРСИЮ)

M.partBeamStrengthCache = {}

-- Безопасная конвертация любых типов данных JBeam в число
local function parseStrength(val)
  if type(val) == "number" then
    return val
  elseif type(val) == "string" then
    if val == "FLT_MAX" or val == "math.huge" or val == "huge" or val == "INF" then
      return 1e10
    end
    return tonumber(val) or 1000000.0
  end
  return 1000000.0
end

-- Сканирование всех деталей
function M.scanPartBeamStrengths()
  M.partBeamStrengthCache = {}
  M.partBeamDeformCache = {}
  if not v or not v.data or not v.data.beams then return end

  for _, beam in pairs(v.data.beams) do
    if beam and beam.cid ~= nil then
      local partName = tostring(beam.partOrigin or "body")
      if partName == "" or partName == "nil" then partName = "body" end

      if not M.partBeamStrengthCache[partName] then
        M.partBeamStrengthCache[partName] = {}
      end

      local origStr = parseStrength(beam.beamStrength)
      local origDef = parseStrength(beam.beamDeform)
      if origDef <= 0 or origDef >= 1e14 then
        origDef = math.min(220000, math.max(8000, origStr * 0.42))
      end
      M.partBeamDeformCache[beam.cid] = origDef
      
      -- Фильтруем только корректные положительные значения
      if origStr > 0 and origStr < 1e15 then
        M.partBeamStrengthCache[partName][beam.cid] = origStr
      end
    end
  end
end

function M.releaseDrivePresetPlayerInput()
  if not electrics or not electrics.values then return end
  -- Ne pas toucher throttle : laisser clavier / manette gérer
  electrics.values.brake = 0
  if electrics.values.parkingbrake ~= nil then electrics.values.parkingbrake = 0 end
  if electrics.values.parkingBrake ~= nil then electrics.values.parkingBrake = 0 end
  if electrics.values.clutch ~= nil then electrics.values.clutch = 0 end
end

function M.hardStopVehiclePhysics()
  M.zeroMotionForDrivePreset(false)
  if not obj or not obj.getRefNodeId or not obj.applyClusterVelocityScaleAdd then return end
  local vel = obj.getVelocity and obj:getVelocity()
  if vel then
    local vx, vy, vz = vel.x, vel.y, vel.z
    if vx ~= vx or vy ~= vy or vz ~= vz then return end
  end
  local ref = obj:getRefNodeId()
  if ref then
    obj:applyClusterVelocityScaleAdd(ref, 0, 0, 0, 0)
  end
end

-- Remet vitesse roues / moteur à zéro (sans bloquer les inputs joueur)
function M.zeroMotionForDrivePreset(hardReset)
  if wheels and wheels.wheels then
    for _, w in pairs(wheels.wheels) do
      w.angularVelocity = 0
      w.angularVelocityBrakeCouple = 0
      if w.lastAngularVelocity then w.lastAngularVelocity = 0 end
      if w.lastAngularVelocityBrakeCouple then w.lastAngularVelocityBrakeCouple = 0 end
    end
  end
  if powertrain and powertrain.getDevices then
    for _, d in pairs(powertrain.getDevices()) do
      for _, key in ipairs({"outputAV", "inputAV", "engineAV", "engAV", "virtualMassAV"}) do
        if d[key] ~= nil then d[key] = 0 end
      end
    end
  end
  M._drivePresetSettleFrames = hardReset and 120 or 60
  -- Jamais requestReset ici : ça rappelle onVehicleResetted → boucle respawn infinie
end

local function isDriveModuleEnabled(cfg, moduleId)
  if not cfg or not cfg.moduleOff then return true end
  return cfg.moduleOff[moduleId] ~= true
end

local function logDrivePresetModules(cfg)
  if not cfg or not log then return end
  local off, on = {}, {}
  local ids = {
    "globalStrength", "indestructibleEngine", "freezeThermals", "suspension",
    "superTires", "tireFriction", "grip", "brakes", "gravity",
    "power", "rpm", "drag", "engineBrake",
  }
  for _, id in ipairs(ids) do
    if isDriveModuleEnabled(cfg, id) then on[#on + 1] = id else off[#off + 1] = id end
  end
  log("I", "cheatMenuDrive", string.format(
    "applyDrivePreset %s | ON: %s | OFF: %s",
    tostring(cfg.presetId or "?"),
    table.concat(on, ","),
    #off > 0 and table.concat(off, ",") or "(none)"
  ))
end

local function drivePresetBuildAdvancedTire(overrides)
  local p = {
    radius = 1, width = 1, sideSpring = 1, sideDamp = 1, sideExpSpring = 1, sideExpDamp = 1,
    sidePre = 1, sideDeform = 1, sideStrength = 1,
    reinfSpring = 1, reinfDamp = 1, reinfPre = 1,
    treadSpring = 1, treadDamp = 1, treadPre = 1, treadDeform = 1, treadStrength = 1,
    treadReinfSpring = 1, treadReinfDamp = 1, treadReinfPre = 1,
    periSpring = 1, periDamp = 1, periPre = 1, periDeform = 1, periStrength = 1,
    periReinfSpring = 1, periReinfDamp = 1, periReinfPre = 1,
    nodeWeight = 1, friction = 1, sliding = 1,
  }
  if type(overrides) == "table" then
    for k, v in pairs(overrides) do p[k] = v end
  end
  return p
end

function drivePresetApplyGripPackage(cfg)
  if not cfg then return end
  if M.scanPressureWheels and (not M.pressureWheelsCache or not next(M.pressureWheelsCache)) then
    M.scanPressureWheels()
  end

  if isDriveModuleEnabled(cfg, "grip") and cfg.gripMultiplier then
    state.gripMultiplier = cfg.gripMultiplier
  end
  if cfg.stickyGrip == true then
    state.stickyGrip = true
    state.stickyGripForce = cfg.stickyGripForce or 0.35
  end

  if cfg.superTires and applySuperTires and isDriveModuleEnabled(cfg, "superTires") then
    applySuperTires(true)
  end

  if cfg.advancedTireTuning and M.applyAdvancedTireTuning and isDriveModuleEnabled(cfg, "tireFriction") then
    M.applyAdvancedTireTuning(drivePresetBuildAdvancedTire(cfg.advancedTireTuning))
  end
  if cfg.tireStiffnessMult and M.applyTireStiffness and isDriveModuleEnabled(cfg, "tireFriction") then
    M.applyTireStiffness(cfg.tireStiffnessMult, cfg.tireDampMult or (cfg.tireStiffnessMult * 1.08))
  end
  if cfg.tireFrictionMult and M.applyTireFriction and isDriveModuleEnabled(cfg, "tireFriction") then
    M.applyTireFriction(cfg.tireFrictionMult, cfg.tireSlidingMult or cfg.tireFrictionMult)
  end
  if applyGripMultiplier then applyGripMultiplier() end
  if cfg.tirePressurePSI and M.applyTirePressure then
    M.applyTirePressure(cfg.tirePressurePSI)
  end

  if wheels and wheels.wheels then
    for _, w in pairs(wheels.wheels) do
      w.isBroken = false
      w.isInflated = true
      w.isTireDeflated = false
      w.tireBurstAV = math.huge
    end
  end
end

function M.refreshDrivePresetGrip()
  if not state.drivePresetActive or not M._drivePresetLastCfg then return end
  drivePresetApplyGripPackage(M._drivePresetLastCfg)
end

-- Preset conduite (GE) : ordre safe, pas de god mode sur toutes les beams
function M.getPrimaryEngineDevice()
  if not powertrain then return nil end
  if powertrain.getDevice then
    local main = powertrain.getDevice("mainEngine")
    if main and main.torqueCurve then return main end
  end
  local engines = powertrain.getDevicesByCategory and powertrain.getDevicesByCategory("engine") or {}
  for _, eng in ipairs(engines) do
    if eng and eng.torqueCurve then return eng end
  end
  return engines[1]
end

function M.pushTorqueCurveToGe(forceRebuild)
  local eng = M.getPrimaryEngineDevice()
  if not eng or not eng.torqueCurve then
    if log then log("W", "cheatMenuDrive", "pushTorqueCurveToGe: no engine / torqueCurve") end
    return false
  end
  if forceRebuild or not eng.customTorquePoints or #eng.customTorquePoints == 0 then
    eng.customTorquePoints = {}
    local step = 500
    local maxRPM = math.floor(eng.maxRPM or 8000)
    if maxRPM > 12000 then step = 1000 end
    for rpm = 0, maxRPM, step do
      local torque = eng.torqueCurve[rpm] or eng.torqueCurve[math.floor(rpm)] or 0
      table.insert(eng.customTorquePoints, { rpm, torque })
    end
    if not eng.factoryTorquePoints or #eng.factoryTorquePoints == 0 then
      eng.factoryTorquePoints = {}
      for _, pt in ipairs(eng.customTorquePoints) do
        table.insert(eng.factoryTorquePoints, { pt[1], pt[2] })
      end
    end
  end
  if not jsonEncode then return false end
  local vid = obj:getID()
  local payload = jsonEncode(eng.customTorquePoints)
  obj:queueGameEngineLua(
    "if not _G.CheatMenuWindow_Data then _G.CheatMenuWindow_Data = { vehicleStates = {}, parts = {} } end\n"
    .. "if not _G.CheatMenuWindow_Data.torqueCurve then _G.CheatMenuWindow_Data.torqueCurve = {} end\n"
    .. "local ok, t = pcall(jsonDecode, [===[" .. payload .. "]===])\n"
    .. "if ok and type(t) == 'table' then _G.CheatMenuWindow_Data.torqueCurve[" .. tostring(vid) .. "] = t end")
  if log then
    log("I", "cheatMenuDrive", string.format(
      "pushTorqueCurveToGe: %s (%d pts, maxRPM %s)",
      tostring(eng.name or "?"), #eng.customTorquePoints, tostring(eng.maxRPM)))
  end
  return true
end

local function notifyDrivePresetUiSync()
  if not obj then return end
  local vid = obj:getID()
  obj:queueGameEngineLua(string.format(
    "if extensions.cheatMenuu and extensions.cheatMenuu.onDrivePresetPowerApplied then extensions.cheatMenuu.onDrivePresetPowerApplied(%d) end",
    vid))
end

local function drivePresetApplyPowertrainFromCfg(cfg)
  if not cfg then return end
  state.powerMultiplier = isDriveModuleEnabled(cfg, "power") and (cfg.powerMultiplier or 1) or 1
  state.rpmMultiplier = isDriveModuleEnabled(cfg, "rpm") and (cfg.rpmMultiplier or 1) or 1
  state.dragMultiplier = isDriveModuleEnabled(cfg, "drag") and (cfg.dragMultiplier or 1) or 1
  state.engineBrakeMultiplier = isDriveModuleEnabled(cfg, "engineBrake") and (cfg.engineBrakeMultiplier or 1) or 1
  needsPowerBaseRefresh = true
  M._drivePresetTorqueBlend = 1
  M._drivePresetTorqueRefreshAcc = 0
  M._drivePresetPendingPower = nil
  M._drivePresetPowerUnlockFrames = 0
  if state.rpmMultiplier > 1.001 and applyRPMMultiplier then applyRPMMultiplier() end
  if (state.dragMultiplier < 0.999 or state.dragMultiplier > 1.001) and applyDragAndCompensate then applyDragAndCompensate() end
  if state.powerMultiplier > 1.001 and applyPowerMultiplier then applyPowerMultiplier() end
  if applyGearingMultiplier and math.abs(state.gearMultiplier - 1) > 0.001 then applyGearingMultiplier() end
  if log then
    log("I", "cheatMenuDrive", string.format(
      "drivePreset powertrain: p=%s rpm=%s drag=%s",
      tostring(state.powerMultiplier), tostring(state.rpmMultiplier), tostring(state.dragMultiplier)))
  end
end

function M.applyDrivePreset(cfgJson)
  local cfg = type(cfgJson) == "table" and cfgJson or (jsonDecode and jsonDecode(cfgJson))
  if not cfg then return end
  M._drivePresetModuleOff = cfg.moduleOff or {}
  M._drivePresetLastCfg = cfg
  logDrivePresetModules(cfg)

  activeFlags.power = false
  activeFlags.rpm = false
  activeFlags.engineBrake = false

  local afterRespawn = _G.CheatMenu_DrivePresetRespawnApply == true
  local freshSpawn = _G.CheatMenu_DrivePresetFreshSpawn == true
  local softReapply = _G.CheatMenu_DrivePresetSoftReapply == true
  _G.CheatMenu_DrivePresetRespawnApply = false
  _G.CheatMenu_DrivePresetFreshSpawn = false
  _G.CheatMenu_DrivePresetSoftReapply = false

  local wantPowerEarly = isDriveModuleEnabled(cfg, "power") and (cfg.powerMultiplier or 1) or 1
  if softReapply and state.drivePresetActive and state.powerMultiplier >= wantPowerEarly * 0.85 then
    if cfg.globalStrengthMult and M.applyGlobalBeamStrengthMult and isDriveModuleEnabled(cfg, "globalStrength") then
      M.applyGlobalBeamStrengthMult(cfg.globalStrengthMult)
      if cfg.structuralBoost and M.applyDrivePresetStructuralReinforce then
        M.applyDrivePresetStructuralReinforce(cfg.structuralBoost)
      end
    end
    drivePresetApplyGripPackage(cfg)
    if applyBrakeMultiplier then applyBrakeMultiplier() end
    if cfg.awdOnPreset == true and applyAWD then
      state.awdMode = true
      applyAWD(true)
    end
    M._drivePresetCollisionArmor = cfg.collisionProof ~= false
    if M._drivePresetCollisionArmor and M.applyDrivePresetCollisionArmor then
      M.applyDrivePresetCollisionArmor()
    end
    if M.refreshDrivePresetActiveFlag then M.refreshDrivePresetActiveFlag() end
    if log then log("I", "cheatMenuDrive", "softReapply chassis only, power kept") end
    return
  end

  _G.CheatMenu_DrivePresetSuppressResetHook = true
  if afterRespawn or freshSpawn then
    M.zeroMotionForDrivePreset(true)
    M._drivePresetSettleFrames = freshSpawn and 90 or 60
  end

  -- Preset conduite : pas de god mode beams (1e10) → ca fige / tord la caisse
  state.invulnerableMultiplier = 1
  state.drivePresetTorqueProfile = cfg.torqueProfile
  state.camberOffset = 0
  state.wheelOffset = 0
  if M.applyCamberAndOffset then M.applyCamberAndOffset(0, 0) end
  M._drivePresetTorqueBlend = 1
  M._drivePresetTorqueRefreshAcc = 0
  M._drivePresetWheelClampFrames = 0
  M._drivePresetStallGuardAcc = 0

  if cfg.indestructibleEngine and isDriveModuleEnabled(cfg, "indestructibleEngine") then
    state.indestructibleEngine = true
    if healDrivetrain then healDrivetrain() end
  end
  if cfg.freezeThermals and isDriveModuleEnabled(cfg, "freezeThermals") then
    state.freezeThermals = true
    if forceThermalsCooldown then forceThermalsCooldown() end
  end

  if cfg.globalStrengthMult and M.applyGlobalBeamStrengthMult and isDriveModuleEnabled(cfg, "globalStrength") then
    M.applyGlobalBeamStrengthMult(cfg.globalStrengthMult)
    if cfg.structuralBoost and M.applyDrivePresetStructuralReinforce then
      M.applyDrivePresetStructuralReinforce(cfg.structuralBoost)
    end
  end
  M._drivePresetCollisionArmor = cfg.collisionProof ~= false
  if M._drivePresetCollisionArmor and M.applyDrivePresetCollisionArmor then
    M.applyDrivePresetCollisionArmor()
  end
  if state.indestructibleEngine and healDrivetrain then healDrivetrain() end

  state.drivePresetStabilityAssist = cfg.driveStabilityAssist == true
  M._drivePresetLastCfgId = cfg.presetId
  M._drivePresetBrakeExtraMult = tonumber(cfg.brakeExtraMult) or 1
  M._drivePresetBrakePressureGain = tonumber(cfg.brakePressureGain) or 1
  M._drivePresetBrakeSpringGain = (cfg.presetId == "scintilla" or cfg.presetId == "etk_series") and 1.22 or 1
  M._drivePresetHardBrakeThreshold = cfg.hardBrakeThreshold or 0.38
  M._drivePresetHardBrakeGain = cfg.hardBrakeGain
  M._drivePresetHardBrakePressureBoost = cfg.hardBrakePressureBoost
  M._drivePresetHardEngineBrakeBoost = cfg.hardEngineBrakeBoost
  M._drivePresetBaseEngineBrake = state.engineBrakeMultiplier or 1
  M._drivePresetStabilityGain = cfg.stabilityAssistGain or 1.0
  M._drivePresetYawDampGain = cfg.stabilityYawDampGain or 0
  M._drivePresetTcsMaxSpeed = cfg.tractionControlMaxSpeed or 32
  M._drivePresetDisableTcs = cfg.disableTractionControl == true
  M._drivePresetWl40BypassGovernor = cfg.unlockIndustrialGovernor == true
  if cfg.presetId == "wl40" or cfg.unlockIndustrialGovernor == true then
    M._drivePresetWl40BypassGovernor = true
  end
  M._drivePresetStabilitySteerMax = cfg.stabilityStraightSteerMax or 0.3
  M._drivePresetLaunchRampSec = cfg.launchTorqueRampSec or 0
  M._drivePresetLaunchMinFactor = cfg.launchTorqueMinFactor or 0.4
  M._drivePresetLaunchBlend = 0
  M._drivePresetLaunchPowerAcc = 0
  M._drivePresetTorqueLowScale = cfg.torqueLowEndScale or 1.0
  M._drivePresetTcsStrength = cfg.tractionControlStrength or 1.0
  M._drivePresetDownforceGain = cfg.downforceAssistGain or 0
  M._drivePresetLaneKeepGain = cfg.laneKeepGain or 0
  M._drivePresetDrivetrainHealAcc = 0
  M._drivePresetDisableTireMorph = cfg.disableTireTreadMorph == true
  M._drivePresetPauseEsc = cfg.pauseGameEsc == true
  M._drivePresetGripRefreshAcc = 0
  if cfg.stickyGrip ~= true then
    state.stickyGrip = false
  end

  state.massMultiplier = (cfg.massMultiplier and cfg.massMultiplier > 0.2) and cfg.massMultiplier or 1
  state.gearMultiplier = cfg.gearMultiplier or 1
  state.gripMultiplier = isDriveModuleEnabled(cfg, "grip") and (cfg.gripMultiplier or 1) or 1
  state.brakeMultiplier = isDriveModuleEnabled(cfg, "brakes") and (cfg.brakeMultiplier or 1) or 1
  state.gravityMultiplier = isDriveModuleEnabled(cfg, "gravity") and (cfg.gravityMultiplier or 1) or 1

  if isDriveModuleEnabled(cfg, "suspension") and (cfg.suspensionSpringMult or cfg.suspensionDampMult) then
    if M.applySuspensionTuning then
      M.applySuspensionTuning(cfg.suspensionSpringMult or 1, cfg.suspensionDampMult or 1)
    end
  end
  if cfg.suspensionHeightMult and cfg.suspensionHeightMult > 0.5 and cfg.suspensionHeightMult < 1.5 then
    state.suspensionHeightMultiplier = cfg.suspensionHeightMult
  end
  drivePresetApplyGripPackage(cfg)

  wheelBrakeBaseData = {}
  M._drivePresetAbsOff = cfg.disableAbsOnPreset ~= false
  if M._drivePresetAbsOff and wheels and wheels.setABSBehavior then
    wheels.setABSBehavior("off")
  end
  if applyBrakeMultiplier then applyBrakeMultiplier() end
  enforceBrakeThermalEfficiency()
  if applyGravityMultiplier then applyGravityMultiplier() end
  if applyMassMultiplier and math.abs(state.massMultiplier - 1) > 0.02 then applyMassMultiplier() end
  if cfg.awdOnPreset == true and applyAWD then
    state.awdMode = true
    applyAWD(true)
  elseif cfg.awdOnPreset == false then
    state.awdMode = false
    applyAWD(false)
  end
  drivePresetApplyPowertrainFromCfg(cfg)
  if M.applyDrivePresetIndustrialSpeedUnlock then M.applyDrivePresetIndustrialSpeedUnlock(0) end
  if M.refreshDrivePresetActiveFlag then M.refreshDrivePresetActiveFlag() end

  M.releaseDrivePresetPlayerInput()
  M._drivePresetInputReleaseFrames = 12
  if M.pushTorqueCurveToGe then M.pushTorqueCurveToGe(true) end
  notifyDrivePresetUiSync()
  showStatusMessage(string.format(
    "Preset ETK: moteur x%.1f | rpm x%.1f",
    state.powerMultiplier or 1, state.rpmMultiplier or 1), "cheat_drive_preset")
end

function M.refreshDrivePresetActiveFlag()
  local cfg = M._drivePresetLastCfg
  if not cfg or not _G.CheatMenu_DriveCheatEnabled then
    state.drivePresetActive = false
    return false
  end
  local wantP = isDriveModuleEnabled(cfg, "power") and (cfg.powerMultiplier or 1) or 1
  local wantR = isDriveModuleEnabled(cfg, "rpm") and (cfg.rpmMultiplier or 1) or 1
  local pwr = state.powerMultiplier or 1
  local rpm = state.rpmMultiplier or 1
  local motorOk = true
  if wantP > 1.05 and pwr < wantP * 0.85 then motorOk = false end
  if wantR > 1.05 and rpm < wantR * 0.85 then motorOk = false end
  state.drivePresetActive = motorOk
  return motorOk
end

function M.ensureDrivePresetMotorApplied()
  if not _G.CheatMenu_DriveCheatEnabled or not M._drivePresetLastCfg then return end
  if M.refreshDrivePresetActiveFlag() then return end
  M._drivePresetMotorRetryTick = (M._drivePresetMotorRetryTick or 0) + 1
  if M._drivePresetMotorRetryTick % 18 ~= 0 then return end
  drivePresetApplyPowertrainFromCfg(M._drivePresetLastCfg)
  M.refreshDrivePresetActiveFlag()
end

function M.applyDrivePresetPendingPower()
  if M._drivePresetLastCfg then
    drivePresetApplyPowertrainFromCfg(M._drivePresetLastCfg)
  end
end

function M.applyDrivePresetStructuralReinforce(boostMult)
  boostMult = tonumber(boostMult) or 1
  if boostMult < 1.05 then return end
  if not M.partBeamStrengthCache or not next(M.partBeamStrengthCache) then
    M.scanPartBeamStrengths()
  end
  local gMult = state.globalStrengthMult or 1
  local cap = 8e6
  for partName, beams in pairs(M.partBeamStrengthCache) do
    local po = (partName or ""):lower()
    if shouldSkipGlobalStrengthPart(partName) then
    elseif po:find("engine") or po:find("subframe") or po:find("bodyshell")
        or po:find("bumper") or po:find("fender") or po:find("hood") then
      for cid, baseStr in pairs(beams) do
        local newStr = math.min(cap, baseStr * gMult * boostMult)
        obj:setBeamStrength(cid, math.max(10.0, newStr))
      end
    end
  end
end

local function drivePresetPartIsBodyPanel(partName)
  local po = (partName or ""):lower()
  if shouldSkipGlobalStrengthPart(partName) then return false end
  if po:find("hood") or po:find("fender") or po:find("bumper") or po:find("bodyshell")
      or po:find("grille") or po:find("headlight") or po:find("splitter") or po:find("lip")
      or po:find("mirror") or po:find("trim") or po:find("badge") then
    return true
  end
  if po:find("body") and not po:find("subframe") then return true end
  return false
end

local function drivePresetPartIsFrontBody(partName)
  if not drivePresetPartIsBodyPanel(partName) then return false end
  local po = (partName or ""):lower()
  if po:find("rear") or po:find("trunk") or po:find("tail") or po:find("spoiler")
      or po:find("wing") or po:find("diffuser") then
    return false
  end
  if po:find("front") or po:find("hood") or po:find("grille") or po:find("headlight")
      or po:find("splitter") or po:find("fender") or po:find("bumper") then
    return true
  end
  return po:find("f") and not po:find("rear")
end

function M.drivePresetCollisionDeformLimit(partName, baseDeform, baseStr)
  local d = tonumber(baseDeform) or 0
  local str = tonumber(baseStr) or 1e5
  if d <= 0 or d ~= d then d = math.min(200000, str * 0.42) end
  if drivePresetPartIsBodyPanel(partName) then
    return math.min(d * 1.12, 185000)
  end
  return math.min(d * 1.85, 420000)
end

local function drivePresetStiffenBodyBeam(cid, springMult)
  if not v or not v.data or not v.data.beams or not obj.setBeamSpringDamp then return end
  for _, beam in pairs(v.data.beams) do
    if beam.cid == cid then
      local sp = beam.beamSpring or 45000
      local dp = beam.beamDamp or 1200
      obj:setBeamSpringDamp(cid, sp * springMult, dp * math.sqrt(springMult), -1, -1)
      return
    end
  end
end

-- Carrosserie / choc : force haute, deform JBeam (pas caoutchouc à grande vitesse)
function M.applyDrivePresetCollisionArmor()
  if not M._drivePresetCollisionArmor or not _G.CheatMenu_DriveCheatEnabled then return end
  if not M.partBeamStrengthCache or not next(M.partBeamStrengthCache) then
    M.scanPartBeamStrengths()
  end
  local gMult = math.min(state.globalStrengthMult or 85000, 110000)
  local strCap = 5e8
  for partName, beams in pairs(M.partBeamStrengthCache) do
    if not shouldSkipGlobalStrengthPart(partName) then
      local isFront = drivePresetPartIsFrontBody(partName)
      local isPanel = drivePresetPartIsBodyPanel(partName)
      for cid, baseStr in pairs(beams) do
        local newStr = math.min(strCap, math.max(8000, baseStr * gMult))
        obj:setBeamStrength(cid, newStr)
        if obj.setBeamDeform then
          local baseDef = M.partBeamDeformCache and M.partBeamDeformCache[cid]
          obj:setBeamDeform(cid, M.drivePresetCollisionDeformLimit(partName, baseDef, baseStr))
        end
        if isPanel and (isFront or M._drivePresetLastCfgId == "scintilla") then
          drivePresetStiffenBodyBeam(cid, isFront and 2.35 or 1.75)
        end
      end
    end
  end
  if healDrivetrain then healDrivetrain() end
end

function M.enforceDrivePresetFrontBodyShape()
  if not M._drivePresetCollisionArmor or not _G.CheatMenu_DriveCheatEnabled then return end
  if not obj or not obj.getVelocity then return end
  local speed = obj:getVelocity():length()
  if speed < 14 then return end
  if not M.partBeamStrengthCache or not next(M.partBeamStrengthCache) then return end
  for partName, beams in pairs(M.partBeamStrengthCache) do
    if drivePresetPartIsFrontBody(partName) then
      for cid in pairs(beams) do
        if not wheelBeamsSet[cid] and not suspensionBeams[cid] then
          obj:setBeamLengthRefRatio(cid, 1.0)
        end
      end
    end
  end
end

updateDrivePresetLaunchRamp = function(dt)
  if not state.drivePresetActive then return end
  local ramp = M._drivePresetLaunchRampSec or 0
  if ramp <= 0 then
    M._drivePresetLaunchBlend = 1
    return
  end
  local throttle = electrics.values and electrics.values.throttle or 0
  if throttle > 0.04 then
    M._drivePresetLaunchBlend = math.min(1, (M._drivePresetLaunchBlend or 0) + (dt or 0.016) / ramp)
  else
    M._drivePresetLaunchBlend = 0
  end
  M._drivePresetLaunchPowerAcc = (M._drivePresetLaunchPowerAcc or 0) + (dt or 0.016)
  if M._drivePresetLaunchPowerAcc > 0.1 and state.powerMultiplier > 1.001 and applyPowerMultiplier then
    M._drivePresetLaunchPowerAcc = 0
    applyPowerMultiplier()
  end
end

applyDrivePresetDownforce = function(dt)
  if not state.drivePresetActive or not state.drivePresetStabilityAssist then return end
  local gain = M._drivePresetDownforceGain or 0
  if gain <= 0 or not obj then return end
  local steerMax = M._drivePresetStabilitySteerMax or 0.3
  local aSteer = math.abs(electrics.values and electrics.values.steering or 0)
  local throttle = electrics.values and electrics.values.throttle or 0
  if aSteer > steerMax + 0.06 or throttle < 0.12 then return end
  local vel = obj:getVelocity()
  local speed = vel and vel:length() or 0
  if speed < 10 then return end
  local up = obj:getDirectionVectorUp()
  local refNode = obj:getRefNodeId()
  if not up or not refNode then return end
  local step = (dt or 0.016) * 60
  local steerFree = math.max(0, 1 - aSteer / math.max(0.12, steerMax))
  local down = gain * speed * throttle * steerFree * step
  obj:applyForceVector(refNode, vec3(up.x, up.y, up.z) * (-down))
end

function M.applyDrivePresetIndustrialSpeedUnlock(dt)
  if not M._drivePresetWl40BypassGovernor or not _G.CheatMenu_DriveCheatEnabled then return end
  if not state.drivePresetActive or not electrics or not electrics.values then return end

  M._drivePresetIndustrialUnlockAcc = (M._drivePresetIndustrialUnlockAcc or 0) + (dt or 0.016)
  local periodic = M._drivePresetIndustrialUnlockAcc > 0.45
  if periodic then M._drivePresetIndustrialUnlockAcc = 0 end

  if powertrain and powertrain.getDevice then
    local eng = powertrain.getDevice("mainEngine")
    if eng then
      if eng.maxRPM and (not eng.revLimiterRPM or eng.revLimiterRPM < eng.maxRPM * 0.92) then
        eng.revLimiterRPM = eng.maxRPM
        if eng.revLimiterAV and eng.maxAV and eng.maxRPM > 0 then
          eng.revLimiterAV = eng.maxAV
          eng.revLimiterMaxAV = eng.maxAV
        end
        if eng.resetTempRevLimiter then eng:resetTempRevLimiter() end
      end
      if eng.electricsThrottleName == "throttleGoverned" then
        eng.electricsThrottleName = "throttle"
      end
    end
  end

  local pedal = electrics.values.throttle or 0
  if pedal > 0.02 then
    local gov = electrics.values.throttleGoverned or 0
    if gov < pedal then electrics.values.throttleGoverned = pedal end
  end

  if periodic and controller and controller.getController then
    local vc = controller.getController("vehicleController")
    if vc and vc.setTopSpeedLimitTemporary and vc.setTopSpeedLimitTemporaryActive then
      vc.setTopSpeedLimitTemporary(9999)
      vc.setTopSpeedLimitTemporaryActive(true)
    end
  end
end

applyDrivePresetTractionControl = function(dt)
  if not state.drivePresetActive or not _G.CheatMenu_DriveCheatEnabled then return end
  if M._drivePresetDisableTcs then return end
  if not wheels or not wheels.wheels or not powertrain then return end
  local throttle = electrics.values and electrics.values.throttle or 0
  if throttle < 0.06 then return end

  local vel = obj:getVelocity()
  local speed = vel and vel:length() or 0
  local tcsMax = M._drivePresetTcsMaxSpeed or 32
  if speed > tcsMax then return end

  local maxWheelSpeed = 0
  local maxWheelSlip = 0
  for _, w in pairs(wheels.wheels) do
    local r = w.radius or 0.33
    local ws = math.abs(w.angularVelocity or 0) * r
    if ws > maxWheelSpeed then maxWheelSpeed = ws end
    local wslp = w.lastSlip or 0
    if wslp > maxWheelSlip then maxWheelSlip = wslp end
  end

  local tcsStr = M._drivePresetTcsStrength or 1.0
  local slip
  if speed < 3.5 then
    slip = maxWheelSpeed / (5.8 / tcsStr)
  else
    slip = (maxWheelSpeed / math.max(speed, 0.5)) - 1.0
  end
  if maxWheelSlip > 1.6 then
    slip = math.max(slip, (maxWheelSlip - 1.6) * (0.32 * tcsStr))
  end
  local slipOn = 0.1 / math.max(0.85, tcsStr)
  if slip < slipOn then return end

  local cut = math.min(0.9, (slip - slipOn) * (1.22 * tcsStr))
  local launchMin = M._drivePresetLaunchMinFactor or 0.4
  local launchMul = launchMin + (1 - launchMin) * (M._drivePresetLaunchBlend or 1)
  local tCap = throttle * (1.0 - cut) * launchMul
  local aSteer = math.abs(electrics.values and electrics.values.steering or 0)
  if aSteer > 0.42 then
    tCap = math.max(tCap, throttle * 0.55)
  end

  for _, eng in ipairs(powertrain.getDevicesByCategory("engine") or {}) do
    if eng.controls and eng.controls.throttle then
      eng.controls.throttle = math.min(eng.controls.throttle, tCap)
    end
  end
  for _, mot in ipairs(powertrain.getDevicesByCategory("electricMotor") or {}) do
    if mot.controls and mot.controls.throttle then
      mot.controls.throttle = math.min(mot.controls.throttle, tCap)
    end
  end
end

applyDrivePresetStabilityAssist = function(dt)
  if not state.drivePresetActive or not state.drivePresetStabilityAssist then return end
  if not obj or not electrics or not electrics.values then return end

  local steer = electrics.values.steering or 0
  local throttle = electrics.values.throttle or 0
  local aSteer = math.abs(steer)
  if throttle < 0.08 then return end

  local vel = obj:getVelocity()
  local fwd = obj:getDirectionVector()
  local up = obj:getDirectionVectorUp()
  if not vel or not fwd or not up then return end
  local speed = vel:length()

  local steerMax = M._drivePresetStabilitySteerMax or 0.3
  local straightBlend = 0
  if aSteer <= steerMax then
    straightBlend = (1 - aSteer / math.max(0.12, steerMax)) * math.min(1, throttle * 1.25)
  end
  local cornerBlend = 0
  if speed > 11 and aSteer > 0.1 and aSteer < 0.62 and throttle > 0.15 then
    cornerBlend = math.min(0.32, ((aSteer - 0.1) / 0.45) * 0.32)
  end
  local blend = math.max(straightBlend, cornerBlend)
  if blend < 0.04 then return end

  local right = fwd:cross(up)
  if right:length() < 1e-5 then return end
  right = right:normalized()

  local lateral = vel:dot(right)
  local step = (dt or 0.016) * 60
  if lateral ~= lateral or math.abs(lateral) > 120 then return end

  local stabGain = M._drivePresetStabilityGain or 1.0
  local laneK = M._drivePresetLaneKeepGain or 0
  local laneBlend = blend
  if laneK > 0 and speed > 28 and aSteer < 0.2 then
    laneBlend = math.max(laneBlend, math.min(1, (speed - 28) / 35) * (1 - aSteer / 0.2))
  end
  local dampForce = -lateral * (10200.0 + speed * 28.0) * laneBlend * step * stabGain
  if laneK > 0 and speed > 40 and aSteer < 0.14 and throttle > 0.2 then
    dampForce = dampForce - lateral * (5500.0 + speed * 28.0) * laneK * step
  end
  if dampForce ~= dampForce or math.abs(dampForce) > 50000 then return end

  local refNode = obj:getRefNodeId()
  if refNode then
    obj:applyForceVector(refNode, right * dampForce)

    local yawGain = M._drivePresetYawDampGain or 0
    if yawGain > 0 and aSteer < 0.28 and throttle > 0.22 and speed > 5 then
      local angVel = obj.getAngularVelocity and obj:getAngularVelocity()
      if angVel then
        local worldUp = vec3(0, 0, 1)
        local yawRate = angVel:dot(worldUp)
        if yawRate == yawRate and math.abs(yawRate) > 0.025 and math.abs(yawRate) < 3.8 then
          local steerFree = 1 - (aSteer / 0.28)
          local yawTorque = -yawRate * (19500.0 + speed * 62.0) * yawGain * steerFree * step
          if obj.applyTorque then
            obj:applyTorque(refNode, worldUp * yawTorque)
          else
            obj:applyForceVector(refNode, right * (-yawRate * 5200.0 * yawGain * steerFree * step))
          end
        end
      end
    end
  end
end

local function shouldSkipGlobalStrengthPart(partName)
  local po = (partName or ""):lower()
  if po:find("steering") or po:find("wheel") or po:find("tire") or po:find("hub")
      or po:find("suspension") or po:find("coilover") or po:find("strut")
      or po:find("swaybar") or po:find("spring") or po:find("brake")
      or po:find("driveshaft") or po:find("gearbox") or po:find("transmission")
      or po:find("shifter") or po:find("clutch") or po:find("hydro") then
    return true
  end
  return false
end

-- Безопасное применение глобального множителя (защита от 0 и NaN)
function M.applyGlobalBeamStrengthMult(mult)
  mult = tonumber(mult) or 1.0
  -- Минимальный порог 0.001 не дает физике авто схлопнуться в 0 и сломать камеру
  if mult < 0.001 then mult = 0.001 end
  
  state.globalStrengthMult = mult
  if not M.partBeamStrengthCache or not next(M.partBeamStrengthCache) then
    M.scanPartBeamStrengths()
  end

  local restoreAll = mult <= 1.001
  for partName, beams in pairs(M.partBeamStrengthCache) do
    if restoreAll or not shouldSkipGlobalStrengthPart(partName) then
      for cid, baseStr in pairs(beams) do
        local newStr = restoreAll and baseStr or math.max(10.0, math.min(1e10, baseStr * mult))
        obj:setBeamStrength(cid, newStr)
      end
    end
  end
end

-- Безопасное применение к конкретной детали
function M.applyPartBeamStrengthMult(partName, mult)
  mult = tonumber(mult) or 1.0
  if mult < 0.001 then mult = 0.001 end

  state.partStrengthMults = state.partStrengthMults or {}
  state.partStrengthMults[partName] = mult

  if not M.partBeamStrengthCache or not next(M.partBeamStrengthCache) then
    M.scanPartBeamStrengths()
  end

  local beams = M.partBeamStrengthCache[partName]
  if beams then
    for cid, baseStr in pairs(beams) do
      local newStr = math.max(10.0, math.min(1e10, baseStr * mult))
      obj:setBeamStrength(cid, newStr)
    end
  end
end

_G.scanPartBeamStrengths = M.scanPartBeamStrengths
_G.applyGlobalBeamStrengthMult = M.applyGlobalBeamStrengthMult
_G.applyPartBeamStrengthMult = M.applyPartBeamStrengthMult




-- Хранилища оригинальных JBeam-параметров балок и узлов шин
M.pressureWheelsCache = {}

-- Функция глубокого разбора JBeam-структуры шин автомобиля [2]
function M.scanPressureWheels()
  M.pressureWheelsCache = {}
  if not v or not v.data or not v.data.wheels or not wheels or not wheels.wheels then return end
  
  for _, wheel in pairs(wheels.wheels) do
    local wd = nil
    for _, jbWheel in ipairs(v.data.wheels) do
      if jbWheel.wheelID == wheel.wheelID then
        wd = jbWheel
        break
      end
    end
    
    if wd then
      local wCache = {
        wheelID = wheel.wheelID,
        sideBeams = {},
        reinfBeams = {},
        treadBeams = {},
        treadReinfBeams = {},
        peripheryBeams = {},
        peripheryReinfBeams = {},
        nodes = {}
      }
      
      -- Внутренний кэшер характеристик балок из JBeam [2]
      local function cacheBeams(beamList, targetCache)
        if not beamList then return end
        for _, bid in ipairs(beamList) do
          local jbBeam = v.data.beams[bid]
          if jbBeam then
            targetCache[bid] = {
              spring = jbBeam.beamSpring or 40000,
              damp = jbBeam.beamDamp or 100,
              springExpansion = jbBeam.springExpansion or -1,
              dampExpansion = jbBeam.dampExpansion or -1,
              deform = jbBeam.beamDeform or 10000,
              strength = jbBeam.beamStrength or 20000,
              precomp = jbBeam.beamPrecompression or 1.0,
              length = obj:getBeamLength(bid) or 1.0
            }
          end
        end
      end
      
      -- Сортируем балки по категориям JBeam [2]
      cacheBeams(wd.sideBeams, wCache.sideBeams)
      cacheBeams(wd.reinfBeams, wCache.reinfBeams)
      cacheBeams(wd.treadBeams, wCache.treadBeams)
      cacheBeams(wd.treadReinfBeams, wCache.treadReinfBeams)
      cacheBeams(wd.peripheryBeams, wCache.peripheryBeams)
      cacheBeams(wd.peripheryReinfBeams, wCache.peripheryReinfBeams)
      
      -- Кэшируем характеристики узлов (nodes) контакта шины [2]
      if wd.treadNodes then
        for _, nid in ipairs(wd.treadNodes) do
          local nodeData = v.data.nodes[nid]
          if nodeData then
            wCache.nodes[nid] = {
              weight = nodeData.nodeWeight or 0.16,
              friction = nodeData.frictionCoef or 1.0,
              slidingFriction = nodeData.slidingFrictionCoef or 1.0
            }
          end
        end
      end
      
      M.pressureWheelsCache[wheel.wheelID] = wCache
    end
  end
end

-- Единая функция тонкой регулировки ВСЕХ JBeam-параметров шин в реальном времени [2.1.1, 2.4.1]
function M.applyAdvancedTireTuning(p)
  -- Записываем состояние множителей в state
  state.tireRadiusMult = p.radius
  state.tireWidthMult = p.width
  state.tireSideSpring = p.sideSpring
  state.tireSideDamp = p.sideDamp
  state.tireSideExpSpring = p.sideExpSpring
  state.tireSideExpDamp = p.sideExpDamp
  state.tireSidePre = p.sidePre
  state.tireSideDeform = p.sideDeform
  state.tireSideStrength = p.sideStrength
  state.tireReinfSpring = p.reinfSpring
  state.tireReinfDamp = p.reinfDamp
  state.tireReinfPre = p.reinfPre
  state.tireTreadSpring = p.treadSpring
  state.tireTreadDamp = p.treadDamp
  state.tireTreadPre = p.treadPre
  state.tireTreadDeform = p.treadDeform
  state.tireTreadStrength = p.treadStrength
  state.tireTreadReinfSpring = p.treadReinfSpring
  state.tireTreadReinfDamp = p.treadReinfDamp
  state.tireTreadReinfPre = p.treadReinfPre
  state.tirePeriSpring = p.periSpring
  state.tirePeriDamp = p.periDamp
  state.tirePeriPre = p.periPre
  state.tirePeriDeform = p.periDeform
  state.tirePeriStrength = p.periStrength
  state.tirePeriReinfSpring = p.periReinfSpring
  state.tirePeriReinfDamp = p.periReinfDamp
  state.tirePeriReinfPre = p.periReinfPre
  state.tireNodeWeight = p.nodeWeight
  state.tireFriction = p.friction
  state.tireSliding = p.sliding

  if not M.pressureWheelsCache or not next(M.pressureWheelsCache) then
    M.scanPressureWheels()
  end
  
  for wID, c in pairs(M.pressureWheelsCache) do
    -- 1. Регулируем боковины (sideBeams)
    for bid, b in pairs(c.sideBeams) do
      obj:setBeamSpringDamp(bid, b.spring * p.sideSpring, b.damp * p.sideDamp, b.springExpansion * p.sideExpSpring, b.dampExpansion * p.sideExpDamp)
      obj:setBeamStrength(bid, b.strength * p.sideStrength)
      obj:setBeamDeform(bid, b.deform * p.sideDeform)
      -- Прекомпрессия масштабируется с учетом ширины tireWidth
      obj:setBeamLengthRefRatio(bid, b.precomp * p.sidePre * p.width)
    end
    
    -- 2. Регулируем корд (reinfBeams)
    for bid, b in pairs(c.reinfBeams) do
      obj:setBeamSpringDamp(bid, b.spring * p.reinfSpring, b.damp * p.reinfDamp, -1, -1)
      obj:setBeamLengthRefRatio(bid, b.precomp * p.reinfPre * p.radius)
    end
    
    -- 3. Регулируем протектор (treadBeams)
    for bid, b in pairs(c.treadBeams) do
      obj:setBeamSpringDamp(bid, b.spring * p.treadSpring, b.damp * p.treadDamp, -1, -1)
      obj:setBeamStrength(bid, b.strength * p.treadStrength)
      obj:setBeamDeform(bid, b.deform * p.treadDeform)
      obj:setBeamLengthRefRatio(bid, b.precomp * p.treadPre * p.width)
    end
    
    -- 4. Регулируем усиление протектора (treadReinfBeams)
    for bid, b in pairs(c.treadReinfBeams) do
      obj:setBeamSpringDamp(bid, b.spring * p.treadReinfSpring, b.damp * p.treadReinfDamp, -1, -1)
      obj:setBeamLengthRefRatio(bid, b.precomp * p.treadReinfPre * p.width)
    end
    
    -- 5. Регулируем окружность (peripheryBeams)
    for bid, b in pairs(c.peripheryBeams) do
      obj:setBeamSpringDamp(bid, b.spring * p.periSpring, b.damp * p.periDamp, -1, -1)
      obj:setBeamStrength(bid, b.strength * p.periStrength)
      obj:setBeamDeform(bid, b.deform * p.periDeform)
      obj:setBeamLengthRefRatio(bid, b.precomp * p.periPre * p.radius)
    end
    
    -- 6. Регулируем усиление окружности (peripheryReinfBeams)
    for bid, b in pairs(c.peripheryReinfBeams) do
      obj:setBeamSpringDamp(bid, b.spring * p.periReinfSpring, b.damp * p.periReinfDamp, -1, -1)
      obj:setBeamLengthRefRatio(bid, b.precomp * p.periReinfPre * p.radius)
    end
    
    -- 7. Регулируем массу и трение узлов (nodes) контакта шины [2.4.1]
    for nid, n in pairs(c.nodes) do
      obj:setNodeMass(nid, n.weight * p.nodeWeight)
      obj:setNodeFrictionSlidingCoefs(nid, n.friction * p.friction, n.slidingFriction * p.sliding)
    end
  end
end

_G.applyAdvancedTireTuning = M.applyAdvancedTireTuning
_G.scanPressureWheels = M.scanPressureWheels




-- Полноценная система управления полетом (Fly Mode) с поддержкой автономных кнопок Roll/Pitch/Yaw
local function applyFlightPhysics(dt)
  -- Проверяем, нажата ли хоть одна кнопка управления
  local hasManualInput = (math.abs(state.thrustX or 0) > 0.01) or
                         (math.abs(state.thrustY or 0) > 0.01) or
                         (math.abs(state.thrustZ or 0) > 0.01) or
                         (math.abs(state.flyPitch or 0) > 0.01) or
                         (math.abs(state.flyYaw or 0) > 0.01) or
                         (math.abs(state.flyRoll or 0) > 0.01)

  -- Если полет выключен И кнопки не зажаты — выходим
  if not state.flyMode and not hasManualInput then return end
  
  local nodeCount = obj:getNodeCount()
  if nodeCount <= 0 then return end

  -- 1. СЧИТЫВАНИЕ УПРАВЛЕНИЯ
  local throttle = electrics.values and electrics.values.throttle or 0
  local brake = electrics.values and electrics.values.brake or 0
  local steering = electrics.values and electrics.values.steering or 0
  local pBrake = electrics.values and electrics.values.parkingbrake or 0
  local isReverse = (electrics.values and (electrics.values.gear == "R" or (electrics.values.gearIndex and electrics.values.gearIndex < 0)))

  local flySpeed = state.flySpeed or 15.0
  local vel = obj:getVelocity()

  -- ТЯГА И ВЗЛЕТ (Автоматический подъём от педали газа работает только при включенном flyMode)
  local pedalDir = isReverse and -1 or 1
  local pedalThrustY = state.flyMode and ((throttle * flySpeed * pedalDir) - (brake * flySpeed * 0.6)) or 0.0
  local autoTakeoffLift = state.flyMode and ((throttle > 0.05) and (flySpeed * 0.5) or 0.0) or 0.0
  local handbrakeLift = state.flyMode and ((pBrake > 0.1) and (flySpeed * 1.5) or 0.0) or 0.0

  local totalThrustY = (state.thrustY or 0.0) + pedalThrustY
  local totalThrustX = state.thrustX or 0.0
  local totalThrustZ = (state.thrustZ or 0.0) + autoTakeoffLift + handbrakeLift

  local autoYaw = -steering * 0.20
  local yaw = (math.abs(state.flyYaw or 0.0) > 0.01) and (state.flyYaw * 0.2) or (state.flyMode and autoYaw or 0.0)
  local pitch = state.flyPitch or 0.0
  local roll = state.flyRoll or 0.0

  -- 2. ВЫЧИСЛЕНИЕ ЦЕНТРА МАСС И ТОЧНОГО ПАРАЛЛЕЛИЗМА ОСЕЙ
  local totalMass = 0
  local comPos = vec3(0, 0, 0)
  for i = 0, nodeCount - 1 do
    local m = obj:getNodeMass(i) or 0.1
    comPos = comPos + vec3(v.data.nodes[i].pos) * m
    totalMass = totalMass + m
  end
  if totalMass > 0 then comPos = comPos / totalMass end

  local frontZSum, frontCount = 0, 0
  local rearZSum, rearCount = 0, 0
  for i = 0, nodeCount - 1 do
    local nPos = vec3(v.data.nodes[i].pos)
    local relY = nPos.y - comPos.y
    if relY > 0.2 then
      frontZSum = frontZSum + nPos.z
      frontCount = frontCount + 1
    elseif relY < -0.2 then
      rearZSum = rearZSum + nPos.z
      rearCount = rearCount + 1
    end
  end

  local avgFrontZ = (frontCount > 0) and (frontZSum / frontCount) or comPos.z
  local avgRearZ = (rearCount > 0) and (rearZSum / rearCount) or comPos.z
  local rearZDiff = avgRearZ - avgFrontZ

  -- 3. МИРОВЫЕ ВЕКТОРЫ
  local rawForward = vec3(obj:getDirectionVector()):normalized()
  local rawUp = vec3(obj:getDirectionVectorUp()):normalized()
  local rawRight = rawForward:cross(rawUp):normalized()

  local horizForward = vec3(rawForward.x, rawForward.y, 0):normalized()
  if horizForward:length() < 0.001 then horizForward = vec3(1, 0, 0) end
  local horizRight = horizForward:cross(vec3(0, 0, 1)):normalized()
  local worldUp = vec3(0, 0, 1)

  local rollError = rawRight.z

  local angVel = (obj.getAngularVelocity and obj:getAngularVelocity()) or vec3(0, 0, 0)
  local wPitch = angVel:dot(rawRight)
  local wRoll = angVel:dot(rawForward)
  local wYaw = angVel:dot(worldUp)

  local isMovingInput = math.abs(totalThrustX) > 0.01 or math.abs(totalThrustY) > 0.01 or math.abs(totalThrustZ) > 0.01 or math.abs(yaw) > 0.01

  -- 4. ПРИМЕНЕНИЕ СИЛ
  for i = 0, nodeCount - 1 do
    local nodePos = vec3(v.data.nodes[i].pos)
    local relPos = nodePos - comPos
    local m = obj:getNodeMass(i) or 0.1
    local force = vec3(0, 0, 0)

    -- АНТИГРАВИТАЦИЯ (работает только при активной галочке Fly Mode + Hover)
    if state.flyMode and state.flyHover then
      local grav = obj:getGravity() or -9.81
      force.z = force.z - (grav * m)

      if not isMovingInput then
        force = force - (vel * m * 3.0)
      end
    end

    -- ТЯГА ВДОЛЬ ГОРИЗОНТА (Кнопки Up/Down/Fwd/Bwd)
    local accelVec = (horizForward * totalThrustY + horizRight * totalThrustX + worldUp * totalThrustZ) * 9.81 * m
    force = force + accelVec

    -- СТАБИЛИЗАЦИЯ И МАНЕВРИРОВАНИЕ
    local stabForce = vec3(0, 0, 0)

    -- 1. КРЕН (Roll Left / Roll Right)
    if math.abs(roll) > 0.01 then
      stabForce = stabForce + (worldUp * (relPos.x * roll) * 10.0 * m)
    elseif state.flyMode then
      local rollCorr = (rollError * 350.0 + wRoll * 80.0)
      stabForce = stabForce - (worldUp * rollCorr * m * relPos.x)
    end

    -- 2. ТАНГАЖ (Pitch Up / Pitch Down)
    if math.abs(pitch) > 0.01 then
      stabForce = stabForce + (worldUp * (relPos.y * pitch) * 10.0 * m)
    elseif state.flyMode then
      local pitchCorr = (rearZDiff * 350.0 + wPitch * 60.0)
      stabForce = stabForce - (worldUp * pitchCorr * m * relPos.y)
    end

    -- 3. РЫСКАНИЕ (Yaw Turn)
    if math.abs(yaw) > 0.01 then
      stabForce = stabForce + (horizRight * (relPos.y * yaw) * 1.2 * m)
    elseif state.flyMode then
      stabForce = stabForce - (horizRight * (wYaw * 45.0) * m * relPos.y)
    end

    force = force + stabForce
    obj:applyForceVector(i, force)
  end
end

-- Усовершенствованная функция 3D-маневрирования, педального разгона и тормозного бустера
local function applyManeuveringThrust(dt)
  dt = dt or 0.0166
  local tx = state.thrustX or 0.0
  local ty = state.thrustY or 0.0
  local tz = state.thrustZ or 0.0
  
  local pedalForce = state.pedalThrustForce or 0.0
  local throttle = electrics.values.throttle or 0
  
  -- 1. Ускорение от педали газа (Virtual Rocket Booster)
  if pedalForce > 0.01 and throttle > 0.01 then
    local isReverse = (electrics.values.gear == "R" or (electrics.values.gearIndex and electrics.values.gearIndex < 0))
    local direction = isReverse and -1 or 1
    ty = ty + (pedalForce * throttle * direction)
  end
  
  -- 2. Торможение от педали тормоза (Virtual Braking Booster)
  local brakeForceSetting = state.pedalBrakeForce or 0.0
  local brakePedal = electrics.values.brake or 0
  
  if brakeForceSetting > 0.01 and brakePedal > 0.01 then
    local vel = obj:getVelocity()
    local speed = vel:length()
    
    if speed > 0.05 then
      local forwardVec = vec3(obj:getDirectionVector()):normalized()
      local velDir = vel:normalized()
      local forwardDot = velDir:dot(forwardVec)
      local moveSign = (forwardDot >= 0) and 1 or -1
      
      -- Плавное затухание при полной остановке (чтобы машина не начинала ехать назад)
      local speedFactor = math.min(1.0, speed / 1.5)
      ty = ty - (brakeForceSetting * brakePedal * moveSign * speedFactor)
    end
  end
  
  if math.abs(tx) <= 0.01 and math.abs(ty) <= 0.01 and math.abs(tz) <= 0.01 then return end
  
  local forwardVec = vec3(obj:getDirectionVector()):normalized()
  local upVec = vec3(obj:getDirectionVectorUp()):normalized()
  if not forwardVec or not upVec then return end
  
  local rightVec = forwardVec:cross(upVec):normalized()
  
  local tickCompensation = math.max(1.0, dt / 0.0005)
  local accelVec = (forwardVec * ty + rightVec * tx + upVec * tz) * 9.81 * tickCompensation
  local nodeCount = obj:getNodeCount()
  
  for i = 0, nodeCount - 1 do
    local nodeMass = obj:getNodeMass(i) or 0.1
    local fx = accelVec.x * nodeMass
    local fy = accelVec.y * nodeMass
    local fz = accelVec.z * nodeMass
    
    obj:applyForceVector(i, vec3(fx, fy, fz))
  end
end

-- Привязка ступиц колес к поверхности дороги (без изменения гравитации кузова)
local function applyStickyGripPhysics(dt)
  if not state.stickyGrip or not obj or not wheels or not wheels.wheels then return end

  dt = dt or 0.0166
  local tickCompensation = math.max(1.0, dt / 0.0005)
  local forceMult = state.stickyGripForce or 0.2 -- Множитель силы липкости
  local vehPos = obj:getPosition()

  for _, wheel in pairs(wheels.wheels) do
    if wheel.node1 and wheel.node2 then
      local node1Local = obj:getNodePosition(wheel.node1)
      local wPos = vehPos + node1Local
      
      -- Считываем высоту рельефа/дороги строго под этим колесом
      local groundZ = obj:getSurfaceHeightBelow(wPos)
      if groundZ and groundZ > -900 then
        local radius = wheel.radius or 0.35
        local currentHubHeight = wPos.z - groundZ
        local lift = currentHubHeight - radius

        -- Если колесо находится у поверхности или пытается оторваться от земли (lift > 0)
        if lift > -0.05 and lift < 1.5 then
          -- Притягиваем ТОЛЬКО ступицу этого колеса к рельефу дороги с учетом множителя силы
          local liftForce = math.max(0, lift) * 90000.0 * forceMult
          local baseAdhesion = 12000.0 * forceMult
          local totalPullZ = -(baseAdhesion + liftForce) * tickCompensation

          local forceVec = vec3(0, 0, totalPullZ * 0.5)
          obj:applyForceVector(wheel.node1, forceVec)
          obj:applyForceVector(wheel.node2, forceVec)
        end
      end
    end
  end
end


local geSyncTimer = 0
local function geSyncUpdateGFX(dt)
  -- Вызов оригинальной функции обновления физики и логики читов
  if updateGFX then updateGFX(dt) end
  
  -- Применяем физику полноценного полета
  applyFlightPhysics(dt)
  if M.updateVirtualSandPhysics then M.updateVirtualSandPhysics(dt) end

  -- Применяем реактивную силу педального бустера [2]
  applyManeuveringThrust()
  -- Применяем липкое сцепление и защиту от переворота
  applyStickyGripPhysics(dt)
    
  -- Принудительное удержание замороженных параметров трансмиссии (каждый кадр)
  if M.frozenProperties then
    for devName, props in pairs(M.frozenProperties) do
      for propName, value in pairs(props) do
        M.setDeviceProperty(devName, propName, value)
      end
    end
  end
  
  -- Принудительное удержание абсолютно всех замороженных температур в машине (каждый кадр)
  if M.frozenThermals then
    for path, value in pairs(M.frozenThermals) do
      M.setVehicleThermal(path, value)
    end
  end
  
  -- Кэшируем исходные параметры деталей один раз при первой загрузке авто
  if (not M.powertrainDefaults or not next(M.powertrainDefaults)) and powertrain and powertrain.getDevices then
    M.powertrainDefaults = {}
    for name, device in pairs(powertrain.getDevices() or {}) do
      M.powertrainDefaults[name] = {}
      for k, v in pairs(device) do
        local t = type(v)
        if t == "number" or t == "boolean" or t == "string" then
          M.powertrainDefaults[name][k] = v
        end
      end
      -- Кэшируем также термо-дефолты для радиатора ДВС
      if device.thermals and type(device.thermals) == "table" then
        for k, v in pairs(device.thermals) do
          local t = type(v)
          if t == "number" or t == "boolean" or t == "string" then
            M.powertrainDefaults[name]["thermals." .. k] = v
          end
        end
      end
    end
  end

  -- Периодическая отправка состояния в GE ImGui (примерно 7 раз в секунду)
  geSyncTimer = geSyncTimer + dt
  if geSyncTimer > 0.15 then
    geSyncTimer = 0
    local ok, err = pcall(M.syncVehicleStateToGe)
    if not ok then
      if log then log("E", "cheatMenuSync", tostring(err)) end
      if M.pushMinimalGeConnection then M.pushMinimalGeConnection() end
    end
  end
end
M.spawnParticles = M.spawnParticles
-- Перенаправляем точку входа обновления на наш обернутый метод
M.updateGFX = geSyncUpdateGFX


log('W', 'CheatMenu', '========== RADIAL CHEAT MENU = Export GUI final ==========')

return M
