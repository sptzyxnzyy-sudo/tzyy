-- [[ ULTRA REAL JAIL & MAGNET - SPTZYY ]] --
-- Logika: Physical Cage + Persistent CFrame Lock (Server-Side Feel)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Real_Jail"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Variabel State
_G.MagnetActive = false
_G.JailList = {} 
local MagnetRadius = 200

-- UI Setup (Icon Support)
local SupportIcon = Instance.new("ImageButton", ScreenGui)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.Draggable = true
SupportIcon.Active = true
Instance.new("UICorner", SupportIcon).CornerRadius = UDim.new(1, 0)

-- Main Frame
local MainGui = Instance.new("Frame", ScreenGui)
MainGui.Size = UDim2.new(0, 260, 0, 350)
MainGui.Position = UDim2.new(0.5, -130, 0.5, -175)
MainGui.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainGui.Visible = false
Instance.new("UICorner", MainGui)

local Title = Instance.new("TextLabel", MainGui)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "COPY FITUR SPTZYY - REAL"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

-- Fungsi Buat Kandang (Nyata di Workspace)
local function CreateCage(pos)
    local CageFolder = Instance.new("Folder", game.Workspace)
    CageFolder.Name = "Sptzyy_Cage"
    
    local parts = {
        {size = Vector3.new(12, 1, 12), pos = Vector3.new(0, -5, 0)}, -- Lantai
        {size = Vector3.new(12, 1, 12), pos = Vector3.new(0, 5, 0)},  -- Atap
        {size = Vector3.new(1, 10, 12), pos = Vector3.new(6, 0, 0)},  -- Dinding 1
        {size = Vector3.new(1, 10, 12), pos = Vector3.new(-6, 0, 0)}, -- Dinding 2
        {size = Vector3.new(12, 10, 1), pos = Vector3.new(0, 0, 6)},  -- Dinding 3
        {size = Vector3.new(12, 10, 1), pos = Vector3.new(0, 0, -6)}, -- Dinding 4
    }
    
    for _, pInfo in pairs(parts) do
        local p = Instance.new("Part", CageFolder)
        p.Size = pInfo.size
        p.CFrame = pos * CFrame.new(pInfo.pos)
        p.Anchored = true
        p.Material = Enum.Material.ForceField -- Biar terlihat transparan tapi nyata
        p.Color = Color3.fromRGB(255, 0, 0)
        p.Transparency = 0.5
    end
    return CageFolder
end

-- Fungsi Notifikasi
local function Notify(msg)
    local n = Instance.new("TextLabel", ScreenGui)
    n.Size = UDim2.new(0, 250, 0, 45)
    n.Position = UDim2.new(0.5, -125, 0.85, 0)
    n.Text = "⚡ " .. msg
    n.BackgroundColor3 = Color3.new(0,0,0)
    n.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", n)
    n:TweenPosition(UDim2.new(0.5, -125, 0.45, 0), "Out", "Back", 1)
    task.delay(2, function() n:Destroy() end)
end

-- LOGIKA CORE (Persistent)
RunService.Heartbeat:Connect(function()
    -- Magnet Logic
    if _G.MagnetActive then
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= lp and player.Character then
                    local tRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if tRoot and (root.Position - tRoot.Position).Magnitude < MagnetRadius then
                        tRoot.CFrame = root.CFrame * CFrame.new(0, 0, -5)
                    end
                end
            end
        end
    end

    -- Jail Logic (Anti-Respawn)
    for playerName, jailPos in pairs(_G.JailList) do
        local target = Players:FindFirstChild(playerName)
        if target and target.Character then
            local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                tRoot.CFrame = jailPos -- Mengunci di tengah kandang
            end
        end
    end
end)

-- Tombol Menu
local function NewBtn(txt, color, func)
    local b = Instance.new("TextButton", MainGui)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.Position = UDim2.new(0.05, 0, 0, #MainGui:GetChildren() * 55 - 60)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
    return b
end

NewBtn("MAGNET TOGGLE", Color3.fromRGB(40, 40, 40), function()
    _G.MagnetActive = not _G.MagnetActive
    Notify("Magnet: " .. (_G.MagnetActive and "AKTIF" or "MATI"))
end)

NewBtn("JAIL ALL (KANDANG NYATA)", Color3.fromRGB(150, 0, 0), function()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local jailPos = root.CFrame * CFrame.new(0, 0, -15) -- Kandang muncul di depan kamu
    local cage = CreateCage(jailPos)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lp then
            _G.JailList[player.Name] = jailPos
        end
    end
    Notify("Semua Terkurung di Kandang!")
end)

NewBtn("UNJAIL & HAPUS KANDANG", Color3.fromRGB(0, 100, 200), function()
    _G.JailList = {}
    if game.Workspace:FindFirstChild("Sptzyy_Cage") then
        game.Workspace.Sptzyy_Cage:Destroy()
    end
    Notify("Kurungan Dibersihkan")
end)

NewBtn("TUTUP MENU", Color3.fromRGB(80, 0, 0), function() MainGui.Visible = false end)

SupportIcon.MouseButton1Click:Connect(function() MainGui.Visible = not MainGui.Visible end)
