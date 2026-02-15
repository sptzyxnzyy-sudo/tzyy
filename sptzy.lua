-- [[ BEAST REQABLE PRO: CYBER EDITION V6 ]] --
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- [[ STATE MANAGEMENT ]] --
local interceptedLogs = {}
local selectedData = nil
local isExecutingAll = false
local set_clipboard = setclipboard or tostring

-- [[ MODERN NOTIFICATION SYSTEM ]] --
local function showNotify(msg, col)
    local n = Instance.new("Frame", ScreenGui)
    n.Size = UDim2.new(0, 250, 0, 40)
    n.Position = UDim2.new(0.5, -125, -0.1, 0)
    n.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", n)
    local s = Instance.new("UIStroke", n)
    s.Color = col or Color3.fromRGB(0, 255, 150)
    s.Thickness = 2

    local t = Instance.new("TextLabel", n)
    t.Size = UDim2.new(1, 0, 1, 0)
    t.Text = msg
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.BackgroundTransparency = 1

    n:TweenPosition(UDim2.new(0.5, -125, 0.05, 0), "Out", "Back", 0.4)
    task.delay(2, function()
        n:TweenPosition(UDim2.new(0.5, -125, -0.1, 0), "In", "Back", 0.4)
        task.wait(0.5)
        n:Destroy()
    end)
end

