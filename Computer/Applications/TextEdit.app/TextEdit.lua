	menus = {}
	windows = {}
	version = "1"
	id = 0
	name = "TextEdit"
	author = "nk2"

	init = function()
		local filemenuItems = {
    			OSMenuItem:new("New", function() newWindow("") end,  "N"),
    			OSMenuItem:new("Open", nil)
	    	}
		local filemenu = OSMenu:new(1, 1, "File", filemenuItems)
    	
    		local editmenuItems = {
    			OSMenuItem:new("Copy", nil)
	    	}
		local editmenu = OSMenu:new(1, 1, "Edit", editmenuItems)
    	
    		menus = {filemenu, editmenu}

			newWindow("/Home/Documents/Text.txt")
    		OSExtensionAssociations.register({"txt", "lua"}, environment)
	end
	
	about = function()
		windows['about'] = OSAboutWindow:new(name, version, author, path, environment)
	end	
	
	newWindow = function(_path, new)
		local window = nil
		local name = "Untitled"
		local text = ""
		if path then
			name = OSFileSystem.getName(_path)
			if OSFileSystem.exists(_path) then
				text = readFile(_path)
			else
				text = ""
			end
		end
		
		local textView = OSBigTextField:new(1,1, 30, 14, text, function() 
			
		end)
		
		window = OSWindow:new(name, {
			textView
		}, 30, 14, environment)
		
		id = id + 1
		window.textView = textView
		window.text = textView.text
		window.path = _path
		windows['window'..id] = window
	end
	
	readFile = function(_path)
		local file = fs.open(_path, "r")
		if file then
			local content = file.readAll()
			file.close()	
			return content
		else
			return ""
		end
	end
	
	saveFile = function(_path, _content)
		local file = fs.open( _path, "w" )
		if file then
			file.write(_content)
			file.close()
		else
			error( "Failed to open ".._path )
		end
		return true
	end
	
	openFile = function(_path)
    	newWindow(_path)
	end
	
	windowShouldClose = function(window)
		if window.textView then
			saveFile(window.path, window.textView.text)
		end
		return true
	end
	
	windowDidResize = function(window, _width, _height)
		window.textView.width = _width 
		window.textView.height = _height
		window.textView:calculateWrapping()
	end