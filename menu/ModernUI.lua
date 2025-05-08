local ModernUI = {}
ModernUI.__index = ModernUI

-- Colors and Theme
local Theme = {
    Primary = Color3.fromRGB(45, 45, 45),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 120, 215),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(60, 60, 60)
}

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- Window Creation
function ModernUI.new(title)
    local self = setmetatable({}, ModernUI)
    
    -- Main ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = "ModernUI",
        ResetOnSpawn = false
    })
    
    -- Main Frame
    self.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0
    })
    
    -- Title Bar
    self.TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0
    })
    
    self.Title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold
    })
    
    -- Tab Container
    self.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 120, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0
    })
    
    -- Content Container
    self.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -120, 1, -40),
        Position = UDim2.new(0, 120, 0, 40),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0
    })
    
    -- Parent everything
    self.TitleBar.Parent = self.MainFrame
    self.Title.Parent = self.TitleBar
    self.TabContainer.Parent = self.MainFrame
    self.ContentContainer.Parent = self.MainFrame
    self.MainFrame.Parent = self.ScreenGui
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Initialize tabs
    self.Tabs = {}
    self.CurrentTab = nil
    
    return self
end

-- Tab Creation
function ModernUI:NewTab(name)
    local tab = {
        Name = name,
        Button = CreateInstance("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Theme.Secondary,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham
        }),
        Content = CreateInstance("ScrollingFrame", {
            Name = name .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
    }
    
    tab.Button.Parent = self.TabContainer
    tab.Content.Parent = self.ContentContainer
    
    table.insert(self.Tabs, tab)
    
    -- Tab switching logic
    tab.Button.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Button.BackgroundColor3 = Theme.Secondary
            t.Content.Visible = false
        end
        tab.Button.BackgroundColor3 = Theme.Accent
        tab.Content.Visible = true
        self.CurrentTab = tab
    end)
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        tab.Button.BackgroundColor3 = Theme.Accent
        tab.Content.Visible = true
        self.CurrentTab = tab
    else
        tab.Content.Visible = false
    end
    
    return tab
end

-- Section Creation
function ModernUI:NewSection(tab, name)
    local section = {
        Name = name,
        Frame = CreateInstance("Frame", {
            Name = name,
            Size = UDim2.new(1, -20, 0, 0),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundColor3 = Theme.Secondary,
            BorderSizePixel = 0
        })
    }
    
    local title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    
    title.Parent = section.Frame
    section.Frame.Parent = tab.Content
    
    return section
end

-- Control Creation Functions
function ModernUI:NewButton(section, name, callback)
    local button = CreateInstance("TextButton", {
        Name = name,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, section.Frame.Size.Y.Offset + 10),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham
    })
    
    button.MouseButton1Click:Connect(callback)
    button.Parent = section.Frame
    
    -- Update section size
    section.Frame.Size = UDim2.new(1, -20, 0, section.Frame.Size.Y.Offset + 50)
    
    return button
end

function ModernUI:NewSlider(section, name, min, max, default, callback)
    local slider = {
        Name = name,
        Frame = CreateInstance("Frame", {
            Name = name,
            Size = UDim2.new(1, -20, 0, 60),
            Position = UDim2.new(0, 10, 0, section.Frame.Size.Y.Offset + 10),
            BackgroundTransparency = 1
        })
    }
    
    local title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham
    })
    
    local value = CreateInstance("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -50, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local track = CreateInstance("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0
    })
    
    local fill = CreateInstance("Frame", {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0
    })
    
    local handle = CreateInstance("Frame", {
        Name = "Handle",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 0, 0.5, -6),
        BackgroundColor3 = Theme.Text,
        BorderSizePixel = 0
    })
    
    title.Parent = slider.Frame
    value.Parent = slider.Frame
    track.Parent = slider.Frame
    fill.Parent = track
    handle.Parent = track
    slider.Frame.Parent = section.Frame
    
    -- Slider logic
    local dragging = false
    local currentValue = default
    
    local function updateSlider(x)
        local relativeX = math.clamp(x - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local percentage = relativeX / track.AbsoluteSize.X
        local newValue = math.floor(min + (max - min) * percentage)
        
        if newValue ~= currentValue then
            currentValue = newValue
            value.Text = tostring(newValue)
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            handle.Position = UDim2.new(percentage, -6, 0.5, -6)
            callback(newValue)
        end
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    
    -- Update section size
    section.Frame.Size = UDim2.new(1, -20, 0, section.Frame.Size.Y.Offset + 80)
    
    return slider
end

function ModernUI:NewToggle(section, name, default, callback)
    local toggle = {
        Name = name,
        Frame = CreateInstance("Frame", {
            Name = name,
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, section.Frame.Size.Y.Offset + 10),
            BackgroundTransparency = 1
        })
    }
    
    local title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -40, 0, 30),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham
    })
    
    local button = CreateInstance("TextButton", {
        Name = "Toggle",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = default and Theme.Accent or Theme.Secondary,
        BorderSizePixel = 0,
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham
    })
    
    title.Parent = toggle.Frame
    button.Parent = toggle.Frame
    toggle.Frame.Parent = section.Frame
    
    -- Toggle logic
    local enabled = default
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.BackgroundColor3 = enabled and Theme.Accent or Theme.Secondary
        callback(enabled)
    end)
    
    -- Update section size
    section.Frame.Size = UDim2.new(1, -20, 0, section.Frame.Size.Y.Offset + 50)
    
    return toggle
end

return ModernUI 