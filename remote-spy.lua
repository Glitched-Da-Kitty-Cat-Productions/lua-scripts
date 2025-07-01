-- Add these inside your GUI setup (after Title creation, before LogFrame)

local buttonFrame = Instance.new("Frame")
buttonFrame.Parent = MainFrame
buttonFrame.BackgroundTransparency = 1
buttonFrame.Position = UDim2.new(1, -150, 0, 5)
buttonFrame.Size = UDim2.new(0, 140, 0, 25)

local function makeButton(text, position)
	local btn = Instance.new("TextButton")
	btn.Parent = buttonFrame
	btn.Size = UDim2.new(0, 65, 1, 0)
	btn.Position = position
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	return btn
end

local startButton = makeButton("Start", UDim2.new(0, 0, 0, 0))
local stopButton = makeButton("Stop", UDim2.new(0, 75, 0, 0))

-- Button functionality
startButton.MouseButton1Click:Connect(function()
	isLogging = true
	addLog("System", "Logging", "Logging started", Color3.fromRGB(100, 255, 100))
end)

stopButton.MouseButton1Click:Connect(function()
	isLogging = false
	addLog("System", "Logging", "Logging stopped", Color3.fromRGB(255, 100, 100))
end)

-- Color updates in addLog function calls

local function addLog(logType, name, details, color)
	if not isLogging then return end
	logCount += 1

	local label = Instance.new("TextLabel")
	label.Parent = LogFrame
	label.BackgroundColor3 = color or Color3.fromRGB(60, 60, 60)
	label.Size = UDim2.new(1, -10, 0, 40)
	label.Font = Enum.Font.Code
	label.TextColor3 = Color3.fromRGB(230, 230, 230)
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextWrapped = true
	label.Text = string.format("[%s] %s: %s\n%s", os.date("%H:%M:%S"), logType, name, details)
	label.LayoutOrder = logCount
	Instance.new("UICorner", label).CornerRadius = UDim.new(0, 4)

	task.wait()
	LogFrame.CanvasPosition = Vector2.new(0, LogFrame.AbsoluteCanvasSize.Y)

	if #LogFrame:GetChildren() > maxLogs then
		LogFrame:GetChildren()[1]:Destroy()
	end
end

-- Replace these color codes with more readable ones:

-- In hookRemotes:
addLog("RemoteEvent", self.Name, "Args: " .. formatArgs(unpack(args)), Color3.fromRGB(0, 180, 0)) -- dark green
addLog("RemoteFunction", self.Name, "Args: " .. formatArgs(unpack(args)), Color3.fromRGB(0, 120, 180)) -- teal blue

-- In hookValueChanges:
addLog("ValueChanged", inst:GetFullName(), "New Value: " .. tostring(inst.Value) .. " | Source: " .. src, Color3.fromRGB(200, 180, 0)) -- golden yellow

-- In Inputs:
addLog("Click", "Mouse1", string.format("Position: %d, %d", mouse.X, mouse.Y), Color3.fromRGB(180, 130, 0)) -- amber
addLog("Key", input.KeyCode.Name, "Keyboard input", Color3.fromRGB(120, 140, 180)) -- soft blue

-- Movement:
addLog("Movement", "Moved", "From: " .. tostring(lastPos) .. " To: " .. tostring(pos), Color3.fromRGB(200, 180, 40)) -- mustard yellow

-- Chat:
addLog("Chat", "Message", msg, Color3.fromRGB(0, 180, 120)) -- greenish teal

-- System Ready:
addLog("System", "Logger Ready", "Now tracking remotes, values, inputs, and movement", Color3.fromRGB(0, 180, 0)) -- green

