-- [[ SPTZYY PART CONTROLLER: BEAST REQABLE ULTIMATE ENGINE ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

-- [[ SETTINGS & TOGGLES ]] --
local botActive = true
local loggerActive = true
local breakpointActive = false
local rewriteActive = false
local mockActive = false

local pullRadius = 180      
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125        
local followStrength = 200  

-- [[ REQABLE DATA STORAGE ]] --
local interceptedLogs = {}
local rewriteRules = {} -- Format: { ["RemoteName"] = {newData} }
local breakpointQueue = {}

-- Clipboard Support
local set_clipboard = setclipboard or tostring

-- [[ CORE REQABLE ENGINE: SNIFFER, REWRITE, MOCK, BREAKPOINT ]] --
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    local remoteName = tostring(self)

    if loggerActive and (method == "FireServer" or method == "InvokeServer") then
        -- 1. SNIFFER: Melihat Body/Args secara Real-time
        local cleanArgs = {}
        for i,v in pairs(args) do cleanArgs[i] = tostring(v) end
        local dataString = HttpService:JSONEncode(cleanArgs)
        
        table.insert(interceptedLogs, 1, {Name = remoteName, Method = method, Data = dataString})
        if #interceptedLogs > 20 then table.remove(interceptedLogs, 21) end

        -- 2. REWRITE: Mengubah data sebelum dikirim
        if rewriteActive and rewriteRules[remoteName] then
            return oldNamecall(self, unpack(rewriteRules[remoteName]))
        end

        -- 3. MOCKING: Blokir kiriman asli, beri hasil palsu
        if mockActive and rewriteRules[remoteName] then
            return nil 
        end

        -- 4. BREAKPOINT: Tahan request (Logging ke Console untuk manual edit)
        if breakpointActive then
            warn("[BREAKPOINT] Intercepted: " .. remoteName .. " | Args: " .. dataString)
            -- Di Mobile, ini akan melambatkan game sebagai tanda tertahan
            wait(0.1) 
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ PHYSICS MAGNET LOGIC ]] --
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
                p.RotVelocity = Vector3.new(0, 15, 0)
            end
        end
    end
end)

-- [[ UI SETUP: REQABLE PRO INTERFACE ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "SPTZYY BEAST REQABLE PRO"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local LogScroll = Instance.new("ScrollingFrame", MainFrame)
LogScroll.Size = UDim2.new(0.9, 0, 0, 160)
LogScroll.Position = UDim2.new(0.05, 0, 0.5, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.Padding = UDim.new(0, 4)

-- Refresh UI Log
local function updateLogUI()
    for _, child in pairs(LogScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, log in pairs(interceptedLogs) do
        local b = Instance.new("TextButton", LogScroll)
        b.Size = UDim2.new(1, -5, 0, 40)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = " ["..log.Method.."] "..log.Name.."\n Data: "..log.Data
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
        b.TextSize = 10
        b.Font = Enum.Font.Code
        b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", b)
        
        b.MouseButton1Click:Connect(function()
            set_clipboard(log.Name .. " | Data: " .. log.Data)
            local old = b.Text
            b.Text = " [!] DATA COPIED TO CLIPBOARD"
            wait(0.7)
            b.Text = old
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end

spawn(function() while wait(1.5) do if loggerActive then updateLogUI() end end end)

-- [[ BUTTON CREATOR ]] --
local function createBtn(txt, pos, color, callback)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.43, 0, 0, 30)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local mBtn = createBtn("MAGNET: ON", UDim2.new(0.05, 0, 0.12, 0), Color3.fromRGB(0, 120, 255), function()
    botActive = not botActive
    script.Parent.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
end)

local sBtn = createBtn("SNIFFER: ON", UDim2.new(0.52, 0, 0.12, 0), Color3.fromRGB(120, 0, 255), function()
    loggerActive = not loggerActive
end)

local bBtn = createBtn("BREAKPOINT: OFF", UDim2.new(0.05, 0, 0.22, 0), Color3.fromRGB(150, 50, 0), function()
    breakpointActive = not breakpointActive
    -- Indikasi visual sederhana
end)

local rBtn = createBtn("REWRITE: OFF", UDim2.new(0.52, 0, 0.22, 0), Color3.fromRGB(50, 150, 0), function()
    rewriteActive = not rewriteActive
end)

-- Floating Icon & Drag
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
