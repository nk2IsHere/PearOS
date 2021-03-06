--OSMenuItem--

	__index = OSEntity -- parent class

	isSelected = false
	objtype = "OSMenuItem"
	subtype = ""
	shortcut = nil
	
	new = function(self, _title, _action, _shortcut)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSMenuItem} ) -- copy an instance of OSMenuItem
		new.width = 0 --this is set to the string length of the longest item + 2 for padding
		new.height = 1
		new.title = _title
		if _action then
			new.action = function(self)
			self.isSelected = true
			self:Draw()
			sleep(0.2)
			_action()
			OSUpdate()
		end
		end
		if _shortcut then
			new.shortcut = _shortcut
			OSKeyboardShortcuts.register(_shortcut, _action)
		end
		return new
	end

	updateCords = function(menuItem, _x, _y)
		menuItem.x = _x
		menuItem.y = _y
	end

	Draw = function(self, darkMode)
		local bgColour = OSMenu.BackgroundColour
		local textColour = OSMenu.TextColour
		if darkMode then
			bgColour = OSMenu.BackgroundColourDark
			textColour = OSMenu.TextColourDark
		end

		--if the menu self doesn't have an action grey out the text
		if self.action == nil then
			textColour = OSMenu.DisabledTextColour
			if darkMode then
				textColour = OSMenu.DisabledTextColourDark
			end
		end

		--if the self is selected give it the background and text color 
		if self.isSelected then
			bgColour = OSMenu.SelectedBackgroundColour
			textColour = OSMenu.SelectedTextColour
			if darkMode then
				bgColour = OSMenu.SelectedBackgroundColourDark
				textColour = OSMenu.SelectedTextColourDark
			end
			--hide all menus
			self.isSelected = false
			OSInterfaceServices.shouldHideAllMenus = true
		end

		OSDrawing.DrawBlankArea(self.x, self.y, self.width, self.height, bgColour)
		OSDrawing.DrawCharacters(self.x + 1, self.y, self.title, textColour, bgColour)
		if self.shortcut then
			OSDrawing.DrawCharacters(self.x + self.width - 3, self.y, "#"..self.shortcut, textColour, bgColour) 
		end
	end

	cleanup = function (self)
		self = nil
	end
