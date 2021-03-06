--OSBox--

	__index = OSControl
	
	objtype = "OSBox"

	new = function(self, _x, _y, _width, _height, _colour)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSBox} )
		new.x = _x
		new.y = _y
		new.width = _width
		new.height = _height
		new.color = _colour
		return new
	end

	Draw = function(self)
		OSDrawing.DrawBlankArea(self.x, self.y, self.width, self.height, self.color)
	end