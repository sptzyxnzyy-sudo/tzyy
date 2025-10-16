local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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

-- ** ⬇️ STATUS FITUR BRING UNANCHORED PART (MAGNET KUAT & SENTUH) ⬇️ **
local isBringUnanchoredPartActive = false 
local bringUnanchoredPartSpeed = 70 -- Kekuatan tarik
local autoReleaseDistance = 3 -- Jarak di mana part akan dilepaskan otomatis
local activeMagnetForces = {} -- Part yang sedang ditarik
local touchConnections = {} -- Koneksi event Touched
local heartbeatConnectionBringPart = nil -- Koneksi Heartbeat khusus untuk magnet

-- 🔽 [ANIMASI DAN GUI UTAMA - TIDAK BERUBAH, DIHAPUS UNTUK KONSENTRASI KODE] 🔽

-- (ASUMSI SEMUA KODE ANIMASI, GUI, NOTIFIKASI, DAN FUNGSI UTILITY GLOBAL ADA DI SINI)

local function showNotification(message)
    -- Stub: Pastikan fungsi ini ada di kode lengkap Anda.
    print("Notifikasi: " .. message)
end

local function updateButtonStatus(button, isActive, featureName)
    -- Stub: Pastikan fungsi ini ada di kode lengkap Anda.
    local name = featureName or button.Name:gsub("Button", ""):gsub("_", " "):upper()
    print(name .. ": " .. (isActive and "ON" or "OFF"))
end

local function cleanupMagnetForces()
    for _, force in pairs(activeMagnetForces) do
        if force and force.Parent then
            local attachment = force.Attachment0
            force:Destroy()
            if attachment and attachment.Parent then attachment:Destroy() end
        end
    end
    activeMagnetForces = {}
end

-- 🔽 FUNGSI BARU: LOGIKA TARIK BERDASARKAN SENTUHAN 🔽

local function startPartMagnet(part)
    if not player.Character or not part or activeMagnetForces[part] then return end
    
    -- Kriteria Cek Ulang: Unanchored, bukan bagian karakter, bukan Baseplate
    if part:IsA("BasePart") and not part.Anchored and part.Name ~= "Baseplate" and part:GetMass() < 1000 then
        if Players:GetPlayerFromCharacter(part.Parent) or part.Parent:FindFirstChildOfClass("Humanoid") then
            return -- Abaikan bagian karakter lain
        end

        local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        -- Buat VectorForce untuk part yang disentuh
        local force = Instance.new("VectorForce")
        force.Force = Vector3.new(0, 0, 0) 
        force.Attachment0 = Instance.new("Attachment")
        force.Attachment0.Parent = part
        force.Parent = part
        activeMagnetForces[part] = force

        -- Bersihkan saat part dihancurkan
        local conn
        conn = part.AncestryChanged:Connect(function()
            if not part.Parent then
                if activeMagnetForces[part] then activeMagnetForces[part]:Destroy() end
                activeMagnetForces[part] = nil
                conn:Disconnect()
            end
        end)
        
        showNotification("Part " .. part.Name .. " disentuh dan ditarik!")
    end
end

-- 🔽 FUNGSI BRING UNANCHORED PART (LOGIKA SENTUH + HEARTBEAT TARIK) 🔽

local function doBringUnanchoredPart()
    if not player.Character then return end
    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local toRemove = {}

    for part, force in pairs(activeMagnetForces) do
        if not part.Parent or not force.Parent then
            table.insert(toRemove, part)
            continue
        end

        local distance = (myRoot.Position - part.Position).Magnitude

        -- LOGIKA PELEPASAN OTOMATIS (Menempel)
        if distance <= autoReleaseDistance then
             force:Destroy()
             table.insert(toRemove, part)
             continue 
        end
        
        -- GAYA TARIK KUAT
        local directionToPlayer = (myRoot.Position - part.Position).Unit
        local forceMagnitude = part:GetMass() * bringUnanchoredPartSpeed * 1.5 
        
        force.Force = directionToPlayer * forceMagnitude
        
        -- PASTIKAN PART TIDAK 'TIDUR' (WAKE UP)
        part.AssemblyLinearVelocity = part.AssemblyLinearVelocity + Vector3.new(0.01, 0.01, 0.01)
    end
    
    for _, part in ipairs(toRemove) do
        activeMagnetForces[part] = nil
    end
