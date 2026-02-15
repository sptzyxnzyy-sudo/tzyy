-- [[ SPTZYY BEAST REQABLE ULTIMATE: FULL HTTP & REMOTE SNIFFER ]] --
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

-- 1. [HTTP SNIFFER] Hooking HttpService (Memantau Web Request)
local oldRequest
local function hookHttp()
    local success, err = pcall(function()
        local mt = getrawmetatable(HttpService)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        
        mt.__index = newcclosure(function(self, key)
            local method = oldIndex(self, key)
            if loggerActive and (key == "GetAsync" or key == "PostAsync" or key == "RequestAsync") then
                return newcclosure(function(instance, ...)
                    local args = {...}
                    local url = args[1] or "Unknown URL"
                    local body = args[2] or "No Body"
                    
                    table.insert(interceptedLogs, 1, {
                        Type = "🌐 HTTP", 
                        Name = url, 
                        Method = key, 
                        Data = "Body/Header: " .. HttpService:JSONEncode(body)
                    })
                    return method(instance, ...)
                end)
            end
            return method
        end)
        setreadonly(mt, true)
    end)
    if not success then warn("HTTP Sniffer Hook Failed: " .. err) end
end
hookHttp()

-- 2. [REMOTE SNIFFER] Hooking Namecall (Memantau RemoteEvent/Function)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local remoteName = tostring(self)

    if loggerActive and (method == "FireServer" or method == "InvokeServer") then
        local dataString = HttpService:JSONEncode(args) -- Format Array/Dictionary
        
        if filterText == "" or string.find(string.lower(remoteName), string.lower(filterText)) then
            table.insert(interceptedLogs, 1, {
                Type = "📡 REMOTE", 
                Name = remoteName, 
                Method = method, 
                Data = "Args: " .. dataString
            })
            if #interceptedLogs > 40 then table.remove(interceptedLogs, 41) end
        end

        if rewriteActive and rewriteRules[remoteName] then
            return oldNamecall(self, unpack({rewriteRules[remoteName]}))
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ PHYSICS MAGNET ]] --
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

-- [[ UI SETUP: ULTIMATE REQABLE ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 480)
MainFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(60, 60, 60)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BEAST REQABLE X-RAY V5"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local FilterBox = Instance.new("TextBox", MainFrame)
FilterBox.Size = UDim2.new(0.9, 0, 0, 30)
FilterBox.Position = UDim2.new(0.05, 0, 0.09, 0)
FilterBox.PlaceholderText = "🔍 Search Remote / URL Website..."
FilterBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FilterBox.TextColor3 = Color3.new(1,1,1)
FilterBox.Font = Enum.Font.GothamMedium
FilterBox.TextSize = 11
Instance.new("UICorner", FilterBox)

FilterBox:GetPropertyChangedSignal("Text"):Connect(function() filterText = FilterBox.Text end)

-- [[ LOG AREA ]] --
local LogScroll = Instance.new("ScrollingFrame", MainFrame)
LogScroll.Size = UDim2.new(0.9, 0, 0, 220)
LogScroll.Position = UDim2.new(0.05, 0, 0.52, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogScroll.ScrollBarThickness = 3
local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.Padding = UDim.new(0, 5)

local function updateLogs()
    for _, v in pairs(LogScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, log in pairs(interceptedLogs) do
        local b = Instance.new("TextButton", LogScroll)
        b.Size = UDim2.new(1, -10, 0, 55)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = " " .. log.Type .. " | " .. log.Method .. "\n Source: " .. log.Name .. "\n " .. log.Data
        b.TextColor3 = (log.Type == "🌐 HTTP") and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(0, 255, 150)
        b.TextSize = 8
        b.Font = Enum.Font.Code
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.TextWrapped = true
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            set_clipboard(log.Name .. " | " .. log.Data)
            b.Text = "COPIED TO CLIPBOARD!"
            task.wait(0.5)
            updateLogs()
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end

spawn(function() while task.wait(1.5) do if loggerActive then updateLogs() end end end)

-- [[ CONTROLS ]] --
local function btn(t, p, c, cb)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.43, 0, 0, 35)
    b.Position = p
    b.BackgroundColor3 = c
    b.Text = t
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

btn("MAGNET: ON", UDim2.new(0.05, 0, 0.17, 0), Color3.fromRGB(0, 100, 255), function(b)
    botActive = not botActive
    b.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
end)

btn("SNIFFER: ON", UDim2.new(0.52, 0, 0.17, 0), Color3.fromRGB(150, 0, 255), function(b)
    loggerActive = not loggerActive
    b.Text = loggerActive and "SNIFFER: ON" or "SNIFFER: OFF"
end)

-- [[ FLOATING ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", Icon).Color = Color3.fromRGB(0, 255, 150)
Icon.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    UserInputService.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(MainFrame)
