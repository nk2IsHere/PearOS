
	name = "Rosetta"
	menus = {}
	windows = {}
	version = "0.01"
	showHidden = false
	id = 0
	author = "nk2"
	
	init = function()
    		menus = {}
    		rosetta()
	end
	
	about = function()
		windows['about'] = OSAboutWindow:new(name, version, author, path, environment)
	end

	rosetta = function()
		local appList = {}
		local path = "Applications/ComputerCraft/"
		local appListView = OSListView:new(1, 2, 17, 14, appList)
		update(path, appListView)
		windows['rosetta'] = OSWindow:new(name, {
			appListView
		}, 17,14, environment)
		windows['rosetta'].minHeight = 4
		windows['rosetta'].minWidth = 9 + #name
	end

	renderApp = function(path, name)
		shell.resolve(path..name.."/")
		shell.setDir(path..name.."/")
		OSEvents.computerCraftMode = true
		local ok, err = os.run(environment, path..name.."/"..name)
		OSEvents.computerCraftMode = false
		if not (err == nil) then 
			windows['error'] = OSErrorWindow:new("Application Error", {"Application did not start", "This can be a code error"}, "Proceed", function() windows['error'] = nil end, environment)
		end
	end

	update = function(path, list)
		local appList = {}
		for _,v in pairs(OSFileSystem.list(path)) do
			table.insert(appList, OSListItem:new(v, function ()
				renderApp(path, v)
				update(path, list)
			end))
		end

		list.items = appList
	end

	function windowDidClose(self)
		environment:quit()
	end

	windowDidResize = function(window, _width, _height)
		if window == windows['about'] then
			return
		end

		window.entities[1].width = _width 
		window.entities[1].height = _height -2
	end
		