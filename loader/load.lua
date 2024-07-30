local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MenuButton = Instance.new("TextButton")
local MenuFrame = Instance.new("Frame")

ScreenGui.Name = "Library"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

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

MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
MenuFrame.BorderSizePixel = 0
MenuFrame.Position = UDim2.new(0, 0, 0, 0)
MenuFrame.Size = UDim2.new(1, 0, 1, 0)

local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    MenuButton.Text = MainFrame.Visible and "-" or "+"
end

MenuButton.MouseButton1Click:Connect(toggleMenu)

local SampleButton = Instance.new("TextButton")
SampleButton.Name = "SampleButton"
SampleButton.Parent = MenuFrame
SampleButton.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
SampleButton.BorderSizePixel = 0
SampleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
SampleButton.Size = UDim2.new(0.8, 0, 0.1, 0)
SampleButton.Font = Enum.Font.SourceSans
SampleButton.Text = "Sample Button"
SampleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SampleButton.TextSize = 24

SampleButton.MouseButton1Click:Connect(function()
    print("Sample button clicked")
end)

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
    button.TextSize = 24
    button.MouseButton1Click:Connect(callback)
end

addButton("Remote Spy", "Open Remote Spy", UDim2.new(0.1, 0, 0.25, 0), UDim2.new(0.8, 0, 0.1, 0), function()
    print("Remote Spy clicked")
end)

ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
