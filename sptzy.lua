-- [[ PHANTOM REAL-TAP: COMPACT PHYSICAL CLICKER ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local isClicking = false
local clickCount = 0
local delayVal = 0.1

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomCompactTap"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 280) -- Ukuran lebih pendek & ringkas
Main.Position = UDim2.new(0.5, -130, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 1.5

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "AUTO-CLICKER"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1

-- [[ COMPACT MONITOR ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.85, 0, 0, 60)
Monitor.Position = UDim2.new(0.075, 0, 0, 45)
Monitor.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Instance.new("UICorner", Monitor).CornerRadius = UDim.new(0, 6)

local ConsoleTxt = Instance.new("TextLabel", Monitor)
ConsoleTxt.Size = UDim2.new(1, -16, 1, -16)
ConsoleTxt.Position = UDim2.new(0, 8, 0, 8)
ConsoleTxt.BackgroundTransparency = 1
ConsoleTxt.TextColor3 = Color3.fromRGB(0, 255, 150)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 10
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left
ConsoleTxt.Text = "> READY\n> SPEED: 0.10s"

-- [[ SLIDER SECTION ]] --
local SliderBack = Instance.new("TextButton", Main)
SliderBack.Size = UDim2.new(0.85, 0, 0, 6)
SliderBack.Position = UDim2.new(0.075, 0, 0, 135)
SliderBack.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SliderBack.Text = ""
SliderBack.AutoButtonColor = false
Instance.new("UICorner", SliderBack)

local SliderFill = Instance.new("Frame", SliderBack)
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", SliderFill)

local Knob = Instance.new("Frame", SliderFill)
Knob.Size = UDim2.new(0, 14, 0, 14)
Knob.Position = UDim2.new(1, -7, 0.5, -7)
Knob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Knob)

-- Slider Logic
local dragging = false
SliderBack.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation().X
        local relPos = math.clamp((mousePos - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(relPos, 0, 1, 0)
        delayVal = math.max(0.001, 0.5 - (relPos * 0.499)) -- Kanan = 0.001s
    end
end)

-- [[ TOGGLE BUTTON ]] --
local ToggleBg = Instance.new("TextButton", Main)
ToggleBg.Size = UDim2.new(0, 55, 0, 26)
ToggleBg.Position = UDim2.new(0.5, -27, 0, 180)
ToggleBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
ToggleBg.Text = ""
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local Circle = Instance.new("Frame", ToggleBg)
Circle.Size = UDim2.new(0, 20, 0, 20)
Circle.Position = UDim2.new(0, 3, 0.5, -10)
Circle.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

-- [[ ENGINE ]] --
task.spawn(function()
    while true do
        if isClicking then
            local mousePos = UserInputService:GetMouseLocation()
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
            task.wait()
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
            clickCount = clickCount + 1
            task.wait(delayVal)
        else
            task.wait(0.1)
        end
    end
end)

ToggleBg.MouseButton1Click:Connect(function()
    isClicking = not isClicking
    if isClicking then
        Circle:TweenPosition(UDim2.new(1, -23, 0.5, -10), "Out", "Quart", 0.2)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    else
        Circle:TweenPosition(UDim2.new(0, 3, 0.5, -10), "Out", "Quart", 0.2)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    end
end)

-- [[ MONITOR LOOP ]] --
task.spawn(function()
    while task.wait(0.1) do
        if isClicking then
            ConsoleTxt.Text = string.format("> CLICKING...\n> SPEED: %.3fs\n> TOTAL: %d", delayVal, clickCount)
        else
            ConsoleTxt.Text = string.format("> STANDBY\n> SPEED: %.3fs\n> READY TO START", delayVal)
        end
    end
end)

-- [[ ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 45, 0, 45)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Icon.Image = "rbxassetid://12513101569"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Icon).Color = Color3.fromRGB(0, 255, 150)

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
