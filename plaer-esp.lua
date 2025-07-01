
-- Player ESP Module for Glitched Nordic Void Menu
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local PlayerESP = {}
PlayerESP.Enabled = false
PlayerESP.TeamCheck = false
PlayerESP.ShowDistance = true
PlayerESP.ShowHealth = true
PlayerESP.ShowName = true
PlayerESP.BoxESP = true
PlayerESP.TracerESP = false
PlayerESP.ESPColor = Color3.fromRGB(255, 255, 255)
PlayerESP.BoxESPColor = "Default"
PlayerESP.TracerESPColor = "Default"
PlayerESP.EnemyColor = Color3.fromRGB(255, 0, 0)
PlayerESP.TeamColor = Color3.fromRGB(0, 255, 0)
PlayerESP.BoxESPCustomColor = Color3.fromRGB(255, 255, 255)
PlayerESP.TracerESPCustomColor = Color3.fromRGB(255, 255, 255)

local ESPObjects = {}
local Connections = {}

-- Drawing objects cache
local function createDrawing(type, properties)
    local drawing = Drawing.new(type)
    for property, value in pairs(properties or {}) do
        drawing[property] = value
    end
    return drawing
end

-- Clean up ESP for a player
local function cleanupESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if obj and obj.Remove then
                obj:Remove()
            end
        end
        ESPObjects[player] = nil
    end
end

-- Create ESP for a player
local function createESP(player)
    if player == LocalPlayer then return end
    
    cleanupESP(player)
    
    ESPObjects[player] = {
        Box = createDrawing("Square", {
            Thickness = 2,
            Filled = false,
            Transparency = 1,
            Visible = false
        }),
        Tracer = createDrawing("Line", {
            Thickness = 2,
            Transparency = 1,
            Visible = false
        }),
        Name = createDrawing("Text", {
            Size = 16,
            Center = true,
            Outline = true,
            OutlineColor = Color3.new(0, 0, 0),
            Transparency = 1,
            Visible = false
        }),
        Health = createDrawing("Text", {
            Size = 14,
            Center = true,
            Outline = true,
            OutlineColor = Color3.new(0, 0, 0),
            Transparency = 1,
            Visible = false
        }),
        Distance = createDrawing("Text", {
            Size = 12,
            Center = true,
            Outline = true,
            OutlineColor = Color3.new(0, 0, 0),
            Transparency = 1,
            Visible = false
        })
    }
end

