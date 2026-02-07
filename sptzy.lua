-- [[ SPTZYY ULTIMATE V14: MOBILE OPTIMIZED ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125        
local followStrength = 100  
local walkSpeedValue = 16

-- MOBILE FLY SETTINGS --
local flying = false
local flySpeed = 50
local bv, bg

-- [[ NOTIFICATION SYSTEM ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Sptzyy_V14_Mobile"

local function showNotify(title, message, isSuccess)
    local notifyFrame = Instance.new("Frame", ScreenGui)
    notifyFrame.Size = UDim2.new(0, 200, 0, 45)
    notifyFrame.Position = UDim2.new(1, 10, 0.05, 0)
    notifyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notifyFrame.BorderSizePixel = 0
    Instance.new("UICorner", notifyFrame)
    local stroke = Instance.new("UIStroke", notifyFrame)
    stroke.Color = isSuccess and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 50, 50)
    
    local tLabel = Instance.new("TextLabel", notifyFrame)
    tLabel.Size = UDim2.new(1, 0, 0, 15)
    tLabel.Text = " " .. title
    tLabel.TextColor3 = stroke.Color
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 10
    tLabel.BackgroundTransparency = 1

    local mLabel = Instance.new("TextLabel", notifyFrame)
    mLabel.Size = UDim2.new(1, -10, 0, 25)
    mLabel.Position = UDim2.new(0, 5, 0, 15)
    mLabel.Text = message
    mLabel.TextColor3 = Color3.new(1, 1, 1)
    mLabel.Font = Enum.Font.GothamMedium
    mLabel.TextSize = 8
    mLabel.TextWrapped = true
    mLabel.BackgroundTransparency = 1

    notifyFrame:TweenPosition(UDim2.new(1, -210, 0.05, 0), "Out", "Back", 0.5)
    task.delay(3, function()
        if notifyFrame then
            notifyFrame:TweenPosition(UDim2.new(1, 10, 0.05, 0), "In", "Quad", 0.5)
            task.wait(0.5)
            notifyFrame:Destroy()
        end
    end)
end

-- [[ FLY LOGIC FOR MOBILE ]] --
local function startFly()
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    
    bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 15000
    bg.D = 500
    
    task.spawn(function()
        while flying and root and root.Parent do
            local moveDir = lp.Character.Humanoid.MoveDirection
            bg.CFrame = Camera.CFrame
            
            -- Pada mobile, terbang mengikuti arah kamera + joystick
            if moveDir.Magnitude > 0 then
                bv.Velocity = Camera.CFrame.LookVector * flySpeed * (moveDir.Magnitude)
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            RunService.RenderStepped:Wait()
        end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end)
end

-- [[ UI CONSTRUCTION ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.05, 0, 0.15, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1,0)
local iconStroke = Instance.new("UIStroke", IconButton)
iconStroke.Color = Color3.fromRGB(0, 200, 255)
iconStroke.Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 200, 255)

-- Tab System --
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 40)
TabBar.Position = UDim2.new(0, 10, 0, 10)
TabBar.BackgroundTransparency = 1

local function createTab(name, xPos)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.5, -5, 1, 0)
    btn.Position = UDim2.new(xPos, 2.5, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    return btn
end

local Tab1Btn = createTab("HACKS", 0)
local Tab2Btn = createTab("PLAYERS", 0.5)

local Page1 = Instance.new("ScrollingFrame", MainFrame)
Page1.Size = UDim2.new(1, -20, 1, -70)
Page1.Position = UDim2.new(0, 10, 0, 60)
Page1.BackgroundTransparency = 1
Page1.CanvasSize = UDim2.new(0,0,0,450)
Page1.ScrollBarThickness = 0

local Page2 = Instance.new("ScrollingFrame", MainFrame)
Page2.Size = UDim2.new(1, -20, 1, -70)
Page2.Position = UDim2.new(0, 10, 0, 60)
Page2.BackgroundTransparency = 1
Page2.Visible = false
Page2.ScrollBarThickness = 0
local pList = Instance.new("UIListLayout", Page2)
pList.Padding = UDim.new(0, 8)

-- [[ UI COMPONENTS ]] --
local function createButton(parent, text, color, pos)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    return b
end

local MagBtn = createButton(Page1, "MAGNET: ACTIVE", Color3.fromRGB(0, 200, 255), UDim2.new(0,0,0,0))
local FlyBtn = createButton(Page1, "FLY: OFF", Color3.fromRGB(40, 40, 40), UDim2.new(0,0,0,55))
local SkyBtn = createButton(Page1, "SET NOON (SIANG)", Color3.fromRGB(255, 165, 0), UDim2.new(0,0,0,110))

-- Slider Speed Mobile --
local SpeedTitle = Instance.new("TextLabel", Page1)
SpeedTitle.Size = UDim2.new(1, 0, 0, 30)
SpeedTitle.Position = UDim2.new(0, 0, 0, 165)
SpeedTitle.Text = "WALKSPEED: 16"
SpeedTitle.TextColor3 = Color3.new(1,1,1)
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.BackgroundTransparency = 1

local SBack = Instance.new("Frame", Page1)
SBack.Size = UDim2.new(1, -20, 0, 10)
SBack.Position = UDim2.new(0, 10, 0, 200)
SBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", SBack)

local SFill = Instance.new("Frame", SBack)
SFill.Size = UDim2.new(0, 0, 1, 0)
SFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Instance.new("UICorner", SFill)

local SDot = Instance.new("TextButton", SBack)
SDot.Size = UDim2.new(0, 24, 0, 24)
SDot.Position = UDim2.new(0, -12, 0.5, -12)
SDot.Text = ""
SDot.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SDot)

-- [[ FUNCTIONALITIES ]] --
MagBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    MagBtn.Text = botActive and "MAGNET: ACTIVE" or "MAGNET: OFF"
    MagBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(200, 50, 50)
end)

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "FLY: ON" or "FLY: OFF"
    FlyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 40)
    if flying then startFly() end
