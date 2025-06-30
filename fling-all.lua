
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Create fling tool if it doesn't exist
local flingTool = player.Backpack:FindFirstChild("Fling Tool")
if not flingTool then
    flingTool = Instance.new("Tool")
    flingTool.Name = "Fling Tool"
    flingTool.RequiresHandle = false
    flingTool.Parent = player.Backpack
end

local hiddenfling = false
local flingThread
local isRunning = false

local function fling()
    local lp = player
    local c, hrp, vel, movel = nil, nil, nil, 0.1

    while hiddenfling do
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

local function startFling()
    hiddenfling = true
    flingThread = coroutine.create(fling)
    coroutine.resume(flingThread)
end

local function stopFling()
    hiddenfling = false
end

local function flingAllPlayers()
    if isRunning then
        print("Fling All is already running!")
        return
    end
    
    isRunning = true
    print("Starting Fling All - targeting all players...")
    
    -- Equip the fling tool
    flingTool.Parent = character
    wait(0.5)
    
    -- Get all players except local player
    local targetPlayers = {}
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targetPlayers, targetPlayer)
        end
    end
    
    if #targetPlayers == 0 then
        print("No valid targets found!")
        isRunning = false
        return
    end
    
    print("Found " .. #targetPlayers .. " targets")
    
    -- Store original position
    local originalPosition = humanoidRootPart.CFrame
    
    -- Teleport to each player and fling
    for i, targetPlayer in pairs(targetPlayers) do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            print("Targeting player " .. i .. "/" .. #targetPlayers .. ": " .. targetPlayer.Name)
            
            -- Teleport to target
            local targetPosition = targetPlayer.Character.HumanoidRootPart.CFrame
            humanoidRootPart.CFrame = targetPosition + Vector3.new(0, 5, 0)
            
            wait(0.3)
            
            -- Start fling
            startFling()
            wait(2) -- Fling duration
            stopFling()
            
            wait(0.5)
        end
    end
    
    -- Return to original position
    print("Returning to original position...")
    humanoidRootPart.CFrame = originalPosition
    
    -- Unequip tool
    flingTool.Parent = player.Backpack
    
    print("Fling All completed!")
    isRunning = false
end

-- Set up tool events
flingTool.Equipped:Connect(function()
    if not isRunning then
        startFling()
    end
end)

flingTool.Unequipped:Connect(function()
    if not isRunning then
        stopFling()
    end
end)

-- Start the fling all process
flingAllPlayers()
