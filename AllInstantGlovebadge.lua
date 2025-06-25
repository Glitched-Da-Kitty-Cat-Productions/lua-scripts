-- No Clue Who Made This But It Works ( if your the owner of this script contact me at glitched-da-kitty-cat.is-a.dev/contact so i can put your name here )
local function NetworkFunc(Name)
	for i,v in pairs(game:GetService("ReplicatedStorage")._NETWORK:GetChildren()) do
		if v:IsA("RemoteEvent") then
			v:FireServer(Name)
		end
	end
end

local GaypassGloves = {"OVERKILL", "CUSTOM", "Spectator", "Titan", "Ultra Instinct", "Acrobat"}
for i,v in pairs(game:GetService("Workspace").Lobby:GetChildren()) do
pcall(function()
if v.CFrame.Z < -18 and not table.find(GaypassGloves, v.Name) then
NetworkFunc(v.Name)
end
end)
end
NetworkFunc("potato")
