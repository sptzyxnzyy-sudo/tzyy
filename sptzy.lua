local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
-- local UserInputService = game:GetService("UserInputService") -- Tidak digunakan

local player = Players.LocalPlayer

-- ** ⬇️ STATUS FITUR FLYFLING PART ⬇️ **
local isFlyflingActive = false
local flyflingConnection = nil
local isFlyflingRadiusOn = true 
local isFlyflingSpeedOn = true 
local isPartFollowActive = false 
local isScanAnchoredOn = false -- Status untuk scan anchored parts
local flyflingSpeedMultiplier = 100 -- DIUBAH: Default langsung 100x
local flyflingRadius = 30 -- DIUBAH: Default langsung 30

-- ** ⬇️ STATUS FITUR BRING PART BARU ⬇️ **
local isBringPartActive = false -- Status aktif/nonaktif Bring Part
local bringPartConnection = nil
local isBringPartRadiusOn = true 
local bringPartRadius = 50 -- Radius default untuk Bring Part
local bringPartMaxMass = 5000 -- Batas massa part yang bisa dibawa


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


-- 🔽 GUI Utama 🔽
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoreFeaturesGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama 
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

-- Judul GUI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "CORE FEATURES"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- ScrollingFrame untuk Daftar Pilihan Fitur
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


-- 🔽 FUNGSI UTILITY GLOBAL 🔽

-- FUNGSI BARU: Notifikasi dengan Animasi
local function showNotification(message)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "Notification"
    notifGui.ResetOnSpawn = false
    notifGui.Parent = player:WaitForChild("PlayerGui")

    local notifLabel = Instance.new("TextLabel")
    notifLabel.Size = UDim2.new(0, 400, 0, 50)
    notifLabel.Position = UDim2.new(0.5, -200, 0.1, 0)
    notifLabel.BackgroundTransparency = 1
    notifLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    notifLabel.Text = message
    notifLabel.TextColor3 = Color3.new(1, 1, 1)
    notifLabel.TextScaled = true
    notifLabel.Font = Enum.Font.GothamBold
    notifLabel.Parent = notifGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifLabel

    -- Animation: Fade In (with background)
    local fadeIn = TweenService:Create(notifLabel, TweenInfo.new(0.3), {TextTransparency = 0, BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(0, 100, 200)})
    -- Animation: Fade Out (with background fade)
    local fadeOut = TweenService:Create(notifLabel, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})

    fadeIn:Play()
    fadeIn.Completed:Connect(function()
        task.wait(1.5)
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            notifGui:Destroy()
        end)
    end)
end

local function updateButtonStatus(button, isActive, featureName, isToggle)
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


-- 🔽 FUNGSI FLYFLING PART 🔽

local function doFlyfling()
    if not isFlyflingActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local myVelocity = myRoot.Velocity
    local speed = isFlyflingSpeedOn and flyflingSpeedMultiplier or 0
    local targetParts = {}

    -- Ambil semua part di Workspace
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        -- Cek kriteria: BasePart, bukan Baseplate, bukan bagian karakter/Humanoid
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            -- Lewati jika part tersebut adalah bagian dari karakter pemain lain atau NPC
            if Players:GetPlayerFromPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end
            
            -- ** MODIFIKASI: Mendukung Scan Anchored Parts **
            -- Lewati part yang ditambatkan (Anchored) KECUALI fitur Scan Anchored diaktifkan
            if (not isScanAnchoredOn) and obj.Anchored then
                continue
            end

            local distance = (myRoot.Position - obj.Position).Magnitude
            
            -- Cek Radius
            if isFlyflingRadiusOn and distance > flyflingRadius then continue end
            
            -- Batasi massa part
            if obj:GetMass() < 1000 then 
                 table.insert(targetParts, obj)
            end
        end
    end

    -- Terapkan Gaya
    for _, part in ipairs(targetParts) do
        local direction = (part.Position - myRoot.Position).Unit
        local force = direction * part:GetMass() * speed * 10 
        
        -- Fling: Dorongan menjauhi pemain (Hanya efektif pada part yang Unanchored)
        part.Velocity = part.Velocity + (force / part:GetMass())
        
        -- Part Follow: Membuat part mengikuti pemain
        if isPartFollowActive then
            -- Set kecepatan Part pada sumbu X dan Z agar sama dengan kecepatan pemain
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
        showNotification("FLYFLING PART AKTIF (Speed: " .. flyflingSpeedMultiplier .. "x, Radius: " .. flyflingRadius .. ")") -- NOTIFIKASI
        print("Flyfling Part AKTIF.")
    else
        updateButtonStatus(button, false, "FLYFLING PART")
        if flyflingConnection then
            flyflingConnection:Disconnect()
            flyflingConnection = nil
        end
        FlyflingFrame.Visible = false 
        showNotification("FLYFLING PART NONAKTIF.") -- NOTIFIKASI
        print("Flyfling Part NONAKTIF.")
    end
