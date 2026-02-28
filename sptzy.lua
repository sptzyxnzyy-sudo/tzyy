-- JALANKAN DI SERVER-SIDE EXECUTOR
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. TUNGGU PEMAIN (Agar tidak Nil)
local function GetAdmin()
    local p = Players:GetPlayers()[1] -- Mengambil pemain pertama yang ada
    while not p or not p:FindFirstChild("PlayerGui") do
        task.wait(1)
        p = Players:GetPlayers()[1]
    end
    return p
end

local Admin = GetAdmin()

-- 2. AKSES REMOTE DENGAN VALIDASI
local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
local Index = Packages and Packages:WaitForChild("_Index", 10)

local ReplionSet = Index and Index["ytrev_replion@2.0.0-rc.3"] and Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Set
local NetRF = Index and Index["sleitnick_net@0.2.0"] and Index["sleitnick_net@0.2.0"].net.RF["%?Jy:zLw7JB?q5\"<?p5d?k'B9yL=6"]
local NetRE = Index and Index["sleitnick_net@0.2.0"] and Index["sleitnick_net@0.2.0"].net.RE["#F:}zpK:7EAzi4:6E"]

-- 3. PEMBUATAN UI (DIPAKSA MUNCUL)
-- Hapus UI lama jika ada agar tidak double
if Admin.PlayerGui:FindFirstChild("SS_Ultra_Square_Fixed") then
    Admin.PlayerGui.SS_Ultra_Square_Fixed:Destroy()
end

local UI = Instance.new("ScreenGui")
UI.Name = "SS_Ultra_Square_Fixed"
UI.ResetOnSpawn = false
UI.DisplayOrder = 99999 -- Sangat tinggi agar di depan sendiri
UI.Parent = Admin.PlayerGui

local MainFrame = Instance.new("Frame", UI)
MainFrame.Size = UDim2.new(0, 180, 0, 180)
MainFrame.Position = UDim2.new(0.5, -90, 0.4, 0) -- Tengah layar
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true -- Support Mobile Drag

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 15)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "ULTRA FISH"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 90)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
ToggleBtn.Text = "START"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 25
Instance.new("UICorner", ToggleBtn)

-- 4. LOGIKA EKSEKUSI
local isUltraLoop = false

local function RunUltraProcess()
    pcall(function()
        if ReplionSet then
            ReplionSet:FireServer("", "Time", 11.26583333333335)
            ReplionSet:FireServer("", "EquippedId", "3a82b9eb-6fe3-4b32-9e80-e9b93381f154")
            ReplionSet:FireServer("", "EquippedType", "Fishing Rods")
            ReplionSet:FireServer("", "AutoFishing", true)
            ReplionSet:FireServer("", "LastCharacterCoordinate", "table: 0xc8b4f8a7f592d65f")
        end
        if NetRF then
            NetRF:InvokeServer(-1.233184814453125, 0.5, 1772273321.91057)
        end
        if NetRE then
            local char = Admin.Character
            if char and char:FindFirstChild("Head") then
                NetRE:FireServer(Admin, char.Head, 2)
            end
        end
    end)
end

-- 5. KONEKSI TOMBOL
ToggleBtn.MouseButton1Click:Connect(function()
    isUltraLoop = not isUltraLoop
    if isUltraLoop then
        ToggleBtn.Text = "STOP"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.spawn(function()
            while isUltraLoop do
                RunUltraProcess()
                task.wait(1)
            end
        end)
    else
        ToggleBtn.Text = "START"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        if ReplionSet then
            ReplionSet:FireServer("", "AutoFishing", false)
        end
    end
end)

print("UI Berhasil Dikirim ke " .. Admin.Name)
