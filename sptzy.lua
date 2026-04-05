local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Cleanup
if CoreGui:FindFirstChild("Ikyy_StaticGhost_V26") then CoreGui:FindFirstChild("Ikyy_StaticGhost_V26"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_StaticGhost_V26"
ScreenGui.Parent = CoreGui

-- UI Design (Dark Ghost Theme)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 380)
Main.Position = UDim2.new(0.5, -130, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Parent = ScreenGui
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 15) Corner.Parent = Main
local Stroke = Instance.new("UIStroke") Stroke.Thickness = 2 Stroke.Color = Color3.fromRGB(100, 100, 255) Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "STATIC GHOST V26"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.TextColor3 = Color3.fromRGB(150, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = Main

-- TOGGLE GHOST (STAY IN PLACE)
local GhostToggle = Instance.new("TextButton")
GhostToggle.Size = UDim2.new(1, -20, 0, 45)
GhostToggle.Position = UDim2.new(0, 10, 0, 50)
GhostToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
GhostToggle.Text = "GHOST MODE: OFF"
GhostToggle.TextColor3 = Color3.fromRGB(200, 200, 200)
GhostToggle.Font = Enum.Font.GothamBold
GhostToggle.TextSize = 11
GhostToggle.Parent = Main
local GCorner = Instance.new("UICorner") GCorner.CornerRadius = UDim.new(0, 10) GCorner.Parent = GhostToggle

-- PLAYER LIST
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 110)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Main
local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 5)

-- LOGIKA GHOST (TANPA PINDAH POSISI)
local GhostActive = false

local function SetGhost(state)
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Menghilangkan Nama (HumanoidDisplay)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayDistanceType = state and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
    end

    -- Menghilangkan Semua Part Tubuh & Aksesori
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            -- Local Transparency agar Client tetap bisa lihat diri sendiri tipis-tipis
            -- Tapi Server akan melihatmu hilang jika game tidak punya proteksi transparency
            v.Transparency = state and 1 or 0
            if v.Name == "HumanoidRootPart" then v.Transparency = 1 end
        end
    end
end

GhostToggle.MouseButton1Click:Connect(function()
    GhostActive = not GhostActive
    GhostToggle.Text = GhostActive and "GHOST MODE: ACTIVE (HIDDEN)" or "GHOST MODE: OFF"
    GhostToggle.BackgroundColor3 = GhostActive and Color3.fromRGB(50, 50, 150) or Color3.fromRGB(20, 20, 30)
    SetGhost(GhostActive)
end)

-- LOGIKA FLING (SAMA SEPERTI SEBELUMNYA TAPI OPTIMIZED)
local function FlingPlayer(target)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local tchar = target.Character
    local thrp = tchar and tchar:FindFirstChild("HumanoidRootPart")
    
    if hrp and thrp then
        local oldPos = hrp.CFrame
        
        -- Aktifkan Power Rotasi
        local bAV = Instance.new("BodyAngularVelocity")
        bAV.Parent = hrp
        bAV.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bAV.P = 10^12
        bAV.AngularVelocity = Vector3.new(9e9, 9e9, 9e9)
        
        -- Ghost Hitbox (Tabrakan tanpa memantul)
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
        hrp.CanCollide = true
        
        -- Teleport kilat ke target (Headsit)
        hrp.CFrame = thrp.CFrame * CFrame.new(0, 1.5, 0)
        task.wait(0.3) -- Tabrakan brutal
        
        -- Reset Posisi & Gaya
        bAV:Destroy()
        hrp.CFrame = oldPos
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

-- UI LIST GENERATOR
local function UpdateList()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Btn.Text = "  " .. p.DisplayName
            Btn.TextColor3 = Color3.new(1, 1, 1)
            Btn.Font = Enum.Font.GothamSemibold
            Btn.TextSize = 10
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Scroll
            local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(0, 5) BCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                FlingPlayer(p)
            end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end

UpdateList()
Players.PlayerAdded:Connect(UpdateList)
Players.PlayerRemoving:Connect(UpdateList)

-- Draggable UI
local d, di, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