end


-- 🔽 FUNGSI BRING PART BARU 🔽

local function doBringPart()
    if not isBringPartActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local targetParts = {}
    local myPosition = myRoot.CFrame.Position
    -- Target 5 stud di depan pemain
    local targetPosition = myPosition + myRoot.CFrame.LookVector * 5 + Vector3.new(0, 1, 0) 

    -- Ambil semua part di Workspace
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        -- Cek kriteria: BasePart, bukan Baseplate, bukan bagian karakter/Humanoid
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            -- Lewati jika part tersebut adalah bagian dari karakter pemain lain atau NPC
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end
            
            local distance = (myPosition - obj.Position).Magnitude
            
            -- Cek Radius
            if isBringPartRadiusOn and distance > bringPartRadius then continue end
            
            -- Cek Batas Massa
            if obj:GetMass() <= bringPartMaxMass then 
                 table.insert(targetParts, obj)
            end
        end
    end

    -- Pindahkan Part
    for _, part in ipairs(targetParts) do
        -- ** Logika Utama: Unanchor dan Pindah **
        if part.Anchored then
            part.Anchored = false -- Penting: jadikan Unanchored
        end
        
        -- Set Network Owner ke pemain untuk kontrol yang lebih baik
        if part:CanSetNetworkOwnership() then
            part:SetNetworkOwner(player)
        end

        -- Tarik part ke posisi target
        local direction = (targetPosition - part.Position).Unit
        local speed = 50 -- Kecepatan tarik
        part.AssemblyLinearVelocity = direction * speed
    end
end

local function toggleBringPart(button)
    isBringPartActive = not isBringPartActive
    
    if isBringPartActive then
        updateButtonStatus(button, true, "BRING PART")
        bringPartConnection = RunService.Heartbeat:Connect(doBringPart)
        BringPartFrame.Visible = true 
        showNotification("BRING PART AKTIF (Radius: " .. bringPartRadius .. ", Max Mass: " .. bringPartMaxMass .. ")") 
        print("Bring Part AKTIF.")
    else
        updateButtonStatus(button, false, "BRING PART")
        if bringPartConnection then
            bringPartConnection:Disconnect()
            bringPartConnection = nil
        end
        BringPartFrame.Visible = false 
        showNotification("BRING PART NONAKTIF.")
        print("Bring Part NONAKTIF.")
    end
end


-- 🔽 FUNGSI PEMBUAT TOMBOL FITUR 🔽

local function makeFeatureButton(name, color, callback, parent)
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

-- 🔽 PENAMBAHAN TOMBOL KE FEATURE LIST 🔽

-- Tombol FLYFLING PART (Tombol Utama)
local flyflingButton = makeFeatureButton("FLYFLING PART: OFF", Color3.fromRGB(120, 0, 0), toggleFlyfling)

-- Tombol BRING PART BARU (Tombol Utama)
local bringPartButton = makeFeatureButton("BRING PART: OFF", Color3.fromRGB(120, 0, 0), toggleBringPart)

-- 🔽 SUBMENU FLYFLING PART (Frame) 🔽

