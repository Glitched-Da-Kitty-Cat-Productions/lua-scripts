
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local isRunning = false
local originalCFrame = humanoidRootPart.CFrame

-- Anti-death measures
local function protectPlayer()
    if humanoid then
        humanoid.PlatformStand = true
        humanoidRootPart.Anchored = true
    end
end

local function unprotectPlayer()
    if humanoid then
        humanoid.PlatformStand = false
        humanoidRootPart.Anchored = false
    end
end

-- Improved fling function with safety
local function performFling(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local targetHRP = targetPlayer.Character.HumanoidRootPart
    local targetPosition = targetHRP.Position
    
    -- Protect ourselves before flinging
    protectPlayer()
    
    -- Move close to target safely using TweenService
    local moveInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local targetCFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
    local moveTween = TweenService:Create(humanoidRootPart, moveInfo, {CFrame = targetCFrame})
    
    moveTween:Play()
    moveTween.Completed:Wait()
    
    wait(0.2)
    
    -- Apply fling force to target
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(
        math.random(-100, 100),
        math.random(50, 150),
        math.random(-100, 100)
    )
    bodyVelocity.Parent = targetHRP
    
    -- Apply our own controlled velocity for fling effect
    local ourBodyVelocity = Instance.new("BodyVelocity")
    ourBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    ourBodyVelocity.Velocity = Vector3.new(0, 50, 0)
    ourBodyVelocity.Parent = humanoidRootPart
    
    wait(0.1)
    
    -- Clean up
    if bodyVelocity then bodyVelocity:Destroy() end
    if ourBodyVelocity then ourBodyVelocity:Destroy() end
    
    wait(0.3)
    
    return true
end

local function flingAllPlayers()
    if isRunning then
        print("Fling All is already running!")
        return
    end
    
    isRunning = true
    originalCFrame = humanoidRootPart.CFrame
    
    print("Starting Fling All - targeting all players...")
    
    -- Get all valid targets
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
    
    -- Fling each player
    for i, targetPlayer in pairs(targetPlayers) do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            print("Targeting player " .. i .. "/" .. #targetPlayers .. ": " .. targetPlayer.Name)
            
            local success = performFling(targetPlayer)
            if success then
                print("Successfully flung " .. targetPlayer.Name)
            else
                print("Failed to fling " .. targetPlayer.Name)
            end
            
            wait(0.8) -- Delay between targets
        end
    end
    
    -- Return to original position safely
    print("Returning to original position...")
    unprotectPlayer()
    
    local returnInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local returnTween = TweenService:Create(humanoidRootPart, returnInfo, {CFrame = originalCFrame})
    returnTween:Play()
    returnTween.Completed:Wait()
    
    print("Fling All completed!")
    isRunning = false
end

-- Start the fling all process
flingAllPlayers()
