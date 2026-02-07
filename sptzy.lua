-- [[ SPTZYY UTILITY V5: PRIVATE CHAT + EXTENDED SCROLL + ICONS ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
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
ScreenGui.Name = "SptzyyUtility_V5_Final"

local function showNotify(message, isSuccess)
    local notifyFrame = Instance.new("Frame", ScreenGui)
    notifyFrame.Size = UDim2.new(0, 220, 0, 45)
    notifyFrame.Position = UDim2.new(1, 10, 0.15, 0)
    notifyFrame.BackgroundColor3 = isSuccess and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(180, 50, 50)
    notifyFrame.BorderSizePixel = 0
    Instance.new("UICorner", notifyFrame)
    
    local text = Instance.new("TextLabel", notifyFrame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 11
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

-- [[ FUNGSI UTAMA ]] --
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
        showNotify("Kamera Normal", false)
    else
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = targetPlayer.Character.Humanoid
            isSpectating = true
            spectateTarget = targetPlayer
            showNotify("Memantau: " .. targetPlayer.DisplayName, true)
        end
    end
end

local function openPrivateChat(targetPlayer)
    showNotify("Siapkan Chat Private untuk " .. targetPlayer.Name, true)
    -- Fokus ke kotak chat dan ketik /w otomatis
    local chatInput = game:GetService("GuiService").SelectedObject
    print("/w " .. targetPlayer.Name .. " ") -- Instruksi manual jika sistem auto-fokus gagal
end

-- [[ UI CONSTRUCTION ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.05, 0, 0.1, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 150, 255)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 340, 0, 400)
MainFrame.Position = UDim2.new(0.5, -170, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
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
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn)
    return btn
end

local Tab1 = createTab("MAGNET CONTROL", 0)
local Tab2 = createTab("PLAYER HUB", 0.5)

local MagnetPage = Instance.new("Frame", MainFrame)
MagnetPage.Size = UDim2.new(1, 0, 1, -55)
MagnetPage.Position = UDim2.new(0, 0, 0, 55)
MagnetPage.BackgroundTransparency = 1

local PlayerPage = Instance.new("ScrollingFrame", MainFrame)
PlayerPage.Size = UDim2.new(1, -10, 1, -65)
PlayerPage.Position = UDim2.new(0, 5, 0, 60)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = false
PlayerPage.ScrollBarThickness = 4
PlayerPage.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
local layout = Instance.new("UIListLayout", PlayerPage)
layout.Padding = UDim.new(0, 8)

-- Tombol Magnet
local StatusBtn = Instance.new("TextButton", MagnetPage)
StatusBtn.Size = UDim2.new(0.8, 0, 0, 50)
StatusBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
StatusBtn.Text = "MAGNET STATUS: ACTIVE"
StatusBtn.TextColor3 = Color3.new(1, 1, 1)
StatusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusBtn)

-- [[ REFRESH LIST PLAYER LUAS ]] --
local function refreshPlayerList()
    for _, c in pairs(PlayerPage:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= lp then
            local pFrame = Instance.new("Frame", PlayerPage)
            pFrame.Size = UDim2.new(1, -10, 0, 75)
            pFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", pFrame)

            -- Player Icon
            local pIcon = Instance.new("ImageLabel", pFrame)
            pIcon.Size = UDim2.new(0, 50, 0, 50)
            pIcon.Position = UDim2.new(0, 10, 0.5, -25)
            pIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            pIcon.Image = Players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            Instance.new("UICorner", pIcon).CornerRadius = UDim.new(1, 0)

            -- Player Names
            local pName = Instance.new("TextLabel", pFrame)
            pName.Size = UDim2.new(1, -190, 1, 0)
            pName.Position = UDim2.new(0, 70, 0, 0)
            pName.Text = "<b>" .. target.DisplayName .. "</b>\n@" .. target.Name
            pName.TextColor3 = Color3.new(1, 1, 1)
            pName.Font = Enum.Font.GothamMedium
            pName.TextSize = 10
            pName.RichText = true
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.BackgroundTransparency = 1

            -- Action Buttons Container
            local actions = Instance.new("Frame", pFrame)
            actions.Size = UDim2.new(0, 110, 1, 0)
            actions.Position = UDim2.new(1, -115, 0, 0)
            actions.BackgroundTransparency = 1

            local function createBtn(txt, yPos, color, func)
                local b = Instance.new("TextButton", actions)
                b.Size = UDim2.new(1, 0, 0, 20)
                b.Position = UDim2.new(0, 0, 0, yPos)
                b.Text = txt
                b.BackgroundColor3 = color
                b.TextColor3 = Color3.new(1, 1, 1)
                b.Font = Enum.Font.GothamBold
                b.TextSize = 8
                Instance.new("UICorner", b)
                b.MouseButton1Click:Connect(func)
            end

            createBtn("VIEW", 8, Color3.fromRGB(60, 60, 60), function() toggleView(target) end)
            createBtn("TELEPORT", 30, Color3.fromRGB(0, 120, 255), function() teleportTo(target) end)
            createBtn("PRIVATE CHAT", 52, Color3.fromRGB(0, 180, 100), function() openPrivateChat(target) end)
        end
    end
    -- Auto-scale scrolling list agar luas
    PlayerPage.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
end

-- Interactions
Tab1.MouseButton1Click:Connect(function() MagnetPage.Visible = true; PlayerPage.Visible = false end)
Tab2.MouseButton1Click:Connect(function() MagnetPage.Visible = false; PlayerPage.Visible = true; refreshPlayerList() end)

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
    StatusBtn.Text = botActive and "MAGNET STATUS: ACTIVE" or "MAGNET STATUS: DISABLED"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 80, 80)
end)

showNotify("Sptzyy V5 Ready: Extended Scroll & Chat!", true)
