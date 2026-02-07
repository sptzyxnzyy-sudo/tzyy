-- [[ SPTZYY PART CONTROLLER + PLAYER UTILITY V4 (ICON + VIEW + TP) ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125        
local followStrength = 100  

local isSpectating = false
local spectateTarget = nil

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SptzyyUtility_V4_Icon"

local function showNotify(message, isSuccess)
    local notifyFrame = Instance.new("Frame", ScreenGui)
    notifyFrame.Size = UDim2.new(0, 220, 0, 45)
    notifyFrame.Position = UDim2.new(1, 10, 0.15, 0)
    notifyFrame.BackgroundColor3 = isSuccess and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(180, 50, 50)
    notifyFrame.BorderSizePixel = 0
    Instance.new("UICorner", notifyFrame)
    local stroke = Instance.new("UIStroke", notifyFrame)
    stroke.Thickness = 2
    stroke.Color = Color3.new(1, 1, 1)

    local text = Instance.new("TextLabel", notifyFrame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.TextWrapped = true

    notifyFrame:TweenPosition(UDim2.new(1, -230, 0.15, 0), "Out", "Back", 0.5)
    task.delay(2.5, function()
        if notifyFrame then
            notifyFrame:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5)
            task.wait(0.5)
            notifyFrame:Destroy()
        end
    end)
end

-- [[ LOGIKA MAGNET ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            local distance = (part.Position - rootPart.Position).Magnitude
            if distance <= pullRadius then
                pcall(function()
                    part:SetNetworkOwner(lp) 
                    part.Velocity = (targetPos - part.Position) * followStrength
                end)
            end
        end
    end
end)

-- [[ FUNGSI VIEW & TP ]] --
local function teleportTo(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        showNotify("Teleport ke " .. targetPlayer.DisplayName, true)
    end
end

local function toggleView(targetPlayer)
    if isSpectating and spectateTarget == targetPlayer then
        Camera.CameraSubject = lp.Character:FindFirstChild("Humanoid")
        isSpectating = false
        spectateTarget = nil
        showNotify("View Dimatikan", false)
    else
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = targetPlayer.Character.Humanoid
            isSpectating = true
            spectateTarget = targetPlayer
            showNotify("Mengintai: " .. targetPlayer.DisplayName, true)
        end
    end
end

-- [[ UI CONSTRUCTION ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
IconButton.Image = "rbxassetid://6031094678" 
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 150, 255)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 150, 255)
mainStroke.Thickness = 2

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 45)
TabBar.BackgroundTransparency = 1

local function createTab(name, xPos)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.5, -5, 1, -5)
    btn.Position = UDim2.new(xPos, 2.5, 0, 5)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn)
    return btn
end

local Tab1 = createTab("MAGNET CONTROL", 0)
local Tab2 = createTab("PLAYER LIST", 0.5)

local MagnetPage = Instance.new("Frame", MainFrame)
MagnetPage.Size = UDim2.new(1, 0, 1, -55)
MagnetPage.Position = UDim2.new(0, 0, 0, 55)
MagnetPage.BackgroundTransparency = 1

local PlayerPage = Instance.new("ScrollingFrame", MainFrame)
PlayerPage.Size = UDim2.new(1, -10, 1, -65)
PlayerPage.Position = UDim2.new(0, 5, 0, 60)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = false
PlayerPage.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", PlayerPage)
layout.Padding = UDim.new(0, 8)

local StatusBtn = Instance.new("TextButton", MagnetPage)
StatusBtn.Size = UDim2.new(0.8, 0, 0, 50)
StatusBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
StatusBtn.Text = "MAGNET: ACTIVE"
StatusBtn.TextColor3 = Color3.new(1, 1, 1)
StatusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusBtn)

-- [[ REFRESH PLAYER LIST DENGAN ICON ]] --
local function refreshPlayerList()
    for _, c in pairs(PlayerPage:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= lp then
            local pFrame = Instance.new("Frame", PlayerPage)
            pFrame.Size = UDim2.new(1, -5, 0, 65)
            pFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", pFrame)

            -- Icon Pemain
            local pIcon = Instance.new("ImageLabel", pFrame)
            pIcon.Size = UDim2.new(0, 45, 0, 45)
            pIcon.Position = UDim2.new(0, 10, 0.5, -22)
            pIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            pIcon.Image = Players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            Instance.new("UICorner", pIcon).CornerRadius = UDim.new(1, 0)

            local pName = Instance.new("TextLabel", pFrame)
            pName.Size = UDim2.new(1, -180, 1, 0)
            pName.Position = UDim2.new(0, 65, 0, 0)
            pName.Text = target.DisplayName .. "\n<font color='#aaaaaa'>@" .. target.Name .. "</font>"
            pName.TextColor3 = Color3.new(1, 1, 1)
            pName.Font = Enum.Font.GothamMedium
            pName.TextSize = 10
            pName.RichText = true
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.BackgroundTransparency = 1

            -- Container Tombol
            local btnContainer = Instance.new("Frame", pFrame)
            btnContainer.Size = UDim2.new(0, 110, 1, 0)
            btnContainer.Position = UDim2.new(1, -115, 0, 0)
            btnContainer.BackgroundTransparency = 1

            local viewBtn = Instance.new("TextButton", btnContainer)
            viewBtn.Size = UDim2.new(0, 50, 0, 30)
            viewBtn.Position = UDim2.new(0, 0, 0.5, -15)
            viewBtn.Text = "VIEW"
            viewBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            viewBtn.TextColor3 = Color3.new(1, 1, 1)
            viewBtn.Font = Enum.Font.GothamBold
            viewBtn.TextSize = 9
            Instance.new("UICorner", viewBtn)

            local tpBtn = Instance.new("TextButton", btnContainer)
            tpBtn.Size = UDim2.new(0, 50, 0, 30)
            tpBtn.Position = UDim2.new(0, 55, 0.5, -15)
            tpBtn.Text = "TP"
            tpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            tpBtn.TextColor3 = Color3.new(1, 1, 1)
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 9
            Instance.new("UICorner", tpBtn)

            viewBtn.MouseButton1Click:Connect(function() toggleView(target) end)
            tpBtn.MouseButton1Click:Connect(function() teleportTo(target) end)
        end
    end
    PlayerPage.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end

-- Tab Logic
Tab1.MouseButton1Click:Connect(function() MagnetPage.Visible = true; PlayerPage.Visible = false end)
Tab2.MouseButton1Click:Connect(function() MagnetPage.Visible = false; PlayerPage.Visible = true; refreshPlayerList() end)

-- Drag System
local function drag(obj)
    local dragging, startPos, dragStart
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; startPos = obj.Position; dragStart = i.Position end end)
    obj.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - dragStart; obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

drag(IconButton); drag(MainFrame)

IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ACTIVE" or "MAGNET: DISABLED"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 80, 80)
end)

showNotify("Sptzyy V4: Player Icons Loaded!", true)
