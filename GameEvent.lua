--[[
GameEvent module

Exposes some functions for wrapping up DCS and KI events into a message that can be sent to TCP Server

Author: Igneous01
]]--

GameEvent = {}

GameEvent.CreateGameEvent = function(sessionID, serverID, dcs_event_obj, realTime)
  env.info("GameEvent.CreateGameEvent called (sessionID: " 
           .. tostring(sessionID) .. ", serverID: " 
           .. tostring(serverID) .. ", sortieID: " 
           .. tostring(sortieID) .. ", dcs_event_obj: "
           .. KI.Toolbox.Dump(dcs_event_obj) .. ", realTime: "
           .. tostring(realTime) .. ")")
  if sessionID == nil or 
    serverID == nil or 
    dcs_event_obj == nil or 
    dcs_event_obj.initiator == nil or
    realTime == nil then
    
    env.info("GameEvent.CreateGameEvent - invalid parameters (one or more is nil) exiting")
    return nil
  end
  
  local playerName = dcs_event_obj.initiator:getPlayerName() or "AI"
  local UCID = KI.Null
  if playerName ~= "AI" then
    UCID = KI.Query.FindUCID_Player(playerName)
  end
  local sortieID = KI.Query.FindSortieID_Player(playerName) or KI.Null
  local airfield = KI.Null
  local weapon = KI.Null
  local weaponCategory = KI.Null
  local target = KI.Null
  local targetName = KI.Null
  local targetType = KI.Null
  local targetCategory = KI.Null
  local targetIsPlayer = false
  local targetPlayerName = KI.Null
  local targetPlayerUCID = KI.Null
  local targetSide = KI.Null
  
  if dcs_event_obj.place then
    airfield = dcs_event_obj.place:getName() or "Ground"
  end
  
  if dcs_event_obj.weapon then
    weapon = dcs_event_obj.weapon:getDesc()["displayName"]
    weaponCategory = KI.Defines.WeaponCategories[dcs_event_obj.weapon:getCategory()]
  else
    if dcs_event_obj.id == world.event.S_EVENT_SHOOTING_START or 
       dcs_event_obj.id == world.event.S_EVENT_SHOOTING_END then
      weapon = "Cannon"
      weaponCategory = "CANNON"
    end
  end
  
  if dcs_event_obj.target then
    targetName = dcs_event_obj.target:getName()
    target = dcs_event_obj.target:getTypeName()
    targetType = KI.Defines.UnitTypes[target]
    targetCategory = KI.Defines.UnitCategories[dcs_event_obj.target:getCategory()]
    targetPlayerName = dcs_event_obj.target:getPlayerName() or KI.Null
    targetSide = dcs_event_obj.target:getCoalition()
    
    if targetPlayerName ~= KI.Null then
      targetIsPlayer = true
      targetPlayerUCID = KI.Query.FindUCID_Player(targetPlayerName) or KI.Null
    end
    
  end
  
  local gameevent =
  {
    ["SessionID"] = sessionID,
    ["ServerID"] = serverID,
    ["SortieID"] = sortieID,
    ["UCID"] = UCID,
    ["Event"] = KI.Defines.EventNames[dcs_event_obj.id],
    ["PlayerName"] = playerName,
    ["PlayerSide"] = dcs_event_obj.initiator:getCoalition(),
    ["RealTime"] = realTime,
    ["GameTime"] = dcs_event_obj.time,
    ["Role"] = dcs_event_obj.initiator:getTypeName(),
    -- optional fields
    ["Airfield"] = airfield,
    ["Weapon"] = weapon,
    ["WeaponCategory"] = weaponCategory,
    ["TargetName"] = targetName,
    ["TargetModel"] = target,
    ["TargetType"] = targetType,
    ["TargetCategory"] = targetCategory,
    ["TargetSide"] = targetSide,
    ["TargetIsPlayer"] = targetIsPlayer,
    ["TargetPlayerUCID"] =  targetPlayerUCID,
    ["TargetPlayerName"] = targetPlayerName
  }
  
  return gameevent
end