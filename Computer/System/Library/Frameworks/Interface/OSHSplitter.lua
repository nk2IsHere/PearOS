--OSHSplitter--

	__index = OSControl
	objtype = "OSHSplitter"

	character = "-"	
	TextColour = colours.grey
	TextColourDark = colours.white
	BackgroundColour = colours.white
	BackgroundColourDark = colours.grey

	new = function(self, _x, _y, _length)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSHSplitter} )
		new.width = _length
		new.height = 1
		new.x = _x
		new.y = _y
		new.enabled = true
		return new
	end

	Draw = function(self, darkMode)
		if not darkMode then	
			OSDrawing.DrawArea(self.x, self.y, self.width, self.height, self.character, self.BackgroundColour, self.TextColour)
		else
			OSDrawing.DrawArea(self.x, self.y, self.width, self.height, self.character, self.BackgroundColourDark, self.TextColourDark)
		end
	end