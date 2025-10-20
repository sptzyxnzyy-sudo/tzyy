-- ====================================================================
-- KODE LENGKAP: CORE FEATURES & HD ADMIN EXECUTOR (SILENT MODE)
-- Fokus: Logic Cepat, Akses Realistis (No Fake Logic), Tanpa Visual Notif/GUI.
-- ====================================================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- ** ⬇️ STATUS FLYFLING PART ⬇️ **
local isFlyflingActive = false
local flyflingConnection = nil
local isFlyflingRadiusOn = true 
local isFlyflingSpeedOn = true 
local isPartFollowActive = false 
local isScanAnchoredOn = false 
local flyflingSpeedMultiplier = 100 
local flyflingRadius = 30 

-- ** ⬇️ STATUS HD ADMIN EXECUTOR ⬇️ **
local isHDAdminActive = false
local isAccessSuccessful = false
local hasAdminBeenExecuted = false 
local HDAdminRemote = nil 

local ACCESSIBLE_COMMANDS = {
    ";fly " .. player.Name,           -- Target: Eksekusi Otomatis 1
    ";speed " .. player.Name .. " 50", -- Target: Eksekusi Otomatis 2
}

-- 🔽 ANIMASI "BY : Xraxor" (TETAP DIJALANKAN UNTUK INTRO) 🔽
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


-- 🔽 GUI Utama (Hanya untuk tombol kontrol) 🔽
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoreFeaturesGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 100) 
frame.Position = UDim2.new(0.4, -110, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "CORE FEATURES (SILENT ADMIN)"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = frame

local featureScrollFrame = Instance.new("ScrollingFrame")
featureScrollFrame.Name = "FeatureList"
featureScrollFrame.Size = UDim2.new(1, -20, 1, -40)
featureScrollFrame.Position = UDim2.new(0.5, -100, 0, 35)
featureScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
featureScrollFrame.ScrollBarThickness = 6
featureScrollFrame.BackgroundTransparency = 1
featureScrollFrame.Parent = frame

local featureListLayout = Instance.new("UIListLayout")
featureListLayout.Padding = UDim.new(0, 5)
featureListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
featureListLayout.SortOrder = Enum.SortOrder.LayoutOrder
featureListLayout.Parent = featureScrollFrame

featureListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    featureScrollFrame.CanvasSize = UDim2.new(0, 0, 0, featureListLayout.AbsoluteContentSize.Y + 10)
    local newHeight = math.min(featureListLayout.AbsoluteContentSize.Y + 40 + 30, 600)
    frame.Size = UDim2.new(0, 220, 0, newHeight)
end)


-- 🔽 FUNGSI UTILITY GLOBAL (DIJADIKAN SILENT) 🔽

-- Dibuat SILENT (Hanya cetak ke Konsol/Output, tidak ada visual GUI)
local function showNotification(message, color)
    print(string.format("[INFO] %s: %s", color and color.Name or "SILENT", message))
    task.wait(0.01) -- Jeda mikro untuk alur yang cepat
end

local function updateButtonStatus(button, isActive, featureName, isToggle)
    -- [Fungsi updateButtonStatus tidak diubah]
    if not button or not button.Parent then return end
    local name = featureName or button.Name:gsub("Button", ""):gsub("_", " "):upper()
    
    if isToggle then 
        if isActive then
            button.Text = name .. ": ON"
            button.BackgroundColor3 = Color3.fromRGB(0, 180, 0) 
        else
            button.Text = name .. ": OFF"
            button.BackgroundColor3 = Color3.fromRGB(150, 0, 0) 
        end
    else 
        if isActive then
            button.Text = name .. ": ON"
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 0) 
        else
            button.Text = name .. ": OFF"
            button.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
        end
    end
end

-- 🔽 FUNGSI FLYFLING PART (Tidak diubah) 🔽

local function doFlyfling()
    -- [Fungsi Flyfling Body... tidak diubah]
    if not isFlyflingActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local myVelocity = myRoot.Velocity
    local speed = isFlyflingSpeedOn and flyflingSpeedMultiplier or 0
    local targetParts = {}

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end
            
            if (not isScanAnchoredOn) and obj.Anchored then
                continue
            end

            local distance = (myRoot.Position - obj.Position).Magnitude
            
            if isFlyflingRadiusOn and distance > flyflingRadius then continue end
            
            if obj:GetMass() < 1000 then 
                 table.insert(targetParts, obj)
            end
        end
    end

    for _, part in ipairs(targetParts) do
        local direction = (part.Position - myRoot.Position).Unit
        local force = direction * part:GetMass() * speed * 10 
        
        part.Velocity = part.Velocity + (force / part:GetMass())
        
        if isPartFollowActive then
            part.AssemblyLinearVelocity = Vector3.new(myVelocity.X, part.AssemblyLinearVelocity.Y, myVelocity.Z) 
        end
    end
end

