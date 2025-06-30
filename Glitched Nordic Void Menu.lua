if not game then
    error("This script must be run in a Roblox environment.")
end

local success, Airflow = pcall(function()
    return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/4lpaca-pin/Airflow/refs/heads/main/src/source.luau"))()
end)

if not success or not Airflow then
    error("Failed to load Airflow UI library. Please check your internet connection or the URL.")
end

local mainraw = "https://raw.githubusercontent.com/Glitched-Da-Kitty-Cat-Productions/lua-scripts/refs/heads/main/"

local Window = Airflow:Init({
    Name = "Glitched's Nordic Void Menu",
    Keybind = "Backquote",
    Logo = "http://www.roblox.com/asset/?id=118752982916680",
    Highlight = Color3.fromRGB(163, 128, 216),
    Resizable = false,
    UnlockMouse = false,
    IconSize = 20,
})

-- Create Tabs
local HomeTab = Window:DrawTab({Name = "Home", Icon = "home"})
local SafetyTab = Window:DrawTab({Name = "Safety", Icon = "shield"})
local ToolsTab = Window:DrawTab({Name = "Tools", Icon = "library"})
local TrollingTab = Window:DrawTab({Name = "Trolling", Icon = "smile"})
local GamesTab = Window:DrawTab({Name = "Games", Icon = "gamepad"})
local PlayerTab = Window:DrawTab({Name = "Player", Icon = "user"})
local MiscTab = Window:DrawTab({Name = "Miscellaneous", Icon = "bookmark"})
local OtherMenusTab = Window:DrawTab({Name = "Other Menus", Icon = "menu"})
local Setting = Window:DrawTab({Name = "Settings", Icon = "cog"})

local HomeSection = HomeTab:AddSection({Name = "Main Menu", Position = "left"})
HomeSection:AddLabel("Welcome to Glitched's Nordic Void Menu!")
HomeSection:AddButton({
    Name = "Discord Server",
    Callback = function()
        local success, err = pcall(function()
            setclipboard("https://discord.gg/rNNpGDcCeZ")
            Airflow:Notify({
                Title = "Discord Server",
                Content = "Discord Server Copied To Clipboard",
                Duration = 5,
                Icon = "info"
            })
        end)
        if not success then
            warn("Failed to copy Discord link: " .. tostring(err))
        end
    end
})


-- Safety Tab Sections
local SafetySection = SafetyTab:AddSection({Name = "Safety Tools", Position = "left"})
SafetySection:AddButton({
    Name = "Unc Test",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(mainraw .. "unc.lua"))()
        end)
        if not success then
            warn("Failed to execute Unc Test: " .. tostring(err))
        end
    end
})
SafetySection:AddButton({
    Name = "Server Hop",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(mainraw .. "server-hop.lua"))()
        end)
        if not success then
            warn("Failed to execute Server Hop: " .. tostring(err))
        end
    end
})
SafetySection:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        local success, err = pcall(function()
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local placeId = game.PlaceId
            local jobId = game.JobId
            TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
        end)
        if not success then
            warn("Failed to execute Rejoin: " .. tostring(err))
        end
    end
})

--SafetySection:AddToggle({
  --  Name = "Anti Fling",
    --Default = false,
    --Callback = function(value)
        ---if value then

--        else

--        end
    --end
--})


-- Tools Tab Section
local ToolsSection = ToolsTab:AddSection({Name = "Tools", Position = "left"})

-- Load Player ESP module
local PlayerESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Glitched-Da-Kitty-Cat-Productions/lua-scripts/refs/heads/main/plaer-esp.lua"))()

-- Player ESP Section
local PlayerESPSection = ToolsTab:AddSection({Name = "Player ESP", Position = "left"})

PlayerESPSection:AddToggle({
    Name = "Enable Player ESP",
    Default = false,
    Callback = function(value)
        if value then
            PlayerESP:Init()
            PlayerESP:Toggle(true)
        else
            PlayerESP:Toggle(false)
        end
    end
})

PlayerESPSection:AddToggle({
    Name = "Team Check",
    Default = false,
    Callback = function(value)
        PlayerESP.TeamCheck = value
    end
})

PlayerESPSection:AddToggle({
    Name = "Show Names",
    Default = true,
    Callback = function(value)
        PlayerESP.ShowName = value
    end
})

