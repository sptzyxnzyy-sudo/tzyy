-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE EDITION + UNANCHORED BRING ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 200      -- Radius ditingkatkan agar lebih efektif
local orbitHeight = 10      
local orbitRadius = 12     
local spinSpeed = 130        
local followStrength = 120  

-- [[ LOGIKA PHYSICS & TOOLS UNANCHORED ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    -- [[ LOGIKA BRING PLAYER TOOLS ]] --
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= lp and player.Character then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, part in pairs(tool:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- LOGIKA UNANCHORED: Pastikan part tidak terkunci secara physics
                        if part.Anchored then
                            pcall(function() part.Anchored = false end)
                        end
                        
                        local distance = (part.Position - rootPart.Position).Magnitude
                        if distance <= pullRadius then
                            pcall(function() 
                                part:SetNetworkOwner(lp) 
                            end)
                            -- Tarikan paksa menggunakan Velocity
                            part.Velocity = (targetPos - part.Position) * followStrength
                        end
                    end
                end
            end
        end
    end

    -- [[ LOGIKA PART LIAR ]] --
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(lp.Character) then
            -- Lewati jika itu bagian dari map yang sengaja di-anchor (opsional)
            -- Namun jika ingin brutal, hapus pengecekan Anchored di bawah:
            if not part.Anchored then
                local distance = (part.Position - rootPart.Position).Magnitude
                if distance <= pullRadius then
                    -- Hancurkan penghambat (Rope/Joints)
                    for _, joint in pairs(part:GetChildren()) do
                        if joint:IsA("Constraint") or joint:IsA("JointInstance") then
                            joint:Destroy()
                        end
                    end

                    pcall(function() part:SetNetworkOwner(lp) end)
                    part.Velocity = (targetPos - part.Position) * followStrength
                end
            end
        end
    end
end)

-- [[ UI SETUP (Tetap Sama) ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://6031094678"
local IconCorner = Instance.new("UICorner", IconButton)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BEAST UNANCHORED ❤️"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.85, 0, 0, 45)
StatusBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
StatusBtn.Text = "MAGNET: ON"
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", StatusBtn)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 60)
Info.Position = UDim2.new(0, 0, 0.6, 0)
Info.Text = "MODE: UNANCHOR BRING\nOWNER: SPTZYY\nSTATUS: ACTIVE"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextSize = 10
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamMedium

-- [[ DRAGGABLE ]] --
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

IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80)
    IconStroke.Color = StatusBtn.BackgroundColor3
end)
