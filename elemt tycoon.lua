
-- Elemental Powers Tycoon Auto Chest Collector
-- Monitors workspace.Treasure.Chests for new chests and auto-collects them

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

-- Function to teleport player
local function teleportTo(position)
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Function to simulate holding E key
local function holdEKey(duration)
    local keyCode = Enum.KeyCode.E
    
    -- Start holding E
    game:GetService("VirtualInputManager"):SendKeyEvent(true, keyCode, false, game)
    
    -- Wait for specified duration
    wait(duration)
    
    -- Release E
    game:GetService("VirtualInputManager"):SendKeyEvent(false, keyCode, false, game)
end

-- Function to collect a chest
local function collectChest(chest)
    if not chest or not chest.Parent then
        return
    end
    
    isCollecting = true
    print("Collecting chest:", chest.Name)
    
    -- Teleport to chest position
    if chest.PrimaryPart then
        teleportTo(chest.PrimaryPart.Position + Vector3.new(0, 5, 0))
    elseif chest:FindFirstChild("Part") then
        teleportTo(chest.Part.Position + Vector3.new(0, 5, 0))
    else
        -- Find any part in the chest model
        local part = chest:FindFirstChildOfClass("Part")
        if part then
            teleportTo(part.Position + Vector3.new(0, 5, 0))
        end
    end
    
    wait(0.5) -- Wait a moment after teleporting
    
    -- Hold E for 5 seconds to collect
    holdEKey(5)
    
    print("Finished collecting chest:", chest.Name)
    wait(1) -- Wait before moving to next chest
    
    isCollecting = false
end

-- Function to process chest queue
local function processChestQueue()
    while monitoring do
        if #chestQueue > 0 and not isCollecting then
            local chest = table.remove(chestQueue, 1)
            if chest and chest.Parent then
                collectChest(chest)
            end
        end
        wait(0.1)
    end
end

-- Function to monitor for new chests
local function monitorChests()
    local treasureFolder = workspace:WaitForChild("Treasure")
    local chestsFolder = treasureFolder:WaitForChild("Chests")
    
    -- Track existing chests
    local existingChests = {}
    for _, chest in pairs(chestsFolder:GetChildren()) do
        if chest.Name == "Chest" then
            existingChests[chest] = true
        end
    end
    
    -- Monitor for new chests
    chestsFolder.ChildAdded:Connect(function(child)
        if child.Name == "Chest" and not existingChests[child] then
            existingChests[child] = true
            table.insert(chestQueue, child)
            print("New chest detected! Added to queue.")
        end
    end)
    
    -- Clean up when chests are removed
    chestsFolder.ChildRemoved:Connect(function(child)
        if child.Name == "Chest" then
            existingChests[child] = nil
        end
    end)
    
    print("Chest monitoring started for Elemental Powers Tycoon!")
    print("Watching workspace.Treasure.Chests for new chests...")
end

-- Handle character respawn
plr.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end)

-- Start monitoring and processing
spawn(monitorChests)
spawn(processChestQueue)

-- Optional: Add a way to stop the script
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F9 then
        monitoring = false
        print("Chest collector stopped!")
    end
end)

print("Elemental Powers Tycoon Chest Collector loaded!")
print("Press F9 to stop the script.")
