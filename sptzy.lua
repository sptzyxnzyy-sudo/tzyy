-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE EDITION UPDATED ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150      
local orbitHeight = 8      
local orbitRadius = 15     
local spinSpeed = 10        -- Disesuaikan agar lebih halus
local followStrength = 50   

-- [[ LOGIKA PHYSICS ]] --
local angle = 0
local cachedParts = {}

-- Fungsi untuk scan part sekitar secara berkala (biar tidak lag)
task.spawn(function()
    while task.wait(1) do
        if botActive then
            cachedParts = {}
            local rootPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
            if rootPos then
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
                        if (part.Position - rootPos).Magnitude <= pullRadius then
                            table.insert(cachedParts, part)
                        end
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (dt * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(cachedParts) do
        if part and part.Parent then
            -- Break Constraints
            for _, constraint in pairs(part:GetChildren()) do
                if constraint:IsA("Constraint") or constraint:IsA("RopeConstraint") then
                    constraint:Destroy()
                end
            end

            -- Physics Manipulation (Modern Velocity)
            -- Catatan: Ini bekerja maksimal jika game tidak memiliki sistem Anti-Cheat NetworkOwner
            local direction = (targetPos - part.Position)
            part.AssemblyLinearVelocity = direction * (followStrength / 2)
            part.AssemblyAngularVelocity = Vector3.new(0, 15, 0)
            
            -- Bypass sederhana agar part tidak "tidur" (Physics Sleeping)
            if part.AssemblyLinearVelocity.Magnitude < 0.1 then
                part.Velocity = Vector3.new(0, 0.1, 0)
            end
        end
    end
end)

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyUltraControl"
ScreenGui.Parent = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("CoreGui"))
ScreenGui.ResetOnSpawn = false

-- Tombol Icon
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

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
local MainCorner = Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BEAST CONTROLLER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.85, 0, 0, 45)
StatusBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
StatusBtn.Text = "MAGNET: ON"
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", StatusBtn)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 50)
Info.Position = UDim2.new(0, 0, 0.65, 0)
Info.Text = "KEKUATAN: MAX\nBY SPTZYY PARTICLE"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextSize = 10
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamMedium

-- [[ DRAG LOGIC ]] --
local function setupDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)
end

setupDrag(IconButton)
setupDrag(MainFrame)

IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80)
    IconStroke.Color = StatusBtn.BackgroundColor3
end)
