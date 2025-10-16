local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ** ⬇️ STATUS FITUR PART INTERACTION ⬇️ **
local isPartInteractionActive = false -- Status umum (Flyfling atau Bring)
local interactionConnection = nil

local isFlyflingActive = false
local isBringPartActive = false -- Status untuk Bring Part (Tarik)

local isFlyflingRadiusOn = true 
local isFlyflingSpeedOn = true 
local isPartFollowActive = false 
local isScanAnchoredOn = false 
local partInteractionSpeedMultiplier = 100 -- Digunakan untuk kedua mode (Flyfling & Bring)
local partInteractionRadius = 30 -- Digunakan untuk kedua mode

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

-- FUNGSI NOTIFIKASI GAYA ROBLOX
local function showNotification(message)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "Notification"
    notifGui.ResetOnSpawn = false
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifGui.Parent = player:WaitForChild("PlayerGui")

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 300, 0, 40)
    notifFrame.AnchorPoint = Vector2.new(1, 1)
    notifFrame.Position = UDim2.new(1, -10, 1, -10)
    notifFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
    notifFrame.BackgroundTransparency = 1 
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame
        
    local notifLabel = Instance.new("TextLabel")
    notifLabel.Size = UDim2.new(1, 0, 1, 0)
    notifLabel.BackgroundTransparency = 1
    notifLabel.Text = message
    notifLabel.TextColor3 = Color3.new(1, 1, 1)
    notifLabel.TextScaled = false
    notifLabel.TextSize = 14
    notifLabel.Font = Enum.Font.Gotham
    notifLabel.TextXAlignment = Enum.TextXAlignment.Left
    notifLabel.TextWrapped = true
    notifLabel.Parent = notifFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = notifLabel

    local startPos = UDim2.new(1, 10, 1, -10) 
    local endPos = UDim2.new(1, -10, 1, -10) 

    notifFrame.Position = startPos

    local tweenIn = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = endPos, BackgroundTransparency = 0.1})
    local tweenOut = TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 1.5), {Position = startPos, BackgroundTransparency = 1})

    tweenIn:Play()
    tweenIn.Completed:Connect(function()
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
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
        -- Untuk tombol utama Flyfling/Bring
        if isActive then
            button.Text = name .. ": ON"
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 0) 
        else
            button.Text = name .. ": OFF"
            button.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
        end
    end
end


-- 🔽 FUNGSI UTAMA PART INTERACTION (FLYFLING/BRING) 🔽

local function doPartInteraction()
    if not isPartInteractionActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local myVelocity = myRoot.Velocity
    local speed = isFlyflingSpeedOn and partInteractionSpeedMultiplier or 0
    local targetParts = {}

    -- Tentukan arah gaya: 1 untuk Flyfling (menjauh), -1 untuk Bring (mendekat)
    local directionMultiplier = 0
    if isFlyflingActive then
        directionMultiplier = 1 
    elseif isBringPartActive then
        directionMultiplier = -1 
    else
        return 
    end

    -- Ambil semua part di Workspace
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end
            
            if (not isScanAnchoredOn) and obj.Anchored then
                continue
            end

            local distance = (myRoot.Position - obj.Position).Magnitude
            
            if isFlyflingRadiusOn and distance > partInteractionRadius then continue end
            
            if obj:GetMass() < 1000 then 
                 table.insert(targetParts, obj)
            end
        end
    end

    -- Terapkan Gaya
    for _, part in ipairs(targetParts) do
        local direction = (part.Position - myRoot.Position).Unit
        local force = direction * part:GetMass() * speed * 10 * directionMultiplier
        
        part.Velocity = part.Velocity + (force / part:GetMass())
        
        -- Part Follow: hanya efektif/masuk akal saat Flyfling aktif (mendorong)
        if isPartFollowActive and isFlyflingActive then 
             part.AssemblyLinearVelocity = Vector3.new(myVelocity.X, part.AssemblyLinearVelocity.Y, myVelocity.Z) 
        end
    end
end


-- 🔽 FUNGSI TOGGLE UTAMA (Mengelola Flyfling dan Bring) 🔽

local function startPartInteraction(interactionType)
    local wasFlyfling = isFlyflingActive
    local wasBringPart = isBringPartActive

    -- Logika Toggle: Hanya satu mode yang boleh aktif
    if interactionType == "Flyfling" then
        if wasFlyfling then
            isFlyflingActive = false -- Matikan
        else
            isFlyflingActive = true  -- Aktifkan Flyfling
            isBringPartActive = false -- Pastikan Bring mati
        end
    elseif interactionType == "Bring" then
        if wasBringPart then
            isBringPartActive = false -- Matikan
        else
            isBringPartActive = true -- Aktifkan Bring
            isFlyflingActive = false -- Pastikan Flyfling mati
        end
    end

    isPartInteractionActive = (isFlyflingActive or isBringPartActive)

    -- Manajemen Connection
    if interactionConnection then
        interactionConnection:Disconnect()
        interactionConnection = nil
    end

    -- Update GUI dan Connection
    local flyflingButton = featureScrollFrame:FindFirstChild("FlyflingPartButton")
    local bringPartButton = featureScrollFrame:FindFirstChild("BringPartButton")

    updateButtonStatus(flyflingButton, isFlyflingActive, "FLYFLING PART")
    updateButtonStatus(bringPartButton, isBringPartActive, "BRING PART")

    if isPartInteractionActive then
        interactionConnection = RunService.Heartbeat:Connect(doPartInteraction)
        FlyflingFrame.Visible = true
        local featureName = isBringPartActive and "BRING PART" or "FLYFLING PART"
        showNotification(featureName .. " AKTIF (Speed: " .. partInteractionSpeedMultiplier .. "x)")
    else
        FlyflingFrame.Visible = false 
        showNotification("PART INTERACTION NONAKTIF.")
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
local flyflingButton = makeFeatureButton("FLYFLING PART: OFF", Color3.fromRGB(120, 0, 0), function()
    startPartInteraction("Flyfling")
end)

