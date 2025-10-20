local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ** ⬇️ STATUS FITUR UGC EQUIP (NILAI DEFAULT) ⬇️ **
local isUGCEquipActive = false
-- Ubah nilai default ini sesuai dengan item yang Anda inginkan
local currentUGCItemId = 133292294488871 
local currentUGCEquipAssetId = "rbxassetid://89119211625300" 
local ugcEquipName = "Light Wings" 

-- ** ⬇️ STATUS FITUR FLYFLING PART ⬇️ **
local isFlyflingActive = false
local flyflingConnection = nil
local isFlyflingRadiusOn = true 
local isFlyflingSpeedOn = true 
local isPartFollowActive = false 
local isScanAnchoredOn = false 
local flyflingSpeedMultiplier = 100 
local flyflingRadius = 30

-- ** ⬇️ STATUS FITUR GUI & SCANNER ⬇️ **
local isGUIVisible = true 
local isRemoteScannerActive = false 
local oldFireServer = nil -- Untuk menyimpan fungsi FireServer asli

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
    local contentHeight = featureListLayout.AbsoluteContentSize.Y
    local minFrameHeight = 100 
    local newHeight = math.min(contentHeight + 40, 600)
    
    local currentPos = frame.Position
    
    frame.Size = UDim2.new(0, 220, 0, math.max(minFrameHeight, newHeight))
    
    featureScrollFrame.Size = UDim2.new(1, -20, 1, -40)

    frame.Position = UDim2.new(currentPos.X.Scale, currentPos.X.Offset, 
                               currentPos.Y.Scale, currentPos.Y.Offset)
end)


-- 🔽 FUNGSI UTILITY GLOBAL 🔽

