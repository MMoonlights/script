-- Check for mobile
local UserInputService = game:GetService("UserInputService")
local IsOnMobile = table.find({
    Enum.Platform.IOS,
    Enum.Platform.Android
}, UserInputService:GetPlatform())

-- Create the main UI elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local SideMenu = Instance.new("Frame")
local Header = Instance.new("Frame")
local MenuButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local DebuggersButton = Instance.new("TextButton")
local ACButton = Instance.new("TextButton")

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
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.ClipsDescendants = true

-- Set properties for SideMenu
SideMenu.Name = "SideMenu"
SideMenu.Parent = MainFrame
SideMenu.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
SideMenu.Size = UDim2.new(0.2, 0, 1, 0)
SideMenu.BorderSizePixel = 0

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
MenuButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    MenuButton.Text = MainFrame.Visible and "-" or "+"
end)

-- Set properties for CloseButton
CloseButton.Name = "CloseButton"
CloseButton.Parent = Header
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.95, -20, 0.5, -10)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MenuButton.Text = "+"
end)

-- Set properties for ContentFrame
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0.2, 0, 0, 50)
ContentFrame.Size = UDim2.new(0.8, 0, 1, -50)
ContentFrame.ClipsDescendants = true

-- Function to create side menu buttons
local function createSideButton(name, text, parent, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Create Debuggers and AC buttons in SideMenu
DebuggersButton = createSideButton("DebuggersButton", "Debuggers", SideMenu, function()
    ContentFrame:ClearAllChildren()
    -- Add your debugger buttons to ContentFrame
end)

ACButton = createSideButton("ACButton", "AC", SideMenu, function()
    ContentFrame:ClearAllChildren()
    -- Add your anti-cheat buttons to ContentFrame
end)

-- Function to add buttons to the ContentFrame
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
DebuggersButton.MouseButton1Click:Connect(function()
    ContentFrame:ClearAllChildren()
    addButton("SimpleSpyButton", "SimpleSpy", ContentFrame, function()
        if IsOnMobile then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/SimpleSpyV3/mobilemain.lua"))()
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
        end
    end)
    addButton("DexButton", "Dex", ContentFrame, function()
        if IsOnMobile then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/Dex/Mobile%20Dex%20Explorer.txt"))()
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end
    end)
    addButton("GameUIViewButton", "Game UI/Frame Viewer", ContentFrame, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gameuigiver.lua"))()
    end)
    addButton("GameToolEquipperButton", "Game Tool Equipper", ContentFrame, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/gametoolequipper.lua"))()
    end)
end)

-- Add buttons to AC section
ACButton.MouseButton1Click:Connect(function()
    ContentFrame:ClearAllChildren()
    addButton("AntiKickButton", "Anti Kick", ContentFrame, function()
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
    addButton("BypassAntiCheatsButton", "Bypass AntiCheats/Kicks", ContentFrame, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ADSKerOffical/AntiCheat/main/Bypass"))()
    end)
    addButton("BypassAdonisButton1", "Bypass Adonis v1", ContentFrame, function()
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
                            if DEBUG then warn("Bypassing:", Action, Info, NoCrash) end
                            return nil
                        end
                        return Old(Action, Info, NoCrash)
                    end)
                end
                if typeof(KillFunc) == "function" and not Kill then
                    Kill = KillFunc
                    local Old; Old = hookfunction(Kill, function(...)
                        if DEBUG then warn("Bypassing:", ...) end
                        return nil
                    end)
                end
            end
        end
        setthreadidentity(7)
    end)
    addButton("AntiLockButton", "Anti Lock", ContentFrame, function()
        local Players = game:GetService("Players")
        local Client = Players.LocalPlayer
        local OldGetPropertyChangedSignal = Client.GetPropertyChangedSignal
        local OldChanged = Client.Changed
        local OldKick = Client.Kick
        local OldKickWithMessage = Client.KickWithMessage

        Client.GetPropertyChangedSignal = function(self, property)
            if property == "Locked" then
                return Instance.new("BindableEvent").Event
            end
            return OldGetPropertyChangedSignal(self, property)
        end

        Client.Changed = function(self, property)
            if property == "Locked" then
                return nil
            end
            return OldChanged(self, property)
        end

        Client.Kick = function(self, reason)
            return nil
        end

        Client.KickWithMessage = function(self, message)
            return nil
        end
    end)
end)

return ScreenGui

-- Show the initial UI
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
MainFrame:TweenPosition(UDim2.new(0.5, -150, 0.5, -200), "Out", "Quad", 0.5, true)
MainFrame.Visible = true
MenuButton.Text = "-"
