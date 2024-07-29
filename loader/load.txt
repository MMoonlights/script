local UserInputService = game:GetService("UserInputService")
local IsOnMobile = table.find({
	Enum.Platform.IOS,
	Enum.Platform.Android
}, UserInputService:GetPlatform())

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
	Title = "Debuggers",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = false,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Discord = Window:AddTab({
	Title = "Discords",
	Icon = "globe"
})

Discord:AddButton({
	Title = "Discord Invite",
	Description = "Copies Discord invite link",
	Callback = function()
		setclipboard("https://discord.gg/your-invite-link")
	end
})

local Debugs = Window:AddTab({
	Title = "Debuggers",
	Icon = "globe"
})

Debugs:AddButton({
	Title = "IY",
	Description = "Helps with noclip and faster actions",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end
})

Debugs:AddButton({
	Title = "Dex",
	Description = "Explorer",
	Callback = function()
		if IsOnMobile then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/Dex/Mobile%20Dex%20Explorer.txt"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
		end
	end
})

Debugs:AddButton({
	Title = "SimpleSpy V3",
	Description = "Logs Remotes, you may get kicked if they have good AC or namecall detection",
	Callback = function()
		if IsOnMobile then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/SimpleSpyV3/mobilemain.lua"))()
		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
		end
	end
})

Debugs:AddButton({
	Title = "Game Tool Giver",
	Description = "A GUI that gives you tools found in the game by putting it in your backpack.",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gametoolgiver.lua"))()
	end
})

Debugs:AddButton({
	Title = "Game Tool Equipper",
	Description = "A GUI that equips the tool found in the game.",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gametoolequipper.lua"))()
	end
})

Debugs:AddButton({
	Title = "Game UI/Frame Viewer",
	Description = "A GUI that allows you to toggle and see hidden guis found in the game.",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gameuigiver.lua"))()
	end
})

Debugs:AddInput({
	Title = "GUI Stealer",
	Default = "Put name of gui u want to convert must be screengui",
	Placeholder = "Put name of gui u want to convert must be screengui",
	Numeric = false, -- Only allows numbers
	Finished = false, -- Only calls callback when you press enter
	Callback = function(Value)
		local UIPath
		for i,v in pairs(game:GetDescendants()) do
			if v.Name == Value and v:IsA("ScreenGui") then
				UIPath = v
			end
		end
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/debugnation/main/decompilers%20and%20debugging/guistealer.txt"))()
	end
})
