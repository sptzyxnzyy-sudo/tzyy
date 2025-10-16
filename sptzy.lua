local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- ** ⬇️ STATUS FITUR FLYFLING PART ⬇️ **
local isFlyflingActive = false
local flyflingConnection = nil
local isFlyflingRadiusOn = true 
local isFlyflingSpeedOn = true 
local isPartFollowActive = false 
local isScanAnchoredOn = false 
local flyflingSpeedMultiplier = 100 
local flyflingRadius = 30 

-- ** ⬇️ STATUS FITUR UNANCHORED ESP ⬇️ **
local isUnanchoredEspActive = false 
local unanchoredEspConnection = nil
local espMaxDistance = 100 

-- ** ⬇️ STATUS FITUR PART CARRIER BARU ⬇️ **
local isCarrierActive = false 
local carrierConnection = nil
local carriedPart = nil 
local carryRadius = 15 
local rotationSpeed = 20 

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
    -- [Logika Flyfling tetap sama]
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
        showNotification("FLYFLING PART AKTIF (Speed: " .. flyflingSpeedMultiplier .. "x, Radius: " .. flyflingRadius .. ")") 
    else
        updateButtonStatus(button, false, "FLYFLING PART")
        if flyflingConnection then
            flyflingConnection:Disconnect()
            flyflingConnection = nil
        end
        FlyflingFrame.Visible = false 
        showNotification("FLYFLING PART NONAKTIF.") 
    end
end


-- 🔽 FUNGSI UNANCHORED ESP 🔽
local partEsp = {} 
local espContainer = Workspace:FindFirstChild("UnanchoredEspContainer") or Instance.new("Folder")
if not espContainer.Parent then
    espContainer.Name = "UnanchoredEspContainer"
    espContainer.Parent = Workspace.CurrentCamera 
end

local function removeEsp(part)
    if partEsp[part] then
        if partEsp[part].textLabel then partEsp[part].textLabel.Parent = nil end
        if partEsp[part].line then partEsp[part].line.Parent = nil end
        partEsp[part] = nil
    end
end

local function doUnanchoredEsp()
    -- [Logika ESP tetap sama]
    if not isUnanchoredEspActive or not player.Character then 
        for part, espObjects in pairs(partEsp) do
            removeEsp(part)
        end
        return 
    end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local validParts = {} 

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and obj.Name ~= "Baseplate" and obj:GetMass() < 1000 then
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end

            local distance = (myRoot.Position - obj.Position).Magnitude
            
            if distance <= espMaxDistance then
                table.insert(validParts, obj)
            end
        end
    end

    -- Update/Buat ESP
    for _, part in ipairs(validParts) do
        local esp = partEsp[part]
        if not esp then
            esp = {}
            -- [Pembuatan Text Label dan Line (Beam) seperti sebelumnya...]
            local textLabel = Instance.new("TextLabel")
            textLabel.BackgroundTransparency = 1
            textLabel.TextScaled = true
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 0) 
            textLabel.TextStrokeTransparency = 0
            textLabel.Font = Enum.Font.GothamBold
            
            local adornee = Instance.new("BillboardGui")
            adornee.AlwaysOnTop = true
            adornee.Size = UDim2.new(1, 0, 1, 0)
            adornee.ExtentsOffsetWorldSpace = Vector3.new(0, part.Size.Y/2 + 1, 0)
            textLabel.Size = UDim2.new(0, 100, 0, 50)
            textLabel.Parent = adornee
            adornee.Adornee = part
            adornee.Parent = espContainer
            esp.textLabel = adornee

            local line = Instance.new("Part")
            line.Size = Vector3.new(0.2, 0.2, 0.2)
            line.BrickColor = BrickColor.new("Bright yellow")
            line.Material = Enum.Material.Neon
            line.Anchored = true
            line.CanCollide = false
            line.CFrame = CFrame.new() 
            line.Parent = espContainer
            
            local a1 = Instance.new("Attachment")
            a1.Parent = myRoot
            local a2 = Instance.new("Attachment")
            a2.Parent = part
            
            local beam = Instance.new("Beam")
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
            beam.Transparency = NumberSequence.new(0.2)
            beam.Width0 = 0.5
            beam.Width1 = 0.1
            beam.Attachment0 = a1
            beam.Attachment1 = a2
            beam.Parent = line 
            
            esp.line = line
            partEsp[part] = esp
        end
        
        -- Update Teks
        local distance = (myRoot.Position - part.Position).Magnitude
        esp.textLabel.TextLabel.Text = string.format("UNANCHORED: %s\n(%.1fm)", part.Name, distance)
    end
    
    local partsToRemove = {}
    for part, espObjects in pairs(partEsp) do
        local partExists = part.Parent and table.find(validParts, part)
        if not partExists then
            table.insert(partsToRemove, part)
        end
    end

    for _, part in ipairs(partsToRemove) do
        removeEsp(part)
    end
end

