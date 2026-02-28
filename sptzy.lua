--[[ 
    LOGIKA: SS REPLION AUTO-LOOP XP
    1. Scan: Mendeteksi Admin di server secara otomatis.
    2. Loop: Mengirimkan sinyal XP secara berulang dengan jeda aman.
    3. UI: Panel persegi draggable dengan indikator ON/OFF.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Lokasi Remote Replion (Sesuai struktur framework yang kamu berikan)
local ReplionRemote = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :FindFirstChild("ytrev_replion@2.0.0-rc.3")
    :WaitForChild("replion")
    :WaitForChild("Remotes")
    :WaitForChild("Set")

-- Deteksi Admin
local Admin = nil
for _, p in pairs(Players:GetPlayers()) do
    Admin = p
    break
end

if Admin then
    local isLoopingXP = false

    -- === UI PERSEGI MODERN (DRAGGABLE) ===
    local UI = Instance.new("ScreenGui", Admin.PlayerGui)
    UI.Name = "SS_Replion_Loop"
    UI.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", UI)
    MainFrame.Size = UDim2.new(0, 180, 0, 200)
    MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.Active = true
    MainFrame.Draggable = true -- Bisa digeser di layar
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "REPLION HUB SS"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1

    -- Fungsi Membuat Tombol
    local function CreateButton(text, pos, color, callback)
        local btn = Instance.new("TextButton", MainFrame)
        btn.Size = UDim2.new(0.85, 0, 0, 40)
        btn.Position = UDim2.new(0.075, 0, 0, pos)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function() callback(btn) end)
    end

    -- 1. Fitur Set Time (Sekali Tekan)
    CreateButton("SET TIME (12:00)", 50, Color3.fromRGB(60, 100, 180), function()
        ReplionRemote:FireServer("", "Time", 12.145833333333401)
    end)

    -- 2. Fitur LOOP XP (Terus Menerus)
    CreateButton("LOOP XP: OFF", 100, Color3.fromRGB(180, 60, 60), function(btn)
        isLoopingXP = not isLoopingXP
        
        if isLoopingXP then
            btn.Text = "LOOP XP: ON"
            btn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
            
            -- Jalankan Thread Looping
            task.spawn(function()
                while isLoopingXP do
                    pcall(function()
                        -- Mengirimkan Key XP Replion sesuai argumenmu
                        ReplionRemote:FireServer("", "XP", 30)
                    end)
                    task.wait(1.5) -- Jeda antar pengiriman XP agar tidak limit
                end
            end)
        else
            btn.Text = "LOOP XP: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        end
    end)

    -- 3. Fitur AutoFishing Toggle
    local isFishing = false
    CreateButton("AUTOFISH: OFF", 150, Color3.fromRGB(80, 80, 80), function(btn)
        isFishing = not isFishing
        ReplionRemote:FireServer("", "AutoFishing", isFishing)
        
        if isFishing then
            btn.Text = "AUTOFISH: ON"
            btn.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
        else
            btn.Text = "AUTOFISH: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
    end)

    print("Replion Hub Injected! Gunakan panel di layar.")
end
