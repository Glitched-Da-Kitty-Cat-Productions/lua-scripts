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
Frame.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
Frame.BorderColor3 = Color3.fromRGB(100, 0, 150)
Frame.Position = UDim2.new(0.1, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 320, 0, 160)
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true
Frame.Name = "MainFrame"

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(180, 0, 255)
UIStroke.Thickness = 2
UIStroke.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 40))
}
UIGradient.Rotation = 45
UIGradient.Parent = Frame

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

local CONTROL = {F = 0, B = 0, L = 0, R = 0}
local lCONTROL = {F = 0, B = 0, L = 0, R = 0}
local SPEED = 0

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local bodyGyro
local bodyVelocity

local function fly()
    flying = true
    bodyGyro = Instance.new('BodyGyro', rootPart)
    bodyVelocity = Instance.new('BodyVelocity', rootPart)
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = rootPart.CFrame
    bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    spawn(function()
        repeat wait()
            humanoid.PlatformStand = true
            if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 then
                SPEED = 50
            elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0) and SPEED ~= 0 then
                SPEED = 0
            end
            if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 then
                bodyVelocity.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
            elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and SPEED ~= 0 then
                bodyVelocity.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
            else
                bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
            end
            bodyGyro.cframe = workspace.CurrentCamera.CoordinateFrame
        until not flying
        CONTROL = {F = 0, B = 0, L = 0, R = 0}
        lCONTROL = {F = 0, B = 0, L = 0, R = 0}
        SPEED = 0
        bodyGyro:Destroy()
        bodyVelocity:Destroy()
        humanoid.PlatformStand = false
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode
        if key == Enum.KeyCode.W then
            CONTROL.F = flySpeed
        elseif key == Enum.KeyCode.S then
            CONTROL.B = -flySpeed
        elseif key == Enum.KeyCode.A then
            CONTROL.L = -flySpeed
        elseif key == Enum.KeyCode.D then
            CONTROL.R = flySpeed
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode
        if key == Enum.KeyCode.W then
            CONTROL.F = 0
        elseif key == Enum.KeyCode.S then
            CONTROL.B = 0
        elseif key == Enum.KeyCode.A then
            CONTROL.L = 0
        elseif key == Enum.KeyCode.D then
            CONTROL.R = 0
        end
    end
end)

local function stopFly()
    flying = false
end

FlyToggleButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        FlyToggleButton.Text = "Fly: OFF"
    else
        fly()
        FlyToggleButton.Text = "Fly: ON"
    end
end)

SpeedUpButton.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 1
    SpeedValue.Text = tostring(flySpeed)
end)

SpeedDownButton.MouseButton1Click:Connect(function()
    if flySpeed > 1 then
        flySpeed = flySpeed - 1
        SpeedValue.Text = tostring(flySpeed)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

updateSpeedDisplay()
