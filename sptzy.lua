-- [[ BEAST TERMINATOR: MAP DESTRUCTION + LIVE ANIMATION ]] --
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = game:GetService("Players").LocalPlayer

local isDestroying = false
local currentProcess = "IDLE"

-- [[ UI CONSTRUCTION: CYBER DESTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 360, 0, 480)
Main.Position = UDim2.new(0.5, -180, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2

-- [[ ANIMATED LOADING PANEL ]] --
local TerminalFrame = Instance.new("Frame", Main)
TerminalFrame.Size = UDim2.new(0.9, 0, 0, 100)
TerminalFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
TerminalFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Instance.new("UICorner", TerminalFrame)

local LogLabel = Instance.new("TextLabel", TerminalFrame)
LogLabel.Size = UDim2.new(1, -20, 0, 60)
LogLabel.Position = UDim2.new(0, 10, 0, 10)
LogLabel.Text = "> SYSTEM READY\n> WAITING FOR COMMAND..."
LogLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
LogLabel.Font = Enum.Font.Code
LogLabel.TextSize = 12
LogLabel.TextXAlignment = Enum.TextXAlignment.Left
LogLabel.BackgroundTransparency = 1

local LoadingBarBack = Instance.new("Frame", TerminalFrame)
LoadingBarBack.Size = UDim2.new(0.9, 0, 0, 10)
LoadingBarBack.Position = UDim2.new(0.05, 0, 0.75, 0)
LoadingBarBack.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Instance.new("UICorner", LoadingBarBack)

local LoadingBarFront = Instance.new("Frame", LoadingBarBack)
LoadingBarFront.Size = UDim2.new(0, 0, 1, 0)
LoadingBarFront.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", LoadingBarFront)

-- [[ ANIMATION LOGIC ]] --
task.spawn(function()
    local frames = {"/", "-", "\\", "|"}
    local count = 0
    while true do
        if isDestroying then
            count = count + 1
            local char = frames[count % #frames + 1]
            LogLabel.Text = "> EXECUTING: " .. currentProcess .. " " .. char .. "\n> INJECTING PACKETS TO MAP...\n> SERVER RESPONSE: LAG_DETECTED"
            
            -- Loading Bar Loop
            LoadingBarFront:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 0.8)
            task.wait(0.8)
            LoadingBarFront.Size = UDim2.new(0, 0, 1, 0)
        else
            LogLabel.Text = "> SYSTEM IDLE\n> READY TO TERMINATE"
            LoadingBarFront.Size = UDim2.new(0, 0, 1, 0)
            task.wait(0.5)
        end
    end
end)

-- [[ ATTACK BUTTONS ]] --
local function createBtn(txt, pos, color, func)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 50)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
    return b
end

createBtn("PHYSICS TERMINATOR (LAG)", UDim2.new(0.05, 0, 0.38, 0), Color3.fromRGB(100, 0, 0), function()
    isDestroying = not isDestroying
    currentProcess = "PHYSICS_OVERFLOW"
    if isDestroying then
        task.spawn(function()
            while isDestroying do
                local p = Instance.new("Part")
                p.Size = Vector3.new(15, 15, 15)
                p.Position = lp.Character.HumanoidRootPart.Position + Vector3.new(math.random(-100,100), 50, math.random(-100,100))
                p.Velocity = Vector3.new(0, -5000, 0)
                p.Parent = workspace
                game:GetService("Debris"):AddItem(p, 0.3)
                task.wait()
            end
        end)
    end
end)

createBtn("VOID MAP (BRIGHTNESS CRASH)", UDim2.new(0.05, 0, 0.52, 0), Color3.fromRGB(60, 0, 120), function()
    currentProcess = "LIGHTING_VOID"
    local l = game:GetService("Lighting")
    l.Brightness = 0
    l.ClockTime = 0
    local c = Instance.new("ColorCorrectionEffect", l)
    c.Saturation = -1
    c.Contrast = 10
end)

createBtn("STOP ALL PROCESS", UDim2.new(0.05, 0, 0.82, 0), Color3.fromRGB(30, 30, 30), function()
    isDestroying = false
    currentProcess = "CLEANING"
    task.wait(1)
    currentProcess = "IDLE"
end)

-- [[ ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local iS = Instance.new("UIStroke", Icon)
iS.Color = Color3.fromRGB(255, 0, 0)
iS.Thickness = 4

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
