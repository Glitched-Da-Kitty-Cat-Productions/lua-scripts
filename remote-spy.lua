
-- Enhanced Remote Spy for Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Configuration
local isLogging = false
local logCount = 0
local maxLogs = 100
local hookedRemotes = {}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RemoteSpyGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 8)

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(1, -20, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "Remote Spy - Enhanced"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Button Frame
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Parent = MainFrame
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Position = UDim2.new(1, -150, 0, 5)
ButtonFrame.Size = UDim2.new(0, 140, 0, 25)

local function makeButton(text, position)
    local btn = Instance.new("TextButton")
    btn.Parent = ButtonFrame
    btn.Size = UDim2.new(0, 65, 1, 0)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    return btn
end

local StartButton = makeButton("Start", UDim2.new(0, 0, 0, 0))
local StopButton = makeButton("Stop", UDim2.new(0, 75, 0, 0))

-- Clear Button
local ClearButton = Instance.new("TextButton")
ClearButton.Parent = MainFrame
ClearButton.Size = UDim2.new(0, 60, 0, 25)
ClearButton.Position = UDim2.new(0, 10, 0, 35)
ClearButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ClearButton.TextColor3 = Color3.fromRGB(220, 220, 220)
ClearButton.Font = Enum.Font.GothamBold
ClearButton.TextSize = 14
ClearButton.Text = "Clear"

local clearCorner = Instance.new("UICorner")
clearCorner.Parent = ClearButton
clearCorner.CornerRadius = UDim.new(0, 4)

-- Log Frame
local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Parent = MainFrame
LogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LogFrame.Position = UDim2.new(0, 10, 0, 70)
LogFrame.Size = UDim2.new(1, -20, 1, -80)
LogFrame.ScrollBarThickness = 8
LogFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)

local LogCorner = Instance.new("UICorner")
LogCorner.Parent = LogFrame
LogCorner.CornerRadius = UDim.new(0, 4)

local Layout = Instance.new("UIListLayout")
Layout.Parent = LogFrame
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 2)

-- Functions
local function formatArgs(...)
    local args = {...}
    local formatted = {}
    
    for i, arg in ipairs(args) do
        local argType = type(arg)
        if argType == "string" then
            table.insert(formatted, '"' .. tostring(arg) .. '"')
        elseif argType == "number" then
            table.insert(formatted, tostring(arg))
        elseif argType == "boolean" then
            table.insert(formatted, tostring(arg))
        elseif argType == "table" then
            table.insert(formatted, "Table")
        elseif argType == "userdata" then
            table.insert(formatted, tostring(arg))
        else
            table.insert(formatted, argType)
        end
    end
    
    return table.concat(formatted, ", ")
end

local function addLog(logType, name, details, color)
    if not isLogging then return end
    logCount = logCount + 1

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
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.Parent = label
    labelCorner.CornerRadius = UDim.new(0, 4)

    task.wait()
    LogFrame.CanvasPosition = Vector2.new(0, LogFrame.AbsoluteCanvasSize.Y)

    if #LogFrame:GetChildren() > maxLogs + 2 then -- +2 for UIListLayout and UICorner
        for i, child in ipairs(LogFrame:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
                break
            end
        end
    end
end

-- Hook remotes
local function hookRemotes()
    local function hookRemote(remote, remoteType)
        if hookedRemotes[remote] then return end
        hookedRemotes[remote] = true
        
        local originalMethod = remote[remoteType == "RemoteEvent" and "FireServer" or "InvokeServer"]
        
        remote[remoteType == "RemoteEvent" and "FireServer" or "InvokeServer"] = function(self, ...)
            local args = {...}
            addLog(remoteType, self.Name, "Args: " .. formatArgs(unpack(args)), 
                   remoteType == "RemoteEvent" and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(0, 120, 180))
            return originalMethod(self, ...)
        end
    end
    
    -- Hook existing remotes
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            hookRemote(obj, "RemoteEvent")
        elseif obj:IsA("RemoteFunction") then
            hookRemote(obj, "RemoteFunction")
        end
    end
    
    -- Hook new remotes
    ReplicatedStorage.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") then
            hookRemote(obj, "RemoteEvent")
        elseif obj:IsA("RemoteFunction") then
            hookRemote(obj, "RemoteFunction")
        end
    end)
end

-- Hook value changes
local function hookValueChanges()
    local function hookValue(obj)
        if obj:IsA("StringValue") or obj:IsA("IntValue") or obj:IsA("NumberValue") or obj:IsA("BoolValue") then
            obj.Changed:Connect(function()
                addLog("ValueChanged", obj:GetFullName(), "New Value: " .. tostring(obj.Value), Color3.fromRGB(200, 180, 0))
            end)
        end
    end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        hookValue(obj)
    end
    
    workspace.DescendantAdded:Connect(hookValue)
end

-- Hook inputs
local function hookInputs()
    UserInputService.InputBegan:Connect(function(input)
        if not isLogging then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = LocalPlayer:GetMouse()
            addLog("Click", "Mouse1", string.format("Position: %d, %d", mouse.X, mouse.Y), Color3.fromRGB(180, 130, 0))
        elseif input.UserInputType == Enum.UserInputType.Keyboard then
            addLog("Key", input.KeyCode.Name, "Keyboard input", Color3.fromRGB(120, 140, 180))
        end
    end)
end

-- Hook movement
local function hookMovement()
    local lastPos = nil
    
    RunService.Heartbeat:Connect(function()
        if not isLogging or not LocalPlayer.Character then return end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local pos = humanoidRootPart.Position
        if lastPos and (pos - lastPos).Magnitude > 5 then
            addLog("Movement", "Moved", "From: " .. tostring(lastPos) .. " To: " .. tostring(pos), Color3.fromRGB(200, 180, 40))
        end
        lastPos = pos
    end)
end

-- Hook chat
local function hookChat()
    LocalPlayer.Chatted:Connect(function(msg)
        if not isLogging then return end
        addLog("Chat", "Message", msg, Color3.fromRGB(0, 180, 120))
    end)
end

-- Button functionality
StartButton.MouseButton1Click:Connect(function()
    isLogging = true
    addLog("System", "Logging", "Logging started", Color3.fromRGB(100, 255, 100))
end)

StopButton.MouseButton1Click:Connect(function()
    isLogging = false
    addLog("System", "Logging", "Logging stopped", Color3.fromRGB(255, 100, 100))
end)

ClearButton.MouseButton1Click:Connect(function()
    for _, child in pairs(LogFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    logCount = 0
end)

-- Initialize
hookRemotes()
hookValueChanges()
hookInputs()
hookMovement()
hookChat()

addLog("System", "Logger Ready", "Now tracking remotes, values, inputs, and movement", Color3.fromRGB(0, 180, 0))

print("Enhanced Remote Spy loaded successfully!")
