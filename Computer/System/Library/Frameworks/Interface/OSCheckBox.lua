--OSCheckBox--

	__index = OSControl

	objtype = "OSCheckBox"
	TextColour = colours.black
	TextColourDark = colours.white
	BackgroundColour = colours.white
	BackgroundColourDark = colours.grey

	OnBackgroundColour = colours.lightGrey
	OnBackgroundColourDark = colours.orange
	OffBackgroundColour = colours.lightGrey
	OffBackgroundColourDark = colours.black
	OnTextColour = colours.white
	OnTextColourDark = colours.white

	valueChangedAction = nil
	state = false
	new = function(self, _x, _y, _title, _state, _valueChangedAction)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSCheckBox} ) -- copy an instance of OSMenuItem

		new.width = string.len(_title)+2
		new.height = 1
		new.x = _x
		new.y = _y
		new.title = _title
		new.state = _state
		new.valueChangedAction = _valueChangedAction
		new.action = _action
		return new
	end


	action = function(self)
		self.state = not self.state
		self.valueChangedAction()
	end

	Draw = function(self, darkMode)
		local bgColour = colors.black
		local textColour = TextColour
		local check = "x"

		if not darkMode then
			if self.state then
				bgColour = self.OnBackgroundColour
				textColour = self.OnTextColour
			else
				bgColour = self.OffBackgroundColour
				check = " "
			end
		else
			textColour = TextColourDark
			if self.state then
				bgColour = self.OnBackgroundColourDark
				textColour = self.OnTextColourDark
			else
				bgColour = self.OffBackgroundColourDark
				check = " "
			end
		end

		OSDrawing.DrawCharacters(self.x,self.y, check, textColour, bgColour)
		if not darkMode then OSDrawing.DrawCharacters(self.x+2,self.y, self.title, self.TextColour, self.BackgroundColour)
			else OSDrawing.DrawCharacters(self.x+2,self.y, self.title, self.TextColourDark, self.BackgroundColourDark) end
	end