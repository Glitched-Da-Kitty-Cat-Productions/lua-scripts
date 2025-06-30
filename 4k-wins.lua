
-- 4k Wins Teleport Script
-- Teleports player to coordinates: X: 5026.482, Y: -2.294, Z: -122

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function teleportTo4kWins()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = Vector3.new(5026.482, -2.294, -122)
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        print("Teleported to 4k wins location!")
    else
        warn("Character or HumanoidRootPart not found!")
    end
end

-- Execute the teleport
teleportTo4kWins()
