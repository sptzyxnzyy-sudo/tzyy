-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE EDITION (V2 - VEHICLE SUPPORT) ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 200      -- Jangkauan lebih luas
local orbitHeight = 12      -- Lebih tinggi agar tidak nyangkut di tanah
local orbitRadius = 15     
local spinSpeed = 150       
local followStrength = 120  -- Power ditingkatkan untuk menarik part berat

-- [[ LOGIKA PHYSICS & CONSTRAINT BREAKER ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    -- Target posisi melingkar di atas kepala
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(workspace:GetDescendants()) do
        -- Filter: Bukan punya kita, tidak di-anchor, dan merupakan BasePart (Part, MeshPart, Wedge)
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            local distance = (part.Position - rootPart.Position).Magnitude
            
            if distance <= pullRadius then
                -- 1. BREAK JOINTS (Kunci utama untuk mobil/unanchored parts yang nempel)
                -- Menghancurkan Weld, Glue, TouchTransmitter, dan Constraints
                for _, obj in pairs(part:GetChildren()) do
                    if obj:IsA("Constraint") or obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("ManualWeld") or obj:IsA("Motor6D") then
                        obj:Destroy()
                    end
                end

                -- 2. CLAIM OWNERSHIP
                -- Mengambil alih kendali physics part agar tidak lag/delay
                if part.ReceiveAge > 0 then -- Cek kepemilikan
                    pcall(function() part:SetNetworkOwner(lp) end)
                end

                -- 3. APPLY FORCE (VELOCITY)
                -- Menghitung arah ke target
                local direction = (targetPos - part.Position)
                part.Velocity = direction * (followStrength / 5) -- Penyesuaian power
                
                -- 4. ANTI-GRAVITY & MASSLESS (Agar mobil terasa ringan)
                part.CanCollide = false -- Opsional: agar mobil tidak menabrak player
                if part.Massless == false then part.Massless = true end
                
                -- Putaran rotasi agar part terlihat "hidup" saat terbang
                part.RotVelocity = Vector3.new(5, 10, 5)
            end
        end
    end
end)

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SptzyyBeastV2"

-- Icon Floating
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconButton.Image = "rbxassetid://6031094678"
local IconCorner = Instance.new("UICorner", IconButton)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(255, 0, 0)
IconStroke.Thickness = 3

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 230, 0, 180)
MainFrame.Position = UDim2.new(0.5, -115, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "BEAST MOBILE V2"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextSize = 18

local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.9, 0, 0, 50)
StatusBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
StatusBtn.Text = "MAGNET: ON"
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", StatusBtn)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 60)
Info.Position = UDim2.new(0, 0, 0.65, 0)
Info.Text = "TARGET: VEHICLES & PARTS\nWELD BREAKER: ACTIVE\nSTRENGTH: OVERLOAD"
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.TextSize = 11
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Code

-- [[ DRAG & TOGGLE ]] --
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

MakeDraggable(IconButton)
MakeDraggable(MainFrame)

IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 50, 50)
    IconStroke.Color = StatusBtn.BackgroundColor3
end)
