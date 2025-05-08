local Orbit = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utility Functions
local Utils = {}

function Utils:Tween(obj, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utils:MakeDraggable(frame, handle)
    handle = handle or frame
    
    local dragging = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Utils:Ripple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.Position = UDim2.fromOffset(Mouse.X - button.AbsolutePosition.X, Mouse.Y - button.AbsolutePosition.Y)
    ripple.Size = UDim2.fromScale(0, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    ripple.Parent = button
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Utils:Tween(ripple, {Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Темы
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(35, 35, 40),
        Secondary = Color3.fromRGB(45, 45, 50),
        Accent = Color3.fromRGB(100, 100, 225),
        Text = Color3.fromRGB(235, 235, 235),
        DimText = Color3.fromRGB(175, 175, 175),
        StrokeColor = Color3.fromRGB(65, 65, 70)
    },
    Light = {
        Primary = Color3.fromRGB(235, 235, 235),
        Secondary = Color3.fromRGB(245, 245, 245),
        Accent = Color3.fromRGB(70, 70, 225),
        Text = Color3.fromRGB(50, 50, 50),
        DimText = Color3.fromRGB(120, 120, 120),
        StrokeColor = Color3.fromRGB(200, 200, 200)
    },
    Midnight = {
        Primary = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(90, 90, 180),
        Text = Color3.fromRGB(230, 230, 230),
        DimText = Color3.fromRGB(170, 170, 170),
        StrokeColor = Color3.fromRGB(50, 50, 65)
    },
    Aqua = {
        Primary = Color3.fromRGB(30, 40, 45),
        Secondary = Color3.fromRGB(35, 45, 50),
        Accent = Color3.fromRGB(60, 170, 200),
        Text = Color3.fromRGB(235, 235, 235),
        DimText = Color3.fromRGB(175, 175, 175),
        StrokeColor = Color3.fromRGB(55, 65, 70)
    },
    Rose = {
        Primary = Color3.fromRGB(45, 35, 40),
        Secondary = Color3.fromRGB(50, 40, 45),
        Accent = Color3.fromRGB(200, 90, 120),
        Text = Color3.fromRGB(235, 235, 235),
        DimText = Color3.fromRGB(180, 170, 175),
        StrokeColor = Color3.fromRGB(70, 60, 65)
    },
    Forest = {
        Primary = Color3.fromRGB(35, 45, 35),
        Secondary = Color3.fromRGB(40, 50, 40),
        Accent = Color3.fromRGB(90, 180, 90),
        Text = Color3.fromRGB(235, 235, 235),
        DimText = Color3.fromRGB(175, 185, 175),
        StrokeColor = Color3.fromRGB(60, 70, 60)
    }
}

-- Класс Window (окно)
local Window = {}
Window.__index = Window

function Orbit.CreateWindow(title, theme)
    local self = setmetatable({}, Window)
    
    -- Свойства
    self.Title = title or "Orbit UI"
    self.Theme = Themes[theme] or Themes.Dark
    self.Tabs = {}
    self.CurrentTab = nil
    self.Toggled = true
    
    -- Создание интерфейса
    self:Create()
    
    return self
end

function Window:Create()
    -- Основной ScreenGui
    local uiName = HttpService:GenerateGUID(false)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "OrbitUI_" .. uiName
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Размещаем ScreenGui правильно
    if syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = game.CoreGui
    elseif gethui then
        self.ScreenGui.Parent = gethui()
    else
        self.ScreenGui.Parent = game.CoreGui
    end
    
    -- Основной фрейм
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = self.Theme.Primary
    self.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.MainFrame.Size = UDim2.fromOffset(600, 350)
    self.MainFrame.Parent = self.ScreenGui
    
    -- Делаем MainFrame перетаскиваемым
    Utils:MakeDraggable(self.MainFrame)
    
    -- Добавляем скругление к MainFrame
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = self.MainFrame
    
    -- Добавляем обводку к MainFrame
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = self.Theme.StrokeColor
    mainStroke.Thickness = 1
    mainStroke.Parent = self.MainFrame
    
    -- Верхняя панель
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.BackgroundColor3 = self.Theme.Secondary
    self.TopBar.Size = UDim2.new(1, 0, 0, 40)
    self.TopBar.Parent = self.MainFrame
    
    -- Скругление верхней панели
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 8)
    topBarCorner.Parent = self.TopBar
    
    -- Закрываем нижние углы TopBar
    local topBarCover = Instance.new("Frame")
    topBarCover.Name = "TopBarCover"
    topBarCover.BackgroundColor3 = self.Theme.Secondary
    topBarCover.BorderSizePixel = 0
    topBarCover.Position = UDim2.new(0, 0, 1, -8)
    topBarCover.Size = UDim2.new(1, 0, 0, 8)
    topBarCover.Parent = self.TopBar
    
    -- Заголовок
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Position = UDim2.fromOffset(15, 0)
    self.TitleLabel.Size = UDim2.new(1, -110, 1, 0)
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TopBar
    
    -- Кнопка закрытия
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Position = UDim2.new(1, -35, 0.5, -10)
    self.CloseButton.Size = UDim2.fromOffset(20, 20)
    self.CloseButton.Image = "rbxassetid://9113953222"
    self.CloseButton.ImageColor3 = self.Theme.Text
    self.CloseButton.Parent = self.TopBar
    
    self.CloseButton.MouseEnter:Connect(function()
        Utils:Tween(self.CloseButton, {ImageColor3 = self.Theme.Accent})
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        Utils:Tween(self.CloseButton, {ImageColor3 = self.Theme.Text})
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        Utils:Tween(self.MainFrame, {Size = UDim2.fromOffset(0, 0), Position = UDim2.fromScale(0.5, 0.5)}, 0.3)
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    -- Кнопка сворачивания
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Position = UDim2.new(1, -65, 0.5, -10)
    self.MinimizeButton.Size = UDim2.fromOffset(20, 20)
    self.MinimizeButton.Image = "rbxassetid://9113934104"
    self.MinimizeButton.ImageColor3 = self.Theme.Text
    self.MinimizeButton.Parent = self.TopBar
    
    self.MinimizeButton.MouseEnter:Connect(function()
        Utils:Tween(self.MinimizeButton, {ImageColor3 = self.Theme.Accent})
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        Utils:Tween(self.MinimizeButton, {ImageColor3 = self.Theme.Text})
    end)
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self.Toggled = not self.Toggled
        if self.Toggled then
            Utils:Tween(self.MainFrame, {Size = UDim2.fromOffset(600, 350)})
        else
            Utils:Tween(self.MainFrame, {Size = UDim2.fromOffset(600, 40)})
        end
    end)
    
    -- Держатель вкладок
    self.TabHolder = Instance.new("Frame")
    self.TabHolder.Name = "TabHolder"
    self.TabHolder.BackgroundColor3 = self.Theme.Secondary
    self.TabHolder.Position = UDim2.fromOffset(0, 40)
    self.TabHolder.Size = UDim2.new(0, 160, 1, -40)
    self.TabHolder.Parent = self.MainFrame
    
    -- Скругление держателя вкладок
    local tabHolderCorner = Instance.new("UICorner")
    tabHolderCorner.CornerRadius = UDim.new(0, 8)
    tabHolderCorner.Parent = self.TabHolder
    
    -- Закрываем правые углы TabHolder
    local tabHolderCover = Instance.new("Frame")
    tabHolderCover.Name = "TabHolderCover"
    tabHolderCover.BackgroundColor3 = self.Theme.Secondary
    tabHolderCover.BorderSizePixel = 0
    tabHolderCover.Position = UDim2.new(1, -8, 0, 0)
    tabHolderCover.Size = UDim2.new(0, 8, 1, 0)
    tabHolderCover.Parent = self.TabHolder
    
    -- Скроллер вкладок
    self.TabScroller = Instance.new("ScrollingFrame")
    self.TabScroller.Name = "TabScroller"
    self.TabScroller.BackgroundTransparency = 1
    self.TabScroller.Position = UDim2.fromOffset(0, 10)
    self.TabScroller.Size = UDim2.new(1, 0, 1, -10)
    self.TabScroller.CanvasSize = UDim2.fromScale(0, 0)
    self.TabScroller.ScrollBarThickness = 0
    self.TabScroller.ScrollingDirection = Enum.ScrollingDirection.Y
    self.TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.TabScroller.Parent = self.TabHolder
    
    -- Список вкладок
    self.TabList = Instance.new("UIListLayout")
    self.TabList.Name = "TabList"
    self.TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.TabList.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabList.Padding = UDim.new(0, 10)
    self.TabList.Parent = self.TabScroller
    
    -- Отступы для вкладок
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.PaddingBottom = UDim.new(0, 5)
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.PaddingRight = UDim.new(0, 5)
    tabPadding.Parent = self.TabScroller
    
    -- Контейнер для вкладок
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Position = UDim2.fromOffset(160, 40)
    self.TabContainer.Size = UDim2.new(1, -160, 1, -40)
    self.TabContainer.Parent = self.MainFrame
    
    -- Горячая клавиша для переключения видимости
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        end
    end)
    
    -- Настройка обновления темы
    self:UpdateTheme()
