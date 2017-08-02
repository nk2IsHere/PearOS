--[[

PearOS by Oliver 'oeed' Cooper.
PearOS is released under Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported (CC BY-NC-ND 3.0) License

Basically, that is not mine fully. But I'm trying to make it rly usable //nk2
]]--

--Slightly Modified os.loadAPI--
local tAPIsLoading = {}


StringSplit = function(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

CopyTable = function(t)
	local u = { __index = _G }
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

function includeFile(_sPath)
	local sName = fs.getName( _sPath )

	if string.match(sName, ".lua") then
		sName = StringSplit(sName, ".")[1]
	end

	if tAPIsLoading[sName] == true then
		printError( "API "..sName.." is already being loaded" )
		return false
	end
	tAPIsLoading[sName] = true

	local tEnv = getfenv()


	setmetatable( tEnv, { __index = _G } )
	tEnv['OSSettings'] = OSSettings
	local fnAPI, err = loadfile( _sPath )
	if fnAPI then
		setfenv( fnAPI, tEnv )
		fnAPI()
	else
		printError( err )
        tAPIsLoading[sName] = nil
		return false
	end
	
	local oldv = nil

	local tAPI = {}
	for k,v in pairs( tEnv ) do
		tAPI[k] =  v
		oldv = k
	end
	_G[sName] = tAPI
	tAPIsLoading[sName] = nil
	if verbose then
		sleep(0)
	end
	return true
end

function include(_sDir)
	if fs.isDir(_sDir) then
		for _, file in pairs(fs.list(_sDir)) do
			if string.sub(file,1,1) ~= "." then
				if fs.isDir(_sDir.."/"..file) then
					include(_sDir.."/"..file)
				else
					includeFile(_sDir.."/"..file)
					if verbose then
						print("Included "..file)
					end
				end
			end
		end
	else
		error("Attempt to dir-include a non-directory")
	end
end

OSVersion = 0.3
OSVersionLong = "Preview 3"

OSCurrentWindow = nil --the window in focus
OSSelectedEntity = nil
OSUpdateTimer = nil
OSWindowDragTimer = nil
OSWindowResizeTimer = nil
OSCommandKeyTimer = nil
OSSleepTimer = nil

OSFirstRunMode = false
--default settings
OSSettings = {
	dark_mode = false, 
	desktop_bg = colours.grey,
	machine_name = "",
	user_name = "",
	update_frequency = 1,
	extension_associations = {},
	sleep_delay = 0
}	

OSReloadSettings = function()
	OSSaveSettings()
	desktop.BackgroundColour = OSSettings['desktop_bg']
	desktop:Draw()
	OSSettings = OSTableIO.load("Home/Settings.cfg")
	--load the extension associations
	--OSExtensionAssociations.list = OSSettings
end

OSChangeSetting = function(_key, _value, _reload)
	OSSettings[_key] = _value
	if _reload then
		OSReloadSettings()
	end
end

OSSaveSettings = function()
	OSSettings['extension_associations'] = OSExtensionAssociations.list
	OSTableIO.save(OSSettings,"Home/Settings.cfg")
end

OSLog = function(message)
	local file = fs.open("log", "a")
	file.write(message.."\n")
    file.close()
	term.setBackgroundColour(colours.black)
	term.setTextColour(colours.white)
	print(message)
end

OSUpdate = function()
	if OSServices.shouldHideAllMenus then
		OSServices.hideAllMenus()
		OSServices.shouldHideAllMenus = false
	end
	--
	--sleep(0.1)
	OSDrawing.Draw()
	OSUpdateTimer = os.startTimer(OSServices.updateFrequency) 
end

function OSHandleClick (x, y)
	OSSelectedEntity = nil
	for _,entity in pairs(OSInterfaceEntities.list) do
	
		--check if the click overlaps an entities
		if OSServices.pointOverlapsRect({x = x, y = y}, entity)  then
			if OSServices.clickEntity(entity, x, y) then
				OSSelectedEntity = entity
				return
			end
		end
	end

			--check windows
			--first click on the current window
	for _,key in ipairs(OSInterfaceApplications.order) do
		local application = OSInterfaceApplications.list[key]
		for _,window in pairs(application.windows) do

			--check if the click overlaps an entities
			if window.isMinimised then
				break
			end

			if OSServices.pointOverlapsRect({x = x, y = y}, window)   then
				local relativeX = x - window.x + 1
				local relativeY = y - window.y
				OSCurrentWindow = window
				OSInterfaceApplications.switchTo(application)
				window:action(relativeX, relativeY)
				return
			end
		end
	end
	OSServices.hideAllMenus()
end

function OSHandleCharacter (char) 
	if OSSelectedEntity then
	OSSelectedEntity:insertCharacter(char)
	end
end

function OSHandleKeystroke (keystroke) 
	local name = keys.getName(keystroke)
	if name == "left" then
		if OSSelectedEntity then
		OSSelectedEntity:moveCursor(-1)
		end
	elseif name == "right" then
		if OSSelectedEntity then
		OSSelectedEntity:moveCursor(1)
		end
	elseif name == "backspace" then
		if OSSelectedEntity then
		OSSelectedEntity:removeCharacter (-1)
		end
	elseif name == "delete" then
		if OSSelectedEntity then
		OSSelectedEntity:removeCharacter (0)
		end
	elseif name == "enter" then
		if OSSelectedEntity then
			OSSelectedEntity:submit()
		end
	elseif keystroke == 219 or keystroke == 220 or name == "leftCtrl" or name == "rightCtrl" then
		OSCommandKeyTimer = os.startTimer(OSServices.commandTimeout) 
	elseif not name == nil then
		if #name == 1 then -- a character
			if OSCommandKeyTimer then
			--if the user pressed the command key (presumably its still down)
			OSHandleKeyCommand(name:upper())
			end
		end
	else
	--		print(name)
	end
end

function OSHandleKeyCommand (key)
	local application = OSInterfaceApplications.current() --the current application
	if key == "R" and false then --this is disabled, enable it if you wish
		os.reboot()
	else
		if OSKeyboardShortcuts.list[key] then
			local action = OSKeyboardShortcuts.list[key]
			action()
		end
	end
	OSUpdate()
end

function OSHandleScroll (x, y, direction)
	--only windows are checked, only windows should have a scrolling view
	for _,application in pairs(OSInterfaceApplications.list) do
		for _,window in pairs(application.windows) do
			--check if the click overlaps an entities
			if OSServices.pointOverlapsRect({x = x, y = y}, window)   then

				--give the window focus
				OSCurrentWindow = window
				--get the click position relative to the window
				local relativeX = x - window.x + 1
				local relativeY = y - window.y

				--if the y of the click was 0 (the window frame) do special actions
				if relativeY == 0 then

					if relativeX == 1 then --close button
					window:close()
					return
					elseif relativeX == 2 and window.canMinimise then --minimise button

					elseif relativeX == 3 and window.canMaximise then --maximise button

					else --main bar
					window.dragX = relativeX  + 1
					OSWindowDragTimer = os.startTimer(OSServices.dragTimeout)
					end
				else -- it was in the window content
					for _,entity in pairs(window.entities) do

						--check if the click overlaps an entities
						if entity.canScroll == true and OSServices.pointOverlapsRect({x = relativeX - 1, y = relativeY - 1}, entity)  then

							local newScroll = entity.scrollY - direction
							if newScroll >= entity.maxScrollY and newScroll <= 0  then
								entity.scrollY = newScroll
								OSUpdate()
							end

						end
					end
				end

			end
		end
	end
end

function OSHandleDrag (x,y)
	--check the window should be draged
	if OSWindowDragTimer and not OSFirstRunMode then
		OSCurrentWindow.x = x - OSCurrentWindow.dragX
		if y == 1 then
			y = 2
		end
		OSCurrentWindow.y = y  
		--update the time out
		OSWindowDragTimer = os.startTimer(OSServices.dragTimeout)
		--redraw the screen
		OSUpdate()
	elseif OSWindowResizeTimer then
		--resize the window
		OSCurrentWindow:resize(x - OSCurrentWindow.x + 1, y - OSCurrentWindow.y + 1)
		--update the time out
		OSWindowResizeTimer = os.startTimer(OSServices.dragTimeout)
	end
	if OSSelectedEntity then
		if OSServices.pointOverlapsRect({x = x, y = y}, OSSelectedEntity)  then
			local endPos = x + (y * OSSelectedEntity.width)
			OSSelectedEntity.Selection[2] = endPos
		end
	end
end

function EventHandler ()
	OSUpdateTimer = os.startTimer(OSServices.updateFrequency)
	OSServices.resetSleepTimer()
	while true do
		local event, arg, x, y = os.pullEventRaw()

		if event == "timer" then
		if arg == OSUpdateTimer then

			if not OSServices.computerCraftMode then
				OSUpdate()
				if clock then
					clock:Draw()
				end
			end
			--[[
			It would be very easy to turn off constant refreshing. It would work, a few problems with the button selection colour prevent me from doing so.
			To switch, comment out OSUpdate
			]]
			OSUpdateTimer = os.startTimer(OSServices.updateFrequency)
			elseif arg == OSWindowDragTimer then
			OSWindowDragTimer = nil
			elseif arg == OSCommandKeyTimer then
			OSCommandKeyTimer = nil
			elseif arg == OSWindowResizeTimer then
			OSWindowResizeTimer = nil
			elseif arg == OSSleepTimer then
			--OSServices.sleep()
		end
		elseif event == "char" then
			OSServices.resetSleepTimer()
			OSHandleCharacter(arg)
		elseif event == "key" then
			OSServices.resetSleepTimer()
			OSHandleKeystroke(arg)
		elseif event == "mouse_click"  then
			OSServices.resetSleepTimer()
			if arg == 1 then --left click
				OSHandleClick(x, y)
			else --right click
			--os.reboot()
			end
		elseif event == "monitor_touch" then
			OSServices.resetSleepTimer()
			OSHandleClick(x, y)
		elseif event == "mouse_drag" then
			OSServices.resetSleepTimer()
			OSHandleDrag(x, y)
		elseif event == "mouse_scroll" then
			OSServices.resetSleepTimer()
			OSHandleScroll(x, y, arg)
		else
		--	  			print(event)
		--	  			print(arg)
		end
	end
end

function initMenuBar()
	local menuItems = {
		OSMenuItem:new("About", function()
										local about = OSApplication:load("System/Applications/About.app")
										OSApplication.run(about)
								end),
		OSMenuSplitter:new(),
		OSMenuItem:new("Preferences", function() 
											local systemPreferences = OSApplication:load("System/Applications/Preferences.app")
											OSApplication.run(systemPreferences)
										end),
		OSMenuSplitter:new(),
		OSMenuItem:new("Switch Screen", function() OSServices.switchScreen() end),
		OSMenuItem:new("Restart", function() OSServices.restart() end),
		OSMenuItem:new("Shut Down", function() OSServices.shutdown() end)
	}
	local menu = OSMenu:new(1, 1, "P", menuItems)

	clock = OSClockButton:new(20,1,"--:--:--")

	desktop = OSDesktop:new()
	OSInterfaceEntities.add(OSMenuBar:new())
	OSInterfaceEntities.add(clock)
	OSInterfaceEntities.add(menu)
end

function initDock()
	local dockItems = {}
	table.insert(dockItems, OSDockItem:new("System/Applications/Finder.app"))
	local applicationsPath = "Applications/"
	for _,name in ipairs(OSFileSystem.list(applicationsPath)) do
		if OSFileSystem.extension(name) == "app" then
			table.insert(dockItems, OSDockItem:new(applicationsPath..name))
		end
	end
	dock = OSDock:new(dockItems)
	OSInterfaceEntities.add(dock)
end

function startFinder()
	Finder = OSApplication:load("System/Applications/Finder.app")
	OSApplication.run(Finder)
end

function init()
	term.setTextColour(colours.white)

	--add Macintosh command keys because computercraft doesn't have them in the keys api *cough* cloudy & dan200, add them *cough*
	keys[219] = "leftCommand"
	keys[220] = "rightCommand"
	--this isn't working, it is implimented manually when needed

	if fs.exists("/Home/Settings.cfg") then
		OSSettings = OSTableIO.load("/Home/Settings.cfg")
		os.setComputerLabel(OSSettings['machine_name'])

		include("System/Library/Frameworks")
		OSExtensionAssociations.list = OSSettings['extension_associations']

		--Verbose wait
		wait = OSSettings['boot_arg'] == 47
		while wait do
			term.write(shell.dir().."/# ")
			local command = io.read()
			if command == "pear" then
				print("Starting PearOS...")
				wait = false
			else
				result = shell.run(command)
			end

		end

		initMenuBar()
		initDock()
		startFinder()
		clock:Draw()
	else
		firstRun()
	end

	OSUpdate()
	EventHandler()
end

function firstRun()
	include("System/Library/Frameworks")
	OSFirstRunMode = true
	desktop = OSDesktop:new()
	FirstRun = OSApplication:load("System/Applications/FirstRun.app")
	OSApplication.run(FirstRun)
end