-- Tombol BRING PART (Tombol Utama BARU)
local bringPartButton = makeFeatureButton("BRING PART: OFF", Color3.fromRGB(120, 0, 0), function()
    startPartInteraction("Bring")
end)

-- 🔽 SUBMENU FLYFLING/BRING PART (Frame) 🔽

local FlyflingFrame = Instance.new("Frame")
FlyflingFrame.Name = "InteractionSettings"
FlyflingFrame.Size = UDim2.new(1, -20, 0, 360) 
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
    showNotification("PART FOLLOW diatur ke: " .. (isPartFollowActive and "ON" or "OFF")) 
end, FlyflingFrame)

-- Tombol SCAN ANCHORED
local scanAnchoredButton = makeFeatureButton("SCAN ANCHORED: OFF", Color3.fromRGB(150, 0, 0), function(button)
    isScanAnchoredOn = not isScanAnchoredOn
    updateButtonStatus(button, isScanAnchoredOn, "SCAN ANCHORED", true)
    showNotification("SCAN ANCHORED diatur ke: " .. (isScanAnchoredOn and "ON" or "OFF")) 
end, FlyflingFrame)


-- Tombol Radius ON/OFF
local radiusButton = makeFeatureButton("RADIUS ON/OFF", Color3.fromRGB(0, 180, 0), function(button)
    isFlyflingRadiusOn = not isFlyflingRadiusOn
    updateButtonStatus(button, isFlyflingRadiusOn, "RADIUS", true)
    showNotification("RADIUS INTERACTION diatur ke: " .. (isFlyflingRadiusOn and "ON" or "OFF")) 
end, FlyflingFrame)

-- Input Jumlah Radius
local radiusInput = Instance.new("TextBox")
radiusInput.Name = "RadiusInput"
radiusInput.Size = UDim2.new(0, 180, 0, 40)
radiusInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
radiusInput.PlaceholderText = "Atur Radius: " .. tostring(partInteractionRadius) 
radiusInput.Text = ""
radiusInput.TextColor3 = Color3.new(1, 1, 1)
radiusInput.Font = Enum.Font.Gotham
radiusInput.TextSize = 12
radiusInput.Parent = FlyflingFrame

radiusInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newRadius = tonumber(radiusInput.Text)
        if newRadius and newRadius >= 0 then
            partInteractionRadius = newRadius
            radiusInput.PlaceholderText = "Atur Radius: " .. tostring(partInteractionRadius)
            radiusInput.Text = "" 
            showNotification("Radius diatur ke: " .. tostring(newRadius))
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
    showNotification("SPEED INTERACTION diatur ke: " .. (isFlyflingSpeedOn and "ON" or "OFF")) 
end, FlyflingFrame)

-- Input Jumlah Speed
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(0, 180, 0, 40)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedInput.PlaceholderText = "Atur Speed: " .. tostring(partInteractionSpeedMultiplier) 
speedInput.Text = ""
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 12
speedInput.Parent = FlyflingFrame

speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed >= 0 then
            partInteractionSpeedMultiplier = newSpeed
            speedInput.PlaceholderText = "Atur Speed: " .. tostring(partInteractionSpeedMultiplier)
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
        partInteractionSpeedMultiplier = speedValue
        speedInput.PlaceholderText = "Atur Speed: " .. tostring(partInteractionSpeedMultiplier)
        speedInput.Text = "" 
        showNotification("Speed diatur ke: " .. tostring(speedValue) .. "x")
    end)
end

-- Pastikan FlyflingLayout dan featureListLayout diperbarui
FlyflingLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FlyflingFrame.Size = UDim2.new(1, -20, 0, FlyflingLayout.AbsoluteContentSize.Y + 10)
    featureListLayout.AbsoluteContentSize = featureListLayout.AbsoluteContentSize 
end)


-- 🔽 LOGIKA CHARACTER ADDED (PENTING UNTUK MEMPERTAHANKAN STATUS) 🔽
player.CharacterAdded:Connect(function(char)
    -- Pertahankan status Part Interaction
    if isPartInteractionActive then
        if not interactionConnection then
            interactionConnection = RunService.Heartbeat:Connect(doPartInteraction)
        end
    end
end)


-- Atur status awal tombol
updateButtonStatus(flyflingButton, isFlyflingActive, "FLYFLING PART")
updateButtonStatus(bringPartButton, isBringPartActive, "BRING PART") -- Diperbarui
updateButtonStatus(partFollowButton, isPartFollowActive, "PART FOLLOW", true)
updateButtonStatus(scanAnchoredButton, isScanAnchoredOn, "SCAN ANCHORED", true)
updateButtonStatus(radiusButton, isFlyflingRadiusOn, "RADIUS", true)
updateButtonStatus(speedToggleButton, isFlyflingSpeedOn, "SPEED", true)
