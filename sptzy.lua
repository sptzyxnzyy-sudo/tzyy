-- [[ SPTZYY PART CONTROLLER + MORPH BEAST EDITION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125        
local followStrength = 100  

-- [[ LOGIKA MAGNET (BEAST) ]] --
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
                for _, constraint in pairs(part:GetChildren()) do
                    if constraint:IsA("RopeConstraint") or constraint:IsA("RodConstraint") or constraint:IsA("SpringConstraint") then
                        constraint:Destroy()
                    end
                end
                pcall(function() part:SetNetworkOwner(lp) end)
                part.Velocity = (targetPos - part.Position) * followStrength
                part.RotVelocity = Vector3.new(0, 10, 0)
            end
        end
    end
end)

-- [[ FUNGSI MORPH ]] --
local function morphToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local myChar = lp.Character
        if myChar and myChar:FindFirstChildOfClass("Humanoid") then
            local success, description = pcall(function()
                return Players:GetHumanoidDescriptionFromUserId(targetPlayer.UserId)
            end)
            if success and description then
                myChar:FindFirstChildOfClass("Humanoid"):ApplyDescription(description)
            end
        end
    end
end

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SptzyyUltraControlV2"

-- Icon Button
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://6031094678"
local IconCorner = Instance.new("UICorner", IconButton, {CornerRadius = UDim.new(1,0)})
local IconStroke = Instance.new("UIStroke", IconButton, {Color = Color3.fromRGB(0, 255, 150), Thickness = 2})

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame, {Color = Color3.fromRGB(0, 255, 150), Thickness = 2})

-- Tabs (Magnet vs Morph)
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.BackgroundTransparency = 1

local function createTab(name, pos)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.5, 0, 1, 0)
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    return btn
end

local TabMagnet = createTab("MAGNET", 0)
local TabMorph = createTab("MORPH", 0.5)

-- Content Sections
local MagnetFrame = Instance.new("Frame", MainFrame)
MagnetFrame.Size = UDim2.new(1, 0, 1, -30)
MagnetFrame.Position = UDim2.new(0, 0, 0, 30)
MagnetFrame.BackgroundTransparency = 1

local MorphFrame = Instance.new("ScrollingFrame", MainFrame)
MorphFrame.Size = UDim2.new(1, -10, 1, -40)
MorphFrame.Position = UDim2.new(0, 5, 0, 35)
MorphFrame.BackgroundTransparency = 1
MorphFrame.Visible = false
MorphFrame.ScrollBarThickness = 4
MorphFrame.CanvasSize = UDim2.new(0,0,0,0)

local UIList = Instance.new("UIListLayout", MorphFrame)
UIList.Padding = UDim.new(0, 5)

-- Fill Magnet Frame
local StatusBtn = Instance.new("TextButton", MagnetFrame)
StatusBtn.Size = UDim2.new(0.8, 0, 0, 40)
StatusBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
StatusBtn.Text = "MAGNET: ON"
StatusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusBtn)

-- Function Update Morph List
local function updateList()
    for _, child in pairs(MorphFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local Item = Instance.new("Frame", MorphFrame)
            Item.Size = UDim2.new(1, 0, 0, 45)
            Item.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Instance.new("UICorner", Item)

            local pIcon = Instance.new("ImageLabel", Item)
            pIcon.Size = UDim2.new(0, 35, 0, 35)
            pIcon.Position = UDim2.new(0, 5, 0, 5)
            pIcon.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            Instance.new("UICorner", pIcon, {CornerRadius = UDim.new(1,0)})

            local pName = Instance.new("TextLabel", Item)
            pName.Size = UDim2.new(1, -100, 1, 0)
            pName.Position = UDim2.new(0, 45, 0, 0)
            pName.Text = p.DisplayName
            pName.TextColor3 = Color3.new(1, 1, 1)
            pName.Font = Enum.Font.Gotham
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.BackgroundTransparency = 1

            local mBtn = Instance.new("TextButton", Item)
            mBtn.Size = UDim2.new(0, 60, 0, 30)
            mBtn.Position = UDim2.new(1, -65, 0, 7.5)
            mBtn.Text = "Copy"
            mBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            mBtn.TextColor3 = Color3.new(1, 1, 1)
            Instance.new("UICorner", mBtn)

            mBtn.MouseButton1Click:Connect(function() morphToPlayer(p) end)
        end
    end
    MorphFrame.CanvasSize = UDim2.new(0,0,0, UIList.AbsoluteContentSize.Y + 10)
end

-- Tab Switch Logic
TabMagnet.MouseButton1Click:Connect(function()
    MagnetFrame.Visible = true
    MorphFrame.Visible = false
end)

TabMorph.MouseButton1Click:Connect(function()
    MagnetFrame.Visible = false
    MorphFrame.Visible = true
    updateList()
end)

-- Dragging & Toggle
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
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
