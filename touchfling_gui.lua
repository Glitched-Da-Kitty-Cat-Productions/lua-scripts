local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("ScreenGui")
main.Name = "Touch Fling"
main.Parent = PlayerGui
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
Frame.BorderColor3 = Color3.fromRGB(100, 0, 150)
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 320, 0, 160)
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true
Frame.Name = "MainFrame"

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(180, 0, 255)
UIStroke.Thickness = 2
UIStroke.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 40))
}
UIGradient.Rotation = 45
UIGradient.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Frame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Touch Fling"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextWrapped = true
TitleLabel.Name = "TitleLabel"

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0, 30, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 1, -35)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Name = "CloseButton"

local toggleButton = Instance.new("TextButton")
toggleButton.Parent = Frame
toggleButton.Size = UDim2.new(0, 121, 0, 37)
toggleButton.Position = UDim2.new(0.113924049, 0, 0.418181807, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Name = "ToggleButton"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local hiddenfling = false
local flingThread 

if not ReplicatedStorage:FindFirstChild("dfgnsdrlfgjdfoigsjdroigvjesdriogjeiorgjoeirgjsieorgjsioejgiosjrgiosedjrhgiodsrjmhgbioserjgioserjgiojresiojgoi") then
	local detection = Instance.new("Decal")
	detection.Name = "dfgnsdrlfgjdfoigsjdroigvjesdriogjeiorgjoeirgjsieorgjsioejgiosjrgiosedjrhgiodsrjmhgbioserjgioserjgiojresiojgoi"
	detection.Parent = ReplicatedStorage
end

local function fling()
	local lp = Players.LocalPlayer
	local c, hrp, vel, movel = nil, nil, nil, 0.1

	while hiddenfling do
		RunService.Heartbeat:Wait()
		c = lp.Character
		hrp = c and c:FindFirstChild("HumanoidRootPart")

		if hrp then
			vel = hrp.Velocity
			hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
			RunService.RenderStepped:Wait()
			hrp.Velocity = vel
			RunService.Stepped:Wait()
			hrp.Velocity = vel + Vector3.new(0, movel, 0)
			movel = -movel
		end
	end
end

toggleButton.MouseButton1Click:Connect(function()
	hiddenfling = not hiddenfling
	toggleButton.Text = hiddenfling and "ON" or "OFF"

	if hiddenfling then
		flingThread = coroutine.create(fling)
		coroutine.resume(flingThread)
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	main:Destroy()
end)
