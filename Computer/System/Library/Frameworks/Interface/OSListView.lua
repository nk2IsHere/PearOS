--OSListView--

	__index = OSControl

	objtype = "OSListView"
	items = {}
	scrollY = 0
	maxScrollY = 0
	canScroll = true

	SpliterColour = colours.grey
	SpliterColourDark = colours.lightGrey
	SpliterBackgroundColour = colours.white
	SpliterBackgroundColourDark = colours.grey

	new = function(self, _x, _y, _width, _height, _items)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSListView} )
		new.x = _x
		new.y = _y
		new.width = _width
		new.height = _height
		for _,item in pairs(_items) do
			item.width = _width
		end
		new.items = _items
		new.maxScrollY = new.height - #new.items
		return new
	end

	Draw = function(self, darkMode)

		self.maxScrollY = self.height - #self.items
		
		for i = 1, #self.items do
			local listItem = self.items[i]
			listItem.x = self.x
			listItem.y = self.y + i + self.scrollY - 1
			listItem.width = self.width
			--calculate whether or not the item should be drawn
			--print(self.y)

			if  listItem.y >= self.y and listItem.y < self.height + 3 then
				listItem:Draw(darkMode)
			end
		end
	end

	action = function(self, x, y)
		--check that the item won't be out of bounds
		if y - self.scrollY + 1 <= #self.items then
			local item = self.items[y - self.scrollY + 1]
			item.isSelected = true
			OSUpdate()
			sleep(0.2)
			if item.action then
				item:action()
			end
		end
	end