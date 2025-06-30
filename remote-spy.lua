
-- Advanced Remote Spy Script
-- Logs RemoteEvents, RemoteFunctions, user clicks, movement, chat, and more

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
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local LogFrame = Instance.new("ScrollingFrame")
local ClearButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local FilterFrame = Instance.new("Frame")
local FilterTitle = Instance.new("TextLabel")
local ChatToggle = Instance.new("TextButton")
local ClickToggle = Instance.new("TextButton")
local MovementToggle = Instance.new("TextButton")
local RemoteToggle = Instance.new("TextButton")

-- Tracking states
local trackChat = true
local trackClicks = true
local trackMovement = true
local trackRemotes = true

ScreenGui.Name = "AdvancedRemoteSpy"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Advanced Remote Spy - All Activity Monitor"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

-- Filter Frame
FilterFrame.Parent = MainFrame
FilterFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FilterFrame.BorderSizePixel = 0
FilterFrame.Position = UDim2.new(0, 10, 0, 35)
FilterFrame.Size = UDim2.new(1, -20, 0, 60)

local FilterCorner = Instance.new("UICorner")
FilterCorner.CornerRadius = UDim.new(0, 4)
FilterCorner.Parent = FilterFrame

FilterTitle.Parent = FilterFrame
FilterTitle.BackgroundTransparency = 1
FilterTitle.Position = UDim2.new(0, 5, 0, 0)
FilterTitle.Size = UDim2.new(1, 0, 0, 20)
FilterTitle.Font = Enum.Font.Gotham
FilterTitle.Text = "Tracking Filters:"
FilterTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
FilterTitle.TextSize = 10
FilterTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Filter Buttons
local filterButtons = {
    {ChatToggle, "Chat: ON", Color3.fromRGB(100, 255, 100)},
    {ClickToggle, "Clicks: ON", Color3.fromRGB(100, 255, 100)},
    {MovementToggle, "Movement: ON", Color3.fromRGB(100, 255, 100)},
    {RemoteToggle, "Remotes: ON", Color3.fromRGB(100, 255, 100)}
}

for i, data in pairs(filterButtons) do
    local button = data[1]
    button.Parent = FilterFrame
    button.BackgroundColor3 = data[3]
    button.BorderSizePixel = 0
    button.Position = UDim2.new((i-1) * 0.25, 5, 0, 25)
    button.Size = UDim2.new(0.24, -5, 0, 25)
    button.Font = Enum.Font.Gotham
    button.Text = data[2]
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 9
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = button
end

-- Log Frame
LogFrame.Parent = MainFrame
LogFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LogFrame.BorderSizePixel = 0
LogFrame.Position = UDim2.new(0, 10, 0, 105)
LogFrame.Size = UDim2.new(1, -20, 1, -155)
LogFrame.ScrollBarThickness = 8
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 4)
LogCorner.Parent = LogFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.Parent = LogFrame
LogLayout.Padding = UDim.new(0, 2)
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Control Buttons
ClearButton.Parent = MainFrame
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0, 10, 1, -40)
ClearButton.Size = UDim2.new(0, 100, 0, 30)
ClearButton.Font = Enum.Font.Gotham
ClearButton.Text = "Clear Logs"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 12

ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 120, 1, -40)
ToggleButton.Size = UDim2.new(0, 120, 0, 30)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "Logging: ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12

