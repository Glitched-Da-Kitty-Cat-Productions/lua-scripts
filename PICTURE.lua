
-- Advanced Image Display System
-- Displays images from URLs on all players' screens

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local ImageDisplay = {}
ImageDisplay.Enabled = false
ImageDisplay.CurrentImage = nil
ImageDisplay.ImageSize = UDim2.new(0, 400, 0, 300)
ImageDisplay.ImagePosition = UDim2.new(0.5, -200, 0.5, -150)
ImageDisplay.FadeTime = 0.5
ImageDisplay.DisplayTime = 5
ImageDisplay.ImageHistory = {}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local UrlInput = Instance.new("TextBox")
local DisplayButton = Instance.new("TextButton")
local ClearButton = Instance.new("TextButton")
local SizeSlider = Instance.new("TextLabel")
local SizeInput = Instance.new("TextBox")
local TimeSlider = Instance.new("TextLabel")
local TimeInput = Instance.new("TextBox")
local PreviewFrame = Instance.new("Frame")
local PreviewImage = Instance.new("ImageLabel")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "ImageDisplayGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 100, 120)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🖼️ Image Display System"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

-- URL Input
UrlInput.Name = "UrlInput"
UrlInput.Parent = MainFrame
UrlInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
UrlInput.BorderSizePixel = 0
UrlInput.Position = UDim2.new(0, 10, 0, 45)
UrlInput.Size = UDim2.new(1, -20, 0, 35)
UrlInput.Font = Enum.Font.Gotham
UrlInput.PlaceholderText = "Enter image URL (PNG, JPG, GIF)..."
UrlInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
UrlInput.Text = ""
UrlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UrlInput.TextSize = 12
UrlInput.TextWrapped = true

local UrlCorner = Instance.new("UICorner")
UrlCorner.CornerRadius = UDim.new(0, 6)
UrlCorner.Parent = UrlInput

-- Display Button
DisplayButton.Name = "DisplayButton"
DisplayButton.Parent = MainFrame
DisplayButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
DisplayButton.BorderSizePixel = 0
DisplayButton.Position = UDim2.new(0, 10, 0, 90)
DisplayButton.Size = UDim2.new(0.48, -5, 0, 35)
DisplayButton.Font = Enum.Font.GothamBold
DisplayButton.Text = "Display Image"
DisplayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayButton.TextSize = 12

local DisplayCorner = Instance.new("UICorner")
DisplayCorner.CornerRadius = UDim.new(0, 6)
DisplayCorner.Parent = DisplayButton

-- Clear Button
ClearButton.Name = "ClearButton"
ClearButton.Parent = MainFrame
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0.52, 5, 0, 90)
ClearButton.Size = UDim2.new(0.48, -5, 0, 35)
ClearButton.Font = Enum.Font.GothamBold
ClearButton.Text = "Clear All"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 12

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

-- Size Controls
SizeSlider.Name = "SizeSlider"
SizeSlider.Parent = MainFrame
SizeSlider.BackgroundTransparency = 1
SizeSlider.Position = UDim2.new(0, 10, 0, 135)
SizeSlider.Size = UDim2.new(0.6, 0, 0, 20)
SizeSlider.Font = Enum.Font.Gotham
SizeSlider.Text = "Image Size:"
SizeSlider.TextColor3 = Color3.fromRGB(200, 200, 200)
SizeSlider.TextSize = 11
SizeSlider.TextXAlignment = Enum.TextXAlignment.Left

SizeInput.Name = "SizeInput"
SizeInput.Parent = MainFrame
SizeInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SizeInput.BorderSizePixel = 0
SizeInput.Position = UDim2.new(0.65, 0, 0, 135)
SizeInput.Size = UDim2.new(0.3, -10, 0, 20)
SizeInput.Font = Enum.Font.Gotham
SizeInput.Text = "400"
SizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeInput.TextSize = 10

local SizeCorner = Instance.new("UICorner")
SizeCorner.CornerRadius = UDim.new(0, 4)
SizeCorner.Parent = SizeInput

