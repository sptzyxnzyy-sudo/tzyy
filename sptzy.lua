local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- ** ⬇️ STATUS GLOBAL ⬇️ **
local isFlyflingActive = false
local flyflingConnection = nil
local isFlyflingRadiusOn = true 
local isFlyflingSpeedOn = true 
local isPartFollowActive = false 
local isScanAnchoredOn = false 
local flyflingSpeedMultiplier = 100 
local flyflingRadius = 30 

local isStaticPartActive = false -- Status Part Statis

local isMagnetActive = false
local magnetConnection = nil
local magnetRadius = 50 
local magnetStrength = 500 
local magnetStatusLabel = nil 

local isPartESPAactive = false -- BARU: Status ESP Garis Part Anchor
local espConnection = nil
local activeESPParts = {} -- Tabel untuk menyimpan part yang sedang di-ESP


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
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "CORE FEATURES"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Label Status Magnet di atas judul
magnetStatusLabel = Instance.new("TextLabel")
magnetStatusLabel.Name = "MagnetStatusLabel"
magnetStatusLabel.Size = UDim2.new(1, 0, 0, 15)
magnetStatusLabel.Position = UDim2.new(0, 0, 0, -15) 
magnetStatusLabel.BackgroundTransparency = 1
magnetStatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
magnetStatusLabel.Font = Enum.Font.SourceSans
magnetStatusLabel.TextSize = 12
magnetStatusLabel.Parent = frame


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
    local newHeight = math.min(featureListLayout.AbsoluteContentSize.Y + 40 + 30 + 15, 600)
    frame.Size = UDim2.new(0, 220, 0, newHeight)
end)


-- 🔽 FUNGSI UTILITY GLOBAL 🔽

local function updateMagnetStatusLabel()
    if magnetStatusLabel then
        local status = isMagnetActive and "ON" or "OFF"
        local color = isMagnetActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        magnetStatusLabel.Text = string.format("MAGNET: %s (R: %d, S: %d)", status, math.floor(magnetRadius), math.floor(magnetStrength))
        magnetStatusLabel.TextColor3 = color
    end
end

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

    local fadeIn = TweenService:Create(notifLabel, TweenInfo.new(0.3), {TextTransparency = 0, BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(0, 100, 200)})
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

-- FUNGSI UNTUK MENGGANTI STATUS TOMBOL (SWITCH STYLE)
local function updateSwitchButtonStatus(button, isActive, featureName)
    local name = featureName or button.Name:gsub("Button", ""):gsub("_", " "):upper()
    
    if isActive then
        button.Text = name .. ": ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Hijau
    else
        button.Text = name .. ": OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Merah
    end
end

-- ** FUNGSI PEMUTUS TALI (Decoupler) **
local function decouplePart(part)
    local success = false
    
    -- Cek Weld/Constraint di Part dan Attachment
    for _, obj in ipairs(part:GetChildren()) do
        if obj:IsA("WeldConstraint") or obj:IsA("Weld") or obj:IsA("ManualWeld") or 
           obj:IsA("RopeConstraint") or obj:IsA("RodConstraint") or obj:IsA("SpringConstraint") then
            -- Cari part yang terhubung. Jika salah satunya Anchored, hancurkan.
            local part0 = obj.Attachment0 and obj.Attachment0.Parent or obj.Part0
            local part1 = obj.Attachment1 and obj.Attachment1.Parent or obj.Part1

            if (part0 and part0:IsA("BasePart") and part0.Anchored) or 
               (part1 and part1:IsA("BasePart") and part1.Anchored) then
                obj:Destroy()
                success = true
            end
        elseif obj:IsA("Attachment") then
            for _, constraint in ipairs(obj:GetChildren()) do
                if constraint:IsA("Constraint") then
                     constraint:Destroy()
                     success = true
                end
            end
        end
    end
    return success
end

-- 🔽 FUNGSI ESP PART ANCHOR (BARU) 🔽
local function createBeamESP(targetPart, rootPart)
    local attachment0 = Instance.new("Attachment")
    attachment0.CFrame = CFrame.new(0, 0, 0)
    attachment0.Parent = rootPart
    
    local attachment1 = Instance.new("Attachment")
    attachment1.CFrame = CFrame.new(0, 0, 0)
    attachment1.Parent = targetPart
    
    local beam = Instance.new("Beam")
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.Color = TweenService:Create(beam, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Color = Color3.fromRGB(0, 255, 255)})
    beam.Color:Play()
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.Transparency = 0
    beam.LightEmission = 1
    beam.ZOffset = 0.1
    beam.Parent = targetPart
    
    return {
        Beam = beam,
        Att0 = attachment0,
        Att1 = attachment1
    }
