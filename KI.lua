if not KI then
  KI = {}
end

assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\Spatial.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Toolbox.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\GC.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\SLC.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\DWM.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\DSMT.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\CP.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Config.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Query.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Init.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Loader.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Scheduled.lua"))()
assert(loadfile("C:\\Program Files (x86)\\ZeroBraneStudio\\myprograms\\DCS\\KI\\KI_Hooks.lua"))()



--================= START OF INIT ================

SLC.Config.PreOnRadioAction = KI.Hooks.SLCPreOnRadioAction
SLC.Config.PostOnRadioAction = KI.Hooks.SLCPostOnRadioAction
--GC.OnLifeExpired = KI.Hooks.GCOnLifeExpired
GC.OnDespawn = KI.Hooks.GCOnDespawn
KI.Init.Depots()
KI.Init.CapturePoints()
KI.Init.SideMissions()
SLC.InitSLCRadioItemsForUnits()

timer.scheduleFunction(KI.Scheduled.UpdateCPStatus, {}, timer.getTime() + 5)
timer.scheduleFunction(KI.Scheduled.CheckSideMissions, {}, timer.getTime() + 5)

--KI.Loader.SaveData()
KI.Loader.LoadData()