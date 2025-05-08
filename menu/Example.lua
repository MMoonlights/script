local ModernUI = require(script.Parent.ModernUI)

-- Create a new window
local Window = ModernUI.new("Modern UI Example")

-- Create tabs
local MainTab = Window:NewTab("Main")
local SettingsTab = Window:NewTab("Settings")

-- Create sections
local MovementSection = MainTab:NewSection("Movement")
local CombatSection = MainTab:NewSection("Combat")
local VisualSection = SettingsTab:NewSection("Visual Settings")

-- Add controls to Movement section
MovementSection:NewSlider("WalkSpeed", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

MovementSection:NewSlider("JumpPower", 50, 200, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

MovementSection:NewToggle("Infinite Jump", false, function(enabled)
    -- Add your infinite jump logic here
    print("Infinite Jump:", enabled)
end)

-- Add controls to Combat section
CombatSection:NewButton("Kill All", function()
    -- Add your kill all logic here
    print("Kill All pressed")
end)

CombatSection:NewToggle("Auto Kill", false, function(enabled)
    -- Add your auto kill logic here
    print("Auto Kill:", enabled)
end)

-- Add controls to Visual Settings section
VisualSection:NewToggle("ESP", false, function(enabled)
    -- Add your ESP logic here
    print("ESP:", enabled)
end)

VisualSection:NewToggle("Full Bright", false, function(enabled)
    -- Add your full bright logic here
    print("Full Bright:", enabled)
end) 