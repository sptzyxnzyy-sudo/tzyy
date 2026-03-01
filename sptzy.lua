local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Mengambil modul kontrol internal Roblox
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner_M = Instance.new("UICorner")
UICorner_M.CornerRadius = UDim.new(0, 8)
UICorner_M.Parent = MainFrame

local Border = Instance.new("Frame")
Border.Name = "RainbowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.BorderSizePixel = 0
Border.Position = UDim2.new(0, -2, 0, -2)
Border.Size = UDim2.new(1, 4, 1, 4)
Border.ZIndex = 0
local UICorner_B = Instance.new("UICorner")
UICorner_B.CornerRadius = UDim.new(0, 8)
UICorner_B.Parent = Border

local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 0, 0, 70)
Container.Size = UDim2.new(1, 0, 1, -70)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

-- Rainbow Logic
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Border.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
            task.wait(0.02)
        end
    end
end)

-- Freecam Variables
local isFreecam = false
local camSpeed = 1.2
local lookSensitivity = 0.5
local cameraRot = Vector2.new(0, 0)
local freecamPos = Vector3.new(0, 0, 0)
local charLockPos = nil
local bv = nil

-- Touch Input Handler
UserInputService.InputChanged:Connect(function(input)
    if isFreecam and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Delta
        cameraRot = cameraRot + Vector2.new(-delta.X * lookSensitivity, -delta.Y * lookSensitivity)
        cameraRot = Vector2.new(cameraRot.X, math.clamp(cameraRot.Y, -85, 85))
    end
end)

-- Button Creator
local function CreateStyledButton(name, icon, color, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = "          " .. name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Container
    
    local UICorner_Btn = Instance.new("UICorner")
    UICorner_Btn.CornerRadius = UDim.new(0, 6)
    UICorner_Btn.Parent = Btn
    
    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 20, 0, 20)
    IconImg.Position = UDim2.new(0, 10, 0.5, -10)
    IconImg.Image = icon
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = Btn
    
    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.BackgroundColor3 = toggled and color or Color3.fromRGB(35, 35, 35)
        func(toggled)
    end)
end

-- Buttons
CreateStyledButton("AUTO BUY", "rbxassetid://6031764630", Color3.fromRGB(0, 102, 204), function(state)
    _G.AutoBuy = state
    while _G.AutoBuy do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) end)
        task.wait(0.5)
    end
end)

CreateStyledButton("AUTO SELL", "rbxassetid://6031154871", Color3.fromRGB(153, 0, 0), function(state)
    _G.AutoSell = state
    while _G.AutoSell do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45) end)
        task.wait(0.5)
    end
end)

-- ANTI BUG FREECAM
CreateStyledButton("FREECAM ANTI-BUG", "rbxassetid://6034289542", Color3.fromRGB(0, 153, 76), function(state)
    isFreecam = state
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if state then
        if hrp then
            charLockPos = hrp.Position
            freecamPos = Camera.CFrame.Position
            
            -- Buat Force agar tidak jatuh
            bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Parent = hrp
            
            local y, x, z = Camera.CFrame:ToEulerAnglesYXZ()
            cameraRot = Vector2.new(math.deg(x), math.deg(y))
        end
        Camera.CameraType = Enum.CameraType.Scriptable
    else
        if bv then bv:Destroy() end
        Camera.CameraType = Enum.CameraType.Custom
        -- Kembalikan posisi karakter ke titik aman terakhir agar tidak tembus
        if hrp and charLockPos then
            hrp.CFrame = CFrame.new(charLockPos + Vector3.new(0, 2, 0))
        end
    end
end)

-- Render Loop
RunService.RenderStepped:Connect(function()
    if isFreecam then
        -- 1. Lock Character Position (Anti-Bug Tembus)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and charLockPos then
            hrp.CFrame = CFrame.new(charLockPos) -- Karakter dipaksa diam di posisi awal
            hrp.Velocity = Vector3.new(0, 0, 0)
        end

        -- 2. Camera Rotation & Movement
        local rotationCF = CFrame.Angles(0, math.rad(cameraRot.X), 0) * CFrame.Angles(math.rad(cameraRot.Y), 0, 0)
        local moveVector = Controls:GetMoveVector()
        
        if moveVector.Magnitude > 0 then
            local moveDir = (rotationCF * Vector3.new(moveVector.X, 0, -moveVector.Z))
            freecamPos = freecamPos + (moveDir * camSpeed)
        end
        
        Camera.CFrame = CFrame.new(freecamPos) * rotationCF
    end
end)

-- Watermark
local WM = Instance.new("TextLabel")
WM.Text = "IKYY EXECUTOR v3"
WM.Position = UDim2.new(0, 0, 1, -20)
WM.Size = UDim2.new(1, 0, 0, 20)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(80, 80, 80)
WM.TextSize = 10
WM.Parent = MainFrame
