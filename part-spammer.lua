
-- Advanced Particle Spammer with GUI
-- Shows available particles and spawns them around the player

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local spamming = false
local particleList = {}
local spawnedParticles = {}
local spamConnection = nil

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ScanButton = Instance.new("TextButton")
local ParticleScrollFrame = Instance.new("ScrollingFrame")
local ControlFrame = Instance.new("Frame")
local SpawnButton = Instance.new("TextButton")
local ClearButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local ParticleCountLabel = Instance.new("TextLabel")

ScreenGui.Name = "AdvancedParticleSpammer"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Advanced Particle Spammer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

-- Scan Button
ScanButton.Parent = MainFrame
ScanButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
ScanButton.BorderSizePixel = 0
ScanButton.Position = UDim2.new(0, 10, 0, 35)
ScanButton.Size = UDim2.new(1, -20, 0, 30)
ScanButton.Font = Enum.Font.Gotham
ScanButton.Text = "🔍 Scan for Available Particles"
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextSize = 12

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 4)
ScanCorner.Parent = ScanButton

-- Particle Count Label
ParticleCountLabel.Parent = MainFrame
ParticleCountLabel.BackgroundTransparency = 1
ParticleCountLabel.Position = UDim2.new(0, 10, 0, 70)
ParticleCountLabel.Size = UDim2.new(1, -20, 0, 20)
ParticleCountLabel.Font = Enum.Font.Gotham
ParticleCountLabel.Text = "Available Particles: 0"
ParticleCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ParticleCountLabel.TextSize = 10
ParticleCountLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Particle List Frame
ParticleScrollFrame.Parent = MainFrame
ParticleScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ParticleScrollFrame.BorderSizePixel = 0
ParticleScrollFrame.Position = UDim2.new(0, 10, 0, 95)
ParticleScrollFrame.Size = UDim2.new(1, -20, 0, 250)
ParticleScrollFrame.ScrollBarThickness = 6
ParticleScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ParticleScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 4)
ScrollCorner.Parent = ParticleScrollFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Parent = ParticleScrollFrame
ScrollLayout.Padding = UDim.new(0, 5)
ScrollLayout.SortOrder = Enum.SortOrder.Name

-- Control Frame
ControlFrame.Parent = MainFrame
ControlFrame.BackgroundTransparency = 1
ControlFrame.Position = UDim2.new(0, 10, 0, 355)
ControlFrame.Size = UDim2.new(1, -20, 0, 60)

SpawnButton.Parent = ControlFrame
SpawnButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
SpawnButton.BorderSizePixel = 0
SpawnButton.Position = UDim2.new(0, 0, 0, 0)
SpawnButton.Size = UDim2.new(0.48, 0, 0, 30)
SpawnButton.Font = Enum.Font.Gotham
SpawnButton.Text = "🎉 Start Spawning"
SpawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnButton.TextSize = 12

ClearButton.Parent = ControlFrame
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0.52, 0, 0, 0)
ClearButton.Size = UDim2.new(0.48, 0, 0, 30)
ClearButton.Font = Enum.Font.Gotham
ClearButton.Text = "🧹 Clear All"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 12

StatusLabel.Parent = ControlFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 35)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: Ready - Click 'Scan' to find particles"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 9
StatusLabel.TextWrapped = true