PlayerESPSection:AddToggle({
    Name = "Show Health",
    Default = true,
    Callback = function(value)
        PlayerESP.ShowHealth = value
    end
})

PlayerESPSection:AddToggle({
    Name = "Show Distance",
    Default = true,
    Callback = function(value)
        PlayerESP.ShowDistance = value
    end
})

PlayerESPSection:AddToggle({
    Name = "Box ESP",
    Default = true,
    Callback = function(value)
        PlayerESP.BoxESP = value
    end
})

PlayerESPSection:AddToggle({
    Name = "Tracer ESP",
    Default = false,
    Callback = function(value)
        PlayerESP.TracerESP = value
    end
})

-- Other Tools Section
local OtherToolsSection = ToolsTab:AddSection({Name = "Other Tools", Position = "left"})
OtherToolsSection:AddButton({
    Name = "Touch Fling Tool",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(mainraw .. "toolfling.lua"))()
        end)
        if not success then
            warn("Failed to execute Touch Fling: " .. tostring(err))
        end
    end
})
OtherToolsSection:AddButton({
    Name = "Aimbot",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Glitched-Da-Kitty-Cat-Productions/lua-scripts/refs/heads/main/aimbot.lua"))()
        end)
        if not success then
            warn("Failed to execute Aimbot: " .. tostring(err))
        end
    end
})

-- Trolling Tab Section
local TrollingSection = TrollingTab:AddSection({Name = "Trolling Tools", Position = "left"})
TrollingSection:AddButton({
    Name = "Touch Fling GUI",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(mainraw .. "touchfling_gui.lua"))()
        end)
        if not success then
            warn("Failed to execute Touch Fling GUI: " .. tostring(err))
        end
    end
})

-- Games Tab Sections
local GamesSection = GamesTab:AddSection({Name = "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, Position = "left"})
-- SlapBattles
if game.PlaceId == 124596094333302 or game.PlaceId == 6403373529 then
    GamesSection:AddParagraph({
        Name = "Slap Battles Information",
        Content = "Slap Battles is a Roblox game where players use a variety of gloves with unique abilities to slap other players, aiming to knock them off the map or out of the arena"
    })
    GamesSection:AddButton({
        Name = "All Instant Glove Badges",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(mainraw .. "AllInstantGlovebadge.lua"))()
            end)
            if not success then
                warn("Failed to execute All Instant Glove Badges script: " .. tostring(err))
            end
        end
    })
    GamesSection:AddButton({
        Name = "Slap Battle VINQHUB",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(mainraw .. "SlapbattleVINQHUB.lua"))()
            end)
            if not success then
                warn("Failed to execute Slap Battle VINQHUB: " .. tostring(err))
            end
        end
    })
end
-- Pressure
if game.PlaceId == 12411473842 then
    GamesSection:AddButton({
        Name = "Null Fire Hub: Pressure Lobby",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Null-Fire/refs/heads/main/Loader"))()
            end)
            if not success then
                warn("Failed to execute Null Fire Hub: Pressure Lobby: " .. tostring(err))
            end
        end
    })
end
if game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name == "Hadal Blacksite" then
    GamesSection:AddButton({
        Name = "Null Fire Hub: Pressure",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Null-Fire/refs/heads/main/Loader"))()
            end)
            if not success then
                warn("Failed to execute Null Fire Hub: Pressure: " .. tostring(err))
            end
        end   
    })
end

-- PlayerTab Tab Section
local PlayerSections = PlayerTab:AddSection({Name = "Player", Position = "left"})
PlayerSections:AddLabel("Some Of These Scripts Reset On Player Death")

PlayerSections:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 1000,
    Round = 0,
    Default = 16,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        Player.Character.Humanoid.WalkSpeed = Value
    end
})
PlayerSections:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 1000,
    Round = 0,
    Default = 50,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        Player.Character.Humanoid.JumpPower = Value
    end
})
PlayerSections:AddSlider({
    Name = "Hip Height",
    Min = 2,
    Max = 100,
    Round = 0,
    Default = 2,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        Player.Character.Humanoid.HipHeight = Value
    end
})
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Humanoid = nil
local JumpRequestConnection = nil
local canJump = true
local jumpCooldown = 0.3

