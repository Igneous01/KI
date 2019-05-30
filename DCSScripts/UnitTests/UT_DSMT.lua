-- Side Mission Unit Tests

UT.TestCase("DSMT Core", nil, 
function()
  UT.TestData.INIT_CALLED = false
  UT.TestData.DESTROY_CALLED = false
  UT.TestData.COMPLETE_CALLED = false
  UT.TestData.FAIL_CALLED = false
  UT.TestData.ON_COMPLETE_CALLED = false
  UT.TestData.ON_FAIL_CALLED = false
  UT.TestData.ON_TIMEOUT_CALLED = false
end,
    function()
      
      -- ================================== TEST DATA =========================================================--
      local _missionName = "Test Mission"
      local _argVal = "TestArg"
      local _zones = { "TestZone1", "TestZone2", "TestZone3" }
      local _expTime = 30
      local _rate = 10
      local _destroyTime = 30
      
      
      local _init = function(name, z)     
        UT.TestCompare(function() return name == _missionName end)
        UT.TestCompare(function() return z ~= nil end)
        UT.TestCompare(function() return z.ZoneName == _zones[1] or z.ZoneName == _zones[2] or z.ZoneName == _zones[3] end)
        return _argVal
      end
      
      local _destroy = function(rsc) end    
      local _complete = function(name, zone, rsc) end     
      local _fail = function(name, zone, rsc) end    
      local _oncomplete = function(name, zone, rsc) end   
      local _onfail = function(name, zone, rsc) end
      local _ontimeout = function(name, zone, rsc) end
      -- ================================== END OF TEST DATA =========================================================--
      
      
      
      local _sm = DSMT:New(_missionName, "Desc", "Image")
                        :SetZones(_zones)
                        :SetCheckRate(_rate)
                        :SetExpiryTime(_expTime)
                        :SetDestroyTime(_destroyTime)
                        :SetInitFnc(_init)
                        :SetDestroyFnc(_destroy)
                        :SetCompleteFnc(_complete)
                        :SetFailFnc(_fail)
                        :SetOnCompleteFnc(_oncomplete)
                        :SetOnFailFnc(_onfail)
                        :SetOnTimeoutFnc(_ontimeout)
      UT.TestCompare(function() return _sm.Zones ~= nil end)
      UT.TestCompare(function() return #_sm.Zones == #_zones end)
      UT.TestCompare(function() return _sm.Name == _missionName end)
      UT.TestCompare(function() return _sm.Desc == "Desc" end)
      UT.TestCompare(function() return _sm.Image == "Image" end)
      UT.TestCompare(function() return _sm.Init == _init end)
      UT.TestCompare(function() return _sm.Destroy == _destroy end)
      UT.TestCompare(function() return _sm.Complete == _complete end)
      UT.TestCompare(function() return _sm.Fail == _fail end)
      UT.TestCompare(function() return _sm.OnComplete == _oncomplete end)
      UT.TestCompare(function() return _sm.OnFail == _onfail end)
      UT.TestCompare(function() return _sm.OnTimeout == _ontimeout end)
      UT.TestCompare(function() return _sm.CheckRate == _rate end)
      UT.TestCompare(function() return _sm.Expiry == _expTime end)
      UT.TestCompare(function() return _sm.DestroyTime == _destroyTime end)
      UT.TestCompare(function() return _sm.Life == 0 end)
      UT.TestCompare(function() return _sm.Done == false end)
      
      -- testing SelectZone method
      UT.TestFunction(DSMT._selectZone, _zones)
      UT.TestCompare(function()
          local _z = DSMT._selectZone(_sm.Zones)
          env.info("UT_DSMT ZoneName : " .. _z.ZoneName )
          env.info("UT_DSMT _zones[1] : " .. _zones[1])
          return _z.ZoneName == _zones[1] or _z.ZoneName == _zones[2] or _z.ZoneName == _zones[3]  
        end)
      
      -- testing _initMission method
      UT.TestFunction(DSMT._initMission, _sm)
      UT.TestCompare(function() return _sm:_initMission() end)
      UT.TestCompare(function() return _sm.CurrentZone.ZoneName == _zones[1] or _sm.CurrentZone.ZoneName == _zones[2] or _sm.CurrentZone.ZoneName == _zones[3] end)
      UT.TestCompare(function() return _sm.Arguments == _argVal end)
    end)
  
  
  
  
  
  
  UT.TestCase("DSMT Manager", nil, 
  function()
    UT.TestData.INIT_CALLED = false
    UT.TestData.DESTROY_CALLED = false
    UT.TestData.COMPLETE_CALLED = false
    UT.TestData.FAIL_CALLED = false
    UT.TestData.ON_COMPLETE_CALLED = false
    UT.TestData.ON_FAIL_CALLED = false
    UT.TestData.ON_TIMEOUT_CALLED = false
  end,
    function()
      
      -- ================================== TEST DATA =========================================================--
      local _missionName = "Test Mission"
      local _argVal = "TestArg"
      local _zones = { "TestZone1", "TestZone2", "TestZone3" }
      local _expires = 30
      local _rate = 10
      local _destroyTime = 30
      local _customMissionVal = 100
      local _missionStatus = ""
      
      
      local _init = function(name, z)
        UT.TestData.INIT_CALLED = true
        UT.TestCompare(function() return name == _missionName end)
        UT.TestCompare(function() return z ~= nil end)
        UT.TestCompare(function() return z.ZoneName == _zones[1] or z.ZoneName == _zones[2] or z.ZoneName == _zones[3] end)
        return _argVal
      end
      
      local _destroy = function(args)
        UT.TestData.DESTROY_CALLED = true
        UT.TestCompare(function() return args == _argVal end)
      end
      
      local _complete = function(name, z, args)
        UT.TestData.COMPLETE_CALLED = true
        UT.TestCompare(function() return name == _missionName end)
        UT.TestCompare(function() return z ~= nil end)
        UT.TestCompare(function() return z.ZoneName == _zones[1] or z.ZoneName == _zones[2] or z.ZoneName == _zones[3] end)
        UT.TestCompare(function() return args == _argVal end)
        return _customMissionVal == 1
      end
      
      local _fail = function(name, z, args)
        UT.TestData.FAIL_CALLED = true
        UT.TestCompare(function() return name == _missionName end)
        UT.TestCompare(function() return z ~= nil end)
        UT.TestCompare(function() return z.ZoneName == _zones[1] or z.ZoneName == _zones[2] or z.ZoneName == _zones[3] end)
        UT.TestCompare(function() return args == _argVal end)
        return _customMissionVal == 0
      end
      
      local _oncomplete = function(name, z, args)
        UT.TestData.ON_COMPLETE_CALLED = true
        UT.TestCompare(function() return name == _missionName end)
        UT.TestCompare(function() return z ~= nil end)
        UT.TestCompare(function() return z.ZoneName == _zones[1] or z.ZoneName == _zones[2] or z.ZoneName == _zones[3] end)
        UT.TestCompare(function() return args == _argVal end)   
        _missionStatus = "SUCCESS"
      end
      
      local _onfail = function(name, z, args)
        UT.TestData.ON_FAIL_CALLED = true
        UT.TestCompare(function() return name == _missionName end)
        UT.TestCompare(function() return z ~= nil end)
        UT.TestCompare(function() return z.ZoneName == _zones[1] or z.ZoneName == _zones[2] or z.ZoneName == _zones[3] end)
        UT.TestCompare(function() return args == _argVal end)  
        _missionStatus = "FAIL"
      end
        
      local _ontimeout = function(name, z, args)
        UT.TestData.ON_TIMEOUT_CALLED = true   
        UT.TestCompare(function() return name == _missionName end)
        UT.TestCompare(function() return z ~= nil end)
        UT.TestCompare(function() return z.ZoneName == _zones[1] or z.ZoneName == _zones[2] or z.ZoneName == _zones[3] end)
        UT.TestCompare(function() return args == _argVal end)     
        _missionStatus = "TIMEOUT"
      end
      -- ================================== END OF TEST DATA =========================================================--
      
      
      
      local _sm = DSMT:New(_missionName, "Desc", "Image")
                        :SetZones(_zones)
                        :SetCheckRate(_rate)
                        :SetExpiryTime(_expires)
                        :SetDestroyTime(_destroyTime)
                        :SetInitFnc(_init)
                        :SetDestroyFnc(_destroy)
                        :SetCompleteFnc(_complete)
                        :SetFailFnc(_fail)
                        :SetOnCompleteFnc(_oncomplete)
                        :SetOnFailFnc(_onfail)
                        :SetOnTimeoutFnc(_ontimeout)
                        
      UT.TestCompare(function() return _sm.Zones ~= nil end)
      UT.TestCompare(function() return #_sm.Zones == #_zones end)
      UT.TestCompare(function() return _sm.Name == _missionName end)
      UT.TestCompare(function() return _sm.Init == _init end)
      UT.TestCompare(function() return _sm.Destroy == _destroy end)
      UT.TestCompare(function() return _sm.Complete == _complete end)
      UT.TestCompare(function() return _sm.Fail == _fail end)
      UT.TestCompare(function() return _sm.OnComplete == _oncomplete end)
      UT.TestCompare(function() return _sm.OnFail == _onfail end)
      UT.TestCompare(function() return _sm.OnTimeout == _ontimeout end)
      UT.TestCompare(function() return _sm.CheckRate == _rate end)
      UT.TestCompare(function() return _sm.Expiry == _expires end)
      UT.TestCompare(function() return _sm.DestroyTime == _destroyTime end)
      UT.TestCompare(function() return _sm.Life == 0 end)
      UT.TestCompare(function() return _sm.Done == false end)
      
      UT.TestFunction(DSMT._initMission, _sm)
      UT.TestCompare(function() return UT.TestData.INIT_CALLED end)
      
      _customMissionVal = 1
      UT.TestFunction(DSMT._manage, _sm, 0)
      UT.TestCompare(function() return UT.TestData.COMPLETE_CALLED end)  
      UT.TestCompare(function() return UT.TestData.ON_COMPLETE_CALLED end)
      UT.TestCompare(function() return _sm.Done == true end) -- mission should be completed
      UT.TestCompare(function() return _missionStatus == "SUCCESS" end) -- mission status should be SUCCESS
      
      _customMissionVal = 0
      UT.TestFunction(DSMT._manage, _sm, 0)
      UT.TestCompare(function() return UT.TestData.FAIL_CALLED end)
      UT.TestCompare(function() return UT.TestData.ON_FAIL_CALLED end)
      UT.TestCompare(function() return _sm.Done == true end) -- mission should be completed
      UT.TestCompare(function() return _missionStatus == "FAIL" end) -- mission status should be FAIL
      
      -- restart side mission (pretending this is a new mission)
      _customMissionVal = 100
      _sm.Done = false
      _sm.Life = 0
      
      UT.TestFunction(DSMT._manage, _sm, 0)
      UT.TestCompare(function() return _sm.Done == false end)
      UT.TestCompare(function() return _sm.Life == 10 end)
      
      UT.TestFunction(DSMT._manage, _sm, 0)
      UT.TestCompare(function() return _sm.Done == false end)
      UT.TestCompare(function() return _sm.Life == 20 end)
      
      UT.TestFunction(DSMT._manage, _sm, 0)
      UT.TestCompare(function() return _sm.Done == true end)
      UT.TestCompare(function() return _sm.Life == 30 end)
      
      -- UT.TestFunction(DSMT._manage, _sm, 0)
      UT.TestCompare(function() return UT.TestData.ON_TIMEOUT_CALLED end)
      UT.TestCompare(function() return _sm.Done == true end)
      UT.TestCompare(function() return _missionStatus == "TIMEOUT" end) -- mission status should be TIMEOUT
      
      UT.TestFunction(DSMT._destroy, _sm, 0)
      UT.TestCompare(function() return UT.TestData.DESTROY_CALLED end)
    end)
