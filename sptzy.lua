-- Konfigurasi Test
local testPayload = {999, "Test", true} -- Data acak untuk mencoba memicu respon server
local report = {}

print("🔍 Memulai Scanning RemoteEvents...")

-- Fungsi untuk scan dan test
local function scanAndTest()
    local remotes = {}
    
    -- Mencari semua RemoteEvent di ReplicatedStorage
    for _, item in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if item:IsA("RemoteEvent") then
            table.insert(remotes, item)
        end
    end

    print("Found " .. #remotes .. " RemoteEvents. Memulai pengujian...")

    for _, remote in pairs(remotes) do
        -- Menjalankan test dengan pcall agar script tidak berhenti jika ada error
        local success, err = pcall(function()
            -- Mengirim payload ke server
            remote:FireServer(unpack(testPayload))
        end)

        if success then
            warn("✅ [SENT]: " .. remote.Name .. " (" .. remote:GetFullName() .. ")")
            table.insert(report, "Sukses terkirim ke: " .. remote.Name)
        else
            print("❌ [FAILED]: " .. remote.Name .. " | Error: " .. err)
        end
        
        task.wait(0.1) -- Jeda singkat agar tidak terkena rate-limit/spam filter
    end
end

-- Eksekusi
scanAndTest()

print("--- [ RINGKASAN TEST ] ---")
for _, msg in pairs(report) do
    print(msg)
end