local function showNotification(message, isError)
    local notifGui = screenGui:FindFirstChild("Notification")
    if notifGui then notifGui:Destroy() end 
    
    local color = isError and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 100, 200)

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

    local fadeIn = TweenService:Create(notifLabel, TweenInfo.new(0.3), {TextTransparency = 0, BackgroundTransparency = 0.2, BackgroundColor3 = color})
    local fadeOut = TweenService:Create(notifLabel, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})

    fadeIn:Play()
    fadeIn.Completed:Connect(function()
        task.wait(2.0)
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


-- 🔽 FUNGSI REMOTE SCANNER 🔽
local function activateRemoteScanner(button)
    if isRemoteScannerActive then
        showNotification("Scanner sudah aktif! Tidak bisa diaktifkan dua kali.", true)
        return
    end

    print("--- Kohl's Admin Remote Event Scanner ---")
    local VIPUGCMethod = nil
    
    -- CARA 1: Akses Melalui Global State (shared / _G)
    if shared and shared._K and shared._K.Remote and shared._K.Remote.VIPUGCMethod and shared._K.Remote.VIPUGCMethod:IsA("RemoteEvent") then
        VIPUGCMethod = shared._K.Remote.VIPUGCMethod
    elseif _G and _G._K and _G._K.Remote and _G._K.Remote.VIPUGCMethod and _G._K.Remote.VIPUGCMethod:IsA("RemoteEvent") then
        VIPUGCMethod = _G._K.Remote.VIPUGCMethod
    end

    -- CARA 2: Pencarian Manual di ReplicatedStorage (jika Cara 1 gagal)
    if not VIPUGCMethod or not VIPUGCMethod:IsA("RemoteEvent") then
        warn("[SCANNER] Gagal menemukan VIPUGCMethod di global. Mencari secara manual...")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RemoteFolder = ReplicatedStorage:FindFirstChild("KAdminRemotes") or ReplicatedStorage:FindFirstChild("KohlAdmin") or ReplicatedStorage
        
        for _, obj in RemoteFolder:GetDescendants() do
            if obj.Name == "VIPUGCMethod" and obj:IsA("RemoteEvent") then
                VIPUGCMethod = obj
                break
            end
        end
    end


    if not VIPUGCMethod or not VIPUGCMethod:IsA("RemoteEvent") then
        warn("[SCANNER] Remote Event 'VIPUGCMethod' tidak dapat ditemukan. Scanner gagal diaktifkan.")
        showNotification("❌ REMOTE SCANNER GAGAL: Remote 'VIPUGCMethod' tidak ditemukan.", true)
        button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        return
    end

    -- Simpan FireServer asli untuk meneruskan panggilan
    oldFireServer = VIPUGCMethod.FireServer
    
    -- Ganti fungsi FireServer dengan versi yang memantau
    VIPUGCMethod.FireServer = function(self, ...)
        local args = {...}
        
        -- Logging ke konsol
        local info = debug.getinfo(2, "Snl")
        local source = info and info.source or "Unknown Source"
        local line = info and info.linedefined or "Unknown Line"
        
        print("\n[🚨 DETEKSI PANGGILAN REMOTE] --------------------")
        print("Remote Event: VIPUGCMethod")
        print("Lokasi Pemicu: " .. source .. " (Line: " .. line .. ")")
        
        print("Parameter Diterima:")
        if #args >= 4 then
            print(string.format("  [1] ID UGC: %s", tostring(args[1])))
            print(string.format("  [2] Equip Asset ID: %s", tostring(args[2])))
            print(string.format("  [3] Equipped (Boolean): %s", tostring(args[3])))
            print(string.format("  [4] Name (String): %s", tostring(args[4])))
        else
            for i, v in ipairs(args) do
                print(string.format("  [%d] %s", i, tostring(v)))
            end
        end
        print("--------------------------------------------------")

        -- Meneruskan panggilan asli ke server
        return oldFireServer(self, table.unpack(args))
    end
    
    isRemoteScannerActive = true
    button.Text = "REMOTE SCANNER: AKTIF"
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    showNotification("✅ REMOTE SCANNER AKTIF! Coba klik UGC Equip atau panel admin.")
end


-- 🔽 FUNGSI UGC EQUIP 🔽
local function doUGCEquip(id, equipAssetId, name)
    if not id or not equipAssetId then 
        showNotification("❌ UGC EQUIP: ID Tidak Valid (Internal)!", true)
        return 
    end
    
    local VIPUGCMethod = nil
    
    -- CARA 1: Akses Melalui Global State (shared / _G)
    if shared and shared._K and shared._K.Remote and shared._K.Remote.VIPUGCMethod then
        VIPUGCMethod = shared._K.Remote.VIPUGCMethod
    elseif _G and _G._K and _G._K.Remote and _G._K.Remote.VIPUGCMethod then
        VIPUGCMethod = _G._K.Remote.VIPUGCMethod
    end

    -- CARA 2: Pencarian Manual di ReplicatedStorage
    if not VIPUGCMethod then
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local PossibleRemote = ReplicatedStorage:FindFirstChild("KAdminRemotes") 
            or ReplicatedStorage:FindFirstChild("KohlAdmin") 
            or ReplicatedStorage 
        
        for _, obj in PossibleRemote:GetChildren() do
            if obj.Name:find("VIPUGCMethod", 1, true) and obj:IsA("RemoteEvent") then
                VIPUGCMethod = obj
                break
            end
        end
    end

    -- Memicu Remote Event
    if VIPUGCMethod and VIPUGCMethod:IsA("RemoteEvent") then
        -- Jika Scanner aktif, panggilan ini akan tercatat di konsol karena FireServer sudah di-hook.
        VIPUGCMethod:FireServer(
            id, 
            equipAssetId, 
            true, -- Memaksa equip ON
            name
        )
        showNotification("✅ UGC EQUIP: Permintaan dikirim! " .. name)
    else
        showNotification("❌ UGC EQUIP: Remote 'VIPUGCMethod' GAGAL ditemukan.", true)
    end
end

local function toggleUGCEquip(button)
    isUGCEquipActive = not isUGCEquipActive
    
    if isUGCEquipActive then
        doUGCEquip(currentUGCItemId, currentUGCEquipAssetId, ugcEquipName)
        updateButtonStatus(button, true, "UGC EQUIP: " .. ugcEquipName)
    else
        -- Logic unequip (FireServer dengan Equipped=false)
        local VIPUGCMethod = nil
        if shared and shared._K and shared._K.Remote and shared._K.Remote.VIPUGCMethod then
            VIPUGCMethod = shared._K.Remote.VIPUGCMethod
        elseif _G and _G._K and _G._K.Remote and _G._K.Remote.VIPUGCMethod then
            VIPUGCMethod = _G._K.Remote.VIPUGCMethod
        end
        
        -- Cari Remote manual jika diperlukan untuk unequip
        if not VIPUGCMethod then
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local PossibleRemote = ReplicatedStorage:FindFirstChild("KAdminRemotes") 
                or ReplicatedStorage:FindFirstChild("KohlAdmin") 
                or ReplicatedStorage 
            for _, obj in PossibleRemote:GetChildren() do
                if obj.Name:find("VIPUGCMethod", 1, true) and obj:IsA("RemoteEvent") then
                    VIPUGCMethod = obj
                    break
                end
            end
        end
        
        if VIPUGCMethod and VIPUGCMethod:IsA("RemoteEvent") then
            VIPUGCMethod:FireServer(currentUGCItemId, currentUGCEquipAssetId, false, ugcEquipName) -- Memaksa equip OFF
            showNotification("✅ UGC UNEQUIP: Permintaan Nonaktif dikirim.")
        end
        
        updateButtonStatus(button, false, "UGC EQUIP: " .. ugcEquipName)
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

-- 🔽 FUNGSI TOGGLE GUI 🔽
local function toggleGUIVisibility(button)
    isGUIVisible = not isGUIVisible
    frame.Visible = isGUIVisible
    
    if isGUIVisible then
        updateButtonStatus(button, true, "GUI VISIBILITY", true)
        showNotification("GUI DITAMPILKAN")
    else
        updateButtonStatus(button, false, "GUI VISIBILITY", true)
        showNotification("GUI DISEMBUNYIKAN (Tekan H untuk Membuka)")
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.H then 
        local guiButton = featureScrollFrame:FindFirstChild("GuiVisibilityButton") 
        if guiButton then 
             toggleGUIVisibility(guiButton)
        end
    end
end)

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

