local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("ScreenGui")
main.Name = "WalkSpeed Gui"
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
TitleLabel.Text = "WalkSpeed GUI - Glitched Da Kitty Cat"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextWrapped = true
TitleLabel.Name = "TitleLabel"

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 30, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 1, -35)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Name = "CloseButton"

local SpeedToggleButton = Instance.new("TextButton")
SpeedToggleButton.Parent = Frame
SpeedToggleButton.Size = UDim2.new(0, 80, 0, 30)
SpeedToggleButton.Position = UDim2.new(0, 10, 0, 35)
SpeedToggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
SpeedToggleButton.Font = Enum.Font.GothamBold
SpeedToggleButton.Text = "Speed: OFF"
SpeedToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggleButton.TextScaled = true
SpeedToggleButton.Name = "SpeedToggleButton"

local NoClipButton = Instance.new("TextButton")
NoClipButton.Parent = Frame
NoClipButton.Size = UDim2.new(0, 80, 0, 30)
NoClipButton.Position = UDim2.new(0, 100, 0, 35)
NoClipButton.BackgroundColor3 = Color3.fromRGB(120, 0, 120)
NoClipButton.Font = Enum.Font.GothamBold
NoClipButton.Text = "NoClip: OFF"
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.TextScaled = true
NoClipButton.Name = "NoClipButton"

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = Frame
MinimizeButton.Size = UDim2.new(0, 30, 0, 25)
MinimizeButton.Position = UDim2.new(1, -70, 1, -35)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextScaled = true
MinimizeButton.Name = "MinimizeButton"

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
SpeedValue.Text = "16"
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

local speedEnabled = false
local walkSpeed = 16
local noclip = false

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

RunService.Stepped:Connect(function()
    if noclip then
        if player.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
            player.Character.Head.CanCollide = false
            player.Character.Torso.CanCollide = false
            player.Character["Left Leg"].CanCollide = false
            player.Character["Right Leg"].CanCollide = false
        else
            player.Character.Humanoid:ChangeState(11)
        end
    end
end)

SpeedToggleButton.MouseButton1Click:Connect(function()
    if speedEnabled then
        speedEnabled = false
        humanoid.WalkSpeed = 16
        SpeedToggleButton.Text = "Speed: OFF"
    else
        speedEnabled = true
        humanoid.WalkSpeed = walkSpeed
        SpeedToggleButton.Text = "Speed: ON"
    end
end)

NoClipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        NoClipButton.Text = "NoClip: ON"
    else
        NoClipButton.Text = "NoClip: OFF"
    end
end)

SpeedUpButton.MouseButton1Click:Connect(function()
    walkSpeed = walkSpeed + 1
    SpeedValue.Text = tostring(walkSpeed)
    if speedEnabled then
        humanoid.WalkSpeed = walkSpeed
    end
end)

SpeedDownButton.MouseButton1Click:Connect(function()
    if walkSpeed > 1 then
        walkSpeed = walkSpeed - 1
        SpeedValue.Text = tostring(walkSpeed)
        if speedEnabled then
            humanoid.WalkSpeed = walkSpeed
        end
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    main:Destroy()
end)
