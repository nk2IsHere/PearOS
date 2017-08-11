--OSServices--
	
	shutdown = function()
		shell.run("System/Library/Computer/Shutdown")
	end
	
	restart = function()
		shell.run("System/Library/Computer/Restart")
	end
	
	switchScreen = function()
		shell.run("System/Library/Computer/SwitchScreen")
		OSServices.rescheduleTimer()
	end
	
	compactArray = function (table) --remove any array items set as nil
		local j=0
		for i=1, #table do
			if table[i]~=nil then
				j=j+1
				table[j]=table[i]
			end
		end
		for i=j+1, #table do
			table[i]=nil
		end
		return table
	end
	
	removeTableItem = function(_table, _item)
		for _,item in ipairs(_table) do
			if item == _item then
				table.remove(_table, _)
			end
		end
	end
	
	--copied from http://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
	copyTable =function(t)
		local u = { }
		for k, v in pairs(t) do
			u[k] = v
		end
		return setmetatable(u, getmetatable(t))
	end
	
	longestStringInArray = function(input)
		local length = 0
		for i = 1, #input do
			--if the string length is larger then the set length reset it
			local titleLength = string.len(input[i].title)
			if titleLength > length then
				length = titleLength
			end
		end
		return length
	end
	
	availableScreenSize = function()
		local w, h = term.getSize()
		return w, h - 4
	end
	
	round = function(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	split = function(str, sep)
		local sep, fields = sep or ":", {}
		local pattern = string.format("([^%s]+)", sep)
		str:gsub(pattern, function(c) fields[#fields+1] = c end)
		return fields
	end