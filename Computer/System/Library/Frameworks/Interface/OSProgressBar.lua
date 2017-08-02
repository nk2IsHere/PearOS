--OSProgressBar--
 
	__index = OSControl

	objtype = "OSProgressBar"
	value = 0
	BackgroundColour = colours.white
	BackgroundColourDark = colours.grey
	ProgressBackgroundColour = colours.lightBlue
	ProgressBackgroundColourDark = colours.orange

	new = function(self, _x, _y, _width, _value)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSProgressBar} ) -- copy an instance of OSMenuItem
		new.width = _width
		new.height = 1
		new.x = _x
		new.y = _y
		new.value = _value
		return new
	end

	Draw = function(self, darkMode)
		if self.value > 100 then self.value = 0 end --prevent value from going above 100 percent
		local progressEnd = OSServices.round(((self.value)/100)*self.width)
		if not darkMode then
			OSDrawing.DrawBlankArea(self.x, self.y, progressEnd, self.height, self.ProgressBackgroundColour)
			OSDrawing.DrawBlankArea(self.x + progressEnd, self.y, self.width - progressEnd, self.height, self.BackgroundColour)
		else
			OSDrawing.DrawBlankArea(self.x, self.y, progressEnd, self.height, self.ProgressBackgroundColourDark)
			OSDrawing.DrawBlankArea(self.x + progressEnd, self.y, self.width - progressEnd, self.height, self.BackgroundColourDark)
		end
	end