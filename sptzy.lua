local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser") -- Untuk simulasi klik
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Mobile Controls
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyySquare_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -100)
MainFrame.Size = UDim2.new(0, 200, 0, 310)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Rainbow Border
local Border = Instance.new("Frame")
Border.Name = "Border"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.BorderSizePixel = 0
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.ZIndex = 0

-- Minimize Button
local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 20, 0, 20)
MiniBtn.Position = UDim2.new(1, -25, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MiniBtn.Text = "_"
MiniBtn.TextColor3 = Color3.new(1, 1, 1)
MiniBtn.BorderSizePixel = 0
MiniBtn.Parent = MainFrame

-- [PROFILE SECTION]
local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(1, 0, 0, 50)
Profile.BackgroundTransparency = 1
Profile.Parent = MainFrame

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 35, 0, 35)
Avatar.Position = UDim2.new(0, 8, 0, 8)
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Avatar.BorderSizePixel = 0
Avatar.Parent = Profile

local NameLabel = Instance.new("TextLabel")
NameLabel.Text = LocalPlayer.DisplayName
NameLabel.Position = UDim2.new(0, 50, 0, 10)
NameLabel.Size = UDim2.new(0, 120, 0, 15)
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.Font = Enum.Font.SourceSansBold
NameLabel.TextSize = 14
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.BackgroundTransparency = 1
NameLabel.Parent = Profile

-- [CONTAINER - SCROLLING]
local Container = Instance.new("ScrollingFrame")
Container.Position = UDim2.new(0, 0, 0, 55)
Container.Size = UDim2.new(1, 0, 1, -75)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.ScrollBarThickness = 2
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 5)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
end)

-- Styled Square Button
local function AddSquareButton(name, icon, color, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.95, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.BorderSizePixel = 0
    Btn.Text = "          " .. name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 12
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Container
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0, 8, 0.5, -9)
    Icon.Image = icon
    Icon.BackgroundTransparency = 1
    Icon.Parent = Btn
    
    local act = false
    Btn.MouseButton1Click:Connect(function()
        act = not act
        Btn.BackgroundColor3 = act and color or Color3.fromRGB(25, 25, 25)
        func(act)
    end)
    return Btn
end

-- [Fitur Auto]

-- FITUR: AUTO CLICK SCREEN (Simulasi Klik Layar)
AddSquareButton("AUTO CLICK SCREEN", "rbxassetid://6034289542", Color3.fromRGB(0, 150, 150), function(s)
    _G.AutoClick = s
    while _G.AutoClick do
        -- Simulasi Klik di tengah layar (Viewport Center)
        local center = Camera.ViewportSize / 2
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(center.X, center.Y))
        task.wait(0.05) -- Kecepatan klik
    end
end)

-- FITUR: SPAM REMOTE (Punching Remote)
AddSquareButton("SPAM PUNCH REMOTE", "rbxassetid://6034289542", Color3.fromRGB(200, 0, 0), function(s)
    _G.SpamPunch = s
    while _G.SpamPunch do
        pcall(function() 
            ReplicatedStorage.CombatSystemVilk.Punching:FireServer(unpack({})) 
        end)
        task.wait(0.01)
    end
end)

AddSquareButton("AUTO BUY PADI", "rbxassetid://6031764630", Color3.fromRGB(0, 85, 150), function(s)
    _G.AutoBuy = s
    while _G.AutoBuy do
        pcall(function() ReplicatedStorage.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) end)
        task.wait(0.5)
    end
end)

AddSquareButton("AUTO SELL PADI", "rbxassetid://6031154871", Color3.fromRGB(150, 80, 0), function(s)
    _G.AutoSell = s
    while _G.AutoSell do
        pcall(function() ReplicatedStorage.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45) end)
        task.wait(0.5)
    end
end)

-- [Speed Control & Freecam Tetap Sama]
-- (Bagian Speed UI dan Freecam menyatu di bawah)

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(0.95, 0, 0, 35)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = Container

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
SpeedLabel.Text = "SPEED: 50"
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.Parent = SpeedFrame

local camSpeed = 50
local Plus = Instance.new("TextButton")
Plus.Size = UDim2.new(0.2, 0, 1, 0)
Plus.Position = UDim2.new(0.6, 0, 0, 0)
Plus.Text = "+" Plus.BackgroundColor3 = Color3.fromRGB(40,40,40)
Plus.TextColor3 = Color3.new(1,1,1)
Plus.Parent = SpeedFrame
Plus.MouseButton1Click:Connect(function() camSpeed = camSpeed + 10 SpeedLabel.Text = "SPEED: "..camSpeed end)

local Minus = Instance.new("TextButton")
Minus.Size = UDim2.new(0.2, 0, 1, 0)
Minus.Position = UDim2.new(0.8, 0, 0, 0)
Minus.Text = "-" Minus.BackgroundColor3 = Color3.fromRGB(40,40,40)
Minus.TextColor3 = Color3.new(1,1,1)
Minus.Parent = SpeedFrame
Minus.MouseButton1Click:Connect(function() camSpeed = math.max(10, camSpeed - 10) SpeedLabel.Text = "SPEED: "..camSpeed end)

-- Global Loops & Logic
task.spawn(function()
    while true do for i = 0, 1, 0.01 do Border.BackgroundColor3 = Color3.fromHSV(i, 0.8, 1) task.wait(0.03) end end
end)

-- Minimize Logic
MiniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 40, 0, 40), "Out", "Quad", 0.2, true)
        for _, v in pairs(MainFrame:GetChildren()) do if v ~= MiniBtn and v ~= Border then v.Visible = false end end
        MiniBtn.Text = "+" MiniBtn.Position = UDim2.new(0, 10, 0, 10)
    else
        MainFrame:TweenSize(UDim2.new(0, 200, 0, 310), "Out", "Quad", 0.2, true)
        task.wait(0.1)
        for _, v in pairs(MainFrame:GetChildren()) do v.Visible = true end
        MiniBtn.Text = "_" MiniBtn.Position = UDim2.new(1, -25, 0, 5)
    end
end)

local WM = Instance.new("TextLabel")
WM.Text = "IKYY SQUARE EXECUTOR V3"
WM.Position = UDim2.new(0, 0, 1, -20)
WM.Size = UDim2.new(1, 0, 0, 15)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(80, 80, 80)
WM.TextSize = 9
WM.Parent = MainFrame
