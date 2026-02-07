-- [[ SPTZYY ULTIMATE V8.5: ADVANCED INFO & COMPACT UI ]] --
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

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Sptzyy_V8_5"

local function showNotify(title, message, isSuccess)
    local notifyFrame = Instance.new("Frame", ScreenGui)
    notifyFrame.Size = UDim2.new(0, 240, 0, 60)
    notifyFrame.Position = UDim2.new(1, 10, 0.1, 0)
    notifyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    notifyFrame.BorderSizePixel = 0
    Instance.new("UICorner", notifyFrame)
    local stroke = Instance.new("UIStroke", notifyFrame)
    stroke.Color = isSuccess and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 150, 0)
    
    local tLabel = Instance.new("TextLabel", notifyFrame)
    tLabel.Size = UDim2.new(1, 0, 0, 25)
    tLabel.Text = "  " .. title
    tLabel.TextColor3 = stroke.Color
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 11
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1

    local mLabel = Instance.new("TextLabel", notifyFrame)
    mLabel.Size = UDim2.new(1, -10, 0, 30)
    mLabel.Position = UDim2.new(0, 5, 0, 25)
    mLabel.Text = message
    mLabel.TextColor3 = Color3.new(1, 1, 1)
    mLabel.Font = Enum.Font.GothamMedium
    mLabel.TextSize = 10
    mLabel.TextWrapped = true
    mLabel.BackgroundTransparency = 1

    notifyFrame:TweenPosition(UDim2.new(1, -250, 0.1, 0), "Out", "Back", 0.5)
    task.delay(4, function()
        if notifyFrame then
            notifyFrame:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.5)
            task.wait(0.5)
            notifyFrame:Destroy()
        end
    end)
end

-- [[ MAGNET ENGINE ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            if (part.Position - rootPart.Position).Magnitude <= pullRadius then
                pcall(function()
                    part:SetNetworkOwner(lp) 
                    part.Velocity = (targetPos - part.Position) * followStrength
                end)
            end
        end
    end
end)

-- [[ UI CONSTRUCTION ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 45, 0, 45)
IconButton.Position = UDim2.new(0.02, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 200, 255)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 200, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "SPTZYY HUB V8.5"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 40)
TabBar.BackgroundTransparency = 1

local function createTab(name, xPos)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.5, -5, 1, 0)
    btn.Position = UDim2.new(xPos, 2.5, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    Instance.new("UICorner", btn)
    return btn
end

local Tab1 = createTab("MAGNET CONTROL", 0)
local Tab2 = createTab("PLAYER INFO", 0.5)

local MagnetPage = Instance.new("Frame", MainFrame)
MagnetPage.Size = UDim2.new(1, -20, 1, -85)
MagnetPage.Position = UDim2.new(0, 10, 0, 80)
MagnetPage.BackgroundTransparency = 1

local PlayerPage = Instance.new("ScrollingFrame", MainFrame)
PlayerPage.Size = UDim2.new(1, -20, 1, -85)
PlayerPage.Position = UDim2.new(0, 10, 0, 80)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = false
PlayerPage.ScrollBarThickness = 2
PlayerPage.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
local layout = Instance.new("UIListLayout", PlayerPage)
layout.Padding = UDim.new(0, 6)

local StatusBtn = Instance.new("TextButton", MagnetPage)
StatusBtn.Size = UDim2.new(1, 0, 0, 45)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
StatusBtn.Text = "MAGNET: ACTIVE"
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", StatusBtn)

-- [[ REFRESH PLAYER LIST ]] --
local function refreshList()
    for _, c in pairs(PlayerPage:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= lp then
            local pFrame = Instance.new("Frame", PlayerPage)
            pFrame.Size = UDim2.new(1, -5, 0, 55)
            pFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Instance.new("UICorner", pFrame)

            local icon = Instance.new("ImageLabel", pFrame)
            icon.Size = UDim2.new(0, 35, 0, 35)
            icon.Position = UDim2.new(0, 8, 0.5, -17.5)
            icon.Image = Players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            icon.BackgroundTransparency = 1
            Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

            local name = Instance.new("TextLabel", pFrame)
            name.Size = UDim2.new(1, -165, 1, 0)
            name.Position = UDim2.new(0, 50, 0, 0)
            name.Text = target.DisplayName
            name.TextColor3 = Color3.new(1, 1, 1)
            name.Font = Enum.Font.GothamBold
            name.TextSize = 10
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.BackgroundTransparency = 1

            local btnRow = Instance.new("Frame", pFrame)
            btnRow.Size = UDim2.new(0, 110, 0, 24)
            btnRow.Position = UDim2.new(1, -115, 0.5, -12)
            btnRow.BackgroundTransparency = 1

            local function addBtn(txt, x, color, func)
                local b = Instance.new("TextButton", btnRow)
                b.Size = UDim2.new(0, 32, 1, 0)
                b.Position = UDim2.new(0, x, 0, 0)
                b.Text = txt
                b.BackgroundColor3 = color
                b.TextColor3 = Color3.new(1, 1, 1)
                b.Font = Enum.Font.GothamBold
                b.TextSize = 7
                Instance.new("UICorner", b)
                b.MouseButton1Click:Connect(func)
            end

            addBtn("TP", 0, Color3.fromRGB(0, 120, 255), function()
                if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                end
            end)
            
            addBtn("VIEW", 38, Color3.fromRGB(60, 60, 60), function()
                if Camera.CameraSubject == target.Character:FindFirstChild("Humanoid") then
                    Camera.CameraSubject = lp.Character:FindFirstChild("Humanoid")
                    showNotify("Camera", "Kembali ke karakter sendiri", false)
                else
                    Camera.CameraSubject = target.Character:FindFirstChild("Humanoid")
                    showNotify("Spectating", "Memantau " .. target.DisplayName, true)
                end
            end)

            addBtn("INFO", 76, Color3.fromRGB(150, 0, 255), function()
                local membership = (target.MembershipType == Enum.MembershipType.Premium) and "Premium" or "Regular"
                local infoText = string.format("ID: %s\nAge: %d Days\nType: %s", target.UserId, target.AccountAge, membership)
                showNotify("PLAYER DATA: " .. target.Name, infoText, true)
            end)
        end
    end
    PlayerPage.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

-- Tabs Toggle
Tab1.MouseButton1Click:Connect(function() MagnetPage.Visible = true; PlayerPage.Visible = false end)
Tab2.MouseButton1Click:Connect(function() MagnetPage.Visible = false; PlayerPage.Visible = true; refreshList() end)

-- Dragging Logic
local function drag(obj)
    local d, s, ds
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = obj.Position; ds = i.Position end end)
    obj.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local del = i.Position - ds; obj.Position = UDim2.new(s.X.Scale, s.X.Offset + del.X, s.Y.Scale, s.Y.Offset + del.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

drag(IconButton); drag(MainFrame)
IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ACTIVE" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(200, 50, 50)
end)

showNotify("SYSTEM READY", "Sptzyy V8.5 Compact Loaded!", true)
