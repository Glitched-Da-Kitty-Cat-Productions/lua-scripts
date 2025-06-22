if not game then
    error("This script must be run in a Roblox environment.")
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
 
local Window = Rayfield:CreateWindow({
   Name = "c00lkidd's gui of nds",
   Icon = 130386628476315, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "c00lkidd's gui",
   LoadingSubtitle = "by c00lkidd",
   Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },
 
   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "Teamc00lkidd", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
 
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "join discord for key, this script can be used for other games.",
      Subtitle = "Enter Key",
      Note = "Join the discord and ask the mods or owner for key", -- Use this to tell the user how to get a key
      FileName = "Teamz", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"c00lkiddssecretkey","dyskord","quijk","F5w20s","27jUkl","jkiO92w"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
 
local MainTab = Window:CreateTab("trolling scripts", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Troll")
 
local ToolsTab = Window:CreateTab("Tool givers", nil) -- Title, Image
 
local DiscordTab = Window:CreateTab("Discord link", nil)
 
local TsbTab = Window:CreateTab("TSB", nil) -- Title, Image
 
local OtherTab = Window:CreateTab("other", nil) -- Title, Image
 
local BaseplateTab = Window:CreateTab("Just a baseplate", nil) -- Title, Image
 
local SimulatorTab = Window:CreateTab("scripts for simulators", nil) -- Title, Image

local DeadrailsTab = Window:CreateTab("Dead Rails 💀", nil) -- Title, Image

local GrowAGardenTab = Window:CreateTab("Grow A Garden", nil) -- Title, Image

local BackdoorTab = Window:CreateTab("Backdoor finders", nil) -- Title, Image

local ForsakenTab = Window:CreateTab("Forsaken", nil) -- Title, Image

Rayfield:Notify({
   Title = "c00lkidd's trolling gui of nds and other games",
   Content = "Script loading",
   Duration = 3.5,
   Image = 130386628476315,
})
 
local Button = MainTab:CreateButton({
   Name = "fly v3",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
   end,
})
 
local Button = MainTab:CreateButton({
   Name = "Newest Infinite yeild",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})
 
local Button = MainTab:CreateButton({
   Name = "Funny 3 script trolls",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Luarmor123/community-Y-HUB/refs/heads/main/Invisible-Fling-Autoclicker-BringParts.lua"))()
   end,
})
 
local Button = MainTab:CreateButton({
   Name = "Super Ring",
   Callback = function()
   loadstring(game:HttpGet("https://pastebin.com/raw/aZjaAr6F"))()
   end,
})
 
local Button = MainTab:CreateButton({
   Name = "Aquamatrix animations",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/ExploitFin/AquaMatrix/refs/heads/AquaMatrix/AquaMatrix"))()
   end,
})
 
local Button = MainTab:CreateButton({
   Name = "NDS autofarm (Broke)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/03koios/Loader/main/Loader.lua"))()
   end,
})
 
local Button = MainTab:CreateButton({
   Name = "fe Blackhole, aka caseoh",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers"))()
   end,
})
 
local Buttton = MainTab:CreateButton({
   Name = "Wisl FE",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/wisl884/wisl-i-Universal-Project1/main/Wisl'i%20Universal%20Project.lua", true))()
      end,
   })
 
local Buttton = MainTab:CreateButton({
   Name = "NullFire NDS (OP)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader"))()
      end,
   })
 
local Buttton = MainTab:CreateButton({
   Name = "Swamp Monster Hub (op)",
   Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/2tC7nRAK/raw"))()
      end,
   })

local Buttton = MainTab:CreateButton({
   Name = "Fe ball reimagined",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/KaterHub-Inc/scripts/refs/heads/main/unofficial-Projects/FEHamsterBall.lua"))()
      end,
   })

local Buttton = MainTab:CreateButton({
   Name = "Zer0 Gravity (jump to gain back gravity)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/zerogravity"))()
      end,
   })

local Buttton = MainTab:CreateButton({
   Name = "Unanchored parts controller",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/v0c0n1337/scripts/refs/heads/main/Unachored_parts_controller_v2.lua.txt"))()
      end,
   })

local Button = ToolsTab:CreateButton({
   Name = "Telekinesis",
   Callback = function()
   loadstring(game:HttpGet(("https://pastebin.com/raw/07GGb4Dk"),true))()
   end,
})

local Button = ToolsTab:CreateButton({
   Name = "TP Tool",
   Callback = function()
   mouse = game.Players.LocalPlayer:GetMouse()
tool = Instance.new("Tool")
tool.RequiresHandle = false
tool.Name = "Tp tool(Equip to Click TP)"
tool.Activated:connect(function()
local pos = mouse.Hit+Vector3.new(0,2.5,0)
pos = CFrame.new(pos.X,pos.Y,pos.Z)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end)
tool.Parent = game.Players.LocalPlayer.Backpack
   end,
})

