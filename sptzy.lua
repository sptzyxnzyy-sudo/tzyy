-- [[ PHANTOM SQUARE: REMOTE SCANNER & EXECUTOR ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- [[ STATE MANAGEMENT ]] --
local autoListen = true
local historyLog = {}
local isLooping = false
local selectedRemote = "NotifyEvent" -- Default sesuai permintaanmu

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomScannerV4"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- [[ TOGGLE ICON (⚡) ]] --
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenBtn.Text = "⚡"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
OpenBtn.TextSize = 25
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)

-- [[ MAIN PANEL ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 450)
Main.Position = UDim2.new(0.5, -175, 0.4, -225)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 255)

-- [[ STATUS BAR (LOOP MONITOR) ]] --
local StatusBar = Instance.new("Frame", Main)
StatusBar.Size = UDim2.new(1, 0, 0, 25)
StatusBar.Position = UDim2.new(0, 0, 1, -25)
StatusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
local StatusText = Instance.new("TextLabel", StatusBar)
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "SYSTEM IDLE | LOOP: OFF"
StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusText.Font = Enum.Font.Code
StatusText.TextSize = 10

-- [[ REMOTE SCANNER COMPONENT ]] --
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 30)
ScanBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ScanBtn.Text = "SCAN REMOTES"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
ScanBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ScanBtn)

-- [[ LOG DISPLAY ]] --
local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0, 150)
LogFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
LogFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
local LogText = Instance.new("TextLabel", LogFrame)
LogText.Size = UDim2.new(0.95, 0, 1, 0)
LogText.BackgroundTransparency = 1
LogText.TextColor3 = Color3.fromRGB(0, 255, 150)
LogText.Font = Enum.Font.Code
LogText.TextSize = 10
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.TextWrapped = true

-- [[ EXECUTION CONTROLS ]] --
local LoopBtn = Instance.new("TextButton", Main)
LoopBtn.Size = UDim2.new(0.9, 0, 0, 40)
LoopBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
LoopBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
LoopBtn.Text = "START EXECUTION LOOP"
LoopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", LoopBtn)

local ManualInput = Instance.new("TextBox", Main)
ManualInput.Size = UDim2.new(0.9, 0, 0, 40)
ManualInput.Position = UDim2.new(0.05, 0, 0.68, 0)
ManualInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ManualInput.PlaceholderText = "Target Remote Name..."
ManualInput.Text = "NotifyEvent"
ManualInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ManualInput)

-- [[ FUNCTIONS ]] --
local function addLog(msg)
    table.insert(historyLog, 1, "[" .. os.date("%X") .. "] " .. msg)
    if #historyLog > 10 then table.remove(historyLog, 11) end
    LogText.Text = table.concat(historyLog, "\n")
end

-- Scan Function
ScanBtn.MouseButton1Click:Connect(function()
    addLog("Scanning ReplicatedStorage...")
    local found = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            found = found + 1
            addLog("Found: " .. obj.Name)
        end
    end
    addLog("Scan Complete. Found " .. found .. " Remotes.")
end)

-- Execution Loop Logic
local function runExecutionLoop()
    while isLooping do
        local target = ReplicatedStorage:FindFirstChild(ManualInput.Text, true)
        if target and target:IsA("RemoteEvent") then
            local success, err = pcall(function()
                -- Contoh simulasi eksekusi (menangkap/menunggu event)
                StatusText.Text = "EXECUTING: " .. target.Name .. " | SUCCESS ✅"
                StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
            end)
            if not success then
                StatusText.Text = "EXECUTION ERROR ❌"
                StatusText.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        else
            StatusText.Text = "TARGET NOT FOUND ⚠️"
            StatusText.TextColor3 = Color3.fromRGB(255, 165, 0)
        end
        task.wait(1) -- Delay loop agar tidak lag
    end
end

LoopBtn.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    if isLooping then
        LoopBtn.Text = "STOP EXECUTION LOOP"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        task.spawn(runExecutionLoop)
    else
        LoopBtn.Text = "START EXECUTION LOOP"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        StatusText.Text = "SYSTEM IDLE | LOOP: OFF"
        StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- Draggable logic
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function() dragging = false end)
end

makeDraggable(Main); makeDraggable(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
