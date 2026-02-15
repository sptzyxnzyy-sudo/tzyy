-- [[ BEAST ADMIN SIMULATOR: REAL-TIME MANIPULATION ]] --
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ GLOBAL STATE ]] --
local interceptedLogs = {}
local selectedRemote = nil
local isLooping = false
local set_clipboard = setclipboard or tostring

-- [[ NOTIFIKASI SYSTEM ]] --
local function notify(msg, color)
    local n = Instance.new("TextLabel", ScreenGui)
    n.Size = UDim2.new(0, 250, 0, 35)
    n.Position = UDim2.new(0.5, -125, 0.05, 0)
    n.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    n.TextColor3 = color or Color3.new(1,1,1)
    n.Text = "SYSTEM: " .. msg
    n.Font = Enum.Font.GothamBold
    n.TextSize = 12
    Instance.new("UICorner", n)
    Instance.new("UIStroke", n).Color = color or Color3.new(1,1,1)
    
    task.spawn(function()
        n:TweenPosition(UDim2.new(0.5, -125, 0.1, 0), "Out", "Back", 0.3)
        task.wait(2)
        n:TweenPosition(UDim2.new(0.5, -125, -0.1, 0), "In", "Back", 0.3)
        task.wait(0.3)
        n:Destroy()
    end)
end

-- [[ UNIVERSAL SNIFFER ENGINE ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (method == "FireServer" or method == "InvokeServer") then
        local raw = HttpService:JSONEncode(args)
        if #interceptedLogs == 0 or interceptedLogs[1].Raw ~= raw then
            table.insert(interceptedLogs, 1, {Obj = self, Name = tostring(self), Raw = raw, Args = args})
            if #interceptedLogs > 25 then table.remove(interceptedLogs, 26) end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ UI DESIGN: NEON ADMIN PANEL ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 520)
Main.Position = UDim2.new(0.5, -190, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "ADMIN MANIPULATOR v7"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

--- [[ PANEL: CONSOLE PROSES ]] ---
local ProcFrame = Instance.new("Frame", Main)
ProcFrame.Size = UDim2.new(0.92, 0, 0, 180)
ProcFrame.Position = UDim2.new(0.04, 0, 0.1, 0)
ProcFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", ProcFrame)

local TargetTxt = Instance.new("TextLabel", ProcFrame)
TargetTxt.Size = UDim2.new(0.9, 0, 0, 25)
TargetTxt.Position = UDim2.new(0.05, 0, 0.05, 0)
TargetTxt.Text = "SELECT REMOTE FROM SCANNER"
TargetTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetTxt.Font = Enum.Font.Code
TargetTxt.BackgroundTransparency = 1

local Editor = Instance.new("TextBox", ProcFrame)
Editor.Size = UDim2.new(0.9, 0, 0, 65)
Editor.Position = UDim2.new(0.05, 0, 0.25, 0)
Editor.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Editor.TextColor3 = Color3.fromRGB(0, 255, 150)
Editor.Text = ""
Editor.PlaceholderText = "Data JSON..."
Editor.TextWrapped = true
Editor.Font = Enum.Font.Code
Instance.new("UICorner", Editor)

local function btn(t, p, c, cb)
    local b = Instance.new("TextButton", ProcFrame)
    b.Size = UDim2.new(0.44, 0, 0, 35)
    b.Position = p
    b.BackgroundColor3 = c
    b.Text = t
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
    return b
end

btn("FORCE FIRE", UDim2.new(0.05, 0, 0.7, 0), Color3.fromRGB(0, 120, 255), function()
    if not selectedRemote then notify("PILIH REMOTE!", Color3.new(1,0,0)) return end
    local success, args = pcall(function() return HttpService:JSONDecode(Editor.Text) end)
    if success then
        selectedRemote:FireServer(unpack(args))
        notify("EXECUTED!", Color3.new(0,1,0))
    end
end)

btn("ADMIN: ALL PLAYERS", UDim2.new(0.51, 0, 0.7, 0), Color3.fromRGB(150, 0, 0), function()
    if not selectedRemote then notify("PILIH REMOTE!", Color3.new(1,0,0)) return end
    isLooping = not isLooping
    notify(isLooping and "MASS EXECUTION START" or "STOPPED", Color3.new(1,1,1))
    
    task.spawn(function()
        while isLooping do
            local _, data = pcall(function() return HttpService:JSONDecode(Editor.Text) end)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp then pcall(function() selectedRemote:FireServer(p, unpack(data)) end) end
            end
            task.wait(0.5)
        end
    end)
end)

--- [[ PANEL: CONSOLE SCAN ]] ---
local LogScroll = Instance.new("ScrollingFrame", Main)
LogScroll.Size = UDim2.new(0.92, 0, 0, 220)
LogScroll.Position = UDim2.new(0.04, 0, 0.52, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogScroll.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", LogScroll)
Layout.Padding = UDim.new(0, 5)

local function updateLogs()
    for _, v in pairs(LogScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, log in pairs(interceptedLogs) do
        local b = Instance.new("TextButton", LogScroll)
        b.Size = UDim2.new(1, -10, 0, 45)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = " [" .. log.Name .. "]\n Data: " .. log.Raw
        b.TextColor3 = Color3.fromRGB(0, 255, 150)
        b.TextSize = 9
        b.Font = Enum.Font.Code
        b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            selectedRemote = log.Obj
            TargetTxt.Text = "SYNCED: " .. log.Name
            Editor.Text = log.Raw
            set_clipboard(log.Raw)
            notify("PATH CAPTURED", Color3.fromRGB(0, 200, 255))
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end

task.spawn(function() while task.wait(1.5) do if Main.Visible then updateLogs() end end end)

-- [[ FLOATING TOGGLE ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local iStroke = Instance.new("UIStroke", Icon)
iStroke.Color = Color3.fromRGB(0, 255, 150)
iStroke.Thickness = 3

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
