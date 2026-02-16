-- [[ PHANTOM AUTO-FISH: CLEAN MODERN UI EDITION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local isFishing = false
local fishCount = 0
local speedVal = 0.3 
local tapSpeed = 0.01 

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomCleanUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 480) -- Ukuran lebih proporsional
Main.Position = UDim2.new(0.5, -160, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Soft Shadow / Glow
local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5

-- [[ HEADER ]] --
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Text = "PHANTOM AUTO-FISH V5"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 14
Header.BackgroundTransparency = 1

local Line = Instance.new("Frame", Main)
Line.Size = UDim2.new(0.9, 0, 0, 1)
Line.Position = UDim2.new(0.05, 0, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Line.BackgroundTransparency = 0.8

-- [[ TERMINAL MONITOR ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.85, 0, 0, 100)
Monitor.Position = UDim2.new(0.075, 0, 0, 55)
Monitor.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Monitor).CornerRadius = UDim.new(0, 8)

local ConsoleTxt = Instance.new("TextLabel", Monitor)
ConsoleTxt.Size = UDim2.new(1, -20, 1, -20)
ConsoleTxt.Position = UDim2.new(0, 10, 0, 10)
ConsoleTxt.BackgroundTransparency = 1
ConsoleTxt.Text = "> SYSTEM ONLINE\n> STATUS: IDLE\n> READY TO REEL"
ConsoleTxt.TextColor3 = Color3.fromRGB(0, 170, 255)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 11
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left

-- [[ SLIDER SYSTEM FUNCTION ]] --
local function AddSlider(name, pos, min, max, default)
    local Label = Instance.new("TextLabel", Main)
    Label.Size = UDim2.new(0.85, 0, 0, 20)
    Label.Position = pos
    Label.Text = name:upper()
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local SliderBack = Instance.new("TextButton", Main)
    SliderBack.Size = UDim2.new(0.85, 0, 0, 6)
    SliderBack.Position = pos + UDim2.new(0, 0, 0, 25)
    SliderBack.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    SliderBack.AutoButtonColor = false
    SliderBack.Text = ""
    Instance.new("UICorner", SliderBack)

    local SliderFill = Instance.new("Frame", SliderBack)
    SliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Instance.new("UICorner", SliderFill)

    local Knob = Instance.new("Frame", SliderFill)
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(1, -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local value = default

    SliderBack.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouseX = UserInputService:GetMouseLocation().X
            local relPos = math.clamp((mouseX - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            SliderFill.Size = UDim2.new(relPos, 0, 1, 0)
            value = min + (relPos * (max - min))
        end
    end)
    return function() return value end
end

local getCast = AddSlider("Casting Speed", UDim2.new(0.075, 0, 0, 175), 0.05, 1.5, 0.3)
local getTap = AddSlider("Hyper-Reel Speed", UDim2.new(0.075, 0, 0, 225), 0.001, 0.4, 0.01)

-- [[ MODERN TOGGLE SWITCH ]] --
local ToggleLabel = Instance.new("TextLabel", Main)
ToggleLabel.Size = UDim2.new(1, 0, 0, 20)
ToggleLabel.Position = UDim2.new(0, 0, 0, 300)
ToggleLabel.Text = "SYSTEM ACTIVATION"
ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.TextSize = 11
ToggleLabel.BackgroundTransparency = 1

local ToggleBg = Instance.new("TextButton", Main)
ToggleBg.Size = UDim2.new(0, 60, 0, 30)
ToggleBg.Position = UDim2.new(0.5, -30, 0, 330)
ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ToggleBg.Text = ""
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local Circle = Instance.new("Frame", ToggleBg)
Circle.Size = UDim2.new(0, 24, 0, 24)
Circle.Position = UDim2.new(0, 3, 0.5, -12)
Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

-- [[ FISHING LOGIC ]] --
local function startFishing()
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("fish") or n:find("cast") or n:find("reel") or n:find("pull") or n:find("tap") then
                table.insert(remotes, v)
            end
        end
    end

    task.spawn(function()
        while isFishing do
            pcall(function()
                for _, r in pairs(remotes) do
                    if r:IsA("RemoteEvent") then r:FireServer(true) else task.spawn(function() r:InvokeServer() end) end
                end
                RunService.Heartbeat:Wait()
            end)
            task.wait(getCast())
        end
    end)
end

ToggleBg.MouseButton1Click:Connect(function()
    isFishing = not isFishing
    if isFishing then
        Circle:TweenPosition(UDim2.new(1, -27, 0.5, -12), "Out", "Quart", 0.3)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        startFishing()
    else
        Circle:TweenPosition(UDim2.new(0, 3, 0.5, -12), "Out", "Quart", 0.3)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end
end)

-- [[ STATUS ANIMATION ]] --
task.spawn(function()
    while true do
        if isFishing then
            ConsoleTxt.Text = string.format("> AUTO-FISHING: ON\n> CATCH: %d\n> CAST-DELAY: %.2f\n> REEL-SPEED: %.3f\n> MODE: BACKGROUND READY", fishCount, getCast(), getTap())
            fishCount = fishCount + 1
        else
            ConsoleTxt.Text = "> PHANTOM SYSTEM: STANDBY\n> MONITORING: READY\n> CONFIGURE SLIDERS THEN START"
        end
        task.wait(0.2)
    end
end)

-- [[ ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Icon.Image = "rbxassetid://15264870535"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", Icon).Color = Color3.fromRGB(0, 170, 255)

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

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
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end
makeDraggable(Main); makeDraggable(Icon)