-- Add corners to buttons
for _, button in pairs({SpawnButton, ClearButton}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
end

-- Particle System Functions
local function scanForParticles()
    particleList = {}
    local foundParticles = {}
    
    -- Clear existing list
    for _, child in pairs(ParticleScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Scan for all particle emitters in the game
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ParticleEmitter") and obj.Parent then
            local particleName = obj.Name
            local parentName = obj.Parent.Name
            local fullPath = obj:GetFullName()
            
            if not foundParticles[particleName] then
                foundParticles[particleName] = {
                    name = particleName,
                    parent = parentName,
                    path = fullPath,
                    originalEmitter = obj,
                    count = 1
                }
            else
                foundParticles[particleName].count = foundParticles[particleName].count + 1
            end
        end
    end
    
    -- Convert to list and create GUI elements
    for name, data in pairs(foundParticles) do
        table.insert(particleList, data)
        
        -- Create particle entry in GUI
        local ParticleFrame = Instance.new("Frame")
        ParticleFrame.Parent = ParticleScrollFrame
        ParticleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ParticleFrame.BorderSizePixel = 0
        ParticleFrame.Size = UDim2.new(1, -10, 0, 60)
        ParticleFrame.Name = name
        
        local FrameCorner = Instance.new("UICorner")
        FrameCorner.CornerRadius = UDim.new(0, 4)
        FrameCorner.Parent = ParticleFrame
        
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Parent = ParticleFrame
        NameLabel.BackgroundTransparency = 1
        NameLabel.Position = UDim2.new(0, 10, 0, 5)
        NameLabel.Size = UDim2.new(1, -20, 0, 20)
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.Text = "🎆 " .. name
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.TextSize = 11
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local InfoLabel = Instance.new("TextLabel")
        InfoLabel.Parent = ParticleFrame
        InfoLabel.BackgroundTransparency = 1
        InfoLabel.Position = UDim2.new(0, 10, 0, 25)
        InfoLabel.Size = UDim2.new(1, -20, 0, 15)
        InfoLabel.Font = Enum.Font.Gotham
        InfoLabel.Text = string.format("Parent: %s | Found: %d instances", data.parent, data.count)
        InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        InfoLabel.TextSize = 8
        InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local PathLabel = Instance.new("TextLabel")
        PathLabel.Parent = ParticleFrame
        PathLabel.BackgroundTransparency = 1
        PathLabel.Position = UDim2.new(0, 10, 0, 40)
        PathLabel.Size = UDim2.new(1, -20, 0, 15)
        PathLabel.Font = Enum.Font.Code
        PathLabel.Text = "Path: " .. data.path
        PathLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        PathLabel.TextSize = 7
        PathLabel.TextXAlignment = Enum.TextXAlignment.Left
        PathLabel.TextTruncate = Enum.TextTruncate.AtEnd
    end
    
    ParticleCountLabel.Text = "Available Particles: " .. #particleList
    StatusLabel.Text = string.format("Status: Found %d unique particle types!", #particleList)
    
    if #particleList == 0 then
        StatusLabel.Text = "Status: No particles found in this game"
    end
end

local function createParticleAroundPlayer(particleData)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    -- Create a part to attach the particle to
    local part = Instance.new("Part")
    part.Name = "SpammedParticle_" .. particleData.name
    part.Transparency = 1
    part.CanCollide = false
    part.Anchored = true
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    
    -- Random position around player
    local angle = math.random() * math.pi * 2
    local distance = math.random(2, 8)
    local height = math.random(-3, 6)
    
    part.Position = playerPos + Vector3.new(
        math.cos(angle) * distance,
        height,
        math.sin(angle) * distance
    )
    
    part.Parent = workspace
    
    -- Clone the original particle
    local particle = particleData.originalEmitter:Clone()
    particle.Parent = part
    particle.Enabled = true
    
    -- Enhance the particle
    particle.Rate = math.random(50, 200)
    particle.Lifetime = NumberRange.new(2, 5)
    particle.Speed = NumberRange.new(5, 15)
    
    -- Random colors if possible
    if particle:FindFirstChild("Color") then
        particle.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(math.random(), 0.8, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(math.random(), 0.8, 1))
        }
    end
    
    -- Make it move randomly
    local tween = TweenService:Create(part, 
        TweenInfo.new(math.random(3, 8), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = part.Position + Vector3.new(math.random(-5, 5), math.random(-2, 4), math.random(-5, 5))}
    )
    tween:Play()
    
    table.insert(spawnedParticles, {part = part, tween = tween})
    return part
end

local function startSpamming()
    if #particleList == 0 then
        StatusLabel.Text = "Status: No particles to spawn! Scan first."
        return
    end
    
    spamming = true
    SpawnButton.Text = "⏹ Stop Spawning"
    SpawnButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    StatusLabel.Text = "Status: Spawning particles around you!"
    
    spamConnection = RunService.Heartbeat:Connect(function()
        if math.random(1, 20) == 1 then -- 5% chance per frame
            local randomParticle = particleList[math.random(1, #particleList)]
            createParticleAroundPlayer(randomParticle)
            
            -- Limit total spawned particles
            if #spawnedParticles > 50 then
                local oldest = table.remove(spawnedParticles, 1)
                if oldest.tween then oldest.tween:Cancel() end
                if oldest.part then oldest.part:Destroy() end
            end
        end
    end)
end

local function stopSpamming()
    spamming = false
    SpawnButton.Text = "🎉 Start Spawning"
    SpawnButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.Text = "Status: Stopped spawning"
    
    if spamConnection then
        spamConnection:Disconnect()
        spamConnection = nil
    end
end

local function clearAllParticles()
    -- Stop spawning first
    if spamming then
        stopSpamming()
    end
    
    -- Clean up all spawned particles
    for _, data in pairs(spawnedParticles) do
        if data.tween then data.tween:Cancel() end
        if data.part and data.part.Parent then 
            data.part:Destroy() 
        end
    end
    spawnedParticles = {}
    
    StatusLabel.Text = "Status: Cleared all spawned particles"
end

-- Button Events
ScanButton.MouseButton1Click:Connect(function()
    scanForParticles()
end)

SpawnButton.MouseButton1Click:Connect(function()
    if spamming then
        stopSpamming()
    else
        startSpamming()
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    clearAllParticles()
end)

-- Auto-scan on load
task.wait(1)
scanForParticles()

print("Advanced Particle Spammer loaded! Scan for particles, then start spawning!")
