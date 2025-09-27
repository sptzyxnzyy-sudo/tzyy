--[[
    Skrip Teleport Roblox yang Ditingkatkan dengan Fitur Jahil
    
    Fitur Baru yang Ditambahkan:
    - Jahilan Ping Palsu (Fake Latency)
    - Jahilan Chat Otomatis (Auto Chat)
    
    Kredit: Xraxor1 (Basis skrip asli)
    Peningkatan: Gemini
--]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui") -- Untuk Jahilan Chat

local player = Players.LocalPlayer

-- Variabel status untuk fitur jahil
local isFakePingActive = false
local isAutoChatActive = false

-- Fungsi utilitas untuk teleport yang aman
local function teleportTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- --- ANIMASI "BY : Xraxor" --- (Dibiarkan sama)
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

-- --- Status AutoFarm --- (Dibiarkan sama)
local statusValue = ReplicatedStorage:FindFirstChild("AutoFarmStatus")
if not statusValue then
    statusValue = Instance.new("BoolValue")
    statusValue.Name = "AutoFarmStatus"
    statusValue.Value = false
    statusValue.Parent = ReplicatedStorage
end

-- --- GUI Utama ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EnhancedGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 270) -- Ukuran ditingkatkan untuk tombol Trolling
frame.Position = UDim2.new(0.4, -110, 0.5, -135) -- Posisi disesuaikan
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

-- Tombol SUMMIT (Auto Farm)
local summitButton = Instance.new("TextButton")
summitButton.Name = "SummitButton"
summitButton.Size = UDim2.new(0, 160, 0, 40)
summitButton.Position = UDim2.new(0.5, -80, 0.5, -80)
summitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
summitButton.Text = "SUMMIT"
summitButton.TextColor3 = Color3.new(1, 1, 1)
summitButton.Font = Enum.Font.GothamBold
summitButton.TextSize = 15
summitButton.Parent = frame

local summitButtonCorner = Instance.new("UICorner")
summitButtonCorner.CornerRadius = UDim.new(0, 10)
summitButtonCorner.Parent = summitButton

-- Tombol TELEPORT KE PEMAIN
local tpPlayerButton = Instance.new("TextButton")
tpPlayerButton.Name = "TeleportPlayerButton"
tpPlayerButton.Size = UDim2.new(0, 160, 0, 40)
tpPlayerButton.Position = UDim2.new(0.5, -80, 0.5, 0)
tpPlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpPlayerButton.Text = "TELEPORT KE PEMAIN"
tpPlayerButton.TextColor3 = Color3.new(1, 1, 1)
tpPlayerButton.Font = Enum.Font.GothamBold
tpPlayerButton.TextSize = 14
tpPlayerButton.Parent = frame

local tpPlayerButtonCorner = Instance.new("UICorner")
tpPlayerButtonCorner.CornerRadius = UDim.new(0, 10)
tpPlayerButtonCorner.Parent = tpPlayerButton

-- Tombol JAHIL (Trolling) (BARU)
local trollButton = Instance.new("TextButton")
trollButton.Name = "TrollButton"
trollButton.Size = UDim2.new(0, 160, 0, 40)
trollButton.Position = UDim2.new(0.5, -80, 0.5, 80)
trollButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
trollButton.Text = "FITUR JAHIL"
trollButton.TextColor3 = Color3.new(1, 1, 1)
trollButton.Font = Enum.Font.GothamBold
trollButton.TextSize = 15
trollButton.Parent = frame

local trollButtonCorner = Instance.new("UICorner")
trollButtonCorner.CornerRadius = UDim.new(0, 10)
trollButtonCorner.Parent = trollButton

-- --- Tombol dan Frame Samping Posisi dan Pemain (Dibiarkan sama) ---

local flagButton = Instance.new("ImageButton")
flagButton.Name = "PosFlagButton"
flagButton.Size = UDim2.new(0, 20, 0, 20)
flagButton.Position = UDim2.new(1, -30, 0, 5)
flagButton.BackgroundTransparency = 1
flagButton.Image = "rbxassetid://6031097229" 
flagButton.Parent = frame

