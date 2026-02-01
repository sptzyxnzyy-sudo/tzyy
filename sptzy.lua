-- [[ ULTRA MAGNET BY SPTZYY - SERVER-SIDE LOGIC ]] --

local ScreenGui = Instance.new("ScreenGui")
local SupportIcon = Instance.new("ImageButton")
local MainGui = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local RadiusBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- State & Konfigurasi
_G.MagnetActive = false
local RadiusOptions = {50, 150, 500, 1000}
local CurrentRadiusIndex = 2
local MagnetRadius = RadiusOptions[CurrentRadiusIndex]

-- UI Setup
ScreenGui.Name = "Sptzyy_MagnetV2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Tombol Icon (Smooth Draggable)
SupportIcon.Parent = ScreenGui
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
local CornerIcon = Instance.new("UICorner")
CornerIcon.CornerRadius = UDim.new(1, 0)
CornerIcon.Parent = SupportIcon

-- Logika Dragging Support
local dragging, dragInput, dragStart, startPos
SupportIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = SupportIcon.Position
    end
end)
SupportIcon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        SupportIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
SupportIcon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Main Frame UI
MainGui.Parent = ScreenGui
MainGui.Size = UDim2.new(0, 240, 0, 280)
MainGui.Position = UDim2.new(0.5, -120, 0.5, -140)
MainGui.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainGui.Visible = false
Instance.new("UICorner", MainGui).CornerRadius = UDim.new(0, 10)

Title.Parent = MainGui
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(100, 0, 255)
Title.Text = "MAGNET FITUR SPTZYY"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

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
    Instance.new("UICorner", Label)
    Label:TweenPosition(UDim2.new(0.5, -110, 0.45, 0), "Out", "Back", 1)
    task.delay(1.5, function() Label:Destroy() end)
end

-- LOGIKA TARIKAN NYATA (VELOCITY + ROPE)
RunService.Heartbeat:Connect(function()
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
                        -- Logika Tarikan Fisik (Force)
                        local direction = (root.Position - targetRoot.Position).Unit
                        targetRoot.Velocity = direction * 75 -- Membuat mereka terbang ke arahmu
                        
                        -- Logika Rope Visual & Constraint
                        if not targetRoot:FindFirstChild("SptzyyRope") then
                            local att0 = root:FindFirstChild("SptzyyAtt") or Instance.new("Attachment", root)
                            att0.Name = "SptzyyAtt"
                            local att1 = Instance.new("Attachment", targetRoot)
                            att1.Name = "TargetAtt"
                            local rope = Instance.new("RopeConstraint", targetRoot)
                            rope.Name = "SptzyyRope"; rope.Attachment0 = att0; rope.Attachment1 = att1
                            rope.Length = 0; rope.Visible = true; rope.Thickness = 0.2
                            rope.Color = BrickColor.new("Bright blue")
                        end
                    end
                end
            end
        end
    else
        -- Clean up
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v.Name == "SptzyyRope" or v.Name == "TargetAtt" then v:Destroy() end
        end
    end
end)

-- Tombol Logika
ToggleBtn.Parent = MainGui; ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45); ToggleBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBtn.Text = "STATUS: OFF"; ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1,1,1); ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    _G.MagnetActive = not _G.MagnetActive
    ToggleBtn.Text = _G.MagnetActive and "MAGNET: AKTIF" or "MAGNET: MATI"
    ToggleBtn.BackgroundColor3 = _G.MagnetActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    Notify(_G.MagnetActive and "Magnet Menyedot Server!" or "Magnet Berhenti")
end)

RadiusBtn.Parent = MainGui; RadiusBtn.Size = UDim2.new(0.9, 0, 0, 45); RadiusBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
RadiusBtn.Text = "JARAK: 150 (SEDANG)"; RadiusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
RadiusBtn.TextColor3 = Color3.new(1,1,1); RadiusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RadiusBtn)

RadiusBtn.MouseButton1Click:Connect(function()
    CurrentRadiusIndex = CurrentRadiusIndex % #RadiusOptions + 1
    MagnetRadius = RadiusOptions[CurrentRadiusIndex]
    RadiusBtn.Text = "JARAK: " .. MagnetRadius
    Notify("Radius Set: " .. MagnetRadius)
end)

CloseBtn.Parent = MainGui; CloseBtn.Size = UDim2.new(0.9, 0, 0, 40); CloseBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20); CloseBtn.Text = "TUTUP MENU"
CloseBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CloseBtn)

SupportIcon.MouseButton1Click:Connect(function() MainGui.Visible = not MainGui.Visible end)
CloseBtn.MouseButton1Click:Connect(function() MainGui.Visible = false end)
