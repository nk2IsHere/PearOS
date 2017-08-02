--OSButton--

	__index = OSControl
	
	objtype = "OSButton"

	TextColour = colours.black
	TextColourDark = colours.white
	DisabledTextColour = colours.grey
	DisabledTextColourDark = colours.lightGrey

	BackgroundColour = colours.lightGrey
	BackgroundColourDark = colours.black
	DisabledBackgroundColour = colours.lightGrey
	DisabledBackgroundColourDark = colours.black

	SelectedBackgroundColour = colours.lightBlue
	SelectedBackgroundColourDark = colours.orange
	SelectedTextColour = colours.white
	SelectedTextColourDark = colours.white

	new = function(self, _x, _y, _title, _action)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSButton} )
		new.width = string.len(_title)+2
		new.height = 1
		new.x = _x
		new.y = _y
		new.title = _title
		new.action = _action
		new.enabled = true
		return new
	end

	Draw = function(self, darkMode)
		--if the button doesn't have an action grey out the text
		local textColour = nil
		
		--if the button is selected give it the background and text color 
		local bgColour = nil
		if not darkMode then
			if self.isSelected then
				bgColour = self.SelectedBackgroundColour
				textColour = self.SelectedTextColour
				self.isSelected = false
			else
				if self.enabled and self.action then
					bgColour = self.BackgroundColour
					textColour = self.TextColour
				else
					bgColour = self.DisabledBackgroundColour
					textColour = self.DisabledTextColour
				end
			end
		else
			if self.isSelected then
				bgColour = self.SelectedBackgroundColourDark
				textColour = self.SelectedTextColourDark
				self.isSelected = false
			else
				if self.enabled and self.action then
					bgColour = self.BackgroundColourDark
					textColour = self.TextColourDark
				else
					bgColour = self.DisabledBackgroundColourDark
					textColour = self.DisabledTextColourDark
				end
			end
		end
		OSDrawing.DrawCharacters(self.x,self.y, " "..self.title.." ", textColour, bgColour)
	end