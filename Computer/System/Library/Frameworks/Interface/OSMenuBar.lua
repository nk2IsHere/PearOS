--OSMenuBar--
 
	x = 1
	y = 1
	width = 1
	height = 1
	action = nil

	objtype = "OSMenuBar"
	BackgroundColour = colours.white
	BackgroundColourDark = colours.black
	TextColour = colours.black
	TextColourDark = colours.white
	SelectedBackgroundColour = colours.lightBlue
	SelectedBackgroundColourDark = colours.orange
	SelectedTextColour = colours.white
	SelectedTextColourDark = colours.white
	
	new = function(self)
		local w, h = term.getSize()
		self.width = w
		return self
	end
	
	Draw = function (self, darkMode)
		if not darkMode then
			OSDrawing.DrawBlankArea(self.x, self.y, self.width, self.height, self.BackgroundColour)
		else
			OSDrawing.DrawBlankArea(self.x, self.y, self.width, self.height, self.BackgroundColourDark)
		end
	end
