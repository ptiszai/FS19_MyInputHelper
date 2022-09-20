--
-- My Input Helpe for FS19
-- @author:    	Tiszai Istvan (tiszaii@hotmail.com)
-- @history:	2022-09-15
--

--			configDir  = getUserProfileAppPath().. "modsSettings/FS19_VehicleControlAddon"
--			configFile = "config.xml" 
HelperControl = {}
HelperControl.modDirectory  = g_currentModDirectory
HelperControl.start_help_flag = false
--HelperControl.once_onLoad = true
HelperControl.buttonsTable = {}

function HelperControl.prerequisitesPresent(specializations)
	return SpecializationUtil.hasSpecialization(HelperControl, specializations)
end

----
function HelperControl.onStartMission() 
    print("INFO:helperControl:onStartMission")
end

----
function HelperControl.registerEventListeners(vehicleType)  
   print("INFO:HelperControl:registerEventListeners")
    for _,n in pairs( {"onLoad", "onUpdate" }) do
        SpecializationUtil.registerEventListener(vehicleType, n, HelperControl)
    end
    table.insert(vehicleType.eventListeners.onRegisterActionEvents, HelperControl)
end

----
function HelperControl.registerFunctions(vehicleType)	
    print("INFO:HelperControl.registerFunctions");
    SpecializationUtil.registerFunction(vehicleType, "onStartMission", HelperControl.onStartMission)   
end

function  HelperControl.registerOverwrittenFunctions(vehicleType)
    print("INFO:HelperControl.registerOverwrittenFunctions");
    
    -- Only needed for action event for player
    Player.registerActionEvents = Utils.appendedFunction(Player.registerActionEvents, HelperControl.registerActionEventsPlayer);       
end

--- only needed for action event for vehicle
function HelperControl:onRegisterActionEvents(isSelected, isOnActiveVehicle)
    print("INFO:HelperControl:onRegisterActionEvents") 
    -- this function is called onLoad of a vehicle and when the state of the vehicle changes
    -- when the vehicle is selected then isSelected is true
    -- when the vehicle is attached to a vehicle that is active isOnActiveVehicle is true
	if self.isClient and self:getIsActiveForInput(true, true) then
		if self.helperActionEvents == nil then 
			self.helperActionEvents = {}
		end 
        if self:getIsActiveForInput(true, true) then
            for _,actionName in pairs({ "HELPER_30",                                        
                                        "HELPER_31", 
                }) do
                local _, eventName = self:addActionEvent(self.helperActionEvents, InputAction[actionName], self, HelperControl.onActionCallback, false, true, false, true, nil);
                if g_inputBinding ~= nil and g_inputBinding.events ~= nil and g_inputBinding.events[eventName] ~= nil then                                    
                    g_inputBinding.events[eventName].displayPriority = 1                     
                end
            end
        end
	end

end

-- only needed for action event for player
function HelperControl:registerActionEventsPlayer()
    print("INFO:HelperControl:registerActionEventsPlayer")

	if self.isClient then     
        for _,actionName in pairs({ "HELPER_1",                                        
                                    "HELPER_2",
                                    "HELPER_3",
                                    "HELPER_4",
                                    "HELPER_5",
                                    "HELPER_6", 
                                    "HELPER_7",
                                    "HELPER_8",
                                    "HELPER_9",
                                    "HELPER_10",   
                                    "HELPER_11",        
                                    "HELPER_12",
                                    "HELPER_13",
                                    "HELPER_14",
                                    "HELPER_15",
                                    "HELPER_16",
                                    "HELPER_17",
                                    "HELPER_18",
                                    "HELPER_19",
                                    "HELPER_20",
                                    "HELPER_21",
                                    "HELPER_22",
                                    "HELPER_23",
                                    "HELPER_24",
                                    "HELPER_25", 
                                    "HELPER_26",                                   
        }) do        
            local _, actionEventId1 = g_inputBinding:registerActionEvent(InputAction[actionName], self,  HelperControl.actionKeyPressed , false, true, false, true) 
            if g_inputBinding ~= nil and g_inputBinding.events ~= nil and g_inputBinding.events[eventName] ~= nil then                                    
                g_inputBinding.events[eventName].displayPriority = 1                     
            end        
        end
	end
    --    DebugUtil.printTableRecursively(g_inputBinding,"-",0,1)
end


function HelperControl:actionKeyPressed(actionName, keyStatus, arg4, arg5, arg6)
    --print("INFO:HelperControl:actionKeyBPressed")
    --print(actionName)
    --print(keyStatus) --1.00 pressed 0.000 not pressed, maybe any value for analog inputs
    --print(arg4) --nil maybe callbackStatus
    --print(arg5) --bool unknown
    --print(arg6) --bool unknown
    --local spec = self.spec_helpercontrol  
    if keyStatus > 0 then    
        for ii = 1, #HelperControl.buttonsTable, 1 do    
            if actionName == 'HELPER_' .. tostring(ii) then
                print("INFO:HELPER_" .. tostring(ii)) 
                g_currentMission:showBlinkingWarning(HelperControl.buttonsTable[ii].message, 3000)
                return
            end
        end
    end

