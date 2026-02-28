-- JALANKAN DI SERVER-SIDE EXECUTOR

-- (Path Sleitnick Net ditambahkan di sini)
local NetRF = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net.RF["%?Jy:zLw7JB?q5\"<?p5d?k'B9yL=6"]
local NetRE = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net.RE["#F:}zpK:7EAzi4:6E"]

-- GANTI / UPDATE BAGIAN TOMBOL DI DALAM SKRIP KAMU:

-- 1. Update Fitur Set Time (Menyesuaikan dengan args terbaru kamu)
CreateButton("SET TIME (11:26)", 50, Color3.fromRGB(60, 100, 180), function()
    ReplionRemote:FireServer("", "Time", 11.26583333333335)
end)

-- 2. Update Fitur LOOP XP & ULTRA SYNC (Menggabungkan semua args baru)
CreateButton("ULTRA LOOP: OFF", 100, Color3.fromRGB(180, 60, 60), function(btn)
    isLoopingXP = not isLoopingXP
    
    if isLoopingXP then
        btn.Text = "ULTRA LOOP: ON"
        btn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        task.spawn(function()
            while isLoopingXP do
                pcall(function()
                    -- REPLION SET: XP, Tools, & Coordinate
                    ReplionRemote:FireServer("", "XP", 30)
                    ReplionRemote:FireServer("", "EquippedId", "3a82b9eb-6fe3-4b32-9e80-e9b93381f154")
                    ReplionRemote:FireServer("", "EquippedType", "Fishing Rods")
                    ReplionRemote:FireServer("", "LastCharacterCoordinate", "table: 0xc8b4f8a7f592d65f")
                    
                    -- SLEITNICK NET: RF & RE
                    NetRF:InvokeServer(-1.233184814453125, 0.5, 1772273321.91057)
                    
                    local char = Admin.Character
                    if char and char:FindFirstChild("Head") then
                        NetRE:FireServer(Admin, char.Head, 2)
                    end
                end)
                task.wait(1.2) -- Jeda loop
            end
        end)
    else
        btn.Text = "ULTRA LOOP: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end
end)

-- 3. Update Fitur AutoFishing (Sesuai args terbaru kamu)
local isFishing = false
CreateButton("AUTOFISH: OFF", 150, Color3.fromRGB(80, 80, 80), function(btn)
    isFishing = not isFishing
    
    -- Mengirim true/false sesuai status toggle
    ReplionRemote:FireServer("", "AutoFishing", isFishing)
    
    if isFishing then
        btn.Text = "AUTOFISH: ON"
        btn.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
    else
        btn.Text = "AUTOFISH: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)
