-- Load Rayfield Library
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not success then
    warn("Failed to load Rayfield")
    return
end

-- Wait until Rayfield is ready
repeat task.wait() until Rayfield and typeof(Rayfield.CreateWindow) == "function"

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Arsenal Silent Aim Hub",
    LoadingTitle = "Arsenal Silent Aim",
    LoadingSubtitle = "by umr251098",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- SETTINGS
local SilentAimEnabled = false
local SpeedHackEnabled = false
local ESPEnabled = false
local WallHackEnabled = false
local AimFOV = 40 -- Safe limit

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458) -- Gun Icon
local CustomizeTab = Window:CreateTab("Customize", 4483362939) -- Setting Icon

-- Functions

-- Silent Aim Function
local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = AimFOV

    for i, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToScreenPoint(v.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closest = v
                end
            end
        end
    end

    return closest
end

-- Hook Mouse Hit
local __index
__index = hookmetamethod(game, "__index", function(self, key)
    if SilentAimEnabled and not checkcaller() and self == Workspace.CurrentCamera and key == "CFrame" then
        local target = GetClosestPlayer()
        if target and target.Character then
            local targetPart = math.random(1,3) == 1 and target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("Head")
            if targetPart then
                return CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    end
    return __index(self, key)
end)

-- Speed Hack
RunService.RenderStepped:Connect(function()
    if SpeedHackEnabled then
        LocalPlayer.Character.Humanoid.WalkSpeed = 35
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Wall Hack (Basic Transparency)
RunService.RenderStepped:Connect(function()
    if WallHackEnabled then
        for i,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency < 0.8 then
                v.LocalTransparencyModifier = 0.5
            end
        end
    else
        for i,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency < 0.8 then
                v.LocalTransparencyModifier = 0
            end
        end
    end
end)

-- ESP
local function CreateESP(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4,6,1)
    box.Color3 = Color3.fromRGB(255,0,0)
    box.Transparency = 0.5
    box.Adornee = player.Character
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Parent = player.Character

    local nameTag = Instance.new("BillboardGui", player.Character)
    nameTag.Size = UDim2.new(0,100,0,40)
    nameTag.Adornee = player.Character.Head
    nameTag.AlwaysOnTop = true

    local text = Instance.new("TextLabel", nameTag)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = player.Name
    text.TextColor3 = Color3.new(1,0,0)
    text.TextScaled = true
end

local function ToggleESP(bool)
    if bool then
        for i,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                CreateESP(v)
            end
        end
    else
        for i,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BoxHandleAdornment") or v:IsA("BillboardGui") then
                v:Destroy()
            end
        end
    end
end

-- Create Main Tab buttons
MainTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end,
})

-- Create Customize Tab buttons
CustomizeTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        SpeedHackEnabled = Value
    end,
})

CustomizeTab:CreateToggle({
    Name = "Wall Hack",
    CurrentValue = false,
    Callback = function(Value)
        WallHackEnabled = Value
    end,
})

CustomizeTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value
        ToggleESP(Value)
    end,
})
