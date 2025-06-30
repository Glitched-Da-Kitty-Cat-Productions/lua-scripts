
-- Chat Bypass Script
-- Bypasses Roblox chat filters using various techniques

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Chat bypass methods
local BypassMethods = {
    -- Character substitution
    CharSubstitution = {
        ["a"] = {"а", "ɑ", "α", "à", "á", "â", "ã", "ä", "å"},
        ["e"] = {"е", "ε", "è", "é", "ê", "ë"},
        ["i"] = {"і", "ι", "ì", "í", "î", "ï"},
        ["o"] = {"о", "ο", "ò", "ó", "ô", "õ", "ö"},
        ["u"] = {"υ", "ù", "ú", "û", "ü"},
        ["s"] = {"ѕ", "ş", "š"},
        ["c"] = {"с", "ç", "č"},
        ["p"] = {"р"},
        ["h"] = {"һ"},
        ["x"] = {"х"},
        ["y"] = {"у"},
        ["n"] = {"ñ", "ň"},
        ["l"] = {"ł"},
        ["z"] = {"ž", "ź", "ż"}
    },
    
    -- Zero-width characters
    ZeroWidth = {
        "\u200B", -- Zero Width Space
        "\u200C", -- Zero Width Non-Joiner
        "\u200D", -- Zero Width Joiner
        "\u2060", -- Word Joiner
        "\uFEFF"  -- Zero Width No-Break Space
    },
    
    -- Unicode variations
    UnicodeVariations = {
        ["fuck"] = {"fųck", "fưck", "fủck", "fůck", "fŭck"},
        ["shit"] = {"shịt", "shít", "shįt", "shīt", "shĩt"},
        ["damn"] = {"dạmn", "dámn", "dãmn", "dămn", "dāmn"},
        ["ass"] = {"ạss", "áss", "ăss", "āss", "ãss"},
        ["bitch"] = {"bịtch", "bítch", "bĩtch", "bīch", "bįtch"},
        ["hell"] = {"hęll", "héll", "hëll", "hēll", "hẽll"}
    }
}

