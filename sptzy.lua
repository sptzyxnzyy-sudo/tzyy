local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup UI Lama
if CoreGui:FindFirstChild("IkyyPremium_V4_Final") then
    CoreGui:FindFirstChild("IkyyPremium_V4_Final"):Destroy()
end

-- Create Canvas
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V4_Final"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Helper: UI Corner & Drag
local function AddCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
end

local function MakeDraggable(f)
    local d, di, ds, sp
    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = true ds = i.Position sp = f.Position
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            di = i
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == di and d then
            local del = i.Position - ds
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = false
        end
    end)
end

-- Main Frame (Modern Cyberpunk)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 420)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
AddCorner(MainFrame, 15)
MakeDraggable(MainFrame)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Transparency = 0.3
Stroke.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
Title.Text = "IKYY PREMIUM V4"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Scroll Area
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 8)

-- Footer Status
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.Text = "SYSTEM IDLE"
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.Font = Enum.Font.Code
Footer.TextSize = 10
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

-- Logic: Server-Side Simulation
local function ExecuteFakeBuy(name, price)
    Title.Text = "INJECTING PACKET..."
    Title.TextColor3 = Color3.fromRGB(255, 200, 0)
    Footer.Text = "TARGET: " .. name:upper()
    
    -- Simulasi Delay Server
    task.wait(1.2)
    
    local success = math.random(1, 10) > 2
    if success then
        Title.Text = "SUCCESS ✅"
        Title.TextColor3 = Color3.fromRGB(0, 255, 100)
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[SERVER]: Verified. Product '"..name.."' added. (R$ "..price..")";
            Color = Color3.fromRGB(0, 255, 255);
            Font = Enum.Font.GothamBold;
        })
        Footer.Text = "TRANS_ID: " .. math.random(100000, 999999)
    else
        Title.Text = "FAILED ❌"
        Title.TextColor3 = Color3.fromRGB(255, 50, 50)
        Footer.Text = "ERROR: PACKET_LOSS_DETECTION"
    end
    
    task.wait(2)
    Title.Text = "IKYY PREMIUM V4"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
end

-- Function: Add Item to List
local function AddProductItem(name, price)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.Text = "  " .. name .. " [R$ " .. price .. "]"
    Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 12
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Scroll
    AddCorner(Btn, 8)

    local Icon = Instance.new("TextLabel")
    Icon.Text = "FAKE BUY"
    Icon.Size = UDim2.new(0, 70, 1, 0)
    Icon.Position = UDim2.new(1, -75, 0, 0)
    Icon.TextColor3 = Color3.fromRGB(0, 255, 255)
    Icon.Font = Enum.Font.GothamBold
    Icon.TextSize = 9
    Icon.BackgroundTransparency = 1
    Icon.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        ExecuteFakeBuy(name, price)
    end)
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end

-- Auto Scan Products
local function ScanProducts()
    Footer.Text = "SCANNING SERVER PRODUCTS..."
    task.wait(1.5)
    
    local List = {
        {n = "Admin Panel", p = "5,000"},
        {n = "VIP Pass", p = "800"},
        {n = "Unlimited Gems", p = "10,000"},
        {n = "Mega Sword", p = "1,200"},
        {n = "Speed Coil", p = "250"},
        {n = "Fly Potion", p = "150"}
    }
    
    for _, item in pairs(List) do
        AddProductItem(item.n, item.p)
        task.wait(0.1)
    end
    Footer.Text = "SCAN READY: " .. #List .. " ITEMS"
end

-- Minimize/Open UI
local IsOpen = true
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleBtn.Position = UDim2.new(1, -40, 0, 8)
ToggleBtn.Text = "—"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Parent = MainFrame
AddCorner(ToggleBtn, 5)

ToggleBtn.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen
    local targetSize = IsOpen and UDim2.new(0, 280, 0, 420) or UDim2.new(0, 280, 0, 45)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
    ToggleBtn.Text = IsOpen and "—" or "+"
end)

-- Rainbow Cycle
RunService.RenderStepped:Connect(function()
    Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)
end)

-- Initialize
task.spawn(ScanProducts)
print("IkyyPremium V4 Final Loaded!")
