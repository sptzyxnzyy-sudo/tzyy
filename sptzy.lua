-- [[ PHANTOM REMOTE EXECUTOR: SERVERSIDE METHOD ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local activeRemotes = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomRemoteMethod"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 210) 
Main.Position = UDim2.new(0.5, -120, 0.4, 0)
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
Title.Text = "SERVERSIDE EXECUTION"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.BackgroundTransparency = 1

-- [[ SCROLL LIST ]] --
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.55, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.18, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 5)

-- [[ LOADING DOTS ]] --
local dots = {"", ".", "..", "..."}
local dotIdx = 1
task.spawn(function()
    while true do 
        dotIdx = (dotIdx % #dots) + 1
        task.wait(0.4)
    end
end)

-- [[ ITEM CREATOR ]] --
local function addRemoteItem(remote)
    local Frame = Instance.new("Frame", Scroll)
    Frame.Size = UDim2.new(1, -6, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    Instance.new("UICorner", Frame)

    local NameLabel = Instance.new("TextLabel", Frame)
    NameLabel.Size = UDim2.new(0.65, 0, 0.6, 0)
    NameLabel.Position = UDim2.new(0, 8, 0, 2)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = remote.Name
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 12
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local StatusLabel = Instance.new("TextLabel", Frame)
    StatusLabel.Size = UDim2.new(0.65, 0, 0.4, 0)
    StatusLabel.Position = UDim2.new(0, 8, 0.55, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: Idle"
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextSize = 10
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Frame)
    Switch.Size = UDim2.new(0, 38, 0, 18)
    Switch.Position = UDim2.new(1, -44, 0.5, -9)
    Switch.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Switch)
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 2, 0.5, -7)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local active = false
    
    -- Status Loop
    task.spawn(function()
        while Frame.Parent do
            if active then
                StatusLabel.Text = "FIRE_SERVER" .. dots[dotIdx]
                StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
            else
                StatusLabel.Text = "Status: Idle"
                StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            task.wait(0.1)
        end
    end)

    Switch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            activeRemotes[remote] = true
            Switch.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
            Circle:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quart", 0.15)
        else
            activeRemotes[remote] = nil
            Switch.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
            Circle:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quart", 0.15)
        end
    end)
end

-- [[ METHOD EXECUTION ENGINE ]] --
task.spawn(function()
    while true do
        for remote, _ in pairs(activeRemotes) do
            -- Logika ServerSide: Mengirim sinyal ke Server
            -- Menggunakan pcall agar jika remote membutuhkan argumen spesifik, script tidak crash
            pcall(function()
                -- Kita coba tembak dengan argumen 'true' agar server menganggap ini input valid
                remote:FireServer(true) 
            end)
        end
        task.wait(0.2) -- Delay agar tidak terkena Rate Limit server
    end
end)

-- [[ SCAN BUTTON ]] --
local RefBtn = Instance.new("TextButton", Main)
RefBtn.Size = UDim2.new(0, 216, 0, 30)
RefBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
RefBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
RefBtn.Text = "SCAN REMOTE EVENTS"
RefBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
RefBtn.Font = Enum.Font.GothamBold
RefBtn.TextSize = 10
Instance.new("UICorner", RefBtn)

RefBtn.MouseButton1Click:Connect(function()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    activeRemotes = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then addRemoteItem(v) end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
end)

-- [[ OPEN BUTTON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
OpenBtn.Text = "EXE"
OpenBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 10
Instance.new("UICorner", OpenBtn)
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
