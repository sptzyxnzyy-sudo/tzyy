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
ScreenGui.Name = "Ikyy_Director_V5_Pro"
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
Title.Text = "DIRECTOR PRO v5"
Title.Position = UDim2.new(0, 58, 0, 15)
Title.Size = UDim2.new(0, 130, 0, 15)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 12
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

-- Freecam Manual & Producer Variables
local freecamOn, producerMode = false, false
local camSpeed = 50
local yaw, pitch, orbitAngle, timeCount = 0, 0, 0, 0
local camPos = Vector3.zero
local upHeld, downHeld = false, false
local lookTouch, lastLookPos = nil, nil

-- [ FREECAM MANUAL OVERLAY (UP/DOWN) ]
local FC_Overlay = Instance.new("Frame")
FC_Overlay.Size = UDim2.new(1, 0, 1, 0)
FC_Overlay.BackgroundTransparency = 1
FC_Overlay.Visible = false
FC_Overlay.Parent = ScreenGui

local function makeFCBtn(t, p)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 55, 0, 55)
    b.Position = p
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.BackgroundTransparency = 0.5
    b.Text = t
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 24
    b.BorderSizePixel = 0
    b.Parent = FC_Overlay
    return b
end

local UBtn = makeFCBtn("▲", UDim2.new(1, -70, 0.5, -60))
local DBtn = makeFCBtn("▼", UDim2.new(1, -70, 0.5, 5))

UBtn.InputBegan:Connect(function() upHeld = true end)
UBtn.InputEnded:Connect(function() upHeld = false end)
DBtn.InputBegan:Connect(function() downHeld = true end)
DBtn.InputEnded:Connect(function() downHeld = false end)

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
    freecamOn = s
    producerMode = false
    FC_Overlay.Visible = s
    Camera.CameraType = s and Enum.CameraType.Scriptable or Enum.CameraType.Custom
    if s then
        camPos = Camera.CFrame.Position
        local lv = Camera.CFrame.LookVector
        yaw = math.deg(math.atan2(-lv.X, -lv.Z))
        pitch = math.deg(math.asin(math.clamp(lv.Y, -1, 1)))
    end
end)

AddBtn("DIRECTOR AI (ESTETIK)", "rbxassetid://6034289542", Color3.fromRGB(150, 0, 150), function(s)
    producerMode = s
    freecamOn = false
    FC_Overlay.Visible = false
    Camera.CameraType = s and Enum.CameraType.Scriptable or Enum.CameraType.Custom
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
SLbl.Text = "CAM SPEED: "..camSpeed
SLbl.TextColor3 = Color3.new(1, 1, 1)
SLbl.BackgroundTransparency = 1
SLbl.Font = Enum.Font.SourceSansBold
SLbl.Parent = SFrame
SFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then
        camSpeed = camSpeed >= 150 and 25 or camSpeed + 25
        SLbl.Text = "CAM SPEED: "..camSpeed
    end
end)

-- [ CAMERA ENGINE - PRO DIRECTOR LOGIC ]
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if producerMode and hrp then
        timeCount = timeCount + dt
        orbitAngle = orbitAngle + (dt * (camSpeed/100))
        
        -- LOGIKA BARU: Gerakan Kamera Produser (Tidak hanya muter)
        local wave1 = math.sin(timeCount * 0.5)
        local wave2 = math.cos(timeCount * 0.3)
        
        -- 1. Dolly Effect (Maju Mundur)
        local radius = 18 + (wave1 * 8)
        
        -- 2. Vertical Pan (Atas Bawah perlahan)
        local height = 5 + (wave2 * 4)
        
        -- 3. Side Panning (Geser Horizontal halus)
        local sideSweep = math.sin(timeCount * 0.2) * 5
        
        local basePos = hrp.Position + Vector3.new(
            math.sin(orbitAngle) * radius,
            height,
            math.cos(orbitAngle) * radius
        )
        
        -- Tambahkan Handheld Shake (Getaran kamera estetik)
        local shake = Vector3.new(
            math.noise(timeCount * 2, 0) * 0.2,
            math.noise(0, timeCount * 2) * 0.2,
            math.noise(timeCount * 2, timeCount * 2) * 0.2
        )
        
        local finalPos = basePos + (Camera.CFrame.RightVector * sideSweep) + shake
        
        -- LookAt Target (Fokus ke badan karakter)
        local targetLook = hrp.Position + Vector3.new(0, 1.5, 0)
        local lookCF = CFrame.new(finalPos, targetLook)
        
        -- Lerp sangat smooth agar terasa berat/premium
        Camera.CFrame = Camera.CFrame:Lerp(lookCF, 0.04)
        
    elseif freecamOn then
        local moveVector = Controls:GetMoveVector()
        local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        local vert = (upHeld and 1 or 0) - (downHeld and 1 or 0)
        local move = (rot.RightVector * moveVector.X) + (rot.LookVector * -moveVector.Z) + (Vector3.yAxis * vert)
        camPos = camPos + move * camSpeed * dt
        Camera.CFrame = CFrame.new(camPos) * rot
    end
    
    -- Character Lock
    if (freecamOn or producerMode) and hrp then
        hrp.Anchored = true
        hrp.Velocity = Vector3.zero
    elseif hrp then
        hrp.Anchored = false
    end
end)

-- Manual Touch Rotation
UserInputService.TouchStarted:Connect(function(input, gp)
    if freecamOn and not gp then
        if input.Position.X > Camera.ViewportSize.X * 0.3 then
            lookTouch = input
            lastLookPos = input.Position
        end
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if freecamOn and input == lookTouch then
        local delta = input.Position - lastLookPos
        yaw = yaw - delta.X * 0.25
        pitch = math.clamp(pitch - delta.Y * 0.25, -88, 88)
        lastLookPos = input.Position
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    if input == lookTouch then lookTouch = nil end
end)

-- Rainbow Border
task.spawn(function()
    while true do
        for i=0,1,0.01 do Border.BackgroundColor3 = Color3.fromHSV(i,0.7,1) task.wait(0.04) end
    end
end)

local WM = Instance.new("TextLabel")
WM.Text = "DIRECTOR PRO V5"
WM.Position = UDim2.new(0, 0, 1, -18)
WM.Size = UDim2.new(1, 0, 0, 15)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(100, 100, 100)
WM.TextSize = 8
WM.Parent = MainFrame
