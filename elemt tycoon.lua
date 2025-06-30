
-- Elemental Powers Tycoon Auto Chest Teleport Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local autoTpEnabled = false
local connection = nil

local function teleportToChest()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local character = LocalPlayer.Character
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Check for chests in workspace.Treasure.Chests
    local treasureFolder = workspace:FindFirstChild("Treasure")
    if not treasureFolder then
        return
    end
    
    local chestsFolder = treasureFolder:FindFirstChild("Chests")
    if not chestsFolder then
        return
    end
    
    -- Find the nearest chest
    local nearestChest = nil
    local shortestDistance = math.huge
    
    for _, chest in pairs(chestsFolder:GetChildren()) do
        if chest and chest:FindFirstChild("HumanoidRootPart") or chest.PrimaryPart then
            local chestPosition = chest:FindFirstChild("HumanoidRootPart") and chest.HumanoidRootPart.Position or chest.PrimaryPart.Position
            local distance = (humanoidRootPart.Position - chestPosition).Magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                nearestChest = chest
            end
        end
    end
    
    -- Teleport to the nearest chest
    if nearestChest then
        local chestPosition = nearestChest:FindFirstChild("HumanoidRootPart") and nearestChest.HumanoidRootPart.CFrame or nearestChest.PrimaryPart.CFrame
        humanoidRootPart.CFrame = chestPosition + Vector3.new(0, 5, 0) -- Teleport slightly above the chest
    end
end

local function toggleAutoTp(enabled)
    autoTpEnabled = enabled
    
    if enabled then
        -- Start the auto teleport loop
        connection = RunService.Heartbeat:Connect(function()
            if autoTpEnabled then
                teleportToChest()
                task.wait(0.5) -- Wait half a second between teleports
            end
        end)
    else
        -- Stop the auto teleport loop
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Return the toggle function for use in the main menu
return {
    ToggleAutoTp = toggleAutoTp,
    TeleportToChest = teleportToChest
}