local FlyflingFrame = Instance.new("Frame")
FlyflingFrame.Name = "FlyflingSettings"
FlyflingFrame.Size = UDim2.new(1, -20, 0, 310) -- Ukuran disesuaikan
FlyflingFrame.Position = UDim2.new(0, 10, 0, 0)
FlyflingFrame.BackgroundTransparency = 1
FlyflingFrame.Visible = false 
FlyflingFrame.Parent = featureScrollFrame

local FlyflingLayout = Instance.new("UIListLayout")
FlyflingLayout.Padding = UDim.new(0, 5)
FlyflingLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FlyflingLayout.SortOrder = Enum.SortOrder.LayoutOrder
FlyflingLayout.Parent = FlyflingFrame

-- Tombol PART FOLLOW
local partFollowButton = makeFeatureButton("PART FOLLOW: OFF", Color3.fromRGB(150, 0, 0), function(button)
    isPartFollowActive = not isPartFollowActive
    updateButtonStatus(button, isPartFollowActive, "PART FOLLOW", true)
    showNotification("PART FOLLOW diatur ke: " .. (isPartFollowActive and "ON" or "OFF")) -- NOTIFIKASI
end, FlyflingFrame)

-- Tombol SCAN ANCHORED
local scanAnchoredButton = makeFeatureButton("SCAN ANCHORED: OFF", Color3.fromRGB(150, 0, 0), function(button)
    isScanAnchoredOn = not isScanAnchoredOn
    updateButtonStatus(button, isScanAnchoredOn, "SCAN ANCHORED", true)
    showNotification("SCAN ANCHORED diatur ke: " .. (isScanAnchoredOn and "ON" or "OFF")) -- NOTIFIKASI
end, FlyflingFrame)


-- Tombol Radius ON/OFF
local radiusButton = makeFeatureButton("RADIUS ON/OFF", Color3.fromRGB(0, 180, 0), function(button)
    isFlyflingRadiusOn = not isFlyflingRadiusOn
    updateButtonStatus(button, isFlyflingRadiusOn, "RADIUS", true)
    showNotification("RADIUS FLING diatur ke: " .. (isFlyflingRadiusOn and "ON" or "OFF")) -- NOTIFIKASI
end, FlyflingFrame)

-- Input Jumlah Radius
local radiusInput = Instance.new("TextBox")
radiusInput.Name = "RadiusInput"
radiusInput.Size = UDim2.new(0, 180, 0, 40)
radiusInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
radiusInput.PlaceholderText = "Atur Radius: " .. tostring(flyflingRadius) 
radiusInput.Text = ""
radiusInput.TextColor3 = Color3.new(1, 1, 1)
radiusInput.Font = Enum.Font.Gotham
radiusInput.TextSize = 12
radiusInput.Parent = FlyflingFrame

radiusInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newRadius = tonumber(radiusInput.Text)
        if newRadius and newRadius >= 0 then
            flyflingRadius = newRadius
            radiusInput.PlaceholderText = "Atur Radius: " .. tostring(flyflingRadius)
            radiusInput.Text = "" 
            showNotification("Radius diatur ke: " .. tostring(newRadius)) -- NOTIFIKASI
        else
            radiusInput.Text = "Invalid Number!"
            task.wait(1)
            radiusInput.Text = ""
        end
    end
end)


-- Tombol Speed ON/OFF
local speedToggleButton = makeFeatureButton("SPEED ON/OFF", Color3.fromRGB(0, 180, 0), function(button)
    isFlyflingSpeedOn = not isFlyflingSpeedOn
    updateButtonStatus(button, isFlyflingSpeedOn, "SPEED", true)
    showNotification("SPEED FLING diatur ke: " .. (isFlyflingSpeedOn and "ON" or "OFF")) -- NOTIFIKASI
    
    local speedInput = FlyflingFrame:FindFirstChild("SpeedInput")
    if speedInput then
        speedInput.PlaceholderText = "Speed: " .. tostring(flyflingSpeedMultiplier)
    end
end, FlyflingFrame)

