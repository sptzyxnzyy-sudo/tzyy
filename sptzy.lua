-- [[ PHANTOM ULTIMATE v3: AUTO-ENGINE WITH SWITCH ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local JointService = game:GetService("JointsService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local isRunning = false
local currentTask = nil

-- Cleanup
if CoreGui:FindFirstChild("PhantomSwitch_V3") then CoreGui.PhantomSwitch_V3:Destroy() end

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomSwitch_V3"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 380) 
Main.Position = UDim2.new(0.5, -150, 0.4, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127)

-- [[ HEADER & SWITCH CONTAINER ]] --
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

-- [[ TOGGLE SWITCH (KANAN KIRI) ]] --
local SwitchBG = Instance.new("Frame", Header)
SwitchBG.Size = UDim2.new(0, 60, 0, 25)
SwitchBG.Position = UDim2.new(0.75, 0, 0.5, -12)
SwitchBG.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

local SwitchDot = Instance.new("TextButton", SwitchBG)
SwitchDot.Size = UDim2.new(0, 21, 0, 21)
SwitchDot.Position = UDim2.new(0.05, 0, 0.5, -10)
SwitchDot.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Default Red (OFF)
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

-- [[ LOGGER ]] --
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

-- [[ AUTOMATION LOGIC ]] --
local function StartAutomation()
    isRunning = true
    AddLog("Initializing Engine...", Color3.new(1,1,0), 0.1)
    Title.Text = "SYSTEM: RUNNING"
    Title.TextColor3 = Color3.fromRGB(85, 255, 127)

    -- Spoofing
    if not isRunning then return end
    AddLog("Bypassing HD Admin...", Color3.new(1,1,0), 0.3)
    pcall(function()
        if _G.HDAdminMain then
            _G.HDAdminMain.pd[lp].Rank = 5
            AddLog("Rank Spoofed (Level 5)", Color3.fromRGB(85, 255, 127))
        end
    end)
    task.wait(0.5)

    -- Scanning
    if not isRunning then return end
    AddLog("Scanning Remotes...", Color3.new(1,1,1), 0.6)
    local targets = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then table.insert(targets, v) end
    end
    for _, loc in pairs({JointService, game:GetService("LogService")}) do
        pcall(function()
            for _, v in pairs(loc:GetDescendants()) do if v:IsA("RemoteEvent") then table.insert(targets, v) end end
        end)
    end

    -- Injecting
    if not isRunning then return end
    AddLog("Found " .. #targets .. " Remotes. Injecting...", Color3.new(1,0,0), 0.8)
    local payload = "require(5021815801):Fire('" .. lp.Name .. "')"
    
    for i, v in pairs(targets) do
        if not isRunning then break end
        pcall(function() v:FireServer(payload); v:FireServer(true) end)
        if i % 10 == 0 then task.wait(0.1) end
    end

    if isRunning then
        AddLog("ALL PROCESSES FINISHED", Color3.fromRGB(85, 255, 127), 1)
        Title.Text = "SYSTEM: COMPLETED"
    end
end

-- [[ SWITCH TOGGLE LOGIC ]] --
SwitchDot.MouseButton1Click:Connect(function()
    if not isRunning then
        -- TURN ON (Pindah ke Kanan)
        isRunning = true
        SwitchDot:TweenPosition(UDim2.new(0.6, 0, 0.5, -10), "Out", "Back", 0.3, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
        currentTask = task.spawn(StartAutomation)
    else
        -- TURN OFF (Pindah ke Kiri)
        isRunning = false
        if currentTask then task.cancel(currentTask) end
        SwitchDot:TweenPosition(UDim2.new(0.05, 0, 0.5, -10), "Out", "Back", 0.3, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        Title.Text = "SYSTEM: STANDBY"
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        BarFill.Size = UDim2.new(0, 0, 1, 0)
        AddLog("Engine Stopped by User", Color3.new(1,0,0), 0)
    end
end)

-- Drag
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and inp.UserInputType == Enum.UserInputType.MouseMovement then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then s = false end end)
end
drag(Main)

AddLog("Phantom Engine Ready. Use switch to start.", Color3.new(0.7,0.7,0.7))
