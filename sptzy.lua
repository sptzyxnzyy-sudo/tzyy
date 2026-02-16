-- [[ PHANTOM COMPACT REMOTE SCANNER ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local activeRemotes = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "CompactRemoteScanner"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 260) -- Ukuran jauh lebih pendek
Main.Position = UDim2.new(0.5, -120, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 1.5

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "REMOTE SCANNER"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.BackgroundTransparency = 1

-- [[ SCROLL LIST ]] --
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.6, 0) -- Proporsi list yang pas
Scroll.Position = UDim2.new(0.05, 0, 0.15, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 4)

-- [[ LOGIC: ITEM CREATION ]] --
local function createRemoteItem(remote)
    local Frame = Instance.new("Frame", Scroll)
    Frame.Size = UDim2.new(1, -6, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

    local NameLabel = Instance.new("TextLabel", Frame)
    NameLabel.Size = UDim2.new(0.7, -5, 1, 0)
    NameLabel.Position = UDim2.new(0, 8, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = remote.Name
    NameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 13
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.ClipsDescendants = true

    -- Mini Switch
    local SwitchBg = Instance.new("TextButton", Frame)
    SwitchBg.Size = UDim2.new(0, 36, 0, 18)
    SwitchBg.Position = UDim2.new(1, -42, 0.5, -9)
    SwitchBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SwitchBg.Text = ""
    Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", SwitchBg)
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 2, 0.5, -7)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local isOn = false
    SwitchBg.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            activeRemotes[remote] = true
            Circle:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quart", 0.2)
            SwitchBg.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        else
            activeRemotes[remote] = nil
            Circle:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quart", 0.2)
            SwitchBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        end
    end)
end

-- [[ REFRESH BUTTON ]] --
local RefBtn = Instance.new("TextButton", Main)
RefBtn.Size = UDim2.new(0.9, 0, 0, 30)
RefBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
RefBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
RefBtn.Text = "SCAN REMOTES"
RefBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
RefBtn.Font = Enum.Font.GothamBold
RefBtn.TextSize = 10
Instance.new("UICorner", RefBtn)

-- [[ ENGINE ]] --
task.spawn(function()
    while true do
        for remote, _ in pairs(activeRemotes) do
            pcall(function() remote:FireServer() end)
        end
        task.wait(0.1)
    end
end)

RefBtn.MouseButton1Click:Connect(function()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    activeRemotes = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then createRemoteItem(v) end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
end)

-- [[ OPEN BUTTON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
OpenBtn.Text = "RE"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 10
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 255, 150)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- DRAG
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then s = false end end)
end
drag(OpenBtn); drag(Main)