end)

SkyBtn.MouseButton1Click:Connect(function()
    Lighting.ClockTime = 14
    showNotify("MOBILE HACK", "Time set to Afternoon", true)
end)

-- Slider Logic Mobile --
local function moveSlider(input)
    local pos = math.clamp((input.Position.X - SBack.AbsolutePosition.X) / SBack.AbsoluteSize.X, 0, 1)
    SDot.Position = UDim2.new(pos, -12, 0.5, -12)
    SFill.Size = UDim2.new(pos, 0, 1, 0)
    walkSpeedValue = math.floor(16 + (pos * 184))
    SpeedTitle.Text = "WALKSPEED: " .. walkSpeedValue
end

local isDragging = false
SDot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = true end end)
UserInputService.InputChanged:Connect(function(i) if isDragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then moveSlider(i) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end end)

-- Player List --
local function getPlayers()
    for _, v in pairs(Page2:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local f = Instance.new("Frame", Page2)
            f.Size = UDim2.new(1, 0, 0, 60)
            f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", f)
            
            local name = Instance.new("TextLabel", f)
            name.Size = UDim2.new(1, -110, 1, 0)
            name.Position = UDim2.new(0, 10, 0, 0)
            name.Text = p.DisplayName
            name.TextColor3 = Color3.new(1,1,1)
            name.Font = Enum.Font.GothamBold
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.BackgroundTransparency = 1
            
            local tp = Instance.new("TextButton", f)
            tp.Size = UDim2.new(0, 80, 0, 35)
            tp.Position = UDim2.new(1, -90, 0.5, -17.5)
            tp.Text = "TELEPORT"
            tp.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            tp.TextColor3 = Color3.new(1,1,1)
            tp.Font = Enum.Font.GothamBold
            tp.TextSize = 10
            Instance.new("UICorner", tp)
            tp.MouseButton1Click:Connect(function()
                lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            end)
        end
    end
end

-- Navigation --
Tab1Btn.MouseButton1Click:Connect(function() Page1.Visible = true; Page2.Visible = false end)
Tab2Btn.MouseButton1Click:Connect(function() Page1.Visible = false; Page2.Visible = true; getPlayers() end)

-- Drag & Toggle --
local function makeDraggable(obj)
    local dragStart, startPos
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragStart = i.Position; startPos = obj.Position end end)
    obj.InputChanged:Connect(function(i) if (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) and dragStart then
        local delta = i.Position - dragStart
        obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    obj.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then dragStart = nil end end)
end

makeDraggable(IconButton); makeDraggable(MainFrame)
IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Magnet Loop --
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(lp.Character) then
            if (v.Position - root.Position).Magnitude < pullRadius then
                pcall(function()
                    v:SetNetworkOwner(lp)
                    v.Velocity = (root.Position - v.Position).Unit * followStrength
                end)
            end
        end
    end
end)

showNotify("SPTZYY V14 MOBILE", "Optimized & Ready!", true)
