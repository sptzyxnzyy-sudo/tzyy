-- =========================================================
-- Executor Script: Permanent UGC Equip (Simulasi "Try")
-- Dibuat untuk mencoba mengatasi enkapsulasi Kohl's Admin.
-- =========================================================

local TargetUGC = {
    -- Ganti dengan item yang ingin Anda coba
    id = 133292294488871, 
    equip = "rbxassetid://89119211625300", -- ID Mesh Part (Wings)
    name = "Light Wings"
}

local function AttemptEquip(id, equipAssetId, name)
    local VIPUGCMethod = nil
    
    -- --- CARA 1: Akses Melalui Global State (shared / _G) ---
    -- Admin Kohl's sering menggunakan 'shared' atau 'getfenv()' untuk menyimpan data.
    if shared and shared._K and shared._K.Remote and shared._K.Remote.VIPUGCMethod then
        VIPUGCMethod = shared._K.Remote.VIPUGCMethod
        print("[SUKSES] Remote ditemukan melalui 'shared._K'.")
    elseif _G and _G._K and _G._K.Remote and _G._K.Remote.VIPUGCMethod then
        VIPUGCMethod = _G._K.Remote.VIPUGCMethod
        print("[SUKSES] Remote ditemukan melalui '_G._K'.")
    end

    -- --- CARA 2: Pencarian Manual di ReplicatedStorage ---
    if not VIPUGCMethod then
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        
        -- Coba path umum Admin Kohl's (mungkin memerlukan penyesuaian path)
        local PossibleRemote = ReplicatedStorage:FindFirstChild("KAdminRemotes") 
            or ReplicatedStorage:FindFirstChild("KohlAdmin") 
            or ReplicatedStorage 
        
        -- Asumsikan Remote Event ada di suatu tempat
        for _, obj in PossibleRemote:GetChildren() do
            if obj.Name:find("VIPUGCMethod", 1, true) and obj:IsA("RemoteEvent") then
                VIPUGCMethod = obj
                print("[SUKSES] Remote ditemukan melalui pencarian manual di ReplicatedStorage.")
                break
            end
        end
    end

    -- --- Memicu Remote Event ---
    if VIPUGCMethod and VIPUGCMethod:IsA("RemoteEvent") then
        print(string.format("--> Memicu Equip %s (ID: %d) ke Server...", name, id))
        
        -- Parameter: AssetId, EquipAssetId, Equipped(true), Name
        VIPUGCMethod:FireServer(
            id, 
            equipAssetId, 
            true, -- Memaksa equip ON
            name
        )
        print("✅ Permintaan Equip dikirim. Hasil tergantung pada pemeriksaan server.")
    else
        warn("❌ GAGAL: Remote Event 'VIPUGCMethod' tidak dapat ditemukan.")
        warn("   Coba ubah TargetUGC.id dan TargetUGC.equip, lalu sesuaikan path pencarian manual.")
    end
end

-- Jalankan fungsi equip
AttemptEquip(TargetUGC.id, TargetUGC.equip, TargetUGC.name)