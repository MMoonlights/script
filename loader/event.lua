-- Player reference and event setup
local player = game.Players.LocalPlayer
local playerRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if not playerRootPart then
    player.CharacterAdded:Wait()
    playerRootPart = player.Character:WaitForChild("HumanoidRootPart")
end

local pumpkinsFolder = game.Workspace:WaitForChild("HalloweenEvent")
local pumpkinPrefix = "Pumpkin_"
local pumpkinCount = 10 -- Number of pumpkins

-- Store active ESPs
local espGUIs = {}

-- Function to create ESP for a pumpkin
local function createESP(pumpkin)
    -- Create BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PumpkinESP"
    billboard.Adornee = pumpkin
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    -- Create TextLabel to show pumpkin name and distance
    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange color
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    
    -- Store the ESP for later updates/removal
    espGUIs[pumpkin] = billboard
    billboard.Parent = pumpkin
end

-- Update ESP for each pumpkin
local function updateESP()
    for i = 1, pumpkinCount do
        local pumpkinName = pumpkinPrefix .. i
        local pumpkin = pumpkinsFolder:FindFirstChild(pumpkinName)
        
        -- Create ESP if it doesn't exist for this pumpkin
        if pumpkin and not espGUIs[pumpkin] then
            createESP(pumpkin)
        end

        -- Update ESP text with distance if it exists
        if pumpkin and espGUIs[pumpkin] then
            local distance = (playerRootPart.Position - pumpkin.Position).Magnitude
            espGUIs[pumpkin].TextLabel.Text = string.format("%s\nDistance: %.1f", pumpkin.Name, distance)
        end
    end
end

-- Function to detect collection and remove ESP
local function checkCollection()
    for pumpkin, gui in pairs(espGUIs) do
        local distance = (playerRootPart.Position - pumpkin.Position).Magnitude
        if distance < 5 then -- Assuming 5 studs is the "collect" range
            gui:Destroy() -- Remove ESP GUI
            espGUIs[pumpkin] = nil -- Remove from tracking
        end
    end
end

-- Continuous update and collection check
game:GetService("RunService").RenderStepped:Connect(function()
    updateESP()
    checkCollection()
end)
