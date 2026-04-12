-- RAJUAUTO SCANNER v4.5 - Ultra Compact Version
-- Ukuran Kecil, Rapi, & Modern

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajuCompact_V45"
ScreenGui.Parent = game.CoreGui

-- State
local isVisible = false
local selected = {}

-- Toggle Button (Ikon Kecil di Samping)
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 40, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0.5, -20)
Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Toggle.Text = "📡"
Toggle.TextColor3 = Color3.fromRGB(255, 50, 50)
Toggle.TextSize = 20
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)
local TStroke = Instance.new("UIStroke", Toggle)
TStroke.Color = Color3.fromRGB(255, 50, 50)
TStroke.Thickness = 1.5

-- Main Frame (Ukuran diperkecil jadi 220x280)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 280)
Main.Position = UDim2.new(0.5, -110, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Visible = false
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MCorner = Instance.new("UICorner", Main)
MCorner.CornerRadius = UDim.new(0, 8)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(255, 50, 50)
MStroke.Thickness = 1.2

-- Header (Drag Area)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Header.Parent = Main
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "RAJU SCANNER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Mini Buttons
local function createMiniBtn(txt, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 25)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 10
    b.Parent = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local ScanBtn = createMiniBtn("🔍 SCAN", 40, Color3.fromRGB(40, 40, 55))
local ExecBtn = createMiniBtn("🚀 FIRE", 245, Color3.fromRGB(180, 40, 40))
ExecBtn.Visible = false

-- Scroll List (Compact)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0, 160)
Scroll.Position = UDim2.new(0.05, 0, 0, 75)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 3)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

-- Dragging logic
local dragStart, startPos, dragging
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Toggle Menu
Toggle.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    Main.Visible = isVisible
    Toggle.Text = isVisible and "❌" or "📡"
end)

-- List Function
local function addToList(remote)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 24)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.Text = " " .. remote.Name
    b.TextColor3 = Color3.fromRGB(150, 150, 150)
    b.Font = Enum.Font.Gotham
    b.TextSize = 9
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    b.MouseButton1Click:Connect(function()
        if selected[remote] then
            selected[remote] = nil
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            b.TextColor3 = Color3.fromRGB(150, 150, 150)
        else
            selected[remote] = true
            b.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
            b.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
        ExecBtn.Visible = next(selected) ~= nil
    end)
end

-- Scan Function
ScanBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    table.clear(selected)
    ExecBtn.Visible = false
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then addToList(obj) end
    end
end)

-- Fire Function
ExecBtn.MouseButton1Click:Connect(function()
    for r, _ in pairs(selected) do pcall(function() r:FireServer() end) end
end)
