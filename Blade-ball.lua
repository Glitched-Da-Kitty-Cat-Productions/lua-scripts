
-- Blade Ball Auto Parry Script (Enhanced Version)
-- Automatically detects and parries incoming balls with visualizer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Configuration
local AutoParry = {
    Enabled = true,
    ParryThreshold = 0.55, -- Time threshold for parrying (distance/speed)
    ParryKey = Enum.KeyCode.F,
    DebugMode = true,
    NotificationEnabled = true
}

-- Variables
local Connections = {}
local Cooldown = tick()
local IsParried = false
local Connection = nil

-- GUI Elements
local ScreenGui = nil
local StatusLabel = nil

-- Send notification
local function sendNotification(title, text, duration)
    if not AutoParry.NotificationEnabled then return end
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Icon = "rbxassetid://135351041318579",
            Duration = duration or 5,
            Button1 = "OK"
        })
    end)
end

-- Create enhanced GUI
local function createGUI()
    if ScreenGui then return end
    
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AutoParryGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = ScreenGui
    StatusLabel.Size = UDim2.new(0, 280, 0, 80)
    StatusLabel.Position = UDim2.new(0, 10, 0, 10)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    StatusLabel.BackgroundTransparency = 0.1
    StatusLabel.BorderSizePixel = 0
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 16
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = "🛡️ Auto Parry: ON\n🎯 Status: Waiting\n⌨️ Press F to toggle"
    StatusLabel.TextWrapped = true
    StatusLabel.TextYAlignment = Enum.TextYAlignment.Center
    
    local corner = Instance.new("UICorner")
    corner.Parent = StatusLabel
    corner.CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = StatusLabel
    stroke.Color = Color3.fromRGB(0, 255, 127)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
end

-- Update GUI status
local function updateGUI(status)
    if StatusLabel then
        local statusText = status or "Waiting"
        StatusLabel.Text = "🛡️ Auto Parry: " .. (AutoParry.Enabled and "ON" or "OFF") .. 
                          "\n🎯 Status: " .. statusText .. 
                          "\n⌨️ Press F to toggle"
        
        local stroke = StatusLabel:FindFirstChild("UIStroke")
        if stroke then
            stroke.Color = AutoParry.Enabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 100, 100)
        end
    end
end

-- Get the real ball from workspace
local function GetBall()
    if not Workspace:FindFirstChild("Balls") then return nil end
    
    for _, Ball in ipairs(Workspace.Balls:GetChildren()) do
        if Ball:GetAttribute("realBall") then
            return Ball
        end
    end
    return nil
end

-- Reset ball connection
local function ResetConnection()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
end

-- Perform parry action
local function performParry()
    if not AutoParry.Enabled then return end
    
    -- Use VirtualInputManager for more reliable input
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    
    IsParried = true
    Cooldown = tick()
    
    updateGUI("🎯 PARRIED!")
    
    if AutoParry.DebugMode then
        print("🛡️ Auto Parry: Ball parried successfully!")
    end
    
    -- Reset parry status after cooldown
    task.spawn(function()
        task.wait(1)
        if (tick() - Cooldown) >= 1 then
            IsParried = false
            updateGUI("Waiting")
        end
    end)
end

-- Main parry detection loop
local function parryLoop()
    if not AutoParry.Enabled then return end
    
    local Ball = GetBall()
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not Ball or not HRP then
        return
    end
    
    -- Check if ball has zoomies (velocity component)
    local zoomies = Ball:FindFirstChild("zoomies")
    if not zoomies or not zoomies:FindFirstChild("VectorVelocity") then
        return
    end
    
    local Speed = zoomies.VectorVelocity.Magnitude
    local Distance = (HRP.Position - Ball.Position).Magnitude
    
    -- Check if ball is targeting the player and conditions are met
    if Ball:GetAttribute("target") == LocalPlayer.Name and 
       not IsParried and 
       Speed > 0 and
       Distance / Speed <= AutoParry.ParryThreshold then
        
        performParry()
        updateGUI("🎯 Ball Incoming!")
    end
end

-- Handle new balls being added
local function onBallAdded()
    local Ball = GetBall()
    if not Ball then return end
    
    ResetConnection()
    Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
        IsParried = false
        updateGUI("New Target")
    end)
end

-- Toggle auto parry
local function toggleAutoParry()
    AutoParry.Enabled = not AutoParry.Enabled
    updateGUI()
    
    local status = AutoParry.Enabled and "Enabled" or "Disabled"
    sendNotification("Auto Parry", "Auto Parry " .. status, 3)
    
    if AutoParry.DebugMode then
        print("🛡️ Auto Parry:", status)
    end
end

-- Key input handler
local function onKeyPress(key, processed)
    if processed then return end
    
    if key.KeyCode == AutoParry.ParryKey then
        toggleAutoParry()
    end
end

-- Initialize the script
local function initialize()
    print("🛡️ Initializing Enhanced Blade Ball Auto Parry...")
    
    -- Send startup notification
    sendNotification(
        "Glitched Nordic Void",
        "Auto Parry Executed (Enhanced with visualizer)",
        7
    )
    
    -- Create GUI
    createGUI()
    updateGUI()
    
    -- Set up ball detection
    if Workspace:FindFirstChild("Balls") then
        Connections.BallAdded = Workspace.Balls.ChildAdded:Connect(onBallAdded)
        onBallAdded() -- Check for existing balls
    end
    
    -- Set up input detection
    Connections.KeyPress = UserInputService.InputBegan:Connect(onKeyPress)
    
    -- Set up main parry loop
    Connections.ParryLoop = RunService.PreSimulation:Connect(parryLoop)
    
    print("🛡️ Enhanced Auto Parry initialized successfully!")
    print("🛡️ Press F to toggle | Parry threshold:", AutoParry.ParryThreshold)
end

-- Cleanup function
local function cleanup()
    for _, connection in pairs(Connections) do
        if connection then connection:Disconnect() end
    end
    
    ResetConnection()
    
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

print("🛡️ Enhanced Blade Ball Auto Parry loaded successfully!")
