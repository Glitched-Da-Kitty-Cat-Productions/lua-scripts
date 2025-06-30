
-- Random Inventory Filler Script
-- Scans the game world and grabs random existing items/tools

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Function to scan for items in the game world
local function scanForItems()
    local foundItems = {}
    
    -- Scan workspace for tools and items
    local function scanContainer(container)
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Model") then
                table.insert(foundItems, item)
            elseif item:IsA("Folder") or item:IsA("Model") then
                scanContainer(item) -- Recursive scan
            end
        end
    end
    
    -- Scan different areas
    scanContainer(workspace)
    
    -- Also check ReplicatedStorage for items
    if game:GetService("ReplicatedStorage") then
        scanContainer(game:GetService("ReplicatedStorage"))
    end
    
    -- Check ServerStorage if accessible
    pcall(function()
        scanContainer(game:GetService("ServerStorage"))
    end)
    
    return foundItems
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ItemCountSlider = Instance.new("TextBox")
local ScanButton = Instance.new("TextButton")
local FillButton = Instance.new("TextButton")
local ClearButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local ItemsList = Instance.new("ScrollingFrame")

-- GUI Properties
ScreenGui.Name = "RandomInventoryFiller"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = MainFrame

-- Title
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Random Game Item Grabber"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

-- Item Count Input
ItemCountSlider.Name = "ItemCountSlider"
ItemCountSlider.Parent = MainFrame
ItemCountSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ItemCountSlider.BorderSizePixel = 0
ItemCountSlider.Position = UDim2.new(0.1, 0, 0, 45)
ItemCountSlider.Size = UDim2.new(0.8, 0, 0, 30)
ItemCountSlider.Font = Enum.Font.SourceSans
ItemCountSlider.PlaceholderText = "Number of items (1-50)"
ItemCountSlider.Text = "10"
ItemCountSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemCountSlider.TextSize = 14

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 4)
sliderCorner.Parent = ItemCountSlider

-- Scan Button
ScanButton.Name = "ScanButton"
ScanButton.Parent = MainFrame
ScanButton.BackgroundColor3 = Color3.fromRGB(33, 150, 243)
ScanButton.BorderSizePixel = 0
ScanButton.Position = UDim2.new(0.05, 0, 0, 85)
ScanButton.Size = UDim2.new(0.2, 0, 0, 35)
ScanButton.Font = Enum.Font.SourceSansBold
ScanButton.Text = "Scan"
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextSize = 12

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 4)
scanCorner.Parent = ScanButton

-- Fill Button
FillButton.Name = "FillButton"
FillButton.Parent = MainFrame
FillButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
FillButton.BorderSizePixel = 0
FillButton.Position = UDim2.new(0.275, 0, 0, 85)
FillButton.Size = UDim2.new(0.2, 0, 0, 35)
FillButton.Font = Enum.Font.SourceSansBold
FillButton.Text = "Grab"
FillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FillButton.TextSize = 12

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
fillCorner.Parent = FillButton

-- Clear Button
ClearButton.Name = "ClearButton"
ClearButton.Parent = MainFrame
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 152, 0)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0.5, 0, 0, 85)
ClearButton.Size = UDim2.new(0.2, 0, 0, 35)
ClearButton.Font = Enum.Font.SourceSansBold
ClearButton.Text = "Clear"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 12

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 4)
clearCorner.Parent = ClearButton

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(244, 67, 54)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.725, 0, 0, 85)
CloseButton.Size = UDim2.new(0.2, 0, 0, 35)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = CloseButton

-- Status Label
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 130)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Click 'Scan' to find items in the game world!"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Items List
ItemsList.Name = "ItemsList"
ItemsList.Parent = MainFrame
ItemsList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ItemsList.BorderSizePixel = 0
ItemsList.Position = UDim2.new(0.05, 0, 0, 155)
ItemsList.Size = UDim2.new(0.9, 0, 0, 180)
ItemsList.ScrollBarThickness = 5

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 4)
listCorner.Parent = ItemsList

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = ItemsList
listLayout.Padding = UDim.new(0, 2)

