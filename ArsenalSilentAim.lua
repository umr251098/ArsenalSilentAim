-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Setup
local Window = Rayfield:CreateWindow({
    Name = "Arsenal Silent Aim Hub",
    LoadingTitle = "Arsenal Silent Aim Hub",
    LoadingSubtitle = "by umr251098",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local CustomizeTab = Window:CreateTab("Customize", 4483362458)

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- Silent Aim Variables
local SilentAimEnabled = false

-- ESP Variables
local ESPEnabled = false
local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "ESPFolder"

-- Speed Hack Variables
local SpeedEnabled = false
local NormalSpeed = 16
local BoostSpeed = 50

-- Wall Hack Variables
local WallHackEnabled = false

-- Main Tab: Silent Aim Toggle
MainTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end,
})

-- Customize Tab: ESP Toggle
CustomizeTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value

        if not Value then
            espFolder:ClearAllChildren()
        end
    end,
})

-- Customize Tab: Speed Hack Toggle
CustomizeTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        SpeedEnabled = Value

        if SpeedEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = BoostSpeed
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = NormalSpeed
        end
    end,
})

-- Customize Tab: Wall Hack Toggle
CustomizeTab:CreateToggle({
    Name = "Wall Hack",
    CurrentValue = false,
    Callback = function(Value)
        WallHackEnabled = Value

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency == 0 and v.CanCollide then
                if WallHackEnabled then
                    v.LocalTransparencyModifier = 0.5
                else
                    v.LocalTransparencyModifier = 0
                end
            end
        end
    end,
})

-- Silent Aim Logic
local function GetClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                if distance < shortestDistance and distance <= 40 then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if SilentAimEnabled and method == "FireServer" and self.Name == "HitPart" then
        local target = GetClosestPlayerToCursor()
        if target and target.Character then
            local chance = math.random(1, 100)
            if chance <= 80 then
                args[2] = target.Character.Head
            else
                args[2] = target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("UpperTorso")
            end
            return old(self, unpack(args))
        end
    end

    return old(self, ...)
end)

-- ESP Update Loop
task.spawn(function()
    while task.wait(0.5) do
        if ESPEnabled then
            espFolder:ClearAllChildren()

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local box = Instance.new("BillboardGui", espFolder)
                    box.Adornee = player.Character.HumanoidRootPart
                    box.Size = UDim2.new(4,0,5,0)
                    box.AlwaysOnTop = true

                    local frame = Instance.new("Frame", box)
                    frame.Size = UDim2.new(1,0,1,0)
                    frame.BackgroundTransparency = 0.5
                    frame.BackgroundColor3 = Color3.fromRGB(255,0,0)

                    local name = Instance.new("TextLabel", box)
                    name.Size = UDim2.new(1,0,0.2,0)
                    name.Position = UDim2.new(0,0,-0.2,0)
                    name.Text = player.Name
                    name.TextColor3 = Color3.new(1,0,0)
                    name.BackgroundTransparency = 1
                end
            end
        end
    end
end)
