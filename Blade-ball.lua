
-- Blade Ball Auto Parry Script (Fixed Version)
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
    Enabled = true, -- Auto-enabled on load
    ParryDistance = 25, -- Increased distance for better detection
    ParryKey = Enum.KeyCode.F, -- Key to toggle auto parry
    DebugMode = true -- Show debug messages
}

-- Variables
local Connections = {}
local ParryRemote = nil
local LastParryTime = 0
local ParryDebounce = 0.5 -- Prevent spam clicking

-- GUI Elements for visual feedback
local ScreenGui = nil
local StatusLabel = nil

-- Find parry remote (updated for current Blade Ball)
local function findParryRemote()
    local possiblePaths = {
        ReplicatedStorage:FindFirstChild("Remotes"),
        ReplicatedStorage:FindFirstChild("Events"),
        ReplicatedStorage
    }
    
    local possibleNames = {
        "ParryButtonPress", "Parry", "ParryAttempt", "ParryBall", 
        "Deflect", "ParryRemote", "Block", "Hit"
    }
    
    for _, parent in pairs(possiblePaths) do
        if parent then
            for _, name in pairs(possibleNames) do
                local remote = parent:FindFirstChild(name)
                if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
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
    StatusLabel.Size = UDim2.new(0, 250, 0, 60)
    StatusLabel.Position = UDim2.new(0, 10, 0, 10)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    StatusLabel.BackgroundTransparency = 0.2
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 18
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = "Auto Parry: ON\nPress F to toggle"
    StatusLabel.TextWrapped = true
    
    local corner = Instance.new("UICorner")
    corner.Parent = StatusLabel
    corner.CornerRadius = UDim.new(0, 8)
end

-- Update GUI
local function updateGUI()
    if StatusLabel then
        StatusLabel.Text = "Auto Parry: " .. (AutoParry.Enabled and "ON" or "OFF") .. "\nPress F to toggle"
        StatusLabel.TextColor3 = AutoParry.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
    end
end

-- Enhanced ball detection
local function findBalls()
    local balls = {}
    
    -- Check workspace for balls
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("ball") and obj.Parent and obj.Velocity then
            table.insert(balls, obj)
        end
    end
    
    -- Also check for specific ball models or folders
    local ballFolder = Workspace:FindFirstChild("Balls") or Workspace:FindFirstChild("Ball")
    if ballFolder then
        for _, obj in pairs(ballFolder:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Velocity then
                table.insert(balls, obj)
            end
        end
    end
    
    return balls
end

-- Check if ball is dangerous (moving towards player)
local function isBallDangerous(ball)
    if not ball or not ball.Parent or not LocalPlayer.Character then return false end
    
    local character = LocalPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local ballPosition = ball.Position
    local ballVelocity = ball.Velocity
    local playerPosition = humanoidRootPart.Position
    
    -- Check if ball is moving fast enough
    if ballVelocity.Magnitude < 10 then return false end
    
    -- Calculate distance
    local distance = (ballPosition - playerPosition).Magnitude
    
    -- Check if ball is moving towards player
    local directionToPlayer = (playerPosition - ballPosition).Unit
    local ballDirection = ballVelocity.Unit
    
    local dotProduct = directionToPlayer:Dot(ballDirection)
    
    -- Ball is dangerous if it's close, moving fast, and towards player
    return distance <= AutoParry.ParryDistance and dotProduct > 0.2
end

-- Perform parry action
local function performParry()
    local currentTime = tick()
    if currentTime - LastParryTime < ParryDebounce then return end
    
    LastParryTime = currentTime
    
    -- Try multiple parry methods
    local success = false
    
    -- Method 1: Fire remote if found
    if ParryRemote then
        if ParryRemote:IsA("RemoteEvent") then
            ParryRemote:FireServer()
            success = true
        elseif ParryRemote:IsA("RemoteFunction") then
            pcall(function() ParryRemote:InvokeServer() end)
            success = true
        end
    end
    
    -- Method 2: Simulate F key press
    if not success then
        local virtualInput = {
            KeyCode = Enum.KeyCode.F,
            UserInputType = Enum.UserInputType.Keyboard
        }
        UserInputService.InputBegan:Fire(virtualInput, false)
    end
    
    -- Method 3: Simulate Space key press (backup)
    local spaceInput = {
        KeyCode = Enum.KeyCode.Space,
        UserInputType = Enum.UserInputType.Keyboard
    }
    UserInputService.InputBegan:Fire(spaceInput, false)
    
    if AutoParry.DebugMode then
        print("🛡️ Auto Parry: Attempted parry!")
    end
end

-- Main parry loop
local function parryLoop()
    if not AutoParry.Enabled or not LocalPlayer.Character then return end
    
    local balls = findBalls()
    
    for _, ball in pairs(balls) do
        if isBallDangerous(ball) then
            performParry()
            if AutoParry.DebugMode then
                print("🎾 Ball detected at distance:", (ball.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            end
            break -- Only parry once per frame
        end
    end
end

-- Toggle auto parry
local function toggleAutoParry()
    AutoParry.Enabled = not AutoParry.Enabled
    updateGUI()
    
    if AutoParry.Enabled then
        print("🛡️ Auto Parry: Enabled")
    else
        print("🛡️ Auto Parry: Disabled")
    end
end

-- Key input handler
local function onKeyPress(key, processed)
    if processed then return end
    
    if key.KeyCode == AutoParry.ParryKey then
        toggleAutoParry()
    end
end

-- Initialize
local function initialize()
    print("🛡️ Initializing Blade Ball Auto Parry...")
    
    -- Find parry remote
    ParryRemote = findParryRemote()
    if ParryRemote then
        print("🛡️ Found parry remote:", ParryRemote.Name, "in", ParryRemote.Parent.Name)
    else
        print("🛡️ No parry remote found, using key simulation")
    end
    
    -- Create GUI
    createGUI()
    updateGUI()
    
    -- Set up input detection
    Connections.KeyPress = UserInputService.InputBegan:Connect(onKeyPress)
    
    -- Set up main parry loop
    Connections.ParryLoop = RunService.Heartbeat:Connect(parryLoop)
    
    print("🛡️ Auto Parry initialized successfully!")
    print("🛡️ Press F to toggle auto parry")
    print("🛡️ Parry distance:", AutoParry.ParryDistance)
end

-- Cleanup function
local function cleanup()
    for _, connection in pairs(Connections) do
        if connection then connection:Disconnect() end
    end
    
    if ScreenGui then
        ScreenGui:Destroy()
    end
    
    Connections = {}
    print("🛡️ Auto Parry cleaned up")
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

print("🛡️ Blade Ball Auto Parry loaded successfully!")
