-- [[ ULTRA KILL REAL - SPTZYY ]] --
-- Logika: Force CFrame Bring + Void Kill (Nyata dilihat server)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_KillSystem"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Variabel State
_G.KillAllActive = false
local RadiusKill = 500

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
MainGui.Size = UDim2.new(0, 240, 0, 250)
MainGui.Position = UDim2.new(0.5, -120, 0.5, -125)
MainGui.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainGui.Visible = false
Instance.new("UICorner", MainGui)

local Title = Instance.new("TextLabel", MainGui)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.Text = "KILL FITUR SPTZYY"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

-- Fungsi Notifikasi
local function Notify(msg)
    local n = Instance.new("TextLabel", ScreenGui)
    n.Size = UDim2.new(0, 200, 0, 40)
    n.Position = UDim2.new(0.5, -100, 0.9, 0)
    n.Text = "💀 " .. msg
    n.BackgroundColor3 = Color3.new(0,0,0)
    n.TextColor3 = Color3.new(1,0,0)
    Instance.new("UICorner", n)
    n:TweenPosition(UDim2.new(0.5, -100, 0.5, 0), "Out", "Back", 1)
    task.delay(1, function() n:Destroy() end)
end

-- ==========================================
-- LOGIKA KILL NYATA (CFrame Bring to Void)
-- ==========================================
RunService.Heartbeat:Connect(function()
    if _G.KillAllActive then
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= lp and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChild("Humanoid")
                    
                    if targetRoot and hum and hum.Health > 0 then
                        -- Metode Kill: Paksa CFrame ke bawah Map (Void)
                        -- Pemain lain akan melihat target jatuh menembus lantai dan mati
                        targetRoot.CFrame = CFrame.new(targetRoot.Position.X, -500, targetRoot.Position.Z)
                        
                        -- Alternatif: Tabrakkan ke posisi kita dengan kecepatan tinggi
                        -- targetRoot.CFrame = root.CFrame * CFrame.new(0, 0, -1)
                        -- targetRoot.Velocity = Vector3.new(0, -1000, 0)
                    end
                end
            end
        end
    end
end)

-- Tombol Menu
local function NewBtn(txt, pos, color, func)
    local b = Instance.new("TextButton", MainGui)
    b.Size = UDim2.new(0.9, 0, 0, 50)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
    return b
end

NewBtn("KILL ALL SERVER", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(200, 0, 0), function(self)
    _G.KillAllActive = not _G.KillAllActive
    self.Text = _G.KillAllActive and "STOP KILL" or "KILL ALL SERVER"
    self.BackgroundColor3 = _G.KillAllActive and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(200, 0, 0)
    Notify(_G.KillAllActive and "Killing Everyone!" or "Stopped")
end)

NewBtn("CLOSE MENU", UDim2.new(0.05, 0, 0.65, 0), Color3.fromRGB(30, 30, 30), function()
    MainGui.Visible = false
end)

SupportIcon.MouseButton1Click:Connect(function() 
    MainGui.Visible = not MainGui.Visible 
end)
