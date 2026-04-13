-- Skrip Universal Border Fixer
local function applyModernStyle(obj)
    -- Jika objek adalah UIStroke (garis pinggir modern)
    if obj:IsA("UIStroke") then
        obj.Color = Color3.fromRGB(0, 255, 255) -- Cyan
        obj.Thickness = 1.8
        obj.Transparency = 0
        obj.Enabled = true
    
    -- Jika objek adalah Frame/Button tanpa UIStroke (metode lama)
    elseif obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        -- Jika tidak ada UIStroke, kita buatkan baru agar lebih bagus
        if not obj:FindFirstChildOfClass("UIStroke") then
            local newStroke = Instance.new("UIStroke")
            newStroke.Color = Color3.fromRGB(0, 255, 255)
            newStroke.Thickness = 1.2
            newStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            newStroke.Parent = obj
        end
        -- Menghilangkan border bawaan yang kaku (metode lama)
        obj.BorderSizePixel = 0 
    end
end

-- Fungsi scan menyeluruh
local function scanAll()
    for _, item in pairs(game:GetDescendants()) do
        -- Membatasi hanya pada objek UI agar tidak lag di Mobile/Chromebook
        if item:IsA("ScreenGui") or item:IsA("SurfaceGui") or item:IsA("BillboardGui") then
            for _, child in pairs(item:GetDescendants()) do
                pcall(function()
                    applyModernStyle(child)
                end)
            end
        end
    end
end

-- Jalankan sekali di awal
scanAll()

-- Pantau jika ada UI baru yang muncul di Studio Lite (Real-time)
game.DescendantAdded:Connect(function(newObj)
    pcall(function()
        applyModernStyle(newObj)
    end)
end)

print("Semua UI di Studio Lite telah diperbarui!")
