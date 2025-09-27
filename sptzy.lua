--You can take the script with your own ideas, friend.
-- credit: Xraxor1

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- ** ⬇️ STATUS FITUR CORE ⬇️ **
local teleporting = false

-- 🔽 ANIMASI "BY : Xraxor" 🔽
do
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "IntroAnimation"
    introGui.ResetOnSpawn = false
    introGui.Parent = player:WaitForChild("PlayerGui")

    local introLabel = Instance.new("TextLabel")
    introLabel.Size = UDim2.new(0, 300, 0, 50)
    introLabel.Position = UDim2.new(0.5, -150, 0.4, 0)
    introLabel.BackgroundTransparency = 1
    introLabel.Text = "By : Xraxor"
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
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.4, -110, 0.5, -80)
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
title.Text = "Mount Atin V2"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Tombol SUMMIT
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0.5, -80, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Diubah agar status OFF terlihat jelas
button.Text = "SUMMIT: OFF"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 15
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button

-- 🔽 GUI Samping Teleport List Toggle 🔽
local flagButton = Instance.new("ImageButton")
flagButton.Size = UDim2.new(0, 20, 0, 20)
flagButton.Position = UDim2.new(1, -30, 0, 5)
flagButton.BackgroundTransparency = 1
flagButton.Image = "rbxassetid://6031097229"
flagButton.Parent = frame

local sideFrame = Instance.new("Frame")
sideFrame.Size = UDim2.new(0, 170, 0, 200)
sideFrame.Position = UDim2.new(1, 10, 0, 0)
sideFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sideFrame.Visible = false
sideFrame.Parent = frame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 12)
sideCorner.Parent = sideFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -5)
scrollFrame.Position = UDim2.new(0, 0, 0, 5)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = sideFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

flagButton.MouseButton1Click:Connect(function()
    sideFrame.Visible = not sideFrame.Visible
end)

---

## Daftar Teleportasi

```lua
-- 🔽 Teleport List 🔽
local teleportList = {
    {name = "Teleport Pos 1", pos = Vector3.new(5.91, 13.20, -401.66)},
    {name = "Teleport Pos 2", pos = Vector3.new(-183.98, 128.67, 409.35)},
    {name = "Teleport Pos 3", pos = Vector3.new(-165.62, 230.20, 653.26)},
    {name = "Teleport Pos 4", pos = Vector3.new(-37.75, 407.22, 616.05)},
    {name = "Teleport Pos 5", pos = Vector3.new(130.81, 652.40, 613.81)},
    {name = "Teleport Pos 6", pos = Vector3.new(-246.32, 666.33, 734.26)},
    {name = "Teleport Pos 7", pos = Vector3.new(-684.34, 641.34, 867.82)},
    {name = "Teleport Pos 8", pos = Vector3.new(-658.35, 689.06, 1458.58)},
    {name = "Teleport Pos 9", pos = Vector3.new(-507.38, 903.54, 1867.65)},
    {name = "Teleport Pos 10", pos = Vector3.new(60.53, 950.50, 2088.49)},
    {name = "Teleport Pos 11", pos = Vector3.new(51.97, 982.12, 2450.11)},
    {name = "Teleport Pos 12", pos = Vector3.new(72.71, 1097.56, 2456.81)},
    {name = "Teleport Pos 13", pos = Vector3.new(262.32, 1270.73, 2037.32)},
    {name = "Teleport Pos 14", pos = Vector3.new(-418.16, 1302.79, 2393.94)},
    {name = "Teleport Pos 15", pos = Vector3.new(-773.07, 1314.52, 2664.33)},
    {name = "Teleport Pos 16", pos = Vector3.new(-837.85, 1475.55, 2625.13)},
    {name = "Teleport Pos 17", pos = Vector3.new(-468.79, 1466.25, 2769.38)},
    {name = "Teleport Pos 18", pos = Vector3.new(-385.24, 1640.90, 2794.93)},
    {name = "Teleport Pos 19", pos = Vector3.new(-385.24, 1640.90, 2794.93)},
    {name = "Teleport Pos 20", pos = Vector3.new(-208.03, 1666.32, 2749.07)},
    {name = "Teleport Pos 21", pos = Vector3.new(-232.37, 1742.68, 2792.08)},
    {name = "Teleport Pos 22", pos = Vector3.new(-424.28, 1741.32, 2797.70)},
    {name = "Teleport Pos 23", pos = Vector3.new(-422.88, 1713.02, 3419.81)},
    {name = "Teleport Pos 24", pos = Vector3.new(70.72, 1719.29, 3427.58)},
    {name = "Teleport Pos 25", pos = Vector3.new(436.34, 1721.15, 3430.44)},
    {name = "Teleport Pos 26", pos = Vector3.new(625.27, 1799.83, 3432.84)},
    {name = "PUNCAK", pos = Vector3.new(780.47, 2183.38, 3945.07)},
}

-- 🔽 Fungsi bikin tombol teleport otomatis 🔽
local function makeTeleportButton(name, pos)
    local tpButton = Instance.new("TextButton")
    tpButton.Size = UDim2.new(0, 140, 0, 35)
    tpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tpButton.Text = name
    tpButton.TextColor3 = Color3.new(1, 1, 1)
    tpButton.Font = Enum.Font.SourceSansBold
    tpButton.TextSize = 14
    tpButton.Parent = scrollFrame

    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 8)
    tpCorner.Parent = tpButton

    tpButton.MouseButton1Click:Connect(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Teleport karakter pemain ke posisi yang ditentukan
            character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
end

-- Buat semua tombol dari daftar
for _, data in ipairs(teleportList) do
    makeTeleportButton(data.name, data.pos)
end

---

## Logika Auto Farm (SUMMIT)

```lua
-- 🔽 AUTO FARM SYSTEM (Tombol SUMMIT) 🔽
local position1 = Vector3.new(625.27, 1799.83, 3432.84)
local position2 = Vector3.new(780.47, 2183.38, 3945.07)

local function teleportTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function autoFarmLoop()
    while teleporting do
        -- Teleport ke Pos 26
        teleportTo(position1)
        task.wait(2)
        
        -- Teleport ke PUNCAK
        teleportTo(position2)
        task.wait(1)
        
        -- Rejoin (TeleportService ke PlaceId yang sama)
        TeleportService:Teleport(game.PlaceId, player) 
        
        -- Hentikan loop setelah permintaan rejoin
        break 
    end
end

local function toggleAutoFarm(state)
    teleporting = state
    statusValue.Value = state
    
    if teleporting then
        button.Text = "SUMMIT: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        -- Memulai loop di thread terpisah
        task.spawn(autoFarmLoop) 
    else
        button.Text = "SUMMIT: OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        -- Catatan: Mengklik OFF setelah loop dimulai mungkin tidak langsung menghentikan karena adanya TeleportService:Teleport
    end
end

-- Atur status awal tombol
toggleAutoFarm(false) 

button.MouseButton1Click:Connect(function()
    toggleAutoFarm(not teleporting)
end)
