-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE EXTREME EDITION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150      -- Jangkauan magnet
local orbitHeight = 12      -- Tinggi part di atas kepala
local orbitRadius = 15      -- Jarak putaran part
local spinSpeed = 150       -- Kecepatan putaran orbit
local followStrength = 130  -- Kekuatan tarikan (makin tinggi makin instan)
local breakForce = 600      -- Sentakan ledakan saat tali putus

-- [[ LOGIKA PHYSICS & ANTI-RECALL ]] --
local angle = 0

local function ClaimPart(part)
    pcall(function()
        if part:IsA("BasePart") and not part.Anchored then
            part.CanCollide = true
            -- Memaksa kepemilikan fisik ke kita (Anti-Back)
            if part.ReceiveAge > 0 then 
                part:SetNetworkOwner(lp)
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * (spinSpeed / 10))
    local rootPart = lp.Character.HumanoidRootPart
    -- Kalkulasi posisi orbit yang dinamis
    local targetPos = rootPart.Position + Vector3.new(
        math.cos(angle) * orbitRadius, 
        orbitHeight + (math.sin(angle * 0.5) * 3), -- Variasi tinggi biar estetik
        math.sin(angle) * orbitRadius
    )

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            local distance = (part.Position - rootPart.Position).Magnitude
            
            if distance <= pullRadius then
                -- 1. PENGHANCUR TALI & WELD (DEEP CLEAN)
                for _, obj in pairs(part:GetDescendants()) do
                    if obj:IsA("Constraint") or obj:IsA("Weld") or obj:IsA("ManualWeld") or obj:IsA("Snap") or obj:IsA("BallSocketConstraint") then
                        -- Beri sentakan ledakan agar part tidak nyangkut saat putus
                        part:ApplyImpulse(Vector3.new(0, breakForce, 0))
                        obj:Destroy()
                    end
                end

                -- 2. CLAIM OWNERSHIP (CEGAH BALIK KE TEMPAT ASAL)
                ClaimPart(part)

                -- 3. MANIPULASI VELOCITY (MOVEMENT)
                local direction = (targetPos - part.Position)
                part.Velocity = direction * (followStrength / 5)
                
                -- Anti-Sleep & Chaos Rotation (Agar part tidak diam/tidur secara physics)
                part.RotVelocity = Vector3.new(math.random(-10,10), spinSpeed/2, math.random(-10,10))
            end
        end
    end
end)

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SptzyyBeastV2"

-- Floating Icon
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconButton.Image = "rbxassetid://6031094678"
IconButton.BorderSizePixel = 0
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 2

-- Main Panel
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 230, 0, 190)
MainFrame.Position = UDim2.new(0.5, -115, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(40, 40, 40)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "BEAST MOBILE V2"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.85, 0, 0, 45)
StatusBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
StatusBtn.Text = "MAGNET: ON"
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", StatusBtn)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 70)
Info.Position = UDim2.new(0, 0, 0.6, 0)
Info.Text = "ROPE BREAKER: ACTIVE\nANTI-RECALL: STABLE\nNETWORK: BYPASSING"
Info.TextColor3 = Color3.fromRGB(180, 180, 180)
Info.TextSize = 11
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamMedium

-- [[ DRAG & TOGGLE SYSTEM ]] --
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

MakeDraggable(IconButton)
MakeDraggable(MainFrame)

IconButton.MouseButton1Click:Connect(function() 
    MainFrame.Visible = not MainFrame.Visible 
end)

StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    if botActive then
        StatusBtn.Text = "MAGNET: ON"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        IconStroke.Color = Color3.fromRGB(0, 255, 150)
    else
        StatusBtn.Text = "MAGNET: OFF"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        IconStroke.Color = Color3.fromRGB(255, 60, 60)
    end
end)

print("Sptzyy Beast V2 Loaded - Anti-Rubberband Active")
