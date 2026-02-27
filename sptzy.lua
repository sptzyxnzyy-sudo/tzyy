-- Jalankan kode ini di Server-Side Executor kamu
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- KONFIGURASI OTOMATIS
local owner = Players.LocalPlayer -- Karena ini SS Executor, LocalPlayer merujuk ke kamu
local deletedStorage = {}

-- 1. FUNGSI NOTIFIKASI SS
local function notify(msg)
    local sg = game:GetService("StarterGui")
    pcall(function()
        sg:SetCore("SendNotification", {
            Title = "SS ADMIN",
            Text = msg,
            Duration = 3
        })
    end)
end

-- 2. PEMBUATAN TOOL (SERVER-SIDE)
local tool = Instance.new("Tool")
tool.Name = "SS_Deleter_Wand"
tool.RequiresHandle = false
tool.Parent = owner.Backpack

-- 3. PEMBUATAN UI UNDO (SERVER-SIDE)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SS_Undo_UI"
screenGui.Parent = owner.PlayerGui

local undoBtn = Instance.new("TextButton", screenGui)
undoBtn.Size = UDim2.new(0, 150, 0, 50)
undoBtn.Position = UDim2.new(0.5, -75, 0.8, 0)
undoBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
undoBtn.Text = "UNDO (KEMBALIKAN)"
undoBtn.TextColor3 = Color3.new(1, 1, 1)
undoBtn.Font = Enum.Font.GothamBold
undoBtn.Visible = false
Instance.new("UICorner", undoBtn)

-- 4. LOGIKA UTAMA
local mouse = nil -- Akan diisi saat tool digunakan

tool.Equipped:Connect(function()
    undoBtn.Visible = true
    -- Mengambil mouse target via remote internal player
    task.spawn(function()
        local pMouse = owner:GetMouse()
        tool.Activated:Connect(function()
            local target = pMouse.Target
            if target and target:IsA("BasePart") then
                if target.Name ~= "Baseplate" then
                    table.insert(deletedStorage, {Obj = target, OldParent = target.Parent})
                    target.Parent = nil
                    notify("Dihapus: " .. target.Name)
                end
            end
        end)
    end)
end)

tool.Unequipped:Connect(function()
    undoBtn.Visible = false
end)

-- Tombol Undo (Server-Side Connection)
undoBtn.MouseButton1Click:Connect(function()
    if #deletedStorage > 0 then
        local lastData = table.remove(deletedStorage, #deletedStorage)
        lastData.Obj.Parent = lastData.OldParent
        notify("Objek dikembalikan!")
    else
        notify("Tidak ada yang bisa di-undo.")
    end
end)

notify("Tool SS Deleter berhasil diberikan!")
