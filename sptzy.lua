-- Kode untuk mengubah garis pinggir (UIStroke) pada GUI MAP
local function gubahGarisPinggir(obj)
    -- Mencari objek UIStroke yang sudah ada di GUI map
    if obj:IsA("UIStroke") then
        obj.Color = Color3.fromRGB(0, 255, 255) -- Ganti warna (Cyan)
        obj.Thickness = 2 -- Ketebalan garis
        obj.Transparency = 0
        obj.Enabled = true
    end
    
    -- Jika elemen UI map tidak punya UIStroke, kita tambahkan manual agar ada garisnya
    if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
        if not obj:FindFirstChildOfClass("UIStroke") then
            local stroke baru = Instance.new("UIStroke")
            baru.Color = Color3.fromRGB(0, 255, 255)
            baru.Thickness = 1.5
            baru.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            baru.Parent = obj
        end
        -- Menghilangkan border kotak gaya lama agar terlihat modern
        obj.BorderSizePixel = 0
    end
end

-- Menjalankan fungsi ke semua GUI yang ada di dalam Map (PlayerGui)
local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

for _, v in pairs(pg:GetDescendants()) do
    pcall(function()
        gubahGarisPinggir(v)
    end)
end

-- Otomatis mengubah jika ada GUI map baru yang muncul saat bermain
pg.DescendantAdded:Connect(function(baru)
    pcall(function()
        task.wait(0.1) -- Tunggu sebentar agar objek termuat sempurna
        gubahGarisPinggir(baru)
    end)
end)

print("Garis pinggir GUI Map berhasil digubah!")
