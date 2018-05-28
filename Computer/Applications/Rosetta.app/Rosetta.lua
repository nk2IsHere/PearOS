
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
		local appsPath = OSFileSystem.HomePath.."/ComputerCraft/"
		if not OSFileSystem.exists(appsPath) then
			OSFileSystem.mkDir(appsPath)
		end
		local appListView = OSListView:new(1, 2, 17, 12, appList)
		update(appsPath, appListView)
		windows['rosetta'] = OSWindow:new(name, {
			appListView
		}, 17,12, environment)
		windows['rosetta'].minHeight = 4
		windows['rosetta'].minWidth = 9 + #name
	end

	renderApp = function(appPath, name)
		OSEvents.computerCraftMode = true
		local vmDataPath = path.."/VM"

		local args = {}
		args.ops = {
			biosPath = vmDataPath.."/bios.lua",
			romPath = vmDataPath.."/rom",
			rootPath = appPath..name
		}
		local ok, err = os.run(args, path.."/virtualos.lua")
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
		