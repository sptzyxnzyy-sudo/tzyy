-- Delta Executor Script (Custom UI)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7YSeven/Script/main/UiLib.lua"))() -- Menggunakan Lib umum

-- Buat Window Utama (Ukuran 300x300)
local Window = Library:CreateWindow({
    Name = "Delta Executor - Quick Cmd",
    Size = UDim2.fromOffset(300, 300),
    Color = Color3.fromRGB(255, 85, 0), -- Warna tema Delta
})

-- Tambahkan Tab Utama
local MainTab = Window:CreateTab("General")

-- Fitur Reset (/re)
MainTab:CreateButton({
    Name = "Reset Character (/re)",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
            -- Alternatif jika game mematikan suicide:
            -- char:BreakJoints()
        end
    end
})

-- Fitur Rejoin (/rejoin)
MainTab:CreateButton({
    Name = "Rejoin Server (/rejoin)",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local p = game.Players.LocalPlayer
        ts:Teleport(game.PlaceId, p)
    end
})

-- Label Tambahan untuk estetika
MainTab:CreateLabel("Size: 300x300 | Drag Support")

-- Fitur Toggle (Open/Close)
-- Di executor, biasanya menggunakan tombol keyboard seperti "RightControl" atau "Insert"
Library:SetToggleKey(Enum.KeyCode.RightControl)

-- Pemberitahuan
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Delta Executor",
    Text = "Script Loaded! Press RightCtrl to Toggle",
    Duration = 5
})