-- Add corners to buttons
for _, button in pairs({ClearButton, ToggleButton}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
end

-- Utility Functions
local function formatArgs(...)
    local args = {...}
    local formatted = {}
    
    for i, arg in pairs(args) do
        if type(arg) == "string" then
            table.insert(formatted, '"' .. arg .. '"')
        elseif typeof(arg) == "Instance" then
            table.insert(formatted, arg:GetFullName())
        elseif typeof(arg) == "Vector3" then
            table.insert(formatted, string.format("Vector3(%.1f, %.1f, %.1f)", arg.X, arg.Y, arg.Z))
        else
            table.insert(formatted, tostring(arg))
        end
    end
    
    return table.concat(formatted, ", ")
end

local function addLog(logType, action, details, color)
    if not isLogging then return end
    
    logCount = logCount + 1
    
    local logData = {
        type = logType,
        action = action,
        details = details,
        time = os.date("%H:%M:%S"),
        id = logCount
    }
    
    table.insert(logs, logData)
    
    if #logs > maxLogs then
        table.remove(logs, 1)
    end
    
    -- Create GUI log entry
    local LogEntry = Instance.new("TextLabel")
    LogEntry.Parent = LogFrame
    LogEntry.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
    LogEntry.BorderSizePixel = 0
    LogEntry.Size = UDim2.new(1, -10, 0, 40)
    LogEntry.Font = Enum.Font.Code
    LogEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogEntry.TextSize = 9
    LogEntry.TextWrapped = true
    LogEntry.TextXAlignment = Enum.TextXAlignment.Left
    LogEntry.TextYAlignment = Enum.TextYAlignment.Top
    LogEntry.LayoutOrder = logCount
    
    local EntryCorner = Instance.new("UICorner")
    EntryCorner.CornerRadius = UDim.new(0, 3)
    EntryCorner.Parent = LogEntry
    
    LogEntry.Text = string.format("[%s] %s: %s\n%s", 
        logData.time, 
        logType,
        action,
        details
    )
    
    -- Auto-scroll to bottom
    task.wait()
    LogFrame.CanvasPosition = Vector2.new(0, LogFrame.AbsoluteCanvasSize.Y)
    
    -- Remove old GUI entries
    local children = LogFrame:GetChildren()
    local logEntries = {}
    for _, child in pairs(children) do
        if child:IsA("TextLabel") then
            table.insert(logEntries, child)
        end
    end
    
    if #logEntries > maxLogs then
        logEntries[1]:Destroy()
    end
end

-- Hooking Functions
local function hookRemotes()
    -- Hook RemoteEvents and RemoteFunctions
    if hookfunction and getnamecallmethod then
        local oldNamecall
        oldNamecall = hookfunction(game.namecall, function(self, ...)
            if not trackRemotes or not isLogging then
                return oldNamecall(self, ...)
            end
            
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "FireServer" and self:IsA("RemoteEvent") then
                addLog("RemoteEvent", self.Name, "Args: " .. formatArgs(unpack(args)), Color3.fromRGB(100, 150, 100))
            elseif method == "InvokeServer" and self:IsA("RemoteFunction") then
                addLog("RemoteFunction", self.Name, "Args: " .. formatArgs(unpack(args)), Color3.fromRGB(100, 100, 150))
            end
            
            return oldNamecall(self, ...)
        end)
    end
    
    -- Monitor existing remotes
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            obj.OnClientEvent:Connect(function(...)
                if trackRemotes and isLogging then
                    addLog("RemoteEvent", obj.Name .. " (Client)", "Args: " .. formatArgs(...), Color3.fromRGB(150, 100, 100))
                end
            end)
        end
    end
end

-- Track User Input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not trackClicks or not isLogging then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = LocalPlayer:GetMouse()
        addLog("Click", "Left Click", string.format("Position: (%d, %d)", mouse.X, mouse.Y), Color3.fromRGB(255, 200, 100))
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        local mouse = LocalPlayer:GetMouse()
        addLog("Click", "Right Click", string.format("Position: (%d, %d)", mouse.X, mouse.Y), Color3.fromRGB(255, 150, 100))
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        addLog("Keyboard", "Key Press", "Key: " .. input.KeyCode.Name, Color3.fromRGB(200, 200, 255))
    end
end)

-- Track Movement
local lastPosition = nil
RunService.Heartbeat:Connect(function()
    if not trackMovement or not isLogging then return end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
        if lastPosition and (currentPos - lastPosition).Magnitude > 5 then
            addLog("Movement", "Position Change", string.format("From: %s To: %s", 
                tostring(lastPosition), tostring(currentPos)), Color3.fromRGB(255, 255, 100))
        end
        lastPosition = currentPos
    end
end)

-- Track Chat
LocalPlayer.Chatted:Connect(function(message)
    if trackChat and isLogging then
        addLog("Chat", "Message Sent", "Message: " .. message, Color3.fromRGB(100, 255, 200))
    end
end)

-- Button Events
ClearButton.MouseButton1Click:Connect(function()
    logs = {}
    logCount = 0
    for _, child in pairs(LogFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    isLogging = not isLogging
    ToggleButton.Text = isLogging and "Logging: ON" or "Logging: OFF"
    ToggleButton.BackgroundColor3 = isLogging and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

-- Filter Button Events
ChatToggle.MouseButton1Click:Connect(function()
    trackChat = not trackChat
    ChatToggle.Text = trackChat and "Chat: ON" or "Chat: OFF"
    ChatToggle.BackgroundColor3 = trackChat and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

ClickToggle.MouseButton1Click:Connect(function()
    trackClicks = not trackClicks
    ClickToggle.Text = trackClicks and "Clicks: ON" or "Clicks: OFF"
    ClickToggle.BackgroundColor3 = trackClicks and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

MovementToggle.MouseButton1Click:Connect(function()
    trackMovement = not trackMovement
    MovementToggle.Text = trackMovement and "Movement: ON" or "Movement: OFF"
    MovementToggle.BackgroundColor3 = trackMovement and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

RemoteToggle.MouseButton1Click:Connect(function()
    trackRemotes = not trackRemotes
    RemoteToggle.Text = trackRemotes and "Remotes: ON" or "Remotes: OFF"
    RemoteToggle.BackgroundColor3 = trackRemotes and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

-- Initialize
hookRemotes()
addLog("System", "Advanced Remote Spy", "Loaded successfully! Tracking all activity.", Color3.fromRGB(100, 255, 100))
print("Advanced Remote Spy loaded! Now tracking clicks, movement, chat, and remotes.")
