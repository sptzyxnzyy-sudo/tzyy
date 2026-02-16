-- [[ PHANTOM REAL-TAP: EXTREME SPEED EDITION (10 - 5000 CPS) ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local isClicking = false
local clickCount = 0
local targetCPS = 10 -- Default 10 CPS

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomExtremeTap"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 260) 
Main.Position = UDim2.new(0.5, -120, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 50, 50) -- Merah Extreme
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "EXTREME AUTO-TAP"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

-- [[ MONITOR ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.85, 0, 0, 60)
Monitor.Position = UDim2.new(0.075, 0, 0, 45)
Monitor.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", Monitor).CornerRadius = UDim.new(0, 6)

local ConsoleTxt = Instance.new("TextLabel", Monitor)
ConsoleTxt.Size = UDim2.new(1, -16, 1, -16)
ConsoleTxt.Position = UDim2.new(0, 8, 0, 8)
ConsoleTxt.BackgroundTransparency = 1
ConsoleTxt.TextColor3 = Color3.fromRGB(255, 50, 50)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 10
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left
ConsoleTxt.Text = "> TARGET: CENTER\n> CPS: 10\n> STATUS: READY"

-- [[ SLIDER (CALIBRATED 10 - 5000) ]] --
local SliderBack = Instance.new("TextButton", Main)
SliderBack.Size = UDim2.new(0.85, 0, 0, 6)
SliderBack.Position = UDim2.new(0.075, 0, 0, 130)
SliderBack.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
SliderBack.Text = ""
SliderBack.AutoButtonColor = false
Instance.new("UICorner", SliderBack)

local SliderFill = Instance.new("Frame", SliderBack)
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
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
        
        -- Rumus 10 ke 5000 CPS
        targetCPS = math.floor(10 + (relPos * 4990))
    end
end)

-- [[ TOGGLE SWITCH ]] --
local ToggleBg = Instance.new("TextButton", Main)
ToggleBg.Size = UDim2.new(0, 50, 0, 24)
ToggleBg.Position = UDim2.new(0.5, -25, 0, 180)
ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ToggleBg.Text = ""
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local Circle = Instance.new("Frame", ToggleBg)
Circle.Size = UDim2.new(0, 18, 0, 18)
Circle.Position = UDim2.new(0, 3, 0.5, -9)
Circle.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

-- [[ HIGH SPEED ENGINE (BATCH MODE) ]] --
task.spawn(function()
    while true do
        if isClicking then
            local center = Camera.ViewportSize / 2
            
            -- Jika CPS rendah (< 60), gunakan delay biasa
            -- Jika CPS tinggi (> 60), gunakan batch per frame
            if targetCPS <= 60 then
                VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 0)
                clickCount = clickCount + 1
                task.wait(1/targetCPS)
            else
                local batchSize = math.ceil(targetCPS / 60)
                for i = 1, batchSize do
                    VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 0)
                    VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 0)
                    clickCount = clickCount + 1
                end
                RunService.Heartbeat:Wait()
            end
        else
            task.wait(0.1)
        end
    end
end)

ToggleBg.MouseButton1Click:Connect(function()
    isClicking = not isClicking
    if isClicking then
        Circle:TweenPosition(UDim2.new(1, -21, 0.5, -9), "Out", "Quart", 0.2)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        Circle:TweenPosition(UDim2.new(0, 3, 0.5, -9), "Out", "Quart", 0.2)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end
end)

-- [[ MONITOR LOOP ]] --
task.spawn(function()
    while task.wait(0.1) do
        if isClicking then
            ConsoleTxt.Text = string.format("> CLICKING CENTER\n> TARGET CPS: %d\n> TOTAL CLICK: %d", targetCPS, clickCount)
        else
            ConsoleTxt.Text = string.format("> STATUS: IDLE\n> TARGET CPS: %d\n> CENTER CLICK", targetCPS)
        end
    end
end)

-- [[ OPEN BUTTON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
OpenBtn.Text = "XTR"
OpenBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 10
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local BStroke = Instance.new("UIStroke", OpenBtn)
BStroke.Color = Color3.fromRGB(255, 50, 50)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(OpenBtn); drag(Main)
