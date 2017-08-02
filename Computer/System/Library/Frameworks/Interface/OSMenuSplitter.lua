--OSMenuSplitter--

	__index = OSMenuItem -- parent class

	subtype = "OSMenuSplitter"
	objtype = "OSMenuItem"

	new = function(self)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSMenuSplitter} ) -- copy an instance of OSMenuItem
		new.width = 1 --this is set to the string length of the longest item later on (first draw)
		new.height = 1

		--create a string with the right amount of hyphens 
		new.id = 100
		new.title = "title"
		new.action = nil
		return new
	end

	updateCords = function(menuItem, _x, _y)
		menuItem.x = _x
		menuItem.y = _y
	end

	Draw = function(self, darkMode)

		--extend the length of the title if it isn't long enough
		if string.len(self.title) < self.width then
			--check if the menu self is a splitter (dont have the padding)
			local title = ""
			for i = 1, self.width do
				title = title.."-"
			end
			self.title = title
		end
		--term.write(self.title)
		if not darkMode then
			OSDrawing.DrawArea(self.x, self.y, self.width, self.height, "-", OSMenu.BackgroundColour, OSMenu.DisabledTextColour)
		else
			OSDrawing.DrawArea(self.x, self.y, self.width, self.height, "-", OSMenu.BackgroundColourDark, OSMenu.DisabledTextColourDark)
		end
	end
