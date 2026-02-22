-- [[ PHANTOM SQUARE V2: FINAL VERSION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = game:GetService("Players").LocalPlayer

-- [[ NETWORK CACHING ]] --
local netFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local RF_Charge = netFolder:WaitForChild("RF/ChargeFishingRod")
local RF_Minigame = netFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_Cancel = netFolder:WaitForChild("RF/CancelFishingInputs")
local RE_Complete = netFolder:WaitForChild("RE/FishingCompleted")

-- Global States
local currentMode = "NONE" -- NONE, LEGIT, BLATANT
local lastFish = "None"

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomSquare_Final"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 240) 
Main.Position = UDim2.new(0.5, -100, 0.4, -120)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Main.Visible = false
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 1.5

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "PHANTOM SQUARE"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -20, 0, 50)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- [[ LOGIC: HELPER FUNCTIONS ]] --
local function safeFire(func)
    task.spawn(function() pcall(func) end)
end

-- [[ LOGIC: MODES ]] --
-- 1. LEGIT MODE (Spam Clicker)
task.spawn(function()
    while task.wait(0.1) do
        if currentMode == "LEGIT" then
            pcall(function()
                -- Mengirim sinyal cast/klik standar
                RF_Charge:InvokeServer({[1] = tick()})
                task.wait(0.2)
                RF_Minigame:InvokeServer(1, 0, tick())
            end)
        end
    end
end)

-- 2. BLATANT MODE (Instant Bypass)
local function runBlatant()
    while currentMode == "BLATANT" do
        local now = tick()
        safeFire(function()
            RF_Charge:InvokeServer({[1] = now})
            RF_Minigame:InvokeServer(1, 0, now)
            task.wait(0.75) -- Delay minimal untuk menghindari kick
            RE_Complete:FireServer()
            task.wait(0.25)
            RF_Cancel:InvokeServer()
        end)
        task.wait(0.1)
    end
end

-- [[ UI BUTTON SYSTEM ]] --
local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = color
    stroke.Thickness = 1
    return btn
end

local LegitBtn = createBtn("LEGIT MODE", UDim2.new(0.075, 0, 0.42, 0), Color3.fromRGB(0, 255, 127))
local BlatantBtn = createBtn("BLATANT MODE", UDim2.new(0.075, 0, 0.58, 0), Color3.fromRGB(255, 60, 60))
local StopBtn = createBtn("STOP SYSTEMS", UDim2.new(0.075, 0, 0.74, 0), Color3.fromRGB(255, 255, 255))

LegitBtn.MouseButton1Click:Connect(function()
    currentMode = "LEGIT"
    LegitBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    BlatantBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
end)

BlatantBtn.MouseButton1Click:Connect(function()
    currentMode = "BLATANT"
    BlatantBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
    LegitBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    task.spawn(runBlatant)
end)

StopBtn.MouseButton1Click:Connect(function()
    currentMode = "NONE"
    LegitBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    BlatantBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    safeFire(function() RF_Cancel:InvokeServer() end)
end)

-- [[ INFO MONITOR ]] --
task.spawn(function()
    while task.wait(0.5) do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        StatusLabel.Text = string.format("PING : %dms\nLAST : %s\nMODE : %s", ping, lastFish:sub(1,15), currentMode)
        
        -- Detect Fish Name from GUI
        pcall(function()
            for _, v in pairs(lp.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and (v.Text:find("mendapatkan") or v.Text:find("Caught")) then
                    lastFish = v.Text:gsub("<[^>]*>", ""):gsub("Anda mendapatkan:", "")
                end
            end
        end)
    end
end)

-- [[ DRAGGABLE TOGGLE ]] --
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 45, 0, 45)
Toggle.Position = UDim2.new(0, 20, 0.5, -22)
Toggle.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Toggle.Text = "⚡"
Toggle.TextColor3 = Color3.fromRGB(0, 255, 255)
Toggle.TextSize = 20
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Toggle).Color = Color3.fromRGB(0, 255, 255)

Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

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
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

makeDraggable(Main); makeDraggable(Toggle)
