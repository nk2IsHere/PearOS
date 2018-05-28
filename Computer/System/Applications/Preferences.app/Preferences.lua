
	name = "Preferences"
	menus = {}
	windows = {}
	version = "0.2"
	showHidden = false
	id = 0
	author = "Oliver'oeed'Cooper"
	
	init = function()
    		menus = {}
    		systemPreferences()
	end
	
	about = function()
		windows['about'] = OSAboutWindow:new(name, version, author, path, environment)
	end

	systemPreferences = function()
		
		local settingsListView = OSListView:new(1, 2, 17, 14, {
			OSListItem:new("General", function()switchCategory('General')end),
			OSListItem:new("Appearance", function()switchCategory('Appearance')end),
			OSListItem:new("Dock Items", function()switchCategory('Dock Items')end),
			OSListItem:new("User", function()switchCategory('User')end),
		})
				
		categoryLabel = OSLabel:new(20,2 ,"General")
		settingsContainer = OSContainer:new(19, 4, 28, 11, {})
		switchCategory('General')--start category
		local systemPreferencesWindow = OSWindow:new(name, {
			settingsListView,
			OSVSplitter:new(18, 1, 14, false),
			OSHSplitter:new(19, 3, 27, true),
			categoryLabel,
			settingsContainer
			
		}, 45,14, environment)
		systemPreferencesWindow.canMaximise = false
		
		environment.windows['systemPreferences'] = systemPreferencesWindow
	end
	
	setDesktopBackground = function(colour)
		local settings = OSTableIO.load("/Home/Settings.cfg")
		settings['users'][OSCurrentUser]['desktop_bg'] = colour
		OSTableIO.save(settings,"/Home/Settings.cfg")
		OSReloadSettings() 
	end
	
	switchCategory = function(category)
		categoryLabel.title = category
		if category == 'Appearance' then
			
			startX = 2
			startY = 3
			
			local orange = OSButton:new(startX, startY," ", function() setDesktopBackground(colours.orange) end)
			orange.BackgroundColour = colours.orange
			orange.BackgroundColourDark = colours.orange
			orange.SelectedBackgroundColour = colours.orange
			orange.SelectedBackgroundColourDark = colours.orange

			local magenta = OSButton:new(startX + 4, startY," ", function()setDesktopBackground(colours.magenta) end)
			magenta.BackgroundColour = colours.magenta
			magenta.BackgroundColourDark = colours.magenta
			magenta.SelectedBackgroundColour = colours.magenta
			magenta.SelectedBackgroundColourDark = colours.magenta
			
			local lightBlue = OSButton:new(startX + 8, startY," ", function() setDesktopBackground(colours.lightBlue) end)
			lightBlue.BackgroundColour = colours.lightBlue
			lightBlue.BackgroundColourDark = colours.lightBlue
			lightBlue.SelectedBackgroundColour = colours.lightBlue
			lightBlue.SelectedBackgroundColourDark = colours.lightBlue

			local yellow = OSButton:new(startX + 12, startY," ", function() setDesktopBackground(colours.yellow) end)
			yellow.BackgroundColour = colours.yellow
			yellow.BackgroundColourDark = colours.yellow
			yellow.SelectedBackgroundColour = colours.yellow
			yellow.SelectedBackgroundColourDark = colours.yellow
			
			local lime = OSButton:new(startX + 16, startY," ", function() setDesktopBackground(colours.lime) end)
			lime.BackgroundColour = colours.lime
			lime.BackgroundColourDark = colours.lime
			lime.SelectedBackgroundColour = colours.lime
			lime.SelectedBackgroundColourDark = colours.lime
			
			local pink = OSButton:new(startX + 20, startY," ", function() setDesktopBackground(colours.pink) end)
			pink.BackgroundColour = colours.pink
			pink.BackgroundColourDark = colours.pink
			pink.SelectedBackgroundColour = colours.pink
			pink.SelectedBackgroundColourDark = colours.pink
			
			local grey = OSButton:new(startX, startY + 2," ", function() setDesktopBackground(colours.grey) end)
			grey.BackgroundColour = colours.grey
			grey.BackgroundColourDark = colours.grey
			grey.SelectedBackgroundColour = colours.grey
			grey.SelectedBackgroundColourDark = colours.grey
			
			local cyan = OSButton:new(startX + 4, startY + 2," ", function() setDesktopBackground(colours.cyan) end)
			cyan.BackgroundColour = colours.cyan
			cyan.BackgroundColourDark = colours.cyan
			cyan.SelectedBackgroundColour = colours.cyan
			cyan.SelectedBackgroundColourDark = colours.cyan
			
			local purple = OSButton:new(startX + 8, startY + 2," ", function() setDesktopBackground(colours.purple) end)
			purple.BackgroundColour = colours.purple
			purple.BackgroundColourDark = colours.purple
			purple.SelectedBackgroundColour = colours.purple
			purple.SelectedBackgroundColourDark = colours.purple
			
			local blue = OSButton:new(startX + 12, startY + 2," ", function() setDesktopBackground(colours.blue) end)
			blue.BackgroundColour = colours.blue
			blue.BackgroundColourDark = colours.blue
			blue.SelectedBackgroundColour = colours.blue
			blue.SelectedBackgroundColourDark = colours.blue
			
			local brown = OSButton:new(startX + 16, startY + 2," ", function() setDesktopBackground(colours.brown) end)
			brown.BackgroundColour = colours.brown
			brown.BackgroundColourDark = colours.brown
			brown.SelectedBackgroundColour = colours.brown
			brown.SelectedBackgroundColourDark = colours.brown
			
			local red = OSButton:new(startX + 20, startY + 2," ", function() setDesktopBackground(colours.red) end)
			red.BackgroundColour = colours.red
			red.BackgroundColourDark = colours.red
			red.SelectedBackgroundColour = colours.red
			red.SelectedBackgroundColourDark = colours.red
			
			local settings = OSTableIO.load("/Home/Settings.cfg")
			local switch = OSSwitch:new(2, 7, "Dark Mode", OSDrawing.GetMode(), function() 
				settings['users'][OSCurrentUser]["dark_mode"] = not OSDrawing.GetMode() 
				OSTableIO.save(settings,"/Home/Settings.cfg")
				OSDrawing.SetMode(settings['users'][OSCurrentUser]["dark_mode"])
			end)

			settingsContainer.entities = {
				OSLabel:new(2, 1, "Desktop Background"),
				switch,
				orange,
				magenta,
				lightBlue,
				backButton,
				yellow,
				lime,
				pink,
				grey,
				cyan,
				purple,
				blue,
				brown,
				green,
				red
			}
		elseif category == 'General' then
			local settings = OSTableIO.load("/Home/Settings.cfg")

			computerField = OSTextField:new(2, 3, 25, os.getComputerLabel(), function() 
				os.setComputerLabel(computerField.text)
				settings['users'][OSCurrentUser]['machine_name'] = computerField.text
				OSTableIO.save(settings,"/Home/Settings.cfg")
			end)
			computerField.BackgroundColour = colours.lightGrey

			verboseCheckBox = OSCheckBox:new(2, 7, "Verbose", settings["boot_arg"] == 47, function() 
				disableMonitorCheckBox.state = false
				dontBootPearOSCheckBox.state = false
				none.state = false
				settings["boot_arg"] = 47
				OSTableIO.save(settings,"/Home/Settings.cfg")
			end)
			disableMonitorCheckBox = OSCheckBox:new(12, 7, "Off Monitor", settings["boot_arg"] == 50, function()
				verboseCheckBox.state = false
				dontBootPearOSCheckBox.state = false
				none.state = false
				settings["boot_arg"] = 50
				OSTableIO.save(settings,"/Home/Settings.cfg")
			end)
			dontBootPearOSCheckBox = OSCheckBox:new(2, 9, "Don't boot OS", settings["boot_arg"] == 46, function()
				verboseCheckBox.state = false
				disableMonitorCheckBox.state = false
				none.state = false
				settings["boot_arg"] = 46
				OSTableIO.save(settings,"/Home/Settings.cfg")
			end)
			none = OSCheckBox:new(18, 9, "None", settings["boot_arg"] == nil, function()
				verboseCheckBox.state = false
				disableMonitorCheckBox.state = false
				dontBootPearOSCheckBox.state = false
				settings["boot_arg"] = nil
				OSTableIO.save(settings,"/Home/Settings.cfg")
			end)

			settingsContainer.entities = {
				OSLabel:new(2, 1, "Change your computer name"),
				computerField,
				OSLabel:new(2, 5, "Boot Option"),
				verboseCheckBox,
				disableMonitorCheckBox,
				dontBootPearOSCheckBox,
				none
			}
		elseif category == 'User' then
			local name = OSTextField:new(7, 1, 19, OSCurrentUser)
			name.submit = function()
				if name.text ~= "" and name.text ~= nil then 
					local currentUserSettings = table.shallow_copy(OSSettings['users'][OSCurrentUser])
					local settings = OSTableIO.load("/Home/Settings.cfg")
					settings['users'][OSCurrentUser] = nil
					settings['users'][name.text] = currentUserSettings
					OSFileSystem.move("/Home/"..OSCurrentUser, "/Home/"..name.text)
					SetCurrentUser(name.text)
					OSTableIO.save(settings,"/Home/Settings.cfg")
					windows['warning'] = OSWarningWindow:new("Name reset", {"Name changed!", "Reboot needed"}, "OK", function() os.reboot() end, environment)
				end
				OSReloadSettins()
			end

			local old = OSTextField:new(6, 6, 20, "")
			local new = OSTextField:new(6, 8, 20, "")

			settingsContainer.entities = {
				OSLabel:new(2, 1, "Name:"),
				name,
				OSLabel:new(2, 4, "Change password"),
				OSLabel:new(2, 6, "Old:"),
				old,
				OSLabel:new(2, 8, "New:"),
				new,
				OSButton:new(19, 10, "Change", function() 
					if OSSettings['users'][OSCurrentUser]['password'] == OSSha1.sha1(old.text) then
						local settings = OSTableIO.load("Home/Settings.cfg")
						settings['users'][OSCurrentUser]['password'] = OSSha1.sha1(new.text)
						OSTableIO.save(settings,"/Home/Settings.cfg")
						OSReloadSettings() 
						windows['warning'] = OSWarningWindow:new("Password reset", {"Password changed!"}, "OK", function() windows['warning'] = nil end, environment)
					else
						windows['error'] = OSErrorWindow:new("Password reset", {"Wrong password!"}, "OK", function() windows['error'] = nil end, environment)
					 end
				end)
			}
		elseif category == 'Dock Items' then
			local dockItemList = OSListView:new(2, 1, 27, 11, {})

			settingsContainer.entities = {
				dockItemList
			}
			local startY = 1
			local applicationsPath = "/Applications/"

			local settings = OSTableIO.load("/Home/Settings.cfg")
			for _,v in pairs(OSFileSystem.list("Applications")) do
				if OSFileSystem.hasExtention(v) then
					local switch = OSSwitch:new(2, startY, v, findInTable(settings['users'][OSCurrentUser].dock_items, v), function()
						if findInTable(settings['users'][OSCurrentUser].dock_items, v) then
							OSServices.removeTableItem(settings['users'][OSCurrentUser].dock_items, v)
							OSDock:remove(findDockItem(applicationsPath..v))
						else
							table.insert(settings['users'][OSCurrentUser].dock_items, v)
							OSDock:add(OSDockItem:new(applicationsPath..v))
						end
						OSTableIO.save(settings,"/Home/Settings.cfg")
					end)

					table.insert(dockItemList.items, switch)
					startY = startY + 2
				end
			end
		else error('impossible category')	
		end
	end

	findInTable = function (_table, _value)
		for k,v in pairs(_table) do
			if v == _value then return true end
		end
		return false
	end

	findDockItem = function(_path)
		for _,item in pairs(OSDock.items) do
			for _,v in pairs(item) do
				if v == _path then return item end
			end
		end
	end

	function windowDidClose(self)
		environment:quit()
	end

	windowDidResize = function(window, _width, _height)
		return
	end
		