local Button = ToolsTab:CreateButton({
   Name = "Jerk off",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-jerk-off-goon-28106"))()
   end,
})
 
local Button = OtherTab:CreateButton({
   Name = "Robux calc (player finder)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Skeleton/refs/heads/main/avatarworthcalculator.lua"))()
   end,
})

local Button = OtherTab:CreateButton({
   Name = "DEX",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
   end,
})

local Button = OtherTab:CreateButton({
   Name = "UNC test (click F9 or type /console in chat",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/OrzScript/Uncategorized/refs/heads/main/Deep%20UNC%20Test.lua",true))()
   end,
})

local Button = OtherTab:CreateButton({
   Name = "Chat Forger",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/v-oidd/chat-forger/main/chat-forger.lua'))()
   end,
})

local Button = OtherTab:CreateButton({
  Name = "Quirky cmd (only works with a few games)",
  Callback = function()
  loadstring(game:HttpGet("https://gist.github.com/someunknowndude/38cecea5be9d75cb743eac8b1eaf6758/raw"))()
  end,
})

local Button = OtherTab:CreateButton({
  Name = "Delta keyboard crack",
  Callback = function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Xxtan31/Ata/main/deltakeyboardcrack.txt"))()
  end,
})

local Button = MainTab:CreateButton({
   Name = "c00l gui",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/MiRw3b/c00lgui-v3rx/main/c00lguiv3rx.lua"))()
   end,
})

local Button = SimulatorTab:CreateButton({
   Name = "Idiot hub (Bubble gum simulator Infinity)",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Bubble-Gum-Simulator-INFINITY-Idiot-Hub-35306"))()
   end,
   })
 
local Button = DiscordTab:CreateButton({
   Name = "https://discord.gg/Teamc00lkidd",
   Callback = function()
   print("Spooky scary skeletons")
   end,
   })
 
local Button = DiscordTab:CreateButton({
   Name = "discord.gg/Teamc00lkidd",
   Callback = function()
   print("Join now")
   end,
})
 
local Button = BaseplateTab:CreateButton({
   Name = "HatHub (rare script)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/inkdupe/hat-scripts/refs/heads/main/updatedhathub.lua"))()
   end,
})
 
local Button = BaseplateTab:CreateButton({
   Name = "FE Server Admin",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/ONEReverseCard/My-Scripts/main/Netless%20Server%20Admin.md"))()
   end,
})
 
local Button = BaseplateTab:CreateButton({
   Name = "FE Cromatic Swordsman",
   Callback = function()
   loadstring(game:HttpGet("https://pastebin.com/raw/2cqh97aB"))()
   end,
})
local Button = BaseplateTab:CreateButton({
   Name = "FE Dragon",
   Callback = function()
   game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-gh 63690008 62234425 12103270510 10775031176 9350274205")
 
wait(1)
 
game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-net")
 
wait(1)
 
loadstring(game:HttpGet('https://pastebin.com/raw/XBfi5wXf'))()
   end,
})
 
local Button = BaseplateTab:CreateButton({
  Name = "Krystal Dance (use delta keyboard if on mobile (others))",
  Callback = function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/sparezirt/Script/refs/heads/main/.github/workflows/JustABaseplate.lua"))()
  end,
})

 local Button = TsbTab:CreateButton({
   Name = "c00lkidd moveset",
   Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/CameraFix"))()
   -- ## C00LKIDD
getgenv().Password = "KqM7@X9p!L#W82YzdT"
loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/C00lK1D%20(Garou)%20Obfuscated.txt", true))()
   end,
})
 
 local Button = TsbTab:CreateButton({
   Name = "Trashcan man bald hero",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/CameraFix"))()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man", true))()
   end,
})
 
local Button = TsbTab:CreateButton({
   Name = "Teleport guy (Garou)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/CameraFix"))()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Teleport%20Guy.txt", true))()
   end,
})
 
local Button = TsbTab:CreateButton({
   Name = "fly tool",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/CameraFix"))()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Flight%20Tool%20Obfuscated.txt"))()
   end,
})
 
local Button = TsbTab:CreateButton({
   Name = "Void Reaper (Garou)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/CameraFix"))()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Void%20Reaper%20Obfuscated.txt"))()
   end,
})
 
