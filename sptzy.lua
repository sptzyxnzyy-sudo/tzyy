-- RAJUAUTO SCANNER v4.0 FULL VERSION
-- Fitur: Auto Scan, Multi-Select, Hooking, & Toggle UI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Cleanup existing UI
if game.CoreGui:FindFirstChild("RajuAI_Scanner_V4") then
    game.CoreGui["RajuAI_Scanner_V4"]:Destroy()
end

-- Container Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajuAI_Scanner_V4"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Variabel State
local isVisible = false
local selectedEvents = {}

-- Fungsi Notifikasi Modern
local function notify(text, color)
    local nFrame = Instance.new("Frame")
    nFrame.Size = UDim2.new(0, 200, 0, 40)
    nFrame.Position = UDim2.new(1, 10, 0.1, 0)
    nFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    nFrame.BorderSizePixel = 0
    nFrame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = nFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 50, 50)
    stroke.Thickness = 2
    stroke.Parent = nFrame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.Parent = nFrame
    
    nFrame:TweenPosition(UDim2.new(1, -220, 0.1, 0), "Out", "Quad", 0.3, true)
    task.delay(2.5, function()
        nFrame:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.3, true)
        task.wait(0.3)
        nFrame:Destroy()
    end)
end

-- Ikon Toggle (Tombol Buka/Tutup)
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Size = UDim2.new(0, 45, 0, 45)
ToggleIcon.Position = UDim2.new(0, 20, 0.5, -22)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleIcon.Text = "📡"
ToggleIcon.TextSize = 22
ToggleIcon.Parent = ScreenGui

local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(0, 12)
TCorner.Parent = ToggleIcon

local TStroke = Instance.new("UIStroke")
TStroke.Thickness = 2
TStroke.Color = Color3.fromRGB(255, 50, 50)
TStroke.Parent = ToggleIcon

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Visible = false
Main.Parent = ScreenGui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0, 10)
MCorner.Parent = Main

-- Header (Drag Area)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.Parent = Main

local HCorner = Instance.new("UICorner")
HCorner.CornerRadius = UDim.new(0, 10)
HCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "RAJU SCANNER v4.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Scroll Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0, 240)
Scroll.Position = UDim2.new(0.05, 0, 0.25, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = Scroll

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

-- Tombol Scan
local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.9, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.05, 0, 0.13, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
ScanBtn.Text = "🔍 SCAN NETWORK"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamMedium
ScanBtn.TextSize = 12
ScanBtn.Parent = Main
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Execute
local ExecBtn = Instance.new("TextButton")
ExecBtn.Size = UDim2.new(0.9, 0, 0, 40)
ExecBtn.Position = UDim2.new(0.05, 0, 0.87, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ExecBtn.Text = "🚀 FIRE REMOTE(S)"
ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextSize = 14
ExecBtn.Visible = false
ExecBtn.Parent = Main
Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 6)

-- Logika Dragging
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Toggle Menu
ToggleIcon.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    Main.Visible = isVisible
    ToggleIcon.Text = isVisible and "❌" or "📡"
    ToggleIcon.BackgroundColor3 = isVisible and Color3.fromRGB(50, 30, 30) or Color3.fromRGB(30, 30, 40)
end)

-- Fungsi Tambah Item ke List
local function addRemoteToList(remote)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = "  " .. remote.Name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        if selectedEvents[remote] then
            selectedEvents[remote] = nil
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        else
            selectedEvents[remote] = true
            btn.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        
        -- Cek jika ada yang dipilih untuk nampilin tombol execute
        local hasSelection = false
        for _ in pairs(selectedEvents) do hasSelection = true break end
        ExecBtn.Visible = hasSelection
    end)
end

-- Scan Logic
ScanBtn.MouseButton1Click:Connect(function()
    notify("Scanning...", Color3.fromRGB(255, 200, 50))
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    table.clear(selectedEvents)
    ExecBtn.Visible = false
    
    local found = 0
    local targets = {game.ReplicatedStorage, game.Workspace, game.Players.LocalPlayer}
    
    for _, root in pairs(targets) do
        for _, obj in pairs(root:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                addRemoteToList(obj)
                found = found + 1
            end
        end
    end
    notify("Found " .. found .. " Remotes", Color3.fromRGB(100, 255, 100))
end)

-- Execute Logic
ExecBtn.MouseButton1Click:Connect(function()
    local count = 0
    for remote, _ in pairs(selectedEvents) do
        pcall(function()
            remote:FireServer() -- Trigger default
            count = count + 1
        end)
    end
    notify("Fired " .. count .. " Remotes!", Color3.fromRGB(100, 150, 255))
end)

notify("RAJU SCANNER LOADED", Color3.fromRGB(255, 50, 50))
