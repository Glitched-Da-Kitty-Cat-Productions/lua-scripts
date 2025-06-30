
-- Elemental Powers Tycoon Auto Chest Collector
-- Monitors workspace.Treasure.Chests.Chest and cycles through indices 1-5

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local plr = Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local chestQueue = {}
local isCollecting = false
local monitoring = true
local checkedIndices = {}

-- Function to teleport player
local function teleportTo(position)
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(position)
        print("Teleported to:", position)
    end
end

-- Function to simulate holding E key
local function holdEKey(duration)
    print("Holding E key for", duration, "seconds")
    
    -- Method 1: VirtualInputManager
    local success = pcall(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
        wait(duration)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
    
    -- Method 2: Fire proximity prompts directly
    if not success then
        local function findAndFirePrompts()
            for i = 1, duration * 10 do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local distance = (obj.Parent.Position - humanoidRootPart.Position).Magnitude
                        if distance <= obj.MaxActivationDistance then
                            pcall(function()
                                fireproximityprompt(obj)
                                print("Fired proximity prompt on:", obj.Parent.Name)
                            end)
                        end
                    end
                end
                wait(0.1)
            end
        end
        spawn(findAndFirePrompts)
    end
end

-- Function to get chest position
local function getChestPosition(chest)
    local position = nil
    
    if chest.PrimaryPart then
        position = chest.PrimaryPart.Position
    elseif chest:FindFirstChild("Part") then
        position = chest.Part.Position
    else
        local part = chest:FindFirstChildOfClass("BasePart")
        if part then
            position = part.Position
        end
    end
    
    return position
end

-- Function to collect a chest
local function collectChest(chest, index)
    if not chest or not chest.Parent then
        print("Chest is nil or has no parent")
        return
    end
    
    isCollecting = true
    print("Collecting chest at index:", index)
    
    -- Get chest position
    local chestPosition = getChestPosition(chest)
    if not chestPosition then
        print("Could not find chest position for index:", index)
        isCollecting = false
        return
    end
    
    -- Teleport to chest position
    local teleportPosition = chestPosition + Vector3.new(0, 2, 0)
    teleportTo(teleportPosition)
    
    wait(0.5) -- Short wait after teleporting
    
    -- Hold E for 5 seconds to collect
    holdEKey(5)
    
    print("Finished collecting chest at index:", index)
    checkedIndices[index] = true
    wait(0.5) -- Short wait before next chest
    
    isCollecting = false
end

-- Function to check for chests at all indices
local function checkAllChestIndices()
    while monitoring do
        if not isCollecting then
            local treasureFolder = workspace:FindFirstChild("Treasure")
            if treasureFolder then
                local chestsFolder = treasureFolder:FindFirstChild("Chests")
                if chestsFolder then
                    -- Check for direct Chest object first
                    local directChest = chestsFolder:FindFirstChild("Chest")
                    if directChest and not checkedIndices["direct"] then
                        print("Found direct Chest object!")
                        table.insert(chestQueue, {chest = directChest, index = "direct"})
                    end
                    
                    -- Check indices 1-5 for chests
                    local children = chestsFolder:GetChildren()
                    for i = 1, 5 do
                        if children[i] and children[i].Name == "Chest" and not checkedIndices[i] then
                            print("Found chest at index", i, ":", children[i].Name)
                            table.insert(chestQueue, {chest = children[i], index = i})
                        end
                    end
                end
            end
        end
        wait(0.2) -- Check every 0.2 seconds for fast detection
    end
end

-- Function to process chest queue
local function processChestQueue()
    while monitoring do
        if #chestQueue > 0 and not isCollecting then
            local chestData = table.remove(chestQueue, 1)
            if chestData.chest and chestData.chest.Parent then
                collectChest(chestData.chest, chestData.index)
            end
        end
        wait(0.1)
    end
end

-- Function to reset checked indices periodically
local function resetCheckedIndices()
    while monitoring do
        wait(30) -- Reset every 30 seconds to allow re-collection
        checkedIndices = {}
        print("Reset checked indices - can collect chests again!")
    end
end

-- Handle character respawn
plr.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    print("Character respawned, updated references")
end)

-- Start all processes
spawn(checkAllChestIndices)
spawn(processChestQueue)
spawn(resetCheckedIndices)

-- Stop script with F9
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F9 then
        monitoring = false
        print("Chest collector stopped!")
    end
end)

-- Manual check with F8
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F8 then
        print("Manual chest check triggered...")
        checkedIndices = {} -- Reset to allow immediate collection
        local treasureFolder = workspace:FindFirstChild("Treasure")
        if treasureFolder then
            local chestsFolder = treasureFolder:FindFirstChild("Chests")
            if chestsFolder then
                -- Check direct Chest
                local directChest = chestsFolder:FindFirstChild("Chest")
                if directChest then
                    print("Found direct Chest!")
                    table.insert(chestQueue, {chest = directChest, index = "direct"})
                end
                
                -- Check all indices
                local children = chestsFolder:GetChildren()
                for i = 1, 5 do
                    if children[i] and children[i].Name == "Chest" then
                        print("Found chest at index", i)
                        table.insert(chestQueue, {chest = children[i], index = i})
                    end
                end
                print("Manual check complete. Queue size:", #chestQueue)
            end
        end
    end
end)

print("Elemental Powers Tycoon Chest Collector loaded!")
print("Looking for workspace.Treasure.Chests.Chest and checking indices 1-5")
print("Press F9 to stop the script.")
print("Press F8 to manually check for chests.")
