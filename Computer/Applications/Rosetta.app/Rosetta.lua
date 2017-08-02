
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

		for _,v in pairs(fs.list(path)) do
			table.insert(appList, OSListItem:new(v, function ()renderApp(path, v)end))
		end

		local appListView = OSListView:new(1, 2, 17, 14, appList)
		windows['rosetta'] = OSWindow:new(name, {
			appListView
		}, 17,14, environment)
		windows['rosetta'].minHeight = 3 + #appList
		windows['rosetta'].minWidth = 9 + #name
	end

	renderApp = function(path, name)
		shell.resolve(path..name.."/")
		shell.setDir(path..name.."/")
		OSServices.computerCraftMode = true
		local ok, err = os.run(environment, path..name.."/"..name)
		OSServices.computerCraftMode = false
		if not ok then 
			windows['error'] = OSErrorWindow:new("Application Error", {"Application did not start", "This can be a code error"}, "Proceed", function() windows['error'] = nil end, environment)
		end
		
		--crash os on crash
		OSLog(err)
	end

	function windowDidClose(self)
		environment:quit()
	end

	windowDidResize = function(window, _width, _height)
		if window == windows['about'] then
			return
		end

		window.entities[1].width = _width -1
		window.entities[1].height = _height -1
	end
		