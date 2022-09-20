--
-- My Input Helpe for FS19
-- @author:    	Tiszai Istvan (tiszaii@hotmail.com)
-- @history:	2022-09-13
--
local directory = g_currentModDirectory
local modName = g_currentModName

--source(Utils.getFilename("helperControl.lua", g_currentModDirectory))

HelperControlRegister = {}

-- if you want to add a specialization to an existing vehicleType you can use this function
-- function to register specializations to existing vehicleTypes
function HelperControlRegister.registerSpecializationVehicle(vehicleType, specialization, specName)
    print("-----register specialization to vehicleType : ".. vehicleType.name)
    table.insert(vehicleType.specializationNames, specName)
    vehicleType.specializationsByName[specName] = specialization
    table.insert(vehicleType.specializations, specialization)
end

-- register specializations
g_specializationManager.addSpecialization('helperControl', 'helperControl', 'HelperControl',  Utils.getFilename("helperControl.lua", g_currentModDirectory))
--HelperControl:loadSettings()
    
-- only needed if you want to add specialization to an existing vehicleType. Here sowingMachine
-- register exampleSpec to vehicleType sowingMachine
if  g_vehicleTypeManager.vehicleTypes.sowingMachine ~= nil then
    HelperControlRegister.registerSpecializationVehicle(g_vehicleTypeManager.vehicleTypes.sowingMachine, HelperControl, 'helpercontrol')
    HelperControlRegister.registerSpecializationVehicle(g_vehicleTypeManager.vehicleTypes.tractor, HelperControl, 'helpercontrol')
end
