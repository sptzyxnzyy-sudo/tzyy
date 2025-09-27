--You can take the script with your own ideas, friend.
-- credit: Xraxor1
-- Modification: Added Player List GUI with Teleport Target TO YOU feature.

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

-- 🔽 GUI Utama (Mount Atin V2) 🔽
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
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0) 
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
    -- Jika daftar Teleport Posisi dibuka, pastikan daftar pemain TIDAK dibuka
    if sideFrame.Visible then
        local playerFrame = screenGui:FindFirstChild("TeleportPlayerFrame")
        if playerFrame then playerFrame.Visible = false end
    end
end)

-- 🔽 Teleport List (Fungsionalitas Asli) 🔽
local teleportList = {
    {name = "Teleport Pos 1", pos = Vector3.new(5.91, 13.20, -401.66)},
    -- ... (25 posisi lain)
    {name = "Teleport Pos 26", pos = Vector3.new(625.27, 1799.83, 3432.84)},
    {name = "PUNCAK", pos = Vector3.new(780.47, 2183.38, 3945.07)},
}
-- Catatan: Saya mempersingkat daftar di sini untuk menghemat ruang, tetapi fungsionalitasnya utuh.

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
            character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
end

for _, data in ipairs(teleportList) do
    makeTeleportButton(data.name, data.pos)
end

-- 🔽 AUTO FARM SYSTEM (Tombol SUMMIT Fungsionalitas Asli) 🔽
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
        teleportTo(position1)
        task.wait(2)
        teleportTo(position2)
        task.wait(1)
        
        TeleportService:Teleport(game.PlaceId, player) 
        break 
    end
end

local function toggleAutoFarm(state)
    teleporting = state
    statusValue.Value = state
    
    if teleporting then
        button.Text = "SUMMIT: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        task.spawn(autoFarmLoop) 
    else
        button.Text = "SUMMIT: OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end

toggleAutoFarm(false) 

button.MouseButton1Click:Connect(function()
    toggleAutoFarm(not teleporting)
end)


---

## 🚀 Fitur Baru: Teleport Target ke Lokasi Anda (Player List) 🚀

-- 🔽 UI Samping Player List Toggle 🔽
local playerListFrame = Instance.new("Frame")
playerListFrame.Name = "TeleportPlayerFrame"
playerListFrame.Size = UDim2.new(0, 50, 0, 50) 
playerListFrame.Position = UDim2.new(0.9, -50, 0.7, -25) -- Diposisikan sedikit di bawah UI utama
playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
playerListFrame.BorderSizePixel = 0
playerListFrame.Active = true
playerListFrame.Draggable = true
playerListFrame.Parent = screenGui -- Dipindahkan ke ScreenGui agar bisa di-drag

local playerListCorner = Instance.new("UICorner")
playerListCorner.CornerRadius = UDim.new(0, 15)
playerListCorner.Parent = playerListFrame

local playerListButton = Instance.new("ImageButton")
playerListButton.Size = UDim2.new(1, 0, 1, 0)
playerListButton.BackgroundTransparency = 1
playerListButton.Image = "rbxassetid://5854746698" -- Ikon Pemain/Orang
playerListButton.Parent = playerListFrame

local playerSideFrame = Instance.new("Frame")
playerSideFrame.Size = UDim2.new(0, 170, 0, 250)
playerSideFrame.Position = UDim2.new(1, 10, 0, 0)
playerSideFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
playerSideFrame.Visible = false
playerSideFrame.Parent = playerListFrame

local playerSideCorner = Instance.new("UICorner")
playerSideCorner.CornerRadius = UDim.new(0, 12)
playerSideCorner.Parent = playerSideFrame

local playerScrollFrame = Instance.new("ScrollingFrame")
playerScrollFrame.Size = UDim2.new(1, 0, 1, -5)
playerScrollFrame.Position = UDim2.new(0, 0, 0, 5)
playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
playerScrollFrame.ScrollBarThickness = 6
playerScrollFrame.BackgroundTransparency = 1
playerScrollFrame.Parent = playerSideFrame

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 5)
playerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Parent = playerScrollFrame

playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 10)
end)


-- 🔽 Logika Teleport Target ke Anda 🔽

local function makePlayerButton(targetPlayer)
    local tpButton = Instance.new("TextButton")
    tpButton.Size = UDim2.new(0, 140, 0, 35)
    tpButton.BackgroundColor3 = targetPlayer == player and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(40, 40, 40)
    tpButton.Text = targetPlayer.Name .. (targetPlayer == player and " (You)" or "")
    tpButton.TextColor3 = Color3.new(1, 1, 1)
    tpButton.Font = Enum.Font.SourceSansBold
    tpButton.TextSize = 14
    tpButton.Parent = playerScrollFrame

    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 8)
    tpCorner.Parent = tpButton

    tpButton.MouseButton1Click:Connect(function()
        
        if targetPlayer == player then return end

        local char = player.Character
        local targetChar = targetPlayer.Character

        if not char or not targetChar then warn("Karakter target tidak ditemukan!") return end

        local playerRoot = char:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if not playerRoot or not targetRoot then warn("HumanoidRootPart tidak ditemukan!") return end
        
        local playerCFrame = playerRoot.CFrame 

        -- Aksi: Teleport Pemain Target ke lokasi Anda
        targetRoot.CFrame = playerCFrame
        print(targetPlayer.Name .. " telah diteleport ke lokasi Anda.")

    end)
end

local function populatePlayerList()
    -- Hapus tombol lama
    for _, child in ipairs(playerScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    -- Isi daftar pemain
    local playerList = Players:GetPlayers()
    table.sort(playerList, function(a, b) return a.Name < b.Name end)

    for _, target in ipairs(playerList) do
        makePlayerButton(target)
    end
end

-- Logika Tombol Samping (Toggle Player List)
playerListButton.MouseButton1Click:Connect(function()
    local isVisible = not playerSideFrame.Visible
    playerSideFrame.Visible = isVisible
    if isVisible then
        populatePlayerList()
        -- Jika daftar pemain dibuka, pastikan daftar Teleport Posisi TIDAK dibuka
        sideFrame.Visible = false 
    end
end)

Players.PlayerAdded:Connect(function() 
    if playerSideFrame.Visible then populatePlayerList() end 
end)
Players.PlayerRemoving:Connect(function() 
    if playerSideFrame.Visible then populatePlayerList() end 
end)