local Button = OtherTab:CreateButton({
   Name = "RTX",
   Callback = function()
   local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
 
-- bye old sky stuff
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v:Destroy() -- yes
    end
end
 
-- lighting settings
Lighting.Brightness = 1.9 -- brightness for glow
Lighting.GlobalShadows = true
Lighting.EnvironmentDiffuseScale = 1
Lighting.EnvironmentSpecularScale = 1.6 -- extra shine
Lighting.ExposureCompensation = -0.03 -- just a bit darker to balance shine
 
-- effects
local function addEffects()
    local sun = Instance.new("SunRaysEffect", Lighting)
    sun.Intensity = 0.1 -- slightly stronger
    sun.Spread = 0.2
 
    local bloom = Instance.new("BloomEffect", Lighting)
    bloom.Intensity = 0.7 -- bloom for glow
    bloom.Size = 64
    bloom.Threshold = 2.5
 
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    cc.Brightness = -0.03
    cc.Contrast = 0.15
    cc.Saturation = 0.1
    cc.TintColor = Color3.fromRGB(255, 255, 255)
 
    local dof = Instance.new("DepthOfFieldEffect", Lighting)
    dof.FarIntensity = 0.05
    dof.FocusDistance = 100
    dof.InFocusRadius = 60
    dof.NearIntensity = 0.2
 
    -- blur effect
    local blur = Instance.new("BlurEffect", Lighting)
    blur.Size = 8 -- more blur
 
    local atmo = Instance.new("Atmosphere", Lighting)
    atmo.Density = 0.28
    atmo.Offset = 0.15
    atmo.Glare = 0.85
    atmo.Haze = 0.55
    atmo.Color = Color3.fromRGB(180, 200, 220)
    atmo.Decay = Color3.fromRGB(95, 100, 115)
end
 
addEffects()
 
-- more shine
for _, part in ipairs(Workspace:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Material = Enum.Material.SmoothPlastic
        part.Reflectance = 0.2 -- reflectance for shininess
    end
end
 
local dayLength = 150
local nightLength = 300
local timeStep = 0.03
 
spawn(function()
    while true do
        -- day shiny!
        Lighting.Ambient = Color3.fromRGB(80, 80, 80)
        Lighting.OutdoorAmbient = Color3.fromRGB(115, 115, 115)
        for t = 6, 18, timeStep do
            Lighting.ClockTime = t
            wait((dayLength / (18 - 6)) * timeStep)
        end
 
        -- night dark??
        Lighting.Ambient = Color3.fromRGB(30, 30, 30)
        Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 50)
        for t = 18, 24, timeStep do
            Lighting.ClockTime = t
            wait((nightLength / (24 - 18)) * timeStep)
        end
        for t = 0, 6, timeStep do
            Lighting.ClockTime = t
            wait((nightLength / 6) * timeStep)
        end
    end
end)
   end,
})
 
local Button = OtherTab:CreateButton({
   Name = "Fast Leave (kick yourself basically)",
   Callback = function()
   game.Players.LocalPlayer:Kick("Spooky Scary Skeletons")
   end,
})

local Button = OtherTab:CreateButton({
   Name = "Stalkie (only works for mic up)",
   Callback = function()
   repeat task.wait() until game.Players.LocalPlayer
   loadstring(game:HttpGet("https://raw.githubusercontent.com/0riginalWarrior/Stalkie/refs/heads/main/roblox.lua"))()
   end,
})

local Button = OtherTab:CreateButton({
   Name = "Btools gui",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/SkireScripts/F3X-Panel/main/Main.lua"))()
   end,
})

local Button = OtherTab:CreateButton({
   Name = "ConsoleX",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Dhelannn/Test/refs/heads/main/Test1"))()
   end,
})

local Button = DeadrailsTab:CreateButton({
   Name = "Inf Bonds and currency",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/DeadrailsTrial/Deadrails%20Trial%20V2"))()
   end,
})
 
local PlayerTab = Window:CreateTab("Player", nil) -- Title, Image
local Section = PlayerTab:CreateSection("Tp or edit your speed.")
 
local Slider = PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
           game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Button = GrowAGardenTab:CreateButton({
   Name = "darkest gui",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/refs/heads/main/Grow%20A%20Garden'))()
   end,
})

local Button = GrowAGardenTab:CreateButton({
   Name = "random script hub",
   Callback = function()
   loadstring(game:HttpGet("https://paste.ee/r/4uq28Ked"))()
   end,
})

local Button = GrowAGardenTab:CreateButton({
   Name = "h4xScript hub",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader2.lua"))()
   end,
})

local Button = GrowAGardenTab:CreateButton({
   Name = "Lemon Cheat",
   Callback = function()
   loadstring(game:HttpGet("https://lunor.dev/loader"))()
   end,
})

local Button = BackdoorTab:CreateButton({
   Name = "LALOL",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/Its-LALOL/LALOL-Hub/main/Backdoor-Scanner/script'))()
   end,
})

local Button = ForsakenTab:CreateButton({
   Name = "Nevcit (key is goaHuB41)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Nevcit/GOA_HUB/refs/heads/main/Forsaken"))()
   end,
})
 
local Dropdown = PlayerTab:CreateDropdown({
   Name = "Teleport to area (Not working atm)",
   Options = {"Spawn","Island"},
   CurrentOption = {"nil"},
   MultipleOptions = false,
   Flag = "Teleport", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
   -- The function that takes place when the selected option is changed
   -- The variable (Options) is a table of strings for the current selected options
   end,
})
