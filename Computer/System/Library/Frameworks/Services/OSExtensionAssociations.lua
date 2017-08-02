--OSExtensionAssociations--

	list = {}
	register = function(extensions, application) --return false if the register fails
		local state = true
		local extensionStr = ""
		for _,v in pairs(extensions) do
			if not OSExtensionAssociations.list[v] then
				extensionStr = extensionStr.." "..v
			end
		end

		if not extensionStr == "" then
			application.windows['extensionRegister'] = OSInfoWindow:new("Extension register",
												{application.name.." application tries to register",  "new extensions:"..extensionStr, "Allow it to do this?"},
												"Yes", function() state = true 
																application.windows['extensionRegister'] = nil end,
				 								"No",  function() state = false 
				 												application.windows['extensionRegister'] = nil end, environment)

			if state then
				for _,ext in pairs(extensions) do
					OSExtensionAssociations.list[ext] = application.path
				end
			end

			local settings = OSTableIO.load("Home/Settings.cfg")
			settings['extension_associations'] = OSExtensionAssociations.list
			OSTableIO.save(settings,"Home/Settings.cfg")
		end
	end