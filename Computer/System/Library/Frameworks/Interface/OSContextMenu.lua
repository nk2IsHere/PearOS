--OSContextMenu--

	__index = OSControl -- parent class

	items = {}

	isHidden = false
	isFirstDraw = true
	objtype = "OSMenu"
	shouldHide = false
	hasShortcut = false
	id = 0

	TextColour = colours.black
	TextColourDark = colours.white
	DisabledTextColour = colours.lightGrey
	DisabledTextColourDark = colours.lightGrey
	BackgroundColour = colours.white
	BackgroundColourDark = colours.black
	SelectedBackgroundColour = colours.lightBlue
	SelectedBackgroundColourDark = colours.orange
	SelectedTextColour = colours.white
	SelectedTextColourDark = colours.white

	new = function(self, _x, _y, _title, _items)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSContextMenu} ) 
		new.x = _x
		new.y = _y
		new.width = string.len(_title) + 2 -- 2 is for the outer padding
		new.height = 1
		new.title = _title
		new.items = _items
		local hasShortcut = false
		for _,i in ipairs(_items) do
			if i.shortcut then
				hasShortcut = true
				break
			end
		end
		self.hasShortcut = hasShortcut
		--assign a unique id to each item
		new.id = OSInterfaceServices.generateID()--math.random()
		return new
	end

	action = function(menu)
		OSInterfaceServices.hideAllMenus()
		OSUpdate()
	end

	hideItems = function (self, menu)
		--hide the menu items
		for _,entity in ipairs(OSInterfaceEntities.list) do
			if entity.objtype == "OSMenuItem" and entity.id == menu.id then
				OSInterfaceEntities.list[_]=nil
			end
		end

		OSServices.compactArray(OSInterfaceEntities.list)
	end

	DrawFullMenu = function(self, darkMode)

		if self.isHidden then 
			self:hideItems(self)
		else
			currentY = self.y
			--if the menu hasn't been draw yet
			if self.isFirstDraw then
				--if not already set, calculate the width of the self
				local menuWidth = 0
				if self.items[1].width == 0 then
					menuWidth =  OSServices.longestStringInArray(self.items) + 2--add two for padding
					if self.hasShortcut then
						menuWidth = menuWidth + 3
					end
				else
					menuWidth = self.items[1].width
				end

				for _,menuItem in pairs(self.items) do
					menuItem.id = self.id
					currentY = currentY + 1
					menuItem:updateCords(self.x, currentY)
					menuItem.width = menuWidth
					menuItem:Draw(darkMode)
					OSInterfaceEntities.add(menuItem)
				end
				self.isFirstDraw = false
			end
			OSDrawing.DrawShadow(self.x, self.y, self.items[1].width, #self.items + 1)
		end
	end
	
	Draw = function(self, darkMode)
		self:DrawFullMenu(darkMode)
	end
	