--OSEvents--

	rescheduleTimer = function()
		OSUpdateTimer = os.startTimer(OSServices.updateFrequency) 
	end
	
	resetSleepTimer = function()
		if OSSettings['sleep_delay'] > 0 then
			OSSleepTimer = os.startTimer(OSSettings['sleep_delay'])
		end
	end

	updateFrequency = OSSettings['update_frequency']
	dragTimeout = 1
	commandTimeout = 1

	clickEntity = function(entity, x, y)
		--make sure the entity has an action
		if entity.action then
			--if the entity doen't have the 'enabled' key or enabled is true
			if entity.enabled == nil or entity.enabled then
				local entityRelativeX = x - entity.x
				local entityRelativeY = y - entity.y
				entity:action(entityRelativeX, entityRelativeY)
				entity.isSelected = true
				return true --prevent any other clicks from being registered in the same place
			end
		end
		return false
	end

	pointOverlapsRect = function (point, rect)
		if not((rect.width == nil) and (rect.height == nil)) then 
 			return point.x >= rect.x and point.x <=rect.x + rect.width - 1 and point.y >= rect.y and point.y <=rect.y + rect.height - 1
 		end
 		return false
	end


	--EVENT HADLING
	function OSHandleClick (x, y)
		OSSelectedEntity = nil
		for _,entity in pairs(OSInterfaceEntities.list) do
		
			--check if the click overlaps an entities
			if OSEvents.pointOverlapsRect({x = x, y = y}, entity)  then
				if OSEvents.clickEntity(entity, x, y) then
					OSSelectedEntity = entity
					return
				end
			end
		end

				--check windows
				--first click on the current window
		for _,key in ipairs(OSInterfaceApplications.order) do
			local application = OSInterfaceApplications.list[key]
			for _,window in pairs(application.windows) do

				--check if the click overlaps an entities
				if window.isMinimised then
					break
				end

				if OSEvents.pointOverlapsRect({x = x, y = y}, window)   then
					local relativeX = x - window.x + 1
					local relativeY = y - window.y
					OSCurrentWindow = window
					OSInterfaceApplications.switchTo(application)
					window:action(relativeX, relativeY)
					return
				end
			end
		end
		OSEvents.hideAllMenus()
	end

	function OSHandleCharacter (char) 
		if OSSelectedEntity then
		OSSelectedEntity:insertCharacter(char)
		end
	end

	function OSHandleKeystroke (keystroke) 
		local name = keys.getName(keystroke)
		if name == "left" then
			if OSSelectedEntity then
			OSSelectedEntity:moveCursor(-1)
			end
		elseif name == "right" then
			if OSSelectedEntity then
			OSSelectedEntity:moveCursor(1)
			end
		elseif name == "up" then
			if OSSelectedEntity then
			OSSelectedEntity:moveCursor(2)
			end
		elseif name == "down" then
			if OSSelectedEntity then
			OSSelectedEntity:moveCursor(-2)
			end
		elseif name == "backspace" then
			if OSSelectedEntity then
			OSSelectedEntity:removeCharacter (-1)
			end
		elseif name == "delete" then
			if OSSelectedEntity then
			OSSelectedEntity:removeCharacter (0)
			end
		elseif name == "enter" then
			if OSSelectedEntity then
				OSSelectedEntity:submit()
			end
		elseif keystroke == 219 or keystroke == 220 or name == "leftCtrl" or name == "rightCtrl" then
			OSCommandKeyTimer = os.startTimer(OSEvents.commandTimeout) 
		elseif not name == nil then
			if #name == 1 then -- a character
				if OSCommandKeyTimer then
				--if the user pressed the command key (presumably its still down)
				OSHandleKeyCommand(name:upper())
				end
			end
		else
		--		print(name)
		end
	end

	function OSHandleKeyCommand (key)
		local application = OSInterfaceApplications.current() --the current application
		if key == "R" and false then --this is disabled, enable it if you wish
			os.reboot()
		else
			if OSKeyboardShortcuts.list[key] then
				local action = OSKeyboardShortcuts.list[key]
				action()
			end
		end
		OSUpdate()
	end

	function OSHandleScroll (x, y, direction)
		--only windows are checked, only windows should have a scrolling view
		for _,application in pairs(OSInterfaceApplications.list) do
			for _,window in pairs(application.windows) do
				--check if the click overlaps an entities
				if OSEvents.pointOverlapsRect({x = x, y = y}, window)   then

					--give the window focus
					OSCurrentWindow = window
					--get the click position relative to the window
					local relativeX = x - window.x + 1
					local relativeY = y - window.y

					--if the y of the click was 0 (the window frame) do special actions
					if relativeY == 0 then

						if relativeX == 1 then --close button
						window:close()
						return
						elseif relativeX == 2 and window.canMinimise then --minimise button

						elseif relativeX == 3 and window.canMaximise then --maximise button

						else --main bar
						window.dragX = relativeX  + 1
						OSWindowDragTimer = os.startTimer(OSEvents.dragTimeout)
						end
					else -- it was in the window content
						for _,entity in pairs(window.entities) do

							--check if the click overlaps an entities
							if entity.canScroll == true and OSEvents.pointOverlapsRect({x = relativeX , y = relativeY }, entity)  then
								local newScroll = entity.scrollY - direction
								if newScroll >= entity.maxScrollY and newScroll <= 0  then
									entity.scrollY = newScroll
									OSUpdate()
								end

							end
						end
					end

				end
			end
		end
	end

	function OSHandleDrag (x,y)
		--check the window should be draged
		if OSWindowDragTimer and not OSFirstRunMode then
			OSCurrentWindow.x = x - OSCurrentWindow.dragX
			if y == 1 then
				y = 2
			end
			OSCurrentWindow.y = y  
			--update the time out
			OSWindowDragTimer = os.startTimer(OSEvents.dragTimeout)
			--redraw the screen
			OSUpdate()
		elseif OSWindowResizeTimer then
			--resize the window
			OSCurrentWindow:resize(x - OSCurrentWindow.x + 1, y - OSCurrentWindow.y + 1)
			--update the time out
			OSWindowResizeTimer = os.startTimer(OSEvents.dragTimeout)
		end
		if OSSelectedEntity then
			if OSEvents.pointOverlapsRect({x = x, y = y}, OSSelectedEntity)  then
				local endPos = x + (y * OSSelectedEntity.width)
				if OSSelectedEntity.drag then
					OSSelectedEntity:drag(x, y)
				end
				--OSSelectedEntity.Selection[2] = endPos
			end
		end
	end

	function EventHandler ()
		OSUpdateTimer = os.startTimer(OSEvents.updateFrequency)
		OSEvents.resetSleepTimer()
		while true do
			local event, arg, x, y = os.pullEventRaw()

			if event == "timer" then
			if arg == OSUpdateTimer then

				if not OSEvents.computerCraftMode then
					OSUpdate()
					if clock then
						clock:Draw()
					end
				end
				--[[
				It would be very easy to turn off constant refreshing. It would work, a few problems with the button selection colour prevent me from doing so.
				To switch, comment out OSUpdate
				]]
				OSUpdateTimer = os.startTimer(OSEvents.updateFrequency)
				elseif arg == OSWindowDragTimer then
				OSWindowDragTimer = nil
				elseif arg == OSCommandKeyTimer then
				OSCommandKeyTimer = nil
				elseif arg == OSWindowResizeTimer then
				OSWindowResizeTimer = nil
				elseif arg == OSSleepTimer then
			end
			elseif event == "char" then
				OSEvents.resetSleepTimer()
				OSHandleCharacter(arg)
			elseif event == "key" then
				OSEvents.resetSleepTimer()
				OSHandleKeystroke(arg)
			elseif event == "mouse_click"  then
				OSEvents.resetSleepTimer()
				if arg == 1 then --left click
					OSHandleClick(x, y)
				else --right click
				--os.reboot()
				end
			elseif event == "monitor_touch" then
				OSEvents.resetSleepTimer()
				OSHandleClick(x, y)
			elseif event == "mouse_drag" then
				OSEvents.resetSleepTimer()
				OSHandleDrag(x, y)
			elseif event == "mouse_scroll" then
				OSEvents.resetSleepTimer()
				OSHandleScroll(x, y, arg)
			else
			--	  			print(event)
			--	  			print(arg)
			end
		end
end