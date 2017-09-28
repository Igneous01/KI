-- Kaukasus Insurgency Init Namespace

if not KI then
  KI = {}
end

KI.Init = {}


function KI.Init.Depots()
  env.info("KI.InitDepots called")
  local objects = coalition.getStaticObjects(1)
  for i = 1, #objects do
    local obj = objects[i]
    local n = obj:getName()
    env.info("KI.InitDepotZones - looping through static objects (" .. n .. ")")
    if string.match(n, "Depot") then
      env.info("KI.InitDepotZones - found Depot object - initializing")
      local _depot = DWM:New(n, n .. " Zone", 7200, 150, true)
      _depot:SetResource("Infantry", 40, 1)
      _depot:SetResource("APC", 8, 2)
      _depot:SetResource("Tank", 8, 3)
      _depot:SetResource("Fuel Truck", 4, 1)
      _depot:SetResource("Command Truck", 4, 1)
      _depot:SetResource("Ammo Truck", 4, 1)
      _depot:SetResource("Power Truck", 4, 1)
      _depot:SetResource("Fuel Tanks", 8, 1)
      _depot:SetResource("Cargo Crates", 8, 1) 
      _depot:SetResource("Watchtower Wood", 4, 2)
      _depot:SetResource("Watchtower Supplies", 4, 1)
      _depot:SetResource("Outpost Pipes", 4, 3)
      _depot:SetResource("Outpost Wood", 4, 2)
      _depot:SetResource("Outpost Supplies", 4, 1)
      table.insert(KI.Data.Depots, _depot)
      env.info("KI.InitDepotZones - DWM Instance created for " .. n)
    end
  end
end


function KI.Init.CapturePoints()
  env.info("KI.Init.CapturePoints called")
  for i = 1, #KI.Config.CP do
    local _cp = CP:New(KI.Config.CP[i].name, KI.Config.CP[i].zone, KI.Config.CP[i].spawnzone)
    _cp:SetDefenseUnit("Infantry", 4)
    _cp:SetDefenseUnit("Vehicle", 8) -- fortifications are considered to be vehicles
    table.insert(KI.Data.CapturePoints, _cp)
    env.info("KI.Init.CapturePoints - CP Instance created for " .. _cp.Name)
  end
end

function KI.Init.SideMissions()
  env.info("KI.Init.SideMissions called")
  for i = 1, #KI.Config.SideMissions do
    -- should create a validation function here
    
    local _sm = DSMT:New(KI.Config.SideMissions[i].name, 
                         KI.Config.SideMissions[i].zones,
                         KI.Config.SideMissions[i].init,
                         KI.Config.SideMissions[i].destroy,
                         KI.Config.SideMissions[i].complete,
                         KI.Config.SideMissions[i].fail,
                         KI.Config.SideMissions[i].oncomplete,
                         KI.Config.SideMissions[i].onfail,
                         KI.Config.SideMissions[i].ontimeout,
                         KI.Config.SideMissionMaxTime,
                         KI.Config.SideMissions[i].rate,
                         KI.Config.SideMissionsDestroyTime)
    table.insert(KI.Data.SideMissions, _sm)
    env.info("KI.Init.SideMissions - Side Mission Instance created for " .. _sm.Name)
  end
end

function KI.Init.SessionID()
  env.info("KI.Init.SessionID called")
  KI.Data.SessionID = 1
end

function KI.Init.SortieID()
  env.info("KI.Init.SortieID called")
  KI.Data.SortieID = 1
end

function KI.Init.ServerID()
  env.info("KI.Init.ServerID called")
  KI.Data.ServerID = 1
end

function KI.Init.OnlinePlayers()
  KI.Data.OnlinePlayers = PlayerInfoList
end
