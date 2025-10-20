-- Eksekusi kode ini di lingkungan Executor/Client-side.

-- **PERHATIAN:** Variabel _K dan Remote Event harus sudah terisi
-- oleh script Admin Kohl's yang sah di lingkungan klien Anda.
-- Executor harus memiliki akses ke variabel global tersebut.

local TargetUGC = {
    -- Contoh data UGC yang ingin Anda coba pakai: Light Wings
    id = 133292294488871, 
    equip = "rbxassetid://89119211625300",
    name = "Light Wings"
}

-- 1. Akses Remote Event
-- Asumsikan _K adalah variabel global yang berisi referensi ke Remote Events.
local VIPUGCMethod = _K and _K.Remote and _K.Remote.VIPUGCMethod

if not VIPUGCMethod then
    -- Cari Remote Event secara manual jika tidak ada di variabel _K
    -- Lokasi umum: ReplicatedStorage, StarterGui (ScreenGui > _K > Remote)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    VIPUGCMethod = ReplicatedStorage:FindFirstChild("Remote"):FindFirstChild("VIPUGCMethod") -- Ganti dengan path yang sesuai!
end

if VIPUGCMethod and VIPUGCMethod:IsA("RemoteEvent") then
    print("Remote Event VIPUGCMethod ditemukan. Memicu permintaan equip...")
    
    -- Parameter untuk FireServer (dari fungsi debounceEquip):
    -- id: Asset ID UGC (misalnya 133292294488871)
    -- equip: rbxassetid template (misalnya "rbxassetid://89119211625300")
    -- equipped: true (untuk memakai item)
    -- name: Nama item (misalnya "Light Wings")
    
    -- Memicu permintaan equip tanpa debounce dan tanpa expired time (seperti yang dilakukan server).
    -- Karena kita 'melompati' timer 15 detik di klien, item akan tetap terpasang
    -- selama server Admin Kohl's mengizinkannya.
    VIPUGCMethod:FireServer(
        TargetUGC.id, 
        TargetUGC.equip, 
        true, -- Selalu true untuk memakai item
        TargetUGC.name
    )
    
    print("Permintaan 'Try/Equip' UGC " .. TargetUGC.name .. " dikirim ke server.")
else
    warn("Gagal menemukan Remote Event 'VIPUGCMethod'. Pastikan path sudah benar atau variabel _K sudah terisi.")
end