end

----
--- if vehicle is selected.
function HelperControl:onActionCallback(actionName, keyStatus, arg4, arg5, arg6)
    print("INFO:helperControl:onActionCallback for vehicles")
    if keyStatus > 0 then    
        for ii = 1, #HelperControl.buttonsTable, 1 do    
            if actionName == 'HELPER_' .. tostring(ii) then
                print("INFO:HELPER_" .. tostring(ii)) 
                g_currentMission:showBlinkingWarning(HelperControl.buttonsTable[ii].message, 3000)
                return
            end
        end
    end
end

--- if vehicle is selected.
--- InputAction.AXIS_CRUISE_CONTROL
function HelperControl:actionEventCruiseControlValue(sself, actionName, inputValue, callbackState, isAnalog)
    local spec = self.spec_helpercontrol
    spec.cruiseControlValue = spec.cruiseControlValue + inputValue 
    g_currentMission:showBlinkingWarning(string.format('AXIS_CRUISE_CONTROL: %d ',spec.cruiseControlValue), 3000)
  --  print(string.format('AXIS_CRUISE_CONTROL: %d ',spec.cruiseControlValue))
end
Drivable.actionEventCruiseControlValue = Utils.overwrittenFunction( Drivable.actionEventCruiseControlValue, HelperControl.actionEventCruiseControlValue )

----
function HelperControl:onLoad(savegame)
    print("INFO:helperControl:onLoad")   
    
    self.clearTable_helpElements = HelperControl.clearTable_helpElements
    self.drawMyHelpInfos = HelperControl.drawMyHelpInfos
    self.updateInputContext = HelperControl.updateInputContext
    self.drawHelpInfos = HelperControl.drawHelpInfos
    self.clearTable_helpElements = HelperControl.clearTable_helpElements
    self.create_helpElement = HelperControl.create_helpElement
    self.drawGroupInfo = HelperControl.drawGroupInfo
    self.loadSettings = HelperControl.loadSettings
    self.actionEventCruiseControlValue = HelperControl.actionEventCruiseControlValue
  --  self.actionKeyPressed = HelperControl.actionKeyPressed

    g_currentMission.hud.inputHelp.hhelpElements = {}
    g_currentMission.hud.inputHelp.axisIconOffsetX = 0.015

    local spec = self.spec_helpercontrol  
    spec.cruiseControlValue = 0
  --  spec.buttonsTable = {}
    spec.original_help = false  
    spec.switch = false
    spec.overlay1 = createImageOverlay(HelperControl.modDirectory .. "images/overlay_bg.dds")
    setOverlayColor(spec.overlay1, 0, 0, 0, 0.75)
    spec.ov_w = 0.18 
    spec.ov_h = 0.17
    spec.posX_ov = 0.03
    spec.posY_ov = 0.77
    spec.overlayBorder = 0.01
    self:loadSettings()
    self:drawMyHelpInfos(1)

end

----
function HelperControl:onUpdate(dt)
-- print("INFO:helperControl:onUpdate")
    local spec = self.spec_helpercontrol
    if spec.original_help then
        if helperControl.start_help_flag then
            local availableHeight = g_currentMission.hud.inputHelp:getAvailableHeight()
            local helpElements, usedHeight, usedPressedMask = g_currentMission.hud.inputHelp:getInputHelpElements(availableHeight, nil, nil, nil)
            if helpElements ~= nil then
                if #helpElements > 1 then
                    for k in pairs(helpElements) do            
                        table.insert(g_currentMission.hud.inputHelp.hhelpElements, helpElements[k])
                    end           
                    helperControl.start_help_flag = false
                end          
            end
        end  
    end

end

---Utils.getNoNil(getXMLFloat(xmlFile, "placeable.placement#sizeX"), self.placementSizeX)

---
function HelperControl:loadSettings()
    print("INFO:helperControl:loadConfigData")
    if g_currentMission == nil or not g_currentMission:getIsServer() then 
        return 
    end
    --local spec = self.spec_helpercontrol  
    local file = Utils.getFilename("buttons.xml", HelperControl.modDirectory);
--    local xmlFile = getUserProfileAppPath().. "modsSettings/FS19_MyInputHelper/buttons.xml"
    local i = 0
    local key  = ""
    local _text = ""
    local _image = ""
 --   local _item = {}
    if fileExists(file) then 
        local xmlFile = loadXMLFile('HelperControl', file, "buttons");
        while true do
            key  = string.format( "buttons.button%d", i+1 )
            if not hasXMLProperty(xmlFile, key) then
                break
            end
            local _item = {}
			_text = Utils.getNoNil(getXMLString( xmlFile, key.."#text" ))
            _item.text = _text
			_message = Utils.getNoNil(getXMLString( xmlFile, key.."#message" )) 
            _item.message = _message
			_image = Utils.getNoNil(getXMLString( xmlFile, key.."#image" )) 
            _item.image = _image
            table.insert(HelperControl.buttonsTable, _item )
			i = i + 1          
        end
    end
    return
