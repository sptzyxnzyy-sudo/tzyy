-- [[ SPTZYY REQABLE SNIFFER - FIX DRAG & SCAN ONLY ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

local isScanning = false

-- [[ UI CONSTRUCT ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PureScanner_" .. math.random(100, 999)
ScreenGui.Parent = gethui and gethui() or CoreGui or lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Frame Utama (Persegi Empat)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 320)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- Penting agar bisa di-interact

-- Border Pelangi
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

task.spawn(function()
    local c = 0
    while true do
        c = c + 0.01
        UIStroke.Color = Color3.fromHSV(c % 1, 0.7, 1)
        task.wait(0.03)
    end
end)

-- Header (Area Khusus Geser/Drag)
local DragHeader = Instance.new("Frame", MainFrame)
DragHeader.Size = UDim2.new(1, 0, 0, 35)
DragHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DragHeader.BorderSizePixel = 0

local Title = Instance.new("TextLabel", DragHeader)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "NETWORK SCANNER (DRAG HERE)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Scroll Box
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -14, 1, -100)
ScrollFrame.Position = UDim2.new(0, 7, 0, 42)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(2, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 4)

-- [[ LOGIC SCANNER ]] --
local function Serialize(val)
    if type(val) == "table" then
        local s = "{"
        for i, v in pairs(val) do s = s .. tostring(i) .. ":" .. Serialize(v) .. "," end
        return s:gsub(",$", "") .. "}"
    end
    return tostring(val)
end

local function AddLog(method, remote, args)
    local LogBtn = Instance.new("TextButton", ScrollFrame)
    LogBtn.Size = UDim2.new(1, 0, 0, 50)
    LogBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    LogBtn.BorderSizePixel = 0
    LogBtn.Text = ""

    local Info = Instance.new("TextLabel", LogBtn)
    Info.Size = UDim2.new(1, -10, 1, -6)
    Info.Position = UDim2.new(0, 8, 0, 3)
    Info.BackgroundTransparency = 1
    Info.TextColor3 = method == "FIRE" and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 150, 0)
    Info.Font = Enum.Font.Code
    Info.TextSize = 8
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.TextYAlignment = Enum.TextYAlignment.Top
    Info.Text = string.format("[%s] %s\nData: %s", method, remote.Name, Serialize(args))

    LogBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(string.format("Remote: %s\nArgs: %s", remote:GetFullName(), Serialize(args)))
        end
    end)
    ScrollFrame.CanvasSize = UDim2.new(2, 0, 0, UIList.AbsoluteContentSize.Y)
end

-- Hooking Network
local oldNC
oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if isScanning and not checkcaller() then
        if method == "FireServer" or method == "fireServer" then
            task.spawn(AddLog, "FIRE", self, {...})
        elseif method == "InvokeServer" or method == "invokeServer" then
            task.spawn(AddLog, "INVOKE", self, {...})
        end
    end
    return oldNC(self, ...)
end))

-- [[ BUTTONS ]] --
local function MakeBtn(txt, pos, callback)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0, 145, 0, 40)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.Code
    b.TextSize = 10
    
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(80, 80, 80)

    b.MouseButton1Click:Connect(function() callback(b) end)
end

MakeBtn("START SCAN", UDim2.new(0, 10, 1, -48), function(b)
    isScanning = not isScanning
    b.Text = isScanning and "STOP SCAN" or "START SCAN"
    b.TextColor3 = isScanning and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
end)

MakeBtn("CLEAR LOGS", UDim2.new(0, 165, 1, -48), function()
    for _, v in pairs(ScrollFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
end)

-- [[ FIX DRAG LOGIC ]] --
local dragging, dragInput, dragStart, startPos
DragHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
