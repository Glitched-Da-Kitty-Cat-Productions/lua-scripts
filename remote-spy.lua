
-- Remote Spy Script (Fixed Version)
-- Logs all RemoteEvent and RemoteFunction calls using proper hooking

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local maxLogs = 1000
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
local ExportButton = Instance.new("TextButton")

ScreenGui.Name = "RemoteSpy"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Remote Spy (Fixed)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

LogFrame.Parent = MainFrame
LogFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LogFrame.BorderSizePixel = 0
LogFrame.Position = UDim2.new(0, 10, 0, 40)
LogFrame.Size = UDim2.new(1, -20, 1, -90)
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

ClearButton.Parent = MainFrame
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0, 10, 1, -40)
ClearButton.Size = UDim2.new(0, 100, 0, 30)
ClearButton.Font = Enum.Font.Gotham
ClearButton.Text = "Clear Logs"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 12

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 4)
ClearCorner.Parent = ClearButton

ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 120, 1, -40)
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "Logging: ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 4)
ToggleCorner.Parent = ToggleButton

ExportButton.Parent = MainFrame
ExportButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
ExportButton.BorderSizePixel = 0
ExportButton.Position = UDim2.new(0, 230, 1, -40)
ExportButton.Size = UDim2.new(0, 100, 0, 30)
ExportButton.Font = Enum.Font.Gotham
ExportButton.Text = "Export Logs"
ExportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExportButton.TextSize = 12

local ExportCorner = Instance.new("UICorner")
ExportCorner.CornerRadius = UDim.new(0, 4)
ExportCorner.Parent = ExportButton

-- Utility functions
local function formatArgs(...)
    local args = {...}
    local formatted = {}
    
    for i, arg in pairs(args) do
        if type(arg) == "string" then
            table.insert(formatted, '"' .. arg .. '"')
        elseif type(arg) == "number" then
            table.insert(formatted, tostring(arg))
        elseif type(arg) == "boolean" then
            table.insert(formatted, tostring(arg))
        elseif typeof(arg) == "Instance" then
            table.insert(formatted, arg:GetFullName())
        elseif typeof(arg) == "Vector3" then
            table.insert(formatted, string.format("Vector3.new(%.2f, %.2f, %.2f)", arg.X, arg.Y, arg.Z))
        elseif typeof(arg) == "CFrame" then
            table.insert(formatted, "CFrame.new(...)")
        elseif type(arg) == "table" then
            local tableStr = "{"
            local count = 0
            for k, v in pairs(arg) do
                if count < 3 then -- Limit to first 3 items
                    tableStr = tableStr .. tostring(k) .. "=" .. tostring(v) .. ", "
                    count = count + 1
                else
                    tableStr = tableStr .. "..."
                    break
                end
            end
            tableStr = tableStr .. "}"
            table.insert(formatted, tableStr)
        else
            table.insert(formatted, tostring(arg))
        end
    end
    
    return table.concat(formatted, ", ")
end

local function addLog(remoteType, remoteName, remotePath, args)
    if not isLogging then return end
    
    logCount = logCount + 1
    
    local logData = {
        type = remoteType,
        name = remoteName,
        path = remotePath,
        args = args,
        time = os.date("%H:%M:%S"),
        id = logCount
    }
    
    table.insert(logs, logData)
    
    -- Remove old logs if we exceed the limit
    if #logs > maxLogs then
        table.remove(logs, 1)
    end
    
    -- Create GUI log entry
    local LogEntry = Instance.new("TextLabel")
    LogEntry.Parent = LogFrame
    LogEntry.BackgroundColor3 = remoteType == "RemoteEvent" and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(50, 50, 100)
    LogEntry.BorderSizePixel = 0
    LogEntry.Size = UDim2.new(1, -10, 0, 60)
    LogEntry.Font = Enum.Font.Code
    LogEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogEntry.TextSize = 10
    LogEntry.TextWrapped = true
    LogEntry.TextXAlignment = Enum.TextXAlignment.Left
    LogEntry.TextYAlignment = Enum.TextYAlignment.Top
    LogEntry.LayoutOrder = logCount
    
    local EntryCorner = Instance.new("UICorner")
    EntryCorner.CornerRadius = UDim.new(0, 3)
    EntryCorner.Parent = LogEntry
    
    local formattedArgs = formatArgs(unpack(args))
    LogEntry.Text = string.format("[%s] %s\nPath: %s\nArgs: %s", 
        logData.time, 
        remoteType, 
        remotePath, 
        formattedArgs
    )
    
    -- Auto-scroll to bottom
    task.wait()
    LogFrame.CanvasPosition = Vector2.new(0, LogFrame.AbsoluteCanvasSize.Y)
    
    -- Remove old GUI entries if too many
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

-- Hook into RemoteEvent and RemoteFunction using proper method if available
local function hookRemotes()
    -- Method 1: Try to use hookfunction if available
    if hookfunction then
        local oldNamecall
        oldNamecall = hookfunction(game.namecall, function(self, ...)
            if not isLogging then
                return oldNamecall(self, ...)
            end
            
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "FireServer" and self:IsA("RemoteEvent") then
                addLog("RemoteEvent", self.Name, self:GetFullName(), args)
            elseif method == "InvokeServer" and self:IsA("RemoteFunction") then
                addLog("RemoteFunction", self.Name, self:GetFullName(), args)
            end
            
            return oldNamecall(self, ...)
        end)
        
        addLog("System", "RemoteSpy", "System", {"Using hookfunction method"})
    else
        -- Method 2: Fallback to monitoring network events
        local function monitorRemote(remote)
            if remote:IsA("RemoteEvent") then
                remote.OnClientEvent:Connect(function(...)
                    addLog("RemoteEvent (Client)", remote.Name, remote:GetFullName(), {...})
                end)
            end
        end
        
        -- Monitor existing remotes
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                monitorRemote(remote)
            end
        end
        
        -- Monitor new remotes
        game.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                task.wait() -- Wait a frame
                monitorRemote(descendant)
            end
        end)
        
        addLog("System", "RemoteSpy", "System", {"Using fallback monitoring method"})
    end
end

-- Button events
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
    if isLogging then
        ToggleButton.Text = "Logging: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleButton.Text = "Logging: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

ExportButton.MouseButton1Click:Connect(function()
    local exportString = "-- Remote Spy Export --\n"
    exportString = exportString .. "-- Generated at: " .. os.date() .. "\n\n"
    
    for i, log in pairs(logs) do
        exportString = exportString .. string.format(
            "[%s] %s: %s\nArgs: %s\n\n",
            log.time,
            log.type,
            log.path,
            formatArgs(unpack(log.args))
        )
    end
    
    -- Try to copy to clipboard or print
    if setclipboard then
        setclipboard(exportString)
        addLog("System", "RemoteSpy", "System", {"Logs copied to clipboard!"})
    else
        print(exportString)
        addLog("System", "RemoteSpy", "System", {"Logs printed to console!"})
    end
end)

-- Initialize
hookRemotes()
print("Remote Spy (Fixed) loaded! All remote calls are now being logged.")
addLog("System", "RemoteSpy", "System", {"Remote Spy initialized successfully!"})
