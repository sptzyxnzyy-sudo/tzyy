-- [[ PHANTOM AUTO-FISH: BACKGROUND PERSISTENCE EDITION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local isFishing = false
local fishCount = 0
local speedVal = 0.5 

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomAutoFishBackground"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 420)
Main.Position = UDim2.new(0.5, -190, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 150)
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
ConsoleTxt.Text = "> SYSTEM_ONLINE\n> BACKGROUND_MODE: SUPPORTED\n> STATUS: STANDBY"
ConsoleTxt.TextColor3 = Color3.fromRGB(0, 255, 150)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 10
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left

-- [[ SLIDER SYSTEM ]] --
local SliderLabel = Instance.new("TextLabel", Main)
SliderLabel.Size = UDim2.new(0.9, 0, 0, 20)
SliderLabel.Position = UDim2.new(0.05, 0, 0.42, 0)
SliderLabel.Text = "ADJUST SPEED (LEFT = SLOW | RIGHT = FAST)"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.Font = Enum.Font.GothamBold
SliderLabel.TextSize = 10
SliderLabel.BackgroundTransparency = 1

local SliderBack = Instance.new("Frame", Main)
SliderBack.Size = UDim2.new(0.85, 0, 0, 6)
SliderBack.Position = UDim2.new(0.075, 0, 0.5, 0)
SliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", SliderBack)

local SliderFill = Instance.new("Frame", SliderBack)
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", SliderFill)

local SliderBtn = Instance.new("TextButton", SliderFill)
SliderBtn.Size = UDim2.new(0, 16, 0, 16)
SliderBtn.Position = UDim2.new(1, -8, 0.5, -8)
SliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderBtn.Text = ""
Instance.new("UICorner", SliderBtn)

local dragging = false
SliderBtn.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        speedVal = 1 - (pos * 0.95)
    end
end)

-- [[ TOGGLE SWITCH ]] --
local ToggleBg = Instance.new("Frame", Main)
ToggleBg.Size = UDim2.new(0, 80, 0, 40)
ToggleBg.Position = UDim2.new(0.5, -40, 0.65, 0)
ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local ToggleCircle = Instance.new("TextButton", ToggleBg)
ToggleCircle.Size = UDim2.new(0, 32, 0, 32)
ToggleCircle.Position = UDim2.new(0, 4, 0.5, -16)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
ToggleCircle.Text = ""
Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

-- [[ AUTO FISH PERSISTENT ENGINE ]] --
local function startFishing()
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("fish") or v.Name:lower():find("cast") or v.Name:lower():find("reel")) then
            table.insert(remotes, v)
        end
    end

    task.spawn(function()
        while isFishing do -- Loop ini berjalan terus meski Main.Visible = false
            pcall(function()
                for _, r in pairs(remotes) do
                    r:FireServer()
                    r:FireServer(true)
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
        ToggleBg.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        startFishing()
    else
        ToggleCircle:TweenPosition(UDim2.new(0, 4, 0.5, -16), "Out", "Quart", 0.3)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end
end)

-- [[ STATUS LOOP ANIMATION ]] --
task.spawn(function()
    local spinner = {"▖", "▘", "▝", "▗"}
    local step = 0
    while true do
        if isFishing then
            step = step + 1
            ConsoleTxt.Text = string.format(
                "> BG_FARMING_ACTIVE %s\n> MONITORING_WATER...\n> SPEED: %.2fs\n> TOTAL_CAUGHT: %d\n> (GUI CLOSED = STILL RUNNING)",
                spinner[step % #spinner + 1], speedVal, fishCount
            )
        else
            ConsoleTxt.Text = "> PHANTOM_OS: IDLE\n> SPEED: %.2fs\n> STATUS: WAITING_FOR_TOGGLE", speedVal
        end
        task.wait(0.2)
    end
end)

-- [[ ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(0, 30, 20)
Icon.Image = "rbxassetid://15264870535"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", Icon).Color = Color3.fromRGB(0, 255, 150)

-- LOGIKA CLOSE/OPEN GUI
Icon.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible 
end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
