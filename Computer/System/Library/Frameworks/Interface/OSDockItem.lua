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
		return new
	end

	newMinimise = function(self, _window)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSDockItem} ) -- copy an instance of OSMenuItem
		new.icon = paintutils.loadImage("System/Library/Interface/minimise")
		new.action = function()
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
		local application = OSApplication:load(self.path)
		OSApplication.run(application)
	end