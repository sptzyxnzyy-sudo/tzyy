-- [[ PHANTOM SQUARE: ULTRA BLATANT WITH INPUTS ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = game:GetService("Players").LocalPlayer

-- [[ DATA INITIALIZATION ]] --
local isBrutal = false
local lastFish = "None"

-- Network initialization
local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RF_UpdateAutoFishingState = netFolder:WaitForChild("RF/UpdateAutoFishingState")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")

local FishingSettings = {
    CompleteDelay = 0.73,
    CancelDelay = 0.3,
    ReCastDelay = 0.001
}

local FishingState = {
    lastCompleteTime = 0,
    completeCooldown = 0.4
}

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomUltra"
ScreenGui.ResetOnSpawn = false

-- [[ DRAGGABLE ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenBtn.Text = "⚡"
OpenBtn.TextSize = 25
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- [[ SQUARE MAIN FRAME ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 240) -- Ukuran ditambah untuk slot input
Main.Position = UDim2.new(0.5, -90, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 255)

-- [[ STATUS LABEL ]] --
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 50)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.Code
Status.TextSize = 8
Status.Text = "SYSTEM OPTIMIZED"

-- [[ INPUT BOX CREATOR ]] --
local function CreateInput(name, default, pos)
    local box = Instance.new("TextBox", Main)
    box.Size = UDim2.new(0.8, 0, 0, 25)
    box.Position = UDim2.new(0.1, 0, 0, pos)
    box.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    box.TextColor3 = Color3.fromRGB(0, 255, 255)
    box.Text = tostring(default)
    box.PlaceholderText = name
    box.Font = Enum.Font.Code
    box.TextSize = 10
    Instance.new("UICorner", box)
    Instance.new("UIStroke", box).Color = Color3.fromRGB(40, 40, 60)
    
    local label = Instance.new("TextLabel", box)
    label.Size = UDim2.new(1, 0, 0, 15)
    label.Position = UDim2.new(0, 0, 0, -15)
    label.BackgroundTransparency = 1
    label.Text = name:upper()
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.Font = Enum.Font.Code
    label.TextSize = 8
    
    return box
end

local InpComplete = CreateInput("Complete Delay", FishingSettings.CompleteDelay, 75)
local InpCancel = CreateInput("Cancel Delay", FishingSettings.CancelDelay, 115)
local InpRecast = CreateInput("Recast Delay", FishingSettings.ReCastDelay, 155)

-- Listener for inputs
InpComplete.FocusLost:Connect(function() FishingSettings.CompleteDelay = tonumber(InpComplete.Text) or 0.73 end)
InpCancel.FocusLost:Connect(function() FishingSettings.CancelDelay = tonumber(InpCancel.Text) or 0.3 end)
InpRecast.FocusLost:Connect(function() FishingSettings.ReCastDelay = tonumber(InpRecast.Text) or 0.001 end)

-- [[ ENGINE LOGIC ]] --
local function safeFire(func) task.spawn(function() pcall(func) end) end

local function protectedComplete()
    local now = tick()
    if now - FishingState.lastCompleteTime < FishingState.completeCooldown then return false end
    FishingState.lastCompleteTime = now
    safeFire(function() RE_FishingCompleted:FireServer() end)
    return true
end

task.spawn(function()
    while true do
        if isBrutal then
            local now = tick()
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

-- [[ START BUTTON ]] --
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0.8, 0, 0, 30)
ActionBtn.Position = UDim2.new(0.1, 0, 0.85, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ActionBtn.Text = "START BLATANT"
ActionBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)
local BtnStroke = Instance.new("UIStroke", ActionBtn)
BtnStroke.Color = Color3.fromRGB(0, 255, 255)

ActionBtn.MouseButton1Click:Connect(function()
    isBrutal = not isBrutal
    ActionBtn.Text = isBrutal and "BLATANT ON" or "START BLATANT"
    ActionBtn.BackgroundColor3 = isBrutal and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(20, 20, 30)
    safeFire(function() RF_UpdateAutoFishingState:InvokeServer(isBrutal) end)
end)

-- Status Update Loop
task.spawn(function()
    while task.wait(0.5) do
        local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Status.Text = string.format("PING: %dms\nFISH: %s\nMODE: %s", 
            p, lastFish, (isBrutal and "ACTIVE" or "IDLE"))
    end
end)

-- [[ DRAG ]] --
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then s = false end end)
end
drag(Main); drag(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
