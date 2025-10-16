local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ** ⬇️ STATUS & NILAI TETAP GLOBAL ⬇️ **
local isFlyflingActive = false
local flyflingConnection = nil
local isFlyflingRadiusOn = true 
local isFlyflingSpeedOn = true 
local isPartFollowActive = false 
local isScanAnchoredOn = false 

-- NILAI TETAP
local flyflingSpeedMultiplier = 500 
local flyflingRadius = 60          

local isMagnetActive = false
local magnetConnection = nil
local magnetRadius = 80            
local magnetStrength = 1500        

local isPartESPAactive = false 
local espConnection = nil
local activeESPParts = {} -- Tabel untuk menyimpan part yang sedang di-ESP

local magnetStatusLabel = nil 


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
        magnetStatusLabel.Text = string.format("MAGNET: %s (R: %d, S: %d)", status, magnetRadius, magnetStrength)
        magnetStatusLabel.TextColor3 = color
    end
end

local function showNotification(message, color)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "Notification"
    notifGui.ResetOnSpawn = false
    notifGui.Parent = player:WaitForChild("PlayerGui")

    local notifLabel = Instance.new("TextLabel")
    notifLabel.Size = UDim2.new(0, 400, 0, 50)
    notifLabel.Position = UDim2.new(0.5, -200, 0.1, 0)
    notifLabel.BackgroundTransparency = 1
    notifLabel.BackgroundColor3 = color or Color3.new(0, 0, 0)
    notifLabel.Text = message
    notifLabel.TextColor3 = Color3.new(1, 1, 1)
    notifLabel.TextScaled = true
    notifLabel.Font = Enum.Font.GothamBold
    notifLabel.Parent = notifGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifLabel

    local fadeIn = TweenService:Create(notifLabel, TweenInfo.new(0.3), {TextTransparency = 0, BackgroundTransparency = 0.2, BackgroundColor3 = color or Color3.fromRGB(0, 100, 200)})
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
    
    for _, obj in ipairs(part:GetChildren()) do
        if obj:IsA("WeldConstraint") or obj:IsA("Weld") or obj:IsA("ManualWeld") then
            local part0 = obj.Part0
            local part1 = obj.Part1

            if (part0 and part0:IsA("BasePart") and part0.Anchored) or 
               (part1 and part1:IsA("BasePart") and part1.Anchored) then
                obj:Destroy()
                success = true
            end
        elseif obj:IsA("RopeConstraint") or obj:IsA("RodConstraint") or obj:IsA("SpringConstraint") then
             local att0 = obj.Attachment0
             local att1 = obj.Attachment1
             
             local part0 = att0 and att0.Parent:IsA("BasePart") and att0.Parent or nil
             local part1 = att1 and att1.Parent:IsA("BasePart") and att1.Parent or nil

             if (part0 and part0.Anchored) or (part1 and part1.Anchored) then
                 obj:Destroy()
                 if att0 and att0.Parent == part then att0:Destroy() end
                 if att1 and att1.Parent == part then att1:Destroy() end
                 success = true
             end
        end
    end
    
    if success and not part.Anchored then
        part.Velocity = Vector3.new(0, 0, 0)
        part.RotationalVelocity = Vector3.new(0, 0, 0)
    end

    return success
end

-- 🔽 FUNGSI SCAN PART (Umum) 🔽
local function scanTargetParts(radius, allowAnchored, includeAttached)
    local targetParts = {}
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return targetParts end

    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue 
            end

            if not allowAnchored and obj.Anchored then
                continue
            end
            
            local distance = (myRoot.Position - obj.Position).Magnitude
            if distance > radius then
                continue
            end

            local isAttached = false
            if obj.Anchored or includeAttached then
                 for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("WeldConstraint") or child:IsA("RopeConstraint") then
                        isAttached = true
                        break
                    end
                end
            end
            
            if (not obj.Anchored) or allowAnchored or (includeAttached and isAttached) then
                table.insert(targetParts, obj)
            end
        end
    end
    return targetParts
end

-- 🔽 FUNGSI ESP PART ANCHOR DIPERBARUI 🔽

