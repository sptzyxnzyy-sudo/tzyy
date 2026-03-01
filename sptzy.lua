local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Mobile Control Module
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_Director_V4"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- [ MAIN FRAME - PERSEGI EMPAT ]
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -120)
MainFrame.Size = UDim2.new(0, 200, 0, 360)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Rainbow Border Sharp
local Border = Instance.new("Frame")
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.BorderSizePixel = 0
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.ZIndex = 0

-- Minimize Logic
local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 20, 0, 20)
MiniBtn.Position = UDim2.new(1, -25, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MiniBtn.Text = "_"
MiniBtn.TextColor3 = Color3.new(1, 1, 1)
MiniBtn.BorderSizePixel = 0
MiniBtn.Parent = MainFrame

local isMini = false
MiniBtn.MouseButton1Click:Connect(function()
    isMini = not isMini
    MainFrame:TweenSize(isMini and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 360), "Out", "Quad", 0.3, true)
    for _, v in pairs(MainFrame:GetChildren()) do
        if v ~= MiniBtn and v ~= Border then v.Visible = not isMini end
    end
    MiniBtn.Text = isMini and "+" or "_"
end)

-- [ PROFILE SECTION ]
local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(1, 0, 0, 60)
Profile.BackgroundTransparency = 1
Profile.Parent = MainFrame

local Av = Instance.new("ImageLabel")
Av.Size = UDim2.new(0, 40, 0, 40)
Av.Position = UDim2.new(0, 10, 0, 10)
Av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"
Av.BorderSizePixel = 0
Av.Parent = Profile

local Title = Instance.new("TextLabel")
Title.Text = "PRODUCER MODE"
Title.Position = UDim2.new(0, 58, 0, 15)
Title.Size = UDim2.new(0, 130, 0, 15)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Profile

-- [ BUTTON CONTAINER ]
local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 0, 0, 65)
Container.Size = UDim2.new(1, 0, 1, -65)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame
local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 6)

-- Variable Kamera & Fitur
local freecamOn, producerMode = false, false
local camSpeed = 30
local yaw, pitch, orbitAngle, timeCount = 0, 0, 0, 0

local function AddBtn(text, icon, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.92, 0, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = "      "..text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BorderSizePixel = 0
    b.Parent = Container
    local i = Instance.new("ImageLabel")
    i.Size = UDim2.new(0,18,0,18) i.Position = UDim2.new(0,8,0.5,-9)
    i.Image = icon i.BackgroundTransparency = 1 i.Parent = b
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.BackgroundColor3 = act and color or Color3.fromRGB(25, 25, 25)
        callback(act)
    end)
end

-- [ ACTIONS ]
AddBtn("AUTO BUY PADI", "rbxassetid://6031764630", Color3.fromRGB(0, 100, 200), function(s)
    _G.Buy = s while _G.Buy do pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) end) task.wait(0.5) end
end)

AddBtn("AUTO SELL PADI", "rbxassetid://6031154871", Color3.fromRGB(150, 0, 0), function(s)
    _G.Sell = s while _G.Sell do pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45) end) task.wait(0.5) end
end)

AddBtn("FREECAM MANUAL", "rbxassetid://6034289542", Color3.fromRGB(0, 150, 80), function(s)
    freecamOn = s producerMode = false
    Camera.CameraType = s and "Scriptable" or "Custom"
end)

AddBtn("PRODUCER CINEMA", "rbxassetid://6034289542", Color3.fromRGB(150, 150, 0), function(s)
    producerMode = s freecamOn = false
    Camera.CameraType = s and "Scriptable" or "Custom"
    orbitAngle = 0 timeCount = 0
end)

-- [ SPEED UI ]
local SFrame = Instance.new("Frame")
SFrame.Size = UDim2.new(0.92, 0, 0, 36)
SFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SFrame.BorderSizePixel = 0
SFrame.Parent = Container
local SLbl = Instance.new("TextLabel")
SLbl.Size = UDim2.new(1, 0, 1, 0)
SLbl.Text = "DIRECTOR INTENSITY: "..camSpeed
SLbl.TextColor3 = Color3.new(1, 1, 1)
SLbl.BackgroundTransparency = 1
SLbl.Font = Enum.Font.SourceSansBold
SLbl.Parent = SFrame
SFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        camSpeed = camSpeed >= 120 and 20 or camSpeed + 20
        SLbl.Text = "DIRECTOR INTENSITY: "..camSpeed
    end
end)

-- [ DIRECTOR CAMERA ENGINE ]
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if producerMode and hrp then
        timeCount = timeCount + dt
        orbitAngle = orbitAngle + (dt * (camSpeed/80))
        
        -- Logika Produser: Dynamic Zoom & Sweep
        local breathe = math.sin(timeCount * 0.4) * 6 -- Maju mundur lembut
        local radius = 20 + breathe
        local height = 5 + (math.cos(timeCount * 0.5) * 3) -- Ketinggian bervariasi
        
        local targetPos = hrp.Position + Vector3.new(
            math.sin(orbitAngle) * radius,
            height,
            math.cos(orbitAngle) * radius
        )
        
        -- Logika Mengarah ke Karakter (Smooth Gimbal)
        local rawCF = CFrame.new(targetPos, hrp.Position + Vector3.new(0, 1.5, 0))
        Camera.CFrame = Camera.CFrame:Lerp(rawCF, 0.04) -- Efek kamera berat (Mahal)
        
    elseif freecamOn then
        local mv = Controls:GetMoveVector()
        local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position + (rot * mv * (camSpeed/10))), 0.1)
    end
    
    -- Anti-Bug Lock
    if (freecamOn or producerMode) and hrp then
        hrp.Anchored = true
        hrp.Velocity = Vector3.zero
    elseif hrp then
        hrp.Anchored = false
    end
end)

-- Rainbow Border Task
task.spawn(function()
    while true do
        for i=0,1,0.01 do Border.BackgroundColor3 = Color3.fromHSV(i,0.7,1) task.wait(0.04) end
    end
end)

-- Manual Rotation Input
UserInputService.InputChanged:Connect(function(input)
    if freecamOn and input.UserInputType == Enum.UserInputType.Touch then
        yaw = yaw - input.Delta.X * 0.3
        pitch = math.clamp(pitch - input.Delta.Y * 0.3, -80, 80)
    end
end)

local WM = Instance.new("TextLabel")
WM.Text = "DIRECTOR EDITION v4"
WM.Position = UDim2.new(0, 0, 1, -18)
WM.Size = UDim2.new(1, 0, 0, 15)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(100, 100, 100)
WM.TextSize = 8
WM.Parent = MainFrame