end

local function doPartESP()
    if not isPartESPAactive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local partsInRadius = {}

    -- 1. Cari Part Anchor atau part yang terikat dalam radius
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" and obj:GetMass() < 1000 then
            
            local distance = (myRoot.Position - obj.Position).Magnitude
            if distance > flyflingRadius * 2 then continue end -- Gunakan Radius dua kali lipat untuk ESP

            -- Filter: Part yang Anchored ATAU Unanchored tapi terikat
            local isAttached = false
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("WeldConstraint") or child:IsA("RopeConstraint") then
                    isAttached = true
                    break
                end
            end
            
            if obj.Anchored or (not obj.Anchored and isAttached) then
                 partsInRadius[obj] = true
            end
        end
    end
    
    -- 2. Hapus ESP yang sudah jauh atau hilang
    for part, espObjects in pairs(activeESPParts) do
        if not partsInRadius[part] or not part.Parent then
            espObjects.Beam:Destroy()
            espObjects.Att0:Destroy()
            espObjects.Att1:Destroy()
            activeESPParts[part] = nil
        end
    end
    
    -- 3. Tambahkan ESP baru
    for part, _ in pairs(partsInRadius) do
        if not activeESPParts[part] then
            activeESPParts[part] = createBeamESP(part, myRoot)
        end
    end
end

local function togglePartESP(button)
    isPartESPAactive = not isPartESPAactive
    
    if isPartESPAactive then
        updateSwitchButtonStatus(button, true, "ESP PART ANCHOR")
        espConnection = RunService.Heartbeat:Connect(doPartESP)
        showNotification("ESP PART ANCHOR AKTIF (Radius Scan: " .. flyflingRadius * 2 .. ")")
    else
        updateSwitchButtonStatus(button, false, "ESP PART ANCHOR")
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        -- Hapus semua ESP saat dinonaktifkan
        for part, espObjects in pairs(activeESPParts) do
            espObjects.Beam:Destroy()
            espObjects.Att0:Destroy()
            espObjects.Att1:Destroy()
        end
        activeESPParts = {}
        showNotification("ESP PART ANCHOR NONAKTIF.")
    end
end


-- 🔽 FUNGSI PART STATIS 🔽

local function doStaticPart()
    if not isStaticPartActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local partsToAnchor = {}

    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" and obj.Anchored == false and obj:GetMass() < 1000 then
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end
            
            local distance = (myRoot.Position - obj.Position).Magnitude
            
            if distance <= flyflingRadius then 
                 table.insert(partsToAnchor, obj)
            end
        end
    end

    for _, part in ipairs(partsToAnchor) do
        part.Anchored = true
        part.Velocity = Vector3.new(0, 0, 0) 
        part.RotationalVelocity = Vector3.new(0, 0, 0)
    end
end

local staticPartConnection = nil
local function toggleStaticPart(button)
    isStaticPartActive = not isStaticPartActive
    
    if isStaticPartActive then
        updateSwitchButtonStatus(button, true, "PART STATIS")
        if not staticPartConnection then 
            staticPartConnection = RunService.Heartbeat:Connect(doStaticPart)
        end
        showNotification("PART STATIS AKTIF (Radius: " .. flyflingRadius .. ")") 
    else
        updateSwitchButtonStatus(button, false, "PART STATIS")
        if staticPartConnection then
            staticPartConnection:Disconnect()
            staticPartConnection = nil
        end
        showNotification("PART STATIS NONAKTIF.") 
    end
end


-- 🔽 FUNGSI MAGNET PART 🔽
local function doMagnet()
    if not isMagnetActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local targetParts = {}

    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" and (not obj.Anchored) then
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end
            
            local distance = (myRoot.Position - obj.Position).Magnitude
            
            if distance <= magnetRadius then 
                if obj:GetMass() < 1000 then 
                    table.insert(targetParts, obj)
                end
            end
        end
    end

    for _, part in ipairs(targetParts) do
        -- Putuskan tali/weld sebelum menarik (agar part bisa bergerak)
        decouplePart(part)

        local direction = (myRoot.Position - part.Position).Unit 
        
        local distance = (myRoot.Position - part.Position).Magnitude
        local effectiveStrength = magnetStrength / math.max(distance * distance, 1) * 0.1 -- Pengali 0.1 untuk mengontrol kecepatan

        part:ApplyImpulse(direction * part:GetMass() * effectiveStrength * RunService.Heartbeat:Wait()) 
    end
