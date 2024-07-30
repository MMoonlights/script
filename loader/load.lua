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
local HideButton = Instance.new("TextButton")
local MenuFrame = Instance.new("ScrollingFrame")

-- Set properties for ScreenGui
ScreenGui.Name = "MobileUILibrary"
ScreenGui.Parent = game:GetService("CoreGui")

-- Set properties for MainFrame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
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
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)

-- Set properties for MenuButton
MenuButton.Name = "MenuButton"
MenuButton.Parent = ScreenGui
MenuButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
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
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.9, -10, 0.5, -10)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

-- Set properties for HideButton
HideButton.Name = "HideButton"
HideButton.Parent = Header
HideButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
HideButton.BorderSizePixel = 0
HideButton.Position = UDim2.new(0.8, -10, 0.5, -10)
HideButton.Size = UDim2.new(0, 20, 0, 20)
HideButton.Font = Enum.Font.SourceSans
HideButton.Text = "-"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 14

-- Set properties for MenuFrame
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
MenuFrame.BorderSizePixel = 0
MenuFrame.Position = UDim2.new(0, 0, 0, 50)
MenuFrame.Size = UDim2.new(1, 0, 1, -50)
MenuFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
MenuFrame.ScrollBarThickness = 6

-- Function to toggle the menu
local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    MenuButton.Text = MainFrame.Visible and "-" or "+"
end

MenuButton.MouseButton1Click:Connect(toggleMenu)

-- Function to close the menu
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MenuButton.Visible = false
end)

-- Function to hide the menu
HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Function to add buttons
local function addButton(name, text, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = MenuFrame
    button.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0.05, (#MenuFrame:GetChildren() - 1) * 45)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.MouseButton1Click:Connect(callback)
end

-- Add the specified buttons
addButton("SimpleSpyButton", "SimpleSpy", function()
    if IsOnMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/SimpleSpyV3/mobilemain.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
    end
end)

addButton("DexButton", "Dex", function()
    if IsOnMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/Dex/Mobile%20Dex%20Explorer.txt"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
end)

addButton("AntiKickButton", "Anti Kick", function()
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

addButton("BypassAntiCheatsButton", "Bypass Ac", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/AntiCheat/main/Bypass"))()
end)

addButton("GameUIViewButton", "Game UI/Frame Viewer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gameuigiver.lua"))()
end)

addButton("GameToolEquipperButton", "Game Tool Equipper", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gametoolequipper.lua"))()
end)

addButton("BypassAdonisButton1", "Bypass Adonis v1", function()
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

addButton("BypassAdonisButton2", "Bypass Adonis v2", function()
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