-- Time Controls
TimeSlider.Name = "TimeSlider"
TimeSlider.Parent = MainFrame
TimeSlider.BackgroundTransparency = 1
TimeSlider.Position = UDim2.new(0, 10, 0, 165)
TimeSlider.Size = UDim2.new(0.6, 0, 0, 20)
TimeSlider.Font = Enum.Font.Gotham
TimeSlider.Text = "Display Time (seconds):"
TimeSlider.TextColor3 = Color3.fromRGB(200, 200, 200)
TimeSlider.TextSize = 11
TimeSlider.TextXAlignment = Enum.TextXAlignment.Left

TimeInput.Name = "TimeInput"
TimeInput.Parent = MainFrame
TimeInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TimeInput.BorderSizePixel = 0
TimeInput.Position = UDim2.new(0.65, 0, 0, 165)
TimeInput.Size = UDim2.new(0.3, -10, 0, 20)
TimeInput.Font = Enum.Font.Gotham
TimeInput.Text = "5"
TimeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeInput.TextSize = 10

local TimeCorner = Instance.new("UICorner")
TimeCorner.CornerRadius = UDim.new(0, 4)
TimeCorner.Parent = TimeInput

-- Preview Frame
PreviewFrame.Name = "PreviewFrame"
PreviewFrame.Parent = MainFrame
PreviewFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
PreviewFrame.BorderSizePixel = 0
PreviewFrame.Position = UDim2.new(0, 10, 0, 195)
PreviewFrame.Size = UDim2.new(1, -20, 0, 200)

local PreviewCorner = Instance.new("UICorner")
PreviewCorner.CornerRadius = UDim.new(0, 8)
PreviewCorner.Parent = PreviewFrame

PreviewImage.Name = "PreviewImage"
PreviewImage.Parent = PreviewFrame
PreviewImage.BackgroundTransparency = 1
PreviewImage.Position = UDim2.new(0, 5, 0, 5)
PreviewImage.Size = UDim2.new(1, -10, 1, -10)
PreviewImage.Image = ""
PreviewImage.ScaleType = Enum.ScaleType.Fit

-- Status Label
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 405)
StatusLabel.Size = UDim2.new(1, -20, 0, 35)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Ready to display images"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 10
StatusLabel.TextWrapped = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Core Functions
local function validateImageUrl(url)
    if not url or url == "" then
        return false, "URL cannot be empty"
    end
    
    -- Check if URL contains image extensions
    local validExtensions = {".png", ".jpg", ".jpeg", ".gif", ".webp"}
    local hasValidExtension = false
    
    for _, ext in pairs(validExtensions) do
        if url:lower():find(ext) then
            hasValidExtension = true
            break
        end
    end
    
    -- Also accept Roblox asset URLs
    if url:find("rbxasset://") or url:find("rbxassetid://") or url:find("http://www.roblox.com/asset/") then
        hasValidExtension = true
    end
    
    if not hasValidExtension then
        return false, "URL must contain a valid image extension or be a Roblox asset"
    end
    
    return true, "Valid URL"
end

