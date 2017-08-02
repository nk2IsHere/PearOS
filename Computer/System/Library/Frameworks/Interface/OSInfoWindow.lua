--OSInfoWindow--


	__index = OSWindow

	objtype = "OSDialogWindow"
	subtype = "OSInfoWindow"
	title = "Info"
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

	new = function(self, _title, _textTable, _buttonText, _action, _secondButtonText, _secondAction, _environment)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSWindow} )
		new.canMaximise = self.canMaximise
	    new.canMinimise = self.canMinimise
		new.canClose = self.canClose

		local maxWidth = 1
		for k,v in pairs(_textTable) do
			if #v > maxWidth then maxWidth = #v end
		end
		if (#_buttonText+2) > maxWidth then maxWidth = #_buttonText+2 end

		new.title = _title
		new.width = maxWidth+12
		if (table.getn(_textTable) + 5) > 7 then
			new.height = table.getn(_textTable) + 5 --for the menu bar
		else
			new.height = 8 -- check for image
		end
		local w, h = OSServices.availableScreenSize()
		new.x = getCenter(w, new.width)
		new.y = getCenter(h, new.height) + 1
		new.id = OSServices.generateID()
		new.environment = _environment
		OSCurrentWindow = new

		new.entities = {
			OSImageView:new(2,2,"System/Library/Interface/info")
		}
		for k,v in pairs(_textTable) do
			table.insert(new.entities, OSLabel:new(12, k+1, v))
		end

		if not ((_buttonText == nil) or (_action == nil)) then
			local button = OSButton:new(new.width-#_buttonText-2, new.height-2, _buttonText, _action)
			table.insert(new.entities, button)
		end

		if not ((_secondButtonText == nil) or (_secondAction == nil)) then
			local secondButton = OSButton:new(new.width-#_buttonText-2-#_secondButtonText-3, new.height-2, _secondButtonText, _secondAction)
			table.insert(new.entities, secondButton)
		end

		return new
	end