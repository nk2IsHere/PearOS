--OSClockButton--

	__index = OSButton

	objtype = "OSButton"
	subtype = "OSClockButton"

	new = function(self, _x, _y, _title)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSClockButton} ) -- copy an instance of OSMenuItem
		new.width = string.len(_title)
		new.height = 1
		new.x = _x
		new.y = _y
		new.title = _title
		new.enabled = false
		return new
	end
	
	Draw = function(self, darkMode)
		local w, h = term.getSize()
		local time = textutils.formatTime(os.time(), false)
		self.x = w-string.len(time)
		self.y = 1

		local textColour = OSMenuBar.TextColour
		local backgroundColour = OSMenuBar.BackgroundColour
		if darkMode then
			textColour = OSMenuBar.TextColourDark
			backgroundColour = OSMenuBar.BackgroundColourDark
		end

		self.title = time
		OSDrawing.DrawCharacters(self.x, self.y, self.title, textColour, backgroundColour)
	end
