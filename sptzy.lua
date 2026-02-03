-- [[ SPTZYY PART CONTROLLER: FULL MOBILE SUPPORT ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 50
local orbitHeight = 7
local spinSpeed = 3

-- [[ LOGIKA PHYSICS ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * 8, orbitHeight, math.sin(angle) * 8)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            if (part.Position - rootPart.Position).Magnitude <= pullRadius then
                pcall(function() part:SetNetworkOwner(lp) end)
                part.Velocity = (targetPos - part.Position) * 15
            end
        end
    end
end)

-- [[ UI SETUP: SMOOTH DRAG & COMPACT ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 140)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Header untuk Drag (Area pegangan)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Header.BorderSizePixel = 0
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "PART CONTROL"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Status Button
local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.9, 0, 0, 40)
StatusBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
StatusBtn.Text = "STATUS: ACTIVE"
StatusBtn.TextColor3 = Color3.new(1,1,1)
StatusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusBtn)

-- Mini Info
local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 40)
Info.Position = UDim2.new(0, 0, 0.65, 0)
Info.Text = "Cara Pakai: Dekati Part\nyang tidak di-anchor!"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextSize = 10
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamMedium

-- [[ LOGIKA DRAG MOBILE LUAS ]] --
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- [[ TOGGLE CLICK ]] --
StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    if botActive then
        StatusBtn.Text = "STATUS: ACTIVE"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        StatusBtn.Text = "STATUS: OFF"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)