-- Update ESP for a player
local function updateESP(player)
    if not PlayerESP.Enabled or not ESPObjects[player] or player == LocalPlayer then return end
    
    local character = player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local head = character and character:FindFirstChild("Head")
    
    if not character or not humanoid or not rootPart or not head then
        for _, obj in pairs(ESPObjects[player]) do
            obj.Visible = false
        end
        return
    end
    
    -- Team check
    if PlayerESP.TeamCheck and player.Team == LocalPlayer.Team then
        for _, obj in pairs(ESPObjects[player]) do
            obj.Visible = false
        end
        return
    end
    
    -- Get screen position
    local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
    
    if not onScreen then
        for _, obj in pairs(ESPObjects[player]) do
            obj.Visible = false
        end
        return
    end
    
    -- Calculate distance
    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
        and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude) or 0
    
    -- Helper function for rainbow color
    local function getRainbowColor(speed)
        local hue = (tick() * speed) % 1
        return Color3.fromHSV(hue, 1, 1)
    end
    
    -- Determine box color
    local boxColor = PlayerESP.ESPColor
    if PlayerESP.TeamCheck then
        boxColor = (player.Team == LocalPlayer.Team) and PlayerESP.TeamColor or PlayerESP.EnemyColor
    end
    if PlayerESP.BoxESPColor == "Red" then
        boxColor = Color3.fromRGB(255, 0, 0)
    elseif PlayerESP.BoxESPColor == "Orange" then
        boxColor = Color3.fromRGB(255, 165, 0)
    elseif PlayerESP.BoxESPColor == "Pink" then
        boxColor = Color3.fromRGB(255, 105, 180)
    elseif PlayerESP.BoxESPColor == "Rainbow" then
        boxColor = getRainbowColor(2)
    elseif PlayerESP.BoxESPColor == "Custom" and PlayerESP.BoxESPCustomColor then
        boxColor = PlayerESP.BoxESPCustomColor
    end
    
    -- Determine tracer color
    local tracerColor = PlayerESP.ESPColor
    if PlayerESP.TeamCheck then
        tracerColor = (player.Team == LocalPlayer.Team) and PlayerESP.TeamColor or PlayerESP.EnemyColor
    end
    if PlayerESP.TracerESPColor == "Red" then
        tracerColor = Color3.fromRGB(255, 0, 0)
    elseif PlayerESP.TracerESPColor == "Orange" then
        tracerColor = Color3.fromRGB(255, 165, 0)
    elseif PlayerESP.TracerESPColor == "Pink" then
        tracerColor = Color3.fromRGB(255, 105, 180)
    elseif PlayerESP.TracerESPColor == "Rainbow" then
        tracerColor = getRainbowColor(2)
    elseif PlayerESP.TracerESPColor == "Custom" and PlayerESP.TracerESPCustomColor then
        tracerColor = PlayerESP.TracerESPCustomColor
    end
    
    -- Box ESP
    if PlayerESP.BoxESP then
        local box = ESPObjects[player].Box
        local boxHeight = math.abs(headPos.Y - legPos.Y)
        local boxWidth = boxHeight * 0.6
        
        box.Size = Vector2.new(boxWidth, boxHeight)
        box.Position = Vector2.new(rootPos.X - boxWidth/2, headPos.Y)
        box.Color = boxColor
        box.Visible = true
    else
        ESPObjects[player].Box.Visible = false
    end
    
    -- Tracer ESP
    if PlayerESP.TracerESP then
        local tracer = ESPObjects[player].Tracer
        local screenSize = Camera.ViewportSize
        tracer.From = Vector2.new(screenSize.X/2, screenSize.Y)
        tracer.To = Vector2.new(rootPos.X, rootPos.Y)
        tracer.Color = tracerColor
        tracer.Visible = true
    else
        ESPObjects[player].Tracer.Visible = false
    end
    
    -- Name ESP
    if PlayerESP.ShowName then
        local nameObj = ESPObjects[player].Name
        nameObj.Text = player.DisplayName ~= player.Name and player.DisplayName .. " (@" .. player.Name .. ")" or player.Name
        nameObj.Position = Vector2.new(rootPos.X, headPos.Y - 20)
        nameObj.Color = boxColor
        nameObj.Visible = true
    else
        ESPObjects[player].Name.Visible = false
    end
    
    -- Health ESP
    if PlayerESP.ShowHealth then
        local healthObj = ESPObjects[player].Health
        local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
        healthObj.Text = "HP: " .. math.floor(humanoid.Health) .. " (" .. healthPercent .. "%)"
        healthObj.Position = Vector2.new(rootPos.X, headPos.Y - (PlayerESP.ShowName and 35 or 20))
        healthObj.Color = Color3.fromRGB(255 - (healthPercent * 2.55), healthPercent * 2.55, 0)
        healthObj.Visible = true
    else
        ESPObjects[player].Health.Visible = false
    end
    
    -- Distance ESP
    if PlayerESP.ShowDistance then
        local distanceObj = ESPObjects[player].Distance
        distanceObj.Text = distance .. " studs"
        local yOffset = -5
        if PlayerESP.ShowName then yOffset = yOffset - 15 end
        if PlayerESP.ShowHealth then yOffset = yOffset - 15 end
        distanceObj.Position = Vector2.new(rootPos.X, headPos.Y + yOffset)
        distanceObj.Color = boxColor
        distanceObj.Visible = true
    else
        ESPObjects[player].Distance.Visible = false
    end
end

-- Main ESP loop
local function espLoop()
    if not PlayerESP.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        updateESP(player)
    end
end

-- Player management
local function onPlayerAdded(player)
    createESP(player)
end

local function onPlayerRemoving(player)
    cleanupESP(player)
end

-- Initialize ESP
function PlayerESP:Init()
    -- Clean up existing connections
    for _, connection in pairs(Connections) do
        connection:Disconnect()
    end
    Connections = {}
    
    -- Set up player connections
    Connections.PlayerAdded = Players.PlayerAdded:Connect(onPlayerAdded)
    Connections.PlayerRemoving = Players.PlayerRemoving:Connect(onPlayerRemoving)
    Connections.RenderStepped = RunService.RenderStepped:Connect(espLoop)
    
    -- Create ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end
end

-- Toggle ESP
function PlayerESP:Toggle(enabled)
    self.Enabled = enabled
    
    if not enabled then
        for _, playerESP in pairs(ESPObjects) do
            for _, obj in pairs(playerESP) do
                obj.Visible = false
            end
        end
    end
end

-- Cleanup
function PlayerESP:Destroy()
    for _, connection in pairs(Connections) do
        connection:Disconnect()
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        cleanupESP(player)
    end
    
    Connections = {}
    ESPObjects = {}
end

return PlayerESP
