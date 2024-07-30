-- Check for mobile
UserInputService = game:GetService("UserInputService")
local IsOnMobile = table.find({
	Enum.Platform.IOS,
	Enum.Platform.Android
}, UserInputService:GetPlatform())

-- Create the main UI elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MenuButton = Instance.new("TextButton")
local MenuFrame = Instance.new("Frame")

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

-- Set properties for MenuFrame
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
MenuFrame.BorderSizePixel = 0
MenuFrame.Position = UDim2.new(0, 0, 0, 0)
MenuFrame.Size = UDim2.new(1, 0, 1, 0)

-- Function to toggle the menu
local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    MenuButton.Text = MainFrame.Visible and "-" or "+"
end

MenuButton.MouseButton1Click:Connect(toggleMenu)

-- Function to add buttons
local function addButton(name, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = MenuFrame
    button.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = size
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.MouseButton1Click:Connect(callback)
end

-- Add the specified buttons
addButton("DexButton", "Dex", UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    if IsOnMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/Dex/Mobile%20Dex%20Explorer.txt"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
end)

addButton("SimpleSpyButton", "SimpleSpy", UDim2.new(0.1, 0, 0.25, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    if IsOnMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/SimpleSpyV3/mobilemain.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
    end
end)

addButton("HydroxideButton", "Hydroxide", UDim2.new(0.1, 0, 0.4, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    local owner = "Upbolt"
    local branch = "revision"
    local function webImport(file)
        return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
    end
    webImport("init")
    webImport("ui/main")
end)

addButton("AntiKickButton", "Anti Kick", UDim2.new(0.1, 0, 0.55, 0), UDim2.new(0.8, 0, 0.1, 0), function()
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

addButton("BypassAntiCheatsButton", "Bypass AntiCheats/Kicks", UDim2.new(0.1, 0, 0.7, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/AntiCheat/main/Bypass"))()
end)

addButton("BypassAdonisButton1", "Bypass Adonis (1)", UDim2.new(0.1, 0, 0.85, 0), UDim2.new(0.8, 0, 0.1, 0), function()
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

addButton("BypassAdonisButton2", "Bypass Adonis (2)", UDim2.new(0.1, 0, 1, 0), UDim2.new(0.8, 0, 0.1, 0), function()
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

addButton("SimpleSpyV3Button", "SimpleSpy V3", UDim2.new(0.1, 0, 1.15, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    if IsOnMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/SimpleSpyV3/mobilemain.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
    end
end)

addButton("DexV2Button", "Dex V2", UDim2.new(0.1, 0, 1.3, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    if IsOnMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/Dex/Mobile%20Dex%20Explorer.txt"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
end)

addButton("GameUIViewButton", "Game UI/Frame Viewer", UDim2.new(0.1, 0, 1.45, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gameuigiver.lua"))()
end)

addButton("GameToolEquipperButton", "Game Tool Equipper", UDim2.new(0.1, 0, 1.6, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gametoolequipper.lua"))()
end)

-- Add the UI to the player's screen
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