-- Beam Attachment0 di Root Part (Ava) dan Attachment1 di Target Part
local function createBeamESP(targetPart, rootPart)
    -- Attachments diparent ke part masing-masing
    local attachment0 = Instance.new("Attachment", rootPart) 
    local attachment1 = Instance.new("Attachment", targetPart)
    
    local beam = Instance.new("Beam")
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    
    -- Warna yang menonjol (Cyan/Magenta)
    local colorSequence = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),  -- Start: Cyan
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)), -- Middle: Magenta
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))   -- End: Cyan
    }
    beam.Color = colorSequence
    
    beam.Width0 = 0.3 -- Lebih tebal
    beam.Width1 = 0.3
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
    
    local partsInRadius = scanTargetParts(flyflingRadius * 2, true, true)
    local currentESPParts = {}

    -- 1. Hapus ESP yang sudah jauh/hilang
    for part, espObjects in pairs(activeESPParts) do
        local found = false
        for i, p in ipairs(partsInRadius) do
            if p == part then
                found = true
                table.remove(partsInRadius, i) 
                break
            end
        end

        if not found or not part.Parent then
            if espObjects.Beam.Parent then espObjects.Beam:Destroy() end
            if espObjects.Att0.Parent then espObjects.Att0:Destroy() end
            if espObjects.Att1.Parent then espObjects.Att1:Destroy() end
            activeESPParts[part] = nil
        else
            currentESPParts[part] = espObjects
        end
    end
    
    -- 2. Tambahkan ESP baru
    for _, part in ipairs(partsInRadius) do
        if not currentESPParts[part] then
            currentESPParts[part] = createBeamESP(part, myRoot)
        end
    end
    activeESPParts = currentESPParts
end

local function togglePartESP(button)
    isPartESPAactive = not isPartESPAactive
    
    if isPartESPAactive then
        showNotification("Mencoba mengaktifkan ESP Part Anchor...", Color3.fromRGB(255, 165, 0))
        
        -- Cek part sebelum mengaktifkan
        local partsFound = #scanTargetParts(flyflingRadius * 2, true, true)
        
        updateSwitchButtonStatus(button, true, "ESP PART ANCHOR")
        espConnection = RunService.Heartbeat:Connect(doPartESP)
        showNotification(string.format("✅ ESP Part Anchor Aktif! (%d part terdeteksi | Garis ke Ava)", partsFound), Color3.fromRGB(0, 255, 0))
    else
        showNotification("Mencoba mematikan ESP Part Anchor...", Color3.fromRGB(255, 165, 0))
        updateSwitchButtonStatus(button, false, "ESP PART ANCHOR")
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        -- Hapus semua Beam/Attachments
        for part, espObjects in pairs(activeESPParts) do
            if espObjects.Beam.Parent then espObjects.Beam:Destroy() end
            if espObjects.Att0.Parent then espObjects.Att0:Destroy() end
            if espObjects.Att1.Parent then espObjects.Att1:Destroy() end
        end
        activeESPParts = {}
        showNotification("❌ ESP Part Anchor Nonaktif.", Color3.fromRGB(255, 0, 0))
    end
end


-- 🔽 FUNGSI MAGNET PART 🔽
local function doMagnet()
    if not isMagnetActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local targetParts = scanTargetParts(magnetRadius, false, false) 

    for _, part in ipairs(targetParts) do
        decouplePart(part)

        local direction = (myRoot.Position - part.Position).Unit 
        
        local distance = (myRoot.Position - part.Position).Magnitude
        local effectiveStrength = magnetStrength / math.max(distance * distance, 1) * 0.1 

        part:ApplyImpulse(direction * part:GetMass() * effectiveStrength * RunService.Heartbeat:Wait()) 
    end
end

