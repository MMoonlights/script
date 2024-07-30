-- Check for mobile
local UserInputService = game:GetService("UserInputService")
local IsOnMobile = table.find({
	Enum.Platform.IOS,
	Enum.Platform.Android
}, UserInputService:GetPlatform())

-- Create the main UI elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local MenuButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local MenuFrame = Instance.new("Frame")
local DebuggersButton = Instance.new("TextButton")
local ACButton = Instance.new("TextButton")
local DebuggersFrame = Instance.new("Frame")
local ACFrame = Instance.new("Frame")

-- Set properties for ScreenGui
ScreenGui.Name = "MobileUILibrary"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Set properties for MainFrame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

-- Set properties for Header
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)

-- Set properties for MenuButton
MenuButton.Name = "MenuButton"
MenuButton.Parent = ScreenGui
MenuButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
MenuButton.BackgroundTransparency = 0.3
MenuButton.BorderSizePixel = 0
MenuButton.Position = UDim2.new(0, 10, 0, 10)
MenuButton.Size = UDim2.new(0, 50, 0, 50)
MenuButton.Font = Enum.Font.SourceSans
MenuButton.Text = "+"
MenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuButton.TextSize = 24
MenuButton.Active = true
MenuButton.Draggable = true

-- Set properties for CloseButton
CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BackgroundTransparency = 0.3
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.9, -10, 0.5, -10)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

-- Set properties for MenuFrame
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
MenuFrame.BackgroundTransparency = 0.3
MenuFrame.BorderSizePixel = 0
MenuFrame.Position = UDim2.new(0, 0, 0, 50)
MenuFrame.Size = UDim2.new(1, 0, 1, -50)

-- Set properties for DebuggersButton
DebuggersButton.Name = "DebuggersButton"
DebuggersButton.Parent = MenuFrame
DebuggersButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
DebuggersButton.BackgroundTransparency = 0.3
DebuggersButton.BorderSizePixel = 0
DebuggersButton.Position = UDim2.new(0.05, 0, 0.05, 0)
DebuggersButton.Size = UDim2.new(0.4, 0, 0.15, 0)
DebuggersButton.Font = Enum.Font.SourceSans
DebuggersButton.Text = "Debuggers"
DebuggersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DebuggersButton.TextSize = 18

-- Set properties for ACButton
ACButton.Name = "ACButton"
ACButton.Parent = MenuFrame
ACButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
ACButton.BackgroundTransparency = 0.3
ACButton.BorderSizePixel = 0
ACButton.Position = UDim2.new(0.55, 0, 0.05, 0)
ACButton.Size = UDim2.new(0.4, 0, 0.15, 0)
ACButton.Font = Enum.Font.SourceSans
ACButton.Text = "AC"
ACButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ACButton.TextSize = 18

-- Create frames for Debuggers and AC sections
DebuggersFrame.Name = "DebuggersFrame"
DebuggersFrame.Parent = MenuFrame
DebuggersFrame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
DebuggersFrame.BackgroundTransparency = 0.3
DebuggersFrame.BorderSizePixel = 0
DebuggersFrame.Position = UDim2.new(0, 0, 0.25, 0)
DebuggersFrame.Size = UDim2.new(1, 0, 0.75, 0)
DebuggersFrame.Visible = false

ACFrame.Name = "ACFrame"
ACFrame.Parent = MenuFrame
ACFrame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
ACFrame.BackgroundTransparency = 0.3
ACFrame.BorderSizePixel = 0
ACFrame.Position = UDim2.new(0, 0, 0.25, 0)
ACFrame.Size = UDim2.new(1, 0, 0.75, 0)
ACFrame.Visible = false

-- Add animations for buttons
local function animateButton(button)
	button.MouseEnter:Connect(function()
		button:TweenSize(UDim2.new(0.45, 0, 0.2, 0), "Out", "Quad", 0.2, true)
	end)
	button.MouseLeave:Connect(function()
		button:TweenSize(UDim2.new(0.4, 0, 0.15, 0), "Out", "Quad", 0.2, true)
	end)
end

animateButton(DebuggersButton)
animateButton(ACButton)

-- Function to toggle the menu
local function toggleMenu()
	if MainFrame.Visible then
		MainFrame:TweenPosition(UDim2.new(0.5, -150, 1.5, -200), "Out", "Quad", 0.5, true, function()
			MainFrame.Visible = false
		end)
	else
		MainFrame.Visible = true
		MainFrame:TweenPosition(UDim2.new(0.5, -150, 0.5, -200), "Out", "Quad", 0.5, true)
	end
	MenuButton.Text = MainFrame.Visible and "-" or "+"
end

MenuButton.MouseButton1Click:Connect(toggleMenu)

-- Function to close the menu
CloseButton.MouseButton1Click:Connect(function()
	MainFrame:TweenPosition(UDim2.new(0.5, -150, 1.5, -200), "Out", "Quad", 0.5, true, function()
		MainFrame.Visible = false
		MenuButton.Visible = false
	end)
end)

