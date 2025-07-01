
-- Enhanced Particle Spammer Script with Server-Side Elements
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local spamming = false
local spamConnection = nil
local particles = {}
local serverParticles = {}

-- Enhanced particle data with proper textures
local particleEffects = {
    {
        name = "Fire",
        texture = "rbxasset://textures/particles/fire_main.dds",
        color = ColorSequence.new(Color3.fromRGB(255, 100, 0)),
        size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(0.5, 1.2),
            NumberSequenceKeypoint.new(1, 0)
        },
        lifetime = NumberRange.new(0.5, 1.5),
        rate = 150
    },
    {
        name = "Smoke",
        texture = "rbxasset://textures/particles/smoke_main.dds",
        color = ColorSequence.new(Color3.fromRGB(100, 100, 100)),
        size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.5, 1.5),
            NumberSequenceKeypoint.new(1, 2)
        },
        lifetime = NumberRange.new(1, 3),
        rate = 100
    },
    {
        name = "Sparkles",
        texture = "rbxasset://textures/particles/sparkles_main.dds",
        color = ColorSequence.new(Color3.fromRGB(255, 255, 0)),
        size = NumberSequence.new(0.8),
        lifetime = NumberRange.new(0.3, 1),
        rate = 200
    },
    {
        name = "Magic",
        texture = "rbxasset://textures/particles/explosion_main.dds",
        color = ColorSequence.new(Color3.fromRGB(255, 0, 255)),
        size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.3, 1.5),
            NumberSequenceKeypoint.new(1, 0.5)
        },
        lifetime = NumberRange.new(0.8, 2),
        rate = 120
    },
    {
        name = "Snow",
        texture = "rbxasset://textures/particles/snow_main.dds",
        color = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
        size = NumberSequence.new(0.3),
        lifetime = NumberRange.new(2, 4),
        rate = 80
    }
}

