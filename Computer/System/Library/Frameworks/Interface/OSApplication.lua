--OSApplication--

	__index = OSObject --subclass of osobject
	
	objtype = "OSApplication"
	title = ""
	windows = {}
	mainMenu = {}
	menus = {}
	id = 0
	environment = {}

	new = function(_title, _mainMenu, _menus, _windows, _crashed)
		local new = {}    -- the new instance
		setmetatable( new, {__index = OSApplication} )
		new.title = _title
		new.mainMenu = _mainMenu
		new.menus = _menus
		new.crashed = _crashed
		new.windows = _windows
		new.id = OSInterfaceServices.generateID()
		return new
	end

	load = function(self, _path)
	--check if the application is already open
		local name = OSFileSystem.shortName(_path)
		if OSInterfaceApplications.list[name] then
			--the application is already open, return that
			return OSInterfaceApplications.list[name]
		else
			--load an application from a path and assign the environment

			self.environment = OSServices.copyTable(getfenv())
			--add additional commands for the application
			self.environment['quit'] = function()term.setTextColour(colours.black) OSInterfaceApplications.remove(self) end
			self.environment.name = name
			self.environment.path = _path
			self.environment.environment = self.environment

			local crashed = false

			--load app libs if exist
			if OSFileSystem.exists(_path.."/Library") then
				for _,fileName in pairs(OSFileSystem.list(_path.."/Library")) do
					includeFile(_path.."/Library/"..fileName)
				end
			end

			--initialise the application
			local ok, err = os.run(self.environment, _path.."/"..name..".lua")
			if not ok then --the application has an error in its code
				windows['error'] = OSErrorWindow:new("Application Error", {"Application did not load", "This can be a code error"}, "Proceed", function() windows['error'] = nil end, environment)
				crashed = true
			else	
				local ok, err = pcall(self.environment.init)
				if not ok then 
					self.environment.windows = {}
					self.environment.windows['error'] = OSErrorWindow:new("Application Error", {"Application did not init ", err}, "Proceed", function() windows['error'] = nil end, environment)
					crashed = true
				end
			end
			return OSApplication.new(self.environment.name, self.environment.mainMenu, self.environment.menus, self.environment.windows, crashed)
		end
	end

	run = function(_application)
		--if the application is already open bring focus to it 
		if OSInterfaceApplications.list[_application.title] then
			OSInterfaceApplications.switchTo(OSInterfaceApplications.list[_application.title])
		else
			OSInterfaceApplications.switchTo(_application)
		end
		return _application
	end

	quit = function(self)
		for _,window in pairs(self.windows) do
			window:restore()
		end
		OSInterfaceApplications.remove(self)
	end