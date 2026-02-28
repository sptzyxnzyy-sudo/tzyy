-- JALANKAN DI SERVER-SIDE EXECUTOR
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. TUNGGU PEMAIN & PLAYERGUI (AGAR GUI PASTI MUNCUL)
local function GetAdmin()
    local p = Players:GetPlayers()[1]
    local timeout = 0
    while (not p or not p:FindFirstChild("PlayerGui")) and timeout < 10 do
        task.wait(1)
        p = Players:GetPlayers()[1]
        timeout = timeout + 1
    end
    return p
end

local Admin = GetAdmin()
if not Admin then return end

-- 2. AKSES REMOTE (REPLION & NET)
local Packages = ReplicatedStorage:WaitForChild("Packages", 5)
local Index = Packages and Packages:WaitForChild("_Index", 5)

-- Remote Replion
local ReplionRemote = Index and Index["ytrev_replion@2.0.0-rc.3"] and Index["ytrev_replion@2.0.0-rc.3"].replion.Remotes.Set
-- Remote Sleitnick Net
local NetRF = Index and Index["sleitnick_net@0.2.0"] and Index["sleitnick_net@0.2.0"].net.RF["%?Jy:zLw7JB?q5\"<?p5d?k'B9yL=6"]
local NetRE = Index and Index["sleitnick_net@0.2.0"] and Index["sleitnick_net@0.2.0"].net.RE["#F:}zpK:7EAzi4:6E"]

-- 3. PEMBERSIHAN UI LAMA
if Admin.PlayerGui:FindFirstChild("SS_Mega_Square") then
    Admin.PlayerGui.SS_Mega_Square:Destroy()
end

-- 4. PEMBUATAN UI PERSEGI (DRAGGABLE)
local UI = Instance.new("ScreenGui")
UI.Name = "SS_Mega_Square"
UI.ResetOnSpawn = false
UI.DisplayOrder = 99999
UI.Parent = Admin.PlayerGui

local MainFrame = Instance.new("Frame", UI)
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true -- BISA DIGESER

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MEGA HUB SS"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- 5. FUNGSI EKSEKUSI SEMUA FITUR (REPLION + NET)
local isLooping = false
local function ExecuteUltraLogic()
    pcall(function()
        if ReplionRemote then
            -- Set Time & Environment
            ReplionRemote:FireServer("", "Time", 11.26583333333335)
            ReplionRemote:FireServer("", "LastCharacterCoordinate", "table: 0xc8b4f8a7f592d65f")
            
            -- Set Fishing Tools & XP
            ReplionRemote:FireServer("", "EquippedId", "3a82b9eb-6fe3-4b32-9e80-e9b93381f154")
            ReplionRemote:FireServer("", "EquippedType", "Fishing Rods")
            ReplionRemote:FireServer("", "XP", 30)
            ReplionRemote:FireServer("", "AutoFishing", true)
        end

        -- Sleitnick Net Invocation
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

-- 6. TOMBOL TOGGLE (SQUARE DESIGN)
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 140)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
ToggleBtn.Text = "START ULTRA"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
Instance.new("UICorner", ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    if isLooping then
        ToggleBtn.Text = "STOP"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        task.spawn(function()
            while isLooping do
                ExecuteUltraLogic()
                task.wait(1) -- Kecepatan siklus
            end
        end)
    else
        ToggleBtn.Text = "START ULTRA"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        if ReplionRemote then
            ReplionRemote:FireServer("", "AutoFishing", false)
        end
    end
end)

print("Mega Hub Injected to " .. Admin.Name)
