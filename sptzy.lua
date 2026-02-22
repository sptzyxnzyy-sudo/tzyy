-- [[ PHANTOM REALTIME CONSOLE - OPTIMIZED ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- [[ CORE STATE ]] --
local isLooping = false
local autoScroll = true

-- [[ UI BASE ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RealtimeConsole"

-- [[ ICON (⚡) ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenBtn.Text = "⚡"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
OpenBtn.TextSize = 20
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 255, 255)

-- [[ MAIN PANEL ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 420)
Main.Position = UDim2.new(0.5, -190, 0.4, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Main.BorderSizePixel = 0

-- [[ REALTIME SCROLL (LUAS) ]] --
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 0, 280)
Scroll.Position = UDim2.new(0, 10, 0, 10)
Scroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ CONTROLS ]] --
local InputTarget = Instance.new("TextBox", Main)
InputTarget.Size = UDim2.new(1, -20, 0, 35)
InputTarget.Position = UDim2.new(0, 10, 0, 300)
InputTarget.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
InputTarget.Text = "NotifyEvent"
InputTarget.PlaceholderText = "Remote Name..."
InputTarget.TextColor3 = Color3.fromRGB(255, 255, 255)
InputTarget.Font = Enum.Font.Code

local LoopBtn = Instance.new("TextButton", Main)
LoopBtn.Size = UDim2.new(0.48, 0, 0, 35)
LoopBtn.Position = UDim2.new(0, 10, 0, 345)
LoopBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
LoopBtn.Text = "LOOP: OFF"
LoopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoopBtn.Font = Enum.Font.Code

local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.48, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.52, 0, 0, 345)
ScanBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
ScanBtn.Text = "SCAN REMOTE"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.Code

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 1, -30)
StatusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StatusLabel.Text = "SYSTEM STANDBY"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 12

-- [[ CORE LOGIC ]] --

local function log(txt, col)
    local l = Instance.new("TextLabel", Scroll)
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = string.format("[%s] %s", os.date("%X"), txt)
    l.TextColor3 = col or Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.Code
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    if autoScroll then Scroll.CanvasPosition = Vector2.new(0, Scroll.AbsoluteCanvasSize.Y) end
end

-- Scan Remote
ScanBtn.MouseButton1Click:Connect(function()
    log("--- SCANNING REPLICATEDSTORAGE ---", Color3.fromRGB(255, 255, 0))
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            log("FOUND: " .. v.Name, Color3.fromRGB(0, 200, 255))
        end
    end
end)

-- Loop Realtime
local function startLoop()
    while isLooping do
        local target = ReplicatedStorage:FindFirstChild(InputTarget.Text, true)
        if target and target:IsA("RemoteEvent") then
            StatusLabel.Text = "CONNECTED: " .. target.Name
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
            
            -- Listening Realtime tanpa delay visual
            local conn
            conn = target.OnClientEvent:Connect(function(...)
                local args = {...}
                log("RCV [" .. target.Name .. "]: " .. tostring(args[1]), Color3.fromRGB(255, 255, 255))
                conn:Disconnect()
            end)
        else
            StatusLabel.Text = "WAITING FOR: " .. InputTarget.Text
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        task.wait(0.1) -- Fast polling
    end
end

LoopBtn.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    LoopBtn.Text = isLooping and "LOOP: ON" or "LOOP: OFF"
    LoopBtn.BackgroundColor3 = isLooping and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    if isLooping then task.spawn(startLoop) end
end)

-- Draggable logic
local function drag(obj)
    local dragging, inputStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; inputStart = input.Position; startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - inputStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function() dragging = false end)
end

drag(Main); drag(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
