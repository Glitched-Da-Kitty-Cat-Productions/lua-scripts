local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local tool = Instance.new("Tool")
tool.Name = "Fling Tool"
tool.RequiresHandle = false
tool.Parent = player.Backpack

local hiddenfling = false
local flingThread

local function fling()
    local lp = player
    local c, hrp, vel, movel = nil, nil, nil, 0.1

    while hiddenfling do
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

tool.Equipped:Connect(function()
    hiddenfling = true
    flingThread = coroutine.create(fling)
    coroutine.resume(flingThread)
end)

tool.Unequipped:Connect(function()
    hiddenfling = false
end)