-- Function to apply character substitution
local function applyCharSubstitution(text)
    local result = text:lower()
    for char, substitutes in pairs(BypassMethods.CharSubstitution) do
        if result:find(char) then
            local substitute = substitutes[math.random(1, #substitutes)]
            result = result:gsub(char, substitute)
        end
    end
    return result
end

-- Function to add zero-width characters
local function addZeroWidthChars(text)
    local result = ""
    local zeroWidthChars = BypassMethods.ZeroWidth
    
    for i = 1, #text do
        result = result .. text:sub(i, i)
        if math.random(1, 3) == 1 then -- 33% chance to add zero-width char
            result = result .. zeroWidthChars[math.random(1, #zeroWidthChars)]
        end
    end
    
    return result
end

-- Function to apply unicode variations
local function applyUnicodeVariations(text)
    local result = text:lower()
    
    for word, variations in pairs(BypassMethods.UnicodeVariations) do
        if result:find(word) then
            local variation = variations[math.random(1, #variations)]
            result = result:gsub(word, variation)
        end
    end
    
    return result
end

-- Function to add spacing
local function addSpacing(text)
    local result = ""
    for i = 1, #text do
        result = result .. text:sub(i, i)
        if i < #text and math.random(1, 4) == 1 then -- 25% chance to add space
            result = result .. " "
        end
    end
    return result
end

-- Function to reverse text (for leetspeak)
local function leetSpeak(text)
    local leetMap = {
        ["a"] = "4", ["e"] = "3", ["i"] = "1", ["o"] = "0",
        ["s"] = "5", ["t"] = "7", ["l"] = "1", ["g"] = "9"
    }
    
    local result = text:lower()
    for letter, number in pairs(leetMap) do
        if math.random(1, 2) == 1 then -- 50% chance to convert
            result = result:gsub(letter, number)
        end
    end
    
    return result
end

-- Main bypass function
local function bypassText(text, method)
    method = method or "random"
    
    if method == "char_sub" or method == "random" then
        text = applyCharSubstitution(text)
    end
    
    if method == "zero_width" or method == "random" then
        text = addZeroWidthChars(text)
    end
    
    if method == "unicode" or method == "random" then
        text = applyUnicodeVariations(text)
    end
    
    if method == "spacing" or method == "random" then
        text = addSpacing(text)
    end
    
    if method == "leet" or method == "random" then
        text = leetSpeak(text)
    end
    
    return text
end

-- Send bypassed message function
local function sendBypassedMessage(message, method)
    local bypassedMessage = bypassText(message, method)
    
    -- Try different chat methods
    local success = false
    
    -- Method 1: TextChatService (new chat)
    if TextChatService and TextChatService.TextChannels then
        pcall(function()
            local channel = TextChatService.TextChannels.RBXGeneral
            if channel then
                channel:SendAsync(bypassedMessage)
                success = true
            end
        end)
    end
    
    -- Method 2: Legacy chat
    if not success then
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(bypassedMessage, "All")
            success = true
        end)
    end
    
    -- Method 3: Alternative chat method
    if not success then
        pcall(function()
            local chatRemote = ReplicatedStorage:FindFirstChild("SayMessageRequest")
            if chatRemote then
                chatRemote:FireServer(bypassedMessage, "All")
                success = true
            end
        end)
    end
    
    return success, bypassedMessage
end

-- Create GUI
local function createBypassGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ChatBypassGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 400, 0, 200)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- Corner rounding
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Chat Bypass Tool"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    
    -- Message TextBox
    local MessageBox = Instance.new("TextBox")
    MessageBox.Name = "MessageBox"
    MessageBox.Parent = MainFrame
    MessageBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MessageBox.BorderSizePixel = 0
    MessageBox.Position = UDim2.new(0.05, 0, 0.2, 0)
    MessageBox.Size = UDim2.new(0.9, 0, 0, 30)
    MessageBox.Font = Enum.Font.SourceSans
    MessageBox.PlaceholderText = "Enter your message here..."
    MessageBox.Text = ""
    MessageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    MessageBox.TextSize = 14
    MessageBox.TextXAlignment = Enum.TextXAlignment.Left
    
    local MessageCorner = Instance.new("UICorner")
    MessageCorner.CornerRadius = UDim.new(0, 5)
    MessageCorner.Parent = MessageBox
    
    -- Method Dropdown
    local MethodLabel = Instance.new("TextLabel")
    MethodLabel.Name = "MethodLabel"
    MethodLabel.Parent = MainFrame
    MethodLabel.BackgroundTransparency = 1
    MethodLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
    MethodLabel.Size = UDim2.new(0.4, 0, 0, 20)
    MethodLabel.Font = Enum.Font.SourceSans
    MethodLabel.Text = "Bypass Method:"
    MethodLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MethodLabel.TextSize = 14
    MethodLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local MethodDropdown = Instance.new("TextButton")
    MethodDropdown.Name = "MethodDropdown"
    MethodDropdown.Parent = MainFrame
    MethodDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MethodDropdown.BorderSizePixel = 0
    MethodDropdown.Position = UDim2.new(0.5, 0, 0.43, 0)
    MethodDropdown.Size = UDim2.new(0.45, 0, 0, 25)
    MethodDropdown.Font = Enum.Font.SourceSans
    MethodDropdown.Text = "Random"
    MethodDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    MethodDropdown.TextSize = 12
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 5)
    DropdownCorner.Parent = MethodDropdown
    
    -- Send Button
    local SendButton = Instance.new("TextButton")
    SendButton.Name = "SendButton"
    SendButton.Parent = MainFrame
    SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    SendButton.BorderSizePixel = 0
    SendButton.Position = UDim2.new(0.05, 0, 0.7, 0)
    SendButton.Size = UDim2.new(0.4, 0, 0, 35)
    SendButton.Font = Enum.Font.SourceSansBold
    SendButton.Text = "Send Bypassed"
    SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SendButton.TextSize = 14
    
    local SendCorner = Instance.new("UICorner")
    SendCorner.CornerRadius = UDim.new(0, 5)
    SendCorner.Parent = SendButton
    
    -- Preview Button
    local PreviewButton = Instance.new("TextButton")
    PreviewButton.Name = "PreviewButton"
    PreviewButton.Parent = MainFrame
    PreviewButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    PreviewButton.BorderSizePixel = 0
    PreviewButton.Position = UDim2.new(0.55, 0, 0.7, 0)
    PreviewButton.Size = UDim2.new(0.4, 0, 0, 35)
    PreviewButton.Font = Enum.Font.SourceSans
    PreviewButton.Text = "Preview"
    PreviewButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PreviewButton.TextSize = 14
    
    local PreviewCorner = Instance.new("UICorner")
    PreviewCorner.CornerRadius = UDim.new(0, 5)
    PreviewCorner.Parent = PreviewButton
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = MainFrame
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(0.9, 0, 0, 5)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 12
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton
    
    -- Methods
    local methods = {"random", "char_sub", "unicode", "zero_width", "spacing", "leet"}
    local currentMethodIndex = 1
    
    -- Method dropdown functionality
    MethodDropdown.MouseButton1Click:Connect(function()
        currentMethodIndex = currentMethodIndex + 1
        if currentMethodIndex > #methods then
            currentMethodIndex = 1
        end
        MethodDropdown.Text = methods[currentMethodIndex]:gsub("_", " "):gsub("^%l", string.upper)
    end)
    
    -- Send button functionality
    SendButton.MouseButton1Click:Connect(function()
        local message = MessageBox.Text
        if message and message ~= "" then
            local success, bypassedMessage = sendBypassedMessage(message, methods[currentMethodIndex])
            if success then
                MessageBox.Text = ""
                print("Sent bypassed message: " .. bypassedMessage)
            else
                warn("Failed to send message")
            end
        end
    end)
    
    -- Preview button functionality
    PreviewButton.MouseButton1Click:Connect(function()
        local message = MessageBox.Text
        if message and message ~= "" then
            local bypassedMessage = bypassText(message, methods[currentMethodIndex])
            print("Preview: " .. bypassedMessage)
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Enter key to send
    MessageBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SendButton.MouseButton1Click:Fire()
        end
    end)
    
    return ScreenGui
end

-- Initialize
local gui = createBypassGUI()

-- Notification
local function notify(title, content)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = content,
        Duration = 3
    })
end

notify("Chat Bypass", "Chat bypass tool loaded! Use the GUI to send bypassed messages.")