local posSideFrame = Instance.new("Frame")
posSideFrame.Name = "PosSideFrame"
posSideFrame.Size = UDim2.new(0, 170, 0, 200)
posSideFrame.Position = UDim2.new(1, 10, 0, 0)
posSideFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
posSideFrame.Visible = false
posSideFrame.Parent = frame

-- (Logika dan konten posSideFrame sama seperti sebelumnya)
local posScrollFrame = Instance.new("ScrollingFrame")
posScrollFrame.Size = UDim2.new(1, 0, 1, -5)
posScrollFrame.Position = UDim2.new(0, 0, 0, 5)
posScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
posScrollFrame.ScrollBarThickness = 6
posScrollFrame.BackgroundTransparency = 1
posScrollFrame.Parent = posSideFrame

local posListLayout = Instance.new("UIListLayout")
posListLayout.Padding = UDim.new(0, 5)
posListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
posListLayout.SortOrder = Enum.SortOrder.LayoutOrder
posListLayout.Parent = posScrollFrame

posListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    posScrollFrame.CanvasSize = UDim2.new(0, 0, 0, posListLayout.AbsoluteContentSize.Y + 10)
end)

flagButton.MouseButton1Click:Connect(function()
    posSideFrame.Visible = not posSideFrame.Visible
end)

local teleportList = {
    {name = "Teleport Pos 1", pos = Vector3.new(5.91, 13.20, -401.66)},
    {name = "PUNCAK", pos = Vector3.new(780.47, 2183.38, 3945.07)},
}
local function makeTeleportButton(name, pos)
    local tpButton = Instance.new("TextButton")
    -- (Properti dan koneksi tombol teleport posisi)
    tpButton.Size = UDim2.new(0, 140, 0, 35)
    tpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tpButton.Text = name
    tpButton.TextColor3 = Color3.new(1, 1, 1)
    tpButton.Font = Enum.Font.SourceSansBold
    tpButton.TextSize = 14
    tpButton.Parent = posScrollFrame
    Instance.new("UICorner").Parent = tpButton
    tpButton.MouseButton1Click:Connect(function()
        teleportTo(pos)
    end)
end
for _, data in ipairs(teleportList) do
    makeTeleportButton(data.name, data.pos)
end


local playerButton = Instance.new("ImageButton")
playerButton.Name = "PlayerFlagButton"
playerButton.Size = UDim2.new(0, 20, 0, 20)
playerButton.Position = UDim2.new(1, -30, 0, 45) -- Disesuaikan
playerButton.BackgroundTransparency = 1
playerButton.Image = "rbxassetid://5494191480" 
playerButton.Parent = frame

local playerSideFrame = Instance.new("Frame")
playerSideFrame.Name = "PlayerSideFrame"
playerSideFrame.Size = UDim2.new(0, 170, 0, 200)
playerSideFrame.Position = UDim2.new(1, 10, 0, 40) -- Disesuaikan
playerSideFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
playerSideFrame.Visible = false
playerSideFrame.Parent = frame

-- (Logika dan konten playerSideFrame sama seperti sebelumnya)
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

tpPlayerButton.MouseButton1Click:Connect(function()
    playerSideFrame.Visible = not playerSideFrame.Visible
end)
playerButton.MouseButton1Click:Connect(function()
    playerSideFrame.Visible = not playerSideFrame.Visible
end)

local function makePlayerTeleportButton(targetPlayer)
    if targetPlayer == player then return end 
    local tpButton = Instance.new("TextButton")
    -- (Properti dan koneksi tombol teleport pemain)
    tpButton.Size = UDim2.new(0, 140, 0, 35)
    tpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tpButton.Text = targetPlayer.Name
    tpButton.TextColor3 = Color3.new(1, 1, 1)
    tpButton.Font = Enum.Font.SourceSansBold
    tpButton.TextSize = 14
    tpButton.Parent = playerScrollFrame
    Instance.new("UICorner").Parent = tpButton
    tpButton.MouseButton1Click:Connect(function()
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            teleportTo(targetPos)
        end
    end)
