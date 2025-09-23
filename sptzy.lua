local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- 🔽 ANIMASI "BY : Xraxor CMNY" 🔽
do
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "IntroAnimation"
    introGui.ResetOnSpawn = false
    introGui.Parent = player:WaitForChild("PlayerGui")

    local introLabel = Instance.new("TextLabel")
    introLabel.Size = UDim2.new(0, 300, 0, 50)
    introLabel.Position = UDim2.new(0.5, -150, 0.4, 0)
    introLabel.BackgroundTransparency = 1
    introLabel.Text = "By : Xraxor CMNY"
    introLabel.TextColor3 = Color3.fromRGB(40, 40, 40)
    introLabel.TextScaled = true
    introLabel.Font = Enum.Font.GothamBold
    introLabel.Parent = introGui

    local tweenInfoMove = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tweenMove = TweenService:Create(introLabel, tweenInfoMove, {Position = UDim2.new(0.5, -150, 0.42, 0)})

    local tweenInfoColor = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tweenColor = TweenService:Create(introLabel, tweenInfoColor, {TextColor3 = Color3.fromRGB(0, 0, 0)})

    tweenMove:Play()
    tweenColor:Play()

    task.wait(2)
    local fadeOut = TweenService:Create(introLabel, TweenInfo.new(0.5), {TextTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        introGui:Destroy()
    end)
end

-- 🔽 Status AutoFarm 🔽
local statusValue = ReplicatedStorage:FindFirstChild("AutoFarmStatus")
if not statusValue then
    statusValue = Instance.new("BoolValue")
    statusValue.Name = "AutoFarmStatus"
    statusValue.Value = false
    statusValue.Parent = ReplicatedStorage
end

-- 🔽 GUI Utama 🔽
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0.4, -110, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Judul GUI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Mount Gamon"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Tombol SUMMIT
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0.5, -80, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.Text = "SUMMIT"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 15
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button

-- Label Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Inactive"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Parent = frame

-- Tombol Auto Start
local autoStart = false
local autoStartButton = Instance.new("TextButton")
autoStartButton.Size = UDim2.new(0, 160, 0, 30)
autoStartButton.Position = UDim2.new(0.5, -80, 1, 5)
autoStartButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoStartButton.Text = "Auto Start: OFF"
autoStartButton.TextColor3 = Color3.new(1, 1, 1)
autoStartButton.Font = Enum.Font.GothamBold
autoStartButton.TextSize = 14
autoStartButton.Parent = frame

local autoStartCorner = Instance.new("UICorner")
autoStartCorner.CornerRadius = UDim.new(0, 10)
autoStartCorner.Parent = autoStartButton

autoStartButton.MouseButton1Click:Connect(function()
    autoStart = not autoStart
    if autoStart then
        autoStartButton.Text = "Auto Start: ON"
        autoStartButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        autoStartButton.Text = "Auto Start: OFF"
        autoStartButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

-- 🔽 Posisi Teleport 🔽
local position1 = Vector3.new(-655.49, 17.22, 209.03)
local position2 = Vector3.new(1708.42, 953.88, 1387.94)
local position3 = Vector3.new(1734.64, 1067.83, 1240.38)

local teleporting = false

local function teleportTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- 🔁 AutoFarm Sekali
local function autoFarmOnce()
    teleporting = true
    statusValue.Value = true
    button.Text = "RUNNING..."
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    statusLabel.Text = "Status: Running (Once)"

    teleportTo(position1)
    task.wait(1)

    teleportTo(position2)
    task.wait(1)

    teleportTo(position3)
    task.wait(1)

    teleporting = false
    statusValue.Value = false
    button.Text = "SELESAI"
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    statusLabel.Text = "Status: Selesai"
end

-- 🔁 AutoFarm Loop
local function autoFarmLoop()
    while teleporting do
        teleportTo(position1)
        task.wait(1)
        teleportTo(position2)
        task.wait(1)
        teleportTo(position3)
        task.wait(1)
    end
end

local function toggleAutoFarm(state)
    teleporting = state
    statusValue.Value = state
    if teleporting then
        button.Text = "RUNNING..."
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        statusLabel.Text = "Status: Active (Loop)"
        task.spawn(autoFarmLoop)
    else
        button.Text = "STOP"
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        statusLabel.Text = "Status: Inactive"
    end
end

-- Tombol SUMMIT ditekan
button.MouseButton1Click:Connect(function()
    toggleAutoFarm(not teleporting)
end)

-- ⏱️ Jalankan AutoFarm Sekali Jika AutoStart Aktif
task.delay(3, function()
    if autoStart then
        autoFarmOnce()
    end
end)
