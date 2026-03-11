local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Create Canvas
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.Size = UDim2.new(0, 225, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

-- Rainbow Border
local Border = Instance.new("Frame")
Border.Name = "RainbowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.Position = UDim2.new(0, -2, 0, -2)
Border.Size = UDim2.new(1, 4, 1, 4)
Border.ZIndex = 0
AddCorner(Border, 10)
AddCorner(MainFrame, 10)

-- Rainbow Logic
RunService.RenderStepped:Connect(function()
    Border.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
end)

-- Header / Profile
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, 0, 0, 65)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = MainFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 45, 0, 45)
AvatarImg.Position = UDim2.new(0, 12, 0, 10)
AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImg.Parent = ProfileFrame
AddCorner(AvatarImg, 100)

local UserName = Instance.new("TextLabel")
UserName.Text = LocalPlayer.DisplayName
UserName.Position = UDim2.new(0, 65, 0, 15)
UserName.Size = UDim2.new(0, 120, 0, 20)
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.Font = Enum.Font.SourceSansBold
UserName.TextSize = 16
UserName.BackgroundTransparency = 1
UserName.Parent = ProfileFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Parent = MainFrame
AddCorner(CloseBtn, 5)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Buttons Container
local Container = Instance.new("ScrollingFrame")
Container.Position = UDim2.new(0, 0, 0, 75)
Container.Size = UDim2.new(1, 0, 1, -120)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

-- Function Create Button
local function CreateButton(name, icon, activeColor, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 200, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = "          " .. name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Container
    AddCorner(Btn, 6)
    
    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 20, 0, 20)
    IconImg.Position = UDim2.new(0, 10, 0.5, -10)
    IconImg.Image = icon
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = Btn
    
    local Active = false
    Btn.MouseButton1Click:Connect(function()
        Active = not Active
        TweenService:Create(Btn, TweenInfo.new(0.3), {
            BackgroundColor3 = Active and activeColor or Color3.fromRGB(30, 30, 30),
            TextColor3 = Active and Color3.new(1,1,1) or Color3.fromRGB(200,200,200)
        }):Play()

        task.spawn(function()
            while Active do
                local s, e = pcall(func)
                if not s then warn("Error: "..e) end
                task.wait(0.5) -- Delay prevent kick
            end
        end)
    end)
end

-- FITUR: AUTO BELI & JUAL
CreateButton("AUTO BUY PADI", "rbxassetid://6031764630", Color3.fromRGB(0, 80, 200), function()
    ReplicatedStorage.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
end)

CreateButton("AUTO SELL PADI", "rbxassetid://6031154871", Color3.fromRGB(150, 0, 0), function()
    ReplicatedStorage.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45)
end)

-- FITUR: FIREWORKS STATUS
local FireworksStatus = Instance.new("TextLabel")
FireworksStatus.Size = UDim2.new(1, 0, 0, 20)
FireworksStatus.Position = UDim2.new(0, 0, 1, -45)
FireworksStatus.BackgroundTransparency = 1
FireworksStatus.TextColor3 = Color3.fromRGB(100, 100, 100)
FireworksStatus.Text = "Status: No Fireworks"
FireworksStatus.TextSize = 12
FireworksStatus.Parent = MainFrame

-- Remote Listener Fireworks
local F_Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FireworksBroadcast")
F_Remote.OnClientEvent:Connect(function(data)
    -- Logika sesuai argumen yang kamu berikan
    FireworksStatus.Text = "🎆 Fireworks: ON (By: " .. (data.from or "Server") .. ")"
    FireworksStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    task.delay(data.duration or 10, function()
        FireworksStatus.Text = "Status: No Fireworks"
        FireworksStatus.TextColor3 = Color3.fromRGB(100, 100, 100)
    end)
end)

-- Watermark
local WM = Instance.new("TextLabel")
WM.Text = "IKYY PREMIUM V3 - 2026"
WM.Position = UDim2.new(0, 0, 1, -25)
WM.Size = UDim2.new(1, 0, 0, 20)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(60, 60, 60)
WM.TextSize = 10
WM.Parent = MainFrame

print("IkyyPremium V3 Loaded!")
