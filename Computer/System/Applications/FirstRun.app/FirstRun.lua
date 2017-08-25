
	name = "FirstRun"
	menus = {}
	windows = {}
	version = "1.0"
	OSCurrentUser = nil
	
	firstTime = nil --if the user has used pearos before
	
	init = function()
    	firstRun(environment)
	end
	

	firstRun = function(self)
		firstRunWindow = OSWindow:new("", {
			
		}, 47,16, self)
		firstRunWindow.x = 3
		firstRunWindow.y = 1
		firstRunWindow.canMaximise = false
		--firstRunWindow.canClose = false
		--firstRunWindow.FocusFrameColour = colours.white
		firstRunWindow.hasFrame = false
		self:changePage(1)
		self.windows['firstRun'] = firstRunWindow
	end	
	
	changePage = function(self, page)
		if page == 1 then
			firstRunWindow.entities = {
				OSButton:new(3,15 ,"Shutdown", function() os.shutdown() end),
				OSLabel:new(3,2 ,"Welcome to PearOS"),
				OSHSplitter:new(1, 3, 47, true),
				OSLabel:new(3,5 ,"This guide will help you get up and"),
				OSLabel:new(3,6 ,"running as quick as possible."),
				OSLabel:new(3,8 ,"To continue, click 'Next'"),
				OSButton:new(39,15 ,"Next", function() self:changePage(7) end)
			}
		elseif page == 7 then  		--clean setup start
			nameTextBox = OSTextField:new(20,8,18,"")
			pwdTextBox = OSTextField:new(20,10,18,"")
			
			firstRunWindow.entities = {
				OSButton:new(3,15 ,"Back", function() self:changePage(1) end),
				OSLabel:new(3,2 ,"About yourself"),
				OSHSplitter:new(1, 3, 47, true),
				OSLabel:new(3,5 ,"Click on the grey box and enter your cred's"),
				OSLabel:new(10, 8, "Login:"), nameTextBox,
				OSLabel:new(10, 10, "Password:"), pwdTextBox,
				OSButton:new(39,15 ,"Next", function() if (#nameTextBox.text > 0) and (#pwdTextBox.text > 0) then setName(nameTextBox.text, pwdTextBox.text) OSLog("LEL") self:changePage(8) end end)
				
			}
		elseif page == 8 then  		--clean setup start
			OSSelectedEntity = nil
			
			startX = 13
			startY = 9
			
			local orange = OSButton:new(startX, startY," ", function(self) setDesktopBackground(colours.orange) end)
			orange.BackgroundColour = colours.orange
			orange.SelectedBackgroundColour = colours.orange
			orange.BackgroundColourDark = colours.orange
			orange.SelectedBackgroundColourDark = colours.orange
			
			local magenta = OSButton:new(startX + 4, startY," ", function() setDesktopBackground(colours.magenta) end)
			magenta.BackgroundColour = colours.magenta
			magenta.SelectedBackgroundColour = colours.magenta
			magenta.BackgroundColourDark = colours.magenta
			magenta.SelectedBackgroundColourDark = colours.magenta
			
			local lightBlue = OSButton:new(startX + 8, startY," ", function() setDesktopBackground(colours.lightBlue) end)
			lightBlue.BackgroundColour = colours.lightBlue
			lightBlue.SelectedBackgroundColour = colours.lightBlue
			lightBlue.BackgroundColourDark = colours.lightBlue
			lightBlue.SelectedBackgroundColourDark = colours.lightBlue
			
			local yellow = OSButton:new(startX + 12, startY," ", function() setDesktopBackground(colours.yellow) end)
			yellow.BackgroundColour = colours.yellow
			yellow.SelectedBackgroundColour = colours.yellow
			yellow.BackgroundColourDark = colours.yellow
			yellow.SelectedBackgroundColourDark = colours.yellow
			
			local lime = OSButton:new(startX + 16, startY," ", function() setDesktopBackground(colours.lime) end)
			lime.BackgroundColour = colours.lime
			lime.SelectedBackgroundColour = colours.lime
			lime.BackgroundColourDark = colours.lime
			lime.SelectedBackgroundColourDark = colours.lime
			
			local pink = OSButton:new(startX + 20, startY," ", function() setDesktopBackground(colours.pink) end)
			pink.BackgroundColour = colours.pink
			pink.SelectedBackgroundColour = colours.pink
			pink.BackgroundColourDark = colours.pink
			pink.SelectedBackgroundColourDark = colours.pink
			
			local grey = OSButton:new(startX, startY + 2," ", function() setDesktopBackground(colours.grey) end)
			grey.BackgroundColour = colours.grey
			grey.SelectedBackgroundColour = colours.grey
			grey.BackgroundColourDark = colours.grey
			grey.SelectedBackgroundColourDark = colours.grey
			
			local cyan = OSButton:new(startX + 4, startY + 2," ", function() setDesktopBackground(colours.cyan) end)
			cyan.BackgroundColour = colours.cyan
			cyan.SelectedBackgroundColour = colours.cyan
			cyan.BackgroundColourDark = colours.cyan
			cyan.SelectedBackgroundColourDark = colours.cyan
			
			local purple = OSButton:new(startX + 8, startY + 2," ", function() setDesktopBackground(colours.purple) end)
			purple.BackgroundColour = colours.purple
			purple.SelectedBackgroundColour = colours.purple
			purple.BackgroundColourDark = colours.purple
			purple.SelectedBackgroundColourDark = colours.purple
			
			local blue = OSButton:new(startX + 12, startY + 2," ", function() setDesktopBackground(colours.blue) end)
			blue.BackgroundColour = colours.blue
			blue.SelectedBackgroundColour = colours.blue
			blue.BackgroundColourDark = colours.blue
			blue.SelectedBackgroundColourDark = colours.blue
			
			local brown = OSButton:new(startX + 16, startY + 2," ", function() setDesktopBackground(colours.brown) end)
			brown.BackgroundColour = colours.brown
			brown.SelectedBackgroundColour = colours.brown
			brown.BackgroundColourDark = colours.brown
			brown.SelectedBackgroundColourDark = colours.brown
			
			local red = OSButton:new(startX + 20, startY + 2," ", function() setDesktopBackground(colours.red) end)
			red.BackgroundColour = colours.red
			red.SelectedBackgroundColour = colours.red
			red.BackgroundColourDark = colours.red
			red.SelectedBackgroundColourDark = colours.red
			
			local mode = OSSwitch:new(startX, startY+4, "Dark Mode", false, nil)
			mode.valueChangedAction = function() setMode(mode.state) end
			
			firstRunWindow.entities = {
				OSButton:new(3,15 ,"Back", function() self:changePage(2) end),
				OSLabel:new(3,2 ,"Desktop Background"),
				OSHSplitter:new(1, 3, 47, true),
				OSLabel:new(3,5 ,"Choose a desktop background colour by"),
				OSLabel:new(3,6 ,"clicking on a coloured box, you can"),
				OSLabel:new(3,7 ,"change this again in System Preferences."),
				orange,
				magenta,
				lightBlue,
				yellow,
				lime,
				pink,
				grey,
				cyan,
				purple,
				blue,
				brown,
				green,
				red,
				mode,
				OSButton:new(39,15 ,"Next", function() self:changePage(10) end)				
			}
			
		elseif page == 9 then
			firstRunWindow.entities = {
				OSButton:new(3,15 ,"Back", function() self:changePage(page - 1) end),
				OSLabel:new(3,2 ,"Automatic updates?"),
				OSHSplitter:new(1, 3, 47, true),
				OSLabel:new(3, 5 ,"Do you want to enabled automatic updates?"),
				OSLabel:new(3, 7 ,"If enabled, PearOS will update it self to"),
				OSLabel:new(3, 8 ,"the latest version when ever possible."),
				OSLabel:new(3, 10,"However, this requires the 'http' API"),
				OSLabel:new(3, 11,"to be enabled. (current ".. (http and "enabled" or "not enabled") ..")."),

				OSButton:new(35,15 ,"Yes", function() setUpdates(true) self:changePage(10) end),
				OSButton:new(41,15 ,"No", function() setUpdates(false) self:changePage(10) end)
				
			}
		elseif page == 10 then
			setUpdates(false)
			firstRunWindow.entities = {
				OSButton:new(3,15 ,"Back", function() self:changePage(page - 1) end),
				OSLabel:new(3,2 ,"All Done!"),
				OSHSplitter:new(1, 3, 47, true),
				OSLabel:new(3, 5 ,"PearOS setup is complete!"),
				OSLabel:new(3, 7 ,"To begin using PearOS click 'Restart'"),

				OSButton:new(36,15 ,"Restart", function() saveSettings() os.reboot() end),
				
			}
		end
	end
		
	desktopBackground = colours.grey	
	setDesktopBackground = function(colour)
		desktopBackground = colour

		desktop.BackgroundColour = colour
		desktop:Draw()
	end

	setUpdates = function(updates)
		OSSettings['users'][OSCurrentUser]['updates_enabled'] = updates
	end
	
	setName = function(name, password)
		OSCurrentUser = name
		OSSettings['users'] = {} OSSettings['users'][name] = {} 
		OSSettings['users'][name]['dock_items'] = {} OSSettings['users'][name]['extension_associations'] = {}

		OSSettings['users'][name]['password'] = OSSha1.sha1(password)
		OSSettings['users'][name]['machine_name'] = name.."'s Computer"
	end
	
	setMode = function(mode)
		OSDrawing.SetMode(mode)
		OSSettings['users'][OSCurrentUser]['dark_mode'] = mode
	end

	saveSettings = function()
		fs.makeDir("/Home/"..OSCurrentUser)
		OSSettings['users'][OSCurrentUser]['desktop_bg'] = desktopBackground
		OSTableIO.save(OSSettings,"Home/Settings.cfg")
	end