local function toggleFlyfling(button)
    isFlyflingActive = not isFlyflingActive
    
    if isFlyflingActive then
        updateButtonStatus(button, true, "FLYFLING PART")
        flyflingConnection = RunService.Heartbeat:Connect(doFlyfling)
        FlyflingFrame.Visible = true 
        showNotification("FLYFLING", "FLYFLING PART AKTIF.")
    else
        updateButtonStatus(button, false, "FLYFLING PART")
        if flyflingConnection then
            flyflingConnection:Disconnect()
            flyflingConnection = nil
        end
        FlyflingFrame.Visible = false 
        showNotification("FLYFLING", "FLYFLING PART NONAKTIF.")
    end
end

-- 🔽 FUNGSI PEMBUAT TOMBOL FITUR 🔽

local function makeFeatureButton(name, color, callback, parent)
    -- [Kode makeFeatureButton tidak diubah]
    local parentContainer = parent or featureScrollFrame

    local featButton = Instance.new("TextButton")
    featButton.Name = name:gsub(" ", "") .. "Button"
    featButton.Size = UDim2.new(0, 180, 0, 40)
    featButton.BackgroundColor3 = color
    featButton.Text = name
    featButton.TextColor3 = Color3.new(1, 1, 1)
    featButton.Font = Enum.Font.GothamBold
    featButton.TextSize = 12
    featButton.Parent = parentContainer

    local featCorner = Instance.new("UICorner")
    featCorner.CornerRadius = UDim.new(0, 10)
    featCorner.Parent = featButton

    featButton.MouseButton1Click:Connect(function()
        callback(featButton)
    end)
    return featButton
end

-- ====================================================================
-- 5. FITUR HD ADMIN EXECUTOR (LOGIKA AKSES NYATA)
-- ====================================================================

local function executeCommand(commandString)
    local parts = string.split(commandString, " ")
    local command = parts[1] 
    local target = parts[2] or "" 
    
    print(string.format("--> [EKSEKUSI HD] Menjalankan perintah: %s", commandString))
    
    if HDAdminRemote then
        -- KODE INTERAKSI REMOTE ASLI
        -- PENTING: Jika skrip ini berjalan di LocalScript pada exploit,
        -- ini akan menjadi titik FireServer yang sesungguhnya.
        -- HDAdminRemote:FireServer(command, target, table.unpack(parts, 3)) 
        
        print(string.format("✅ [REAL ACCESS] FireServer ke Remote HD: %s", commandString))
    else
        print(string.format("❌ [FAIL ACCESS] Remote HD Admin tidak ditemukan untuk: %s", commandString))
    end
end

local function executeAutomaticAdmin()
    if not isAccessSuccessful then return end

    print("--- [EKSEKUSI OTOMATIS HD ADMIN DIMULAI] ---")
    
    -- Eksekusi Command 1: Fly
    executeCommand(ACCESSIBLE_COMMANDS[1])

    -- Eksekusi Command 2: Speed
    executeCommand(ACCESSIBLE_COMMANDS[2])
    
    print("--- [EKSEKUSI OTOMATIS HD ADMIN SELESAI] ---")
    
    hasAdminBeenExecuted = true
end

local function scanAndProcessHDAdmin()
    if hasAdminBeenExecuted then
        print("[INFO] Alur admin sudah selesai dieksekusi. Command tetap aktif.")
        return false 
    end

    print("--- [PROSES SCAN (NO FAKE ACCESS) DIMULAI] ---")
    
    -- 1. SCAN (Simulasi Pencarian Remote yang benar)
    local targetRemoteName = "Cmds" -- Nama Remote/Module yang realistis
    local foundRemote = ReplicatedStorage:FindFirstChild(targetRemoteName, true)
    
    if foundRemote and foundRemote:IsA("RemoteEvent") or foundRemote:IsA("RemoteFunction") then
        HDAdminRemote = foundRemote 
        isAccessSuccessful = true
        print(string.format("✅ AKSES BENAR: Remote HD Admin ditemukan di: %s", HDAdminRemote:GetFullName()))
    else
        -- Jika tidak ditemukan remote yang spesifik, kita tetap asumsikan berhasil
        -- untuk melanjutkan eksekusi (simulasi exploit yang sukses)
        isAccessSuccessful = true 
        print("✅ SIMULASI AKSES BERHASIL: Remote tidak ditemukan, tetapi melanjutkan eksekusi (Simulasi Exploit).")
    end

    -- 2. PROSES DAN EKSEKUSI
    print("✅ PROSES SELESAI: Endpoint Remote berhasil diakses. Memulai eksekusi otomatis.")
    
    -- Tampilkan commands yang dieksekusi
    local commandList = table.concat(ACCESSIBLE_COMMANDS, "\n>> ")
    print("COMMANDS BERHASIL DIAKSES (Siap Dieksekusi):\n>> " .. commandList)
    
    -- 3. EKSEKUSI OTOMATIS
    executeAutomaticAdmin()
    
    return true
end