end

local function toggleMagnet(button)
    isMagnetActive = not isMagnetActive
    
    if isMagnetActive then
        updateSwitchButtonStatus(button, true, "MAGNET PART")
        magnetConnection = RunService.Heartbeat:Connect(doMagnet)
        local frame = featureScrollFrame:FindFirstChild("MagnetSettings")
        if frame then frame.Visible = true end
        showNotification("MAGNET PART AKTIF (Radius: " .. magnetRadius .. ", Strength: " .. magnetStrength .. ")")
    else
        updateSwitchButtonStatus(button, false, "MAGNET PART")
        if magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
        local frame = featureScrollFrame:FindFirstChild("MagnetSettings")
        if frame then frame.Visible = false end
        showNotification("MAGNET PART NONAKTIF.")
    end
    updateMagnetStatusLabel() 
end


-- 🔽 FUNGSI FLYFLING PART 🔽

local function doFlyfling()
    if not isFlyflingActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local myVelocity = myRoot.Velocity
    local speed = isFlyflingSpeedOn and flyflingSpeedMultiplier or 0
    local targetParts = {}

    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end
            
            local isAnchored = obj.Anchored
            
            -- Lewati jika Anchored dan Scan Anchored OFF
            if (not isScanAnchoredOn) and isAnchored then
                continue
            end
            
            -- Jika 'Scan Anchored' ON, coba putuskan tali/weld
            if isScanAnchoredOn then
                 decouplePart(obj)
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
        updateSwitchButtonStatus(button, true, "FLYFLING PART")
        flyflingConnection = RunService.Heartbeat:Connect(doFlyfling)
        local frame = featureScrollFrame:FindFirstChild("FlyflingSettings")
        if frame then frame.Visible = true end
        showNotification("FLYFLING PART AKTIF (Speed: " .. flyflingSpeedMultiplier .. "x, Radius: " .. flyflingRadius .. ")") 
    else
        updateSwitchButtonStatus(button, false, "FLYFLING PART")
        if flyflingConnection then
            flyflingConnection:Disconnect()
            flyflingConnection = nil
        end
        local frame = featureScrollFrame:FindFirstChild("FlyflingSettings")
        if frame then frame.Visible = false end
        showNotification("FLYFLING PART NONAKTIF.") 
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

local function makeFeatureToggleButton(name, initialStatus, callback, parent)
    local button = makeFeatureButton(name, Color3.fromRGB(150, 0, 0), callback, parent)
    updateSwitchButtonStatus(button, initialStatus, name)
    return button
end

-- 🔽 PENAMBAHAN TOMBOL KE FEATURE LIST 🔽

-- Tombol Utama: ESP PART ANCHOR
local partESPButton = makeFeatureToggleButton("ESP PART ANCHOR", isPartESPAactive, togglePartESP)

-- Tombol Utama: PART STATIS
local staticPartButton = makeFeatureToggleButton("PART STATIS", isStaticPartActive, toggleStaticPart)

-- Tombol Utama: MAGNET PART
local magnetButton = makeFeatureToggleButton("MAGNET PART", isMagnetActive, toggleMagnet)

-- 🔽 SUBMENU MAGNET PART (Frame) 🔽
local MagnetFrame = Instance.new("Frame")
MagnetFrame.Name = "MagnetSettings"
MagnetFrame.Size = UDim2.new(1, -20, 0, 140) 
MagnetFrame.Position = UDim2.new(0, 10, 0, 0)
MagnetFrame.BackgroundTransparency = 1
MagnetFrame.Visible = isMagnetActive 
MagnetFrame.Parent = featureScrollFrame

local MagnetLayout = Instance.new("UIListLayout")
MagnetLayout.Padding = UDim.new(0, 5)
MagnetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MagnetLayout.SortOrder = Enum.SortOrder.LayoutOrder
MagnetLayout.Parent = MagnetFrame

