
-- Modern Size Changer GUI using CFrame manipulation
-- More reliable method that works around Roblox restrictions

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Global variables
local currentScale = 1
local originalSizes = {}
local originalCFrames = {}
local isScaling = false

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
TitleLabel.Text = "Advanced Size Changer"
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
StatusLabel.Text = "Ready - New CFrame method loaded"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12

-- Store original data function
local function storeOriginalData(character)
    if not character then return end
    
    originalSizes = {}
    originalCFrames = {}
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            originalSizes[part] = part.Size
            originalCFrames[part] = part.CFrame
            
            -- Store mesh data
            for _, mesh in pairs(part:GetChildren()) do
                if mesh:IsA("SpecialMesh") then
                    originalSizes[mesh] = mesh.Scale
                end
            end
        elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
            local handle = part.Handle
            originalSizes[handle] = handle.Size
            originalCFrames[handle] = handle.CFrame
            
            for _, mesh in pairs(handle:GetChildren()) do
                if mesh:IsA("SpecialMesh") then
                    originalSizes[mesh] = mesh.Scale
                end
            end
        end
    end
end

-- New CFrame-based scaling method
local function changeCharacterSizeAdvanced(scale)
    local character = LocalPlayer.Character
    if not character then
        StatusLabel.Text = "Error: No character found!"
        StatusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return false
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then
        StatusLabel.Text = "Error: Character not ready!"
        StatusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return false
    end
    
    -- Store original data if first time
    if next(originalSizes) == nil then
        storeOriginalData(character)
    end
    
    currentScale = scale
    isScaling = true
    
    pcall(function()
        -- Method 1: Try R15 first
        if humanoid.RigType == Enum.HumanoidRigType.R15 then
            if humanoid:FindFirstChild("DepthScale") then
                humanoid.DepthScale.Value = scale
            end
            if humanoid:FindFirstChild("HeightScale") then
                humanoid.HeightScale.Value = scale
            end
            if humanoid:FindFirstChild("WidthScale") then
                humanoid.WidthScale.Value = scale
            end
        end
        
        -- Method 2: Manual scaling with CFrame preservation
        local rootPosition = rootPart.CFrame
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and originalSizes[part] then
                -- Calculate new size
                local newSize = originalSizes[part] * scale
                part.Size = newSize
                
                -- Preserve relative position using CFrame
                if part ~= rootPart and originalCFrames[part] then
                    local relativePos = rootPart.CFrame:ToObjectSpace(originalCFrames[part])
                    part.CFrame = rootPart.CFrame:ToWorldSpace(relativePos)
                end
                
                -- Scale meshes
                for _, mesh in pairs(part:GetChildren()) do
                    if mesh:IsA("SpecialMesh") and originalSizes[mesh] then
                        mesh.Scale = originalSizes[mesh] * scale
                    end
                end
            end
        end
        
        -- Scale accessories
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                local handle = accessory:FindFirstChild("Handle")
                if handle and originalSizes[handle] then
                    handle.Size = originalSizes[handle] * scale
                    
                    -- Scale accessory meshes
                    for _, mesh in pairs(handle:GetChildren()) do
                        if mesh:IsA("SpecialMesh") and originalSizes[mesh] then
                            mesh.Scale = originalSizes[mesh] * scale
                        end
                    end
                end
            end
        end
        
        -- Force position update
        rootPart.CFrame = rootPosition
    end)
    
    StatusLabel.Text = "Size changed to " .. tostring(scale) .. "x (CFrame method)!"
    StatusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
    
    return true
end

-- Continuous update function to maintain size
local connection
local function startSizeMonitor()
    if connection then connection:Disconnect() end
    
    connection = RunService.Heartbeat:Connect(function()
        if isScaling and LocalPlayer.Character and currentScale ~= 1 then
            local character = LocalPlayer.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
                -- Continuously apply R15 scaling
                pcall(function()
                    if humanoid:FindFirstChild("DepthScale") and humanoid.DepthScale.Value ~= currentScale then
                        humanoid.DepthScale.Value = currentScale
                    end
                    if humanoid:FindFirstChild("HeightScale") and humanoid.HeightScale.Value ~= currentScale then
                        humanoid.HeightScale.Value = currentScale
                    end
                    if humanoid:FindFirstChild("WidthScale") and humanoid.WidthScale.Value ~= currentScale then
                        humanoid.WidthScale.Value = currentScale
                    end
                end)
            end
        end
    end)
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
    
    changeCharacterSizeAdvanced(size)
end)

CloseButton.MouseButton1Click:Connect(function()
    if connection then connection:Disconnect() end
    ScreenGui:Destroy()
end)

-- Auto-reset on character spawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(2) -- Wait for character to fully load
    originalSizes = {}
    originalCFrames = {}
    currentScale = 1
    isScaling = false
    StatusLabel.Text = "Character respawned - Ready!"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- Start the size monitor
startSizeMonitor()

print("Advanced Size Changer GUI loaded with CFrame method!")
print("This uses a different approach that should be more reliable.")