end

function Window:UpdateTheme()
    -- Обновляем все элементы с темой
    self.MainFrame.BackgroundColor3 = self.Theme.Primary
    self.TopBar.BackgroundColor3 = self.Theme.Secondary
    self.TopBarCover.BackgroundColor3 = self.Theme.Secondary
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.CloseButton.ImageColor3 = self.Theme.Text
    self.MinimizeButton.ImageColor3 = self.Theme.Text
    self.TabHolder.BackgroundColor3 = self.Theme.Secondary
    self.TabHolderCover.BackgroundColor3 = self.Theme.Secondary
    
    -- Обновляем кнопки вкладок
    for _, tab in pairs(self.Tabs) do
        tab:UpdateTheme()
    end
end

function Window:SetTheme(theme)
    if typeof(theme) == "string" and Themes[theme] then
        self.Theme = Themes[theme]
    elseif typeof(theme) == "table" then
        self.Theme = theme
    end
    
    self:UpdateTheme()
end

function Window:AddTab(name, icon)
    local tab = {}
    tab.Name = name
    tab.Icon = icon or "rbxassetid://9087227592" -- Иконка по умолчанию
    tab.Window = self
    tab.Sections = {}
    
    -- Создаем кнопку вкладки
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name .. "Tab"
    tab.Button.BackgroundColor3 = self.Theme.Primary
    tab.Button.Size = UDim2.new(1, -10, 0, 40)
    tab.Button.Font = Enum.Font.GothamSemibold
    tab.Button.Text = ""
    tab.Button.AutoButtonColor = false
    tab.Button.Parent = self.TabScroller
    
    -- Скругление кнопки
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = tab.Button
    
    -- Иконка
    tab.Icon = Instance.new("ImageLabel")
    tab.Icon.Name = "Icon"
    tab.Icon.BackgroundTransparency = 1
    tab.Icon.Position = UDim2.fromOffset(10, 10)
    tab.Icon.Size = UDim2.fromOffset(20, 20)
    tab.Icon.Image = icon or "rbxassetid://9087227592"
    tab.Icon.ImageColor3 = self.Theme.DimText
    tab.Icon.Parent = tab.Button
    
    -- Название
    tab.Title = Instance.new("TextLabel")
    tab.Title.Name = "Title"
    tab.Title.BackgroundTransparency = 1
    tab.Title.Position = UDim2.fromOffset(40, 0)
    tab.Title.Size = UDim2.new(1, -50, 1, 0)
    tab.Title.Font = Enum.Font.GothamSemibold
    tab.Title.Text = name
    tab.Title.TextColor3 = self.Theme.DimText
    tab.Title.TextSize = 14
    tab.Title.TextXAlignment = Enum.TextXAlignment.Left
    tab.Title.Parent = tab.Button
    
    -- Индикатор выбора
    tab.SelectionIndicator = Instance.new("Frame")
    tab.SelectionIndicator.Name = "SelectionIndicator"
    tab.SelectionIndicator.BackgroundColor3 = self.Theme.Accent
    tab.SelectionIndicator.Position = UDim2.fromScale(0, 0.5)
    tab.SelectionIndicator.AnchorPoint = Vector2.new(0, 0.5)
    tab.SelectionIndicator.Size = UDim2.new(0, 0, 0, 20)
    tab.SelectionIndicator.Parent = tab.Button
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 4)
    indicatorCorner.Parent = tab.SelectionIndicator
    
    -- Контейнер для содержимого вкладки
    tab.Container = Instance.new("ScrollingFrame")
    tab.Container.Name = name .. "Container"
    tab.Container.BackgroundTransparency = 1
    tab.Container.BorderSizePixel = 0
    tab.Container.Size = UDim2.fromScale(1, 1)
    tab.Container.CanvasSize = UDim2.fromScale(0, 0)
    tab.Container.ScrollBarThickness = 4
    tab.Container.ScrollingDirection = Enum.ScrollingDirection.Y
    tab.Container.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    tab.Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Container.ScrollBarImageColor3 = self.Theme.Accent
    tab.Container.Visible = false
    tab.Container.Parent = self.TabContainer
    
    -- Контейнер layout
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Name = "ContainerLayout"
    containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 10)
    containerLayout.Parent = tab.Container
    
    -- Контейнер padding
    local containerPadding = Instance.new("UIPadding")
    containerPadding.PaddingTop = UDim.new(0, 10)
    containerPadding.PaddingBottom = UDim.new(0, 10)
    containerPadding.PaddingLeft = UDim.new(0, 10)
    containerPadding.PaddingRight = UDim.new(0, 10)
    containerPadding.Parent = tab.Container
    
    -- Эффект наведения на кнопку вкладки
    tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Utils:Tween(tab.Button, {BackgroundColor3 = self.Theme.Secondary})
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Utils:Tween(tab.Button, {BackgroundColor3 = self.Theme.Primary})
        end
    end)
    
    -- Нажатие на кнопку вкладки
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    -- Метод для добавления секции
    function tab:AddSection(title)
        local section = {}
        section.Title = title
        section.Tab = self
        section.Elements = {}
        
        -- Создаем контейнер секции
        section.Container = Instance.new("Frame")
        section.Container.Name = title .. "Section"
        section.Container.BackgroundColor3 = self.Window.Theme.Secondary
        section.Container.Size = UDim2.new(1, -20, 0, 40) -- Будет изменен на основе содержимого
        section.Container.AutomaticSize = Enum.AutomaticSize.Y
        section.Container.Parent = self.Container
        
        -- Скругление контейнера
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 6)
        containerCorner.Parent = section.Container
        
        -- Заголовок секции
        section.TitleLabel = Instance.new("TextLabel")
        section.TitleLabel.Name = "Title"
        section.TitleLabel.BackgroundTransparency = 1
        section.TitleLabel.Position = UDim2.fromOffset(15, 8)
        section.TitleLabel.Size = UDim2.new(1, -30, 0, 20)
        section.TitleLabel.Font = Enum.Font.GothamBold
        section.TitleLabel.Text = title
        section.TitleLabel.TextColor3 = self.Window.Theme.Text
        section.TitleLabel.TextSize = 14
        section.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        section.TitleLabel.Parent = section.Container
        
        -- Разделитель секции
        section.Divider = Instance.new("Frame")
        section.Divider.Name = "Divider"
        section.Divider.BackgroundColor3 = self.Window.Theme.StrokeColor
        section.Divider.Position = UDim2.new(0, 15, 0, 35)
        section.Divider.Size = UDim2.new(1, -30, 0, 1)
        section.Divider.Parent = section.Container
        
        -- Контейнер содержимого
        section.Content = Instance.new("Frame")
        section.Content.Name = "Content"
        section.Content.BackgroundTransparency = 1
        section.Content.Position = UDim2.fromOffset(15, 45)
        section.Content.Size = UDim2.new(1, -30, 0, 0)
        section.Content.AutomaticSize = Enum.AutomaticSize.Y
        section.Content.Parent = section.Container
        
        -- Компоновка содержимого
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Name = "ContentLayout"
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.Parent = section.Content
        
        -- Добавляем метод для создания кнопки
        function section:AddButton(text, callback)
            local button = {}
            button.Text = text
            button.Callback = callback or function() end
            
            -- Создаем кнопку
            button.Instance = Instance.new("TextButton")
            button.Instance.Name = text .. "Button"
            button.Instance.BackgroundColor3 = self.Tab.Window.Theme.Primary
            button.Instance.Size = UDim2.new(1, 0, 0, 35)
            button.Instance.Font = Enum.Font.Gotham
            button.Instance.Text = text
            button.Instance.TextColor3 = self.Tab.Window.Theme.Text
            button.Instance.TextSize = 14
            button.Instance.AutoButtonColor = false
            button.Instance.ClipsDescendants = true
            button.Instance.Parent = self.Content
            
            -- Скругление кнопки
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = button.Instance
            
            -- Эффект наведения на кнопку
            button.Instance.MouseEnter:Connect(function()
                Utils:Tween(button.Instance, {BackgroundColor3 = self.Tab.Window.Theme.Secondary})
            end)
            
            button.Instance.MouseLeave:Connect(function()
                Utils:Tween(button.Instance, {BackgroundColor3 = self.Tab.Window.Theme.Primary})
            end)
            
            -- Событие нажатия на кнопку
            button.Instance.MouseButton1Click:Connect(function()
                button.Callback()
                Utils:Ripple(button.Instance)
            end)
            
            -- Добавляем кнопку в элементы секции
            table.insert(self.Elements, button)
            
            return button
        end
        
        -- Добавляем метод для создания переключателя
        function section:AddToggle(text, default, callback)
            local toggle = {}
            toggle.Text = text
            toggle.Value = default or false
            toggle.Callback = callback or function() end
            
            -- Создаем контейнер переключателя
            toggle.Container = Instance.new("Frame")
            toggle.Container.Name = text .. "Toggle"
            toggle.Container.BackgroundColor3 = self.Tab.Window.Theme.Primary
            toggle.Container.Size = UDim2.new(1, 0, 0, 35)
            toggle.Container.Parent = self.Content
            
            -- Скругление контейнера
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 4)
            containerCorner.Parent = toggle.Container
            
            -- Надпись переключателя
            toggle.Label = Instance.new("TextLabel")
            toggle.Label.Name = "Label"
            toggle.Label.BackgroundTransparency = 1
            toggle.Label.Position = UDim2.fromOffset(10, 0)
            toggle.Label.Size = UDim2.new(1, -60, 1, 0)
            toggle.Label.Font = Enum.Font.Gotham
            toggle.Label.Text = text
            toggle.Label.TextColor3 = self.Tab.Window.Theme.Text
            toggle.Label.TextSize = 14
            toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
            toggle.Label.Parent = toggle.Container
            
            -- Фон индикатора переключателя
            toggle.Background = Instance.new("Frame")
            toggle.Background.Name = "Background"
            toggle.Background.BackgroundColor3 = self.Tab.Window.Theme.Secondary
            toggle.Background.Position = UDim2.new(1, -50, 0.5, -10)
            toggle.Background.Size = UDim2.fromOffset(40, 20)
            toggle.Background.Parent = toggle.Container
            
            -- Скругление фона
            local backgroundCorner = Instance.new("UICorner")
            backgroundCorner.CornerRadius = UDim.new(1, 0)
            backgroundCorner.Parent = toggle.Background
            
            -- Индикатор переключателя
            toggle.Indicator = Instance.new("Frame")
            toggle.Indicator.Name = "Indicator"
            toggle.Indicator.AnchorPoint = Vector2.new(0, 0.5)
            toggle.Indicator.BackgroundColor3 = self.Tab.Window.Theme.Text
            toggle.Indicator.Position = UDim2.new(0, 2, 0.5, 0)
            toggle.Indicator.Size = UDim2.fromOffset(16, 16)
            toggle.Indicator.Parent = toggle.Background
            
            -- Скругление индикатора
            local indicatorCorner = Instance.new("UICorner")
            indicatorCorner.CornerRadius = UDim.new(1, 0)
            indicatorCorner.Parent = toggle.Indicator
            
            -- Функция обновления переключателя
            function toggle:Set(value)
                self.Value = value
                
                if self.Value then
                    Utils:Tween(self.Background, {BackgroundColor3 = self.parent.Tab.Window.Theme.Accent})
                    Utils:Tween(self.Indicator, {Position = UDim2.new(1, -18, 0.5, 0)})
                else
                    Utils:Tween(self.Background, {BackgroundColor3 = self.parent.Tab.Window.Theme.Secondary})
                    Utils:Tween(self.Indicator, {Position = UDim2.new(0, 2, 0.5, 0)})
                end
                
                self.Callback(self.Value)
            end
            
            -- Устанавливаем родителя для функции Set
            toggle.parent = self
            
            -- Инициализируем состояние переключателя
            if toggle.Value then
                toggle.Background.BackgroundColor3 = self.Tab.Window.Theme.Accent
                toggle.Indicator.Position = UDim2.new(1, -18, 0.5, 0)
            end
            
            -- Нажатие на переключатель
            toggle.Container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggle:Set(not toggle.Value)
                end
            end)
            
            -- Эффект наведения на контейнер
            toggle.Container.MouseEnter:Connect(function()
                Utils:Tween(toggle.Container, {BackgroundColor3 = self.Tab.Window.Theme.Secondary})
            end)
            
            toggle.Container.MouseLeave:Connect(function()
                Utils:Tween(toggle.Container, {BackgroundColor3 = self.Tab.Window.Theme.Primary})
            end)
            
            -- Добавляем переключатель в элементы секции
            table.insert(self.Elements, toggle)
            
            return toggle
        end
        
        -- Добавляем метод для создания слайдера
        function section:AddSlider(text, options, callback)
            local slider = {}
            slider.Text = text
            slider.Min = options.min or 0
            slider.Max = options.max or 100
            slider.Value = options.default or slider.Min
            slider.Callback = callback or function() end
            
            -- Создаем контейнер слайдера
            slider.Container = Instance.new("Frame")
            slider.Container.Name = text .. "Slider"
            slider.Container.BackgroundColor3 = self.Tab.Window.Theme.Primary
            slider.Container.Size = UDim2.new(1, 0, 0, 50)
            slider.Container.Parent = self.Content
            
            -- Скругление контейнера
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 4)
            containerCorner.Parent = slider.Container
            
            -- Надпись слайдера
            slider.Label = Instance.new("TextLabel")
            slider.Label.Name = "Label"
            slider.Label.BackgroundTransparency = 1
            slider.Label.Position = UDim2.fromOffset(10, 5)
            slider.Label.Size = UDim2.new(1, -20, 0, 20)
            slider.Label.Font = Enum.Font.Gotham
            slider.Label.Text = text
            slider.Label.TextColor3 = self.Tab.Window.Theme.Text
            slider.Label.TextSize = 14
            slider.Label.TextXAlignment = Enum.TextXAlignment.Left
            slider.Label.Parent = slider.Container
            
            -- Надпись значения
            slider.ValueLabel = Instance.new("TextLabel")
            slider.ValueLabel.Name = "Value"
            slider.ValueLabel.BackgroundTransparency = 1
            slider.ValueLabel.Position = UDim2.new(1, -50, 0, 5)
            slider.ValueLabel.Size = UDim2.fromOffset(40, 20)
            slider.ValueLabel.Font = Enum.Font.Gotham
            slider.ValueLabel.Text = tostring(slider.Value)
            slider.ValueLabel.TextColor3 = self.Tab.Window.Theme.DimText
            slider.ValueLabel.TextSize = 14
            slider.ValueLabel.Parent = slider.Container
            
            -- Фон слайдера
            slider.Background = Instance.new("Frame")
            slider.Background.Name = "Background"
            slider.Background.BackgroundColor3 = self.Tab.Window.Theme.Secondary
            slider.Background.Position = UDim2.new(0, 10, 0, 30)
            slider.Background.Size = UDim2.new(1, -20, 0, 6)
            slider.Background.Parent = slider.Container
            
            -- Скругление фона
            local backgroundCorner = Instance.new("UICorner")
            backgroundCorner.CornerRadius = UDim.new(1, 0)
            backgroundCorner.Parent = slider.Background
            
            -- Заполнение слайдера
            slider.Fill = Instance.new("Frame")
            slider.Fill.Name = "Fill"
            slider.Fill.BackgroundColor3 = self.Tab.Window.Theme.Accent
            slider.Fill.Size = UDim2.fromScale(0, 1)
            slider.Fill.Parent = slider.Background
            
            -- Скругление заполнения
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = slider.Fill
            
            -- Ползунок слайдера
            slider.Knob = Instance.new("Frame")
            slider.Knob.Name = "Knob"
            slider.Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            slider.Knob.BackgroundColor3 = self.Tab.Window.Theme.Accent
            slider.Knob.Position = UDim2.new(0, 0, 0.5, 0)
            slider.Knob.Size = UDim2.fromOffset(12, 12)
            slider.Knob.ZIndex = 2
            slider.Knob.Parent = slider.Fill
            
            -- Скругление ползунка
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = slider.Knob
            
            -- Функция обновления слайдера
            function slider:Set(value)
                value = math.clamp(value, self.Min, self.Max)
                self.Value = value
                
                local percent = (value - self.Min) / (self.Max - self.Min)
                Utils:Tween(self.Fill, {Size = UDim2.fromScale(percent, 1)}, 0.1)
                self.ValueLabel.Text = tostring(math.round(value))
                
                self.Callback(value)
            end
            
            -- Инициализируем слайдер
            slider:Set(slider.Value)
            
            -- Взаимодействие со слайдером
            local isDragging = false
            
            slider.Background.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    local position = input.Position.X - slider.Background.AbsolutePosition.X
                    local percent = position / slider.Background.AbsoluteSize.X
                    local value = slider.Min + (slider.Max - slider.Min) * percent
                    slider:Set(value)
                end
            end)
            
            slider.Background.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local position = input.Position.X - slider.Background.AbsolutePosition.X
                    local percent = math.clamp(position / slider.Background.AbsoluteSize.X, 0, 1)
                    local value = slider.Min + (slider.Max - slider.Min) * percent
                    slider:Set(value)
                end
            end)
            
            -- Эффект наведения на контейнер
            slider.Container.MouseEnter:Connect(function()
                Utils:Tween(slider.Container, {BackgroundColor3 = self.Tab.Window.Theme.Secondary})
            end)
            
            slider.Container.MouseLeave:Connect(function()
                Utils:Tween(slider.Container, {BackgroundColor3 = self.Tab.Window.Theme.Primary})
            end)
            
            -- Добавляем слайдер в элементы секции
            table.insert(self.Elements, slider)
            
            return slider
        end
        
        -- Добавляем секцию к вкладке
        table.insert(self.Sections, section)
        
        return section
    end
    
    function tab:UpdateTheme()
        self.Button.BackgroundColor3 = self.Window.Theme.Primary
        self.Title.TextColor3 = self == self.Window.CurrentTab and self.Window.Theme.Text or self.Window.Theme.DimText
        self.Icon.ImageColor3 = self == self.Window.CurrentTab and self.Window.Theme.Text or self.Window.Theme.DimText
        self.SelectionIndicator.BackgroundColor3 = self.Window.Theme.Accent
        self.Container.ScrollBarImageColor3 = self.Window.Theme.Accent
        
        -- Обновляем секции
        for _, section in pairs(self.Sections) do
            section.Container.BackgroundColor3 = self.Window.Theme.Secondary
            section.TitleLabel.TextColor3 = self.Window.Theme.Text
            section.Divider.BackgroundColor3 = self.Window.Theme.StrokeColor
            
            -- Обновляем элементы
            for _, element in pairs(section.Elements) do
                if element.Container then
                    element.Container.BackgroundColor3 = self.Window.Theme.Primary
                    element.Label.TextColor3 = self.Window.Theme.Text
                end
                
                if element.Instance then
                    element.Instance.BackgroundColor3 = self.Window.Theme.Primary
                    element.Instance.TextColor3 = self.Window.Theme.Text
                end
                
                if element.Background then
                    element.Background.BackgroundColor3 = element.Value and self.Window.Theme.Accent or self.Window.Theme.Secondary
                end
                
                if element.Fill then
                    element.Fill.BackgroundColor3 = self.Window.Theme.Accent
                end
                
                if element.Knob then
                    element.Knob.BackgroundColor3 = self.Window.Theme.Accent
                end
            end
        end
    end
    
    -- Добавляем вкладку в окно
    table.insert(self.Tabs, tab)
    
    -- Если это первая вкладка, выбираем ее
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

function Window:SelectTab(tab)
    -- Отменяем выбор текущей вкладки
    if self.CurrentTab then
        Utils:Tween(self.CurrentTab.Button, {BackgroundColor3 = self.Theme.Primary})
        Utils:Tween(self.CurrentTab.Title, {TextColor3 = self.Theme.DimText})
        Utils:Tween(self.CurrentTab.Icon, {ImageColor3 = self.Theme.DimText})
        Utils:Tween(self.CurrentTab.SelectionIndicator, {Size = UDim2.new(0, 0, 0, 20)})
        self.CurrentTab.Container.Visible = false
    end
    
    -- Выбираем новую вкладку
    self.CurrentTab = tab
    Utils:Tween(tab.Button, {BackgroundColor3 = self.Theme.Secondary})
    Utils:Tween(tab.Title, {TextColor3 = self.Theme.Text})
    Utils:Tween(tab.Icon, {ImageColor3 = self.Theme.Text})
    Utils:Tween(tab.SelectionIndicator, {Size = UDim2.new(0, 3, 0, 20)})
    tab.Container.Visible = true
end

-- Return library
return Orbit
