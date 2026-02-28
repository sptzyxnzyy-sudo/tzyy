--[[ 
    LOGIKA: SS ULTRA SQUARE INJECTOR
    - UI: Persegi, Draggable (bisa digeser), Modern.
    - Logic: Full Replion & Sleitnick Net Sync.
    - Automation: Auto Identity (otomatis mendeteksi namamu).
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- PATH REMOTES (Replion & Sleitnick Net)
local ReplionSet = ReplicatedStorage:WaitForChild("Packages")._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Set
local NetRF = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net.RF["%?Jy:zLw7JB?q5\"<?p5d?k'B9yL=6"]
local NetRE = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net.RE["#F:}zpK:7EAzi4:6E"]

-- Deteksi Admin Otomatis
local Admin = nil
for _, p in pairs(Players:GetPlayers()) do
    Admin = p
    break
end

if Admin then
    local isUltraLoop = false

    -- === 1. PEMBUATAN UI PERSEGI (DRAGGABLE) ===
    local UI = Instance.new("ScreenGui", Admin.PlayerGui)
    UI.Name = "SS_Ultra_Square_Hub"
    UI.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", UI)
    MainFrame.Size = UDim2.new(0, 180, 0, 180) -- Persegi Sempurna
    MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Active = true
    MainFrame.Draggable = true -- BISA DIGESER
    
    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 12)
    
    local UIStroke = Instance.new("UIStroke", MainFrame)
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.5

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Text = "ULTRA FISH SS"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.BackgroundTransparency = 1

    local ToggleBtn = Instance.new("TextButton", MainFrame)
    ToggleBtn.Size = UDim2.new(0.8, 0, 0, 100)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleBtn.Text = "START"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 22
    Instance.new("UICorner", ToggleBtn)

    -- === 2. LOGIKA INJEKSI DATA (REALTIME) ===
    local function RunUltraProcess()
        pcall(function()
            -- Replion Set: Environment & Items
            ReplionSet:FireServer("", "Time", 11.26583333333335)
            ReplionSet:FireServer("", "EquippedId", "3a82b9eb-6fe3-4b32-9e80-e9b93381f154")
            ReplionSet:FireServer("", "EquippedType", "Fishing Rods")
            ReplionSet:FireServer("", "AutoFishing", true)
            ReplionSet:FireServer("", "LastCharacterCoordinate", "table: 0xc8b4f8a7f592d65f")

            -- Sleitnick Net: Invoke RF
            NetRF:InvokeServer(-1.233184814453125, 0.5, 1772273321.91057)
            
            -- Sleitnick Net: Fire RE (Otomatis target ke Head kamu)
            local char = Admin.Character
            if char and char:FindFirstChild("Head") then
                NetRE:FireServer(Admin, char.Head, 2)
            end
        end)
    end

    -- === 3. KONTROL TOMBOL & LOOP ===
    ToggleBtn.MouseButton1Click:Connect(function()
        isUltraLoop = not isUltraLoop
        if isUltraLoop then
            ToggleBtn.Text = "STOP"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            
            task.spawn(function()
                while isUltraLoop do
                    RunUltraProcess()
                    task.wait(1) -- Kecepatan Loop (1 detik)
                end
            end)
        else
            ToggleBtn.Text = "START"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            
            -- Matikan AutoFish saat stop
            ReplionSet:FireServer("", "AutoFishing", false)
        end
    end)

    print("SS Ultra Square Hub Injected!")
end
