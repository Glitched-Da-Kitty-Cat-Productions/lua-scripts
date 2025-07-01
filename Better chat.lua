
-- Enhanced Chat System
-- 10000x better than default Roblox chat with modern features

local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local EnhancedChat = {}
EnhancedChat.Messages = {}
EnhancedChat.Enabled = true
EnhancedChat.MaxMessages = 100
EnhancedChat.ChatFilters = {
    profanity = true,
    spam = true,
    caps = true
}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ChatFrame = Instance.new("ScrollingFrame")
local InputFrame = Instance.new("Frame")
local ChatInput = Instance.new("TextBox")
local SendButton = Instance.new("TextButton")
local SettingsButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "EnhancedChatGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0.5, -200)
MainFrame.Size = UDim2.new(0, 400, 0, 400)
MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 100, 120)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Chat Frame
ChatFrame.Name = "ChatFrame"
ChatFrame.Parent = MainFrame
ChatFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ChatFrame.BorderSizePixel = 0
ChatFrame.Position = UDim2.new(0, 10, 0, 10)
ChatFrame.Size = UDim2.new(1, -20, 1, -60)
ChatFrame.ScrollBarThickness = 6
ChatFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ChatFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ChatCorner = Instance.new("UICorner")
ChatCorner.CornerRadius = UDim.new(0, 8)
ChatCorner.Parent = ChatFrame

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.Parent = ChatFrame
ChatLayout.Padding = UDim.new(0, 5)
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ChatPadding = Instance.new("UIPadding")
ChatPadding.Parent = ChatFrame
ChatPadding.PaddingTop = UDim.new(0, 8)
ChatPadding.PaddingBottom = UDim.new(0, 8)
ChatPadding.PaddingLeft = UDim.new(0, 8)
ChatPadding.PaddingRight = UDim.new(0, 8)

-- Input Frame
InputFrame.Name = "InputFrame"
InputFrame.Parent = MainFrame
InputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
InputFrame.BorderSizePixel = 0
InputFrame.Position = UDim2.new(0, 10, 1, -45)
InputFrame.Size = UDim2.new(1, -20, 0, 35)

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputFrame

-- Chat Input
ChatInput.Name = "ChatInput"
ChatInput.Parent = InputFrame
ChatInput.BackgroundTransparency = 1
ChatInput.Position = UDim2.new(0, 10, 0, 0)
ChatInput.Size = UDim2.new(1, -90, 1, 0)
ChatInput.Font = Enum.Font.Gotham
ChatInput.PlaceholderText = "Type your message..."
ChatInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
ChatInput.Text = ""
ChatInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatInput.TextSize = 14
ChatInput.TextXAlignment = Enum.TextXAlignment.Left

-- Send Button
SendButton.Name = "SendButton"
SendButton.Parent = InputFrame
SendButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
SendButton.BorderSizePixel = 0
SendButton.Position = UDim2.new(1, -75, 0, 5)
SendButton.Size = UDim2.new(0, 65, 0, 25)
SendButton.Font = Enum.Font.GothamBold
SendButton.Text = "Send"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.TextSize = 12

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 6)
SendCorner.Parent = SendButton

-- Toggle Button
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 10, 0.5, -220)
ToggleButton.Size = UDim2.new(0, 80, 0, 25)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Chat"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

-- Settings Button
SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = MainFrame
SettingsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SettingsButton.BorderSizePixel = 0
SettingsButton.Position = UDim2.new(1, -30, 0, 5)
SettingsButton.Size = UDim2.new(0, 25, 0, 25)
SettingsButton.Font = Enum.Font.GothamBold
SettingsButton.Text = "⚙"
SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsButton.TextSize = 14

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 6)
SettingsCorner.Parent = SettingsButton

