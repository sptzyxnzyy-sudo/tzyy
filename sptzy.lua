-- [[ SPTZYY REQABLE PRO: ULTIMATE SYNC WITH NOTIFICATIONS ]] --
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ GLOBAL STATE ]] --
local interceptedLogs = {}
local selectedRemote = nil
local carryAllActive = false
local set_clipboard = setclipboard or tostring

-- [[ NOTIFICATION SYSTEM ]] --
local function showNotify(text, color)
    local n = Instance.new("TextLabel", ScreenGui)
    n.Size = UDim2.new(0, 200, 0, 30)
    n.Position = UDim2.new(0.5, -100, 0.05, 0)
    n.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    n.TextColor3 = Color3.new(1,1,1)
    n.Text = text
    n.Font = Enum.Font.GothamBold
    n.TextSize = 12
    Instance.new("UICorner", n)
    Instance.new("UIStroke", n).Color = Color3.new(1,1,1)
    
    task.spawn(function()
        n:TweenPosition(UDim2.new(0.5, -100, 0.1, 0), "Out", "Back", 0.3)
        task.wait(1.5)
        n:TweenPosition(UDim2.new(0.5, -100, -0.1, 0), "In", "Back", 0.3)
        task.wait(0.3)
        n:Destroy()
    end)
end

-- [[ ENGINE: DATA SNIFFER ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "InvokeServer") then
        table.insert(interceptedLogs, 1, {
            Obj = self,
            Name = tostring(self),
            Method = method,
            Args = HttpService:JSONEncode(args)
        })
        if #interceptedLogs > 20 then table.remove(interceptedLogs, 21) end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ UI CONSTRUCT ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Position = UDim2.new(0.5, -180, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(40, 40, 40)

-- Area Status Proses
local StatusIndicator = Instance.new("TextLabel", MainFrame)
StatusIndicator.Size = UDim2.new(1, 0, 0, 20)
StatusIndicator.Position = UDim2.new(0, 0, 0.41, 0)
StatusIndicator.Text = "SYSTEM READY"
StatusIndicator.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusIndicator.Font = Enum.Font.Code
StatusIndicator.BackgroundTransparency = 1
StatusIndicator.TextSize = 10

local ProcBox = Instance.new("Frame", MainFrame)
ProcBox.Size = UDim2.new(0.92, 0, 0, 160)
ProcBox.Position = UDim2.new(0.04, 0, 0.08, 0)
ProcBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", ProcBox)

local TargetDisplay = Instance.new("TextLabel", ProcBox)
TargetDisplay.Size = UDim2.new(0.9, 0, 0, 25)
TargetDisplay.Position = UDim2.new(0.05, 0, 0.05, 0)
TargetDisplay.Text = "WAITING FOR SELECTION..."
TargetDisplay.TextColor3 = Color3.fromRGB(0, 255, 150)
TargetDisplay.Font = Enum.Font.Code
TargetDisplay.BackgroundTransparency = 1
TargetDisplay.TextXAlignment = Enum.TextXAlignment.Left

local ArgsEditor = Instance.new("TextBox", ProcBox)
ArgsEditor.Size = UDim2.new(0.9, 0, 0, 60)
ArgsEditor.Position = UDim2.new(0.05, 0, 0.25, 0)
ArgsEditor.PlaceholderText = "Data will appear here..."
ArgsEditor.Text = ""
ArgsEditor.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ArgsEditor.TextColor3 = Color3.fromRGB(255, 255, 255)
ArgsEditor.TextWrapped = true
ArgsEditor.Font = Enum.Font.Code
ArgsEditor.TextSize = 11
Instance.new("UICorner", ArgsEditor)

-- BUTTONS
local function createExecBtn(txt, pos, color, cb)
    local b = Instance.new("TextButton", ProcBox)
    b.Size = UDim2.new(0.44, 0, 0, 35)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 11
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

createExecBtn("FIRE SINGLE", UDim2.new(0.05, 0, 0.7, 0), Color3.fromRGB(0, 120, 255), function()
    if not selectedRemote then 
        showNotify("GAGAL: BELUM PILIH DATA", Color3.fromRGB(150, 0, 0)) 
        return 
    end
    
    StatusIndicator.Text = "PROCESSING..."
    local success, data = pcall(function() return HttpService:JSONDecode(ArgsEditor.Text) end)
    
    if success then
        pcall(function()
            if selectedRemote:IsA("RemoteEvent") then selectedRemote:FireServer(unpack(data))
            else selectedRemote:InvokeServer(unpack(data)) end
        end)
        showNotify("BERHASIL DIKIRIM!", Color3.fromRGB(0, 150, 0))
        StatusIndicator.Text = "EXECUTION SUCCESS"
    else
        showNotify("GAGAL: FORMAT DATA SALAH", Color3.fromRGB(150, 0, 0))
        StatusIndicator.Text = "INVALID JSON FORMAT"
    end
end)

createExecBtn("CARRY ALL", UDim2.new(0.51, 0, 0.7, 0), Color3.fromRGB(180, 0, 0), function(b)
    if not selectedRemote then showNotify("PILIH DATA DULU!", Color3.fromRGB(150, 0, 0)) return end
    
    carryAllActive = not carryAllActive
    b.Text = carryAllActive and "STOP CARRY" or "CARRY ALL"
    b.BackgroundColor3 = carryAllActive and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(180, 0, 0)
    
    if carryAllActive then
        showNotify("CARRY ALL DIMULAI...", Color3.fromRGB(0, 100, 255))
        StatusIndicator.Text = "LOOPING ACTIVE"
        task.spawn(function()
            while carryAllActive do
                local _, data = pcall(function() return HttpService:JSONDecode(ArgsEditor.Text) end)
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp then pcall(function() selectedRemote:FireServer(p, unpack(data)) end) end
                end
                task.wait(0.3)
            end
            StatusIndicator.Text = "LOOPING STOPPED"
        end)
    else
        showNotify("CARRY ALL BERHENTI", Color3.fromRGB(150, 0, 0))
    end
end)

-- LOG SCANNER UI
local LogScroll = Instance.new("ScrollingFrame", MainFrame)
LogScroll.Size = UDim2.new(0.92, 0, 0, 220)
LogScroll.Position = UDim2.new(0.04, 0, 0.48, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LogScroll.ScrollBarThickness = 2
local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.Padding = UDim.new(0, 5)

local function updateLogUI()
    for _, v in pairs(LogScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, log in pairs(interceptedLogs) do
        local b = Instance.new("TextButton", LogScroll)
        b.Size = UDim2.new(1, -10, 0, 45)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = " [" .. log.Method .. "] " .. log.Name
        b.TextColor3 = Color3.fromRGB(0, 255, 150)
        b.Font = Enum.Font.Code
        Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            selectedRemote = log.Obj
            TargetDisplay.Text = "Selected: " .. log.Name
            ArgsEditor.Text = log.Args
            set_clipboard(log.Args)
            showNotify("DATA DIPILIH & DISALIN", Color3.fromRGB(0, 150, 255))
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end

task.spawn(function() while task.wait(1.5) do if MainFrame.Visible then updateLogUI() end end end)

-- TOGGLE & DRAG
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local iStroke = Instance.new("UIStroke", Icon)
iStroke.Color = Color3.fromRGB(0, 255, 150)

Icon.MouseButton1Click:Connect(function() 
    MainFrame.Visible = not MainFrame.Visible 
    iStroke.Color = MainFrame.Visible and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 150)
end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(MainFrame)
