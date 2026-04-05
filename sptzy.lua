local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup UI Lama jika ada
if CoreGui:FindFirstChild("IkyyPremium_V3") then
    CoreGui:FindFirstChild("IkyyPremium_V3"):Destroy()
end

-- Create Canvas
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Helper: Rounded Corner
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

-- Helper: Drag System (Mobile Friendly)
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Main Frame (Modern Dark Glass)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.ClipsDescendants = true
AddCorner(MainFrame, 15)
MakeDraggable(MainFrame)

-- Neon Cyan Border
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Transparency = 0.4
UIStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "IKYY PREMIUM V3"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Minimize/Open Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "—"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Header
AddCorner(CloseBtn, 8)

-- Scrolling Container (Area Fitur Luas)
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 60)
Container.Size = UDim2.new(1, -20, 1, -110)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0) 

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Footer / Status Bar
local Footer = Instance.new("TextLabel")
Footer.Text = "ikyynih60 | Mobile Support"
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -30)
Footer.BackgroundTransparency = 1
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.Parent = MainFrame

-- State Management
local Toggles = { FakeDonate = false, AntiKick = false }

-- Function: Create Switch (ON/OFF)
local function CreateSwitch(name, callback)
    local SwitchFrame = Instance.new("Frame")
    SwitchFrame.Size = UDim2.new(1, -5, 0, 45)
    SwitchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SwitchFrame.Parent = Container
    AddCorner(SwitchFrame, 8)

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = SwitchFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 35, 0, 18)
    ToggleBtn.Position = UDim2.new(1, -45, 0.5, -9)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = SwitchFrame
    AddCorner(ToggleBtn, 10)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 2, 0.5, -7)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = ToggleBtn
    AddCorner(Circle, 10)

    local Status = false
    ToggleBtn.MouseButton1Click:Connect(function()
        Status = not Status
        Toggles[name] = Status
        local targetPos = Status and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = Status and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        callback(Status)
    end)
end

-- LOGIKA SCAN -> FAKE DONATE
local function ExecuteFakeDonate()
    if not Toggles["FakeDonate"] then return end

    -- 1. Scan Mode
    Title.Text = "SCANNING PRODUCT..."
    Title.TextColor3 = Color3.fromRGB(255, 255, 0)
    Footer.Text = "Status: Searching Vulnerability..."
    task.wait(1.8)

    -- 2. Result Logic (Random Success/Fail)
    local isSuccess = math.random(1, 10) > 2 -- 80% Success rate
    
    if isSuccess then
        Title.Text = "SCAN COMPLETE!"
        Title.TextColor3 = Color3.fromRGB(0, 255, 100)
        Footer.Text = "Status: Injecting Visual Data..."
        task.wait(0.5)

        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[SYSTEM]: " .. LocalPlayer.DisplayName .. " has donated 100,000 Robux! (Verified)";
            Color = Color3.fromRGB(0, 255, 255);
            Font = Enum.Font.GothamBold;
        })
        Footer.Text = "SUCCESS: DONATE SENT ✅"
        Footer.TextColor3 = Color3.fromRGB(0, 255, 255)
    else
        Title.Text = "SCAN FAILED!"
        Title.TextColor3 = Color3.fromRGB(255, 50, 50)
        Footer.Text = "FAILED: SERVER BLOCKED SCAN ❌"
        Footer.TextColor3 = Color3.fromRGB(255, 50, 50)
    end

    task.wait(2.5)
    Title.Text = "IKYY PREMIUM V3"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
end

-- Implement Switches
CreateSwitch("FakeDonate", function(enabled)
    if enabled then
        task.spawn(function()
            while Toggles["FakeDonate"] do
                ExecuteFakeDonate()
                task.wait(7) -- Delay antar donasi
            end
        end)
    else
        Footer.Text = "ikyynih60 | Mobile Support"
    end
end)

CreateSwitch("AntiKick", function(enabled)
    if enabled then
        Footer.Text = "Anti-Kick: ACTIVE"
        Footer.TextColor3 = Color3.fromRGB(0, 255, 255)
    else
        Footer.Text = "Anti-Kick: OFF"
        Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- UI Toggle Logic
local IsOpen = true
CloseBtn.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen
    local targetSize = IsOpen and UDim2.new(0, 250, 0, 350) or UDim2.new(0, 250, 0, 50)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    CloseBtn.Text = IsOpen and "—" or "+"
end)

-- Rainbow Pulse Effect
RunService.RenderStepped:Connect(function()
    if IsOpen then
        UIStroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.5, 1)
    end
end)

print("IkyyPremium V3.5 Loaded Successfully!")
