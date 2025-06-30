
-- Particle Spammer Script
-- Spams all types of particles across the game

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local spamming = false
local particleTypes = {
    "Fire",
    "Smoke", 
    "Sparkles",
    "ParticleEmitter"
}

local particleSettings = {
    Fire = {
        Size = 30,
        Heat = 25,
        Color = Color3.fromRGB(255, 140, 0),
        SecondaryColor = Color3.fromRGB(255, 69, 0)
    },
    Smoke = {
        Size = 50,
        Opacity = 1,
        RiseVelocity = 25,
        Color = Color3.fromRGB(100, 100, 100)
    },
    Sparkles = {
        SparkleColor = Color3.fromRGB(255, 255, 0)
    },
    ParticleEmitter = {
        Rate = 500,
        Lifetime = NumberRange.new(2, 5),
        Speed = NumberRange.new(10, 50),
        SpreadAngle = Vector2.new(360, 360)
    }
}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local ClearButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "ParticleSpammer"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Active = true
Frame.Draggable = true

-- Add corner radius
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Frame

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Particle Spammer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 10, 0, 40)
ToggleButton.Size = UDim2.new(1, -20, 0, 30)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "Start Spamming"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 4)
ToggleCorner.Parent = ToggleButton

ClearButton.Parent = Frame
ClearButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0, 10, 0, 80)
ClearButton.Size = UDim2.new(1, -20, 0, 30)
ClearButton.Font = Enum.Font.Gotham
ClearButton.Text = "Clear All Particles"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 12

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 4)
ClearCorner.Parent = ClearButton

StatusLabel.Parent = Frame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 120)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: Stopped"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 10

-- Particle creation functions
local function createParticle(partType, part)
    local particle = Instance.new(partType)
    particle.Parent = part
    
    local settings = particleSettings[partType]
    if settings then
        for property, value in pairs(settings) do
            pcall(function()
                particle[property] = value
            end)
        end
    end
    
    return particle
end

local function spamParticles()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, partType in pairs(particleTypes) do
                pcall(function()
                    createParticle(partType, player.Character.HumanoidRootPart)
                end)
            end
        end
    end
    
    -- Also spam on random parts in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and math.random(1, 100) <= 5 then -- 5% chance per part
            local randomType = particleTypes[math.random(1, #particleTypes)]
            pcall(function()
                createParticle(randomType, obj)
            end)
        end
    end
end

local function clearAllParticles()
    for _, obj in pairs(workspace:GetDescendants()) do
        for _, particleType in pairs(particleTypes) do
            if obj:IsA(particleType) then
                obj:Destroy()
            end
        end
    end
end

-- Connection variable
local spamConnection

-- Button events
ToggleButton.MouseButton1Click:Connect(function()
    spamming = not spamming
    
    if spamming then
        ToggleButton.Text = "Stop Spamming"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        StatusLabel.Text = "Status: Spamming"
        
        spamConnection = RunService.Heartbeat:Connect(function()
            spamParticles()
        end)
    else
        ToggleButton.Text = "Start Spamming"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.Text = "Status: Stopped"
        
        if spamConnection then
            spamConnection:Disconnect()
        end
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    clearAllParticles()
    StatusLabel.Text = "Status: Cleared All"
    wait(2)
    StatusLabel.Text = spamming and "Status: Spamming" or "Status: Stopped"
end)

print("Particle Spammer loaded! Use the GUI to control it.")
