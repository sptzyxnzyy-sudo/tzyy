-- [[ PHANTOM ULTIMATE v3: FINAL STABLE VERSION ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local isRunning = false
local currentTask = nil

-- Cleanup GUI lama agar tidak duplikat
if CoreGui:FindFirstChild("PhantomFinal_V3") then 
    CoreGui.PhantomFinal_V3:Destroy() 
end

-- [[ UI ROOT ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomFinal_V3"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- Mengabaikan bar atas roblox agar posisi lebih akurat

-- [[ FLOATING ICON SYSTEM ]] --
local IconButton = Instance.new("Frame", ScreenGui)
IconButton.Name = "IconContainer"
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IconButton.Active = true
IconButton.ZIndex = 100

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
IconText.TextSize = 26
IconText.BackgroundTransparency = 1

local OpenButton = Instance.new("TextButton", IconButton)
OpenButton.Size = UDim2.new(1, 0, 1, 0)
OpenButton.BackgroundTransparency = 1
OpenButton.Text = ""

-- [[ MAIN MENU SYSTEM ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 310, 0, 380)
Main.Position = UDim2.new(0.5, -155, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.Visible = false 
Main.Active = true
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(85, 255, 127)
MainStroke.Thickness = 1.5

-- [[ TOP BAR / DRAG AREA ]] --
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "PHANTOM ULTIMATE V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.9, 0, 0.5, -15)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.BackgroundTransparency = 1

-- [[ ENGINE CONTROL ]] --
local ControlBox = Instance.new("Frame", Main)
ControlBox.Size = UDim2.new(0.9, 0, 0, 60)
ControlBox.Position = UDim2.new(0.05, 0, 0.15, 0)
ControlBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", ControlBox)

local StatusTxt = Instance.new("TextLabel", ControlBox)
StatusTxt.Size = UDim2.new(0.6, 0, 1, 0)
StatusTxt.Position = UDim2.new(0.05, 0, 0, 0)
StatusTxt.Text = "SYSTEM: STANDBY"
StatusTxt.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusTxt.Font = Enum.Font.GothamBold
StatusTxt.TextSize = 11
StatusTxt.TextXAlignment = Enum.TextXAlignment.Left
StatusTxt.BackgroundTransparency = 1

local SwitchBG = Instance.new("Frame", ControlBox)
SwitchBG.Size = UDim2.new(0, 55, 0, 26)
SwitchBG.Position = UDim2.new(0.78, 0, 0.5, -13)
SwitchBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

local SwitchDot = Instance.new("TextButton", SwitchBG)
SwitchDot.Size = UDim2.new(0, 20, 0, 20)
SwitchDot.Position = UDim2.new(0.1, 0, 0.5, -10)
SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
SwitchDot.Text = ""
Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

-- [[ LOGS & PROGRESS ]] --
local BarBG = Instance.new("Frame", Main)
BarBG.Size = UDim2.new(0.9, 0, 0, 4)
BarBG.Position = UDim2.new(0.05, 0, 0.33, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
local BarFill = Instance.new("Frame", BarBG)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
BarFill.BorderSizePixel = 0

local LogContainer = Instance.new("ScrollingFrame", Main)
LogContainer.Size = UDim2.new(0.9, 0, 0.6, 0)
LogContainer.Position = UDim2.new(0.05, 0, 0.37, 0)
LogContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
LogContainer.BorderSizePixel = 0
LogContainer.ScrollBarThickness = 2
local LogList = Instance.new("UIListLayout", LogContainer)
LogList.Padding = UDim.new(0, 3)

-- [[ DRAG & SLIDE LOGIC ]] --
local function EnableDrag(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function AddLog(msg, col, prog)
    local l = Instance.new("TextLabel", LogContainer)
    l.Size = UDim2.new(1, -10, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = " [SYSTEM] " .. msg
    l.TextColor3 = col or Color3.new(1,1,1)
    l.Font = Enum.Font.Code
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    if prog then BarFill:TweenSize(UDim2.new(prog, 0, 1, 0), "Out", "Quad", 0.3, true) end
    LogContainer.CanvasSize = UDim2.new(0, 0, 0, LogList.AbsoluteContentSize.Y)
    LogContainer.CanvasPosition = Vector2.new(0, LogList.AbsoluteContentSize.Y)
end

-- [[ AUTOMATION WITH ANTI-DETECTION ]] --
local function RunEngine()
    isRunning = true
    StatusTxt.Text = "SYSTEM: ACTIVE"
    StatusTxt.TextColor3 = Color3.fromRGB(85, 255, 127)
    AddLog("Scanning game structure...", Color3.new(1,1,0), 0.1)

    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then table.insert(remotes, v) end
        if #remotes % 400 == 0 then task.wait() end
    end

    AddLog("Found " .. #remotes .. " targets. Injecting...", Color3.new(1,1,1), 0.4)

    for i, remote in pairs(remotes) do
        if not isRunning then break end
        
        pcall(function()
            -- Payload aman (FireServer dengan timestamp)
            remote:FireServer(tick()) 
        end)

        -- Anti-Spam Check
        if i % 4 == 0 then 
            task.wait(math.random(15, 35)/100) -- Jeda acak 0.15s - 0.35s
            BarFill.Size = UDim2.new(0.4 + ((i/#remotes) * 0.6), 0, 1, 0)
        end
    end

    if isRunning then
        AddLog("SEQUENCE COMPLETED SUCCESSFULLY", Color3.fromRGB(85, 255, 127), 1)
        StatusTxt.Text = "SYSTEM: COMPLETED"
    end
end

-- [[ INTERACTION ]] --
EnableDrag(IconButton)
EnableDrag(Main)

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main:TweenSize(UDim2.new(0, 310, 0, 380), "Out", "Back", 0.3, true)
        TweenService:Create(IconStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(255, 255, 255)}):Play()
    else
        TweenService:Create(IconStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(85, 255, 127)}):Play()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    TweenService:Create(IconStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(85, 255, 127)}):Play()
end)

SwitchDot.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        SwitchDot:TweenPosition(UDim2.new(0.6, 0, 0.5, -10), "Out", "Back", 0.3, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
        currentTask = task.spawn(RunEngine)
    else
        isRunning = false
        if currentTask then task.cancel(currentTask) end
        SwitchDot:TweenPosition(UDim2.new(0.1, 0, 0.5, -10), "Out", "Back", 0.3, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        StatusTxt.Text = "SYSTEM: STANDBY"
        StatusTxt.TextColor3 = Color3.fromRGB(150, 150, 150)
        BarFill:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.3, true)
        AddLog("Process stopped by user.", Color3.new(1,0.4,0.4))
    end
end)

AddLog("Phantom UI Ready. Drag 'P' to move icon.", Color3.fromRGB(150,150,150))
