-- Versi Force Overwrite untuk Executor
local function forceStyle()
    -- Mencari di PlayerGui dan CoreGui
    local targets = {game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"), game:GetService("CoreGui")}
    
    for _, folder in pairs(targets) do
        if folder then
            for _, stroke in pairs(folder:GetDescendants()) do
                if stroke:IsA("UIStroke") then
                    stroke.Color = Color3.fromRGB(0, 255, 255) -- Cyan
                    stroke.Thickness = 2.5
                    stroke.Enabled = true
                    -- Mengunci properti agar tidak diubah balik oleh script game
                end
            end
        end
    end
end

-- Menjalankan fungsi setiap 2 detik agar permanen
task.spawn(function()
    while task.wait(2) do
        pcall(forceStyle)
    end
end)

print("Skrip Force Border aktif!")
