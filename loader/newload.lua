local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local IsOnMobile = table.find({
    Enum.Platform.IOS,
    Enum.Platform.Android
}, UserInputService:GetPlatform())

-- Create the main UI elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local MainButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local DexFrame = Instance.new("Frame")
local DexButton = Instance.new("TextButton")
local LoadDexButton = Instance.new("TextButton")
local DexDescription = Instance.new("TextLabel")

-- Set properties for ScreenGui
ScreenGui.Name = "CustomUILibrary"
ScreenGui.Parent = game:GetService("CoreGui")

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

-- Set properties for MainButton
MainButton.Name = "MainButton"
MainButton.Parent = ScreenGui
MainButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
MainButton.BackgroundTransparency = 0.3
MainButton.BorderSizePixel = 0
MainButton.Position = UDim2.new(0, 10, 0, 10)
MainButton.Size = UDim2.new(0, 50, 0, 50)
MainButton.Font = Enum.Font.SourceSans
MainButton.Text = "Main"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 24
MainButton.Active = true
MainButton.Draggable = true

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

-- Set properties for DexFrame
DexFrame.Name = "DexFrame"
DexFrame.Parent = MainFrame
DexFrame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
DexFrame.BackgroundTransparency = 0.3
DexFrame.BorderSizePixel = 0
DexFrame.Position = UDim2.new(0, 0, 0, 50)
DexFrame.Size = UDim2.new(1, 0, 0, 150)

-- Set properties for DexButton
DexButton.Name = "DexButton"
DexButton.Parent = DexFrame
DexButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
DexButton.BackgroundTransparency = 0.3
DexButton.BorderSizePixel = 0
DexButton.Position = UDim2.new(0.05, 0, 0.2, 0)
DexButton.Size = UDim2.new(0.9, 0, 0, 40)
DexButton.Font = Enum.Font.SourceSans
DexButton.Text = "Dex"
DexButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DexButton.TextSize = 18

-- Set properties for DexDescription
DexDescription.Name = "DexDescription"
DexDescription.Parent = DexFrame
DexDescription.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
DexDescription.BackgroundTransparency = 0.3
DexDescription.BorderSizePixel = 0
DexDescription.Position = UDim2.new(0.05, 0, 0.4, 0)
DexDescription.Size = UDim2.new(0.9, 0, 0, 20)
DexDescription.Font = Enum.Font.SourceSans
DexDescription.Text = "(Dex explorer)"
DexDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
DexDescription.TextSize = 14

-- Set properties for LoadDexButton
LoadDexButton.Name = "LoadDexButton"
LoadDexButton.Parent = DexFrame
LoadDexButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
LoadDexButton.BackgroundTransparency = 0.3
LoadDexButton.BorderSizePixel = 0
LoadDexButton.Position = UDim2.new(0.05, 0, 0.7, 0)
LoadDexButton.Size = UDim2.new(0.9, 0, 0, 40)
LoadDexButton.Font = Enum.Font.SourceSans
LoadDexButton.Text = "Load"
LoadDexButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadDexButton.TextSize = 18

-- Add animations
local function animateOpen(frame)
    frame.Visible = true
    frame.Position = UDim2.new(0.5, -150, 1.5, 0)
    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 0.5, -200)}):Play()
end

local function animateClose(frame)
    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -150, 1.5, 0)}):Play()
    wait(0.5)
    frame.Visible = false
end

-- Function to toggle the menu
local function toggleMenu()
    if MainFrame.Visible then
        animateClose(MainFrame)
    else
        animateOpen(MainFrame)
    end
end

MainButton.MouseButton1Click:Connect(toggleMenu)

-- Function to close the menu
CloseButton.MouseButton1Click:Connect(function()
    animateClose(MainFrame)
end)

-- Load Dex script
LoadDexButton.MouseButton1Click:Connect(function()
    if IsOnMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub-Backup/main/Dex/Mobile%20Dex%20Explorer.txt"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end
end)

-- Add the UI to the player's screen
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
