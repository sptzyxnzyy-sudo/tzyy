--[[ 
    LOGIKA: SS DRAGGABLE SQUARE PANEL
    - UI modern berbentuk persegi yang bisa digeser (Drag).
    - Auto-Scan Plot: Mencari lahan terdekat secara otomatis.
    - Full Loop: Beli, Tanam, Panen, Jual.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TutorialRemotes")

-- Cari Pemain (Owner)
local Admin = nil
for _, p in pairs(Players:GetPlayers()) do
    Admin = p
    break
end

if Admin then
    local isLooping = false

    -- === 1. PEMBUATAN UI PERSEGI (DRAGGABLE) ===
    local UI = Instance.new("ScreenGui", Admin.PlayerGui)
    UI.Name = "SS_Square_Hub"
    UI.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", UI)
    MainFrame.Size = UDim2.new(0, 180, 0, 180) -- Bentuk Persegi Sempurna
    MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true -- Fitur geser otomatis

    -- Variasi Estetika
    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 8)
    
    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.5

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "FARM PANEL"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.BackgroundTransparency = 1

    local StatusIndicator = Instance.new("Frame", MainFrame)
    StatusIndicator.Size = UDim2.new(0, 10, 0, 10)
    StatusIndicator.Position = UDim2.new(0.1, 0, 0.1, 8)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Instance.new("UICorner", StatusIndicator).CornerRadius = UDim.new(1, 0)

    local ToggleBtn = Instance.new("TextButton", MainFrame)
    ToggleBtn.Size = UDim2.new(0.8, 0, 0, 80)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleBtn.Text = "START"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 20
    Instance.new("UICorner", ToggleBtn)

    local Footer = Instance.new("TextLabel", MainFrame)
    Footer.Size = UDim2.new(1, 0, 0, 20)
    Footer.Position = UDim2.new(0, 0, 0.85, 0)
    Footer.Text = "SS INJECTOR ACTIVE"
    Footer.TextColor3 = Color3.new(1, 1, 1)
    Footer.TextTransparency = 0.6
    Footer.TextSize = 10
    Footer.BackgroundTransparency = 1

    -- === 2. FUNGSI SCAN KORDINAT ===
    local function GetAutoPos()
        local char = Admin.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
        
        local targetPos = nil
        local distLimit = 50
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("plot") or obj.Name:lower():find("tanah")) then
                local d = (char.HumanoidRootPart.Position - obj.Position).Magnitude
                if d < distLimit then
                    distLimit = d
                    targetPos = obj.Position
                end
            end
        end
        return targetPos or (char.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
    end

    -- === 3. LOOPING SERVER-SIDE ===
    local function RunFarm()
        task.spawn(function()
            while isLooping do
                pcall(function()
                    local pos = GetAutoPos()
                    local coordStr = string.format("%f, %f, %f", pos.X, pos.Y, pos.Z)

                    -- Urutan Remote (Sesuai Args Kamu)
                    Remotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
                    Remotes.GetBibit:FireServer(0, false)
                    Remotes.PlantCrop:FireServer(coordStr)
                    
                    task.wait(0.3)
                    
                    Remotes.HarvestCrop:FireServer("Padi", 1, "Padi")
                    Remotes.RequestSell:InvokeServer("SELL", "Padi", 45)
                    
                    -- Kite Sync
                    Remotes.KiteEvent:FireServer("equip", Admin)
                    task.wait(0.1)
                    Remotes.KiteEvent:FireServer("unequip", Admin)
                end)
                task.wait(0.5)
            end
        end)
    end

    -- === 4. LOGIKA TOMBOL & DRAG ===
    ToggleBtn.MouseButton1Click:Connect(function()
        isLooping = not isLooping
        if isLooping then
            ToggleBtn.Text = "STOP"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            StatusIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            RunFarm()
        else
            ToggleBtn.Text = "START"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)

    print("SS Square Panel Injected!")
end
