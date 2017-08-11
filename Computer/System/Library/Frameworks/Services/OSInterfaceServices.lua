--OSInterfaceServices--

	shouldHideAllMenus = false
	computerCraftMode = false

	hideAllMenus = function ()
		for i = 1, #OSInterfaceEntities.list do	 					-- first delete all the list items
			if OSInterfaceEntities.list[i].objtype == "OSMenuItem" then
				OSInterfaceEntities.list[i]=nil
			end
		end
		OSServices.compactArray(OSInterfaceEntities.list)

		for i = 1, #OSInterfaceEntities.list do	 --then set all menus to hidden     removed -->(the menu that just had it's items removed set to hidden)
			if OSInterfaceEntities.list[i].objtype == "OSMenu" then
				OSInterfaceEntities.list[i].isHidden = true
				OSInterfaceEntities.list[i].isFirstDraw = true
			end
		end
	end

	lastID = 0	--the last used id number, this is used in generateID
	generateID = function()
		OSInterfaceServices.lastID = OSInterfaceServices.lastID + 1
		return OSInterfaceServices.lastID
	end

