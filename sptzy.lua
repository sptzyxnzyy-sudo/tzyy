local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Mengambil modul kontrol internal Roblox
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Setup (Sama seperti sebelumnya dengan sedikit penyesuaian ukuran)
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

-- Rainbow Border
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

-- Profile Section (Singkat)
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, 0, 0, 60)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = MainFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 45, 0, 45)
AvatarImg.Position = UDim2.new(0, 10, 0, 10)
AvatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
AvatarImg.Parent = ProfileFrame
local UICorner_A = Instance.new("UICorner")
UICorner_A.CornerRadius = UDim.new(1, 0)
UICorner_A.Parent = AvatarImg

-- Buttons Container
local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 0, 0, 70)
Container.Size = UDim2.new(1, 0, 1, -70)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 10)

-- Rainbow Anim
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Border.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
            task.wait(0.02)
        end
    end
end)

-- Variabel Freecam
local isFreecam = false
local camSpeed = 1.0

-- Button Function
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

-- ICONS
local CART_ICON = "rbxassetid://6031764630"
local SELL_ICON = "rbxassetid://6031154871"
local CAM_ICON = "rbxassetid://6034289542"

-- ADD BUTTONS
CreateStyledButton("AUTO BUY", CART_ICON, Color3.fromRGB(0, 102, 204), function(state)
    _G.AutoBuy = state
    while _G.AutoBuy do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
        end)
        task.wait(0.5)
    end
end)

CreateStyledButton("AUTO SELL", SELL_ICON, Color3.fromRGB(153, 0, 0), function(state)
    _G.AutoSell = state
    while _G.AutoSell do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45)
        end)
        task.wait(0.5)
    end
end)

CreateStyledButton("FREECAM MOBILE", CAM_ICON, Color3.fromRGB(0, 153, 76), function(state)
    isFreecam = state
    if state then
        Camera.CameraType = Enum.CameraType.Scriptable
        -- Disable pergerakan karakter agar tidak jalan saat freecam
        LocalPlayer.Character.Humanoid.PlatformStand = true
    else
        Camera.CameraType = Enum.CameraType.Custom
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end)

-- FREECAM ENGINE (Menggunakan Input Analog/Control)
RunService.RenderStepped:Connect(function()
    if isFreecam then
        -- Ambil arah dari Analog/Tombol Gerak Roblox
        local moveVector = Controls:GetMoveVector()
        
        if moveVector.Magnitude > 0 then
            -- Hitung pergerakan berdasarkan pandangan kamera
            local cframe = Camera.CFrame
            local direction = (cframe.RightVector * moveVector.X) + (cframe.LookVector * -moveVector.Z)
            
            -- Update posisi kamera
            Camera.CFrame = cframe + (direction * camSpeed)
        end
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
