-- [[ PHANTOM AUTO-FISH: PRECISION HYPER-TAP ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local isFishing = false
local fishCount = 0
local speedVal = 0.5 -- Delay Lempar
local tapSpeed = 0.05 -- Delay Tap (Hyper)

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomPrecisionFish"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 450)
Main.Position = UDim2.new(0.5, -190, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 200) -- Cyber Mint
Stroke.Thickness = 2

-- [[ TERMINAL MONITOR ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.9, 0, 0, 130)
Monitor.Position = UDim2.new(0.05, 0, 0.05, 0)
Monitor.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
Instance.new("UICorner", Monitor)

local ConsoleTxt = Instance.new("TextLabel", Monitor)
ConsoleTxt.Size = UDim2.new(1, -20, 1, -20)
ConsoleTxt.Position = UDim2.new(0, 10, 0, 10)
ConsoleTxt.BackgroundTransparency = 1
ConsoleTxt.Text = "> SYSTEM_CALIBRATED\n> WAITING_FOR_TOGGLE...\n> STATUS: IDLE"
ConsoleTxt.TextColor3 = Color3.fromRGB(0, 255, 200)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 10
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left

-- [[ SLIDER CREATOR FUNCTION ]] --
local function createSlider(name, pos, defaultPercent)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0.9, 0, 0, 20)
    label.Position = pos
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9
    label.BackgroundTransparency = 1

    local back = Instance.new("Frame", Main)
    back.Size = UDim2.new(0.85, 0, 0, 6)
    back.Position = pos + UDim2.new(0, 0, 0, 25)
    back.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", back)

    local fill = Instance.new("Frame", back)
    fill.Size = UDim2.new(defaultPercent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    Instance.new("UICorner", fill)

    local btn = Instance.new("TextButton", fill)
    btn.Size = UDim2.new(0, 18, 0, 18)
    btn.Position = UDim2.new(1, -9, 0.5, -9)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    Instance.new("UICorner", btn)
    
    return back, fill, btn
end

-- Create Sliders
local cBack, cFill, cBtn = createSlider("CAST DELAY (LEFT: 2s | RIGHT: 0.1s)", UDim2.new(0.075, 0, 0.38, 0), 0.7)
local tBack, tFill, tBtn = createSlider("TAP SPEED (LEFT: 0.5s | RIGHT: 0.01s)", UDim2.new(0.075, 0, 0.52, 0), 0.9)

-- Slider Logic
local function connectSlider(back, fill, btn, min, max, isInverse, callback)
    local active = false
    btn.MouseButton1Down:Connect(function() active = true end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then active = false end end)
    
    RunService.RenderStepped:Connect(function()
        if active then
            local mousePos = UserInputService:GetMouseLocation().X
            local relPos = math.clamp((mousePos - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(relPos, 0, 1, 0)
            
            local val
            if isInverse then
                val = max - (relPos * (max - min))
            else
                val = min + (relPos * (max - min))
            end
            callback(val)
        end
    end)
end

-- Casting: Kanan lebih cepat (0.1s), Kiri lebih lambat (2.0s)
connectSlider(cBack, cFill, cBtn, 0.1, 2.0, true, function(v) speedVal = v end)
-- Tapping: Kanan lebih kencang (0.01s), Kiri normal (0.5s)
connectSlider(tBack, tFill, tBtn, 0.01, 0.5, true, function(v) tapSpeed = v end)

-- [[ TOGGLE SWITCH ]] --
local ToggleBg = Instance.new("Frame", Main)
ToggleBg.Size = UDim2.new(0, 80, 0, 40)
ToggleBg.Position = UDim2.new(0.5, -40, 0.75, 0)
ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local ToggleCircle = Instance.new("TextButton", ToggleBg)
ToggleCircle.Size = UDim2.new(0, 32, 0, 32)
ToggleCircle.Position = UDim2.new(0, 4, 0.5, -16)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
ToggleCircle.Text = ""
Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

-- [[ ENGINE: PERSISTENT BACKGROUND FISHING ]] --
local function startFishing()
    local castRemotes = {}
    local reelRemotes = {}
    
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local n = v.Name:lower()
                if n:find("fish") or n:find("cast") or n:find("throw") then table.insert(castRemotes, v) end
                if n:find("reel") or n:find("pull") or n:find("tap") or n:find("click") then table.insert(reelRemotes, v) end
            end
        end)
    end

    task.spawn(function()
        while isFishing do
            pcall(function()
                -- Step 1: Cast
                for _, r in pairs(castRemotes) do r:FireServer() end
                
                -- Step 2: Rapid Tapping (Simulate Reeling)
                local start = tick()
                while tick() - start < 1.2 and isFishing do 
                    for _, r in pairs(reelRemotes) do
                        if r:IsA("RemoteEvent") then r:FireServer(true)
                        else task.spawn(function() r:InvokeServer() end) end
                    end
                    task.wait(tapSpeed)
                end
                fishCount = fishCount + 1
            end)
            task.wait(speedVal)
        end
    end)
end

ToggleCircle.MouseButton1Click:Connect(function()
    isFishing = not isFishing
    if isFishing then
        ToggleCircle:TweenPosition(UDim2.new(1, -36, 0.5, -16), "Out", "Quart", 0.3)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        startFishing()
    else
        ToggleCircle:TweenPosition(UDim2.new(0, 4, 0.5, -16), "Out", "Quart", 0.3)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end
end)

-- [[ STATUS MONITOR ]] --
task.spawn(function()
    local chars = {"▖", "▘", "▝", "▗"}
    local i = 0
    while true do
        if isFishing then
            i = i + 1
            ConsoleTxt.Text = string.format(
                "> HYPER_FARMING: ACTIVE %s\n> CAST_DELAY: %.2fs\n> TAP_INTERVAL: %.3fs\n> TOTAL_CAUGHT: %d\n> BG_MODE: ENABLED",
                chars[i % #chars + 1], speedVal, tapSpeed, fishCount
            )
        else
            ConsoleTxt.Text = "> PHANTOM_OS: STANDBY\n> MONITORING: READY\n> STATUS: IDLE"
        end
        task.wait(0.1)
    end
end)

-- [[ ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60) Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(0, 20, 20) Icon.Image = "rbxassetid://15264870535"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", Icon).Color = Color3.fromRGB(0, 255, 200)

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
