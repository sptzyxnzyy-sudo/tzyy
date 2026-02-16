-- [[ PHANTOM REAL-TAP: FIXED SLIDER & NO DRIFT ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local isClicking = false
local clickCount = 0
local targetCPS = 10 

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomFixedTap"
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
Stroke.Color = Color3.fromRGB(255, 50, 50)
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
ConsoleTxt.Text = "> CPS: 10\n> READY"

-- [[ SLIDER (FIXED LOGIC) ]] --
local SliderBack = Instance.new("TextButton", Main)
SliderBack.Size = UDim2.new(0.85, 0, 0, 8)
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
Knob.Size = UDim2.new(0, 16, 0, 16)
Knob.Position = UDim2.new(1, -8, 0.5, -8)
Knob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Knob)

local sliding = false

SliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

RunService.RenderStepped:Connect(function()
    if sliding then
        local mousePos = UserInputService:GetMouseLocation().X
        local relPos = math.clamp((mousePos - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(relPos, 0, 1, 0)
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

-- [[ ENGINE ]] --
task.spawn(function()
    while true do
        if isClicking then
            local center = Camera.ViewportSize / 2
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

-- [[ UPDATE TEXT ]] --
task.spawn(function()
    while task.wait(0.1) do
        ConsoleTxt.Text = isClicking and string.format("> CLICKING...\n> CPS: %d\n> TOTAL: %d", targetCPS, clickCount) or string.format("> STATUS: IDLE\n> TARGET CPS: %d", targetCPS)
    end
end)

-- [[ OPEN BUTTON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
OpenBtn.Text = "XTR"
OpenBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 10
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local BStroke = Instance.new("UIStroke", OpenBtn)
BStroke.Color = Color3.fromRGB(255, 50, 50)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [[ FIXED DRAG LOGIC (Will not conflict with Slider) ]] --
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        -- HANYA drag jika TIDAK sedang menggeser slider
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not sliding then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(Main)
makeDraggable(OpenBtn)
