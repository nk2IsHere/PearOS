--OSDockItem--

	__index = OSMenuItem -- parent class

	objtype = "OSDockItem"
	width = 3
	height = 2
	x = 0
	y = 0
	icon = nil
	path = nil
	applicationName = nil
	IndicatorColour = colours.white
	Indicator = "*"

	new = function(self, _path)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSDockItem} ) -- copy an instance of OSMenuItem
		new.icon = paintutils.loadImage(_path.."/icon")
		new.path = _path
		new.applicationName = OSFileSystem.shortName(_path)
		new.application = OSApplication:load(_path)
		return new
	end

	newMinimise = function(self, _window)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSDockItem} ) -- copy an instance of OSMenuItem
		new.icon = paintutils.loadImage("System/Library/Interface/minimise")
		new.action = function()
			_window:restore()
		end
		new.context = function()
			_window:restore()
		end
		return new
	end

	Draw = function(self, darkMode)
		OSDrawing.DrawImage(self.x, self.y, self.icon)
		--draw the indicator if the application is open
		if OSInterfaceApplications.list[self.applicationName] then
			if not darkMode then OSDrawing.DrawCharacters(self.x + 1, self.y+ 2, self.Indicator, self.IndicatorColour, OSDock.BackgroundColour)
			else OSDrawing.DrawCharacters(self.x + 1, self.y+ 2, self.Indicator, self.IndicatorColour, OSDock.BackgroundColourDark) end
		end
	end

	action = function(self)
		OSApplication.run(self.application)
	end

	context = function(self, x, y)
		OSInterfaceEntities.add(OSContextMenu:new(self.x+x, 14, "", {
			OSMenuItem:new("Open app", function() OSApplication.run(self.application) end, nil),
			OSMenuItem:new("Close app", function() 
				OSApplication.quit(self.application)
			end, nil)
		}))
	end