--[[

PearOS by Oliver 'oeed' Cooper.
PearOS is released under Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported (CC BY-NC-ND 3.0) License

Basically, oeed, thank you for creating this. Now I'm trying to make it better. and darker. //nk2
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

function includeFile(_sPath)
	local sName = fs.getName( _sPath )

	if string.match(sName, ".lua") then
		sName = string.gsub(sName, ".lua", "")
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

OSVersion = 0.4
OSVersionLong = "Preview 4"

OSCurrentWindow = nil --the window in focus
OSSelectedEntity = nil
OSUpdateTimer = nil
OSWindowDragTimer = nil
OSWindowResizeTimer = nil
OSCommandKeyTimer = nil
OSSleepTimer = nil

OSFirstRunMode = false
--default settings
OSCurrentUser = nil
OSSettings = {
	users = {},
	update_frequency = 1,
	sleep_delay = 0,
}

OSSettingsUser = {
	password = "",
	dark_mode = false, 
	desktop_bg = colours.grey,
	machine_name = "",
	extension_associations = {},
	users = {},
	dock_items = {},
}	

SetCurrentUser = function(user)
	OSCurrentUser = user
end

SetFTMode = function(mode) 
	OSFirstRunMode = mode
end

OSReloadSettings = function()
	OSSettings = OSTableIO.load("Home/Settings.cfg")
	desktop.BackgroundColour = OSSettings['users'][OSCurrentUser]['desktop_bg']
	desktop:Draw()
end

OSChangeSetting = function(_key, _value, _reload)
	OSSettings[_key] = _value
	if _reload then
		OSReloadSettings()
	end
end

OSSaveSettings = function()
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
	if OSInterfaceServices.shouldHideAllMenus then
		OSInterfaceServices.hideAllMenus()
		OSInterfaceServices.shouldHideAllMenus = false
	end
	OSDrawing.Draw()
	OSUpdateTimer = os.startTimer(OSEvents.updateFrequency) 
end

OSStartDesktop = function()
	OSExtensionAssociations.list = OSSettings['users'][OSCurrentUser]['extension_associations']
	os.setComputerLabel(OSSettings['users'][OSCurrentUser]['machine_name'])
	initMenuBar()
	initDock()
	startFinder()
	clock:Draw()
	Login:quit()
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

	OSInterfaceEntities.add(OSMenuBar:new())
	OSInterfaceEntities.add(clock)
	OSInterfaceEntities.add(menu)
end

function initDock()
	local dockItems = {}
	table.insert(dockItems, OSDockItem:new("System/Applications/Finder.app"))
	local applicationsPath = "Applications/"
	for _,name in ipairs(OSSettings['users'][OSCurrentUser]['dock_items']) do
		table.insert(dockItems, OSDockItem:new(applicationsPath..name))
	end
	dock = OSDock:new(dockItems)
	OSInterfaceEntities.add(dock)
end

function startFinder()
	Finder = OSApplication:load("System/Applications/Finder.app")
	OSApplication.run(Finder)
end

function init()
	os.setComputerLabel(nil)
	term.setTextColour(colours.white)

	--add Macintosh command keys because computercraft doesn't have them in the keys api *cough* cloudy & dan200, add them *cough*
	keys[219] = "leftCommand"
	keys[220] = "rightCommand"
	--this isn't working, it is implimented manually when needed

	if fs.exists("/Home/Settings.cfg") then
		OSSettings = OSTableIO.load("/Home/Settings.cfg")
		include("System/Library/Frameworks")
		LoginWindow()
	else
		firstRun()
	end

	OSUpdate()
	OSEvents.EventHandler()
end

LoginWindow = function()
	desktop = OSDesktop:new()
	OSFirstRunMode = true
	Login = OSApplication:load("System/Applications/Login.app")
	OSApplication.run(Login)
end

function firstRun()
	include("System/Library/Frameworks")
	OSFirstRunMode = true
	desktop = OSDesktop:new()
	FirstRun = OSApplication:load("System/Applications/FirstRun.app")
	OSApplication.run(FirstRun)
end