local function createImageDisplay(imageUrl, size, duration)
    -- Create display for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player.PlayerGui then
            local playerDisplay = Instance.new("ScreenGui")
            playerDisplay.Name = "GlobalImageDisplay"
            playerDisplay.Parent = player.PlayerGui
            playerDisplay.ResetOnSpawn = false
            
            local imageFrame = Instance.new("Frame")
            imageFrame.Name = "ImageFrame"
            imageFrame.Parent = playerDisplay
            imageFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            imageFrame.BackgroundTransparency = 0.3
            imageFrame.BorderSizePixel = 0
            imageFrame.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
            imageFrame.Size = UDim2.new(0, size, 0, size)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 12)
            frameCorner.Parent = imageFrame
            
            local closeButton = Instance.new("TextButton")
            closeButton.Name = "CloseButton"
            closeButton.Parent = imageFrame
            closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            closeButton.BorderSizePixel = 0
            closeButton.Position = UDim2.new(1, -30, 0, 5)
            closeButton.Size = UDim2.new(0, 25, 0, 25)
            closeButton.Font = Enum.Font.GothamBold
            closeButton.Text = "✕"
            closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.TextSize = 14
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(0, 6)
            closeCorner.Parent = closeButton
            
            local displayImage = Instance.new("ImageLabel")
            displayImage.Name = "DisplayImage"
            displayImage.Parent = imageFrame
            displayImage.BackgroundTransparency = 1
            displayImage.Position = UDim2.new(0, 10, 0, 10)
            displayImage.Size = UDim2.new(1, -20, 1, -20)
            displayImage.Image = imageUrl
            displayImage.ScaleType = Enum.ScaleType.Fit
            
            -- Fade in animation
            imageFrame.BackgroundTransparency = 1
            displayImage.ImageTransparency = 1
            closeButton.BackgroundTransparency = 1
            closeButton.TextTransparency = 1
            
            local fadeIn = TweenService:Create(imageFrame, 
                TweenInfo.new(ImageDisplay.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0.3}
            )
            
            local fadeInImage = TweenService:Create(displayImage, 
                TweenInfo.new(ImageDisplay.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {ImageTransparency = 0}
            )
            
            local fadeInButton = TweenService:Create(closeButton, 
                TweenInfo.new(ImageDisplay.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0, TextTransparency = 0}
            )
            
            fadeIn:Play()
            fadeInImage:Play()
            fadeInButton:Play()
            
            -- Close button functionality
            closeButton.MouseButton1Click:Connect(function()
                local fadeOut = TweenService:Create(playerDisplay, 
                    TweenInfo.new(ImageDisplay.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {BackgroundTransparency = 1}
                )
                fadeOut:Play()
                fadeOut.Completed:Connect(function()
                    playerDisplay:Destroy()
                end)
            end)
            
            -- Auto-remove after duration
            task.spawn(function()
                task.wait(duration)
                if playerDisplay and playerDisplay.Parent then
                    local fadeOut = TweenService:Create(playerDisplay, 
                        TweenInfo.new(ImageDisplay.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                        {BackgroundTransparency = 1}
                    )
                    fadeOut:Play()
                    fadeOut.Completed:Connect(function()
                        playerDisplay:Destroy()
                    end)
                end
            end)
        end
    end
end

local function clearAllDisplays()
    for _, player in pairs(Players:GetPlayers()) do
        if player.PlayerGui then
            local existingDisplay = player.PlayerGui:FindFirstChild("GlobalImageDisplay")
            if existingDisplay then
                existingDisplay:Destroy()
            end
        end
    end
end

-- Event Connections
DisplayButton.MouseButton1Click:Connect(function()
    local url = UrlInput.Text:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
    local size = tonumber(SizeInput.Text) or 400
    local duration = tonumber(TimeInput.Text) or 5
    
    -- Validate inputs
    if size < 100 then size = 100 end
    if size > 800 then size = 800 end
    if duration < 1 then duration = 1 end
    if duration > 60 then duration = 60 end
    
    local isValid, message = validateImageUrl(url)
    
    if isValid then
        StatusLabel.Text = "Displaying image to all players..."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Update preview
        PreviewImage.Image = url
        
        -- Display to all players
        createImageDisplay(url, size, duration)
        
        -- Add to history
        table.insert(ImageDisplay.ImageHistory, {
            url = url,
            size = size,
            duration = duration,
            time = os.date("%H:%M:%S")
        })
        
        -- Keep only last 10 entries
        if #ImageDisplay.ImageHistory > 10 then
            table.remove(ImageDisplay.ImageHistory, 1)
        end
        
        task.wait(2)
        StatusLabel.Text = "Image displayed successfully!"
        
    else
        StatusLabel.Text = "Error: " .. message
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    clearAllDisplays()
    StatusLabel.Text = "All displays cleared"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    task.wait(2)
    StatusLabel.Text = "Ready to display images"
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- Update preview when URL changes
UrlInput:GetPropertyChangedSignal("Text"):Connect(function()
    local url = UrlInput.Text
    if validateImageUrl(url) then
        PreviewImage.Image = url
    end
end)

-- Update size when input changes
SizeInput:GetPropertyChangedSignal("Text"):Connect(function()
    local size = tonumber(SizeInput.Text)
    if size and size >= 100 and size <= 800 then
        ImageDisplay.ImageSize = UDim2.new(0, size, 0, size)
    end
end)

-- Update duration when input changes
TimeInput:GetPropertyChangedSignal("Text"):Connect(function()
    local time = tonumber(TimeInput.Text)
    if time and time >= 1 and time <= 60 then
        ImageDisplay.DisplayTime = time
    end
end)

print("Advanced Image Display System loaded!")
print("Display images to all players with custom sizes and durations!")

return ImageDisplay
