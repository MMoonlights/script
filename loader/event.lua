local player = game.Players.LocalPlayer
local playerRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if not playerRootPart then
    player.CharacterAdded:Wait()
    playerRootPart = player.Character:WaitForChild("HumanoidRootPart")
end

local pumpkinsFolder = game:GetService("Workspace"):WaitForChild("HalloweenEvent"):WaitForChild("Objects")
local pumpkinPrefix = "Pumpkin_"
local pumpkinCount = 10 -- Number of pumpkins
local espGUIs = {}

local function createESP(pumpkin)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PumpkinESP"
    billboard.Adornee = pumpkin
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    
    espGUIs[pumpkin] = billboard
    billboard.Parent = pumpkin
end

local function updateESP()
    for i = 1, pumpkinCount do
        local pumpkin = pumpkinsFolder:FindFirstChild(pumpkinPrefix .. i)
        if pumpkin and not espGUIs[pumpkin] then
            createESP(pumpkin)
        end

        if pumpkin and espGUIs[pumpkin] then
            local distance = (playerRootPart.Position - pumpkin.Position).Magnitude
            espGUIs[pumpkin].TextLabel.Text = string.format("%s\nDistance: %.1f", pumpkin.Name, distance)
        end
    end
end

local function checkCollection()
    for pumpkin, gui in pairs(espGUIs) do
        local distance = (playerRootPart.Position - pumpkin.Position).Magnitude
        if distance < 5 then
            gui:Destroy()
            espGUIs[pumpkin] = nil
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    updateESP()
    checkCollection()
end)
