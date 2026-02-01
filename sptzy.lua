-- [[ ULTRA REAL MAGNET - SPTZYY ]] --
-- Logika: Force CFrame (Nyata dilihat orang lain)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
local SupportIcon = Instance.new("ImageButton")
local MainGui = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local RadiusBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

-- Variabel State
_G.MagnetActive = false
local RadiusOptions = {50, 200, 500, 2000}
local RadiusIdx = 2
local MagnetRadius = RadiusOptions[RadiusIdx]

-- UI Setup
ScreenGui.Name = "Sptzyy_RealMagnet"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Icon Support (Smooth Dragging)
SupportIcon.Parent = ScreenGui
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SupportIcon.Active = true
SupportIcon.Draggable = true
Instance.new("UICorner", SupportIcon).CornerRadius = UDim.new(1, 0)

-- Main Frame
MainGui.Parent = ScreenGui
MainGui.Size = UDim2.new(0, 240, 0, 260)
MainGui.Position = UDim2.new(0.5, -120, 0.5, -130)
MainGui.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainGui.Visible = false
Instance.new("UICorner", MainGui)

-- Judul
Title.Parent = MainGui
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Title.Text = "FORCE MAGNET SPTZYY"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Instance.new("UICorner", Title)

-- Fungsi Notifikasi
local function Notify(msg)
    local n = Instance.new("TextLabel", ScreenGui)
    n.Size = UDim2.new(0, 200, 0, 40)
    n.Position = UDim2.new(0.5, -100, 0.8, 0)
    n.Text = msg
    n.BackgroundColor3 = Color3.new(0,0,0)
    n.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", n)
    n:TweenPosition(UDim2.new(0.5, -100, 0.5, 0), "Out", "Quart", 1)
    task.delay(1, function() n:Destroy() end)
end

-- ==========================================
-- LOGIKA TARIKAN NYATA (CFrame Force)
-- ==========================================
RunService.RenderStepped:Connect(function()
    if _G.MagnetActive then
        local lp = game.Players.LocalPlayer
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= lp and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChild("Humanoid")
                    
                    if targetRoot and hum and hum.Health > 0 then
                        local dist = (root.Position - targetRoot.Position).Magnitude
                        
                        if dist < MagnetRadius then
                            -- Menarik target tepat di depan kita (Offset 3 stud)
                            -- Menggunakan CFrame agar tarikan absolut dan terlihat di server
                            targetRoot.CFrame = root.CFrame * CFrame.new(0, 0, -3)
                            
                            -- Tambahkan Velocity agar tidak terjadi glitch saat dilepas
                            targetRoot.Velocity = Vector3.new(0, 2, 0)
                        end
                    end
                end
            end
        end
    end
end)

-- Tombol Toggle
ToggleBtn.Parent = MainGui; ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45); ToggleBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBtn.Text = "MAGNET: OFF"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    _G.MagnetActive = not _G.MagnetActive
    ToggleBtn.Text = _G.MagnetActive and "MAGNET: AKTIF" or "MAGNET: MATI"
    ToggleBtn.BackgroundColor3 = _G.MagnetActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    Notify(_G.MagnetActive and "Sucking Players!" or "Stopped")
end)

-- Tombol Radius
RadiusBtn.Parent = MainGui; RadiusBtn.Size = UDim2.new(0.9, 0, 0, 45); RadiusBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
RadiusBtn.Text = "RADIUS: 200"; RadiusBtn.BackgroundColor3 = Color3.fromRGB(40,40,100)
RadiusBtn.TextColor3 = Color3.new(1,1,1); RadiusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RadiusBtn)

RadiusBtn.MouseButton1Click:Connect(function()
    RadiusIdx = RadiusIdx % #RadiusOptions + 1
    MagnetRadius = RadiusOptions[RadiusIdx]
    RadiusBtn.Text = "RADIUS: " .. MagnetRadius
end)

-- Tombol Close
CloseBtn.Parent = MainGui; CloseBtn.Size = UDim2.new(0.9, 0, 0, 45); CloseBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
CloseBtn.Text = "CLOSE"; CloseBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
CloseBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CloseBtn)

SupportIcon.MouseButton1Click:Connect(function() MainGui.Visible = not MainGui.Visible end)
CloseBtn.MouseButton1Click:Connect(function() MainGui.Visible = false end)
