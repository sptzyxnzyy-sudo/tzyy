-- [[ PHANTOM SQUARE: ULTRA BLATANT FINAL REBORN ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = game:GetService("Players").LocalPlayer

-- [[ PRE-CHECK ]] --
local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RF_UpdateAutoFishingState = netFolder:WaitForChild("RF/UpdateAutoFishingState")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")

-- [[ SETTINGS ]] --
local isBrutal = false
local lastFish = "None"
local FishingSettings = {
    CompleteDelay = 0.73,
    CancelDelay = 0.3,
    ReCastDelay = 0.001
}
local FishingState = {
    lastCompleteTime = 0,
    completeCooldown = 0.4
}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomUltraV2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ TOGGLE ICON (⚡) ]] --
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "MainIcon"
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenBtn.Text = "⚡"
OpenBtn.TextSize = 25
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
OpenBtn.ZIndex = 10

local IconCorner = Instance.new("UICorner", OpenBtn)
IconCorner.CornerRadius = UDim.new(1, 0)

local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- [[ MAIN PANEL ]] --
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 200, 0, 260)
Main.Position = UDim2.new(0.5, -100, 0.4, -130)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Visible = false
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 1.5

-- [[ STATUS MONITOR ]] --
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 60)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.Code
Status.TextSize = 9
Status.Text = "SYSTEM INITIALIZING..."

-- [[ INPUT COMPONENT FUNCTION ]] --
local function CreateInputField(name, default, yPos)
    local container = Instance.new("Frame", Main)
    container.Size = UDim2.new(0.9, 0, 0, 35)
    container.Position = UDim2.new(0.05, 0, 0, yPos)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Code
    label.TextSize = 10

    local box = Instance.new("TextBox", container)
    box.Size = UDim2.new(0.35, 0, 0.7, 0)
    box.Position = UDim2.new(0.65, 0, 0.15, 0)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    box.TextColor3 = Color3.fromRGB(0, 255, 255)
    box.Text = tostring(default)
    box.Font = Enum.Font.Code
    box.TextSize = 11
    Instance.new("UICorner", box)
    Instance.new("UIStroke", box).Color = Color3.fromRGB(0, 255, 255)
    
    return box
end

local InpComp = CreateInputField("COMPLETE DELAY:", FishingSettings.CompleteDelay, 70)
local InpCanc = CreateInputField("CANCEL DELAY:", FishingSettings.CancelDelay, 110)
local InpReca = CreateInputField("RECAST DELAY:", FishingSettings.ReCastDelay, 150)

-- Update Settings on Input
InpComp.FocusLost:Connect(function() FishingSettings.CompleteDelay = tonumber(InpComp.Text) or 0.73 end)
InpCanc.FocusLost:Connect(function() FishingSettings.CancelDelay = tonumber(InpCanc.Text) or 0.3 end)
InpReca.FocusLost:Connect(function() FishingSettings.ReCastDelay = tonumber(InpReca.Text) or 0.001 end)

-- [[ ACTION BUTTON ]] --
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0.9, 0, 0, 35)
ActionBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ActionBtn.Text = "START AUTO FISH"
ActionBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ActionBtn.Font = Enum.Font.GothamBold
ActionBtn.TextSize = 12
Instance.new("UICorner", ActionBtn)
local ActionStroke = Instance.new("UIStroke", ActionBtn)
ActionStroke.Color = Color3.fromRGB(0, 255, 255)

-- [[ CORE LOGIC ]] --
local function safeFire(func) task.spawn(function() pcall(func) end) end

local function protectedComplete()
    local now = tick()
    if now - FishingState.lastCompleteTime < FishingState.completeCooldown then return false end
    FishingState.lastCompleteTime = now
    safeFire(function() RE_FishingCompleted:FireServer() end)
    return true
end

-- Main Loop
task.spawn(function()
    while true do
        if isBrutal then
            local now = tick()
            -- Cast & Start Minigame
            safeFire(function() RF_ChargeFishingRod:InvokeServer({[1] = now}) end)
            safeFire(function() RF_RequestMinigame:InvokeServer(1, 0, now) end)
            
            task.wait(FishingSettings.CompleteDelay)
            if isBrutal then protectedComplete() end
            
            task.wait(FishingSettings.CancelDelay)
            if isBrutal then safeFire(function() RF_CancelFishingInputs:InvokeServer() end) end
            
            task.wait(FishingSettings.ReCastDelay)
        else
            task.wait(0.5)
        end
    end
end)

-- Button Toggle
ActionBtn.MouseButton1Click:Connect(function()
    isBrutal = not isBrutal
    ActionBtn.Text = isBrutal and "STATUS: RUNNING" or "START AUTO FISH"
    ActionBtn.BackgroundColor3 = isBrutal and Color3.fromRGB(0, 100, 100) or Color3.fromRGB(20, 20, 30)
    safeFire(function() RF_UpdateAutoFishingState:InvokeServer(isBrutal) end)
end)

-- Toggle Menu
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Status Loop
task.spawn(function()
    while task.wait(0.5) do
        local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Status.Text = string.format("PING: %dms\nMODE: %s\nSYSTEM: SECURED", 
            p, (isBrutal and "ACTIVE" or "IDLE"))
    end
end)

-- [[ DRAG SYSTEM ]] --
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
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
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(Main)
makeDraggable(OpenBtn)
