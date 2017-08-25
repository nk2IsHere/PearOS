--OSContainer--

	__index = OSEntity

	objtype = "OSContainer"
	entities = {}

	new = function(self, _x, _y, _width, _height, _entities)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSContainer} ) -- copy an instance of itself
		new.width = _width
		new.height = _height
		new.x = _x
		new.y = _y
		new.entities = _entities
		return new
	end

	Draw = function(self, darkMode)
		OSDrawing.addOffset(self.x, self.y)
		for _,entity in pairs(self.entities) do
			entity:Draw(darkMode)
		end
	end

	action = function(self, x, y, arg)
		x = x + 1
		y = y + 1
		
		for _,entity in pairs(self.entities) do
			--check if the click overlaps an entities
			if OSServices.pointOverlapsRect({x = x, y = y}, entity)  then
				OSServices.clickEntity(entity, x, y, arg)
			end
		end
	end