--OSSwitch--

	__index = OSControl

	objtype = "OSSwitch"
	TextColour = colours.black
	TextColourDark = colours.white
	BackgroundColour = colours.white
	BackgroundColourDark = colours.grey

	OnTextColour = colours.white
	OnTextColourDark = colours.white
	OnBackgroundColour = colours.lightGrey 
	OnBackgroundColourDark = colours.orange
	OnSecBackgroundColour = colours.lightBlue
	OnSecBackgroundColourDark = colours.black
	OffBackgroundColour = colours.grey
	OffBackgroundColourDark = colours.black

	valueChangedAction = nil
	state = false
	new = function(self, _x, _y, _title, _state, _valueChangedAction)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSSwitch} ) -- copy an instance of OSMenuItem

		new.width = string.len(_title)+2
		new.height = 1
		new.x = _x
		new.y = _y
		new.title = _title
		new.state = _state
		new.valueChangedAction = _valueChangedAction
		new.action = _action
		new.enabled = true
		return new
	end


	action = function(self)
		self.state = not self.state
		self.valueChangedAction()
	end

	Draw = function(self, darkMode)
		local textColour = colours.white
		if not darkMode then
			if self.state then
				OSDrawing.DrawCharacters(self.x, self.y, " ", textColour, self.OnSecBackgroundColour)
				OSDrawing.DrawCharacters(self.x+1, self.y, " o", textColour, self.OnBackgroundColour)
			else
				OSDrawing.DrawCharacters(self.x, self.y, "o ", textColour, self.OnBackgroundColour)
				OSDrawing.DrawCharacters(self.x+2, self.y, " ", textColour, self.OffBackgroundColour)
			end

			OSDrawing.DrawCharacters(self.x+4,self.y, self.title, self.TextColour, self.BackgroundColour)
		else
			textColour = colours.white
			if self.state then
				OSDrawing.DrawCharacters(self.x, self.y, " ", textColour, self.OnSecBackgroundColourDark)
				OSDrawing.DrawCharacters(self.x+1, self.y, " o", textColour, self.OnBackgroundColourDark)
			else
				OSDrawing.DrawCharacters(self.x, self.y, "o ", textColour, self.OnBackgroundColourDark)
				OSDrawing.DrawCharacters(self.x+2, self.y, " ", textColour, self.OffBackgroundColourDark)
			end

			OSDrawing.DrawCharacters(self.x+4,self.y, self.title, self.TextColourDark, self.BackgroundColourDark)
		end

	end