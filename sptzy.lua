-- RAJUAUTO SCANNER v5.0 - Micro Square UI
-- Compact, Sleek, and Mobile-Optimized

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajuMicro_V5"
ScreenGui.Parent = game.CoreGui

local selected = {}

-- 1. Tombol Buka/Tutup (Mini Icon)
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 35, 0, 35)
Toggle.Position = UDim2.new(0, 10, 0.4, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Toggle.Text = "⚡"
Toggle.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan Neon
Toggle.TextSize = 18
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)
local TStroke = Instance.new("UIStroke", Toggle)
TStroke.Color = Color3.fromRGB(0, 255, 255)
TStroke.Thickness = 1.5

-- 2. Main Frame (Persegi Empat Kecil: 180x220)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 220)
Main.Position = UDim2.new(0.5, -90, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Visible = false
Main.Parent = ScreenGui

local MCorner = Instance.new("UICorner", Main)
MCorner.CornerRadius = UDim.new(0, 6)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(0, 255, 255)
MStroke.Thickness = 1.2

-- 3. Header (Drag Area)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 25)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Header.Parent = Main
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "SCANNER MINI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.BackgroundTransparency = 1
Title.Parent = Header

-- 4. Scroll List (Area Tengah)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0, 120)
Scroll.Position = UDim2.new(0.05, 0, 0, 65)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 3)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

-- 5. Buttons (Scan & Fire)
local function createBtn(txt, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 22)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 9
    b.Parent = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local ScanBtn = createBtn("SCAN REMOTES", 35, Color3.fromRGB(40, 40, 50))
local ExecBtn = createBtn("EXECUTE", 190, Color3.fromRGB(150, 0, 0))
ExecBtn.Visible = false

-- Logika Interaksi
local dragging, dragStart, startPos
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

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Toggle.Text = Main.Visible and "X" or "⚡"
end)

local function addRemote(remote)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 22)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Text = " " .. remote.Name
    b.TextColor3 = Color3.fromRGB(200, 200, 200)
    b.Font = Enum.Font.Gotham
    b.TextSize = 8
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    b.MouseButton1Click:Connect(function()
        if selected[remote] then
            selected[remote] = nil
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            selected[remote] = true
            b.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        ExecBtn.Visible = next(selected) ~= nil
    end)
end

ScanBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    table.clear(selected)
    ExecBtn.Visible = false
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then addRemote(obj) end
    end
end)

ExecBtn.MouseButton1Click:Connect(function()
    for r, _ in pairs(selected) do pcall(function() r:FireServer() end) end
end)
