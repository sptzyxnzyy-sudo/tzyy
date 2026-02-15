-- [[ SPTZYY BEAST REQABLE ULTIMATE: ADVANCED REMOTE EXECUTOR ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local loggerActive = true
local rewriteActive = false
local filterText = ""
local pullRadius, orbitHeight, orbitRadius, spinSpeed, followStrength = 180, 8, 10, 125, 200

-- [[ REQABLE DATA ENGINE ]] --
local interceptedLogs = {}
local rewriteRules = {} 
local set_clipboard = setclipboard or tostring

-- Helper: Convert string input to Lua Table (untuk Fire Remote)
local function stringToTable(str)
    local success, result = pcall(function()
        return HttpService:JSONDecode(str)
    end)
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
        local dataString = HttpService:JSONEncode(args)
        
        if filterText == "" or string.find(string.lower(remoteName), string.lower(filterText)) then
            table.insert(interceptedLogs, 1, {
                Type = (method == "FireServer") and "📡 EVENT" or "📩 FUNC", 
                Name = remoteName, 
                Instance = self, -- Simpan referensi instance untuk Re-fire
                Method = method, 
                Data = dataString
            })
            if #interceptedLogs > 30 then table.remove(interceptedLogs, 31) end
        end

        if rewriteActive and rewriteRules[remoteName] then
            return oldNamecall(self, unpack(stringToTable(rewriteRules[remoteName])))
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ UI SETUP: THE EXECUTOR INTERFACE ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.Position = UDim2.new(0.5, -160, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(70, 70, 70)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "BEAST REQABLE: REMOTE EXECUTOR"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- [[ PANEL: MANUAL REMOTE FIRE (THE TESTER) ]] --
local RemoteInput = Instance.new("TextBox", MainFrame)
RemoteInput.Size = UDim2.new(0.9, 0, 0, 30)
RemoteInput.Position = UDim2.new(0.05, 0, 0.08, 0)
RemoteInput.PlaceholderText = "Target Remote Name..."
RemoteInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
RemoteInput.TextColor3 = Color3.new(1,1,1)
RemoteInput.TextSize = 10
Instance.new("UICorner", RemoteInput)

local ArgsInput = Instance.new("TextBox", MainFrame)
ArgsInput.Size = UDim2.new(0.9, 0, 0, 50)
ArgsInput.Position = UDim2.new(0.05, 0, 0.15, 0)
ArgsInput.PlaceholderText = 'Arguments (JSON Format). Contoh: [[1479], 988]'
ArgsInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ArgsInput.TextColor3 = Color3.fromRGB(0, 255, 150)
ArgsInput.TextWrapped = true
ArgsInput.ClearTextOnFocus = false
ArgsInput.TextSize = 10
Instance.new("UICorner", ArgsInput)

local FireBtn = Instance.new("TextButton", MainFrame)
FireBtn.Size = UDim2.new(0.9, 0, 0, 30)
FireBtn.Position = UDim2.new(0.05, 0, 0.26, 0)
FireBtn.Text = "🚀 FIRE REMOTE (EXECUTE)"
FireBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
FireBtn.Font = Enum.Font.GothamBold
FireBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", FireBtn)

FireBtn.MouseButton1Click:Connect(function()
    local target = game:FindFirstChild(RemoteInput.Text, true)
    local rawArgs = stringToTable(ArgsInput.Text)
    
    if target and rawArgs then
        if target:IsA("RemoteEvent") then
            target:FireServer(unpack(rawArgs))
        elseif target:IsA("RemoteFunction") then
            target:InvokeServer(unpack(rawArgs))
        end
        FireBtn.Text = "SUCCESSFULLY FIRED!"
    else
        FireBtn.Text = "FAILED: REMOTE NOT FOUND / INVALID ARGS"
    end
    task.wait(1)
    FireBtn.Text = "🚀 FIRE REMOTE (EXECUTE)"
end)

-- [[ LOG SCROLL AREA ]] --
local LogScroll = Instance.new("ScrollingFrame", MainFrame)
LogScroll.Size = UDim2.new(0.9, 0, 0, 200)
LogScroll.Position = UDim2.new(0.05, 0, 0.55, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogScroll.ScrollBarThickness = 3
local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.Padding = UDim.new(0, 5)

local function updateLogs()
    for _, v in pairs(LogScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, log in pairs(interceptedLogs) do
        local b = Instance.new("TextButton", LogScroll)
        b.Size = UDim2.new(1, -10, 0, 50)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = " " .. log.Type .. " | " .. log.Name .. "\n " .. log.Data
        b.TextColor3 = Color3.fromRGB(0, 255, 150)
        b.TextSize = 8
        b.Font = Enum.Font.Code
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.TextWrapped = true
        Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            -- Auto Fill ke Executor saat diklik
            RemoteInput.Text = log.Name
            ArgsInput.Text = log.Data
            set_clipboard(log.Data)
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end

spawn(function() while task.wait(1.5) do if loggerActive then updateLogs() end end end)

-- [[ PHYSICS MAGNET & ICON (STAY ACTIVE) ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    angle = angle + (0.05 * spinSpeed)
    local root = lp.Character.HumanoidRootPart
    local tPos = root.Position + Vector3.new(math.cos(angle)*orbitRadius, orbitHeight, math.sin(angle)*orbitRadius)
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("BasePart") and not p.Anchored and not p:IsDescendantOf(lp.Character) then
            if (p.Position - root.Position).Magnitude <= pullRadius then
                pcall(function() p:SetNetworkOwner(lp) end)
                p.Velocity = (tPos - p.Position) * followStrength
                p.RotVelocity = Vector3.new(0, 20, 0)
            end
        end
    end
end)

local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
Icon.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    UserInputService.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(MainFrame)
