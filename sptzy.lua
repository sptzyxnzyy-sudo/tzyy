-- [[ BEAST REQABLE X-ADMIN: ULTIMATE PRO COMPLETE ]] --
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ STATE MANAGEMENT ]] --
local interceptedLogs = {}
local selectedRemote = nil
local scannerActive = true
local set_clipboard = setclipboard or tostring

-- [[ NOTIFICATION & STATUS ]] --
local function showStatus(msg, col)
    local n = Instance.new("TextLabel", ScreenGui)
    n.Size = UDim2.new(0, 280, 0, 35)
    n.Position = UDim2.new(0.5, -140, -0.1, 0)
    n.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    n.TextColor3 = col or Color3.new(1,1,1)
    n.Text = "[SYSTEM]: " .. msg
    n.Font = Enum.Font.GothamBold
    n.TextSize = 10
    Instance.new("UICorner", n)
    Instance.new("UIStroke", n).Color = col or Color3.fromRGB(0, 255, 150)
    
    n:TweenPosition(UDim2.new(0.5, -140, 0.05, 0), "Out", "Back", 0.3)
    task.delay(2.5, function()
        if n then
            n:TweenPosition(UDim2.new(0.5, -140, -0.1, 0), "In", "Back", 0.3)
            task.wait(0.5)
            n:Destroy()
        end
    end)
end

