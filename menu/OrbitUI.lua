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
    
    -- Эффект размытия фона (блюр)
    self.Blur = Instance.new("BlurEffect")
    self.Blur.Size = 0
    self.Blur.Parent = game:GetService("Lighting")
    Utils:Tween(self.Blur, {Size = 10}, 0.5)
    
    -- Дополнительное затемнение для улучшения контраста интерфейса
    self.DarkBackground = Instance.new("Frame")
    self.DarkBackground.Name = "DarkBackground"
    self.DarkBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.DarkBackground.BackgroundTransparency = 1
    self.DarkBackground.Size = UDim2.fromScale(1, 1)
    self.DarkBackground.ZIndex = 10
    Utils:Tween(self.DarkBackground, {BackgroundTransparency = 0.5}, 0.5)
    self.DarkBackground.Parent = self.ScreenGui
    
    -- Основной фрейм
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = self.Theme.Primary
    self.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.MainFrame.Size = UDim2.fromOffset(650, 400)
    self.MainFrame.ZIndex = 11
    self.MainFrame.Parent = self.ScreenGui
    
    -- Анимация появления
    self.MainFrame.Size = UDim2.fromOffset(0, 0)
    Utils:Tween(self.MainFrame, {Size = UDim2.fromOffset(650, 400)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Тень для основного фрейма
    local mainShadow = Instance.new("ImageLabel")
    mainShadow.Name = "Shadow"
    mainShadow.BackgroundTransparency = 1
    mainShadow.Position = UDim2.fromOffset(-15, -15)
    mainShadow.Size = UDim2.new(1, 30, 1, 30)
    mainShadow.ZIndex = 10
    mainShadow.Image = "rbxassetid://6014261993"
    mainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    mainShadow.ImageTransparency = 0.5
    mainShadow.ScaleType = Enum.ScaleType.Slice
    mainShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    mainShadow.Parent = self.MainFrame
    
    -- Делаем MainFrame перетаскиваемым
    Utils:MakeDraggable(self.MainFrame)
    
    -- Добавляем скругление к MainFrame
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = self.MainFrame
    
    -- Добавляем обводку к MainFrame
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = self.Theme.StrokeColor
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.5
    mainStroke.Parent = self.MainFrame
    
    -- Верхняя панель
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.BackgroundColor3 = self.Theme.Secondary
    self.TopBar.Size = UDim2.new(1, 0, 0, 45)
    self.TopBar.ZIndex = 12
    self.TopBar.Parent = self.MainFrame
    
    -- Скругление верхней панели
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 10)
    topBarCorner.Parent = self.TopBar
    
    -- Закрываем нижние углы TopBar
    self.TopBarCover = Instance.new("Frame")
    self.TopBarCover.Name = "TopBarCover"
    self.TopBarCover.BackgroundColor3 = self.Theme.Secondary
    self.TopBarCover.BorderSizePixel = 0
    self.TopBarCover.Position = UDim2.new(0, 0, 1, -10)
    self.TopBarCover.Size = UDim2.new(1, 0, 0, 10)
    self.TopBarCover.ZIndex = 12
    self.TopBarCover.Parent = self.TopBar
    
    -- Логотип
    self.Logo = Instance.new("ImageLabel")
    self.Logo.Name = "Logo"
    self.Logo.BackgroundTransparency = 1
    self.Logo.Position = UDim2.fromOffset(15, 7)
    self.Logo.Size = UDim2.fromOffset(30, 30)
    self.Logo.ZIndex = 13
    self.Logo.Image = "rbxassetid://7072706318" -- Логотип Orbit
    self.Logo.ImageColor3 = self.Theme.Accent
    self.Logo.Parent = self.TopBar
    
    -- Заголовок
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Position = UDim2.fromOffset(55, 0)
    self.TitleLabel.Size = UDim2.new(1, -160, 1, 0)
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 13
    self.TitleLabel.Parent = self.TopBar
    
    -- Контейнер для кнопок управления
    self.ControlButtons = Instance.new("Frame")
    self.ControlButtons.Name = "ControlButtons"
    self.ControlButtons.BackgroundTransparency = 1
    self.ControlButtons.Position = UDim2.new(1, -105, 0, 0)
    self.ControlButtons.Size = UDim2.fromOffset(105, 45)
    self.ControlButtons.ZIndex = 13
    self.ControlButtons.Parent = self.TopBar
    
    -- Кнопка настроек
    self.SettingsButton = Instance.new("ImageButton")
    self.SettingsButton.Name = "SettingsButton"
    self.SettingsButton.BackgroundTransparency = 1
    self.SettingsButton.Position = UDim2.fromOffset(10, 12)
    self.SettingsButton.Size = UDim2.fromOffset(20, 20)
    self.SettingsButton.ZIndex = 14
    self.SettingsButton.Image = "rbxassetid://3926307971"
    self.SettingsButton.ImageRectOffset = Vector2.new(324, 124)
    self.SettingsButton.ImageRectSize = Vector2.new(36, 36)
    self.SettingsButton.ImageColor3 = self.Theme.Text
    self.SettingsButton.Parent = self.ControlButtons
    
    -- Эффекты для кнопки настроек
    self.SettingsButton.MouseEnter:Connect(function()
        Utils:Tween(self.SettingsButton, {ImageColor3 = self.Theme.Accent})
    end)
    
    self.SettingsButton.MouseLeave:Connect(function()
        Utils:Tween(self.SettingsButton, {ImageColor3 = self.Theme.Text})
    end)
    
    -- Кнопка сворачивания
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Name = "MinimizeButton"
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Position = UDim2.fromOffset(45, 12)
    self.MinimizeButton.Size = UDim2.fromOffset(20, 20)
    self.MinimizeButton.ZIndex = 14
    self.MinimizeButton.Image = "rbxassetid://9113934104"
    self.MinimizeButton.ImageColor3 = self.Theme.Text
    self.MinimizeButton.Parent = self.ControlButtons
    
    self.MinimizeButton.MouseEnter:Connect(function()
        Utils:Tween(self.MinimizeButton, {ImageColor3 = self.Theme.Accent})
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        Utils:Tween(self.MinimizeButton, {ImageColor3 = self.Theme.Text})
    end)
    
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self.Toggled = not self.Toggled
        if self.Toggled then
            Utils:Tween(self.MainFrame, {Size = UDim2.fromOffset(650, 400)}, 0.3, Enum.EasingStyle.Quint)
            Utils:Tween(self.Blur, {Size = 10}, 0.3)
        else
            Utils:Tween(self.MainFrame, {Size = UDim2.fromOffset(650, 45)}, 0.3, Enum.EasingStyle.Quint)
            Utils:Tween(self.Blur, {Size = 5}, 0.3)
        end
    end)
    
    -- Кнопка закрытия
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Position = UDim2.fromOffset(75, 12)
    self.CloseButton.Size = UDim2.fromOffset(20, 20)
    self.CloseButton.ZIndex = 14
    self.CloseButton.Image = "rbxassetid://9113953222"
    self.CloseButton.ImageColor3 = self.Theme.Text
    self.CloseButton.Parent = self.ControlButtons
    
    self.CloseButton.MouseEnter:Connect(function()
        Utils:Tween(self.CloseButton, {ImageColor3 = Color3.fromRGB(232, 17, 35)})
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        Utils:Tween(self.CloseButton, {ImageColor3 = self.Theme.Text})
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        -- Анимация закрытия
        Utils:Tween(self.MainFrame, {Size = UDim2.fromOffset(0, 0), Position = UDim2.fromScale(0.5, 0.5)}, 0.3)
        Utils:Tween(self.DarkBackground, {BackgroundTransparency = 1}, 0.3)
        Utils:Tween(self.Blur, {Size = 0}, 0.3)
        
        task.wait(0.3)
        self.Blur:Destroy()
        self.ScreenGui:Destroy()
    end)
    
    -- Держатель вкладок (панель навигации)
    self.TabHolder = Instance.new("Frame")
    self.TabHolder.Name = "TabHolder"
    self.TabHolder.BackgroundColor3 = self.Theme.Secondary
    self.TabHolder.Position = UDim2.fromOffset(0, 45)
    self.TabHolder.Size = UDim2.new(0, 180, 1, -45)
    self.TabHolder.ZIndex = 12
    self.TabHolder.Parent = self.MainFrame
    
    -- Скругление держателя вкладок
    local tabHolderCorner = Instance.new("UICorner")
    tabHolderCorner.CornerRadius = UDim.new(0, 10)
    tabHolderCorner.Parent = self.TabHolder
    
    -- Закрываем правые углы TabHolder
    self.TabHolderCover = Instance.new("Frame")
    self.TabHolderCover.Name = "TabHolderCover"
    self.TabHolderCover.BackgroundColor3 = self.Theme.Secondary
    self.TabHolderCover.BorderSizePixel = 0
    self.TabHolderCover.Position = UDim2.new(1, -10, 0, 0)
    self.TabHolderCover.Size = UDim2.new(0, 10, 1, 0)
    self.TabHolderCover.ZIndex = 12
    self.TabHolderCover.Parent = self.TabHolder
    
    -- Заголовок боковой панели
    self.SidebarTitle = Instance.new("TextLabel")
    self.SidebarTitle.Name = "SidebarTitle"
    self.SidebarTitle.BackgroundTransparency = 1
    self.SidebarTitle.Position = UDim2.fromOffset(15, 15)
    self.SidebarTitle.Size = UDim2.new(1, -30, 0, 20)
    self.SidebarTitle.Font = Enum.Font.GothamMedium
    self.SidebarTitle.Text = "НАВИГАЦИЯ"
    self.SidebarTitle.TextColor3 = self.Theme.DimText
    self.SidebarTitle.TextSize = 12
    self.SidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
    self.SidebarTitle.ZIndex = 13
    self.SidebarTitle.Parent = self.TabHolder
    
    -- Скроллер вкладок
    self.TabScroller = Instance.new("ScrollingFrame")
    self.TabScroller.Name = "TabScroller"
    self.TabScroller.BackgroundTransparency = 1
    self.TabScroller.Position = UDim2.fromOffset(0, 45)
    self.TabScroller.Size = UDim2.new(1, 0, 1, -55)
    self.TabScroller.CanvasSize = UDim2.fromScale(0, 0)
    self.TabScroller.ScrollBarThickness = 2
    self.TabScroller.ScrollingDirection = Enum.ScrollingDirection.Y
    self.TabScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.TabScroller.ZIndex = 13
    self.TabScroller.ScrollBarImageColor3 = self.Theme.Accent
    self.TabScroller.Parent = self.TabHolder
    
    -- Список вкладок
    self.TabList = Instance.new("UIListLayout")
    self.TabList.Name = "TabList"
    self.TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.TabList.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabList.Padding = UDim.new(0, 8)
    self.TabList.Parent = self.TabScroller
    
    -- Отступы для вкладок
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.PaddingBottom = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 8)
    tabPadding.PaddingRight = UDim.new(0, 8)
    tabPadding.Parent = self.TabScroller
    
    -- Информация о библиотеке внизу боковой панели
    self.LibraryInfo = Instance.new("TextLabel")
    self.LibraryInfo.Name = "LibraryInfo"
    self.LibraryInfo.BackgroundTransparency = 1
    self.LibraryInfo.Position = UDim2.new(0, 15, 1, -30)
    self.LibraryInfo.Size = UDim2.new(1, -30, 0, 20)
    self.LibraryInfo.Font = Enum.Font.Gotham
    self.LibraryInfo.Text = "Orbit UI v1.0"
    self.LibraryInfo.TextColor3 = self.Theme.DimText
    self.LibraryInfo.TextSize = 12
    self.LibraryInfo.TextXAlignment = Enum.TextXAlignment.Left
    self.LibraryInfo.TextTransparency = 0.4
    self.LibraryInfo.ZIndex = 13
    self.LibraryInfo.Parent = self.TabHolder
    
    -- Контейнер для вкладок
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Position = UDim2.fromOffset(180, 45)
    self.TabContainer.Size = UDim2.new(1, -180, 1, -45)
    self.TabContainer.ZIndex = 12
    self.TabContainer.Parent = self.MainFrame
    
    -- Горячая клавиша для переключения видимости
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
            
            -- Обновляем эффект размытия при переключении видимости
            if self.ScreenGui.Enabled then
                Utils:Tween(self.Blur, {Size = 10}, 0.3)
            else
                Utils:Tween(self.Blur, {Size = 0}, 0.3)
            end
        end
    end)
    
    -- Настройка обновления темы
    self:UpdateTheme()
