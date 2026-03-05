local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService") -- Tambahan untuk simulasi
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Mobile Controls
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyySquare_V3_Updated"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame (PERSEGI EMPAT)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0) -- Diatur agar lebih ke atas sedikit
MainFrame.Size = UDim2.new(0, 200, 0, 360) -- Ukuran ditambah sedikit untuk tombol baru
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Rainbow Border (Persegi)
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

-- [SCROLLING CONTAINER]
local Container = Instance.new("ScrollingFrame") -- Diubah ke Scrolling agar muat banyak
Container.Position = UDim2.new(0, 0, 0, 55)
Container.Size = UDim2.new(1, 0, 1, -75)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 0, 450)
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 5)

-- Variables
local freecamOn, upHeld, downHeld = false, false, false
local camSpeed, yaw, pitch = 50, 0, 0
local camPos, frozenPos = Vector3.zero, nil

-- [MINIMIZE LOGIC]
local isMinimized = false
MiniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 40, 0, 40), "Out", "Quad", 0.2, true)
        for _, v in pairs(MainFrame:GetChildren()) do if v ~= MiniBtn and v ~= Border then v.Visible = false end end
        MiniBtn.Text = "+" MiniBtn.Position = UDim2.new(0, 10, 0, 10)
    else
        MainFrame:TweenSize(UDim2.new(0, 200, 0, 360), "Out", "Quad", 0.2, true)
        task.wait(0.1)
        for _, v in pairs(MainFrame:GetChildren()) do v.Visible = true end
        MiniBtn.Text = "_" MiniBtn.Position = UDim2.new(1, -25, 0, 5)
    end
end)

-- Styled Square Button
local function AddSquareButton(name, icon, color, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
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

-- [FITUR GAMEPLAY]
AddSquareButton("AUTO BUY PADI", "rbxassetid://6031764630", Color3.fromRGB(0, 85, 150), function(s)
    _G.AutoBuy = s
    while _G.AutoBuy do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) end)
        task.wait(0.5)
    end
end)

AddSquareButton("AUTO SELL PADI", "rbxassetid://6031154871", Color3.fromRGB(150, 0, 0), function(s)
    _G.AutoSell = s
    while _G.AutoSell do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45) end)
        task.wait(0.5)
    end
end)

-- [FITUR EXECUTOR SIMULATOR (NEW)]
AddSquareButton("SERVER LOAD TEST", "rbxassetid://6031289224", Color3.fromRGB(138, 43, 226), function(s)
    _G.LoadTest = s
    if s then
        print("Starting Load Simulation on JobId: " .. game.JobId)
        while _G.LoadTest do
            task.spawn(function()
                pcall(function()
                    -- Menggunakan fungsi request jika tersedia (Executor) atau HttpService (Studio/Internal)
                    local reqFunc = (syn and syn.request) or (http and http.request) or request or (HttpService and HttpService.RequestAsync)
                    if reqFunc then
                        reqFunc({
                            Url = "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=10",
                            Method = "GET"
                        })
                    end
                end)
            end)
            task.wait(0.2) -- Interval antar gelombang request
        end
    else
        print("Load Simulation Stopped.")
    end
end)

-- [FREECAM SECTION]
AddSquareButton("MOBILE FREECAM", "rbxassetid://6034289542", Color3.fromRGB(0, 120, 0), function(s)
    freecamOn = s
    FC_Overlay.Visible = s
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if s then
        camPos = Camera.CFrame.Position
        local lv = Camera.CFrame.LookVector
        yaw, pitch = math.deg(math.atan2(-lv.X, -lv.Z)), math.deg(math.asin(math.clamp(lv.Y, -1, 1)))
        Camera.CameraType = Enum.CameraType.Scriptable
        if hrp then frozenPos = hrp.CFrame hrp.Anchored = true end
    else
        Camera.CameraType = Enum.CameraType.Custom
        if hrp then hrp.Anchored = false end
    end
end)

-- [SPEED CONTROL UI]
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 35)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = Container

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
SpeedLabel.Text = "CAM SPEED: " .. camSpeed
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 10
SpeedLabel.Parent = SpeedFrame

local Plus = Instance.new("TextButton")
Plus.Size = UDim2.new(0.2, 0, 1, 0)
Plus.Position = UDim2.new(0.6, 0, 0, 0)
Plus.Text = "+" Plus.BackgroundColor3 = Color3.fromRGB(40,40,40)
Plus.TextColor3 = Color3.new(1,1,1)
Plus.Parent = SpeedFrame
Plus.MouseButton1Click:Connect(function() camSpeed = camSpeed + 10 SpeedLabel.Text = "CAM SPEED: "..camSpeed end)

local Minus = Instance.new("TextButton")
Minus.Size = UDim2.new(0.2, 0, 1, 0)
Minus.Position = UDim2.new(0.8, 0, 0, 0)
Minus.Text = "-" Minus.BackgroundColor3 = Color3.fromRGB(40,40,40)
Minus.TextColor3 = Color3.new(1,1,1)
Minus.Parent = SpeedFrame
Minus.MouseButton1Click:Connect(function() camSpeed = math.max(10, camSpeed - 10) SpeedLabel.Text = "CAM SPEED: "..camSpeed end)

-- [FREECAM OVERLAY]
local FC_Overlay = Instance.new("Frame")
FC_Overlay.Size = UDim2.new(1, 0, 1, 0)
FC_Overlay.BackgroundTransparency = 1
FC_Overlay.Visible = false
FC_Overlay.Parent = ScreenGui

local UBtn = Instance.new("TextButton")
UBtn.Size = UDim2.new(0, 50, 0, 50)
UBtn.Position = UDim2.new(1, -60, 0.5, -55)
UBtn.Text = "UP" UBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
UBtn.BackgroundTransparency = 0.5
UBtn.TextColor3 = Color3.new(1,1,1)
UBtn.Parent = FC_Overlay

local DBtn = Instance.new("TextButton")
DBtn.Size = UDim2.new(0, 50, 0, 50)
DBtn.Position = UDim2.new(1, -60, 0.5, 5)
DBtn.Text = "DOWN" DBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
DBtn.BackgroundTransparency = 0.5
DBtn.TextColor3 = Color3.new(1,1,1)
DBtn.Parent = FC_Overlay

UBtn.InputBegan:Connect(function() upHeld = true end)
UBtn.InputEnded:Connect(function() upHeld = false end)
DBtn.InputBegan:Connect(function() downHeld = true end)
DBtn.InputEnded:Connect(function() downHeld = false end)

-- Rainbow Loop
task.spawn(function()
    while true do 
        for i = 0, 1, 0.01 do 
            Border.BackgroundColor3 = Color3.fromHSV(i, 0.8, 1) 
            task.wait(0.03) 
        end 
    end
end)

-- Control Logic
UserInputService.InputChanged:Connect(function(input)
    if freecamOn and input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.X > Camera.ViewportSize.X * 0.3 then
            yaw = yaw - input.Delta.X * 0.3
            pitch = math.clamp(pitch - input.Delta.Y * 0.3, -88, 88)
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if freecamOn then
        local mv = Controls:GetMoveVector()
        local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        local move = (rot.RightVector * mv.X) + (rot.LookVector * -mv.Z) + (Vector3.yAxis * ((upHeld and 1 or 0) - (downHeld and 1 or 0)))
        camPos = camPos + move * camSpeed * dt
        Camera.CFrame = CFrame.new(camPos) * rot
        if frozenPos and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = frozenPos
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.zero
        end
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
