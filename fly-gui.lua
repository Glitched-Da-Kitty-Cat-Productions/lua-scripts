local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("ScreenGui")
main.Name = "Fly Gui"
main.Parent = PlayerGui
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderColor3 = Color3.fromRGB(100, 100, 100)
Frame.Position = UDim2.new(0.1, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 220, 0, 80)
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true
Frame.Name = "MainFrame"

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Frame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Fly GUI - Glitched Da Kitty Cat"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextWrapped = true
TitleLabel.Name = "TitleLabel"

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 30, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Name = "CloseButton"

local FlyToggleButton = Instance.new("TextButton")
FlyToggleButton.Parent = Frame
FlyToggleButton.Size = UDim2.new(0, 80, 0, 30)
FlyToggleButton.Position = UDim2.new(0, 10, 0, 35)
FlyToggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
FlyToggleButton.Font = Enum.Font.GothamBold
FlyToggleButton.Text = "Fly: OFF"
FlyToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggleButton.TextScaled = true
FlyToggleButton.Name = "FlyToggleButton"

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = Frame
SpeedLabel.Size = UDim2.new(0, 50, 0, 30)
SpeedLabel.Position = UDim2.new(0, 100, 0, 35)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "Speed:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextScaled = true
SpeedLabel.Name = "SpeedLabel"

local SpeedValue = Instance.new("TextLabel")
SpeedValue.Parent = Frame
SpeedValue.Size = UDim2.new(0, 30, 0, 30)
SpeedValue.Position = UDim2.new(0, 150, 0, 35)
SpeedValue.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedValue.Font = Enum.Font.GothamBold
SpeedValue.Text = "1"
SpeedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValue.TextScaled = true
SpeedValue.Name = "SpeedValue"

local SpeedUpButton = Instance.new("TextButton")
SpeedUpButton.Parent = Frame
SpeedUpButton.Size = UDim2.new(0, 25, 0, 25)
SpeedUpButton.Position = UDim2.new(0, 185, 0, 35)
SpeedUpButton.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
SpeedUpButton.Font = Enum.Font.GothamBold
SpeedUpButton.Text = "+"
SpeedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUpButton.TextScaled = true
SpeedUpButton.Name = "SpeedUpButton"

local SpeedDownButton = Instance.new("TextButton")
SpeedDownButton.Parent = Frame
SpeedDownButton.Size = UDim2.new(0, 25, 0, 25)
SpeedDownButton.Position = UDim2.new(0, 185, 0, 60)
SpeedDownButton.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
SpeedDownButton.Font = Enum.Font.GothamBold
SpeedDownButton.Text = "-"
SpeedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDownButton.TextScaled = true
SpeedDownButton.Name = "SpeedDownButton"

local flying = false
local flySpeed = 1

local function updateSpeedDisplay()
    SpeedValue.Text = tostring(flySpeed)
end

local RunService = game:GetService("RunService")
local player = LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local bodyGyro
local bodyVelocity

local function startFly()
    if flying then return end
    flying = true

    bodyGyro = Instance.new("BodyGyro", rootPart)
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = rootPart.CFrame

    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

    humanoid.PlatformStand = true

    local connection
    connection = RunService.Heartbeat:Connect(function()
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            bodyVelocity.velocity = moveDirection * flySpeed * 50
            bodyGyro.cframe = workspace.CurrentCamera.CFrame
        else
            bodyVelocity.velocity = Vector3.new(0, 0, 0)
        end
    end)

    FlyToggleButton:GetPropertyChangedSignal("Text"):Connect(function()
        if not flying then
            connection:Disconnect()
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
            humanoid.PlatformStand = false
        end
    end)
end

local function stopFly()
    if not flying then return end
    flying = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    humanoid.PlatformStand = false
end

FlyToggleButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        FlyToggleButton.Text = "Fly: OFF"
    else
        startFly()
        FlyToggleButton.Text = "Fly: ON"
    end
end)

SpeedUpButton.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 1
    updateSpeedDisplay()
end)

SpeedDownButton.MouseButton1Click:Connect(function()
    if flySpeed > 1 then
        flySpeed = flySpeed - 1
        updateSpeedDisplay()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

updateSpeedDisplay()