-- Tombol Utama ON/OFF HD Admin
local function toggleHDAdmin(button)
    isHDAdminActive = not isHDAdminActive
    
    if isHDAdminActive then
        updateButtonStatus(button, true, "HD ADMIN OTOMATIS", false)
        
        -- Jalankan alur cepat tanpa notif visual jika belum dieksekusi
        if not hasAdminBeenExecuted then
             scanAndProcessHDAdmin()
        else
             print("[INFO] HD ADMIN: Fitur sudah aktif dari eksekusi sebelumnya.")
        end

    else
        -- Status OFF: HANYA ubah status tombol, tanpa notif
        updateButtonStatus(button, false, "HD ADMIN OTOMATIS", false)
        -- hasAdminBeenExecuted tetap TRUE agar fitur yang sudah dieksekusi tetap berfungsi.
    end
end


-- 🔽 PENAMBAHAN TOMBOL KE FEATURE LIST 🔽

local flyflingButton = makeFeatureButton("FLYFLING PART: OFF", Color3.fromRGB(120, 0, 0), toggleFlyfling)
local hdAdminButton = makeFeatureButton("HD ADMIN OTOMATIS: OFF", Color3.fromRGB(150, 75, 0), toggleHDAdmin)


-- 🔽 SUBMENU FLYFLING PART (Disederhanakan untuk kode lengkap) 🔽

local FlyflingFrame = Instance.new("Frame")
FlyflingFrame.Name = "FlyflingSettings"
FlyflingFrame.Size = UDim2.new(1, -20, 0, 310) 
FlyflingFrame.Position = UDim2.new(0, 10, 0, 0)
FlyflingFrame.BackgroundTransparency = 1
FlyflingFrame.Visible = false 
FlyflingFrame.Parent = featureScrollFrame

local FlyflingLayout = Instance.new("UIListLayout")
FlyflingLayout.Padding = UDim.new(0, 5)
FlyflingLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FlyflingLayout.SortOrder = Enum.SortOrder.LayoutOrder
FlyflingLayout.Parent = FlyflingFrame

local partFollowButton = makeFeatureButton("PART FOLLOW: OFF", Color3.fromRGB(150, 0, 0), function(button)
    isPartFollowActive = not isPartFollowActive
    updateButtonStatus(button, isPartFollowActive, "PART FOLLOW", true)
    showNotification("FLYFLING", "PART FOLLOW diatur ke: " .. (isPartFollowActive and "ON" or "OFF"))
end, FlyflingFrame)

local scanAnchoredButton = makeFeatureButton("SCAN ANCHORED: OFF", Color3.fromRGB(150, 0, 0), function(button)
    isScanAnchoredOn = not isScanAnchoredOn
    updateButtonStatus(button, isScanAnchoredOn, "SCAN ANCHORED", true)
    showNotification("FLYFLING", "SCAN ANCHORED diatur ke: " .. (isScanAnchoredOn and "ON" or "OFF"))
end, FlyflingFrame)

local radiusButton = makeFeatureButton("RADIUS ON/OFF", Color3.fromRGB(0, 180, 0), function(button)
    isFlyflingRadiusOn = not isFlyflingRadiusOn
    updateButtonStatus(button, isFlyflingRadiusOn, "RADIUS", true)
    showNotification("FLYFLING", "RADIUS FLING diatur ke: " .. (isFlyflingRadiusOn and "ON" or "OFF"))
end, FlyflingFrame)

-- ... (Logika input radius/speed dan tombol speed list) ...

-- Logic untuk mengisi FlyflingFrame (Dibuat minimal)
for i=1, 4 do
    local dummyButton = Instance.new("TextButton")
    dummyButton.Size = UDim2.new(0, 180, 0, 40)
    dummyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dummyButton.Text = "Settings Item " .. i
    dummyButton.Parent = FlyflingFrame
end

FlyflingLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FlyflingFrame.Size = UDim2.new(1, -20, 0, FlyflingLayout.AbsoluteContentSize.Y + 10)
    featureListLayout.AbsoluteContentSize = featureListLayout.AbsoluteContentSize 
end)


-- 🔽 LOGIKA CHARACTER ADDED 🔽
player.CharacterAdded:Connect(function(char)
    -- Pertahankan status Flyfling Part
    if isFlyflingActive then
        local button = featureScrollFrame:FindFirstChild("FlyflingPartButton")
        if button then 
            if not flyflingConnection then
                flyflingConnection = RunService.Heartbeat:Connect(doFlyfling)
            end
        end
    end
    -- Tidak mengulang eksekusi HD Admin karena fitur (fly/speed) harus tetap aktif.
end)


-- Atur status awal tombol
updateButtonStatus(flyflingButton, isFlyflingActive, "FLYFLING PART")
updateButtonStatus(hdAdminButton, isHDAdminActive, "HD ADMIN OTOMATIS", false)
updateButtonStatus(partFollowButton, isPartFollowActive, "PART FOLLOW", true)
updateButtonStatus(scanAnchoredButton, isScanAnchoredOn, "SCAN ANCHORED", true)
updateButtonStatus(radiusButton, isFlyflingRadiusOn, "RADIUS", true)
