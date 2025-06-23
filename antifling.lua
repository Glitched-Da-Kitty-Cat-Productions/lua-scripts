local Services = setmetatable({}, {__index = function(Self, Index)
local NewService = game.GetService(game, Index)
if NewService then
Self[Index] = NewService
end
return NewService
end})
local LocalPlayer = Services.Players.LocalPlayer

local function PlayerAdded(Player)
   local Detected = false
   local Character
   local PrimaryPart
   local LastVelocity = Vector3.new(0, 0, 0)
   local LastPosition = nil
   local Cooldown = false

   local function ResetPhysicalProperties(part)
       part.CanCollide = true
       part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
       part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
       part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
   end

   local function NeutralizeFling()
       if Character then
           for _, v in ipairs(Character:GetDescendants()) do
               if v:IsA("BasePart") then
                   v.CanCollide = false
                   v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                   v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                   v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
               end
           end
           if PrimaryPart then
               PrimaryPart.CanCollide = false
               PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
               PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
               PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
               if LastPosition then
                   PrimaryPart.CFrame = LastPosition
               end
           end
       end
   end

   local function CharacterAdded(NewCharacter)
       Character = NewCharacter
       repeat
           wait()
           PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
       until PrimaryPart
       Detected = false
       LastVelocity = Vector3.new(0, 0, 0)
       LastPosition = PrimaryPart.CFrame
       Cooldown = false
   end

   CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
   Player.CharacterAdded:Connect(CharacterAdded)

   Services.RunService.Heartbeat:Connect(function()
       if (Character and Character:IsDescendantOf(workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
           local currentVelocity = PrimaryPart.AssemblyLinearVelocity
           local velocityChange = (currentVelocity - LastVelocity).Magnitude
           local velocityMagnitude = currentVelocity.Magnitude
           local angularVelocityMagnitude = PrimaryPart.AssemblyAngularVelocity.Magnitude

           local linearThreshold = 100 + (LastVelocity.Magnitude * 0.5)
           local angularThreshold = 50 + (PrimaryPart.AssemblyAngularVelocity.Magnitude * 0.5)

           if not Cooldown and (velocityMagnitude > linearThreshold or angularVelocityMagnitude > angularThreshold or velocityChange > 75) then
               if Detected == false then
                   game.StarterGui:SetCore("ChatMakeSystemMessage", {
                       Text = "Fling Exploit detected, Player: " .. tostring(Player);
                       Color = Color3.fromRGB(255, 200, 0);
                   })
               end
               Detected = true
               Cooldown = true
               NeutralizeFling()
               wait(2)
               Cooldown = false
           else
               LastPosition = PrimaryPart.CFrame
               LastVelocity = currentVelocity
               if Detected then
                   for _, v in ipairs(Character:GetDescendants()) do
                       if v:IsA("BasePart") then
                           ResetPhysicalProperties(v)
                       end
                   end
                   Detected = false
               end
           end
       end
   end)
end

for i,v in ipairs(Services.Players:GetPlayers()) do
   if v ~= LocalPlayer then
       PlayerAdded(v)
   end
end
Services.Players.PlayerAdded:Connect(PlayerAdded)

local LastPosition = nil
Services.RunService.Heartbeat:Connect(function()
   pcall(function()
       local PrimaryPart = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
       if PrimaryPart then
           local currentVelocity = PrimaryPart.AssemblyLinearVelocity
           local velocityChange = (currentVelocity - (LastVelocity or Vector3.new(0,0,0))).Magnitude
           local velocityMagnitude = currentVelocity.Magnitude
           local angularVelocityMagnitude = PrimaryPart.AssemblyAngularVelocity.Magnitude

           local linearThreshold = 250
           local angularThreshold = 250

           if velocityMagnitude > linearThreshold or angularVelocityMagnitude > angularThreshold or velocityChange > 150 then
               PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
               PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
               if LastPosition then
                   PrimaryPart.CFrame = LastPosition
               end

               game.StarterGui:SetCore("ChatMakeSystemMessage", {
                   Text = "You were flung. Neutralizing velocity.";
                   Color = Color3.fromRGB(255, 0, 0);
               })
           elseif velocityMagnitude < 50 or angularVelocityMagnitude < 50 then
               LastPosition = PrimaryPart.CFrame
           end

           LastVelocity = currentVelocity
       end
   end)
end)
