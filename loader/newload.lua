local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MainButton = Instance.new("TextButton")
local MenuFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local DexButton = Instance.new("TextButton")
local SimpleSpyButton = Instance.new("TextButton")
local GuiViewButton = Instance.new("TextButton")
local ToolEquipButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.Size = UDim2.new(0, 200, 0, 50)
MainFrame.Visible = true

MainButton.Name = "MainButton"
MainButton.Parent = MainFrame
MainButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainButton.Size = UDim2.new(0, 200, 0, 50)
MainButton.Font = Enum.Font.SourceSans
MainButton.Text = "Open Menu"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 18.0

-- Menu Frame
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = ScreenGui
MenuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MenuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MenuFrame.Size = UDim2.new(0, 300, 0, 400)
MenuFrame.Visible = false

Title.Name = "Title"
Title.Parent = MenuFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(0, 300, 0, 50)
Title.Font = Enum.Font.SourceSans
Title.Text = "Main"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18.0

DexButton.Name = "DexButton"
DexButton.Parent = MenuFrame
DexButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DexButton.Position = UDim2.new(0, 0, 0, 60)
DexButton.Size = UDim2.new(0, 300, 0, 50)
DexButton.Font = Enum.Font.SourceSans
DexButton.Text = "Dex"
DexButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DexButton.TextSize = 18.0

SimpleSpyButton.Name = "SimpleSpyButton"
SimpleSpyButton.Parent = MenuFrame
SimpleSpyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SimpleSpyButton.Position = UDim2.new(0, 0, 0, 120)
SimpleSpyButton.Size = UDim2.new(0, 300, 0, 50)
SimpleSpyButton.Font = Enum.Font.SourceSans
SimpleSpyButton.Text = "SimpleSpy"
SimpleSpyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SimpleSpyButton.TextSize = 18.0

GuiViewButton.Name = "GuiViewButton"
GuiViewButton.Parent = MenuFrame
GuiViewButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GuiViewButton.Position = UDim2.new(0, 0, 0, 180)
GuiViewButton.Size = UDim2.new(0, 300, 0, 50)
GuiViewButton.Font = Enum.Font.SourceSans
GuiViewButton.Text = "Gui View"
GuiViewButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GuiViewButton.TextSize = 18.0

ToolEquipButton.Name = "ToolEquipButton"
ToolEquipButton.Parent = MenuFrame
ToolEquipButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToolEquipButton.Position = UDim2.new(0, 0, 0, 240)
ToolEquipButton.Size = UDim2.new(0, 300, 0, 50)
ToolEquipButton.Font = Enum.Font.SourceSans
ToolEquipButton.Text = "Tool Equip"
ToolEquipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolEquipButton.TextSize = 18.0

-- Button Functions
MainButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
end)

DexButton.MouseButton1Click:Connect(function()
    print("Dex Executed")
    -- Place Dex execution code here
end)

SimpleSpyButton.MouseButton1Click:Connect(function()
    print("SimpleSpy Executed")
    -- Place SimpleSpy execution code here
end)

GuiViewButton.MouseButton1Click:Connect(function()
    print("Gui View Executed")
    -- Place Gui View execution code here
end)

ToolEquipButton.MouseButton1Click:Connect(function()
    print("Tool Equip Executed")
    -- Place Tool Equip execution code here
end)
