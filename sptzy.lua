-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE REQABLE PRO ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local set_clipboard = setclipboard or tostring -- Support berbagai executor mobile
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local loggerActive = true
local pullRadius = 180      
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125        
local followStrength = 200  

-- [[ REQABLE ENGINE: SNIFFER & COPY ]] --
local interceptedLogs = {}
local function addToLog(remoteName)
    table.insert(interceptedLogs, 1, remoteName)
    if #interceptedLogs > 25 then table.remove(interceptedLogs, 26) end
end

-- Hooking Logic (The "Reqable" Part)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if loggerActive and (method == "FireServer" or method == "InvokeServer") then
        addToLog(tostring(self.Name))
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ LOGIKA PHYSICS ]] --
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
                p.RotVelocity = Vector3.new(0, 10, 0)
            end
        end
    end
end)

-- [[ UI SETUP: MOBILE PRO ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(45, 45, 45)

-- Floating Icon
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local IconStroke = Instance.new("UIStroke", Icon)
IconStroke.Color = Color3.fromRGB(0, 255, 150)

-- UI Labels
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BEAST MOBILE REQABLE"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- Log Container (Area Hasil Sniff)
local LogScroll = Instance.new("ScrollingFrame", MainFrame)
LogScroll.Size = UDim2.new(0.9, 0, 0, 140)
LogScroll.Position = UDim2.new(0.05, 0, 0.5, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Akan otomatis bertambah
LogScroll.ScrollBarThickness = 2
local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.Padding = UDim.new(0, 5)

-- Fungsi Update UI Log & Copy
local function updateLogUI()
    for _, child in pairs(LogScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, name in pairs(interceptedLogs) do
        local logBtn = Instance.new("TextButton", LogScroll)
        logBtn.Size = UDim2.new(1, -10, 0, 25)
        logBtn.BackgroundTransparency = 0.8
        logBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        logBtn.Text = " " .. name
        logBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        logBtn.TextXAlignment = Enum.TextXAlignment.Left
        logBtn.Font = Enum.Font.Code
        logBtn.TextSize = 12
        
        logBtn.MouseButton1Click:Connect(function()
            set_clipboard(name)
            logBtn.Text = " COPIED!"
            wait(0.5)
            logBtn.Text = " " .. name
        end)
    end
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end

spawn(function()
    while wait(1) do
        if loggerActive then updateLogUI() end
    end
end)

-- Buttons Setup
local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    return b
end

local MagBtn = createBtn("MAGNET: ON", UDim2.new(0.05, 0, 0.15, 0), Color3.fromRGB(0, 120, 255))
local LogBtn = createBtn("SNIFFER: ON", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(120, 0, 255))

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 20)
Info.Position = UDim2.new(0, 0, 0.93, 0)
Info.Text = "TAP LOG UNTUK COPY NAMA REMOTE"
Info.TextColor3 = Color3.fromRGB(120, 120, 120)
Info.TextSize = 10
Info.BackgroundTransparency = 1

-- Draggable Logic
local function drag(obj)
    local d, i, sp, p
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            d = true; i = input.Position; sp = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if d and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local del = input.Position - i
            obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then d = false end end)
end
drag(Icon); drag(MainFrame)

Icon.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

MagBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    MagBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    MagBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(70, 70, 70)
end)

LogBtn.MouseButton1Click:Connect(function()
    loggerActive = not loggerActive
    LogBtn.Text = loggerActive and "SNIFFER: ON" or "SNIFFER: OFF"
    LogBtn.BackgroundColor3 = loggerActive and Color3.fromRGB(120, 0, 255) or Color3.fromRGB(70, 70, 70)
end)
