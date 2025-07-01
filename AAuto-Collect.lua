
-- Auto Collector Script
-- Automatically teleports to and collects all grabbable items, rewards, and tools

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local AutoCollector = {}
AutoCollector.Enabled = false
AutoCollector.CollectionRange = 50 -- Maximum distance to search for items
AutoCollector.TeleportSpeed = 0.5 -- Speed of teleportation (seconds)
AutoCollector.CollectedItems = {}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "AutoCollectorGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0, 80)
MainFrame.Size = UDim2.new(0, 250, 0, 120)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Auto Collector"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

-- Toggle Button
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 10, 0, 35)
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Start Collecting"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-- Status Label
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 80)
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Function to check if an item is collectible
function AutoCollector:IsCollectible(item)
    if not item or not item.Parent then return false end
    
    -- Check for proximity prompt
    local proximityPrompt = item:FindFirstChildOfClass("ProximityPrompt")
    if proximityPrompt and proximityPrompt.Enabled then
        return true
    end
    
    -- Check for tools
    if item:IsA("Tool") then
        return true
    end
    
    -- Check for common collectible names
    local collectibleNames = {
        "coin", "money", "cash", "gem", "crystal", "reward", "prize", "loot",
        "item", "pickup", "collect", "grab", "take", "currency", "token",
        "treasure", "chest", "box", "crate", "orb", "sphere", "diamond",
        "gold", "silver", "bronze", "star", "point", "score", "bonus"
    }
    
    for _, name in pairs(collectibleNames) do
        if item.Name:lower():find(name) then
            return true
        end
    end
    
    -- Check for specific attributes that indicate collectibles
    if item:GetAttribute("Collectible") or item:GetAttribute("Reward") or 
       item:GetAttribute("Prize") or item:GetAttribute("Money") or
       item:GetAttribute("Currency") or item:GetAttribute("Value") then
        return true
    end
    
    return false
end

-- Function to find all collectible items
function AutoCollector:FindCollectibles()
    local collectibles = {}
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return collectibles
    end
    
    local playerPosition = character.HumanoidRootPart.Position
    
    -- Search in workspace
    for _, descendant in pairs(workspace:GetDescendants()) do
        if self:IsCollectible(descendant) and descendant:FindFirstChild("Position") or 
           (descendant:IsA("BasePart") and self:IsCollectible(descendant)) then
            
            local itemPosition
            if descendant:IsA("BasePart") then
                itemPosition = descendant.Position
            elseif descendant:FindFirstChild("Position") then
                itemPosition = descendant.Position.Value
            else
                continue
            end
            
            -- Check if within collection range
            local distance = (playerPosition - itemPosition).Magnitude
            if distance <= self.CollectionRange and not self.CollectedItems[descendant] then
                table.insert(collectibles, {
                    item = descendant,
                    position = itemPosition,
                    distance = distance
                })
            end
        end
    end
    
    -- Sort by distance (closest first)
    table.sort(collectibles, function(a, b)
        return a.distance < b.distance
    end)
    
    return collectibles
end

-- Function to teleport to an item
function AutoCollector:TeleportToItem(targetPosition)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local currentPosition = humanoidRootPart.Position
    
    -- Create teleport tween for smooth movement
    local tweenInfo = TweenInfo.new(
        self.TeleportSpeed,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    
    local targetCFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    tween.Completed:Wait()
    
    return true
end

-- Function to collect an item
function AutoCollector:CollectItem(item)
    if not item or not item.Parent then return false end
    
    local success = false
    
    -- Try proximity prompt first
    local proximityPrompt = item:FindFirstChildOfClass("ProximityPrompt")
    if proximityPrompt and proximityPrompt.Enabled then
        pcall(function()
            fireproximityprompt(proximityPrompt)
            success = true
        end)
    end
    
    -- Try tool pickup
    if item:IsA("Tool") then
        pcall(function()
            item.Parent = LocalPlayer.Backpack
            success = true
        end)
    end
    
    -- Try click detector
    local clickDetector = item:FindFirstChildOfClass("ClickDetector")
    if clickDetector then
        pcall(function()
            fireclickdetector(clickDetector)
            success = true
        end)
    end
    
    if success then
        self.CollectedItems[item] = true
        print("Collected:", item.Name)
    end
    
    return success
end

-- Main collection loop
function AutoCollector:CollectionLoop()
    while self.Enabled do
        local collectibles = self:FindCollectibles()
        
        if #collectibles > 0 then
            local targetItem = collectibles[1]
            StatusLabel.Text = "Status: Collecting " .. targetItem.item.Name
            
            -- Teleport to item
            if self:TeleportToItem(targetItem.position) then
                wait(0.1) -- Small delay to ensure teleport completes
                
                -- Attempt to collect
                self:CollectItem(targetItem.item)
                wait(0.2) -- Delay between collections
            end
        else
            StatusLabel.Text = "Status: No items found nearby"
            wait(1) -- Wait longer when no items found
        end
        
        wait(0.1) -- Small delay between searches
    end
end

-- Toggle function
function AutoCollector:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        ToggleButton.Text = "Stop Collecting"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        StatusLabel.Text = "Status: Searching for items..."
        
        -- Start collection in a new thread
        spawn(function()
            self:CollectionLoop()
        end)
        
        print("Auto Collector enabled!")
    else
        ToggleButton.Text = "Start Collecting"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.Text = "Status: Stopped"
        print("Auto Collector disabled!")
    end
end

-- Connect button
ToggleButton.MouseButton1Click:Connect(function()
    AutoCollector:Toggle()
end)

-- Keyboard shortcut (F key)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        AutoCollector:Toggle()
    end
end)

print("Auto Collector loaded! Click the button or press F to toggle.")
print("The script will automatically find and collect nearby items, rewards, and tools.")

return AutoCollector
