-- [[ SPTZYY PART CONTROLLER: ADVANCED EDITION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 50
local orbitHeight = 5
local spinSpeed = 3 -- Kecepatan putaran
local toggleKey = Enum.KeyCode.T -- Shortcut Keyboard

-- [[ LOGIKA UTAMA ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    
    -- Menghitung posisi orbit melingkar
    local offsetX = math.cos(angle) * 7
    local offsetZ = math.sin(angle) * 7
    local targetPos = rootPart.Position + Vector3.new(offsetX, orbitHeight, offsetZ)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            if (part.Position - rootPart.Position).Magnitude <= pullRadius then
                -- Request Network Ownership
                pcall(function() part:SetNetworkOwner(lp) end)
                
                -- Gerakan halus menggunakan Velocity
                part.Velocity = (targetPos - part.Position) * 15
            end
        end
    end
end)

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame)

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "PART CONTROLLER V2"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- Status Button
local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.9, 0, 0, 35)
StatusBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
StatusBtn.Text = "STATUS: ACTIVE"
StatusBtn.TextColor3 = Color3.new(1,1,1)
StatusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusBtn)

-- Instructions Label
local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(0.9, 0, 0, 40)
Info.Position = UDim2.new(0.05, 0, 0.65, 0)
Info.Text = "Press [T] to Toggle\nRadius: 50 | Spin: ON"
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.TextSize = 11
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham

-- [[ FUNGSI TOGGLE ]] --
local function toggleBot()
    botActive = not botActive
    if botActive then
        StatusBtn.Text = "STATUS: ACTIVE"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    else
        StatusBtn.Text = "STATUS: OFF"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end

StatusBtn.MouseButton1Click:Connect(toggleBot)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == toggleKey then toggleBot() end
end)

-- Dragging System
local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
end)