-- Global variables
local scannedItems = {}

-- Scan for items function
local function performScan()
    StatusLabel.Text = "Scanning game world for items..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 152, 0)
    
    scannedItems = scanForItems()
    
    -- Clear previous items list
    for _, child in pairs(ItemsList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Show found items
    for i, item in ipairs(scannedItems) do
        if i > 50 then break end -- Limit display
        
        local itemLabel = Instance.new("TextLabel")
        itemLabel.Size = UDim2.new(1, -10, 0, 20)
        itemLabel.BackgroundTransparency = 1
        itemLabel.Text = "• " .. item.Name .. " (" .. item.ClassName .. ")"
        itemLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        itemLabel.TextSize = 12
        itemLabel.Font = Enum.Font.SourceSans
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left
        itemLabel.Parent = ItemsList
    end
    
    StatusLabel.Text = "Found " .. #scannedItems .. " items! Click 'Grab' to get random ones."
    StatusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
end

-- Fill Inventory Function
local function fillInventory()
    if #scannedItems == 0 then
        StatusLabel.Text = "No items found! Click 'Scan' first."
        StatusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return
    end
    
    local itemCount = tonumber(ItemCountSlider.Text) or 10
    
    if itemCount <= 0 or itemCount > 50 then
        StatusLabel.Text = "Error: Item count must be between 1 and 50!"
        StatusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
        return
    end
    
    StatusLabel.Text = "Grabbing random items..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 152, 0)
    
    -- Clear previous grabbed items list
    for _, child in pairs(ItemsList:GetChildren()) do
        if child:IsA("TextLabel") and child.TextColor3 == Color3.fromRGB(255, 100, 100) then
            child:Destroy()
        end
    end
    
    local grabbedItems = {}
    
    for i = 1, itemCount do
        if #scannedItems > 0 then
            local randomIndex = math.random(1, #scannedItems)
            local randomItem = scannedItems[randomIndex]
            
            if randomItem and randomItem.Parent then
                pcall(function()
                    local clonedItem = randomItem:Clone()
                    clonedItem.Parent = LocalPlayer.Backpack
                    table.insert(grabbedItems, clonedItem.Name)
                    
                    -- Add to display list
                    local itemLabel = Instance.new("TextLabel")
                    itemLabel.Size = UDim2.new(1, -10, 0, 20)
                    itemLabel.BackgroundTransparency = 1
                    itemLabel.Text = "★ GRABBED: " .. clonedItem.Name
                    itemLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    itemLabel.TextSize = 12
                    itemLabel.Font = Enum.Font.SourceSansBold
                    itemLabel.TextXAlignment = Enum.TextXAlignment.Left
                    itemLabel.Parent = ItemsList
                end)
            end
        end
        
        wait(0.1) -- Small delay
    end
    
    StatusLabel.Text = "Successfully grabbed " .. #grabbedItems .. " random items!"
    StatusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
end

-- Clear Inventory Function
local function clearInventory()
    StatusLabel.Text = "Clearing inventory..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 152, 0)
    
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool:Destroy()
        end
    end
    
    -- Clear character tools
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
    end
    
    -- Clear grabbed items from display
    for _, child in pairs(ItemsList:GetChildren()) do
        if child:IsA("TextLabel") and child.TextColor3 == Color3.fromRGB(255, 100, 100) then
            child:Destroy()
        end
    end
    
    StatusLabel.Text = "Inventory cleared!"
    StatusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
end

-- Button Events
ScanButton.MouseButton1Click:Connect(performScan)
FillButton.MouseButton1Click:Connect(fillInventory)
ClearButton.MouseButton1Click:Connect(clearInventory)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("Random Game Item Grabber loaded!")
print("This will scan the game world and grab actual existing items!")
