--[[ 
    LOGIKA: SS REMOTE FARMER (NO TELEPORT)
    1. Scan: Mencari lahan terdekat dari posisi berdiri saat ini.
    2. Process: Mengirim sinyal Tanam, Equip, dan Panen secara beruntun.
    3. Result: Tanaman muncul dan uang bertambah di posisi tersebut secara realtime.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TutorialRemotes")

-- Otomatis mendeteksi Pengeksekusi (Admin)
local Admin = nil
for _, p in pairs(Players:GetPlayers()) do
    Admin = p
    break
end

if Admin then
    local isLooping = false

    -- === UI PERSEGI MODERN (DRAGGABLE) ===
    local UI = Instance.new("ScreenGui", Admin.PlayerGui)
    UI.Name = "SS_NoTeleport_Hub"
    UI.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", UI)
    MainFrame.Size = UDim2.new(0, 180, 0, 180)
    MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Active = true
    MainFrame.Draggable = true -- Bisa digeser di layar HP/PC
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "REMOTE FARM"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1

    local ToggleBtn = Instance.new("TextButton", MainFrame)
    ToggleBtn.Size = UDim2.new(0.8, 0, 0, 100)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
    ToggleBtn.Text = "START"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 22
    Instance.new("UICorner", ToggleBtn)

    -- === LOGIKA PENGHAPUSAN JARAK JAUH ===
    local function GetNearestPlot()
        local char = Admin.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
        
        local targetPos = nil
        local distLimit = 70 -- Jarak maksimal deteksi lahan dari karakter
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("plot") or obj.Name:lower():find("tanah")) then
                local d = (char.HumanoidRootPart.Position - obj.Position).Magnitude
                if d < distLimit then
                    distLimit = d
                    targetPos = obj.Position
                end
            end
        end
        return targetPos
    end

    local function RunRemoteFarm()
        task.spawn(function()
            while isLooping do
                pcall(function()
                    local pos = GetNearestPlot()
                    if pos then
                        -- Format koordinat menjadi string sesuai permintaan game
                        local coordStr = string.format("%f, %f, %f", pos.X, pos.Y, pos.Z)

                        -- 1. Persiapan: Beli Bibit
                        Remotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
                        Remotes.GetBibit:FireServer(0, false)

                        -- 2. Eksekusi: Tanam & Equip (Tanpa Teleport)
                        Remotes.PlantCrop:FireServer(coordStr)
                        Remotes.KiteEvent:FireServer("equip", Admin) 
                        
                        task.wait(0.3) -- Jeda proses server

                        -- 3. Finishing: Panen & Jual
                        Remotes.HarvestCrop:FireServer("Padi", 1, "Padi")
                        Remotes.RequestSell:InvokeServer("SELL", "Padi", 45)
                        
                        -- Unequip otomatis
                        Remotes.KiteEvent:FireServer("unequip", Admin)
                    end
                end)
                task.wait(0.5) -- Kecepatan siklus farm
            end
        end)
    end

    -- === KONTROL TOMBOL ===
    ToggleBtn.MouseButton1Click:Connect(function()
        isLooping = not isLooping
        if isLooping then
            ToggleBtn.Text = "STOP"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            RunRemoteFarm()
        else
            ToggleBtn.Text = "START"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
        end
    end)

    print("SS Remote Hub Injected: No Teleport Mode.")
end
