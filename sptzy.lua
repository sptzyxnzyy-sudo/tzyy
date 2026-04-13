-- Kode Executor: Mengubah Garis Pinggir GUI
local function applyStyle(stroke)
    if stroke:IsA("UIStroke") then
        -- Pengaturan Visual Modern
        stroke.Color = Color3.fromRGB(0, 255, 255) -- Warna Cyan Neon
        stroke.Thickness = 2 -- Ketebalan garis
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Transparency = 0.1 -- Sedikit transparan agar halus
    end
end

-- 1. Jalankan pada GUI yang sudah ada
for _, object in pairs(game:GetService("CoreGui"):GetDescendants()) do
    applyStyle(object)
end

for _, object in pairs(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do
    applyStyle(object)
end

-- 2. Jalankan otomatis jika ada UI baru yang muncul (Fitur Auto-Update)
game:GetService("Players").LocalPlayer.PlayerGui.DescendantAdded:Connect(function(descendant)
    applyStyle(descendant)
end)

print("UI Border Styles Applied Successfully!")
