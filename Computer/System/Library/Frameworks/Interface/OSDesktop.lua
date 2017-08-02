--OSDesktop--

	__index = OSEntity

	objtype = ""
	BackgroundColour = OSSettings['desktop_bg']

	x = 1
	y = 1
	width = 51
	height = 19

	Draw = function (self, darkMode)
		OSDrawing.DrawBlankArea(1, 1, OSDrawing.Screen.Width, OSDrawing.Screen.Height, self.BackgroundColour)--OSSettings['desktop_bg'])
	end
	
	new = function(self)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSDesktop} ) -- copy an instance of OSDesktop
		return new
	end

	action = function()
		OSServices.hideAllMenus()
	end
