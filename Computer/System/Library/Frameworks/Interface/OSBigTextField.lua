--OSBigTextField--

	__index = OSControl
	objtype = "OSBigTextField"

	text = ""
	Selection = {0,0} --start character, end character
	CursorPosition = {
		x = 0,
		y = 0
	}
	Blink = false  --whether the blinking character should be shown
	BlinkCharacter = "|"
	MoveDirection = 0

	canScroll = true
	maxScrollY = 0
	scrollY = 0

	lines = {}
	linesWithEnters = {}

	TextColour = colours.black
	TextColourDark = colours.white
	SelectedBackgroundColour = colours.lightBlue
	SelectedBackgroundColourDark = colours.orange
	SelectedTextColour = colours.white
	SelectedTextColourDark = colours.white
	BackgroundColour = colours.white
	BackgroundColourDark = colours.grey

	new = function(self, _x, _y, _width, _height, _text)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSBigTextField} )
		new.width = _width
		new.height = _height
		new.x = _x
		new.y = _y
		new.text = _text
		new:calculateWrapping()
		return new
	end

	calculateWrapping = function(self)
		local lines = {''}
		local linesWithEnters = {''}

		for char in self.text:gmatch"." do
			if #lines[#lines] >= self.width then
				table.insert(lines, '')
				table.insert(linesWithEnters, '')
			end
			if not (char == '\n') then
				lines[#lines] = lines[#lines]..char
			end
			linesWithEnters[#linesWithEnters] = linesWithEnters[#linesWithEnters]..char
			if char == '\n' then
				table.insert(lines, '')
				table.insert(linesWithEnters, '')
			end
		end
		self.lines = lines
		self.linesWithEnters = linesWithEnters
		OSUpdate()
	end

	calculateCursorPosition = function(self)
		local cursorFixedY = self.CursorPosition.y  - self.scrollY
		if self.CursorPosition.y > #self.linesWithEnters then
			cursorFixedY = #self.linesWithEnters
		end

		local pos = 0
		for id,line in ipairs(self.linesWithEnters) do
			if id < self.CursorPosition.y - self.scrollY then
				pos = pos + #line
			else
				pos = pos + self.CursorPosition.x
				break
			end
		end

		return pos
	end

	Draw = function(self, darkMode)

		self.maxScrollY = self.height - #self.lines

		local textColour = self.TextColour
		local backgroundColour = self.BackgroundColour
		local selectedTextColour = self.SelectedTextColour
		local selectedBackgroundColour = self.SelectedBackgroundColour
		if darkMode then
			textColour = self.TextColourDark
			backgroundColour = self.BackgroundColourDark
			selectedTextColour = self.SelectedTextColourDark
			selectedBackgroundColour = self.SelectedBackgroundColourDark
		end

		OSDrawing.DrawBlankArea(self.x, self.y, self.width, self.height, backgroundColour)


		for id,line in ipairs(self.lines) do
			if self.height >= id+self.scrollY and (self.y+id+self.scrollY) > (self.y)  then
				OSDrawing.DrawCharacters(self.x, self.y-1+id+self.scrollY, line, textColour, backgroundColour)
			end
		end
		
		if self.isSelected then
			if self.Blink then
				OSDrawing.DrawCharacters(self.CursorPosition.x, self.CursorPosition.y, self.BlinkCharacter, textColour, backgroundColour)
			end
			self.Blink = not self.Blink
		end
	end

	insertCharacter = function(self, char)
		local pos = self:calculateCursorPosition()

		self.text = self.text:sub(1, pos-1) .. char .. self.text:sub(pos)
		self:calculateWrapping()

		if self.CursorPosition.x < self.width then
			self.CursorPosition.x = self.CursorPosition.x + 1
		else
			self.CursorPosition.x = 1
			if self.height - self.scrollY <= #self.lines then
				self.scrollY = self.scrollY - 1
			else
				self.CursorPosition.y = self.CursorPosition.y + 1
			end
		end
		OSUpdate()
	end

	removeCharacter = function(self, direction)
		local pos = self:calculateCursorPosition() 

		if self.CursorPosition.x > self.x then
			self.CursorPosition.x = self.CursorPosition.x - 1
		else
			if self.height + self.scrollY <= #self.lines then
				self.scrollY = self.scrollY + 1
			else
				if self.CursorPosition.y - self.scrollY > self.y then
					self.CursorPosition.y = self.CursorPosition.y - 1
					self.CursorPosition.x = #self.lines[self.CursorPosition.y]+1
				end
				if self.CursorPosition.y == self.y then
					self.CursorPosition.x = #self.lines[self.CursorPosition.y]+1
				end
			end
		end

		if pos ~= 1 then 
			self.text = self.text:sub(1, pos - 1 + direction) .. self.text:sub(pos + 1 + direction)
		end
		self:calculateWrapping()

		OSUpdate()
	end

	drag = function (self, x, y)
		--TODO
	end

	action = function(self, x, y)
		self.CursorPosition.x = x+1
		self.CursorPosition.y = y+1
		if not self.lines[self.CursorPosition.y - self.scrollY] then 
			self.CursorPosition.y = #self.lines + self.scrollY 
		end
		if self.CursorPosition.x >= #self.lines[self.CursorPosition.y - self.scrollY] then
			self.CursorPosition.x = #self.lines[self.CursorPosition.y - self.scrollY] + 1
		end
		self.Blink = true
		OSSelectedEntity = self --gain focus
	end

	submit = function(self)
		local pos = self:calculateCursorPosition()
		self.text = self.text:sub(1, pos-1) .. '\n' .. self.text:sub(pos)
		self:calculateWrapping()
		self.CursorPosition.x = 1
		self.CursorPosition.y = self.CursorPosition.y + 1
		OSUpdate()
	end

	moveCursor = function(self, direction)
		if direction == 2 then --up
			if self.CursorPosition.y - 1 -self.scrollY >= self.y then
				self.CursorPosition.y = self.CursorPosition.y - 1
			end
		elseif direction == -2 then --down
			if (self.CursorPosition.y + 1 -self.scrollY <= self.height) and (self.lines[self.CursorPosition.y + 1] ~= nil) then
				self.CursorPosition.y = self.CursorPosition.y + 1
			end
		elseif direction == -1 then --left
			if self.CursorPosition.x - 1 >= self.x then
				self.CursorPosition.x = self.CursorPosition.x - 1
			end
		elseif direction == 1 then --reight
			if self.CursorPosition.x + 1 <= #self.lines[self.CursorPosition.y]  then
				self.CursorPosition.x = self.CursorPosition.x + 1
			end
		end

		if self.CursorPosition.x > #self.lines[self.CursorPosition.y] + 1 then
			self.CursorPosition.x = #self.lines[self.CursorPosition.y] + 1 
		end
		OSUpdate()
	end