-- [[ CORE ENGINE: UNIVERSAL HOOK ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == "FireServer" or method == "InvokeServer") then
        local rawData = HttpService:JSONEncode(args)
        -- Anti Duplikasi Log Sederhana
        if #interceptedLogs == 0 or interceptedLogs[1].RawJSON ~= rawData then
            table.insert(interceptedLogs, 1, {
                Obj = self,
                Name = tostring(self),
                Method = method,
                Args = args,
                RawJSON = rawData
            })
            if #interceptedLogs > 30 then table.remove(interceptedLogs, 31) end
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(40, 40, 40)
MainStroke.Thickness = 2

-- Neon Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "BEAST REQABLE X-PRO"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- [[ PANEL 1: CONSOLE PROSES (TOP) ]] --
local ConsoleProses = Instance.new("Frame", MainFrame)
ConsoleProses.Size = UDim2.new(0.92, 0, 0, 200)
ConsoleProses.Position = UDim2.new(0.04, 0, 0.1, 0)
ConsoleProses.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", ConsoleProses)

local SelectedInfo = Instance.new("TextLabel", ConsoleProses)
SelectedInfo.Size = UDim2.new(0.9, 0, 0, 30)
SelectedInfo.Position = UDim2.new(0.05, 0, 0.05, 0)
SelectedInfo.Text = "STATUS: WAITING FOR SCAN..."
SelectedInfo.TextColor3 = Color3.fromRGB(100, 100, 100)
SelectedInfo.Font = Enum.Font.Code
SelectedInfo.TextXAlignment = Enum.TextXAlignment.Left
SelectedInfo.BackgroundTransparency = 1

local EditorBox = Instance.new("TextBox", ConsoleProses)
EditorBox.Size = UDim2.new(0.9, 0, 0, 80)
EditorBox.Position = UDim2.new(0.05, 0, 0.22, 0)
EditorBox.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
EditorBox.TextColor3 = Color3.fromRGB(0, 255, 150)
EditorBox.Text = ""
EditorBox.PlaceholderText = "-- Data Editor --"
EditorBox.TextWrapped = true
EditorBox.Font = Enum.Font.Code
EditorBox.TextSize = 12
Instance.new("UICorner", EditorBox)

-- Buttons Creator
local function createBtn(txt, pos, color, cb)
    local b = Instance.new("TextButton", ConsoleProses)
    b.Size = UDim2.new(0.44, 0, 0, 40)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

createBtn("FIRE ONCE", UDim2.new(0.05, 0, 0.72, 0), Color3.fromRGB(0, 100, 255), function()
    if not selectedData then showNotify("ERR: NO DATA SELECTED", Color3.fromRGB(255, 50, 50)) return end
    local success, args = pcall(function() return HttpService:JSONDecode(EditorBox.Text) end)
    if success then
        pcall(function()
            if selectedData.Obj:IsA("RemoteEvent") then selectedData.Obj:FireServer(unpack(args))
            else selectedData.Obj:InvokeServer(unpack(args)) end
        end)
        showNotify("SUCCESS: EXECUTED", Color3.fromRGB(0, 255, 100))
    else
        showNotify("ERR: INVALID JSON", Color3.fromRGB(255, 50, 50))
    end
end)

createBtn("EXEC ALL", UDim2.new(0.51, 0, 0.72, 0), Color3.fromRGB(255, 50, 50), function(b)
    if not selectedData then showNotify("ERR: NO DATA SELECTED", Color3.fromRGB(255, 50, 50)) return end
    isExecutingAll = not isExecutingAll
    b.Text = isExecutingAll and "STOPPING..." or "EXEC ALL"
    b.BackgroundColor3 = isExecutingAll and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(255, 50, 50)
    
    if isExecutingAll then
        showNotify("STARTING UNIVERSAL MASS EXEC...", Color3.fromRGB(0, 200, 255))
        task.spawn(function()
            while isExecutingAll do
                local _, currentArgs = pcall(function() return HttpService:JSONDecode(EditorBox.Text) end)
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp then
                        pcall(function() selectedData.Obj:FireServer(p, unpack(currentArgs)) end)
                    end
                end
                task.wait(0.4)
            end
        end)
    end
end)

-- [[ PANEL 2: CONSOLE SCAN (BOTTOM) ]] --
local ScanTitle = Instance.new("TextLabel", MainFrame)
ScanTitle.Size = UDim2.new(1, 0, 0, 30)
ScanTitle.Position = UDim2.new(0, 0, 0.5, 0)
ScanTitle.Text = "📡 LIVE TRAFFIC SCANNER"
ScanTitle.TextColor3 = Color3.fromRGB(80, 80, 80)
ScanTitle.Font = Enum.Font.GothamMedium
ScanTitle.TextSize = 12
ScanTitle.BackgroundTransparency = 1

local LogScroll = Instance.new("ScrollingFrame", MainFrame)
LogScroll.Size = UDim2.new(0.92, 0, 0, 210)
LogScroll.Position = UDim2.new(0.04, 0, 0.56, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogScroll.BorderSizePixel = 0
LogScroll.ScrollBarThickness = 2
local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.Padding = UDim.new(0, 5)

local function refreshScanUI()
    for _, v in pairs(LogScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, log in pairs(interceptedLogs) do
        local btn = Instance.new("TextButton", LogScroll)
        btn.Size = UDim2.new(1, -10, 0, 50)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.Text = " ⚡ [" .. log.Method:sub(1,4) .. "] " .. log.Name .. "\n Args: " .. log.RawJSON
        btn.TextColor3 = Color3.fromRGB(0, 255, 150)
        btn.Font = Enum.Font.Code
        btn.TextSize = 10
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextWrapped = true
        Instance.new("UICorner", btn)
        
        btn.MouseButton1Click:Connect(function()
            selectedData = log
            SelectedInfo.Text = "SYNCED: " .. log.Name
            SelectedInfo.TextColor3 = Color3.fromRGB(0, 255, 150)
            EditorBox.Text = log.RawJSON
            set_clipboard(log.RawJSON)
            showNotify("PATH SYNCED & COPIED", Color3.fromRGB(0, 150, 255))
            
            -- Visual click effect
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            task.wait(0.2)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end

task.spawn(function() while task.wait(1.5) do if MainFrame.Visible then refreshScanUI() end end end)

-- [[ FLOATING ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local IconStroke = Instance.new("UIStroke", Icon)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 3

Icon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    IconStroke.Color = MainFrame.Visible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
end)

local function makeDraggable(obj)
    local dragging, input, startPos, startObjPos
    obj.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true; input = inp; startPos = inp.Position; startObjPos = obj.Position end end)
    obj.InputChanged:Connect(function(inp) if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local delta = inp.Position - startPos; obj.Position = UDim2.new(startObjPos.X.Scale, startObjPos.X.Offset + delta.X, startObjPos.Y.Scale, startObjPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end
makeDraggable(Icon); makeDraggable(MainFrame)