local function toggleMagnet(button)
    isMagnetActive = not isMagnetActive
    
    if isMagnetActive then
        showNotification("Mencoba mengaktifkan Magnet Part...", Color3.fromRGB(255, 165, 0))
        local partsFound = #scanTargetParts(magnetRadius, false, false)
        
        updateSwitchButtonStatus(button, true, "MAGNET PART")
        magnetConnection = RunService.Heartbeat:Connect(doMagnet)
        local frame = featureScrollFrame:FindFirstChild("MagnetSettings")
        if frame then frame.Visible = true end
        showNotification(string.format("✅ Magnet Part Aktif! (Menarik %d part | R%d, S%d)", partsFound, magnetRadius, magnetStrength), Color3.fromRGB(0, 255, 0))
    else
        showNotification("Mencoba mematikan Magnet Part...", Color3.fromRGB(255, 165, 0))
        updateSwitchButtonStatus(button, false, "MAGNET PART")
        if magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
        local frame = featureScrollFrame:FindFirstChild("MagnetSettings")
        if frame then frame.Visible = false end
        showNotification("❌ Magnet Part Nonaktif.", Color3.fromRGB(255, 0, 0))
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
    
    local targetParts = scanTargetParts(flyflingRadius, isScanAnchoredOn, isScanAnchoredOn)

    for _, part in ipairs(targetParts) do
        if isScanAnchoredOn then
             decouplePart(part)
        end

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
        showNotification("Mencoba mengaktifkan Flyfling Part...", Color3.fromRGB(255, 165, 0))
        local partsFound = #scanTargetParts(flyflingRadius, isScanAnchoredOn, isScanAnchoredOn)

        updateSwitchButtonStatus(button, true, "FLYFLING PART")
        flyflingConnection = RunService.Heartbeat:Connect(doFlyfling)
        local frame = featureScrollFrame:FindFirstChild("FlyflingSettings")
        if frame then frame.Visible = true end
        showNotification(string.format("✅ Flyfling Part Aktif! (Mendorong %d part | R%d, S%dx)", partsFound, flyflingRadius, flyflingSpeedMultiplier), Color3.fromRGB(0, 255, 0))
    else
        showNotification("Mencoba mematikan Flyfling Part...", Color3.fromRGB(255, 165, 0))
        updateSwitchButtonStatus(button, false, "FLYFLING PART")
        if flyflingConnection then
            flyflingConnection:Disconnect()
            flyflingConnection = nil
        end
        local frame = featureScrollFrame:FindFirstChild("FlyflingSettings")
        if frame then frame.Visible = false end
        showNotification("❌ Flyfling Part Nonaktif.", Color3.fromRGB(255, 0, 0))
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
local partESPButton = makeFeatureToggleButton("ESP PART ANCHOR (R" .. flyflingRadius * 2 .. ")", isPartESPAactive, togglePartESP)

-- Tombol Utama: MAGNET PART
local magnetButton = makeFeatureToggleButton("MAGNET PART (R" .. magnetRadius .. ", S" .. magnetStrength .. ")", isMagnetActive, toggleMagnet)

-- 🔽 SUBMENU MAGNET PART (Frame) 🔽
local MagnetFrame = Instance.new("Frame")
MagnetFrame.Name = "MagnetSettings"
MagnetFrame.Size = UDim2.new(1, -20, 0, 5) -- Dikecilkan karena tidak ada input
MagnetFrame.Position = UDim2.new(0, 10, 0, 0)
MagnetFrame.BackgroundTransparency = 1
MagnetFrame.Visible = isMagnetActive 
MagnetFrame.Parent = featureScrollFrame

local MagnetLayout = Instance.new("UIListLayout")
MagnetLayout.Padding = UDim.new(0, 5)
MagnetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MagnetLayout.SortOrder = Enum.SortOrder.LayoutOrder
MagnetLayout.Parent = MagnetFrame

-- Tombol Utama: FLYFLING PART
local flyflingButton = makeFeatureToggleButton("FLYFLING PART (R" .. flyflingRadius .. ", S" .. flyflingSpeedMultiplier .. "x)", isFlyflingActive, toggleFlyfling)

-- 🔽 SUBMENU FLYFLING PART (Frame) 🔽
local FlyflingFrame = Instance.new("Frame")
FlyflingFrame.Name = "FlyflingSettings"
FlyflingFrame.Size = UDim2.new(1, -20, 0, 150) 
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
local radiusButton = makeFeatureToggleButton("RADIUS ON/OFF (R" .. flyflingRadius .. ")", isFlyflingRadiusOn, function(button)
    isFlyflingRadiusOn = not isFlyflingRadiusOn
    updateSwitchButtonStatus(button, isFlyflingRadiusOn, "RADIUS ON/OFF")
    showNotification("RADIUS FLING diatur ke: " .. (isFlyflingRadiusOn and "ON" or "OFF"))
end, FlyflingFrame)


-- Tombol Speed ON/OFF (Toggle)
local speedToggleButton = makeFeatureToggleButton("SPEED ON/OFF (S" .. flyflingSpeedMultiplier .. "x)", isFlyflingSpeedOn, function(button)
    isFlyflingSpeedOn = not isFlyflingSpeedOn
    updateSwitchButtonStatus(button, isFlyflingSpeedOn, "SPEED ON/OFF")
    showNotification("SPEED FLING diatur ke: " .. (isFlyflingSpeedOn and "ON" or "OFF"))
end, FlyflingFrame)

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
        showNotification("Flyfling Speed diatur ke: " .. tostring(speedValue) .. "x") 
        flyflingButton.Text = "FLYFLING PART (R" .. flyflingRadius .. ", S" .. flyflingSpeedMultiplier .. "x)"
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
    if isPartESPAactive and not espConnection then
        espConnection = RunService.Heartbeat:Connect(doPartESP)
    end
    updateMagnetStatusLabel() 
end)


-- Atur status awal
updateMagnetStatusLabel()
