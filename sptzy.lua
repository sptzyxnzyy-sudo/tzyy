--[[ 
    LOGIKA: SS ADVANCED INJECTOR (Replion + Sleitnick Net)
    - Auto-Equip: Memasang alat pancing spesifik via Replion.
    - Auto-Fish: Mengaktifkan status memancing otomatis di server.
    - Net RE/RF: Memicu fungsi internal game (sleitnick_net) secara otomatis.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- PATH REMOTES
local ReplionSet = ReplicatedStorage:WaitForChild("Packages")._Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Set
local NetRF = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net.RF["%?Jy:zLw7JB?q5\"<?p5d?k'B9yL=6"]
local NetRE = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net.RE["#F:}zpK:7EAzi4:6E"]

-- Deteksi Admin
local Admin = nil
for _, p in pairs(Players:GetPlayers()) do
    Admin = p
    break
end

if Admin then
    local isUltraLoop = false

    -- === UI PERSEGI PREMIUM (DRAGGABLE) ===
    local UI = Instance.new("ScreenGui", Admin.PlayerGui)
    UI.Name = "SS_Ultra_Hub"
    UI.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", UI)
    MainFrame.Size = UDim2.new(0, 200, 0, 220)
    MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "ULTRA FISHING SS"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1

    local ToggleBtn = Instance.new("TextButton", MainFrame)
    ToggleBtn.Size = UDim2.new(0.85, 0, 0, 140)
    ToggleBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
    ToggleBtn.Text = "START ULTRA PROCESS"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 16
    ToggleBtn.TextWrapped = true
    Instance.new("UICorner", ToggleBtn)

    -- === LOGIKA INJEKSI DATA ===
    local function RunUltraLogic()
        pcall(function()
            -- 1. Setup Environment (Waktu & Koordinat)
            ReplionSet:FireServer("", "Time", 11.26583333333335)
            ReplionSet:FireServer("", "LastCharacterCoordinate", "table: 0xc8b4f8a7f592d65f")

            -- 2. Auto Equip & Fishing (Sesuai Args Kamu)
            ReplionSet:FireServer("", "EquippedId", "3a82b9eb-6fe3-4b32-9e80-e9b93381f154")
            ReplionSet:FireServer("", "EquippedType", "Fishing Rods")
            ReplionSet:FireServer("", "AutoFishing", true)

            -- 3. Sleitnick Net Invocation (Proses Inti)
            NetRF:InvokeServer(-1.233184814453125, 0.5, 1772273321.91057)
            
            -- Net RE (Otomatis menggunakan karakter kamu sebagai target)
            local char = Admin.Character
            if char and char:FindFirstChild("Head") then
                NetRE:FireServer(Admin, char.Head, 2)
            end
        end)
    end

    -- === LOOPING HANDLER ===
    ToggleBtn.MouseButton1Click:Connect(function()
        isUltraLoop = not isUltraLoop
        if isUltraLoop then
            ToggleBtn.Text = "ULTRA ACTIVE\n(Looping...)"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
            
            task.spawn(function()
                while isUltraLoop do
                    RunUltraLogic()
                    task.wait(1) -- Jeda antar injeksi data
                end
            end)
        else
            ToggleBtn.Text = "START ULTRA PROCESS"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
            
            -- Matikan AutoFishing saat berhenti
            ReplionSet:FireServer("", "AutoFishing", false)
        end
    end)

    print("SS Ultra Hub: Replion & Sleitnick Net Injected!")
end
