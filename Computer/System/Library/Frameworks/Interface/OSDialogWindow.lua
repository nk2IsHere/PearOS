--OSDialogWindow--


	__index = OSWindow

	objtype = "OSWindow"
	subtype = "OSDialogWindow"
	title = "Dialog"
	entities = {}
	environment = nil
	canMaximise = false
	canMinimise = false
	isMinimised = false
	canClose = false
	hasFrame = true
	width = 20
	height = 7


	action = function(self, x, y)
	end

	local getCenter = function(_width, _length)
		return math.ceil((_width - _length) / 2)
	end

	new = function(self, _title, _textTable, _environment)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSWindow} )
		new.canMaximise = self.canMaximise
	    new.canMinimise = self.canMinimise
		new.canClose = self.canClose

		local maxWidth = 1
		for k,v in pairs(_textTable) do
			if #v > maxWidth then maxWidth = #v end
		end

		new.title = _title
		new.width = maxWidth+2
		new.height = table.getn(_textTable) + 3 --for the menu bar
		local w, h = OSServices.availableScreenSize()
		new.x = getCenter(w, new.width)
		new.y = getCenter(h, new.height) + 1
		new.id = OSInterfaceServices.generateID()
		new.environment = _environment
		OSCurrentWindow = new

		new.entities = {
		}
		for k,v in pairs(_textTable) do
			table.insert(new.entities, OSLabel:new(1, k+1, v))
		end

		return new
	end