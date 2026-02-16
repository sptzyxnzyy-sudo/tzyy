-- [[ PHANTOM ULTIMATE v3: FLOATING EDITION ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local isRunning = false
local currentTask = nil

-- Cleanup Old UI
if CoreGui:FindFirstChild("PhantomFloating_V3") then CoreGui.PhantomFloating_V3:Destroy() end

-- [[ UI ROOT ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomFloating_V3"
ScreenGui.ResetOnSpawn = false

-- [[ FLOATING ICON (TOMBOL PEMBUKA) ]] --
local IconButton = Instance.new("Frame", ScreenGui)
IconButton.Name = "FloatingIcon"
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IconButton.BorderSizePixel = 0
IconButton.Active = true
IconButton.ZIndex = 10

local IconCorner = Instance.new("UICorner", IconButton)
IconCorner.CornerRadius = UDim.new(1, 0)

local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(85, 255, 127)
IconStroke.Thickness = 2

local IconText = Instance.new("TextLabel", IconButton)
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.Text = "P"
IconText.TextColor3 = Color3.fromRGB(85, 255, 127)
IconText.Font = Enum.Font.GothamBold
IconText.TextSize = 24
IconText.BackgroundTransparency = 1

local OpenButton = Instance.new("TextButton", IconButton)
OpenButton.Size = UDim2.new(1, 0, 1, 0)
OpenButton.BackgroundTransparency = 1
OpenButton.Text = ""

-- [[ MAIN MENU ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.4, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Visible = false -- Sembunyi saat awal
Main.Active = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(85, 255, 127)
MainStroke.Thickness = 1.5

-- [[ TOP BAR / CLOSE SYSTEM ]] --
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "PHANTOM ULTIMATE v3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.95, -30, 0.5, -15)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BackgroundTransparency = 1

-- [[ TOGGLE SWITCH BOX ]] --
local ControlFrame = Instance.new("Frame", Main)
ControlFrame.Size = UDim2.new(0.9, 0, 0, 50)
ControlFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
ControlFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UICorner", ControlFrame)

local StatusLabel = Instance.new("TextLabel", ControlFrame)
StatusLabel.Size = UDim2.new(0.6, 0, 1, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 0)
StatusLabel.Text = "ENGINE STATUS: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.BackgroundTransparency = 1

local SwitchBG = Instance.new("Frame", ControlFrame)
SwitchBG.Size = UDim2.new(0, 50, 0, 24)
SwitchBG.Position = UDim2.new(0.8, -5, 0.5, -12)
SwitchBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

local SwitchDot = Instance.new("TextButton", SwitchBG)
SwitchDot.Size = UDim2.new(0, 18, 0, 18)
SwitchDot.Position = UDim2.new(0.1, 0, 0.5, -9)
SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
SwitchDot.Text = ""
Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

-- [[ PROGRESS & LOGS ]] --
local BarBG = Instance.new("Frame", Main)
BarBG.Size = UDim2.new(0.9, 0, 0, 4)
BarBG.Position = UDim2.new(0.05, 0, 0.26, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
local BarFill = Instance.new("Frame", BarBG)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
BarFill.BorderSizePixel = 0

local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0.65, 0)
LogFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 2
local LogList = Instance.new("UIListLayout", LogFrame)

-- [[ UTILITY FUNCTIONS ]] --
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
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
end

local function AddLog(text, color, progress)
    local l = Instance.new("TextLabel", LogFrame)
    l.Size = UDim2.new(1, -10, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "> " .. text
    l.TextColor3 = color or Color3.new(1,1,1)
    l.Font = Enum.Font.Code
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    if progress then BarFill:TweenSize(UDim2.new(progress, 0, 1, 0), "Out", "Quad", 0.3, true) end
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogList.AbsoluteContentSize.Y)
    LogFrame.CanvasPosition = Vector2.new(0, LogList.AbsoluteContentSize.Y)
end

-- [[ CORE LOGIC ]] --
local function StartAutomation()
    AddLog("Initializing Engine...", Color3.new(1,1,0), 0.1)
    StatusLabel.Text = "ENGINE STATUS: RUNNING"
    StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 127)

    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then table.insert(remotes, v) end
        if #remotes % 500 == 0 then task.wait() end
    end

    AddLog("Safe-mode: Scanning " .. #remotes .. " targets", Color3.new(1,1,1), 0.5)

    for i, r in pairs(remotes) do
        if not isRunning then break end
        pcall(function() r:FireServer(tick()) end)
        if i % 5 == 0 then 
            task.wait(math.random(1, 3)/10) 
            BarFill.Size = UDim2.new(0.5 + ((i/#remotes) * 0.5), 0, 1, 0)
        end
    end

    if isRunning then
        AddLog("ALL CLEAR - PROCESS DONE", Color3.fromRGB(85, 255, 127), 1)
        StatusLabel.Text = "ENGINE STATUS: FINISHED"
    end
end

-- [[ INPUT EVENTS ]] --
MakeDraggable(IconButton)
MakeDraggable(Main)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    local targetRotation = Main.Visible and 90 or 0
    TweenService:Create(IconButton, TweenInfo.new(0.3), {Rotation = targetRotation}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    TweenService:Create(IconButton, TweenInfo.new(0.3), {Rotation = 0}):Play()
end)

SwitchDot.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        SwitchDot:TweenPosition(UDim2.new(0.55, 0, 0.5, -9), "Out", "Back", 0.3, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
        currentTask = task.spawn(StartAutomation)
    else
        isRunning = false
        if currentTask then task.cancel(currentTask) end
        SwitchDot:TweenPosition(UDim2.new(0.1, 0, 0.5, -9), "Out", "Back", 0.3, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        StatusLabel.Text = "ENGINE STATUS: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        AddLog("Emergency Stop Triggered", Color3.new(1,0.5,0), 0)
    end
end)

AddLog("Phantom UI Loaded. Click 'P' Icon to Start.", Color3.new(0.6,0.6,0.6))
