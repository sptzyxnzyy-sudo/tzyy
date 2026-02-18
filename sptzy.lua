-- [[ PHANTOM FISH-IT: ANTI-DETECTION + REALTIME STATUS ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local lp = game:GetService("Players").LocalPlayer

local activeRemotes = {}
local catchValue = 100
local catchDelay = 0.5

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomAntiDetectV2"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 420) 
Main.Position = UDim2.new(0.5, -140, 0.4, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 170, 0)
Stroke.Thickness = 2

-- [[ REALTIME STATUS BAR ]] --
local StatusFrame = Instance.new("Frame", Main)
StatusFrame.Size = UDim2.new(0.9, 0, 0, 45)
StatusFrame.Position = UDim2.new(0.05, 0, 0.08, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Instance.new("UICorner", StatusFrame)

local StatusLabel = Instance.new("TextLabel", StatusFrame)
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 10
StatusLabel.Text = "Loading Stats..."

-- Update Stats Loop
task.spawn(function()
    local days = {"Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"}
    while task.wait(0.5) do
        local date = os.date("*t")
        local dayName = days[date.wday]
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        
        StatusLabel.Text = string.format(
            "PING: %dms | %s\n%02d:%02d:%02d | %02d/%02d/%d",
            ping, dayName:upper(),
            date.hour, date.min, date.sec,
            date.day, date.month, date.year
        )
    end
end)

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "PHANTOM FISH-IT V2"
Title.TextColor3 = Color3.fromRGB(255, 170, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.BackgroundTransparency = 1

-- [[ INPUT SETTINGS ]] --
local function CreateInput(name, pos, default)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0.4, 0, 0, 25)
    label.Position = pos
    label.Text = name
    label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", Main)
    box.Size = UDim2.new(0.4, 0, 0, 25)
    box.Position = pos + UDim2.new(0.45, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.Text = tostring(default)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Code
    box.TextSize = 11
    Instance.new("UICorner", box)
    return box
end

local ValInput = CreateInput("Catch Value:", UDim2.new(0.05, 0, 0.22, 0), 100)
local SpdInput = CreateInput("Delay (Sec):", UDim2.new(0.05, 0, 0.3, 0), 0.5)

ValInput.FocusLost:Connect(function() catchValue = tonumber(ValInput.Text) or 100 end)
SpdInput.FocusLost:Connect(function() catchDelay = tonumber(SpdInput.Text) or 0.5 end)

-- [[ SCROLL LIST & LOGGER ]] --
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.25, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.4, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", Scroll)

local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0.18, 0)
LogFrame.Position = UDim2.new(0.05, 0, 0.68, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 2
local LogList = Instance.new("UIListLayout", LogFrame)

local function AddLog(text, color)
    local l = Instance.new("TextLabel", LogFrame)
    l.Size = UDim2.new(1, -10, 0, 16)
    l.BackgroundTransparency = 1
    l.Text = "[" .. os.date("%X") .. "] " .. text
    l.TextColor3 = color or Color3.new(1, 1, 1)
    l.Font = Enum.Font.Code
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogList.AbsoluteContentSize.Y)
    LogFrame.CanvasPosition = Vector2.new(0, LogList.AbsoluteContentSize.Y)
end

-- [[ ITEM CREATOR ]] --
local function addRemoteItem(remote)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -6, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = "  " .. remote.Name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        activeRemotes[remote] = active or nil
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 50)
        AddLog(active and "ON: "..remote.Name or "OFF: "..remote.Name)
    end)
end

-- [[ ENGINE ]] --
task.spawn(function()
    while true do
        for remote, _ in pairs(activeRemotes) do
            pcall(function()
                local jitterValue = catchValue + math.random(-1, 1)
                local jitterDelay = catchDelay + (math.random(-5, 5) / 100)
                remote:FireServer(true, jitterValue)
                task.wait(math.max(0.1, jitterDelay)) 
            end)
        end
        task.wait(0.1)
    end
end)

-- [[ SCAN BUTTON ]] --
local RefBtn = Instance.new("TextButton", Main)
RefBtn.Size = UDim2.new(0, 252, 0, 35)
RefBtn.Position = UDim2.new(0.05, 0, 0.88, 0)
RefBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
RefBtn.Text = "SCAN FISHING EVENTS"
RefBtn.Font = Enum.Font.GothamBold
RefBtn.TextSize = 11
Instance.new("UICorner", RefBtn)

RefBtn.MouseButton1Click:Connect(function()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    AddLog("Scanning game descendants...", Color3.new(1,1,0))
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("fish") or v.Name:lower():find("catch")) then 
            addRemoteItem(v) 
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

-- [[ TOGGLE BUTTON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -25)
OpenBtn.Text = "FISH"
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
OpenBtn.TextColor3 = Color3.fromRGB(255, 170, 0)
OpenBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(255, 170, 0)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [[ DRAG LOGIC ]] --
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and inp.UserInputType == Enum.UserInputType.MouseMovement then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then s = false end end)
end
drag(Main); drag(OpenBtn)

AddLog("System Ready.", Color3.fromRGB(0, 255, 255))