-- Input Jumlah Speed
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(0, 180, 0, 40)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedInput.PlaceholderText = "Atur Speed: " .. tostring(flyflingSpeedMultiplier) -- Text diperbarui
speedInput.Text = ""
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 12
speedInput.Parent = FlyflingFrame

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed >= 0 then
            flyflingSpeedMultiplier = newSpeed
            speedInput.PlaceholderText = "Atur Speed: " .. tostring(flyflingSpeedMultiplier)
            speedInput.Text = "" 
            showNotification("Speed diatur ke: " .. tostring(newSpeed) .. "x") -- NOTIFIKASI
        else
            speedInput.Text = "Invalid Number!"
            task.wait(1)
            speedInput.Text = ""
        end
    end
end)


-- Button Speed List (Jumlah x)
local speedListFrame = Instance.new("Frame")
speedListFrame.Name = "SpeedListFrame"
speedListFrame.Size = UDim2.new(0, 180, 0, 40) 
speedListFrame.BackgroundTransparency = 1
speedListFrame.Parent = FlyflingFrame

local speedListLayout = Instance.new("UIListLayout")
speedListLayout.Padding = UDim.new(0, 5)
speedListLayout.FillDirection = Enum.FillDirection.Horizontal
speedListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
speedListLayout.SortOrder = Enum.SortOrder.LayoutOrder
speedListLayout.Parent = speedListFrame

local speedOptions = {100, 200, 500, 1000} -- Daftar opsi diperbarui

for i, speedValue in ipairs(speedOptions) do
    local speedListItem = Instance.new("TextButton")
    speedListItem.Name = "SpeedList" .. speedValue .. "Button"
    speedListItem.Size = UDim2.new(1 / #speedOptions, -5, 1, 0) 
    speedListItem.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedListItem.Text = tostring(speedValue) .. "x"
    speedListItem.TextColor3 = Color3.new(1, 1, 1)
    speedListItem.Font = Enum.Font.GothamBold
    speedListItem.TextSize = 10
    speedListItem.Parent = speedListFrame

    local listItemCorner = Instance.new("UICorner")
    listItemCorner.CornerRadius = UDim.new(0, 5)
    listItemCorner.Parent = speedListItem

    speedListItem.MouseButton1Click:Connect(function()
        flyflingSpeedMultiplier = speedValue
        speedInput.PlaceholderText = "Atur Speed: " .. tostring(flyflingSpeedMultiplier)
        speedInput.Text = "" 
        showNotification("Flyfling Speed diatur ke: " .. tostring(speedValue) .. "x") -- NOTIFIKASI
        print("Flyfling Speed diatur ke: " .. tostring(speedValue))
    end)
end

-- Pastikan FlyflingLayout dan featureListLayout diperbarui
FlyflingLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FlyflingFrame.Size = UDim2.new(1, -20, 0, FlyflingLayout.AbsoluteContentSize.Y + 10)
    featureListLayout.AbsoluteContentSize = featureListLayout.AbsoluteContentSize 
end)

-- 🔽 SUBMENU BRING PART BARU (Frame) 🔽

local BringPartFrame = Instance.new("Frame")
BringPartFrame.Name = "BringPartSettings"
BringPartFrame.Size = UDim2.new(1, -20, 0, 260) 
BringPartFrame.Position = UDim2.new(0, 10, 0, 0)
BringPartFrame.BackgroundTransparency = 1
BringPartFrame.Visible = false 
BringPartFrame.Parent = featureScrollFrame

local BringPartLayout = Instance.new("UIListLayout")
BringPartLayout.Padding = UDim.new(0, 5)
BringPartLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
BringPartLayout.SortOrder = Enum.SortOrder.LayoutOrder
BringPartLayout.Parent = BringPartFrame

-- Tombol Radius ON/OFF (BRING PART)
local bringRadiusButton = makeFeatureButton("BRING RADIUS ON/OFF", Color3.fromRGB(0, 180, 0), function(button)
    isBringPartRadiusOn = not isBringPartRadiusOn
    updateButtonStatus(button, isBringPartRadiusOn, "BRING RADIUS", true)
    showNotification("RADIUS BRING diatur ke: " .. (isBringPartRadiusOn and "ON" or "OFF")) 
end, BringPartFrame)

