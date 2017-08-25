--OSDropdownMenu--

	__index = OSControl -- parent class

	items = {}

	objtype = "OSMenu"
	id = 0


	scrollY = 0
	maxScrollY = 0
	canScroll = true

	allowedHeight = 0

	TextColour = colours.black
	TextColourDark = colours.white
	DisabledTextColour = colours.lightGrey
	DisabledTextColourDark = colours.lightGrey
	BackgroundColour = colours.lightGrey
	BackgroundColourDark = colours.black
	SelectedBackgroundColour = colours.lightBlue
	SelectedBackgroundColourDark = colours.orange
	SelectedTextColour = colours.white
	SelectedTextColourDark = colours.white

	new = function(self, _x, _y, _width, _height, _title, _items)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSDropdownMenu} ) 
		new.x = _x
		new.y = _y

		local width = 0
		if _width == 0 then
			for id,item in pairs(_items) do
				if #item > width then width = #item end
			end
			width = width + 3
		else width = _width end

		new.width = width
		new.height = 1
		new.drawingShouldBeOnTop = true
		new.allowedHeight = _height
		new.maxScrollY = _height - #_items
		new.selected = _title
		new.items = _items
		new.id = OSInterfaceServices.generateID()--math.random()

		return new
	end

	Draw = function(self, darkMode)

		local BackgroundColour = self.BackgroundColour
		local TextColour = TextColour
		if darkMode then
			BackgroundColour = self.BackgroundColourDark
			TextColour = self.TextColourDark
		end

		OSDrawing.DrawArea(self.x, self.y, self.width, 1, " ", BackgroundColour, TextColour) 
		OSDrawing.DrawCharacters(self.x + self.width -1, self.y, '\31', TextColour, BackgroundColour)
		if self.selected then
			OSDrawing.DrawCharacters(self.x+1, self.y, self.selected, TextColour, BackgroundColour)
		end
		if self.clicked then
			for id, item in pairs(self.items) do
				if (id + self.scrollY < self.height) and (id + self.scrollY > 0) then
					OSDrawing.DrawArea(self.x, self.y + id + self.scrollY, self.width, 1, " ", BackgroundColour, TextColour) 
					OSDrawing.DrawCharacters(self.x, self.y + id + self.scrollY, " "..item.."  ", TextColour, BackgroundColour)
				end
			end
			OSDrawing.DrawShadow(self.x, self.y, self.width, self.height-2)
		end
	end

	action = function(self, x, y)
		self.clicked = not self.clicked
		if self.clicked then
			self.height = self.allowedHeight
		else
			if self.items[y - self.scrollY] then
				OSDrawing.DrawCharacters(self.x, y, self.items[y-self.scrollY], self.SelectedBackgroundColourDark, self.SelectedTextColourDark)
				self.selected = self.items[y - self.scrollY]
			end
			self.height = 1
		end
	end