end
local function updatePlayerList()
    for _, child in ipairs(playerScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            makePlayerTeleportButton(targetPlayer)
        end
    end
end
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- --- AUTO FARM SYSTEM (Dibiarkan sama) ---
local position1 = Vector3.new(625.27, 1799.83, 3432.84)
local position2 = Vector3.new(780.47, 2183.38, 3945.07)
local teleporting = false
local function autoFarmLoop()
    if teleporting then
        teleportTo(position1)
        task.wait(2)
        teleportTo(position2)
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, player)
    end
end
local function toggleAutoFarm(state)
    teleporting = state
    statusValue.Value = state
    if teleporting then
        summitButton.Text = "RUNNING..."
        summitButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.spawn(autoFarmLoop)
    else
        summitButton.Text = "SUMMIT"
        summitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end
summitButton.MouseButton1Click:Connect(function()
    toggleAutoFarm(not teleporting)
end)

---
## FITUR JAHIL (TROLING) BARU
---

-- --- GUI Samping Jahil ---
local trollFlagButton = Instance.new("ImageButton")
trollFlagButton.Name = "TrollFlagButton"
trollFlagButton.Size = UDim2.new(0, 20, 0, 85) -- Disesuaikan
trollFlagButton.Position = UDim2.new(1, -30, 0, 85)
trollFlagButton.BackgroundTransparency = 1
trollFlagButton.Image = "rbxassetid://6031097229" -- Ikon
trollFlagButton.Parent = frame

local trollSideFrame = Instance.new("Frame")
trollSideFrame.Name = "TrollSideFrame"
trollSideFrame.Size = UDim2.new(0, 180, 0, 150)
trollSideFrame.Position = UDim2.new(1, 10, 0, 80) -- Disesuaikan
trollSideFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
trollSideFrame.Visible = false
trollSideFrame.Parent = frame

local trollSideCorner = Instance.new("UICorner")
trollSideCorner.CornerRadius = UDim.new(0, 12)
trollSideCorner.Parent = trollSideFrame

local trollListLayout = Instance.new("UIListLayout")
trollListLayout.Padding = UDim.new(0, 5)
trollListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
trollListLayout.SortOrder = Enum.SortOrder.LayoutOrder
trollListLayout.Parent = trollSideFrame

trollButton.MouseButton1Click:Connect(function()
    trollSideFrame.Visible = not trollSideFrame.Visible
end)
trollFlagButton.MouseButton1Click:Connect(function()
    trollSideFrame.Visible = not trollSideFrame.Visible
end)

-- --- FUNGSI JAHIL ---

-- 🔽 1. Laporan Ping Palsu (Fake Latency Indicator) 🔽
local fakePingButton = Instance.new("TextButton")
fakePingButton.Name = "FakePingButton"
fakePingButton.Size = UDim2.new(0, 160, 0, 35)
fakePingButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fakePingButton.Text = "PING PALSU: OFF"
fakePingButton.TextColor3 = Color3.new(1, 1, 1)
fakePingButton.Font = Enum.Font.SourceSansBold
fakePingButton.TextSize = 14
fakePingButton.Parent = trollSideFrame
Instance.new("UICorner").Parent = fakePingButton

local function findPingDisplay()
    -- Mencoba mencari display ping yang umum (di Roblox CoreGui)
    -- Ini sangat tergantung pada game, tapi kita akan coba cari yang paling umum: PlayerGui
    -- Kadang display ping ada di ScreenGui bernama "PerformanceStats" atau sejenisnya.
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        -- Fungsi ini mungkin harus disesuaikan dengan GUI spesifik di game Anda
        local statsGui = playerGui:FindFirstChild("PerformanceStats") 
        if statsGui then 
            return statsGui:FindFirstChild("PingLabel") -- Asumsi ada label ping
        end
    end
    return nil
