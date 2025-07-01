-- Advanced Remote & Value Spy Script
-- Logs RemoteEvents, RemoteFunctions, Value changes, UI changes, clicks, movement, and chat

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local maxLogs = 500
local logs = {}
local isLogging = true
local logCount = 0

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedRemoteSpy"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "🔍 Advanced Remote + Value Logger"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Parent = MainFrame
LogFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LogFrame.Position = UDim2.new(0, 10, 0, 40)
LogFrame.Size = UDim2.new(1, -20, 1, -80)
LogFrame.ScrollBarThickness = 6
LogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 4)

local layout = Instance.new("UIListLayout")
layout.Parent = LogFrame
layout.Padding = UDim.new(0, 2)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function addLog(logType, name, details, color)
	if not isLogging then return end
	logCount += 1

	local label = Instance.new("TextLabel")
	label.Parent = LogFrame
	label.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
	label.Size = UDim2.new(1, -10, 0, 40)
	label.Font = Enum.Font.Code
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextSize = 10
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextWrapped = true
	label.Text = string.format("[%s] %s: %s\n%s", os.date("%H:%M:%S"), logType, name, details)
	label.LayoutOrder = logCount
	Instance.new("UICorner", label).CornerRadius = UDim.new(0, 3)

	task.wait()
	LogFrame.CanvasPosition = Vector2.new(0, LogFrame.AbsoluteCanvasSize.Y)

	if #LogFrame:GetChildren() > maxLogs then
		LogFrame:GetChildren()[1]:Destroy()
	end
end

-- Remote Hooking
local function formatArgs(...)
	local args, out = {...}, {}
	for _, v in ipairs(args) do
		if typeof(v) == "Instance" then table.insert(out, v:GetFullName())
		elseif typeof(v) == "Vector3" then table.insert(out, string.format("Vector3(%.1f, %.1f, %.1f)", v.X, v.Y, v.Z))
		else table.insert(out, tostring(v)) end
	end
	return table.concat(out, ", ")
end

local function hookRemotes()
	if hookfunction and getnamecallmethod then
		local old; old = hookfunction(game.namecall, function(self, ...)
			if not isLogging then return old(self, ...) end
			local method, args = getnamecallmethod(), {...}
			if method == "FireServer" and self:IsA("RemoteEvent") then
				addLog("RemoteEvent", self.Name, "Args: " .. formatArgs(unpack(args)), Color3.fromRGB(100, 255, 100))
			elseif method == "InvokeServer" and self:IsA("RemoteFunction") then
				addLog("RemoteFunction", self.Name, "Args: " .. formatArgs(unpack(args)), Color3.fromRGB(100, 100, 255))
			end
			return old(self, ...)
		end)
	end
end

-- Value Change Hooking
local function hookValueChanges()
	local function track(inst)
		if inst:IsA("StringValue") or inst:IsA("IntValue") or inst:IsA("BoolValue") or inst:IsA("NumberValue") then
			inst:GetPropertyChangedSignal("Value"):Connect(function()
				local src = "Unknown"
				if debug and debug.info then src = debug.info(2, "s") or "Unknown" end
				addLog("ValueChanged", inst:GetFullName(), "New Value: " .. tostring(inst.Value) .. " | Source: " .. src, Color3.fromRGB(255, 255, 0))
			end)
		end
	end
	for _, obj in pairs(game:GetDescendants()) do track(obj) end
	game.DescendantAdded:Connect(track)
end

-- Inputs
UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mouse = LocalPlayer:GetMouse()
		addLog("Click", "Mouse1", string.format("Position: %d, %d", mouse.X, mouse.Y), Color3.fromRGB(255, 200, 100))
	elseif input.UserInputType == Enum.UserInputType.Keyboard then
		addLog("Key", input.KeyCode.Name, "Keyboard input", Color3.fromRGB(200, 200, 255))
	end
end)

-- Movement
local lastPos = nil
RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if char then
		local pos = char.Position
		if lastPos and (pos - lastPos).Magnitude > 5 then
			addLog("Movement", "Moved", "From: " .. tostring(lastPos) .. " To: " .. tostring(pos), Color3.fromRGB(255, 255, 100))
		end
		lastPos = pos
	end
end)

-- Chat
LocalPlayer.Chatted:Connect(function(msg)
	addLog("Chat", "Message", msg, Color3.fromRGB(100, 255, 200))
end)

-- Init
hookRemotes()
hookValueChanges()
addLog("System", "Logger Ready", "Now tracking remotes, values, inputs, and movement", Color3.fromRGB(100, 255, 100))
