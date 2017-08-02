--OSListItem--

	__index = OSMenuItem -- parent class

	objtype = "OSListItem"
	SelectedBackgroundColour = colours.lightBlue
	SelectedBackgroundColourDark = colours.orange
	SelectedTextColour = colours.white
	SelectedTextColourDark = colours.white
	BackgroundColour = colours.white
	BackgroundColourDark = colours.grey
	TextColour = colours.black
	TextColourDark = colours.white

	new = function(self, _title, _action)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSListItem} ) -- copy an instance of OSMenuItem
		new.height = 1
		new.title = _title
		new.action = _action
		return new
	end

	Draw = function(self, darkMode)
		local bgColour = self.BackgroundColour
		local textColour = self.TextColour
		if darkMode then
			bgColour = self.BackgroundColourDark
			textColour = self.TextColourDark
		end

		if self.isSelected then
			bgColour = self.SelectedBackgroundColour
			textColour = self.SelectedTextColour	
			self.isSelected = false
			if darkMode then
				bgColour = self.SelectedBackgroundColourDark
				textColour = self.SelectedTextColourDark
			end
		end	

		local title = self.title
		if string.len(self.title) > self.width-1 then
		--check if the menu self is a splitter (dont have the padding)
		title = string.sub(self.title, 1, self.width-4) .. "..."
		end

		OSDrawing.DrawBlankArea(self.x, self.y, self.width, self.height, bgColour)
		OSDrawing.DrawCharacters (self.x, self.y, " ".. title, textColour,bgColour)
	end
	