end

function Window:UpdateTheme()
    -- Обновляем все элементы с темой
    if self.MainFrame then self.MainFrame.BackgroundColor3 = self.Theme.Primary end
    if self.TopBar then self.TopBar.BackgroundColor3 = self.Theme.Secondary end
    if self.TopBarCover then self.TopBarCover.BackgroundColor3 = self.Theme.Secondary end
    if self.TitleLabel then self.TitleLabel.TextColor3 = self.Theme.Text end
    if self.CloseButton then self.CloseButton.ImageColor3 = self.Theme.Text end
    if self.MinimizeButton then self.MinimizeButton.ImageColor3 = self.Theme.Text end
    if self.TabHolder then self.TabHolder.BackgroundColor3 = self.Theme.Secondary end
    if self.TabHolderCover then self.TabHolderCover.BackgroundColor3 = self.Theme.Secondary end
    
    -- Обновляем кнопки вкладок
    for _, tab in pairs(self.Tabs) do
        if tab.UpdateTheme then
            tab:UpdateTheme()
        end
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
    
    -- Создаем кнопку вкладки с улучшенным дизайном
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name .. "Tab"
    tab.Button.BackgroundColor3 = self.Theme.Primary
    tab.Button.BackgroundTransparency = 1
    tab.Button.Size = UDim2.new(1, -16, 0, 44)
    tab.Button.Font = Enum.Font.GothamSemibold
    tab.Button.Text = ""
    tab.Button.AutoButtonColor = false
    tab.Button.ZIndex = 14
    tab.Button.Parent = self.TabScroller
    
    -- Контейнер для кнопки с эффектами
    tab.ButtonContainer = Instance.new("Frame")
    tab.ButtonContainer.Name = "ButtonContainer"
    tab.ButtonContainer.BackgroundColor3 = self.Theme.Primary
    tab.ButtonContainer.BackgroundTransparency = 0.6
    tab.ButtonContainer.Size = UDim2.fromScale(1, 1)
    tab.ButtonContainer.ZIndex = 13
    tab.ButtonContainer.Parent = tab.Button
    
    -- Скругление контейнера
    local buttonContainerCorner = Instance.new("UICorner")
    buttonContainerCorner.CornerRadius = UDim.new(0, 8)
    buttonContainerCorner.Parent = tab.ButtonContainer
    
    -- Обводка для выделенной вкладки
    tab.ButtonStroke = Instance.new("UIStroke")
    tab.ButtonStroke.Color = self.Theme.Accent
    tab.ButtonStroke.Transparency = 1
    tab.ButtonStroke.Thickness = 1.5
    tab.ButtonStroke.Parent = tab.ButtonContainer
    
    -- Иконка с улучшенным дизайном
    tab.IconContainer = Instance.new("Frame")
    tab.IconContainer.Name = "IconContainer"
    tab.IconContainer.BackgroundColor3 = self.Theme.Secondary
    tab.IconContainer.BackgroundTransparency = 1
    tab.IconContainer.Position = UDim2.fromOffset(12, 12)
    tab.IconContainer.Size = UDim2.fromOffset(20, 20)
    tab.IconContainer.ZIndex = 15
    tab.IconContainer.Parent = tab.Button
    
    tab.Icon = Instance.new("ImageLabel")
    tab.Icon.Name = "Icon"
    tab.Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    tab.Icon.BackgroundTransparency = 1
    tab.Icon.Position = UDim2.fromScale(0.5, 0.5)
    tab.Icon.Size = UDim2.fromOffset(16, 16)
    tab.Icon.ZIndex = 15
    tab.Icon.Image = icon or "rbxassetid://9087227592"
    tab.Icon.ImageColor3 = self.Theme.DimText
    tab.Icon.Parent = tab.IconContainer
    
    -- Название с улучшенным дизайном
    tab.Title = Instance.new("TextLabel")
    tab.Title.Name = "Title"
    tab.Title.BackgroundTransparency = 1
    tab.Title.Position = UDim2.fromOffset(42, 0)
    tab.Title.Size = UDim2.new(1, -50, 1, 0)
    tab.Title.Font = Enum.Font.GothamSemibold
    tab.Title.Text = name
    tab.Title.TextColor3 = self.Theme.DimText
    tab.Title.TextSize = 14
    tab.Title.TextXAlignment = Enum.TextXAlignment.Left
    tab.Title.ZIndex = 15
    tab.Title.Parent = tab.Button
    
    -- Индикатор выбора с улучшенным дизайном
    tab.SelectionIndicator = Instance.new("Frame")
    tab.SelectionIndicator.Name = "SelectionIndicator"
    tab.SelectionIndicator.BackgroundColor3 = self.Theme.Accent
    tab.SelectionIndicator.Position = UDim2.fromOffset(0, 22)
    tab.SelectionIndicator.AnchorPoint = Vector2.new(0, 0.5)
    tab.SelectionIndicator.Size = UDim2.new(0, 0, 0, 0)
    tab.SelectionIndicator.ZIndex = 15
    tab.SelectionIndicator.Parent = tab.ButtonContainer
    
    -- Скругление индикатора
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = tab.SelectionIndicator
    
    -- Контейнер для содержимого вкладки с улучшенным скроллингом
    tab.Container = Instance.new("ScrollingFrame")
    tab.Container.Name = name .. "Container"
    tab.Container.BackgroundTransparency = 1
    tab.Container.BorderSizePixel = 0
    tab.Container.Size = UDim2.fromScale(1, 1)
    tab.Container.CanvasSize = UDim2.fromScale(0, 0)
    tab.Container.ScrollBarThickness = 3
    tab.Container.ScrollingDirection = Enum.ScrollingDirection.Y
    tab.Container.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    tab.Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Container.ScrollBarImageColor3 = self.Theme.Accent
    tab.Container.ScrollBarImageTransparency = 0.5
    tab.Container.Visible = false
    tab.Container.ZIndex = 13
    tab.Container.Parent = self.TabContainer
    
    -- Контейнер layout с равномерными отступами
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Name = "ContainerLayout"
    containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 15)
    containerLayout.Parent = tab.Container
    
    -- Контейнер padding с увеличенными отступами для лучшего вида
    local containerPadding = Instance.new("UIPadding")
    containerPadding.PaddingTop = UDim.new(0, 15)
    containerPadding.PaddingBottom = UDim.new(0, 15)
    containerPadding.PaddingLeft = UDim.new(0, 15)
    containerPadding.PaddingRight = UDim.new(0, 15)
    containerPadding.Parent = tab.Container
    
    -- Эффект наведения на кнопку вкладки с плавной анимацией
    tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Utils:Tween(tab.ButtonContainer, {BackgroundTransparency = 0.2}, 0.2)
            Utils:Tween(tab.Icon, {ImageColor3 = self.Theme.Text}, 0.2)
            Utils:Tween(tab.Title, {TextColor3 = self.Theme.Text}, 0.2)
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Utils:Tween(tab.ButtonContainer, {BackgroundTransparency = 0.6}, 0.2)
            Utils:Tween(tab.Icon, {ImageColor3 = self.Theme.DimText}, 0.2)
            Utils:Tween(tab.Title, {TextColor3 = self.Theme.DimText}, 0.2)
        end
    end)
    
    -- Нажатие на кнопку вкладки с эффектом ripple
    tab.Button.MouseButton1Click:Connect(function()
        Utils:Ripple(tab.ButtonContainer)
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
        section.Container.Size = UDim2.new(1, -20, 0, 40)
        section.Container.AutomaticSize = Enum.AutomaticSize.Y
        section.Container.ZIndex = 14
        section.Container.Parent = self.Container
        
        -- Добавляем тень для улучшения внешнего вида
        local shadowEffect = Instance.new("ImageLabel")
        shadowEffect.Name = "Shadow"
        shadowEffect.BackgroundTransparency = 1
        shadowEffect.Position = UDim2.fromOffset(-15, -15)
        shadowEffect.Size = UDim2.new(1, 30, 1, 30)
        shadowEffect.ZIndex = 13
        shadowEffect.Image = "rbxassetid://6014261993"
        shadowEffect.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadowEffect.ImageTransparency = 0.5
        shadowEffect.ScaleType = Enum.ScaleType.Slice
        shadowEffect.SliceCenter = Rect.new(49, 49, 450, 450)
        shadowEffect.Parent = section.Container
        
        -- Скругление контейнера
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = section.Container
        
        -- Улучшенный вид обводки
        local stroke = Instance.new("UIStroke")
        stroke.Color = self.Window.Theme.StrokeColor
        stroke.Thickness = 1
        stroke.Transparency = 0.5
        stroke.Parent = section.Container
        
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
        section.TitleLabel.ZIndex = 15
        section.TitleLabel.Parent = section.Container
        
        -- Разделитель секции
        section.Divider = Instance.new("Frame")
        section.Divider.Name = "Divider"
        section.Divider.BackgroundColor3 = self.Window.Theme.StrokeColor
        section.Divider.Position = UDim2.new(0, 15, 0, 35)
        section.Divider.Size = UDim2.new(1, -30, 0, 1)
        section.Divider.Transparency = 0.5
        section.Divider.ZIndex = 15
        section.Divider.Parent = section.Container
        
        -- Контейнер содержимого
        section.Content = Instance.new("Frame")
        section.Content.Name = "Content"
        section.Content.BackgroundTransparency = 1
        section.Content.Position = UDim2.fromOffset(15, 45)
        section.Content.Size = UDim2.new(1, -30, 0, 0)
        section.Content.AutomaticSize = Enum.AutomaticSize.Y
        section.Content.ZIndex = 15
        section.Content.Parent = section.Container
        
        -- Нижний отступ для секции
        local bottomPadding = Instance.new("Frame")
        bottomPadding.Name = "BottomPadding"
        bottomPadding.BackgroundTransparency = 1
        bottomPadding.Size = UDim2.new(1, 0, 0, 10)
        bottomPadding.LayoutOrder = 9999
        bottomPadding.ZIndex = 15
        bottomPadding.Parent = section.Content
        
        -- Компоновка содержимого
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Name = "ContentLayout"
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = section.Content
        
        -- Добавляем секцию к вкладке
        table.insert(self.Sections, section)
        
        return section
    end
    
    function tab:UpdateTheme()
        self.ButtonContainer.BackgroundColor3 = self == self.Window.CurrentTab and self.Window.Theme.Accent or self.Window.Theme.Primary
        self.ButtonContainer.BackgroundTransparency = self == self.Window.CurrentTab and 0.7 or 0.6
        self.ButtonStroke.Transparency = self == self.Window.CurrentTab and 0 or 1
        self.Title.TextColor3 = self == self.Window.CurrentTab and self.Window.Theme.Text or self.Window.Theme.DimText
        self.Icon.ImageColor3 = self == self.Window.CurrentTab and self.Window.Theme.Text or self.Window.Theme.DimText
        self.SelectionIndicator.BackgroundColor3 = self.Window.Theme.Accent
        self.Container.ScrollBarImageColor3 = self.Window.Theme.Accent
        
        -- Обновляем секции
        for _, section in pairs(self.Sections) do
            if section.Container then section.Container.BackgroundColor3 = self.Window.Theme.Secondary end
            if section.TitleLabel then section.TitleLabel.TextColor3 = self.Window.Theme.Text end
            if section.Divider then section.Divider.BackgroundColor3 = self.Window.Theme.StrokeColor end
            
            -- Обновляем элементы
            for _, element in pairs(section.Elements) do
                if element.Container then
                    element.Container.BackgroundColor3 = self.Window.Theme.Primary
                    if element.Label then element.Label.TextColor3 = self.Window.Theme.Text end
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
                    element.Knob.BackgroundColor3 = self.Window.Theme.Text
                end
                
                if element.ValueContainer then
                    element.ValueContainer.BackgroundColor3 = self.Window.Theme.Secondary
                    if element.ValueLabel then element.ValueLabel.TextColor3 = self.Window.Theme.Text end
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
        Utils:Tween(self.CurrentTab.ButtonContainer, {BackgroundColor3 = self.Theme.Primary}, 0.3)
        Utils:Tween(self.CurrentTab.ButtonContainer, {BackgroundTransparency = 0.6}, 0.3)
        Utils:Tween(self.CurrentTab.ButtonStroke, {Transparency = 1}, 0.3)
        Utils:Tween(self.CurrentTab.Title, {TextColor3 = self.Theme.DimText}, 0.3)
        Utils:Tween(self.CurrentTab.Icon, {ImageColor3 = self.Theme.DimText}, 0.3)
        Utils:Tween(self.CurrentTab.SelectionIndicator, {Size = UDim2.fromOffset(0, 0)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        -- Анимация исчезновения контейнера
        Utils:Tween(self.CurrentTab.Container, {BackgroundTransparency = 1}, 0.2)
        task.delay(0.1, function()
            self.CurrentTab.Container.Visible = false
        end)
    end
    
    -- Выбираем новую вкладку с улучшенными анимациями
    self.CurrentTab = tab
    
    -- Анимация выбора вкладки
    Utils:Tween(tab.ButtonContainer, {BackgroundColor3 = self.Theme.Accent}, 0.3)
    Utils:Tween(tab.ButtonContainer, {BackgroundTransparency = 0.7}, 0.3)
    Utils:Tween(tab.ButtonStroke, {Transparency = 0}, 0.3)
    Utils:Tween(tab.Title, {TextColor3 = self.Theme.Text}, 0.3)
    Utils:Tween(tab.Icon, {ImageColor3 = self.Theme.Text}, 0.3)
    
    -- Анимация индикатора выбора
    tab.SelectionIndicator.Size = UDim2.fromOffset(0, 0)
    tab.Container.Visible = true
    tab.Container.BackgroundTransparency = 1
    
    Utils:Tween(tab.SelectionIndicator, {Size = UDim2.fromOffset(4, 20)}, 0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
    Utils:Tween(tab.Container, {BackgroundTransparency = 0}, 0.3)
    
    -- Прокручиваем к выбранной вкладке, чтобы она была видна
    local tabPosition = tab.Button.Position.Y.Offset
    local viewportSize = self.TabScroller.Size.Y.Offset
    local canvasPosition = self.TabScroller.CanvasPosition.Y
    
    -- Проверяем, видна ли вкладка в viewport
    if tabPosition < canvasPosition or tabPosition + tab.Button.Size.Y.Offset > canvasPosition + viewportSize then
        -- Прокручиваем к вкладке
        Utils:Tween(self.TabScroller, {CanvasPosition = Vector2.new(0, tabPosition - 10)}, 0.3)
    end
end

-- Return library
return Orbit