-- [[ CORE ENGINE: SCANNER LOGIC ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Hanya tangkap jika scanner aktif
    if scannerActive and (method == "FireServer" or method == "InvokeServer") then
        local raw = HttpService:JSONEncode(args)
        if #interceptedLogs == 0 or interceptedLogs[1].Raw ~= raw then
            table.insert(interceptedLogs, 1, {Obj = self, Name = tostring(self), Raw = raw})
            if #interceptedLogs > 20 then table.remove(interceptedLogs, 21) end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 520)
Main.Position = UDim2.new(0.5, -190, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 40, 40)

-- PLAYER LIST POP-UP
local PlayerListFrame = Instance.new("Frame", Main)
PlayerListFrame.Size = UDim2.new(0.85, 0, 0.7, 0)
PlayerListFrame.Position = UDim2.new(0.075, 0, 0.15, 0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerListFrame.Visible = false
PlayerListFrame.ZIndex = 10
Instance.new("UICorner", PlayerListFrame)
local plStroke = Instance.new("UIStroke", PlayerListFrame)
plStroke.Color = Color3.fromRGB(0, 255, 150)

local PLScroll = Instance.new("ScrollingFrame", PlayerListFrame)
PLScroll.Size = UDim2.new(1, -10, 1, -50)
PLScroll.Position = UDim2.new(0, 5, 0, 40)
PLScroll.BackgroundTransparency = 1
PLScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", PLScroll).Padding = UDim.new(0, 5)

local ClosePL = Instance.new("TextButton", PlayerListFrame)
ClosePL.Size = UDim2.new(0.9, 0, 0, 30)
ClosePL.Position = UDim2.new(0.05, 0, 0.05, 0)
ClosePL.Text = "CLOSE PLAYER LIST"
ClosePL.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ClosePL.TextColor3 = Color3.new(1,1,1)
ClosePL.Font = Enum.Font.GothamBold
Instance.new("UICorner", ClosePL)
ClosePL.MouseButton1Click:Connect(function() PlayerListFrame.Visible = false end)

-- [[ SECTION: CONSOLE PROSES ]] --
local ProcFrame = Instance.new("Frame", Main)
ProcFrame.Size = UDim2.new(0.92, 0, 0, 190)
ProcFrame.Position = UDim2.new(0.04, 0, 0.08, 0)
ProcFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", ProcFrame)

local TargetDisplay = Instance.new("TextLabel", ProcFrame)
TargetDisplay.Size = UDim2.new(1, -20, 0, 25)
TargetDisplay.Position = UDim2.new(0, 10, 0, 5)
TargetDisplay.Text = "TARGET: NONE"
TargetDisplay.TextColor3 = Color3.fromRGB(0, 255, 150)
TargetDisplay.Font = Enum.Font.Code
TargetDisplay.TextXAlignment = Enum.TextXAlignment.Left
TargetDisplay.BackgroundTransparency = 1

local Editor = Instance.new("TextBox", ProcFrame)
Editor.Size = UDim2.new(0.94, 0, 0, 70)
Editor.Position = UDim2.new(0.03, 0, 0.18, 0)
Editor.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Editor.TextColor3 = Color3.new(1,1,1)
Editor.Text = ""
Editor.PlaceholderText = "-- JSON Data Input --"
Editor.TextWrapped = true
Editor.Font = Enum.Font.Code
Editor.TextSize = 11
Instance.new("UICorner", Editor)

-- Button Engine
local function createBtn(txt, pos, size, col, cb)
    local b = Instance.new("TextButton", ProcFrame)
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

createBtn("FIRE (SELF)", UDim2.new(0.03, 0, 0.62, 0), UDim2.new(0.3, 0, 0, 35), Color3.fromRGB(0, 120, 255), function()
    if not selectedRemote then showStatus("SELECT REMOTE FIRST!", Color3.new(1,0,0)) return end
    local success, args = pcall(function() return HttpService:JSONDecode(Editor.Text) end)
    if success then
        pcall(function() selectedRemote:FireServer(unpack(args)) end)
        showStatus("FIRED TO SELF", Color3.new(0,1,0))
    else showStatus("JSON ERROR", Color3.new(1,0,0)) end
end)

createBtn("FIRE (TARGET)", UDim2.new(0.35, 0, 0.62, 0), UDim2.new(0.3, 0, 0, 35), Color3.fromRGB(0, 180, 100), function()
    if not selectedRemote then showStatus("SELECT REMOTE FIRST!", Color3.new(1,0,0)) return end
    for _, v in pairs(PLScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local pb = Instance.new("TextButton", PLScroll)
        pb.Size = UDim2.new(1, -10, 0, 35)
        pb.Text = p.Name
        pb.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        pb.TextColor3 = Color3.new(1,1,1)
        pb.Font = Enum.Font.Code
        Instance.new("UICorner", pb)
        pb.MouseButton1Click:Connect(function()
            PlayerListFrame.Visible = false
            local s, args = pcall(function() return HttpService:JSONDecode(Editor.Text) end)
            if s then pcall(function() selectedRemote:FireServer(p, unpack(args)) end) showStatus("SENT TO: " .. p.Name, Color3.new(0,1,0)) end
        end)
    end
    PLScroll.CanvasSize = UDim2.new(0,0,0, #Players:GetPlayers() * 40)
    PlayerListFrame.Visible = true
end)

createBtn("FIRE (ALL)", UDim2.new(0.67, 0, 0.62, 0), UDim2.new(0.3, 0, 0, 35), Color3.fromRGB(180, 0, 0), function()
    if not selectedRemote then showStatus("SELECT REMOTE FIRST!", Color3.new(1,0,0)) return end
    local success, args = pcall(function() return HttpService:JSONDecode(Editor.Text) end)
    if success then
        showStatus("SENDING TO ALL...", Color3.fromRGB(255, 255, 0))
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then pcall(function() selectedRemote:FireServer(p, unpack(args)) end) end
        end
        showStatus("EXECUTION ALL SUCCESS", Color3.new(0,1,0))
    end
end)

-- [[ SECTION: CONSOLE SCAN ]] --
local ScanBar = Instance.new("Frame", Main)
ScanBar.Size = UDim2.new(0.92, 0, 0, 30)
ScanBar.Position = UDim2.new(0.04, 0, 0.46, 0)
ScanBar.BackgroundTransparency = 1

local ScanTitle = Instance.new("TextLabel", ScanBar)
ScanTitle.Size = UDim2.new(0.6, 0, 1, 0)
ScanTitle.Text = "📡 LIVE SCANNER"
ScanTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
ScanTitle.Font = Enum.Font.GothamBold
ScanTitle.TextXAlignment = Enum.TextXAlignment.Left
ScanTitle.BackgroundTransparency = 1

local ToggleScan = Instance.new("TextButton", ScanBar)
ToggleScan.Size = UDim2.new(0.35, 0, 1, 0)
ToggleScan.Position = UDim2.new(0.65, 0, 0, 0)
ToggleScan.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
ToggleScan.Text = "SCAN: ON"
ToggleScan.TextColor3 = Color3.new(1,1,1)
ToggleScan.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleScan)

ToggleScan.MouseButton1Click:Connect(function()
    scannerActive = not scannerActive
    ToggleScan.Text = scannerActive and "SCAN: ON" or "SCAN: OFF"
    ToggleScan.BackgroundColor3 = scannerActive and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(150, 0, 0)
    showStatus("SCANNER " .. (scannerActive and "ENABLED" or "DISABLED"), scannerActive and Color3.new(0,1,0) or Color3.new(1,0,0))
end)

local LogScroll = Instance.new("ScrollingFrame", Main)
LogScroll.Size = UDim2.new(0.92, 0, 0, 225)
LogScroll.Position = UDim2.new(0.04, 0, 0.53, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", LogScroll).Padding = UDim.new(0, 5)

local function refreshLogs()
    for _, v in pairs(LogScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, log in pairs(interceptedLogs) do
        local b = Instance.new("TextButton", LogScroll)
        b.Size = UDim2.new(1, -10, 0, 45)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = " ⚡ [" .. log.Name .. "]\n Args: " .. log.Raw
        b.TextColor3 = Color3.fromRGB(0, 255, 150)
        b.Font = Enum.Font.Code
        b.TextSize = 9
        b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            selectedRemote = log.Obj
            TargetDisplay.Text = "TARGET: " .. log.Name
            Editor.Text = log.Raw
            set_clipboard(log.Raw)
            showStatus("PATH SYNCED & COPIED", Color3.fromRGB(0, 150, 255))
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, #interceptedLogs * 50)
end

task.spawn(function() while task.wait(1.5) do if Main.Visible then refreshLogs() end end end)

-- [[ TOGGLE ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local iS = Instance.new("UIStroke", Icon)
iS.Color = Color3.fromRGB(0, 255, 150)
iS.Thickness = 3

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