local function toggleUnanchoredEsp(button)
    isUnanchoredEspActive = not isUnanchoredEspActive
    
    if isUnanchoredEspActive then
        updateButtonStatus(button, true, "UNANCHORED ESP")
        unanchoredEspConnection = RunService.Heartbeat:Connect(doUnanchoredEsp)
        showNotification("UNANCHORED ESP AKTIF (Jarak: " .. espMaxDistance .. "m)") 
    else
        updateButtonStatus(button, false, "UNANCHORED ESP")
        if unanchoredEspConnection then
            unanchoredEspConnection:Disconnect()
            unanchoredEspConnection = nil
        end
        doUnanchoredEsp() 
        showNotification("UNANCHORED ESP NONAKTIF.") 
    end
end

-- 🔽 FUNGSI PART CARRIER (MODIFIKASI: Constraint Breaker) 🔽

local function findTargetPart(myRoot)
    local closestPart = nil
    local shortestDistance = carryRadius
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.CanCollide and obj.Name ~= "Baseplate" and obj:GetMass() < 1000 then
            
            -- Lewati jika part adalah bagian dari karakter atau sudah dipegang
            if Players:GetPlayerFromCharacter(obj.Parent) or obj.Parent:FindFirstChildOfClass("Humanoid") then
                continue
            end
            if obj == carriedPart then
                continue
            end
            
            local distance = (myRoot.Position - obj.Position).Magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                closestPart = obj
            end
        end
    end
    return closestPart
end

-- FUNGSI BARU: MENGHANCURKAN TALI/KABEL (Constraints)
local function breakPartConstraints(part)
    local broken = 0
    -- Cari Constraints yang terhubung ke Part ini
    for _, attachment in ipairs(part:GetChildren()) do
        if attachment:IsA("Attachment") then
            for _, constraint in ipairs(attachment:GetChildren()) do
                -- Targetkan Constraints yang biasanya digunakan untuk menggantung atau menghubungkan part
                if constraint:IsA("RopeConstraint") or constraint:IsA("SpringConstraint") or constraint:IsA("WeldConstraint") then
                    constraint:Destroy()
                    broken = broken + 1
                end
            end
        end
    end
    
    -- Cek juga di Parent dan objek di sekitarnya (jika Constraints diletakkan di tempat lain)
    -- Ini lebih sulit dan bisa menyebabkan False Positives, jadi kita fokus pada part itu sendiri.
    
    return broken > 0
end


local function updatePartCarrier()
    if not isCarrierActive or not player.Character then return end

    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    if not carriedPart or not carriedPart.Parent then
        -- Mencari part baru
        carriedPart = findTargetPart(myRoot)
        
        if carriedPart then
            
            -- LANGKAH BARU 1: HANCURKAN CONSTRAINTS DULU
            local wasBroken = breakPartConstraints(carriedPart)
            if wasBroken then
                showNotification("Tali/Kabel part " .. carriedPart.Name .. " diputus!")
                carriedPart.Anchored = false -- Pastikan part bisa bergerak jika Anchored setelah tali putus
            end
            
            -- Jika part masih Anchored setelah Constraints putus (mungkin memang Anchored)
            if carriedPart.Anchored then
                showNotification("Part " .. carriedPart.Name .. " Anchored, tidak bisa dibawa.")
                carriedPart = nil -- Tidak bisa dibawa, batalkan
                return
            end
            
            -- LANGKAH 2: BUAT WELD UNTUK MEMBAWA PART
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = myRoot
            weld.Part1 = carriedPart
            weld.Parent = carriedPart 
            carriedPart:SetAttribute("CarrierWeld", weld)
            
            showNotification("Part berhasil diambil: " .. carriedPart.Name)
        else
            return 
        end
    end

    -- LANGKAH 3: ROTASI PART
    local weld = carriedPart:GetAttribute("CarrierWeld")
    if weld and weld.Part0 == myRoot and weld.Part1 == carriedPart then
        local offset = Vector3.new(0, 3, -5) 
        local rotationAngle = RunService.Heartbeat:Wait() * rotationSpeed 
        
        -- Perbarui posisi part agar berputar mengelilingi pemain
        -- Tambahkan rotasi visual agar part terlihat berputar, bukan hanya mengikuti
        carriedPart.CFrame = myRoot.CFrame * CFrame.new(offset) * CFrame.Angles(0, math.rad(rotationAngle), 0)
    else
        -- Jika part terputus, jatuhkan
        carriedPart = nil
    end
end

local function dropCarriedPart()
    if carriedPart and carriedPart.Parent then
        local weld = carriedPart:GetAttribute("CarrierWeld")
        if weld and weld.Parent then
            weld:Destroy()
            carriedPart:SetAttribute("CarrierWeld", nil)
        end
        carriedPart.AssemblyLinearVelocity = Vector3.new(0,0,0) -- Hentikan gerakan saat dijatuhkan
    end
    carriedPart = nil
end

