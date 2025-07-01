
-- Blade Ball Auto Parry Script
-- Automatically detects and parries incoming balls

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration
local AutoParry = {
    Enabled = false,
    ParryDistance = 15, -- Distance to start parrying
    PredictionTime = 0.15, -- Time to predict ball movement
    ParryDelay = 0, -- Delay before parrying (in seconds)
    VisualIndicator = true,
    ParryKey = Enum.KeyCode.F -- Key to toggle auto parry
}

-- Variables
local Connections = {}
local BallConnections = {}
local ParryRemote = nil
local LastParryTime = 0
local ParryDebounce = {}

-- GUI Elements for visual feedback
local ScreenGui = nil
local StatusLabel = nil

-- Find parry remote
local function findParryRemote()
    -- Common remote names for Blade Ball parry
    local possibleNames = {"ParryButtonPress", "Parry", "ParryAttempt", "ParryBall", "Deflect"}
    
    for _, name in pairs(possibleNames) do
        local remote = ReplicatedStorage:FindFirstChild(name)
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    
    -- Search in subfolders
    for _, folder in pairs(ReplicatedStorage:GetChildren()) do
        if folder:IsA("Folder") then
            for _, name in pairs(possibleNames) do
                local remote = folder:FindFirstChild(name)
                if remote and remote:IsA("RemoteEvent") then
                    return remote
                end
            end
        end
    end
    
    return nil
end

-- Create GUI
local function createGUI()
    if ScreenGui then return end
    
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AutoParryGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = ScreenGui
    StatusLabel.Size = UDim2.new(0, 200, 0, 50)
    StatusLabel.Position = UDim2.new(0, 10, 0, 10)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    StatusLabel.BackgroundTransparency = 0.3
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 16
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = "Auto Parry: OFF"
    
    local corner = Instance.new("UICorner")
    corner.Parent = StatusLabel
    corner.CornerRadius = UDim.new(0, 8)
end

-- Update GUI
local function updateGUI()
    if StatusLabel then
        StatusLabel.Text = "Auto Parry: " .. (AutoParry.Enabled and "ON" or "OFF")
        StatusLabel.TextColor3 = AutoParry.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    end
end

-- Get ball velocity and predict position
local function predictBallPosition(ball, deltaTime)
    if not ball or not ball.Parent then return nil end
    
    local velocity = ball.Velocity
    if velocity.Magnitude < 1 then return ball.Position end
    
    return ball.Position + (velocity * deltaTime)
end

-- Check if ball is targeting player
local function isBallTargeting(ball)
    if not ball or not ball.Parent or not LocalPlayer.Character then return false end
    
    local character = LocalPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local ballPosition = ball.Position
    local ballVelocity = ball.Velocity
    local playerPosition = humanoidRootPart.Position
    
    -- Check if ball is moving towards player
    if ballVelocity.Magnitude < 1 then return false end
    
    local directionToBall = (ballPosition - playerPosition).Unit
    local ballDirection = ballVelocity.Unit
    
    -- Check if ball is moving in player's general direction
    local dotProduct = directionToBall:Dot(-ballDirection)
    return dotProduct > 0.3 -- Adjust this value for sensitivity
end

-- Calculate distance to ball
local function getDistanceToBall(ball)
    if not ball or not LocalPlayer.Character then return math.huge end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return math.huge end
    
    return (ball.Position - humanoidRootPart.Position).Magnitude
end

-- Parry function
local function performParry()
    local currentTime = tick()
    if currentTime - LastParryTime < 0.5 then return end -- Prevent spam
    
    LastParryTime = currentTime
    
    if ParryRemote then
        ParryRemote:FireServer()
        print("Auto Parry: Parried!")
    else
        -- Fallback: simulate key press
        local virtualInput = {
            KeyCode = Enum.KeyCode.Space,
            UserInputType = Enum.UserInputType.Keyboard
        }
        UserInputService:GetService("UserInputService").InputBegan:Fire(virtualInput)
    end
end

-- Monitor balls
local function monitorBall(ball)
    if BallConnections[ball] then return end
    
    BallConnections[ball] = RunService.Heartbeat:Connect(function()
        if not AutoParry.Enabled or not ball or not ball.Parent then
            if BallConnections[ball] then
                BallConnections[ball]:Disconnect()
                BallConnections[ball] = nil
            end
            return
        end
        
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        -- Check if ball is targeting player
        if not isBallTargeting(ball) then return end
        
        local distance = getDistanceToBall(ball)
        
        -- Parry when ball is within range
        if distance <= AutoParry.ParryDistance then
            if AutoParry.ParryDelay > 0 then
                task.wait(AutoParry.ParryDelay)
            end
            performParry()
        end
    end)
end

-- Find and monitor balls
local function findBalls()
    -- Common ball names in Blade Ball
    local ballNames = {"Ball", "ball", "SoccerBall", "BasketBall", "TennisBall"}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
            monitorBall(obj)
        end
    end
    
    -- Monitor for new balls
    Workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
            task.wait(0.1) -- Small delay to ensure ball is properly initialized
            monitorBall(obj)
        end
    end)
end

-- Toggle auto parry
local function toggleAutoParry()
    AutoParry.Enabled = not AutoParry.Enabled
    updateGUI()
    
    if AutoParry.Enabled then
        print("Auto Parry: Enabled")
    else
        print("Auto Parry: Disabled")
    end
end

-- Key input handler
local function onKeyPress(key)
    if key.KeyCode == AutoParry.ParryKey then
        toggleAutoParry()
    end
end

-- Initialize
local function initialize()
    -- Find parry remote
    ParryRemote = findParryRemote()
    if ParryRemote then
        print("Auto Parry: Found parry remote - " .. ParryRemote.Name)
    else
        print("Auto Parry: Parry remote not found, using fallback method")
    end
    
    -- Create GUI
    createGUI()
    updateGUI()
    
    -- Set up input detection
    Connections.KeyPress = UserInputService.InputBegan:Connect(onKeyPress)
    
    -- Find and monitor balls
    findBalls()
    
    print("Auto Parry: Initialized successfully!")
    print("Press " .. AutoParry.ParryKey.Name .. " to toggle auto parry")
end

-- Cleanup function
local function cleanup()
    for _, connection in pairs(Connections) do
        if connection then connection:Disconnect() end
    end
    
    for _, connection in pairs(BallConnections) do
        if connection then connection:Disconnect() end
    end
    
    if ScreenGui then
        ScreenGui:Destroy()
    end
    
    Connections = {}
    BallConnections = {}
end

-- Initialize the script
initialize()

-- Global functions for external control
_G.AutoParryToggle = toggleAutoParry
_G.AutoParryCleanup = cleanup
_G.AutoParryConfig = AutoParry

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        cleanup()
    end
end)

print("Blade Ball Auto Parry loaded successfully!")
print("Configuration:")
print("- Parry Distance:", AutoParry.ParryDistance)
print("- Prediction Time:", AutoParry.PredictionTime)
print("- Parry Delay:", AutoParry.ParryDelay)
print("- Toggle Key:", AutoParry.ParryKey.Name)