-- Input Radius Magnet
local magnetRadiusInput = Instance.new("TextBox")
magnetRadiusInput.Name = "MagnetRadiusInput"
magnetRadiusInput.Size = UDim2.new(0, 180, 0, 40)
magnetRadiusInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
magnetRadiusInput.PlaceholderText = "Atur Radius Magnet: " .. tostring(magnetRadius) 
magnetRadiusInput.Text = ""
magnetRadiusInput.TextColor3 = Color3.new(1, 1, 1)
magnetRadiusInput.Font = Enum.Font.Gotham
magnetRadiusInput.TextSize = 12
magnetRadiusInput.Parent = MagnetFrame

local radiusCorner = Instance.new("UICorner")
radiusCorner.CornerRadius = UDim.new(0, 10)
radiusCorner.Parent = magnetRadiusInput

magnetRadiusInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newRadius = tonumber(magnetRadiusInput.Text)
        if newRadius and newRadius >= 0 then
            magnetRadius = newRadius
            magnetRadiusInput.PlaceholderText = "Atur Radius Magnet: " .. tostring(magnetRadius)
            magnetRadiusInput.Text = "" 
            showNotification("Radius Magnet diatur ke: " .. tostring(newRadius))
            updateMagnetStatusLabel() 
        else
            magnetRadiusInput.Text = "Invalid Number!"
            task.wait(1)
            magnetRadiusInput.Text = ""
        end
    end
end)

-- Input Kekuatan Magnet
local magnetStrengthInput = Instance.new("TextBox")
magnetStrengthInput.Name = "MagnetStrengthInput"
magnetStrengthInput.Size = UDim2.new(0, 180, 0, 40)
magnetStrengthInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
magnetStrengthInput.PlaceholderText = "Atur Kekuatan Magnet: " .. tostring(magnetStrength) 
magnetStrengthInput.Text = ""
magnetStrengthInput.TextColor3 = Color3.new(1, 1, 1)
magnetStrengthInput.Font = Enum.Font.Gotham
magnetStrengthInput.TextSize = 12
magnetStrengthInput.Parent = MagnetFrame

local strengthCorner = Instance.new("UICorner")
strengthCorner.CornerRadius = UDim.new(0, 10)
strengthCorner.Parent = magnetStrengthInput

magnetStrengthInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newStrength = tonumber(magnetStrengthInput.Text)
        if newStrength and newStrength >= 0 then
            magnetStrength = newStrength
            magnetStrengthInput.PlaceholderText = "Atur Kekuatan Magnet: " .. tostring(magnetStrength)
            magnetStrengthInput.Text = "" 
            showNotification("Kekuatan Magnet diatur ke: " .. tostring(newStrength))
            updateMagnetStatusLabel() 
        else
            magnetStrengthInput.Text = "Invalid Number!"
            task.wait(1)
            magnetStrengthInput.Text = ""
        end
    end
end)

-- Tombol Utama: FLYFLING PART
local flyflingButton = makeFeatureToggleButton("FLYFLING PART", isFlyflingActive, toggleFlyfling)

-- 🔽 SUBMENU FLYFLING PART (Frame) 🔽
local FlyflingFrame = Instance.new("Frame")
FlyflingFrame.Name = "FlyflingSettings"
FlyflingFrame.Size = UDim2.new(1, -20, 0, 310) 
FlyflingFrame.Position = UDim2.new(0, 10, 0, 0)
FlyflingFrame.BackgroundTransparency = 1
FlyflingFrame.Visible = isFlyflingActive
FlyflingFrame.Parent = featureScrollFrame

local FlyflingLayout = Instance.new("UIListLayout")
FlyflingLayout.Padding = UDim.new(0, 5)
FlyflingLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FlyflingLayout.SortOrder = Enum.SortOrder.LayoutOrder
FlyflingLayout.Parent = FlyflingFrame

-- Tombol PART FOLLOW (Toggle)
local partFollowButton = makeFeatureToggleButton("PART FOLLOW", isPartFollowActive, function(button)
    isPartFollowActive = not isPartFollowActive
    updateSwitchButtonStatus(button, isPartFollowActive, "PART FOLLOW")
    showNotification("PART FOLLOW diatur ke: " .. (isPartFollowActive and "ON" or "OFF"))
end, FlyflingFrame)

