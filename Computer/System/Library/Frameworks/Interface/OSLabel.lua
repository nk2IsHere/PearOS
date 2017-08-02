--OSLabel--
	__index = OSControl
	
	objtype = "OSLabel"

	TextColour = colours.black
	TextColourDark = colours.white
	DisabledTextColour = colours.grey
	DisabledTextColourDark = colours.lightGrey
	BackgroundColour = colours.white
	BackgroundColourDark = colours.grey

	new = function(self, _x, _y, _title)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSLabel} )
		new.width = string.len(_title)
		new.height = 1
		new.x = _x
		new.y = _y
		new.title = _title
		new.enabled = true
		return new
	end

	Draw = function(self, darkMode)
		local textColour = self.TextColour
		local bgColour = self.BackgroundColour
		if not self.enabled then
			textColour = self.DisabledTextColour
		end
		if darkMode then
			textColour = self.TextColourDark
			bgColour = self.BackgroundColourDark
		end
		OSDrawing.DrawCharacters(self.x,self.y, self.title, textColour, bgColour)
	end

	action = function()end