-- Tombol TOGGLE GUI
local GuiToggleButton = makeFeatureButton("GUI VISIBILITY: ON (H)", Color3.fromRGB(0, 180, 0), toggleGUIVisibility, featureScrollFrame)
GuiToggleButton.LayoutOrder = -1 
GuiToggleButton.Name = "GuiVisibilityButton" 

-- Tombol UGC Equip
local ugcEquipButton = makeFeatureButton("UGC EQUIP: OFF (".. ugcEquipName .. ")", Color3.fromRGB(120, 0, 0), toggleUGCEquip)
ugcEquipButton.Name = "UGCEquipButton"

-- Tombol REMOTE SCANNER 
local remoteScannerButton = makeFeatureButton("REMOTE SCANNER (Kohl's)", Color3.fromRGB(150, 80, 0), activateRemoteScanner)
remoteScannerButton.Name = "RemoteScannerButton"

-- Tombol FLYFLING PART (Utama)
local flyflingButton = makeFeatureButton("FLYFLING PART: OFF", Color3.fromRGB(120, 0, 0), toggleFlyfling)

-- 🔽 SUBMENU FLYFLING PART (Frame) 🔽

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

-- 🔽 LOGIKA CHARACTER ADDED 🔽
player.CharacterAdded:Connect(function(char)
    if isFlyflingActive then
        local button = featureScrollFrame:FindFirstChild("FlyflingPartButton")
        if button then 
            if not flyflingConnection then
                flyflingConnection = RunService.Heartbeat:Connect(doFlyfling)
            end
        end
    end
end)


-- Atur status awal tombol
updateButtonStatus(GuiToggleButton, isGUIVisible, "GUI VISIBILITY", true)
updateButtonStatus(ugcEquipButton, isUGCEquipActive, "UGC EQUIP: " .. ugcEquipName)
updateButtonStatus(flyflingButton, isFlyflingActive, "FLYFLING PART")
updateButtonStatus(partFollowButton, isPartFollowActive, "PART FOLLOW", true)
updateButtonStatus(scanAnchoredButton, isScanAnchoredOn, "SCAN ANCHORED", true)
updateButtonStatus(radiusButton, isFlyflingRadiusOn, "RADIUS", true)
updateButtonStatus(speedToggleButton, isFlyflingSpeedOn, "SPEED", true)
-- Remote Scanner tidak perlu update status, hanya perlu status awal (tombol non-aktif)
