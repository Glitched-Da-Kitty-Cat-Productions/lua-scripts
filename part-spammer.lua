
-- Particle Spammer Script (Fixed Version)
-- Spams actual particle emitters found in the game

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local spamming = false
local particleEmitters = {}
local particleConnections = {}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local ScanButton = Instance.new("TextButton")
local ClearButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local CountLabel = Instance.new("TextLabel")

ScreenGui.Name = "ParticleSpammer"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.Size = UDim2.new(0, 220, 0, 180)
Frame.Active = true
Frame.Draggable = true

-- Add corner radius
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Frame

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "Particle Spammer (Fixed)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12

ScanButton.Parent = Frame
ScanButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
ScanButton.BorderSizePixel = 0
ScanButton.Position = UDim2.new(0, 10, 0, 30)
ScanButton.Size = UDim2.new(1, -20, 0, 25)
ScanButton.Font = Enum.Font.Gotham
ScanButton.Text = "Scan for Particles"
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextSize = 10

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 4)
ScanCorner.Parent = ScanButton

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 10, 0, 60)
ToggleButton.Size = UDim2.new(1, -20, 0, 25)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "Start Spamming"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 10

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 4)
ToggleCorner.Parent = ToggleButton

ClearButton.Parent = Frame
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0, 10, 0, 90)
ClearButton.Size = UDim2.new(1, -20, 0, 25)
ClearButton.Font = Enum.Font.Gotham
ClearButton.Text = "Reset All Particles"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 10

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 4)
ClearCorner.Parent = ClearButton

CountLabel.Parent = Frame
CountLabel.BackgroundTransparency = 1
CountLabel.Position = UDim2.new(0, 10, 0, 120)
CountLabel.Size = UDim2.new(1, -20, 0, 15)
CountLabel.Font = Enum.Font.Gotham
CountLabel.Text = "Particles found: 0"
CountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CountLabel.TextSize = 9

StatusLabel.Parent = Frame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 140)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: Ready\nClick 'Scan for Particles' first"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 9
StatusLabel.TextWrapped = true

-- Particle scanning and manipulation functions
local function scanForParticles()
    particleEmitters = {}
    local count = 0
    
    -- Scan entire workspace for ParticleEmitters
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ParticleEmitter") and obj.Parent then
            table.insert(particleEmitters, {
                emitter = obj,
                originalEnabled = obj.Enabled,
                originalRate = obj.Rate
            })
            count = count + 1
        end
    end
    
    CountLabel.Text = "Particles found: " .. count
    StatusLabel.Text = "Status: Found " .. count .. " particle emitters\nReady to spam!"
    
    if count == 0 then
        StatusLabel.Text = "Status: No particles found\nTry a different game or area"
    end
end

local function enableAllParticles()
    local activated = 0
    for _, data in pairs(particleEmitters) do
        if data.emitter and data.emitter.Parent then
            data.emitter.Enabled = true
            data.emitter.Rate = math.random(200, 1000) -- Random high rate
            activated = activated + 1
        end
    end
    return activated
end

local function resetAllParticles()
    local reset = 0
    for _, data in pairs(particleEmitters) do
        if data.emitter and data.emitter.Parent then
            data.emitter.Enabled = data.originalEnabled
            data.emitter.Rate = data.originalRate
            reset = reset + 1
        end
    end
    return reset
end

local function createNewParticles()
    -- Create new particle emitters on random parts
    local parts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent and math.random(1, 100) <= 2 then -- 2% chance
            table.insert(parts, obj)
        end
    end
    
    for i = 1, math.min(10, #parts) do -- Limit to 10 new particles per frame
        local part = parts[math.random(1, #parts)]
        if part and part.Parent then
            local particle = Instance.new("ParticleEmitter")
            particle.Parent = part
            particle.Enabled = true
            particle.Rate = math.random(100, 500)
            particle.Lifetime = NumberRange.new(1, 3)
            particle.Speed = NumberRange.new(5, 20)
            particle.SpreadAngle = Vector2.new(45, 45)
            
            -- Random colors
            particle.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromHSV(math.random(), 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(math.random(), 1, 1))
            }
            
            table.insert(particleEmitters, {
                emitter = particle,
                originalEnabled = false,
                originalRate = 0
            })
        end
    end
end

-- Connection variable
local spamConnection

-- Button events
ScanButton.MouseButton1Click:Connect(function()
    scanForParticles()
end)

ToggleButton.MouseButton1Click:Connect(function()
    if #particleEmitters == 0 then
        StatusLabel.Text = "Status: No particles to spam!\nScan for particles first"
        return
    end
    
    spamming = not spamming
    
    if spamming then
        ToggleButton.Text = "Stop Spamming"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        
        local activated = enableAllParticles()
        StatusLabel.Text = "Status: Spamming " .. activated .. " particles\nCreating new ones..."
        
        spamConnection = RunService.Heartbeat:Connect(function()
            enableAllParticles()
            if math.random(1, 10) == 1 then -- 10% chance per frame to create new particles
                createNewParticles()
                CountLabel.Text = "Particles found: " .. #particleEmitters
            end
        end)
    else
        ToggleButton.Text = "Start Spamming"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.Text = "Status: Stopped spamming\nParticles still active"
        
        if spamConnection then
            spamConnection:Disconnect()
        end
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    local reset = resetAllParticles()
    StatusLabel.Text = "Status: Reset " .. reset .. " particles\nBack to original state"
    
    if spamConnection then
        spamConnection:Disconnect()
    end
    spamming = false
    ToggleButton.Text = "Start Spamming"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
end)

-- Auto-scan on load
task.wait(1)
scanForParticles()

print("Particle Spammer (Fixed) loaded! Scan for particles first, then start spamming.")
