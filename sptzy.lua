-- [[ PHANTOM SQUARE: ULTRA TURBO & ANTI-FRAME ]] --
-- Integrated with Ultra Blatant Auto Fishing Module

local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = game:GetService("Players").LocalPlayer

-- [[ ULTRA BLATANT MODULE INITIALIZATION ]] --
local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RF_ChargeFishingRod = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_RequestMinigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_CancelFishingInputs = netFolder:WaitForChild("RF/CancelFishingInputs")
local RF_UpdateAutoFishingState = netFolder:WaitForChild("RF/UpdateAutoFishingState")
local RE_FishingCompleted = netFolder:WaitForChild("RE/FishingCompleted")
local RE_MinigameChanged = netFolder:WaitForChild("RE/FishingMinigameChanged")

local isBrutal = false
local lastFish = "None"
local lastEventTime = 0

local Settings = {
    CompleteDelay = 0.73,
    CancelDelay = 0.3,
    ReCastDelay = 0.01
}

local FishingState = {
    lastCompleteTime = 0,
    completeCooldown = 0.4
}

-- [[ CORE UTILITIES ]] --
local function safeFire(func)
    task.spawn(function() pcall(func) end)
end

local function protectedComplete()
    local now = tick()
    if now - FishingState.lastCompleteTime < FishingState.completeCooldown then return false end
    FishingState.lastCompleteTime = now
    safeFire(function() RE_FishingCompleted:FireServer() end)
    return true
end

local function performCast()
    local now = tick()
    safeFire(function() RF_ChargeFishingRod:InvokeServer({[1] = now}) end)
    safeFire(function() RF_RequestMinigame:InvokeServer(1, 0, now) end)
end

-- [[ MAIN FISHING LOOP ]] --
local function startUltraLoop()
    while isBrutal do
        performCast()
        task.wait(Settings.CompleteDelay)
        
        if isBrutal then protectedComplete() end
        task.wait(Settings.CancelDelay)
        
        if isBrutal then
            safeFire(function() RF_CancelFishingInputs:InvokeServer() end)
        end
        task.wait(Settings.ReCastDelay)
    end
end

-- Listener untuk perubahan minigame (Back-up)
RE_MinigameChanged.OnClientEvent:Connect(function()
    if not isBrutal then return end
    local now = tick()
    if now - lastEventTime < 0.2 or now - FishingState.lastCompleteTime < 0.3 then return end
    lastEventTime = now
    
    task.spawn(function()
        task.wait(Settings.CompleteDelay)
        if protectedComplete() then
            task.wait(Settings.CancelDelay)
            safeFire(function() RF_CancelFishingInputs:InvokeServer() end)
        end
    end)
end)

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomUltraV2"
ScreenGui.ResetOnSpawn = false

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenBtn.Text = "⚡"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 255, 255)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 180) 
Main.Position = UDim2.new(0.5, -90, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 255)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 60)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.Code
Status.TextSize = 8
Status.Text = "SYSTEM INITIALIZED"

task.spawn(function()
    while task.wait(0.5) do
        local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Status.Text = string.format("PING: %dms\nFISH: %s\nMODE: %s", 
            p, lastFish, (isBrutal and "ULTRA-BLATANT" or "IDLE"))
    end
end)

-- Detector Log Ikan
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            for _, v in pairs(lp.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and (v.Text:find("mendapatkan") or v.Text:find("Shiny")) then
                    lastFish = v.Text:gsub("Anda mendapatkan:", ""):gsub("<[^>]*>", "")
                end
            end
        end)
    end
end)

local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0.8, 0, 0, 35)
ActionBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ActionBtn.Text = "START TURBO"
ActionBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", ActionBtn)

ActionBtn.MouseButton1Click:Connect(function()
    isBrutal = not isBrutal
    if isBrutal then
        ActionBtn.Text = "TURBO ON"
        ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
        safeFire(function() RF_UpdateAutoFishingState:InvokeServer(true) end)
        task.spawn(startUltraLoop)
    else
        ActionBtn.Text = "START TURBO"
        ActionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        safeFire(function() RF_UpdateAutoFishingState:InvokeServer(false) end) -- Nonaktifkan di server
        safeFire(function() RF_CancelFishingInputs:InvokeServer() end)
    end
end)

-- [[ DRAG SUPPORT ]] --
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then s = false end end)
end
drag(Main); drag(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