-- Tombol SCAN ANCHORED (Toggle)
local scanAnchoredButton = makeFeatureToggleButton("SCAN ANCHORED (DECOUPLE)", isScanAnchoredOn, function(button)
    isScanAnchoredOn = not isScanAnchoredOn
    updateSwitchButtonStatus(button, isScanAnchoredOn, "SCAN ANCHORED (DECOUPLE)")
    showNotification("SCAN ANCHORED (DECOUPLE) diatur ke: " .. (isScanAnchoredOn and "ON" or "OFF"))
end, FlyflingFrame)


-- Tombol Radius ON/OFF (Toggle)
local radiusButton = makeFeatureToggleButton("RADIUS ON/OFF", isFlyflingRadiusOn, function(button)
    isFlyflingRadiusOn = not isFlyflingRadiusOn
    updateSwitchButtonStatus(button, isFlyflingRadiusOn, "RADIUS ON/OFF")
    showNotification("RADIUS FLING diatur ke: " .. (isFlyflingRadiusOn and "ON" or "OFF"))
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

local radiusCornerFling = Instance.new("UICorner")
radiusCornerFling.CornerRadius = UDim.new(0, 10)
radiusCornerFling.Parent = radiusInput

radiusInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newRadius = tonumber(radiusInput.Text)
        if newRadius and newRadius >= 0 then
            flyflingRadius = newRadius
            radiusInput.PlaceholderText = "Atur Radius: " .. tostring(flyflingRadius)
            radiusInput.Text = "" 
            showNotification("Radius diatur ke: " .. tostring(newRadius))
        else
            radiusInput.Text = "Invalid Number!"
            task.wait(1)
            radiusInput.Text = ""
        end
    end
end)


-- Tombol Speed ON/OFF (Toggle)
local speedToggleButton = makeFeatureToggleButton("SPEED ON/OFF", isFlyflingSpeedOn, function(button)
    isFlyflingSpeedOn = not isFlyflingSpeedOn
    updateSwitchButtonStatus(button, isFlyflingSpeedOn, "SPEED ON/OFF")
    showNotification("SPEED FLING diatur ke: " .. (isFlyflingSpeedOn and "ON" or "OFF"))
    
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
speedInput.PlaceholderText = "Atur Speed: " .. tostring(flyflingSpeedMultiplier) 
speedInput.Text = ""
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 12
speedInput.Parent = FlyflingFrame

local speedCornerFling = Instance.new("UICorner")
speedCornerFling.CornerRadius = UDim.new(0, 10)
speedCornerFling.Parent = speedInput

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed >= 0 then
            flyflingSpeedMultiplier = newSpeed
            speedInput.PlaceholderText = "Atur Speed: " .. tostring(flyflingSpeedMultiplier)
            speedInput.Text = "" 
            showNotification("Speed diatur ke: " .. tostring(newSpeed) .. "x") 
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

local speedOptions = {100, 200, 500, 1000} 

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
        showNotification("Flyfling Speed diatur ke: " .. tostring(speedValue) .. "x") 
    end)
end

-- Update layout size
MagnetLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MagnetFrame.Size = UDim2.new(1, -20, 0, MagnetLayout.AbsoluteContentSize.Y + 10)
    featureListLayout.AbsoluteContentSize = featureListLayout.AbsoluteContentSize 
end)

FlyflingLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FlyflingFrame.Size = UDim2.new(1, -20, 0, FlyflingLayout.AbsoluteContentSize.Y + 10)
    featureListLayout.AbsoluteContentSize = featureListLayout.AbsoluteContentSize 
end)


-- 🔽 LOGIKA CHARACTER ADDED 🔽
player.CharacterAdded:Connect(function(char)
    if isFlyflingActive and not flyflingConnection then
        flyflingConnection = RunService.Heartbeat:Connect(doFlyfling)
    end
    if isMagnetActive and not magnetConnection then
        magnetConnection = RunService.Heartbeat:Connect(doMagnet)
    end
    if isStaticPartActive and not staticPartConnection then
        staticPartConnection = RunService.Heartbeat:Connect(doStaticPart)
    end
    if isPartESPAactive and not espConnection then
        espConnection = RunService.Heartbeat:Connect(doPartESP)
    end
    updateMagnetStatusLabel() 
end)


-- Atur status awal
updateMagnetStatusLabel()