local function onJumpRequest()
    if canJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        canJump = false
        task.wait(jumpCooldown)
        canJump = true
    end
end

PlayerSections:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        if Value then
            if not Humanoid then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                Humanoid = character:WaitForChild("Humanoid")
            end
            JumpRequestConnection = UserInputService.JumpRequest:Connect(onJumpRequest)
        else
            if JumpRequestConnection then
                JumpRequestConnection:Disconnect()
                JumpRequestConnection = nil
            end
        end
    end
})

PlayerSections:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Humanoid = nil
        local GodModeConnection = nil

        local function enableGodMode()
            if not Humanoid then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                Humanoid = character:WaitForChild("Humanoid")
            end
            if GodModeConnection then return end
            GodModeConnection = Humanoid.HealthChanged:Connect(function(health)
                if health < Humanoid.MaxHealth then
                    Humanoid.Health = Humanoid.MaxHealth
                end
            end)
            Humanoid.MaxHealth = math.huge
            Humanoid.Health = Humanoid.MaxHealth
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end

        local function disableGodMode()
            if GodModeConnection then
                GodModeConnection:Disconnect()
                GodModeConnection = nil
            end
            if Humanoid then
                Humanoid.MaxHealth = 100
                if Humanoid.Health > 100 then
                    Humanoid.Health = 100
                end
            end
        end

        if Value then
            enableGodMode()

        else
            disableGodMode()
        end
    end
})

PlayerSections:AddToggle({
    Name = "Keep Inventory On Death",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local inventoryBackup = {}
        local deathConnection = nil
        local characterConnection = nil
        local backpackConnection = nil

        local function backupInventory()
            inventoryBackup = {}
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local character = LocalPlayer.Character
            
            -- Backup tools in backpack
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        local clonedTool = item:Clone()
                        table.insert(inventoryBackup, clonedTool)
                    end
                end
            end
            
            -- Backup equipped tool
            if character then
                local equippedTool = character:FindFirstChildOfClass("Tool")
                if equippedTool then
                    local clonedTool = equippedTool:Clone()
                    table.insert(inventoryBackup, clonedTool)
                end
            end
        end

        local function restoreInventory()
            task.wait(0.5) -- Wait for character to fully load
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack and #inventoryBackup > 0 then
                for _, item in pairs(inventoryBackup) do
                    if item and item:IsA("Tool") then
                        local newTool = item:Clone()
                        newTool.Parent = backpack
                    end
                end
            end
        end

        local function onCharacterAdded(char)
            if deathConnection then
                deathConnection:Disconnect()
                deathConnection = nil
            end
            
            -- Wait for character to fully load before backing up
            task.wait(1)
            backupInventory()
            
            local humanoid = char:WaitForChild("Humanoid")
            deathConnection = humanoid.Died:Connect(function()
                -- Restore inventory when new character spawns
                LocalPlayer.CharacterAdded:Wait()
                restoreInventory()
            end)
            
            -- Update backup when tools are added/removed
            if backpackConnection then
                backpackConnection:Disconnect()
            end
            local backpack = LocalPlayer:WaitForChild("Backpack")
            backpackConnection = backpack.ChildAdded:Connect(function()
                task.wait(0.1)
                backupInventory()
            end)
        end

        if Value then
            if LocalPlayer.Character then
                onCharacterAdded(LocalPlayer.Character)
            end
            characterConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        else
            if deathConnection then
                deathConnection:Disconnect()
                deathConnection = nil
            end
            if characterConnection then
                characterConnection:Disconnect()
                characterConnection = nil
            end
            if backpackConnection then
                backpackConnection:Disconnect()
                backpackConnection = nil
            end
            inventoryBackup = {}
        end
    end
})
PlayerSections:AddButton({
    Name = "Fly",
    Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(mainraw .. "fly-gui.lua"))()
            end)
            if not success then
                warn("Failed to execute Slap Battle VINQHUB: " .. tostring(err))
            end
        end

})
-- Miscellaneous Tab Section
local MiscSection = MiscTab:AddSection({Name = "Miscellaneous", Position = "left"})
MiscSection:AddButton({
    Name = "Get Game ID",
    Callback = function()
        local success, err = pcall(function()
            local gameid = game:GetService("HttpService"):GenerateGUID()
            print("Current Game PlaceId:", game.PlaceId)
            Airflow:Notify({
                Title = "Game ID",
                Content = "Current Game PlaceId: " .. game.PlaceId,
                Duration = 5,
                Icon = "info"
            })
            setclipboard(game.PlaceId)
        end)
        if not success then
            warn("Failed to get Game ID: " .. tostring(err))
        end
    end
})
MiscSection:AddButton({
    Name = "Get Game Name",
    Callback = function()
        local success, err = pcall(function()
            local gameid = game:GetService("HttpService"):GenerateGUID()
            print("Current Game Name:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
            Airflow:Notify({
                Title = "Game Name",
                Content = "Current Game Name: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                Duration = 5,
                Icon = "info"
            })
            setclipboard("Current Game Name: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
        end)
        if not success then
            warn("Failed to get Game Name: " .. tostring(err))
        end
    end
})
MiscSection:AddButton({
    Name = "Dex Game Debug Menu",
    Callback = function(name)
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end)
        if not success then
            warn("Failed to get Dex" .. tostring(err))
        end
    end
})
MiscSection:AddButton({
    Name = "Item Cloner",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then
            warn("Local player has no backpack")
            return
        end

        local clonedTools = {}

        local function cloneTool(tool)
            if tool and tool:IsA("Tool") and not clonedTools[tool.Name] then
                local clone = tool:Clone()
                clone.Parent = backpack
                clonedTools[tool.Name] = true
            end
        end

        for _, descendant in pairs(game:GetDescendants()) do
            cloneTool(descendant)
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local playerBackpack = player:FindFirstChild("Backpack")
                if playerBackpack then
                    for _, tool in pairs(playerBackpack:GetChildren()) do
                        cloneTool(tool)
                    end
                end
            end
        end
    end
})

-- Other Menus Tab Section
local OtherMenusSection = OtherMenusTab:AddSection({Name = "Other Menus", Position = "left"})
OtherMenusSection:AddButton({
    Name = "Cool Kid Menu (Keyless Version)",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(mainraw .. "cool-kid-menu.lua"))()
        end)
        if not success then
            warn("Failed to execute Cool Kid Menu: " .. tostring(err))
        end
    end
})
OtherMenusSection:AddButton({
    Name = "Sirius.Menu (Free Version)",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://sirius.menu/sirius"))()
        end)
        if not success then
            warn("Failed to execute Sirius Menu: " .. tostring(err))
        end
    end
})