end

----
function HelperControl:updateInputContext()
    local availableHeight = self:getAvailableHeight()
    if not self.animation:getFinished() then
        availableHeight = math.min(availableHeight, self.animationAvailableHeight)
    end
    local pressedComboMaskGamepad, pressedComboMaskMouse, pressedComboMaskFarmWheel = self.inputManager:getComboCommandPressedMask()
    local useGamepadButtons = self.isConsoleVersion or (self.inputManager:getInputHelpMode() == GS_INPUT_HELP_MODE_GAMEPAD)
    self:updateComboHeaders(useGamepadButtons, pressedComboMaskMouse, pressedComboMaskGamepad)

   if  g_currentMission.hud.inputHelp.hhelpElements ~= nil then  
        self.visibleHelpElements = g_currentMission.hud.inputHelp.hhelpElements  
        self:updateEntries(g_currentMission.hud.inputHelp.hhelpElements, usedPressedMask)
        self.currentAvailableHeight = availableHeight -- store remainder for dynamic components (e.g. HUD extensions)
    end
end
InputHelpDisplay.updateInputContext = Utils.overwrittenFunction( InputHelpDisplay.updateInputContext, HelperControl.updateInputContext )

---
function HelperControl:drawHelpInfos()
    local framePosX, framePosY = self.entriesFrame:getPosition()
    local entriesHeight = self.entriesFrame:getHeight()
    for i, helpElement in ipairs(self.visibleHelpElements) do
        local entryPosY = framePosY + entriesHeight - i * self.entryHeight
        if helpElement.iconOverlay ~= nil then
            g_currentMission.hud.inputHelp.axisIconOffsetX = 0.01
            g_currentMission.hud.inputHelp.axisIconHeight = 0.035 --0.025
            g_currentMission.hud.inputHelp.axisIconWidth = 0.035 --0.01875
            local posX = framePosX + self.axisIconOffsetX
            local posY = entryPosY + self.entryHeight * 0.1
            helpElement.iconOverlay:setPosition(posX, posY)
            helpElement.iconOverlay:setDimension(self.axisIconWidth, self.axisIconHeight)
            helpElement.iconOverlay:render()
        end
            setTextBold(false)
            setTextColor(unpack(InputHelpDisplay.COLOR.HELP_TEXT))
            local text = ""
            local textWidth = 0
            local posX, posY = framePosX, entryPosY
            local textLeftX = 1
            if helpElement.textRight ~= "" then
                setTextAlignment(RenderText.ALIGN_RIGHT)
                text = helpElement.textRight
                textWidth = getTextWidth(self.helpTextSize, text)
                posX = posX + self.entryWidth + self.helpTextOffsetX
                posY = posY + (self.entryHeight - self.helpTextSize) * 0.5 + self.helpTextOffsetY
                textLeftX = posX - textWidth
                renderText(posX, posY, self.helpTextSize, text)
            end
            if helpElement.textLeft ~= "" then
                setTextAlignment(RenderText.ALIGN_LEFT)
                text = helpElement.textLeft
                posX = framePosX + self.extraTextOffsetY + 0.05
                posY = entryPosY + self.entryHeight * 0.35
                textLeftX = posX
                renderText(posX, posY, self.helpTextSize, text)
            end
    end
end
InputHelpDisplay.drawHelpInfos = Utils.overwrittenFunction( InputHelpDisplay.drawHelpInfos, HelperControl.drawHelpInfos )

---
function HelperControl:create_helpElement(ltext, rtext, imageIconName)
    local helpElement = InputHelpElement.new(nil, nil, nil, nil, nil, "none")
    helpElement.textRight = rtext
    helpElement.textLeft = ltext
    helpElement.inlineModifierButtons = false
    if imageIconName  ~= nil then
       helpElement.iconOverlay = Overlay:new(HelperControl.modDirectory .. "images/".. imageIconName, 0, 0, 0, 0)
    end
    table.insert(g_currentMission.hud.inputHelp.hhelpElements, helpElement)
end

----
function HelperControl:clearTable_helpElements()
    if g_currentMission.hud.inputHelp.hhelpElements ~= nil then
        for k in pairs(g_currentMission.hud.inputHelp.hhelpElements) do
            g_currentMission.hud.inputHelp.hhelpElements[k] = nil
        end
    end
end

---
function HelperControl:drawGroupInfo()
    local spec = self.spec_helpercontrol  
    for ii, item in ipairs(HelperControl.buttonsTable) do 
        self:create_helpElement(":" .. tostring(ii), item.text, item.image)
    end
end

---
function HelperControl:drawMyHelpInfos()
    self:clearTable_helpElements()
    self:drawGroupInfo()
    g_currentMission.hud.inputHelp.visibleHelpElements = g_currentMission.hud.inputHelp.hhelpElements
end

Mission00.onStartMission = Utils.appendedFunction(Mission00.onStartMission, HelperControl.onStartMission) 