-- [[ MAGNET ROPE ULTRA RADIUS - SPTZYY ]] --

local ScreenGui = Instance.new("ScreenGui")
local SupportIcon = Instance.new("ImageButton")
local MainGui = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local RadiusBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local TweenService = game:GetService("TweenService")

-- State & Konfigurasi
_G.MagnetActive = false
local RadiusOptions = {50, 150, 500, 1000} -- Opsi jarak tarikan
local CurrentRadiusIndex = 2 -- Default 150
local MagnetRadius = RadiusOptions[CurrentRadiusIndex]

-- UI Setup (CoreGui)
ScreenGui.Name = "Sptzyy_UltraMagnet"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Icon Support (Bisa Digeser)
SupportIcon.Name = "SupportIcon"
SupportIcon.Parent = ScreenGui
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SupportIcon.Active = true
SupportIcon.Draggable = true
local CornerIcon = Instance.new("UICorner")
CornerIcon.CornerRadius = UDim.new(1, 0)
CornerIcon.Parent = SupportIcon

-- Main Frame
MainGui.Parent = ScreenGui
MainGui.Size = UDim2.new(0, 240, 0, 280)
MainGui.Position = UDim2.new(0.5, -120, 0.5, -140)
MainGui.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainGui.Visible = false
local CornerMain = Instance.new("UICorner")
CornerMain.Parent = MainGui

-- Judul GUI
Title.Parent = MainGui
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(100, 0, 255)
Title.Text = "MAGNET FITUR SPTZYY"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = Title

-- Fungsi Notifikasi Melayang
local function Notify(text)
    local Label = Instance.new("TextLabel")
    Label.Parent = ScreenGui
    Label.Size = UDim2.new(0, 220, 0, 40)
    Label.Position = UDim2.new(0.5, -110, 0.9, 0)
    Label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Label.TextColor3 = Color3.fromRGB(0, 255, 150)
    Label.Text = "🧲 " .. text
    Label.Font = Enum.Font.GothamBold
    local c = Instance.new("UICorner")
    c.Parent = Label
    
    Label:TweenPosition(UDim2.new(0.5, -110, 0.45, 0), "Out", "Back", 1)
    task.delay(1.5, function() Label:Destroy() end)
end

-- LOGIKA MAGNET ROPE (Sangat Kuat)
task.spawn(function()
    while task.wait(0.3) do
        if _G.MagnetActive then
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root then
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetRoot = player.Character.HumanoidRootPart
                        local dist = (root.Position - targetRoot.Position).Magnitude
                        
                        if dist < MagnetRadius then
                            if not targetRoot:FindFirstChild("SptzyyRope") then
                                -- Buat Attachment di tubuh kita
                                local att0 = root:FindFirstChild("SptzyyAtt") or Instance.new("Attachment", root)
                                att0.Name = "SptzyyAtt"
                                
                                -- Buat Attachment di tubuh target
                                local att1 = Instance.new("Attachment", targetRoot)
                                att1.Name = "TargetAtt"
                                
                                -- Buat RopeConstraint
                                local rope = Instance.new("RopeConstraint")
                                rope.Name = "SptzyyRope"
                                rope.Parent = targetRoot
                                rope.Attachment0 = att0
                                rope.Attachment1 = att1
                                rope.Length = 0
                                rope.Restitution = 1 -- Efek pegas tarikan kuat
                                rope.Visible = true
                                rope.Color = BrickColor.new("Bright blue")
                                rope.Thickness = 0.1
                            end
                        end
                    end
                end
            end
        else
            -- Bersihkan jika off
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name == "SptzyyRope" or v.Name == "SptzyyAtt" or v.Name == "TargetAtt" then
                    v:Destroy()
                end
            end
        end
    end
end)

-- Tombol Toggle Aktif
ToggleBtn.Parent = MainGui
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBtn.Text = "STATUS: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
local c1 = Instance.new("UICorner") c1.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    _G.MagnetActive = not _G.MagnetActive
    if _G.MagnetActive then
        ToggleBtn.Text = "MAGNET: AKTIF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        Notify("Magnet Radius " .. MagnetRadius .. " Aktif!")
    else
        ToggleBtn.Text = "MAGNET: MATI"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        Notify("Magnet Dinonaktifkan")
    end
end)

-- Tombol Ganti Radius
RadiusBtn.Parent = MainGui
RadiusBtn.Size = UDim2.new(0.9, 0, 0, 45)
RadiusBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
RadiusBtn.Text = "JARAK: 150 (SEDANG)"
RadiusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
RadiusBtn.TextColor3 = Color3.new(1,1,1)
RadiusBtn.Font = Enum.Font.GothamBold
local c2 = Instance.new("UICorner") c2.Parent = RadiusBtn

RadiusBtn.MouseButton1Click:Connect(function()
    CurrentRadiusIndex = CurrentRadiusIndex + 1
    if CurrentRadiusIndex > #RadiusOptions then CurrentRadiusIndex = 1 end
    MagnetRadius = RadiusOptions[CurrentRadiusIndex]
    
    local labels = {"KECIL", "SEDANG", "LUAS", "MAX (1000)"}
    RadiusBtn.Text = "JARAK: " .. MagnetRadius .. " (" .. labels[CurrentRadiusIndex] .. ")"
    Notify("Radius diubah ke: " .. MagnetRadius)
end)

-- Tombol Close
CloseBtn.Parent = MainGui
CloseBtn.Size = UDim2.new(0.9, 0, 0, 40)
CloseBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
CloseBtn.Text = "TUTUP MENU"
CloseBtn.TextColor3 = Color3.new(1,1,1)
local c3 = Instance.new("UICorner") c3.Parent = CloseBtn

SupportIcon.MouseButton1Click:Connect(function()
    MainGui.Visible = not MainGui.Visible
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainGui.Visible = false
end)
