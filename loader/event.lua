-- Player and Character Setup
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local playerRootPart = character:WaitForChild("HumanoidRootPart")

-- Folder and Pumpkin Setup
local pumpkinsFolder = game:GetService("Workspace"):WaitForChild("HalloweenEvent"):WaitForChild("Objects")
local pumpkinPrefix = "Pumpkin_"
local pumpkinCount = 10 -- Adjust if there are more pumpkins
local detectedPumpkins = {}

-- Debug ScreenGui Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PumpkinESP_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- ESP Text Template
local function createESPLabel(pumpkin)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 200, 0, 25)
    textLabel.BackgroundTransparency = 0.5
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Text = pumpkin.Name
    textLabel.Parent = screenGui
    return textLabel
end

-- Teleport Menu
local teleportMenu = Instance.new("Frame")
teleportMenu.Size = UDim2.new(0, 300, 0, 400)
teleportMenu.Position = UDim2.new(0.05, 0, 0.3, 0)
teleportMenu.BackgroundTransparency = 0.5
teleportMenu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
teleportMenu.BorderSizePixel = 0
teleportMenu.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Pumpkin Teleport Menu"
title.TextScaled = true
title.BackgroundTransparency = 0.5
title.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
title.TextColor3 = Color3.fromRGB(255, 165, 0)
title.Parent = teleportMenu

-- Function to Add Teleport Button
local function addTeleportButton(pumpkin)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 45 + #detectedPumpkins * 35)
    button.BackgroundTransparency = 0.3
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 165, 0)
    button.Text = pumpkin.Name .. " - Teleport"
    button.TextScaled = true
    button.Parent = teleportMenu

    -- Button Functionality for Teleport
    button.MouseButton1Click:Connect(function()
        if playerRootPart then
            playerRootPart.CFrame = pumpkin.CFrame
        end
    end)
end

-- Function to Update ESP for Each Pumpkin
local function updateESP()
    for i = 1, pumpkinCount do
        local pumpkin = pumpkinsFolder:FindFirstChild(pumpkinPrefix .. i)

        if pumpkin and not detectedPumpkins[pumpkin] then
            -- Add pumpkin to detected list and set up ESP and button
            detectedPumpkins[pumpkin] = {
                label = createESPLabel(pumpkin)
            }
            addTeleportButton(pumpkin)
        end

        -- Update ESP label with position and distance info
        if pumpkin and detectedPumpkins[pumpkin] then
            local distance = (playerRootPart.Position - pumpkin.Position).Magnitude
            detectedPumpkins[pumpkin].label.Text = string.format("%s - Distance: %.1f", pumpkin.Name, distance)
            local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(pumpkin.Position)

            -- Position the ESP label on the screen if on screen
            if onScreen then
                detectedPumpkins[pumpkin].label.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                detectedPumpkins[pumpkin].label.Visible = true
            else
                detectedPumpkins[pumpkin].label.Visible = false
            end
        end
    end
end

-- Function to Check Collection
local function checkCollection()
    for pumpkin, data in pairs(detectedPumpkins) do
        if pumpkin and pumpkin.Parent then
            local distance = (playerRootPart.Position - pumpkin.Position).Magnitude
            if distance < 5 then
                -- Simulate "collection" by removing ESP label and teleport button
                data.label:Destroy()
                detectedPumpkins[pumpkin] = nil
            end
        end
    end
end

-- Update Character Reference if Player Respawns
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    playerRootPart = character:WaitForChild("HumanoidRootPart")
end)

-- Continuous Update Loop for ESP and Collection Check
game:GetService("RunService").RenderStepped:Connect(function()
    updateESP()
    checkCollection()
end)
