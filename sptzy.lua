-- [[ PHANTOM FISH-IT: ANTI-DETECTION EDITION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local lp = game:GetService("Players").LocalPlayer

local activeRemotes = {}
local catchValue = 100 -- Angka default
local catchDelay = 0.5 -- Jeda default

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomAntiDetect"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 380) -- Ukuran lebih tinggi untuk input
Main.Position = UDim2.new(0.5, -130, 0.4, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 170, 0) -- Warna Amber (Waspada)
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "FISH-IT V2 (ANTI-DETECTION)"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
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

    local box = Instance.new("TextBox", Main)
    box.Size = UDim2.new(0.4, 0, 0, 25)
    box.Position = pos + UDim2.new(0.45, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.Text = tostring(default)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Code
    Instance.new("UICorner", box)
    return box
end

local ValInput = CreateInput("Catch Value:", UDim2.new(0.05, 0, 0.1, 0), 100)
local SpdInput = CreateInput("Delay (Sec):", UDim2.new(0.05, 0, 0.18, 0), 0.5)

ValInput.FocusLost:Connect(function() catchValue = tonumber(ValInput.Text) or 100 end)
SpdInput.FocusLost:Connect(function() catchDelay = tonumber(SpdInput.Text) or 0.5 end)

-- [[ SCROLL LIST & LOGGER (Tetap Sama) ]] --
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.3, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.28, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Scroll.BorderSizePixel = 0
local ListLayout = Instance.new("UIListLayout", Scroll)

local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0.22, 0)
LogFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogFrame.BorderSizePixel = 0
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
end

-- [[ ITEM CREATOR ]] --
local function addRemoteItem(remote)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -6, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = "  " .. remote.Name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        activeRemotes[remote] = active or nil
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 50)
        AddLog(active and "Enabled: "..remote.Name or "Disabled: "..remote.Name)
    end)
end

-- [[ EXECUTION ENGINE WITH ANTI-DETECTION ]] --
task.spawn(function()
    while true do
        for remote, _ in pairs(activeRemotes) do
            pcall(function()
                -- Anti-Detection: Menambah angka acak tipis pada input dan jeda
                local jitterValue = catchValue + math.random(-2, 2)
                local jitterDelay = catchDelay + (math.random(-10, 10) / 100)
                
                remote:FireServer(true, jitterValue)
                AddLog("Sent: " .. jitterValue .. " to " .. remote.Name, Color3.fromRGB(150, 255, 150))
                task.wait(math.max(0.1, jitterDelay)) 
            end)
        end
        task.wait(0.1)
    end
end)

-- [[ SCAN BUTTON ]] --
local RefBtn = Instance.new("TextButton", Main)
RefBtn.Size = UDim2.new(0, 234, 0, 30)
RefBtn.Position = UDim2.new(0.05, 0, 0.88, 0)
RefBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
RefBtn.Text = "SCAN REMOTES"
RefBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RefBtn)

RefBtn.MouseButton1Click:Connect(function()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    AddLog("Scanning...", Color3.new(1,1,0))
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("fish") or v.Name:lower():find("catch")) then 
            addRemoteItem(v) 
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

-- [[ OPEN BUTTON & DRAG ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Text = "FISH"
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.TextColor3 = Color3.new(1, 0.7, 0)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and inp.UserInputType == Enum.UserInputType.MouseMovement then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then s = false end end)
end
drag(Main); drag(OpenBtn)