end

-- 🔽 LOGIKA TOGGLE DENGAN KONEKSI TOUCHED 🔽

local function toggleBringUnanchoredPart(button)
    isBringUnanchoredPartActive = not isBringUnanchoredPartActive
    
    if isBringUnanchoredPartActive then
        updateButtonStatus(button, true, "BRING PART UNANCHORED (TOUCH)")
        
        -- 1. Mulai Heartbeat untuk menjalankan gaya tarik
        heartbeatConnectionBringPart = RunService.Heartbeat:Connect(doBringUnanchoredPart)

        -- 2. Sambungkan event Touched pada SEMUA bagian karakter
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local conn = part.Touched:Connect(function(hit)
                        startPartMagnet(hit)
                    end)
                    table.insert(touchConnections, conn)
                end
            end
        end
        
        showNotification("BRING PART UNANCHORED AKTIF. Sentuh part untuk menarik!")
    else
        updateButtonStatus(button, false, "BRING PART UNANCHORED (TOUCH)")
        
        -- 1. Bersihkan semua gaya magnet
        cleanupMagnetForces() 
        
        -- 2. Putuskan koneksi Touched dan Heartbeat
        if heartbeatConnectionBringPart then
            heartbeatConnectionBringPart:Disconnect()
            heartbeatConnectionBringPart = nil
        end
        for _, conn in ipairs(touchConnections) do
            conn:Disconnect()
        end
        touchConnections = {}
        
        showNotification("BRING PART UNANCHORED NONAKTIF. Semua part dilepas.")
    end
    
    -- Pastikan Heartbeat umum (untuk Flyfling) tetap berjalan jika Flyfling aktif
    if isFlyflingActive then ensureHeartbeatRunning() end
end

-- 🔽 FUNGSI GABUNGAN HEARTBEAT (HANYA UNTUK FLYFLING) 🔽

local function updateCombinedFeatures()
    if isFlyflingActive then
        doFlyfling()
    end
    
    -- Jaga agar koneksi Heartbeat umum tetap berjalan hanya jika Flyfling aktif
    if not isFlyflingActive and not heartbeatConnectionBringPart then
        if flyflingConnection then
            flyflingConnection:Disconnect()
            flyflingConnection = nil
        end
    end
end

local function ensureHeartbeatRunning()
    if isFlyflingActive and not flyflingConnection then
        flyflingConnection = RunService.Heartbeat:Connect(updateCombinedFeatures)
    end
end


-- 🔽 LOGIKA CHARACTER ADDED (MENYAMBUNGKAN ULANG KONEKSI TOUCHED) 🔽
player.CharacterAdded:Connect(function(char)
    ensureHeartbeatRunning()
    
    -- Sambungkan ulang koneksi touch jika fitur Bring Part aktif
    if isBringUnanchoredPartActive then
        for _, conn in ipairs(touchConnections) do
            conn:Disconnect()
        end
        touchConnections = {}
        
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                local conn = part.Touched:Connect(function(hit)
                    startPartMagnet(hit)
                end)
                table.insert(touchConnections, conn)
            end
        end
    end
end)


-- 🔽 SISA KODE GUI (DIAMBIL DARI KODE ASLI) 🔽

-- **Ganti nama tombol utama Bring Part agar sesuai dengan fungsi baru**
local bringPartButton = makeFeatureButton("BRING PART UNANCHORED (TOUCH): OFF", Color3.fromRGB(120, 0, 0), toggleBringUnanchoredPart)
-- ... [Tambahkan semua kode GUI, Input, dan Inisialisasi status di sini]
