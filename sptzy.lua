--[[ 
    LOGIKA: SELF-INJECTING SERVER-SIDE ADMIN
    1. Scan: Mencari pemain yang aktif melakukan eksekusi.
    2. Process: Membuat instance tool & UI langsung di level server.
    3. Output: Sinkronisasi realtime ke semua client.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Fungsi Scan Pengeksekusi (Injection Point)
local function GetExecutor()
    -- Logika pencarian: Siapa pun yang saat ini berada di server 
    -- dan memicu script ini akan dianggap sebagai 'Admin'
    for _, p in pairs(Players:GetPlayers()) do
        return p -- Mengambil user pertama yang terdeteksi oleh thread server
    end
end

local Admin = GetExecutor()

if Admin then
    -- TABEL PENYIMPANAN DATA (SERVER MEMORY)
    local _HISTORY = {}

    -- PROSES: PEMBERIAN TOOL ADMIN (SERVER-SIDE INSTANCE)
    local Wand = Instance.new("Tool")
    Wand.Name = "SS_INJECTOR_WAND"
    Wand.RequiresHandle = false
    Wand.Parent = Admin.Backpack

    -- PROSES: INJECT UI KE CLIENT (DARI SERVER)
    local UI = Instance.new("ScreenGui")
    UI.Name = "SS_Admin_Overlay"
    UI.ResetOnSpawn = false
    UI.Parent = Admin.PlayerGui

    local UndoBtn = Instance.new("TextButton", UI)
    UndoBtn.Size = UDim2.new(0, 180, 0, 50)
    UndoBtn.Position = UDim2.new(0.5, -90, 0.82, 0)
    UndoBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60) -- Crimson Red
    UndoBtn.Text = "RESTORE OBJECT (SS)"
    UndoBtn.TextColor3 = Color3.new(1, 1, 1)
    UndoBtn.Font = Enum.Font.SourceSansBold
    UndoBtn.TextSize = 16
    UndoBtn.Visible = false
    Instance.new("UICorner", UndoBtn).CornerRadius = UDim.new(0, 10)

    -- LOGIKA MANIPULASI REALTIME
    -- Ini akan memutus koneksi part di Server sehingga semua orang melihat hasilnya
    local function ExecuteDelete(target)
        if target and target:IsA("BasePart") and target.Name ~= "Baseplate" then
            -- Push ke History
            table.insert(_HISTORY, {Obj = target, Parent = target.Parent})
            
            -- EKSEKUSI: Putus relasi Parent di Server (Force Sync)
            target.Parent = nil
        end
    end

    -- DETEKSI INPUT (DIPROSES DI SERVER)
    Wand.Equipped:Connect(function()
        UndoBtn.Visible = true
        
        -- Menggunakan Mouse melalui transmisi Server
        local Mouse = Admin:GetMouse()
        Wand.Activated:Connect(function()
            if Mouse.Target then
                ExecuteDelete(Mouse.Target)
            end
        end)
    end)

    Wand.Unequipped:Connect(function()
        UndoBtn.Visible = false
    end)

    -- LOGIKA RESTORE (RE-INJECT OBJECT)
    UndoBtn.MouseButton1Click:Connect(function()
        if #_HISTORY > 0 then
            local Last = table.remove(_HISTORY, #_HISTORY)
            Last.Obj.Parent = Last.Parent
        end
    end)

    print("SUCCESS: Admin Wand Injected to " .. Admin.Name)
else
    warn("PROCESS FAILED: No Executor Detected.")
end
