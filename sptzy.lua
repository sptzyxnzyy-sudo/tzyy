-- JALANKAN DI SERVER-SIDE EXECUTOR
local Players = game:GetService("Players")

-- LOGIKA OTOMATIS: Mencari siapa yang memicu skrip ini di server
local owner = nil
for _, p in pairs(Players:GetPlayers()) do
    -- Mencari pemain yang paling baru bergabung atau yang memiliki akses executor
    -- Di banyak SS Executor, variabel 'owner' atau 's' sudah tersedia otomatis.
    -- Jika tidak, kita ambil pemain pertama yang ditemukan (asumsi kamu sendiri di server/studio)
    owner = p
    break
end

if not owner then return end

local deletedStorage = {}

-- 1. PEMBUATAN TOOL DI SERVER (Sinkron untuk semua pemain)
local tool = Instance.new("Tool")
tool.Name = "SS_DELETER_AUTO"
tool.RequiresHandle = false
tool.Parent = owner.Backpack

-- 2. UI UNDO (Dikirim langsung ke PlayerGui kamu dari Server)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SS_Undo_Sync"
screenGui.ResetOnSpawn = false
screenGui.Parent = owner.PlayerGui

local undoBtn = Instance.new("TextButton", screenGui)
undoBtn.Size = UDim2.new(0, 160, 0, 50)
undoBtn.Position = UDim2.new(0.5, -80, 0.85, 0)
undoBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
undoBtn.Text = "UNDO (SERVER)"
undoBtn.TextColor3 = Color3.new(1, 1, 1)
undoBtn.Font = Enum.Font.GothamBold
undoBtn.Visible = false
Instance.new("UICorner", undoBtn)

-- 3. LOGIKA PENGHAPUSAN REAL-TIME
-- Fungsi ini berjalan di Server, sehingga efeknya dilihat SEMUA pemain
local function serverDelete(target)
    if target and target:IsA("BasePart") and target.Name ~= "Baseplate" then
        -- Simpan data di tabel server agar bisa dikembalikan
        table.insert(deletedStorage, {Obj = target, OldParent = target.Parent})
        
        -- Hapus Parent di Server = Hilang di semua layar pemain & Fisika mati
        target.Parent = nil 
    end
end

-- 4. KONEKSI AKTIVASI (SERVER-SIDE MOUSE)
tool.Equipped:Connect(function()
    undoBtn.Visible = true
end)

tool.Unequipped:Connect(function()
    undoBtn.Visible = false
end)

-- Mendeteksi target klik dari sisi server
task.spawn(function()
    local mouse = owner:GetMouse()
    tool.Activated:Connect(function()
        local target = mouse.Target
        if target then
            serverDelete(target)
        end
    end)
end)

-- Tombol Undo (Langsung memanipulasi objek di server)
undoBtn.MouseButton1Click:Connect(function()
    if #deletedStorage > 0 then
        local lastData = table.remove(deletedStorage, #deletedStorage)
        lastData.Obj.Parent = lastData.OldParent
    end
end)

-- Notifikasi ke layar kamu (Hanya kamu yang lihat notif ini)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SS SUCCESS",
    Text = "Tool otomatis diberikan ke: " .. owner.Name,
    Duration = 3
})
