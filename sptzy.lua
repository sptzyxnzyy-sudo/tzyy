local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Mobile Controls Module
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame (Compact Size)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -100)
MainFrame.Size = UDim2.new(0, 200, 0, 280) -- Ukuran lebih ramping
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner_M = Instance.new("UICorner")
UICorner_M.CornerRadius = UDim.new(0, 10)
UICorner_M.Parent = MainFrame

local Border = Instance.new("Frame")
Border.Name = "RainbowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.BorderSizePixel = 0
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.ZIndex = 0
local UICorner_B = Instance.new("UICorner")
UICorner_B.CornerRadius = UDim.new(0, 10)
UICorner_B.Parent = Border

-- [PROFILE SECTION]
local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(1, 0, 0, 60)
Profile.BackgroundTransparency = 1
Profile.Parent = MainFrame

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 40, 0, 40)
Avatar.Position = UDim2.new(0, 10, 0, 10)
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Avatar.Parent = Profile
local UICorner_A = Instance.new("UICorner")
UICorner_A.CornerRadius = UDim.new(1, 0)
UICorner_A.Parent = Avatar

local NameLabel = Instance.new("TextLabel")
NameLabel.Text = LocalPlayer.DisplayName
NameLabel.Position = UDim2.new(0, 58, 0, 12)
NameLabel.Size = UDim2.new(0, 130, 0, 15)
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.Font = Enum.Font.SourceSansBold
NameLabel.TextSize = 14
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.BackgroundTransparency = 1
NameLabel.Parent = Profile

local UserLabel = Instance.new("TextLabel")
UserLabel.Text = "@" .. LocalPlayer.Name
UserLabel.Position = UDim2.new(0, 58, 0, 27)
UserLabel.Size = UDim2.new(0, 130, 0, 12)
UserLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
UserLabel.Font = Enum.Font.SourceSans
UserLabel.TextSize = 11
UserLabel.TextXAlignment = Enum.TextXAlignment.Left
UserLabel.BackgroundTransparency = 1
UserLabel.Parent = Profile

-- [BUTTONS CONTAINER]
local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 0, 0, 65)
Container.Size = UDim2.new(1, 0, 1, -85)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 6)

-- Freecam Logic Variables
local freecamOn = false
local camSpeed = 50
local yaw, pitch = 0, 0
local camPos = Vector3.zero
local lookTouch, lastLookPos = nil, nil
local upHeld, downHeld = false, false
local frozenPos = nil

-- Render Rainbow
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Border.BackgroundColor3 = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.03)
        end
    end
end)

-- Styled Button Function
local function AddButton(name, icon, color, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = "          " .. name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Container
    
    local UIC_B = Instance.new("UICorner")
    UIC_B.CornerRadius = UDim.new(0, 6)
    UIC_B.Parent = Btn
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0, 10, 0.5, -9)
    Icon.Image = icon
    Icon.BackgroundTransparency = 1
    Icon.Parent = Btn
    
    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        Btn.BackgroundColor3 = active and color or Color3.fromRGB(30, 30, 30)
        func(active)
    end)
end

-- [ACTION BUTTONS]
AddButton("AUTO BUY PADI", "rbxassetid://6031764630", Color3.fromRGB(0, 120, 215), function(s)
    _G.AutoBuy = s
    while _G.AutoBuy do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) end)
        task.wait(0.5)
    end
end)

AddButton("AUTO SELL PADI", "rbxassetid://6031154871", Color3.fromRGB(180, 0, 0), function(s)
    _G.AutoSell = s
    while _G.AutoSell do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45) end)
        task.wait(0.5)
    end
end)

-- [FREECAM UI & LOGIC]
local FC_Overlay = Instance.new("Frame")
FC_Overlay.Size = UDim2.new(1, 0, 1, 0)
FC_Overlay.BackgroundTransparency = 1
FC_Overlay.Visible = false
FC_Overlay.Parent = ScreenGui

local function makeVolBtn(t, p)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 50, 0, 50)
    b.Position = p
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.BackgroundTransparency = 0.4
    b.Text = t
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = FC_Overlay
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

local UBtn = makeVolBtn("▲", UDim2.new(1, -60, 0.5, -55))
local DBtn = makeVolBtn("▼", UDim2.new(1, -60, 0.5, 5))

UBtn.InputBegan:Connect(function() upHeld = true end)
UBtn.InputEnded:Connect(function() upHeld = false end)
DBtn.InputBegan:Connect(function() downHeld = true end)
DBtn.InputEnded:Connect(function() downHeld = false end)

AddButton("MOBILE FREECAM", "rbxassetid://6034289542", Color3.fromRGB(0, 160, 80), function(state)
    freecamOn = state
    FC_Overlay.Visible = state
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if state then
        camPos = Camera.CFrame.Position
        local lv = Camera.CFrame.LookVector
        yaw, pitch = math.deg(math.atan2(-lv.X, -lv.Z)), math.deg(math.asin(math.clamp(lv.Y, -1, 1)))
        Camera.CameraType = Enum.CameraType.Scriptable
        if hrp then frozenPos = hrp.CFrame hrp.Anchored = true end
    else
        Camera.CameraType = Enum.CameraType.Custom
        if hrp then hrp.Anchored = false end
    end
end)

-- Handle Rotation (Touch)
UserInputService.InputChanged:Connect(function(input)
    if freecamOn and input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.X > Camera.ViewportSize.X * 0.4 then
            local delta = input.Delta
            yaw = yaw - delta.X * 0.3
            pitch = math.clamp(pitch - delta.Y * 0.3, -88, 88)
        end
    end
end)

-- Render Loop
RunService.RenderStepped:Connect(function(dt)
    if freecamOn then
        local mv = Controls:GetMoveVector()
        local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        local v = (upHeld and 1 or 0) - (downHeld and 1 or 0)
        local move = (rot.RightVector * mv.X) + (rot.LookVector * -mv.Z) + (Vector3.yAxis * v)
        camPos = camPos + move * camSpeed * dt
        Camera.CFrame = CFrame.new(camPos) * rot
        if frozenPos and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = frozenPos
        end
    end
end)

-- Watermark
local WM = Instance.new("TextLabel")
WM.Text = "IKYY EXECUTOR v3"
WM.Position = UDim2.new(0, 0, 1, -22)
WM.Size = UDim2.new(1, 0, 0, 20)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(100, 100, 100)
WM.TextSize = 10
WM.Parent = MainFrame
