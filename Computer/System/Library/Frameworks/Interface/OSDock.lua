--OSDock--

	__index = OSEntity

	objtype = "OSDock"
	width = 1
	height = 3 --this includes the dock and its items
	maxItems = 11 --(default screen width ([51] - the margin [3 * 2]) / 4)
	items = {}
	BackgroundColour = colours.lightGrey
	BackgroundColourDark = colours.grey

	new = function(self, _items)
		self.width = (#_items * 4) + 4 - 1 -- width include the white bit at the end, the -1 is to compensate for the margin added by the last item
		local dW, dH = term.getSize()
		self.x = (dW/2) - (self.width/2)
		self.y = dH - self.height
		self.items = _items
		return self
	end

	Draw = function (self, darkMode)
		OSDrawing.setOffset(self.x+1, self.y+1)
		if not darkMode then
			OSDrawing.DrawBlankArea(2, 2,  self.width-2, 1, self.BackgroundColour) --the upper dock bar	
			OSDrawing.DrawBlankArea(1, 3,  self.width, 1, self.BackgroundColour) --the lower dock bar
		else
			OSDrawing.DrawBlankArea(2, 2,  self.width-2, 1, self.BackgroundColourDark) --the upper dock bar	dark
			OSDrawing.DrawBlankArea(1, 3,  self.width, 1, self.BackgroundColourDark) --the lower dock bar dark
		end
		local itemX = 3 
		local itemY = 1
		for _,item in pairs(self.items) do
			--update the absolue position of the dock item
			item.x = itemX
			item.y = itemY
			item:Draw(darkMode)
			itemX = itemX + item.width + 1
		end
	end

	add = function(self, _dockItem)
		for i = 1, 2 do
			self.width = self.width + 2
			local dW, dH = term.getSize()
			self.x = (dW/2) - (self.width/2)
			OSUpdate()
			sleep(0.1)
		end
		table.insert(self.items, _dockItem)
	end

	remove = function(self, _dockItem)
		OSServices.removeTableItem(self.items, _dockItem)
		for i = 1, 2 do
			self.width = self.width - 2
			local dW, dH = term.getSize()
			self.x = (dW/2) - (self.width/2)
			OSUpdate()
			sleep(0.1)
		end
	end

	action = function(self, x, y)
		for _,item in pairs(self.items) do
			--check if the click overlaps an items
			if OSEvents.pointOverlapsRect({x = x, y = y}, item)  then
				OSInterfaceServices.hideAllMenus()
				item:action()
				OSUpdate()
				return
			end
		end
	end

	context = function(self, x, y) 
		for _,item in pairs(self.items) do
			--check if the click overlaps an items
			if OSEvents.pointOverlapsRect({x = x, y = y}, item)  then
				OSInterfaceServices.hideAllMenus()
				item:context(x, y)
				OSUpdate()
				return
			end
		end
	end