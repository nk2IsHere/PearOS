--OSMenu--

	__index = OSControl -- parent class

	items = {}

	isHidden = true
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
		setmetatable( new, {__index = OSMenu} ) 
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
		if not menu.isHidden then
			--menu is currently displayed, change it and hide the items
			menu.isHidden = not menu.isHidden
			menu:hideItems(menu)
		else
			--the menu is closed, hide other menus and enrole this for display
			OSInterfaceServices.hideAllMenus()
			menu.isHidden = not menu.isHidden
		end
		OSUpdate()
	end

	hideItems = function (self, menu)
		--hide the menu items
		for _,entity in ipairs(OSInterfaceEntities.list) do						-- make sure the item is in the right menu
			if entity.objtype == "OSMenuItem" and entity.id == menu.id then
				OSInterfaceEntities.list[_]=nil
			end
		end

		OSServices.compactArray(OSInterfaceEntities.list)
		menu.isFirstDraw = true --set to first draw again so it will draw the menu
	end
	
	cleanup = function (self)
		if not self.isHidden then --if the menu is open close it
			self:hideItems(self)
		end
	end

	DrawHiddenMenu = function(self, darkMode)
		--only draw the title of the self, not the content
		if not darkMode then
			OSDrawing.DrawCharacters(self.x, self.y, " "..self.title.." ", self.TextColour, self.BackgroundColour)
		else
			OSDrawing.DrawCharacters(self.x, self.y, " "..self.title.." ", self.TextColourDark, self.BackgroundColourDark)
		end
	end

	DrawFullMenu = function(self, darkMode)
		if not darkMode then
			OSDrawing.DrawCharacters(self.x, self.y, " "..self.title.." ", self.SelectedTextColour, self.SelectedBackgroundColour)
		else
			OSDrawing.DrawCharacters(self.x, self.y, " "..self.title.." ", self.SelectedTextColourDark, self.SelectedBackgroundColourDark)
		end

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
		--draw the shadow
		OSDrawing.DrawShadow(self.x, self.y, self.items[1].width, #self.items + 1)
	end
	
	Draw = function(self, darkMode)
		--if the menu has been told to close (should hide) close it
		if not self.isHidden then
			self:DrawFullMenu(darkMode)
		else
			self:DrawHiddenMenu(darkMode)
		end
	end
	