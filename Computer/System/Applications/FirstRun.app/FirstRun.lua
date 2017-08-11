
	name = "FirstRun"
	menus = {}
	windows = {}
	version = "1.0"
	
	firstTime = nil --if the user has used pearos before
	
	init = function(self)
    		self:firstRun()
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
			nameTextBox = OSTextField:new(13,10,21,"")
			nameTextBox.BackgroundColour = colours.lightGrey
			
			firstRunWindow.entities = {
				OSButton:new(3,15 ,"Back", function() self:changePage(1) end),
				OSLabel:new(3,2 ,"What's your name?"),
				OSHSplitter:new(1, 3, 47, true),
				OSLabel:new(3,5 ,"Click on the grey box and enter your name."),
    			nameTextBox,
				OSButton:new(39,15 ,"Next", function() if #nameTextBox.text > 0 then setName(nameTextBox.text) self:changePage(8) end end)
				
			}
		elseif page == 8 then  		--clean setup start
			OSSelectedEntity = nil
			
			startX = 13
			startY = 9
			
			local orange = OSButton:new(startX, startY," ", function(self) setDesktopBackground(colours.orange) end)
			orange.BackgroundColour = colours.orange
			orange.SelectedBackgroundColour = colours.orange
			
			local magenta = OSButton:new(startX + 4, startY," ", function() setDesktopBackground(colours.magenta) end)
			magenta.BackgroundColour = colours.magenta
			magenta.SelectedBackgroundColour = colours.magenta
			
			local lightBlue = OSButton:new(startX + 8, startY," ", function() setDesktopBackground(colours.lightBlue) end)
			lightBlue.BackgroundColour = colours.lightBlue
			lightBlue.SelectedBackgroundColour = colours.lightBlue
			
			local yellow = OSButton:new(startX + 12, startY," ", function() setDesktopBackground(colours.yellow) end)
			yellow.BackgroundColour = colours.yellow
			yellow.SelectedBackgroundColour = colours.yellow
			
			local lime = OSButton:new(startX + 16, startY," ", function() setDesktopBackground(colours.lime) end)
			lime.BackgroundColour = colours.lime
			lime.SelectedBackgroundColour = colours.lime
			
			local pink = OSButton:new(startX + 20, startY," ", function() setDesktopBackground(colours.pink) end)
			pink.BackgroundColour = colours.pink
			pink.SelectedBackgroundColour = colours.pink
			
			local grey = OSButton:new(startX, startY + 2," ", function() setDesktopBackground(colours.grey) end)
			grey.BackgroundColour = colours.grey
			grey.SelectedBackgroundColour = colours.grey
			
			local cyan = OSButton:new(startX + 4, startY + 2," ", function() setDesktopBackground(colours.cyan) end)
			cyan.BackgroundColour = colours.cyan
			cyan.SelectedBackgroundColour = colours.cyan
			
			local purple = OSButton:new(startX + 8, startY + 2," ", function() setDesktopBackground(colours.purple) end)
			purple.BackgroundColour = colours.purple
			purple.SelectedBackgroundColour = colours.purple
			
			local blue = OSButton:new(startX + 12, startY + 2," ", function() setDesktopBackground(colours.blue) end)
			blue.BackgroundColour = colours.blue
			blue.SelectedBackgroundColour = colours.blue
			
			local brown = OSButton:new(startX + 16, startY + 2," ", function() setDesktopBackground(colours.brown) end)
			brown.BackgroundColour = colours.brown
			brown.SelectedBackgroundColour = colours.brown
			
			local red = OSButton:new(startX + 20, startY + 2," ", function() setDesktopBackground(colours.red) end)
			red.BackgroundColour = colours.red
			red.SelectedBackgroundColour = colours.red
			
			
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
		OSSettings['updates_enabled'] = updates
	end
	
	setName = function(name)
		OSSettings['user_name'] = name
		OSSettings['machine_name'] = name.."'s Computer"
	end
	
	saveSettings = function()
		OSChangeSetting('desktop_bg', desktopBackground, true)
		OSTableIO.save(OSSettings,"Home/Settings.cfg")
	end