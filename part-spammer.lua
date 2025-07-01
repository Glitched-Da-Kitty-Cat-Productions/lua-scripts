
-- Enhanced Particle Spammer Script with Server-Side Elements
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local spamming = false
local spamConnection = nil
local particles = {}
local serverParticles = {}

-- Create remote events for server-side functionality
local particleRemote = Instance.new("RemoteEvent")
particleRemote.Name = "ParticleSpammer"
particleRemote.Parent = ReplicatedStorage

-- Enhanced particle data
local particleEffects = {
    {name = "Fire", color = Color3.fromRGB(255, 0, 0), size = NumberSequence.new(2)},
    {name = "Smoke", color = Color3.fromRGB(100, 100, 100), size = NumberSequence.new(1.5)},
    {name = "Sparkles", color = Color3.fromRGB(255, 255, 0), size = NumberSequence.new(1)},
    {name = "Magic", color = Color3.fromRGB(255, 0, 255), size = NumberSequence.new(3)},
    {name = "Snow", color = Color3.fromRGB(255, 255, 255), size = NumberSequence.new(0.5)},
}

-- Find all particles in the game
local function findParticles()
    particles = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            table.insert(particles, obj)
        end
    end
    print("Found " .. #particles .. " particles in the game!")
    
    -- Add custom particle effects if no particles found
    if #particles == 0 then
        particles = particleEffects
        print("Using custom particle effects!")
    end
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
    local distance = math.random(5, 15)
    local height = math.random(-3, 8)

    part.Position = playerPos + Vector3.new(
        math.cos(angle) * distance,
        height,
        math.sin(angle) * distance
    )

    part.Parent = workspace

    local particle
    if type(particleData) == "table" and particleData.name then
        -- Create custom particle
        particle = Instance.new("ParticleEmitter")
        particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        particle.Color = ColorSequence.new(particleData.color)
        particle.Size = particleData.size
        particle.Lifetime = NumberRange.new(1, 3)
        particle.Rate = math.random(50, 150)
        particle.SpreadAngle = Vector2.new(45, 45)
        particle.Speed = NumberRange.new(5, 10)
    else
        -- Clone existing particle
        particle = particleData:Clone()
    end
    
    particle.Parent = part
    particle.Enabled = true
    particle.Rate = math.random(100, 300)

    -- Add movement animation
    local tweenInfo = TweenInfo.new(
        math.random(3, 8),
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    )
    
    local tween = TweenService:Create(part, tweenInfo, {
        Position = part.Position + Vector3.new(
            math.random(-5, 5),
            math.random(-2, 5),
            math.random(-5, 5)
        )
    })
    tween:Play()

    -- Auto-destroy after some time
    game:GetService("Debris"):AddItem(part, math.random(10, 20))
    
    -- Try to replicate to server
    pcall(function()
        particleRemote:FireServer("create", {
            position = part.Position,
            particleType = type(particleData) == "table" and particleData.name or "default"
        })
    end)
end

-- Server-side particle creation (for other players to see)
local function createServerParticle(position, particleType)
    local part = Instance.new("Part")
    part.Name = "ServerParticleHolder"
    part.Transparency = 1
    part.CanCollide = false
    part.Anchored = true
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Position = position
    part.Parent = workspace

    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxasset://textures/particles/fire_main.dds"
    particle.Rate = 100
    particle.Lifetime = NumberRange.new(1, 2)
    particle.Parent = part
    particle.Enabled = true

    -- Set particle properties based on type
    for _, effect in pairs(particleEffects) do
        if effect.name == particleType then
            particle.Color = ColorSequence.new(effect.color)
            particle.Size = effect.size
            break
        end
    end

    game:GetService("Debris"):AddItem(part, 10)
    table.insert(serverParticles, part)
end

-- Enhanced start function with multiple spam modes
local function startSpamming()
    if #particles == 0 then
        findParticles()
        if #particles == 0 then
            print("No particles found in this game!")
            return
        end
    end

    spamming = true
    print("Started enhanced particle spamming!")

    spamConnection = RunService.Heartbeat:Connect(function()
        -- Variable spam rate based on time
        local spamChance = math.sin(tick() * 2) * 0.1 + 0.15 -- Oscillates between 5% and 25%
        
        if math.random() < spamChance then
            local randomParticle = particles[math.random(1, #particles)]
            createParticle(randomParticle)
        end
        
        -- Occasional burst mode
        if math.random(1, 300) == 1 then -- Very rare burst
            for i = 1, math.random(5, 15) do
                task.wait(0.1)
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
    
    -- Clean up server particles
    for _, part in pairs(serverParticles) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    serverParticles = {}
end

-- Remote event handling for server-side functionality
particleRemote.OnServerEvent:Connect(function(player, action, data)
    if action == "create" and data.position then
        createServerParticle(data.position, data.particleType)
    end
end)

-- Enhanced cleanup function
local function cleanupAllParticles()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "ParticleHolder" or obj.Name == "ServerParticleHolder" then
            obj:Destroy()
        end
    end
    print("Cleaned up all particle holders!")
end

-- Auto-start the enhanced spammer
findParticles()
if #particles > 0 then
    startSpamming()
    print("Enhanced Particle spammer loaded and started!")
    print("Features: Variable rate, burst mode, server-side replication")
else
    print("No particles found to spam!")
end

-- Global commands to control
_G.stopParticleSpam = stopSpamming
_G.startParticleSpam = startSpamming
_G.refreshParticles = findParticles
_G.cleanupParticles = cleanupAllParticles
_G.burstParticles = function()
    for i = 1, 20 do
        task.wait(0.05)
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
print("_G.burstParticles() - Create particle burst")
