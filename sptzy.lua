local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")

-- Setup GUI Utama
ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Name = "AutoFarm_Ikyy_V2"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 360)
MainFrame.Active = true
MainFrame.Draggable = true -- Fitur Geser

Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTO FARM V2 (LOOP)"
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

UIListLayout.Parent = MainFrame
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fungsi Helper untuk Tombol Toggle (Loop)
local function CreateToggle(txt, offColor, onColor, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = "OFF: " .. txt
    btn.BackgroundColor3 = offColor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.Parent = MainFrame
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.Text = "ON: " .. txt
            btn.BackgroundColor3 = onColor
            task.spawn(function()
                while active do
                    func()
                    task.wait(1) -- Jeda antar aksi (bisa dikurangi jika kurang cepat)
                end
            end)
        else
            btn.Text = "OFF: " .. txt
            btn.BackgroundColor3 = offColor
        end
    end)
end

-- 1. AUTO BELI (SHOP)
CreateToggle("Beli Padi", Color3.fromRGB(70, 70, 70), Color3.fromRGB(0, 120, 215), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
end)

-- 2. AUTO TANAM (PLANT)
CreateToggle("Auto Plant", Color3.fromRGB(70, 70, 70), Color3.fromRGB(34, 139, 34), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.PlantCrop:FireServer("-109.92976379394531, 39.296875, -270.92852783203125")
end)

-- 3. AUTO PANEN (HARVEST)
CreateToggle("Auto Harvest", Color3.fromRGB(70, 70, 70), Color3.fromRGB(218, 165, 32), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.HarvestCrop:FireServer("Padi", 1, "Padi")
end)

-- 4. AUTO JUAL (SELL)
CreateToggle("Auto Sell", Color3.fromRGB(70, 70, 70), Color3.fromRGB(139, 0, 0), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45)
end)

-- 5. AUTO EQUIP KITE
CreateToggle("Auto Kite", Color3.fromRGB(70, 70, 70), Color3.fromRGB(100, 50, 150), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.KiteEvent:FireServer("equip", game.Players.LocalPlayer)
end)

-- Tombol Get Bibit Sekali Klik (Bukan Loop)
local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0.9, 0, 0, 35)
getBtn.Text = "GET BIBIT FREE"
getBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
getBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getBtn.Parent = MainFrame
getBtn.MouseButton1Click:Connect(function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.GetBibit:FireServer(0, false)
end)