end

local function toggleFakePing()
    isFakePingActive = not isFakePingActive
    fakePingButton.Text = "PING PALSU: " .. (isFakePingActive and "ON" or "OFF")
    fakePingButton.BackgroundColor3 = isFakePingActive and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
    
    local originalPingText = ""
    local pingLabel = findPingDisplay()
    
    if isFakePingActive and pingLabel and pingLabel:IsA("TextLabel") then
        originalPingText = pingLabel.Text -- Simpan teks asli
        task.spawn(function()
            while isFakePingActive and pingLabel and pingLabel:IsA("TextLabel") do
                -- Set ping palsu
                local fakePing = math.random(700, 1000)
                pingLabel.Text = "Ping: " .. fakePing .. " ms"
                task.wait(math.random(0.1, 0.5))
            end
            -- Kembalikan teks asli saat dimatikan
            if pingLabel and pingLabel:IsA("TextLabel") then
                pingLabel.Text = originalPingText
            end
        end)
    elseif not isFakePingActive and pingLabel and pingLabel:IsA("TextLabel") then
        -- Jika dimatikan, coba kembalikan ke nilai normal (atau biarkan sistem game menimpanya)
        pingLabel.Text = "Ping: Loading..." -- Sistem game biasanya akan segera menimpanya
    end
end

fakePingButton.MouseButton1Click:Connect(toggleFakePing)


-- 🔽 2. Pesan Otomatis yang Menggiring (Subtle Auto Chat) 🔽
local autoChatButton = Instance.new("TextButton")
autoChatButton.Name = "AutoChatButton"
autoChatButton.Size = UDim2.new(0, 160, 0, 35)
autoChatButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoChatButton.Text = "AUTO CHAT: OFF"
autoChatButton.TextColor3 = Color3.new(1, 1, 1)
autoChatButton.Font = Enum.Font.SourceSansBold
autoChatButton.TextSize = 14
autoChatButton.Parent = trollSideFrame
Instance.new("UICorner").Parent = autoChatButton

local chatMessages = {
    "Aku merasa sedikit aneh hari ini...",
    "Apakah ada yang baru saja melihat sesuatu?",
    "Game ini mulai agak lag ya, padahal pingku bagus.",
    "Bisa tolong teleport aku? Aku tersesat.",
    "Aku rasa aku tidak sendirian di sini.",
}

local function autoChatLoop()
    while isAutoChatActive do
        -- Kirim pesan chat melalui LocalScript. 
        -- Metode ini hanya berfungsi jika game masih menggunakan sistem chat lama atau tidak memfilter coregui.
        local message = chatMessages[math.random(1, #chatMessages)]
        
        -- Ini adalah cara untuk memicu pesan dari klien, agar terlihat seperti kita yang mengetik:
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = message,
            Color = Color3.fromRGB(200, 200, 200), -- Warna abu-abu agar terlihat seperti pesan sistem
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size14,
        })
        
        -- Cara yang lebih baik untuk mengirim sebagai pemain (jika game memungkinkan)
        -- Jika game menggunakan RemoteEvent untuk chat:
        -- game:GetService("ReplicatedStorage").RemoteEventChat:FireServer(message)
        
        -- Untuk tujuan jahil, kita bisa menggunakan SetCore untuk menirukan output chat di layar kita.
        
        -- Interval acak dan jarang (120 hingga 300 detik atau 2-5 menit)
        task.wait(math.random(120, 300)) 
    end
end

local function toggleAutoChat()
    isAutoChatActive = not isAutoChatActive
    autoChatButton.Text = "AUTO CHAT: " .. (isAutoChatActive and "ON" or "OFF")
    autoChatButton.BackgroundColor3 = isAutoChatActive and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
    
    if isAutoChatActive then
        task.spawn(autoChatLoop)
    end
end

autoChatButton.MouseButton1Click:Connect(toggleAutoChat)
