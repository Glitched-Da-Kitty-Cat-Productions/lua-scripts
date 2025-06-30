-- Simple Particle Spammer Script
-- Spams all available particles in the game around the player

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local spamming = false
local spamConnection = nil
local particles = {}

-- Find all particles in the game
local function findParticles()
    particles = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            table.insert(particles, obj)
        end
    end
    print("Found " .. #particles .. " particles in the game!")
end

-- Create particle around player
local function createParticle(originalParticle)
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

    -- Random position around player
    local angle = math.random() * math.pi * 2
    local distance = math.random(3, 10)
    local height = math.random(-2, 5)

    part.Position = playerPos + Vector3.new(
        math.cos(angle) * distance,
        height,
        math.sin(angle) * distance
    )

    part.Parent = workspace

    -- Clone and enhance the particle
    local particle = originalParticle:Clone()
    particle.Parent = part
    particle.Enabled = true
    particle.Rate = math.random(50, 200)

    -- Auto-destroy after some time
    game:GetService("Debris"):AddItem(part, math.random(5, 15))
end

-- Start/Stop functions
local function startSpamming()
    if #particles == 0 then
        findParticles()
        if #particles == 0 then
            print("No particles found in this game!")
            return
        end
    end

    spamming = true
    print("Started particle spamming!")

    spamConnection = RunService.Heartbeat:Connect(function()
        if math.random(1, 10) == 1 then -- 10% chance per frame
            local randomParticle = particles[math.random(1, #particles)]
            createParticle(randomParticle)
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

-- Auto-start the spammer
findParticles()
if #particles > 0 then
    startSpamming()
    print("Particle spammer loaded and started!")
else
    print("No particles found to spam!")
end

-- Commands to control
_G.stopParticleSpam = stopSpamming
_G.startParticleSpam = startSpamming
_G.refreshParticles = findParticles