-- Show Debuggers section
DebuggersButton.MouseButton1Click:Connect(function()
	DebuggersFrame.Visible = true
	ACFrame.Visible = false
end)

-- Show AC section
ACButton.MouseButton1Click:Connect(function()
	DebuggersFrame.Visible = false
	ACFrame.Visible = true
end)

-- Function to add buttons
local function addButton(name, text, parentFrame, callback)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Parent = parentFrame
	button.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
	button.BackgroundTransparency = 0.3
	button.BorderSizePixel = 0
	button.Size = UDim2.new(0.9, 0, 0, 40)
	button.Position = UDim2.new(0.05, 0, 0.05, (#parentFrame:GetChildren() - 1) * 45)
	button.Font = Enum.Font.SourceSans
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 18
	button.MouseButton1Click:Connect(callback)
end

-- Add buttons to Debuggers section
addButton("SimpleSpyButton", "SimpleSpy", DebuggersFrame, function()
	if IsOnMobile then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/SimpleSpyV3/mobilemain.lua"))()
	else
		loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
	end
end)

addButton("DexButton", "Dex", DebuggersFrame, function()
	if IsOnMobile then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/Dex/Mobile%20Dex%20Explorer.txt"))()
	else
		loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
	end
end)

addButton("GameUIViewButton", "Game UI/Frame Viewer", DebuggersFrame, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gameuigiver.lua"))()
end)

addButton("GameToolEquipperButton", "Game Tool Equipper", DebuggersFrame, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gametoolequipper.lua"))()
end)

-- Add buttons to AC section
addButton("AntiKickButton", "Anti Kick", ACFrame, function()
	local mt = getrawmetatable(game)
	setreadonly(mt, false)
	local oldmt = mt.__namecall
	mt.__namecall = newcclosure(function(Self, ...)
		local method = getnamecallmethod()
		if method == 'Kick' then
			print("Tried to kick")
			wait(9e9)
			return nil
		end
		return oldmt(Self, ...)
	end)
	setreadonly(mt, true)
end)

addButton("BypassAntiCheatsButton", "Bypass AntiCheats/Kicks", ACFrame, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/AntiCheat/main/Bypass"))()
end)

addButton("BypassAdonisButton1", "Bypass Adonis v1", ACFrame, function()
	local getinfo = getinfo or debug.getinfo
	local DEBUG = false
	local Hooked = {}
	local Detected, Kill
	setthreadidentity(2)
	for i, v in getgc(true) do
		if typeof(v) == "table" then
			local DetectFunc = rawget(v, "Detected")
			local KillFunc = rawget(v, "Kill")
			if typeof(DetectFunc) == "function" and not Detected then
				Detected = DetectFunc
				local Old; Old = hookfunction(Detected, function(Action, Info, NoCrash)
					if Action ~= "_" then
						if DEBUG then
							warn(`Adonis AntiCheat flagged\nMethod: {Action}\nInfo: {Info}`)
						end
					end
					return true
				end)
				table.insert(Hooked, Detected)
			end
			if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
				Kill = KillFunc
				local Old; Old = hookfunction(Kill, function(Info)
					if DEBUG then
						warn(`Adonis AntiCheat tried to kill (fallback): {Info}`)
					end
				end)
				table.insert(Hooked, Kill)
			end
		end
	end
	local Old; Old = hookfunction(getrenv().debug.info, newcclosure(function(...)
		local LevelOrFunc, Info = ...
		if Detected and LevelOrFunc == Detected then
			if DEBUG then
				warn(`zins | adonis bypassed`)
			end
			return coroutine.yield(coroutine.running())
		end
		return Old(...)
	end))
	setthreadidentity(7)
end)

addButton("BypassAdonisButton2", "Bypass Adonis v2", ACFrame, function()
	local players = game:GetService('Players')
	local lplr = players.LocalPlayer
	local lastCF, stop, heartbeatConnection
	local function start()
		heartbeatConnection = game:GetService('RunService').Heartbeat:Connect(function()
			if stop then return end
			lastCF = lplr.Character:FindFirstChildOfClass('Humanoid').RootPart.CFrame
		end)
		lplr.Character:FindFirstChildOfClass('Humanoid').RootPart:GetPropertyChangedSignal('CFrame'):Connect(function()
			stop = true
			lplr.Character:FindFirstChildOfClass('Humanoid').RootPart.CFrame = lastCF
			game:GetService('RunService').Heartbeat:Wait()
			stop = false
		end)
		lplr.Character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
			heartbeatConnection:Disconnect()
		end)
	end
	lplr.CharacterAdded:Connect(function(character)
		repeat game:GetService('RunService').Heartbeat:Wait() until character:FindFirstChildOfClass('Humanoid')
		repeat game:GetService('RunService').Heartbeat:Wait() until character:FindFirstChildOfClass('Humanoid').RootPart
		start()
	end)
	lplr.CharacterRemoving:Connect(function()
		heartbeatConnection:Disconnect()
	end)
	start()
end)

-- Add the UI to the player's screen
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