local function togglePartCarrier(button)
    isCarrierActive = not isCarrierActive

    if isCarrierActive then
        updateButtonStatus(button, true, "PART CARRIER")
        carrierConnection = RunService.Heartbeat:Connect(updatePartCarrier)
        showNotification("PART CARRIER (BREAKER) AKTIF. Dekati part yang digantung.")
    else
        updateButtonStatus(button, false, "PART CARRIER")
        if carrierConnection then
            carrierConnection:Disconnect()
            carrierConnection = nil
        end
        dropCarriedPart()
        showNotification("PART CARRIER NONAKTIF. Part dijatuhkan.")
    end
end


-- 🔽 FUNGSI PEMBUAT TOMBOL FITUR & GUI 🔽
-- (Kode GUI dan Tombol tetap sama)
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

local partCarrierButton = makeFeatureButton("PART CARRIER: OFF", Color3.fromRGB(120, 0, 0), togglePartCarrier)
local unanchoredEspButton = makeFeatureButton("UNANCHORED ESP: OFF", Color3.fromRGB(120, 0, 0), toggleUnanchoredEsp)
local flyflingButton = makeFeatureButton("FLYFLING PART: OFF", Color3.fromRGB(120, 0, 0), toggleFlyfling)

-- [Sisanya dari kode GUI dan Flyfling Frame]

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
    showNotification("PART FOLLOW diatur ke: " .. (isPartFollowActive and "ON" or "OFF")) 
end, FlyflingFrame)

local scanAnchoredButton = makeFeatureButton("SCAN ANCHORED: OFF", Color3.fromRGB(150, 0, 0), function(button)
    isScanAnchoredOn = not isScanAnchoredOn
    updateButtonStatus(button, isScanAnchoredOn, "SCAN ANCHORED", true)
    showNotification("SCAN ANCHORED diatur ke: " .. (isScanAnchoredOn and "ON" or "OFF")) 
end, FlyflingFrame)


local radiusButton = makeFeatureButton("RADIUS ON/OFF", Color3.fromRGB(0, 180, 0), function(button)
    isFlyflingRadiusOn = not isFlyflingRadiusOn
    updateButtonStatus(button, isFlyflingRadiusOn, "RADIUS", true)
    showNotification("RADIUS FLING diatur ke: " .. (isFlyflingRadiusOn and "ON" or "OFF")) 
end, FlyflingFrame)

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
            showNotification("Radius diatur ke: " .. tostring(newRadius)) 
        else
            radiusInput.Text = "Invalid Number!"
            task.wait(1)
            radiusInput.Text = ""
        end
    end
end)


local speedToggleButton = makeFeatureButton("SPEED ON/OFF", Color3.fromRGB(0, 180, 0), function(button)
    isFlyflingSpeedOn = not isFlyflingSpeedOn
    updateButtonStatus(button, isFlyflingSpeedOn, "SPEED", true)
    showNotification("SPEED FLING diatur ke: " .. (isFlyflingSpeedOn and "ON" or "OFF")) 
    
    local speedInput = FlyflingFrame:FindFirstChild("SpeedInput")
    if speedInput then
        speedInput.PlaceholderText = "Speed: " .. tostring(flyflingSpeedMultiplier)
    end
end, FlyflingFrame)

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

FlyflingLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FlyflingFrame.Size = UDim2.new(1, -20, 0, FlyflingLayout.AbsoluteContentSize.Y + 10)
    featureListLayout.AbsoluteContentSize = featureListLayout.AbsoluteContentSize 
end)


-- 🔽 LOGIKA CHARACTER ADDED (PENTING UNTUK MEMPERTAHANKAN STATUS) 🔽
player.CharacterAdded:Connect(function(char)
    -- Pertahankan status Part Carrier
    if isCarrierActive then
        local button = featureScrollFrame:FindFirstChild("PartCarrierButton")
        if button and not carrierConnection then
            carrierConnection = RunService.Heartbeat:Connect(updatePartCarrier)
        end
    end
    -- Pertahankan status Flyfling Part
    if isFlyflingActive then
        local button = featureScrollFrame:FindFirstChild("FlyflingPartButton")
        if button and not flyflingConnection then
            flyflingConnection = RunService.Heartbeat:Connect(doFlyfling)
        end
    end
    -- Pertahankan status Unanchored ESP
    if isUnanchoredEspActive then
        local button = featureScrollFrame:FindFirstChild("UnanchoredEspButton")
        if button and not unanchoredEspConnection then
            unanchoredEspConnection = RunService.Heartbeat:Connect(doUnanchoredEsp)
        end
    end
end)


-- Atur status awal tombol
updateButtonStatus(partCarrierButton, isCarrierActive, "PART CARRIER") 
updateButtonStatus(unanchoredEspButton, isUnanchoredEspActive, "UNANCHORED ESP") 
updateButtonStatus(flyflingButton, isFlyflingActive, "FLYFLING PART")
updateButtonStatus(partFollowButton, isPartFollowActive, "PART FOLLOW", true)
updateButtonStatus(scanAnchoredButton, isScanAnchoredOn, "SCAN ANCHORED", true)
updateButtonStatus(radiusButton, isFlyflingRadiusOn, "RADIUS", true)
updateButtonStatus(speedToggleButton, isFlyflingSpeedOn, "SPEED", true)
