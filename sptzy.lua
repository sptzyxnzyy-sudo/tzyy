-- [[ SPTZYY ULTIMATE V15: PRO-MOBILE FLY ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150
local followStrength = 100  
local walkSpeedValue = 16

-- PRO FLY SETTINGS --
local flying = false
local flySpeed = 50
local bv, bg

-- [[ NOTIFIKASI ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Sptzyy_V15_Mobile"

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

-- [[ PRO FLY LOGIC ]] --
local function toggleFly()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    if flying then
        -- Start Flying
        hum.PlatformStand = true -- Mematikan animasi agar tidak bug berdiri
        hum:ChangeState(Enum.HumanoidStateType.Physics)
        
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 15000
        bg.D = 500
        bg.CFrame = root.CFrame
        bg.Parent = root
        
        task.spawn(function()
            while flying and root and root.Parent do
                local moveDir = hum.MoveDirection -- Mendeteksi input joystick (Maju/Mundur/Kanan/Kiri)
                bg.CFrame = Camera.CFrame
                
                if moveDir.Magnitude > 0 then
                    -- Bergerak sesuai input joystick dan arah kamera
                    bv.Velocity = (Camera.CFrame:VectorToWorldSpace(Vector3.new(moveDir.X, moveDir.Y, moveDir.Z)) * flySpeed)
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        -- Stop Flying
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

-- [[ UI CONSTRUCTION ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.05, 0, 0.15, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 200, 255)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.5, -140, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 200, 255)

-- Tab --
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 40)
TabBar.Position = UDim2.new(0, 10, 0, 10)
TabBar.BackgroundTransparency = 1

local function createTab(name, x)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.5, -5, 1, 0)
    btn.Position = UDim2.new(x, 2.5, 0, 0)
    btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; Instance.new("UICorner", btn)
    return btn
end

local T1 = createTab("MAIN", 0); local T2 = createTab("PLAYERS", 0.5)

local Page1 = Instance.new("ScrollingFrame", MainFrame)
Page1.Size = UDim2.new(1, -20, 1, -70); Page1.Position = UDim2.new(0, 10, 0, 60)
Page1.BackgroundTransparency = 1; Page1.ScrollBarThickness = 0

local Page2 = Instance.new("ScrollingFrame", MainFrame)
Page2.Size = UDim2.new(1, -20, 1, -70); Page2.Position = UDim2.new(0, 10, 0, 60)
Page2.BackgroundTransparency = 1; Page2.Visible = false; Page2.ScrollBarThickness = 0
Instance.new("UIListLayout", Page2).Padding = UDim.new(0, 5)

-- Buttons --
local function makeBtn(txt, color, y)
    local b = Instance.new("TextButton", Page1)
    b.Size = UDim2.new(1, 0, 0, 40); b.Position = UDim2.new(0, 0, 0, y)
    b.Text = txt; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    return b
end

local MagBtn = makeBtn("MAGNET: ON", Color3.fromRGB(0, 200, 255), 0)
local FlyBtn = makeBtn("FLY: OFF", Color3.fromRGB(40, 40, 40), 50)
local SkyBtn = makeBtn("FORCE DAYLIGHT", Color3.fromRGB(255, 165, 0), 100)

-- Logic --
FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "FLY: ON (STABLE)" or "FLY: OFF"
    FlyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 40)
    toggleFly()
end)

SkyBtn.MouseButton1Click:Connect(function()
    Lighting.ClockTime = 14
    showNotify("SKY", "Time set to Afternoon", true)
end)

MagBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    MagBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    MagBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(200, 50, 50)
end)

-- Dragging --
local function drag(obj)
    local s, p; obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then s = i.Position; p = obj.Position end end)
    obj.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch and s then
        local d = i.Position - s; obj.Position = UDim2.new(p.X.Scale, p.X.Offset + d.X, p.Y.Scale, p.Y.Offset + d.Y)
    end end)
    obj.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then s = nil end end)
end
drag(IconButton); drag(MainFrame)
IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Magnet Loop --
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local r = lp.Character.HumanoidRootPart
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(lp.Character) then
            if (v.Position - r.Position).Magnitude < pullRadius then
                pcall(function() v.Velocity = (r.Position - v.Position).Unit * followStrength end)
            end
        end
    end
end)

showNotify("V15 PRO LOADED", "Stable Fly & Anti-Bug Active", true)
