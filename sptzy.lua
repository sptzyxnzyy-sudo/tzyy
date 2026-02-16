-- [[ PHANTOM ULTIMATE v3: REWRITTEN & OPTIMIZED ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local isRunning = false
local currentTask = nil

-- Cleanup Old UI
if CoreGui:FindFirstChild("PhantomSwitch_V3") then 
    CoreGui.PhantomSwitch_V3:Destroy() 
end

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomSwitch_V3"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 380) 
Main.Position = UDim2.new(0.5, -150, 0.4, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Sederhana untuk mobile/PC

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127)
Stroke.Thickness = 1.5

-- [[ HEADER ]] --
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "SYSTEM: STANDBY"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- [[ TOGGLE SWITCH ]] --
local SwitchBG = Instance.new("Frame", Header)
SwitchBG.Size = UDim2.new(0, 50, 0, 24)
SwitchBG.Position = UDim2.new(0.8, -5, 0.5, -12)
SwitchBG.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

local SwitchDot = Instance.new("TextButton", SwitchBG)
SwitchDot.Size = UDim2.new(0, 18, 0, 18)
SwitchDot.Position = UDim2.new(0.1, 0, 0.5, -9)
SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
SwitchDot.Text = ""
SwitchDot.AutoButtonColor = false
Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

-- [[ PROGRESS BAR ]] --
local BarBG = Instance.new("Frame", Main)
BarBG.Size = UDim2.new(0.9, 0, 0, 4)
BarBG.Position = UDim2.new(0.05, 0, 0.16, 0)
BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
BarBG.BorderSizePixel = 0

local BarFill = Instance.new("Frame", BarBG)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
BarFill.BorderSizePixel = 0

-- [[ LOGGER ]] --
local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0.75, -10)
LogFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 2
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local LogList = Instance.new("UIListLayout", LogFrame)
LogList.Padding = Bold or UDim.new(0, 4)

local function AddLog(text, color, progress)
    local l = Instance.new("TextLabel", LogFrame)
    l.Size = UDim2.new(1, -10, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = " [>] " .. text
    l.TextColor3 = color or Color3.new(1,1,1)
    l.Font = Enum.Font.Code
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    
    if progress then
        BarFill:TweenSize(UDim2.new(progress, 0, 1, 0), "Out", "Quart", 0.4, true)
    end
    
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogList.AbsoluteContentSize.Y + 20)
    LogFrame.CanvasPosition = Vector2.new(0, LogList.AbsoluteContentSize.Y)
end

-- [[ CORE LOGIC ]] --
local function StartAutomation()
    AddLog("Initializing Engine...", Color3.fromRGB(255, 255, 100), 0.1)
    Title.Text = "SYSTEM: RUNNING"
    Title.TextColor3 = Color3.fromRGB(85, 255, 127)

    -- Spoofing Check
    task.wait(0.5)
    if not isRunning then return end
    
    AddLog("Checking HD Admin...", Color3.fromRGB(100, 200, 255), 0.3)
    local success, err = pcall(function()
        if _G.HDAdminMain then
            -- Note: Ini adalah logika spoofing visual/lokal
            _G.HDAdminMain.pd[lp].Rank = 5 
            AddLog("Rank Spoofed to Level 5", Color3.fromRGB(85, 255, 127))
        else
            AddLog("HD Admin not found, skipping...", Color3.fromRGB(150, 150, 150))
        end
    end)

    -- Remote Scanning
    task.wait(0.5)
    if not isRunning then return end
    AddLog("Scanning for Vulnerable Remotes...", Color3.new(1,1,1), 0.5)
    
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, v)
        end
        -- Batasi scan agar tidak crash jika game terlalu besar
        if _ % 500 == 0 then task.wait() end 
    end

    AddLog("Found " .. #remotes .. " Remotes. Executing...", Color3.fromRGB(255, 100, 100), 0.7)

    -- Payload Execution
    for i, remote in pairs(remotes) do
        if not isRunning then break end
        
        pcall(function()
            -- Payload Example (Sesuaikan dengan kebutuhan)
            remote:FireServer("Phantom_V3_Heartbeat")
        end)
        
        if i % 10 == 0 then
            task.wait(0.05)
            local prog = 0.7 + ((i/#remotes) * 0.3)
            BarFill.Size = UDim2.new(prog, 0, 1, 0)
        end
    end

    if isRunning then
        AddLog("ALL PROCESSES COMPLETED", Color3.fromRGB(85, 255, 127), 1)
        Title.Text = "SYSTEM: FINISHED"
    end
end

-- [[ TOGGLE BUTTON FUNCTION ]] --
SwitchDot.MouseButton1Click:Connect(function()
    if not isRunning then
        -- TURN ON
        isRunning = true
        SwitchDot:TweenPosition(UDim2.new(0.55, 0, 0.5, -9), "Out", "Back", 0.3, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
        currentTask = task.spawn(StartAutomation)
    else
        -- TURN OFF
        isRunning = false
        if currentTask then task.cancel(currentTask) end
        
        SwitchDot:TweenPosition(UDim2.new(0.1, 0, 0.5, -9), "Out", "Back", 0.3, true)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        
        Title.Text = "SYSTEM: STANDBY"
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        BarFill:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.3, true)
        AddLog("Engine Shutdown Safely", Color3.fromRGB(255, 150, 50), 0)
    end
end)

AddLog("Phantom Engine v3 Ready.", Color3.fromRGB(150, 150, 150))
