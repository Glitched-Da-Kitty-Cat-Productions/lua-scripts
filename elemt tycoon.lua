
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
        print("Teleported to:", position)
    end
end

-- Function to simulate holding E key (improved version)
local function holdEKey(duration)
    print("Holding E key for", duration, "seconds")
    
    -- Try multiple methods to trigger E key
    local success = false
    
    -- Method 1: VirtualInputManager
    pcall(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
        wait(duration)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        success = true
    end)
    
    -- Method 2: If VirtualInputManager fails, try firing proximity prompts directly
    if not success then
        local function findAndFirePrompts()
            for i = 1, duration * 10 do -- Check 10 times per second
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

-- Function to get chest position more reliably
local function getChestPosition(chest)
    -- Try multiple methods to find a valid position
    local position = nil
    
    -- Method 1: PrimaryPart
    if chest.PrimaryPart then
        position = chest.PrimaryPart.Position
    -- Method 2: Part named "Part"
    elseif chest:FindFirstChild("Part") then
        position = chest.Part.Position
    -- Method 3: Any BasePart
    else
        local part = chest:FindFirstChildOfClass("BasePart")
        if part then
            position = part.Position
        end
    end
    
    return position
end

-- Function to collect a chest
local function collectChest(chest)
    if not chest or not chest.Parent then
        print("Chest is nil or has no parent")
        return
    end
    
    isCollecting = true
    print("Collecting chest:", chest.Name)
    
    -- Get chest position
    local chestPosition = getChestPosition(chest)
    if not chestPosition then
        print("Could not find chest position for:", chest.Name)
        isCollecting = false
        return
    end
    
    -- Teleport to chest position (closer to the chest)
    local teleportPosition = chestPosition + Vector3.new(0, 2, 0) -- Only 2 studs above
    teleportTo(teleportPosition)
    
    wait(1) -- Wait longer after teleporting
    
    -- Hold E for 5 seconds to collect
    holdEKey(5)
    
    print("Finished collecting chest:", chest.Name)
    wait(2) -- Wait before moving to next chest
    
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
    -- Wait for workspace structure
    local treasureFolder = workspace:WaitForChild("Treasure", 10)
    if not treasureFolder then
        print("Could not find Treasure folder in workspace!")
        return
    end
    
    local chestsFolder = treasureFolder:WaitForChild("Chests", 10)
    if not chestsFolder then
        print("Could not find Chests folder in Treasure!")
        return
    end
    
    print("Found Chests folder, starting monitoring...")
    
    -- Track chest count to detect new ones
    local lastChestCount = #chestsFolder:GetChildren()
    print("Initial chest count:", lastChestCount)
    
    -- Monitor for chest count changes
    local function checkForNewChests()
        local currentChests = chestsFolder:GetChildren()
        local currentCount = #currentChests
        
        if currentCount > lastChestCount then
            print("New chest detected! Count increased from", lastChestCount, "to", currentCount)
            
            -- Get the newest chest (highest index)
            local newestChest = currentChests[currentCount]
            if newestChest then
                table.insert(chestQueue, newestChest)
                print("Added newest chest to queue:", newestChest.Name, "at index", currentCount)
                print("Queue size:", #chestQueue)
            end
            
            lastChestCount = currentCount
        elseif currentCount < lastChestCount then
            print("Chest removed. Count decreased from", lastChestCount, "to", currentCount)
            lastChestCount = currentCount
        end
    end
    
    -- Check every 0.5 seconds for new chests
    spawn(function()
        while monitoring do
            checkForNewChests()
            wait(0.5)
        end
    end)
    
    -- Also monitor ChildAdded as backup
    chestsFolder.ChildAdded:Connect(function(child)
        print("ChildAdded detected:", child.Name)
        wait(0.1) -- Small delay to ensure it's properly added
        checkForNewChests()
    end)
    
    print("Chest monitoring started for Elemental Powers Tycoon!")
    print("Watching workspace.Treasure.Chests for new chests using index monitoring...")
end

-- Handle character respawn
plr.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    print("Character respawned, updated references")
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

-- Debug: Add manual chest collection for testing
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F8 then
        print("Manual chest detection triggered...")
        local treasureFolder = workspace:FindFirstChild("Treasure")
        if treasureFolder then
            local chestsFolder = treasureFolder:FindFirstChild("Chests")
            if chestsFolder then
                local chests = chestsFolder:GetChildren()
                print("Found", #chests, "chests in folder")
                
                for i, chest in pairs(chests) do
                    print("Chest", i, ":", chest.Name)
                    table.insert(chestQueue, chest)
                    print("Manually added chest to queue:", chest.Name, "at index", i)
                end
                print("Manual detection complete. Queue size:", #chestQueue)
            else
                print("No Chests folder found!")
            end
        else
            print("No Treasure folder found!")
        end
    end
end)

print("Elemental Powers Tycoon Chest Collector loaded!")
print("Press F9 to stop the script.")
print("Press F8 to manually detect existing chests.")
