
	name = "Login"
	menus = {}
	windows = {}
	version = "1.0"
		
	init = function()
    	login(environment)
	end
	

	login = function(self)
		local userNames = {}
		for name,info in pairs(OSSettings['users']) do
			table.insert(userNames,name)
		end

		local dropdown = OSDropdownMenu:new(2, 4, 18, 4, "Username", userNames)
		local password = OSTextField:new(2, 6, 18, "Password")

		loginWindow = OSWindow:new("", {
			OSLabel:new(2, 2, "Login to account:"),
			dropdown,
			password,
			OSButton:new(13, 8, "Login", function() 
				if OSSettings['users'][dropdown.selected] ~= nil then
					if OSSettings['users'][dropdown.selected]['password'] == OSSha1.sha1(password.text) then
						OSDrawing.SetMode(OSSettings['users'][dropdown.selected]['dark_mode'])
						SetCurrentUser(dropdown.selected)
						SetFTMode(false)
						OSFileSystem.HomePath = "/Home/"..dropdown.selected
						desktop.BackgroundColour = OSSettings['users'][dropdown.selected]['desktop_bg']
						OSStartDesktop()
						OSUpdate()
					end
				end
			end)
		}, 20,9, self)
		loginWindow.canMaximise = false
		loginWindow.hasFrame = false

		self.windows['login'] = loginWindow
	end	