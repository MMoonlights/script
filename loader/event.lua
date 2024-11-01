-- Player and Character Setup
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local playerRootPart = character:WaitForChild("HumanoidRootPart")

-- Folder and Pumpkin Setup
local eventFolder = game:GetService("Workspace"):WaitForChild("HalloweenEvent")
local pumpkinsFolder = eventFolder:WaitForChild("Objects")
local posFolder = eventFolder:WaitForChild("Pos")
local pumpkinPrefix = "Pumpkin_"
local pumpkinCount = 10 -- Adjust if there are more pumpkins
local detectedPumpkins = {}

-- Initialize ScreenGui for ESP and Teleport Menu
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PumpkinESP_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

print("ScreenGui for ESP and teleport menu created")

-- Function to Create ESP Label for a Pumpkin
local function createESPLabel(pumpkin)
    print("Creating ESP label for:", pumpkin.Name)
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

-- Create Teleport Menu
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

print("Teleport menu created in ScreenGui")

-- Function to Add a Teleport Button for Each Pumpkin
local function addTeleportButton(pumpkin, pos)
    print("Adding teleport button for:", pumpkin.Name)
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
            print("Teleporting to pumpkin:", pumpkin.Name, "at position:", pos.Position)
            playerRootPart.CFrame = pos.CFrame
        end
    end)
end

-- Function to Update ESP for Each Pumpkin
local function updateESP()
    for i = 1, pumpkinCount do
        local pumpkin = pumpkinsFolder:FindFirstChild(pumpkinPrefix .. i)
        local pos = posFolder:FindFirstChild("Part" .. i) -- Change to "Part" if all positions are just named "Part"

        if not pumpkin then
            print("Pumpkin", pumpkinPrefix .. i, "not found.")
            continue
        end
        
        if not pos then
            print("Position part not found for pumpkin", pumpkinPrefix .. i)
            continue
        end

        -- Set up ESP and Teleport Button if not already added
        if not detectedPumpkins[pumpkin] then
            print("Setting up ESP and teleport for:", pumpkin.Name)
            detectedPumpkins[pumpkin] = {
                label = createESPLabel(pumpkin),
                pos = pos
            }
            addTeleportButton(pumpkin, pos)
        end

        -- Update ESP Label with Position and Distance
        if detectedPumpkins[pumpkin] then
            local distance = (playerRootPart.Position - pos.Position).Magnitude
            detectedPumpkins[pumpkin].label.Text = string.format("%s - Distance: %.1f", pumpkin.Name, distance)
            local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(pos.Position)

            -- Update label position if pumpkin is on-screen
            if onScreen then
                detectedPumpkins[pumpkin].label.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                detectedPumpkins[pumpkin].label.Visible = true
                print("Pumpkin:", pumpkin.Name, "is on screen at position:", screenPos)
            else
                detectedPumpkins[pumpkin].label.Visible = false
                print("Pumpkin:", pumpkin.Name, "is off-screen.")
            end
        end
    end
end

-- Function to Check Collection and Remove ESP When Collected
local function checkCollection()
    for pumpkin, data in pairs(detectedPumpkins) do
        local pos = data.pos
        local distance = (playerRootPart.Position - pos.Position).Magnitude
        if distance < 5 then
            -- Simulate "collection" by removing ESP label and teleport button
            print("Collected pumpkin:", pumpkin.Name, "- Removing ESP and teleport button.")
            data.label:Destroy()
            detectedPumpkins[pumpkin] = nil
        else
            print("Pumpkin:", pumpkin.Name, "is not yet collected. Distance:", distance)
        end
    end
end

-- Update Character Reference if Player Respawns
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    playerRootPart = character:WaitForChild("HumanoidRootPart")
    print("Character respawned, updated playerRootPart.")
end)

-- Continuous Update Loop for ESP and Collection Check
game:GetService("RunService").RenderStepped:Connect(function()
    print("Running updateESP and checkCollection")
    updateESP()
    checkCollection()
end)
