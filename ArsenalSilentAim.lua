--// Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Arsenal Silent Aim Hub",
    LoadingTitle = "Arsenal Hub Loading...",
    LoadingSubtitle = "by YourNameHere", -- you can put your name
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ArsenalSilentAim", -- folder where it saves settings
        FileName = "ArsenalSilentAimHub"
    },
    Discord = {
        Enabled = false,
        Invite = "", -- If you have a Discord server
        RememberJoins = false
    },
    KeySystem = false,
    KeySettings = {
        Title = "Arsenal Hub Key",
        Subtitle = "Key System",
        Note = "No key needed",
        FileName = "KeySystem",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"yourkey"}
    }
})

--// Variables
local SilentAimEnabled = false
local SpeedHackEnabled = false
local WallHackEnabled = false
local ESPEnabled = false

--// Functions
function toggleSilentAim(state)
    SilentAimEnabled = state
    -- Here you would start or stop silent aim
end

function toggleSpeedHack(state)
    SpeedHackEnabled = state
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 40 -- Speed hack
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Reset to normal
    end
end

function toggleWallHack(state)
    WallHackEnabled = state
    if state then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency < 0.8 then
                v.LocalTransparencyModifier = 0.5
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = v.Transparency
            end
        end
    end
end

function toggleESP(state)
    ESPEnabled = state
    if state then
        -- ESP On
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ArsenalESP"
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.OutlineColor = Color3.fromRGB(255,0,0)
                highlight.Parent = player.Character
            end
        end
    else
        -- ESP Off
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ArsenalESP") then
                player.Character:FindFirstChild("ArsenalESP"):Destroy()
            end
        end
    end
end

--// Create Tabs
local MainTab = Window:CreateTab("Main", 4483362458) -- Silent Aim Icon
local CustomizeTab = Window:CreateTab("Customize", 4483362458) -- Customize Icon

--// Main Tab Options
MainTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(Value)
        toggleSilentAim(Value)
    end,
})

--// Customize Tab Options
CustomizeTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        toggleSpeedHack(Value)
    end,
})

CustomizeTab:CreateToggle({
    Name = "Wall Hack",
    CurrentValue = false,
    Flag = "WallHack",
    Callback = function(Value)
        toggleWallHack(Value)
    end,
})

CustomizeTab:CreateToggle({
    Name = "ESP (Box + Username)",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        toggleESP(Value)
    end,
})