-- Utility Functions
local function filterMessage(message)
    local filtered = message
    
    -- Anti-caps filter
    if EnhancedChat.ChatFilters.caps then
        local upperCount = 0
        for i = 1, #message do
            if message:sub(i,i):match("%u") then
                upperCount = upperCount + 1
            end
        end
        if upperCount > #message * 0.7 and #message > 5 then
            filtered = filtered:lower()
            filtered = filtered:sub(1,1):upper() .. filtered:sub(2)
        end
    end
    
    -- Basic profanity filter
    if EnhancedChat.ChatFilters.profanity then
        local badWords = {"noob", "ez", "trash", "bad"} -- Add more as needed
        for _, word in pairs(badWords) do
            filtered = filtered:gsub(word:lower(), string.rep("*", #word))
            filtered = filtered:gsub(word:upper(), string.rep("*", #word))
        end
    end
    
    return filtered
end

local function getPlayerColor(player)
    local colors = {
        Color3.fromRGB(255, 100, 100), -- Red
        Color3.fromRGB(100, 255, 100), -- Green
        Color3.fromRGB(100, 100, 255), -- Blue
        Color3.fromRGB(255, 255, 100), -- Yellow
        Color3.fromRGB(255, 100, 255), -- Magenta
        Color3.fromRGB(100, 255, 255), -- Cyan
        Color3.fromRGB(255, 200, 100), -- Orange
        Color3.fromRGB(200, 100, 255)  -- Purple
    }
    
    local hash = 0
    for i = 1, #player.Name do
        hash = hash + string.byte(player.Name, i)
    end
    
    return colors[(hash % #colors) + 1]
end

local function createMessageFrame(player, message, isSystem)
    local MessageFrame = Instance.new("Frame")
    local PlayerLabel = Instance.new("TextLabel")
    local MessageLabel = Instance.new("TextLabel")
    local TimeLabel = Instance.new("TextLabel")
    
    MessageFrame.Name = "MessageFrame"
    MessageFrame.Parent = ChatFrame
    MessageFrame.BackgroundColor3 = isSystem and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(25, 25, 35)
    MessageFrame.BorderSizePixel = 0
    MessageFrame.Size = UDim2.new(1, -16, 0, 0)
    MessageFrame.AutomaticSize = Enum.AutomaticSize.Y
    MessageFrame.LayoutOrder = #EnhancedChat.Messages
    
    local MessageCorner = Instance.new("UICorner")
    MessageCorner.CornerRadius = UDim.new(0, 6)
    MessageCorner.Parent = MessageFrame
    
    local MessagePadding = Instance.new("UIPadding")
    MessagePadding.Parent = MessageFrame
    MessagePadding.PaddingTop = UDim.new(0, 5)
    MessagePadding.PaddingBottom = UDim.new(0, 5)
    MessagePadding.PaddingLeft = UDim.new(0, 8)
    MessagePadding.PaddingRight = UDim.new(0, 8)
    
    local MessageLayout = Instance.new("UIListLayout")
    MessageLayout.Parent = MessageFrame
    MessageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Time Label
    TimeLabel.Name = "TimeLabel"
    TimeLabel.Parent = MessageFrame
    TimeLabel.BackgroundTransparency = 1
    TimeLabel.Size = UDim2.new(1, 0, 0, 15)
    TimeLabel.Font = Enum.Font.Code
    TimeLabel.Text = os.date("[%H:%M:%S]")
    TimeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    TimeLabel.TextSize = 10
    TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    TimeLabel.LayoutOrder = 1
    
    if not isSystem then
        -- Player Label
        PlayerLabel.Name = "PlayerLabel"
        PlayerLabel.Parent = MessageFrame
        PlayerLabel.BackgroundTransparency = 1
        PlayerLabel.Size = UDim2.new(1, 0, 0, 20)
        PlayerLabel.Font = Enum.Font.GothamBold
        PlayerLabel.Text = player.Name .. ":"
        PlayerLabel.TextColor3 = getPlayerColor(player)
        PlayerLabel.TextSize = 14
        PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
        PlayerLabel.LayoutOrder = 2
    end
    
    -- Message Label
    MessageLabel.Name = "MessageLabel"
    MessageLabel.Parent = MessageFrame
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Size = UDim2.new(1, 0, 0, 0)
    MessageLabel.AutomaticSize = Enum.AutomaticSize.Y
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = message
    MessageLabel.TextColor3 = isSystem and Color3.fromRGB(255, 255, 100) or Color3.fromRGB(255, 255, 255)
    MessageLabel.TextSize = 13
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.LayoutOrder = isSystem and 2 or 3
    
    -- Smooth entrance animation
    MessageFrame.Size = UDim2.new(1, -16, 0, 0)
    MessageFrame.BackgroundTransparency = 1
    
    local tween = TweenService:Create(MessageFrame, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    )
    tween:Play()
    
    -- Auto-scroll to bottom
    task.wait(0.1)
    ChatFrame.CanvasPosition = Vector2.new(0, ChatFrame.AbsoluteCanvasSize.Y)
    
    return MessageFrame
end

local function addMessage(player, message, isSystem)
    local filteredMessage = isSystem and message or filterMessage(message)
    
    table.insert(EnhancedChat.Messages, {
        player = player,
        message = filteredMessage,
        time = tick(),
        isSystem = isSystem or false
    })
    
    createMessageFrame(player, filteredMessage, isSystem or false)
    
    -- Remove old messages
    if #EnhancedChat.Messages > EnhancedChat.MaxMessages then
        table.remove(EnhancedChat.Messages, 1)
        local firstChild = ChatFrame:GetChildren()[2] -- Skip UIListLayout
        if firstChild then
            firstChild:Destroy()
        end
    end
end

local function sendMessage()
    local message = ChatInput.Text:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
    if message == "" then return end
    
    ChatInput.Text = ""
    
    -- Handle commands
    if message:sub(1, 1) == "/" then
        local command = message:sub(2):lower()
        if command == "clear" then
            for _, child in pairs(ChatFrame:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
            EnhancedChat.Messages = {}
            addMessage(LocalPlayer, "Chat cleared.", true)
            return
        elseif command == "help" then
            addMessage(LocalPlayer, "Commands: /clear, /help, /filter [on/off]", true)
            return
        elseif command:find("filter") then
            local setting = command:match("filter (%w+)")
            if setting == "on" then
                EnhancedChat.ChatFilters.profanity = true
                EnhancedChat.ChatFilters.caps = true
                addMessage(LocalPlayer, "Chat filters enabled.", true)
            elseif setting == "off" then
                EnhancedChat.ChatFilters.profanity = false
                EnhancedChat.ChatFilters.caps = false
                addMessage(LocalPlayer, "Chat filters disabled.", true)
            else
                addMessage(LocalPlayer, "Usage: /filter on/off", true)
            end
            return
        end
    end
    
    -- Send message to other players (if in a supported game)
    pcall(function()
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
    end)
    
    -- Add to our enhanced chat
    addMessage(LocalPlayer, message, false)
end

-- Event Connections
SendButton.MouseButton1Click:Connect(sendMessage)

ChatInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendMessage()
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "Hide" or "Chat"
end)

-- Listen for other players' messages
pcall(function()
    local chatEvents = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
    local onMessageDoneFiltering = chatEvents:WaitForChild("OnMessageDoneFiltering")
    
    onMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
        if messageData.FromSpeaker ~= LocalPlayer.Name then
            local speaker = Players:FindFirstChild(messageData.FromSpeaker)
            if speaker then
                addMessage(speaker, messageData.Message, false)
            end
        end
    end)
end)

-- Player join/leave notifications
Players.PlayerAdded:Connect(function(player)
    addMessage(player, player.Name .. " joined the game!", true)
end)

Players.PlayerRemoving:Connect(function(player)
    addMessage(player, player.Name .. " left the game!", true)
end)

-- Hide default chat
pcall(function()
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = "Enhanced Chat loaded! Default chat disabled.";
        Color = Color3.fromRGB(100, 255, 100);
        Font = Enum.Font.GothamBold;
        FontSize = Enum.FontSize.Size18;
    })
    
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
end)

-- Welcome message
addMessage(LocalPlayer, "Enhanced Chat System loaded! Type /help for commands.", true)

return EnhancedChat
