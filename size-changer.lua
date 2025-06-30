
-- Advanced Size Changer GUI for Roblox
-- Works with both R6 and R15 characters

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local SizeSlider = Instance.new("TextBox")
local PresetFrame = Instance.new("Frame")
local TinyButton = Instance.new("TextButton")
local SmallButton = Instance.new("TextButton")
local NormalButton = Instance.new("TextButton")
local BigButton = Instance.new("TextButton")
local GiantButton = Instance.new("TextButton")
local ApplyButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- GUI Properties
ScreenGui.Name = "SizeChangerGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = MainFrame

-- Title
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Size Changer"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

-- Size Input
SizeSlider.Name = "SizeSlider"
SizeSlider.Parent = MainFrame
SizeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SizeSlider.BorderSizePixel = 0
SizeSlider.Position = UDim2.new(0.1, 0, 0.2, 0)
SizeSlider.Size = UDim2.new(0.8, 0, 0, 30)
SizeSlider.Font = Enum.Font.SourceSans
SizeSlider.PlaceholderText = "Enter size (0.1 - 50)"
SizeSlider.Text = "1"
SizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeSlider.TextSize = 14

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 4)
sliderCorner.Parent = SizeSlider

-- Preset Frame
PresetFrame.Name = "PresetFrame"
PresetFrame.Parent = MainFrame
PresetFrame.BackgroundTransparency = 1
PresetFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
PresetFrame.Size = UDim2.new(0.9, 0, 0, 30)

-- Preset Buttons
local presetButtons = {
    {TinyButton, "Tiny", 0.1},
    {SmallButton, "Small", 0.5},
    {NormalButton, "Normal", 1},
    {BigButton, "Big", 3},
    {GiantButton, "Giant", 10}
}

for i, buttonData in ipairs(presetButtons) do
    local button, text, size = buttonData[1], buttonData[2], buttonData[3]
    button.Name = text .. "Button"
    button.Parent = PresetFrame
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    button.BorderSizePixel = 0
    button.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
    button.Size = UDim2.new(0.18, 0, 1, 0)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        SizeSlider.Text = tostring(size)
    end)
end

-- Apply Button
ApplyButton.Name = "ApplyButton"
ApplyButton.Parent = MainFrame
ApplyButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
ApplyButton.BorderSizePixel = 0
ApplyButton.Position = UDim2.new(0.1, 0, 0.65, 0)
ApplyButton.Size = UDim2.new(0.35, 0, 0, 35)
ApplyButton.Font = Enum.Font.SourceSansBold
ApplyButton.Text = "Apply Size"
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.TextSize = 14

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 4)
applyCorner.Parent = ApplyButton

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.55, 0, 0.65, 0)
CloseButton.Size = UDim2.new(0.35, 0, 0, 35)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = CloseButton

-- Status Label
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0.85, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Ready to change size"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12

-- Size Change Function
local function changeCharacterSize(scale)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
        StatusLabel.Text = "Error: Character not found!"
        StatusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return false
    end
    
    local humanoid = LocalPlayer.Character.Humanoid
    
    -- Apply size change based on rig type
    if humanoid.RigType == Enum.HumanoidRigType.R15 then
        -- R15 Character
        LocalPlayer.Character.Humanoid.DepthScale.Value = scale
        LocalPlayer.Character.Humanoid.HeightScale.Value = scale
        LocalPlayer.Character.Humanoid.WidthScale.Value = scale
    else
        -- R6 Character
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Size = part.Size * scale
                
                -- Scale mesh if it exists
                if part:FindFirstChildOfClass("SpecialMesh") then
                    part:FindFirstChildOfClass("SpecialMesh").Scale = part:FindFirstChildOfClass("SpecialMesh").Scale * scale
                end
            end
        end
        
        -- Scale accessories
        for _, accessory in pairs(LocalPlayer.Character:GetChildren()) do
            if accessory:IsA("Accessory") and accessory:FindFirstChild("Handle") then
                accessory.Handle.Size = accessory.Handle.Size * scale
                if accessory.Handle:FindFirstChild("Mesh") then
                    accessory.Handle.Mesh.Scale = accessory.Handle.Mesh.Scale * scale
                end
            end
        end
    end
    
    StatusLabel.Text = "Size changed to " .. tostring(scale) .. "x!"
    StatusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
    return true
end

-- Button Events
ApplyButton.MouseButton1Click:Connect(function()
    local sizeText = SizeSlider.Text
    local size = tonumber(sizeText)
    
    if not size then
        StatusLabel.Text = "Error: Invalid number!"
        StatusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return
    end
    
    if size <= 0 or size > 50 then
        StatusLabel.Text = "Error: Size must be between 0.1 and 50!"
        StatusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return
    end
    
    changeCharacterSize(size)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Keyboard shortcut (Ctrl + K to toggle GUI)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.K and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if ScreenGui.Parent then
            ScreenGui:Destroy()
        end
    end
end)

-- Auto-reset on character spawn
LocalPlayer.CharacterAdded:Connect(function()
    StatusLabel.Text = "Character respawned - Ready!"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

print("Size Changer GUI loaded! Use Ctrl+K to close.")
