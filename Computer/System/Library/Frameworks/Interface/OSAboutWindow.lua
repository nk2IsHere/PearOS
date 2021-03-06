--OSAboutWindow--

	__index = OSWindow

	objtype = "OSWindow"
	subtype = "OSAboutWindow"
	title = "About"
	entities = {}
	environment = nil
	canMaximise = false
	canMinimise = true
	isMinimised = false
	canClose = true
	hasFrame = true
	minWidth = 11
	minHeight = 5


	action = function(self, x, y)
	end

	local getCenter = function(_width, _length)
		if math.fmod(_width - _length, 2) == 0 then-- its just to determine %
			return math.ceil((_width - _length) / 2) + 1
		else
			return math.ceil((_width - _length) / 2)
		end 
	end

	new = function(self, _title, _version, _author, _path, _environment)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSWindow} )
		new.title = "About ".._title
		
		new.width = 20
		new.height = 11 + 1 --for the menu bar
		local w, h = OSServices.availableScreenSize()
		new.x = getCenter(w, new.width)
		new.y = getCenter(h, new.height) + 1
		new.id = OSInterfaceServices.generateID()
		new.environment = _environment
		OSCurrentWindow = new
		local versionText = "Version ".._version
		new.canMaximise = false
		local versionLabel = OSLabel:new(getCenter(new.width, #versionText), 9, "Version ".._version)
		versionLabel.TextColour = colours.grey

		local copyrightLabel = OSLabel:new(4, 10, "Copyright 2xxx")
		copyrightLabel.TextColour = colours.lightGrey

		new.entities = {
			OSImageView:new(8, 2, _path.."/icon_l"),
			OSLabel:new(getCenter(new.width, #_title), 7, _title),
			
			versionLabel,
			copyrightLabel,
			OSLabel:new(getCenter(new.width, #_author)+1, 11, _author),
		}

		return new
	end