-- Settings Tab Section
local SettingsSection = Setting:AddSection({Name = "Configuration", Position = "left"})
local keybindConfig = SettingsSection:AddKeybind({
    Name = "Menu Keybind",
    Default = "Backquote",
    Callback = function(newKey)
        Window:SetKeybind(newKey)
        Airflow:Notify({
            Title = "Keybind Changed",
            Content = "Menu keybind changed to: " .. tostring(newKey),
            Duration = 5,
            Icon = "info"
        })
    end
})
local configPath = "GlitchedMenuConfig.json"
local configVersion = "1.0"
SettingsSection:AddButton({
    Name = "Save Config",
    Callback = function()
        local success, err = pcall(function()
            Airflow.FileManager:WriteConfig(Window, configPath)
            Airflow:Notify({
                Title = "Config Saved",
                Content = "Configuration saved to " .. configPath,
                Duration = 5,
                Icon = "info"
            })
        end)
        if not success then
            warn("Failed to save config: " .. tostring(err))
        end
    end
})
SettingsSection:AddButton({
    Name = "Load Config",
    Callback = function()
        local success, err = pcall(function()
            Airflow.FileManager:LoadConfig(Window, configPath, configVersion)
            Airflow:Notify({
                Title = "Config Loaded",
                Content = "Configuration loaded from " .. configPath,
                Duration = 5,
                Icon = "info"
            })
        end)
        if not success then
            warn("Failed to load config: " .. tostring(err))
        end
    end
})



Airflow:Notify({
    Title = "Welcome",
    Content = "Welcome to the Glitched's Nordic Void Menu",
    Duration = 5,
    Icon = "smile"
})

local success, err = pcall(function()
    Airflow.FileManager:LoadConfig(Window, configPath, configVersion)
end)
if not success then
    warn("Failed to load config on startup: " .. tostring(err))
end