-- Input Jumlah Radius (BRING PART)
local bringRadiusInput = Instance.new("TextBox")
bringRadiusInput.Name = "BringRadiusInput"
bringRadiusInput.Size = UDim2.new(0, 180, 0, 40)
bringRadiusInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bringRadiusInput.PlaceholderText = "Atur Radius: " .. tostring(bringPartRadius) 
bringRadiusInput.Text = ""
bringRadiusInput.TextColor3 = Color3.new(1, 1, 1)
bringRadiusInput.Font = Enum.Font.Gotham
bringRadiusInput.TextSize = 12
bringRadiusInput.Parent = BringPartFrame

bringRadiusInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newRadius = tonumber(bringRadiusInput.Text)
        if newRadius and newRadius >= 0 then
            bringPartRadius = newRadius
            bringRadiusInput.PlaceholderText = "Atur Radius: " .. tostring(bringPartRadius)
            bringRadiusInput.Text = "" 
            showNotification("Bring Part Radius diatur ke: " .. tostring(newRadius)) 
        else
            bringRadiusInput.Text = "Invalid Number!"
            task.wait(1)
            bringRadiusInput.Text = ""
        end
    end
end)


-- Input Max Mass (BRING PART)
local maxMassInput = Instance.new("TextBox")
maxMassInput.Name = "MaxMassInput"
maxMassInput.Size = UDim2.new(0, 180, 0, 40)
maxMassInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
maxMassInput.PlaceholderText = "Max Mass: " .. tostring(bringPartMaxMass) 
maxMassInput.Text = ""
maxMassInput.TextColor3 = Color3.new(1, 1, 1)
maxMassInput.Font = Enum.Font.Gotham
maxMassInput.TextSize = 12
maxMassInput.Parent = BringPartFrame

maxMassInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newMass = tonumber(maxMassInput.Text)
        if newMass and newMass >= 0 then
            bringPartMaxMass = newMass
            maxMassInput.PlaceholderText = "Max Mass: " .. tostring(bringPartMaxMass)
            maxMassInput.Text = "" 
            showNotification("Bring Part Max Mass diatur ke: " .. tostring(newMass)) 
        else
            maxMassInput.Text = "Invalid Number!"
            task.wait(1)
            maxMassInput.Text = ""
        end
    end
end)

-- Layout Update untuk BringPartFrame
BringPartLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    BringPartFrame.Size = UDim2.new(1, -20, 0, BringPartLayout.AbsoluteContentSize.Y + 10)
    featureListLayout.AbsoluteContentSize = featureListLayout.AbsoluteContentSize 
end)


-- 🔽 LOGIKA CHARACTER ADDED (PENTING UNTUK MEMPERTAHANKAN STATUS) 🔽
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
    
    -- Pertahankan status Bring Part
    if isBringPartActive then
        local button = featureScrollFrame:FindFirstChild("BringPartButton")
        if button then 
            if not bringPartConnection then
                bringPartConnection = RunService.Heartbeat:Connect(doBringPart)
            end
        end
    end
end)


-- Atur status awal tombol
updateButtonStatus(flyflingButton, isFlyflingActive, "FLYFLING PART")
updateButtonStatus(partFollowButton, isPartFollowActive, "PART FOLLOW", true)
updateButtonStatus(scanAnchoredButton, isScanAnchoredOn, "SCAN ANCHORED", true)
updateButtonStatus(radiusButton, isFlyflingRadiusOn, "RADIUS", true)
updateButtonStatus(speedToggleButton, isFlyflingSpeedOn, "SPEED", true)

-- Status awal Bring Part BARU
updateButtonStatus(bringPartButton, isBringPartActive, "BRING PART")
updateButtonStatus(bringRadiusButton, isBringPartRadiusOn, "BRING RADIUS", true)
