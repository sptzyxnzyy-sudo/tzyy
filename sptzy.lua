-- [[ SPTZYY REQABLE SNIFFER - RAINBOW SQUARE EDITION ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

local isScanning = false

-- [[ UI CONSTRUCT ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RainbowScanner_" .. math.random(100, 999)
ScreenGui.Parent = gethui and gethui() or CoreGui or lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 320)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0

-- Rainbow Border Effect
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

task.spawn(function()
    local counter = 0
    while true do
        counter = counter + 0.01
        UIStroke.Color = Color3.fromHSV(counter % 1, 0.8, 1)
        task.wait(0.03)
    end
end)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "RAINBOW NETWORK SNIFFER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Scrolling Area
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -14, 1, -90)
ScrollFrame.Position = UDim2.new(0, 7, 0, 38)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
ScrollFrame.CanvasSize = UDim2.new(3, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFrame.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 3)

-- [[ ENGINE: SERIALIZE & LOG ]] --
local function Serialize(val)
    if type(val) == "table" then
        local res = "{"
        for k, v in pairs(val) do
            res = res .. tostring(k) .. ":" .. Serialize(v) .. ","
        end
        return res:gsub(",$", "") .. "}"
    end
    return tostring(val)
end

local function AddLog(method, remote, args, res)
    local argText = Serialize(args)
    local remoteName = remote and remote.Name or "Unknown"
    local fullPath = remote and remote:GetFullName() or "???"
    
    local LogBtn = Instance.new("TextButton", ScrollFrame)
    LogBtn.Size = UDim2.new(1, 0, 0, 55)
    LogBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    LogBtn.BorderSizePixel = 0
    LogBtn.Text = ""

    local Detail = Instance.new("TextLabel", LogBtn)
    Detail.Size = UDim2.new(1, -10, 1, -5)
    Detail.Position = UDim2.new(0, 8, 0, 2)
    Detail.BackgroundTransparency = 1
    Detail.TextColor3 = method == "FIRE" and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 200, 0)
    Detail.Font = Enum.Font.Code
    Detail.TextSize = 9
    Detail.TextXAlignment = Enum.TextXAlignment.Left
    Detail.TextYAlignment = Enum.TextYAlignment.Top
    Detail.Text = string.format("[%s] %s\nPath: %s\nData: %s", method, remoteName, fullPath, argText)

    LogBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(string.format("-- SCAN LOG --\nRemote: %s\nArgs: %s\nReturn: %s", fullPath, argText, Serialize(res)))
            local flash = Instance.new("ColorCorrectionEffect", game:GetService("Lighting")) -- Visual Feedback
            task.wait(0.1)
            flash:Destroy()
        end
    end)
    
    ScrollFrame.CanvasSize = UDim2.new(3, 0, 0, UIList.AbsoluteContentSize.Y)
end

-- Hooking
local oldNC
oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if isScanning and not checkcaller() then
        if method == "FireServer" or method == "fireServer" then
            task.spawn(AddLog, "FIRE", self, args)
        elseif method == "InvokeServer" or method == "invokeServer" then
            local r = oldNC(self, ...)
            task.spawn(AddLog, "INVOKE", self, args, r)
            return r
        end
    end
    return oldNC(self, ...)
end))

-- [[ BUTTONS ]] --
local function CreateButton(txt, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 145, 0, 38)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Code
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Thickness = 1
    bStroke.Color = Color3.fromRGB(100, 100, 100)

    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

CreateButton("START SCAN", UDim2.new(0, 10, 1, -45), function(b)
    isScanning = not isScanning
    b.Text = isScanning and "STOP SCAN" or "START SCAN"
    b.TextColor3 = isScanning and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
end)

CreateButton("CLEAR LOGS", UDim2.new(0, 165, 1, -45), function()
    for _, v in pairs(ScrollFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    ScrollFrame.CanvasSize = UDim2.new(3, 0, 0, 0)
end)

-- [[ DRAG LOGIC ]] --
local d, s, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; s = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - s; MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
