
-- Enhanced Click Teleport System
-- Right-click to teleport to cursor position

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ClickTeleport = {}
ClickTeleport.Enabled = false

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local IndicatorFrame = Instance.new("Frame")
local IndicatorLabel = Instance.new("TextLabel")

ScreenGui.Name = "ClickTeleportGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Indicator UI
IndicatorFrame.Name = "IndicatorFrame"
IndicatorFrame.Parent = ScreenGui
IndicatorFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
IndicatorFrame.BorderSizePixel = 0
IndicatorFrame.Position = UDim2.new(0, 10, 0, 10)
IndicatorFrame.Size = UDim2.new(0, 200, 0, 50)
IndicatorFrame.Visible = false

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(0, 8)
IndicatorCorner.Parent = IndicatorFrame

IndicatorLabel.Name = "IndicatorLabel"
IndicatorLabel.Parent = IndicatorFrame
IndicatorLabel.BackgroundTransparency = 1
IndicatorLabel.Size = UDim2.new(1, 0, 1, 0)
IndicatorLabel.Font = Enum.Font.GothamBold
IndicatorLabel.Text = "Click Teleport: OFF"
IndicatorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
IndicatorLabel.TextSize = 14

-- Teleport crosshair
local CrosshairGui = Instance.new("ScreenGui")
local Crosshair = Instance.new("Frame")
local HorizontalLine = Instance.new("Frame")
local VerticalLine = Instance.new("Frame")

CrosshairGui.Name = "CrosshairGui"
CrosshairGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
CrosshairGui.ResetOnSpawn = false
CrosshairGui.IgnoreGuiInset = true

Crosshair.Name = "Crosshair"
Crosshair.Parent = CrosshairGui
Crosshair.BackgroundTransparency = 1
Crosshair.Size = UDim2.new(0, 20, 0, 20)
Crosshair.Visible = false

HorizontalLine.Name = "HorizontalLine"
HorizontalLine.Parent = Crosshair
HorizontalLine.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
HorizontalLine.BorderSizePixel = 0
HorizontalLine.Position = UDim2.new(0, 0, 0.5, -1)
HorizontalLine.Size = UDim2.new(1, 0, 0, 2)

VerticalLine.Name = "VerticalLine"
VerticalLine.Parent = Crosshair
VerticalLine.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
VerticalLine.BorderSizePixel = 0
VerticalLine.Position = UDim2.new(0.5, -1, 0, 0)
VerticalLine.Size = UDim2.new(0, 2, 1, 0)

-- Functions
local function updateCrosshair()
    if ClickTeleport.Enabled then
        local mouse = LocalPlayer:GetMouse()
        Crosshair.Position = UDim2.new(0, mouse.X - 10, 0, mouse.Y - 10)
    end
end

local function teleportToPosition(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
        
        -- Visual effect
        local effect = Instance.new("Explosion")
        effect.Parent = workspace
        effect.Position = position
        effect.BlastPressure = 0
        effect.BlastRadius = 10
        effect.Visible = true
        
        print("Teleported to:", position)
    end
end

local function onRightClick()
    if not ClickTeleport.Enabled then return end
    
    local mouse = LocalPlayer:GetMouse()
    local unitRay = Camera:ScreenPointToRay(mouse.X, mouse.Y)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
    
    if raycastResult then
        teleportToPosition(raycastResult.Position)
    else
        -- Fallback to fixed distance if no hit
        local targetPosition = unitRay.Origin + unitRay.Direction * 100
        teleportToPosition(targetPosition)
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        onRightClick()
    elseif input.KeyCode == Enum.KeyCode.T then
        ClickTeleport:Toggle()
    end
end)

-- Update crosshair position
game:GetService("RunService").Heartbeat:Connect(updateCrosshair)

-- ClickTeleport methods
function ClickTeleport:Toggle()
    self.Enabled = not self.Enabled
    
    IndicatorFrame.Visible = self.Enabled
    Crosshair.Visible = self.Enabled
    
    if self.Enabled then
        IndicatorLabel.Text = "Click Teleport: ON"
        IndicatorLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        print("Click Teleport enabled! Right-click to teleport, T to toggle.")
    else
        IndicatorLabel.Text = "Click Teleport: OFF"
        IndicatorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        print("Click Teleport disabled!")
    end
end

function ClickTeleport:Enable()
    if not self.Enabled then
        self:Toggle()
    end
end

function ClickTeleport:Disable()
    if self.Enabled then
        self:Toggle()
    end
end

-- Auto-enable
ClickTeleport:Enable()

return ClickTeleport
