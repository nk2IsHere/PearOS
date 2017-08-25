--OSTextField--

	__index = OSControl
	objtype = "OSTextField"

	text = ""
	Selection = {0,0} --start character, end character
	CursorPosition = 0
	Blink = false  --whether the blinking character should be shown
	BlinkCharacter = "|"
	Offset = 0 --the amount of characters hidden
	MoveDirection = 0
	submit = nil

	TextColour = colours.black
	TextColourDark = colours.white
	SelectedTextColour = colours.lightBlue
	SelectedTextColourDark = colours.orange
	BackgroundColour = colours.lightGrey
	BackgroundColourDark = colours.black

	new = function(self, _x, _y, _width, _text, _submit)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSTextField} )
		new.width = _width
		new.height = 1
		new.x = _x
		new.y = _y
		new.text = _text
		if _submit == nil then
			new.submit = function() end
		else
			new.submit = _submit
		end
		return new
	end

	Draw = function(self, darkMode)
		if OSSelectedEntity ~= self then --update selection
			self.Blink = false
		end

		local textColour = self.TextColour
		local backgroundColour = self.BackgroundColour
		if darkMode then
			textColour = self.TextColourDark
			backgroundColour = self.BackgroundColourDark
		end

		OSDrawing.DrawBlankArea(self.x, self.y, self.width, self.height, backgroundColour)

		if #self.text < self.width - 1 then
			self.Offset = 0
			--the text box text is shorter that the maximum
			OSDrawing.DrawCharacters(self.x + 1, self.y, self.text, textColour, backgroundColour)
		else
			self.Offset = #self.text - self.width + 2
			if self.CursorPosition <= self.Offset then

				self:moveCursor(-1)
				self.Offset = self.CursorPosition

			end
			OSDrawing.DrawCharacters(self.x + 1, self.y, string.sub(self.text, self.Offset), textColour, backgroundColour)
		end
		if self.isSelected then
			if self.Blink then
				OSDrawing.DrawCharacters(self.x + self.CursorPosition - self.Offset, self.y, self.BlinkCharacter, textColour, backgroundColour)
			end
			self.Blink = not self.Blink
		end
	end

	insertCharacter = function(self, char)
		self.text = string.sub(self.text, 1, self.CursorPosition - 1) .. char .. string.sub(self.text, self.CursorPosition)
		self.CursorPosition = self.CursorPosition + 1
		self.Blink = true
		OSUpdate()
	end

	removeCharacter = function(self, direction)
		if direction == 0 or self.CursorPosition > 1 then
			self.text = string.sub(self.text, 1, self.CursorPosition - 1 + direction) .. string.sub(self.text, self.CursorPosition + 1 + direction)
			self:moveCursor(direction)
		end
		self.Blink = true
		OSUpdate()
	end

	moveCursor = function(self, direction)
		local c = self.CursorPosition + direction
		if c < 1 then --make sure cursor is greater than 1
			c = 1
		end

		if c > #self.text + 1 then --make sure cursor is the character after the last at maximum
			c = #self.text + 1
		end
		self.CursorPosition = c
		self.Blink = true
	end

	action = function(self, x, y)
		if x < 1 then --make sure x is greater than 1
			x = 1
		end

		if x > #self.text + 1 then --make sure x is the character after the last at maximum
			x = #self.text + 1
		end

		self.CursorPosition = x + self.Offset
		self.Blink = true
		OSSelectedEntity = self --gain focus
	end