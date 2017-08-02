
	name = "About PearOS"
	menus = {}
	windows = {}
	id = 0
	author = "oeed, nk2"
	mainMenu = {
		OSMenuItem:new("More info ", function ()  end)
	}

	function getCenter(_width, _length)
		return math.ceil((_width - _length) / 2)
	end

	init = function()
		local versionText = "Version "..OSVersionLong
		local versionLabel = OSLabel:new(getCenter(20, #versionText), 9, versionText)
		versionLabel.TextColour = colours.grey

		local copyrightLabel = OSLabel:new(4, 10, "Copyright 2xxx")
		copyrightLabel.TextColour = colours.lightGrey

		windows['aboutSystem'] = OSWindow:new(name,{
			OSImageView:new(8, 2, "System/Library/Interface/logo"),
			OSLabel:new(getCenter(20, #name), 7, name ),
			
			versionLabel,
			copyrightLabel,
			OSLabel:new(getCenter(20, #author)+1, 11, author),
		}, 20, 11,environment)
		windows['aboutSystem'].canMaximise = false

	end
	
	function windowDidClose(self)
		environment:quit()
	end