-- Find all particles in the game
local function findParticles()
    particles = {}
    local foundCount = 0
    
    -- Search through all game objects for ParticleEmitters
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") and obj.Enabled then
            table.insert(particles, obj)
            foundCount = foundCount + 1
        end
    end
    
    -- Also search in ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("ParticleEmitter") and obj.Enabled then
            table.insert(particles, obj)
            foundCount = foundCount + 1
        end
    end
    
    -- Search in all players' characters
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, obj in pairs(player.Character:GetDescendants()) do
                if obj:IsA("ParticleEmitter") and obj.Enabled then
                    table.insert(particles, obj)
                    foundCount = foundCount + 1
                end
            end
        end
    end
    
    print("Found " .. foundCount .. " real particles in the game!")
    
    -- Always add custom particle effects for variety
    for _, effect in pairs(particleEffects) do
        table.insert(particles, effect)
    end
    
    print("Total particles available: " .. #particles .. " (including " .. #particleEffects .. " custom effects)")
end

-- Create enhanced particle around player
local function createParticle(particleData)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local playerPos = LocalPlayer.Character.HumanoidRootPart.Position

    -- Create invisible part to hold particle
    local part = Instance.new("Part")
    part.Name = "ParticleHolder"
    part.Transparency = 1
    part.CanCollide = false
    part.Anchored = true
    part.Size = Vector3.new(0.1, 0.1, 0.1)

    -- Random position around player with better distribution
    local angle = math.random() * math.pi * 2
    local distance = math.random(3, 12)
    local height = math.random(-2, 6)

    part.Position = playerPos + Vector3.new(
        math.cos(angle) * distance,
        height,
        math.sin(angle) * distance
    )

    part.Parent = workspace

    local particle
    if type(particleData) == "table" and particleData.name then
        -- Create custom particle with proper settings
        particle = Instance.new("ParticleEmitter")
        particle.Name = particleData.name .. "Effect"
        particle.Texture = particleData.texture
        particle.Color = particleData.color
        particle.Size = particleData.size
        particle.Lifetime = particleData.lifetime
        particle.Rate = particleData.rate
        particle.SpreadAngle = Vector2.new(45, 45)
        particle.Speed = NumberRange.new(3, 8)
        particle.Acceleration = Vector3.new(0, -5, 0)
        particle.Drag = 1
        particle.VelocityInheritance = 0.5
    else
        -- Clone existing particle and enhance it
        particle = particleData:Clone()
        particle.Rate = math.max(particle.Rate, 50) -- Ensure minimum visibility
        particle.Lifetime = NumberRange.new(
            math.max(particle.Lifetime.Min, 0.5),
            math.max(particle.Lifetime.Max, 2)
        )
    end
    
    particle.Parent = part
    particle.Enabled = true

    -- Add movement animation for more dynamic effect
    local tweenInfo = TweenInfo.new(
        math.random(4, 10),
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    )
    
    local targetPos = part.Position + Vector3.new(
        math.random(-8, 8),
        math.random(-3, 6),
        math.random(-8, 8)
    )
    
    local tween = TweenService:Create(part, tweenInfo, {
        Position = targetPos
    })
    tween:Play()

    -- Auto-destroy after some time
    Debris:AddItem(part, math.random(8, 15))
    
    print("Created particle: " .. (type(particleData) == "table" and particleData.name or "Cloned"))
end

-- Enhanced start function with multiple spam modes
local function startSpamming()
    if spamming then
        print("Already spamming!")
        return
    end
    
    findParticles()
    
    if #particles == 0 then
        print("No particles found in this game!")
        return
    end

    spamming = true
    print("Started enhanced particle spamming with " .. #particles .. " different particles!")

    spamConnection = RunService.Heartbeat:Connect(function()
        -- Higher spam rate for better visibility
        local spamChance = math.sin(tick() * 3) * 0.15 + 0.25 -- Oscillates between 10% and 40%
        
        if math.random() < spamChance then
            local randomParticle = particles[math.random(1, #particles)]
            createParticle(randomParticle)
        end
        
        -- More frequent burst mode
        if math.random(1, 150) == 1 then -- More frequent bursts
            print("PARTICLE BURST MODE!")
            for i = 1, math.random(8, 20) do
                task.wait(0.05)
                local randomParticle = particles[math.random(1, #particles)]
                createParticle(randomParticle)
            end
        end
    end)
end

local function stopSpamming()
    spamming = false
    if spamConnection then
        spamConnection:Disconnect()
        spamConnection = nil
    end
    print("Stopped particle spamming!")
end

-- Enhanced cleanup function
local function cleanupAllParticles()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "ParticleHolder" then
            obj:Destroy()
        end
    end
    print("Cleaned up all particle holders!")
end

-- Force spam function for testing
local function forceSpam()
    findParticles()
    print("Force spawning particles...")
    for i = 1, 10 do
        if #particles > 0 then
            local randomParticle = particles[math.random(1, #particles)]
            createParticle(randomParticle)
            task.wait(0.1)
        end
    end
end

-- Initialize
print("Loading Enhanced Particle Spammer...")
findParticles()

-- Auto-start with a test
if #particles > 0 then
    forceSpam() -- Create some particles immediately to test
    task.wait(2)
    startSpamming()
    print("Enhanced Particle spammer loaded and started!")
    print("Features: Variable rate, burst mode, custom effects")
else
    print("No particles found, but custom effects are available!")
    startSpamming() -- Start anyway with custom effects
end

-- Global commands to control
_G.stopParticleSpam = stopSpamming
_G.startParticleSpam = startSpamming
_G.refreshParticles = findParticles
_G.cleanupParticles = cleanupAllParticles
_G.forceSpamParticles = forceSpam
_G.burstParticles = function()
    print("Manual burst mode activated!")
    for i = 1, 25 do
        task.wait(0.03)
        if #particles > 0 then
            createParticle(particles[math.random(1, #particles)])
        end
    end
end

print("Enhanced Particle Spammer Commands:")
print("_G.startParticleSpam() - Start spamming")
print("_G.stopParticleSpam() - Stop spamming") 
print("_G.refreshParticles() - Refresh particle list")
print("_G.cleanupParticles() - Clean up all particles")
print("_G.forceSpamParticles() - Force spawn test particles")
print("_G.burstParticles() - Create particle burst")
