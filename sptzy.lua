-- [[ SPTZYY REQABLE MOBILE PRO: ADVANCED CARRY EXECUTOR ]] --
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local loggerActive = true
local carryLoop = false
local interceptedLogs = {}
local set_clipboard = setclipboard or tostring

-- Helper: JSON to Table
local function decode(str)
    local success, result = pcall(function() return HttpService:JSONDecode(str) end)
    return success and result or nil
end

-- [[ CORE HOOKING ENGINE ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local remoteName = tostring(self)

    if loggerActive and (method == "FireServer" or method == "InvokeServer") then
        table.insert(interceptedLogs, 1, {
            Name = remoteName,
            Method = method,
            Data = HttpService:JSONEncode(args),
            Instance = self
        })
        if #interceptedLogs > 20 then table.remove(interceptedLogs, 21) end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ UI DESIGN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)

-- Header
local Header = Instance.new("TextLabel", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Text = "REQABLE PRO: CARRY EDITION"
Header.TextColor3 = Color3.fromRGB(0, 255, 150)
Header.Font = Enum.Font.GothamBold
Header.BackgroundTransparency = 1

--- [[ SECTION: CONSOLE PROSES (CARRY EXECUTOR) ]] ---
local ProcFrame = Instance.new("Frame", MainFrame)
ProcFrame.Size = UDim2.new(0.9, 0, 0, 180)
ProcFrame.Position = UDim2.new(0.05, 0, 0.08, 0)
ProcFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", ProcFrame)

local RemoteTarget = Instance.new("TextBox", ProcFrame)
RemoteTarget.Size = UDim2.new(0.9, 0, 0, 25)
RemoteTarget.Position = UDim2.new(0.05, 0, 0.08, 0)
RemoteTarget.PlaceholderText = "CarryRemote Name..."
RemoteTarget.Text = "CarryRemote"
RemoteTarget.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
RemoteTarget.TextColor3 = Color3.new(1,1,1)
RemoteTarget.Font = Enum.Font.Code
Instance.new("UICorner", RemoteTarget)

local ArgsInput = Instance.new("TextBox", ProcFrame)
ArgsInput.Size = UDim2.new(0.9, 0, 0, 40)
ArgsInput.Position = UDim2.new(0.05, 0, 0.28, 0)
ArgsInput.PlaceholderText = "Custom Args (JSON)..."
ArgsInput.Text = '{"cmd":"PromptAction"}'
ArgsInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ArgsInput.TextColor3 = Color3.fromRGB(0, 255, 150)
ArgsInput.TextWrapped = true
ArgsInput.Font = Enum.Font.Code
Instance.new("UICorner", ArgsInput)

-- Tombol Carry Satu Persatu (Targeted)
local CarryBtn = Instance.new("TextButton", ProcFrame)
CarryBtn.Size = UDim2.new(0.43, 0, 0, 35)
CarryBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
CarryBtn.Text = "CARRY TARGET"
CarryBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CarryBtn.TextColor3 = Color3.new(1,1,1)
CarryBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CarryBtn)

-- Tombol Carry All (Loop/Mass)
local CarryAllBtn = Instance.new("TextButton", ProcFrame)
CarryAllBtn.Size = UDim2.new(0.43, 0, 0, 35)
CarryAllBtn.Position = UDim2.new(0.52, 0, 0.55, 0)
CarryAllBtn.Text = "CARRY ALL: OFF"
CarryAllBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CarryAllBtn.TextColor3 = Color3.new(1,1,1)
CarryAllBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CarryAllBtn)

local StatusLabel = Instance.new("TextLabel", ProcFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0.82, 0)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextSize = 10

--- [[ SECTION: CONSOLE SCAN ]] ---
local LogScroll = Instance.new("ScrollingFrame", MainFrame)
LogScroll.Size = UDim2.new(0.9, 0, 0, 200)
LogScroll.Position = UDim2.new(0.05, 0, 0.48, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LogScroll.ScrollBarThickness = 2
local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.Padding = UDim.new(0, 5)

-- Fungsi Carry Logic
local function fireCarry(targetPlayer)
    local remote = game:FindFirstChild(RemoteTarget.Text, true)
    local args = decode(ArgsInput.Text)
    if remote and args then
        -- Menambahkan target player ke dalam argumen jika diperlukan oleh remote
        -- Beberapa game membutuhkan: Remote:FireServer(target, args)
        pcall(function()
            remote:FireServer(targetPlayer, args)
        end)
    end
end

-- Carry All Toggle
CarryAllBtn.MouseButton1Click:Connect(function()
    carryLoop = not carryLoop
    CarryAllBtn.Text = carryLoop and "CARRY ALL: ON" or "CARRY ALL: OFF"
    CarryAllBtn.BackgroundColor3 = carryLoop and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 0, 0)
    
    task.spawn(function()
        while carryLoop do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lp then
                    fireCarry(v)
                    StatusLabel.Text = "Carrying: " .. v.Name
                end
            end
            task.wait(0.5) -- Delay agar tidak crash
        end
        StatusLabel.Text = "Status: Idle"
    end)
end)

-- Carry Targeted (Satu persatu berdasarkan input manual atau terdekat)
CarryBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and lp.Character then
            local dist = (v.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
            if dist < 20 then -- Hanya target yang dekat
                fireCarry(v)
                StatusLabel.Text = "Targeted Carry: " .. v.Name
            end
        end
    end
end)

-- Refresh Log UI
local function updateLogs()
    for _, v in pairs(LogScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, log in pairs(interceptedLogs) do
        local b = Instance.new("TextButton", LogScroll)
        b.Size = UDim2.new(1, -10, 0, 50)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        b.Text = " [" .. log.Method .. "] " .. log.Name .. "\n Data: " .. log.Data
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
        b.TextSize = 9
        b.Font = Enum.Font.Code
        b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            RemoteTarget.Text = log.Name
            ArgsInput.Text = log.Data
            set_clipboard(log.Data)
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end

task.spawn(function() while task.wait(1) do if MainFrame.Visible then updateLogs() end end end)

-- Floating Icon & Dragging
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", Icon).Color = Color3.fromRGB(0, 255, 150)
Icon.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local function makeDrag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
makeDrag(Icon); makeDrag(MainFrame)
