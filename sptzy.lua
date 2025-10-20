-- Eksekusi kode ini di lingkungan Executor/Client-side

local function ScanRemoteAccess()
    print("--- Kohl's Admin Remote Event Scanner ---")
    
    local VIPUGCMethod = nil
    
    -- Cari Remote Event (sesuaikan path jika perlu)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    -- Kita coba cari di ReplicatedStorage atau asumsikan sudah ada di _K
    if _K and _K.Remote and _K.Remote.VIPUGCMethod and _K.Remote.VIPUGCMethod:IsA("RemoteEvent") then
        VIPUGCMethod = _K.Remote.VIPUGCMethod
        print("Remote Event 'VIPUGCMethod' ditemukan melalui variabel _K.")
    else
        warn("Gagal menemukan VIPUGCMethod di _K. Mencari secara manual...")
        -- Ganti path berikut jika Admin Kohl's Anda menempatkan remotes di tempat lain
        local RemoteFolder = ReplicatedStorage:FindFirstChild("_K") or ReplicatedStorage
        VIPUGCMethod = RemoteFolder:FindFirstChild("Remote"):FindFirstChild("VIPUGCMethod")
    end

    if not VIPUGCMethod or not VIPUGCMethod:IsA("RemoteEvent") then
        warn("Remote Event 'VIPUGCMethod' tidak dapat ditemukan. Scanner dihentikan.")
        return
    end

    local OldFireServer = VIPUGCMethod.FireServer
    
    -- Ganti fungsi FireServer dengan versi yang memantau
    VIPUGCMethod.FireServer = function(self, ...)
        local args = {...}
        
        -- Dapatkan informasi stack trace untuk melacak dari mana panggilan berasal
        local info = debug.getinfo(2, "Snl")
        local source = info and info.source or "Unknown Source"
        local line = info and info.linedefined or "Unknown Line"
        
        print("\n[🚨 DETEKSI PANGGILAN REMOTE] --------------------")
        print("Remote Event: VIPUGCMethod")
        print("Lokasi Pemicu: " .. source .. " (Line: " .. line .. ")")
        
        -- Menampilkan Parameter
        print("Parameter Diterima:")
        if #args >= 4 then
            print(string.format("  [1] ID UGC: %s", args[1]))
            print(string.format("  [2] Equip Asset ID: %s", args[2]))
            print(string.format("  [3] Equipped (Boolean): %s", tostring(args[3])))
            print(string.format("  [4] Name (String): %s", args[4]))
        else
            for i, v in ipairs(args) do
                print(string.format("  [%d] %s", i, tostring(v)))
            end
        end
        print("--------------------------------------------------")

        -- Meneruskan panggilan asli ke server
        return OldFireServer(self, table.unpack(args))
    end
    
    print("\n✅ Scanner VIPUGCMethod aktif. Sekarang, coba klik tombol 'TRY' atau 'WEAR/HIDE' di panel admin.")
end

-- Panggil fungsi scanner untuk mengaktifkan pemantauan
ScanRemoteAccess()
