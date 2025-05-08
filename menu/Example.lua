-- Загружаем новую библиотеку OrbitUI
local Orbit = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/OrbitUI/main/OrbitUI.lua"))()
-- Если вы загружаете локально, используйте:
-- local Orbit = loadfile("OrbitUI.lua")()

-- Создаем новое окно с заголовком и темой
local Window = Orbit.CreateWindow("Goida", "Midnight")

-- Создаем вкладки с иконками (необязательно)
local MainTab = Window:AddTab("Основное")
local SettingsTab = Window:AddTab("Настройки")

-- Создаем секции в вкладках
local PlayerSection = MainTab:AddSection("Игрок")
local GameSection = MainTab:AddSection("Игра")
local SettingsSection = SettingsTab:AddSection("Настройки интерфейса")

-- Локальная переменная для игрока
local LocalPlayer = game.Players.LocalPlayer

-- Добавляем элементы в секции
-- Слайдер скорости
PlayerSection:AddSlider("Скорость", {
    min = 16,       -- Минимальное значение
    max = 500,      -- Максимальное значение
    default = 16    -- Значение по умолчанию
}, function(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

-- Слайдер высоты прыжка
PlayerSection:AddSlider("Высота прыжка", {
    min = 50,
    max = 300,
    default = 50
}, function(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

-- Кнопка сброса персонажа
PlayerSection:AddButton("Сбросить персонажа", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

-- Переключатель NoClip
local NoClipToggle = GameSection:AddToggle("NoClip", false, function(value)
    _G.NoClip = value
    
    -- Включаем/отключаем NoClip
    if _G.NoClip then
        -- Создаем цикл для NoClip если он еще не существует
        if not _G.NoClipLoop then
            _G.NoClipLoop = game:GetService("RunService").Stepped:Connect(function()
                if LocalPlayer.Character and _G.NoClip then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        -- Отключаем цикл NoClip
        if _G.NoClipLoop then
            _G.NoClipLoop:Disconnect()
            _G.NoClipLoop = nil
        end
    end
end)

-- Переключатель бесконечного прыжка
local InfiniteJumpToggle = GameSection:AddToggle("Бесконечный прыжок", false, function(value)
    _G.InfiniteJump = value
end)

-- Обработчик бесконечного прыжка
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Элементы настроек
local ThemesList = {"Dark", "Light", "Midnight", "Aqua", "Rose", "Forest"}

for _, theme in pairs(ThemesList) do
    SettingsSection:AddButton(theme .. " тема", function()
        Window:SetTheme(theme)
    end)
end

-- Сообщение о загрузке
print("Интерфейс загружен! Нажмите RightControl для переключения видимости интерфейса.") 
