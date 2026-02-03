-- [[ SPTZYY PART CONTROLLER: ULTIMATE MOBILE EDITION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 50      -- Jarak deteksi part
local orbitHeight = 7      -- Tinggi part di atas kepala
local orbitRadius = 8      -- Jarak putaran part dari badan
local spinSpeed = 3        -- Kecepatan putaran
local followStrength = 15  -- Kekuatan tarikan (Velocity)

-- [[ LOGIKA PHYSICS (SPIN & MAGNET) ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    
    -- Kalkulasi posisi orbit melingkar (Circular Orbit)
    local targetPos = rootPart.Position + Vector3.new(
        math.cos(angle) * orbitRadius, 
        orbitHeight, 
        math.sin(angle) * orbitRadius
    )

    for _, part in pairs(workspace:GetDescendants()) do
        -- Hanya kontrol part yang tidak di-anchor dan bukan bagian dari karakter kita
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            local distance = (part.Position - rootPart.Position).Magnitude
            
            if distance <= pullRadius then
                -- Mengambil Network Ownership agar physics tidak lag (Mobile Support)
                pcall(function()
                    if part.ReceiveAge == 0 then 
                        part:SetNetworkOwner(lp) 
                    end
                end)
                
                -- Menerapkan gaya tarik menggunakan Velocity
                part.Velocity = (targetPos - part.Position) * followStrength
                
                -- Anti-Gravity sederhana agar part tidak mudah jatuh ke void
                if part.Velocity.Y < 0 then
                    part.Velocity = part.Velocity + Vector3.new(0, 2, 0)
                end
            end
        end
    end
end)

-- [[ UI SETUP: MOBILE OPTIMIZED ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyPartControl"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 160, 255)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Header Area (Area untuk Drag)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 35)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "PART CONTROLLER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Status Button
local StatusBtn = Instance.new("TextButton")
StatusBtn.Name = "StatusBtn"
StatusBtn.Parent = MainFrame
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
StatusBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
StatusBtn.Size = UDim2.new(0.85, 0, 0, 45)
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.Text = "STATUS: ACTIVE"
StatusBtn.TextColor3 = Color3.new(1, 1, 1)
StatusBtn.TextSize = 12

local BtnCorner = Instance.new("UICorner")
BtnCorner.Parent = StatusBtn

-- Instructions Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
InfoLabel.Size = UDim2.new(0.9, 0, 0, 40)
InfoLabel.Font = Enum.Font.GothamMedium
InfoLabel.Text = "CARA PAKAI:\nDekati Part Unanchored\nGeser GUI ini sesukamu!"
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.TextSize = 10

-- [[ LOGIKA DRAG BEBAS (MOBILE FRIENDLY) ]] --
local dragToggle, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

-- [[ TOGGLE STATUS ]] --
StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    if botActive then
        StatusBtn.Text = "STATUS: ACTIVE"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        Stroke.Color = Color3.fromRGB(0, 160, 255)
    else
        StatusBtn.Text = "STATUS: OFF"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        Stroke.Color = Color3.fromRGB(150, 50, 50)
    end
end)

print("Part Controller Loaded Successfully!")
