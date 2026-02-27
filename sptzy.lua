-- [[ SPTZYY REQABLE MINI - SQUARE EDITION ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

local isScanning = false

-- [[ UI CONSTRUCT ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniScanner_" .. math.random(100, 999)
ScreenGui.Parent = gethui and gethui() or CoreGui or lp:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 300) -- Persegi Sempurna
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 1.5

-- Header (Title Bar)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "REQABLE SNIFFER v2"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Scrolling Log Area
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -14, 1, -95)
ScrollFrame.Position = UDim2.new(0, 7, 0, 38)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(2, 0, 0, 0) -- Support teks lebar ke kanan
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)

local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 3)

-- [[ SCANNER ENGINE ]] --
local function AddLog(type, remote, args, res)
    local argText = ""
    for i, v in pairs(args) do argText = argText .. tostring(v) .. ", " end
    
    local LogBtn = Instance.new("TextButton", ScrollFrame)
    LogBtn.Size = UDim2.new(1, 0, 0, 50)
    LogBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogBtn.Text = ""
    LogBtn.AutoButtonColor = true

    local Detail = Instance.new("TextLabel", LogBtn)
    Detail.Size = UDim2.new(1, -10, 1, -4)
    Detail.Position = UDim2.new(0, 8, 0, 2)
    Detail.BackgroundTransparency = 1
    Detail.TextColor3 = type == "FIRE" and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(255, 180, 0)
    Detail.Font = Enum.Font.Code
    Detail.TextSize = 9
    Detail.TextXAlignment = Enum.TextXAlignment.Left
    Detail.Text = string.format("[%s] %s\nData: %s\nRet: %s", type, remote.Name, argText, tostring(res or "nil"))

    -- Copy to Clipboard on Click
    LogBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(remote:GetFullName() .. "\nArgs: " .. argText)
            local oldColor = Detail.TextColor3
            Detail.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(0.3)
            Detail.TextColor3 = oldColor
        end
    end)
    
    ScrollFrame.CanvasSize = UDim2.new(2, 0, 0, UIList.AbsoluteContentSize.Y)
end

-- Hook Namecall
local oldNC
oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if isScanning then
        if method == "FireServer" then
            task.spawn(AddLog, "FIRE", self, args)
        elseif method == "InvokeServer" then
            local r = oldNC(self, ...)
            task.spawn(AddLog, "INVOKE", self, args, r)
            return r
        end
    end
    return oldNC(self, ...)
end))

-- [[ FOOTER BUTTONS ]] --
local function CreateButton(txt, pos, color, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 138, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = color
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Code
    btn.TextSize = 11

    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

CreateButton("START SCAN", UDim2.new(0, 8, 1, -48), Color3.fromRGB(0, 255, 150), function(b)
    isScanning = not isScanning
    b.Text = isScanning and "STOP SCAN" or "START SCAN"
    b.BackgroundColor3 = isScanning and Color3.fromRGB(0, 60, 40) or Color3.fromRGB(25, 25, 25)
end)

CreateButton("CLEAR", UDim2.new(0, 154, 1, -48), Color3.fromRGB(255, 50, 50), function()
    for _, v in pairs(ScrollFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    ScrollFrame.CanvasSize = UDim2.new(2, 0, 0, 0)
end)

-- Dragging Logic
local d, s, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; s = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - s; MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
