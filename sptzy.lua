-- [[ PHANTOM FISH-IT: COMPACT EDITION ]] --
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local isCatching = false
local catchValue = 100
local catchDelay = 0.5
local targetRemote = nil

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomCompact"
ScreenGui.ResetOnSpawn = false

-- [[ DRAGGABLE ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenBtn.Text = "🐟"
OpenBtn.TextSize = 20
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 150)

-- [[ COMPACT MAIN FRAME ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 180) -- Ukuran jauh lebih kecil
Main.Position = UDim2.new(0.5, -110, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.Visible = false
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 150)

-- [[ MINIMALIST STATUS ]] --
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 40)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.new(1, 1, 1)
Status.Font = Enum.Font.Code
Status.TextSize = 9
Status.Text = "Loading..."

task.spawn(function()
    local days = {"Ming", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"}
    while task.wait(0.5) do
        local d = os.date("*t")
        local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Status.Text = string.format("%s %02d:%02d | PING: %dms", days[d.wday], d.hour, d.min, p)
    end
end)

-- [[ COMPACT INPUTS ]] --
local function CreateMiniInput(name, pos, default)
    local l = Instance.new("TextLabel", Main)
    l.Size = UDim2.new(0.4, 0, 0, 20)
    l.Position = pos
    l.Text = name
    l.TextColor3 = Color3.fromRGB(150, 150, 150)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 11

    local b = Instance.new("TextBox", Main)
    b.Size = UDim2.new(0.3, 0, 0, 20)
    b.Position = pos + UDim2.new(0.45, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Text = tostring(default)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Code
    b.TextSize = 10
    Instance.new("UICorner", b)
    return b
end

local ValBox = CreateMiniInput("Value:", UDim2.new(0.1, 0, 0.3, 0), 100)
local SpdBox = CreateMiniInput("Delay:", UDim2.new(0.1, 0, 0.45, 0), 0.5)

ValBox.FocusLost:Connect(function() catchValue = tonumber(ValBox.Text) or 100 end)
SpdBox.FocusLost:Connect(function() catchDelay = tonumber(SpdBox.Text) or 0.5 end)

-- [[ COMPACT ACTION BUTTON ]] --
local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0.8, 0, 0, 30)
Btn.Position = UDim2.new(0.1, 0, 0.7, 0)
Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 80)
Btn.Text = "START"
Btn.TextColor3 = Color3.new(1, 1, 1)
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 12
Instance.new("UICorner", Btn)

-- [[ DRAG & TOGGLE LOGIC ]] --
local function drag(obj)
    local s, i, sp
    obj.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = obj.Position end end)
    obj.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end

drag(Main); drag(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- [[ ENGINE ]] --
Btn.MouseButton1Click:Connect(function()
    isCatching = not isCatching
    if isCatching then
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and (v.Name:lower():find("fish") or v.Name:lower():find("catch")) then
                targetRemote = v; break
            end
        end
        Btn.Text = targetRemote and "RUNNING..." or "NOT FOUND"
        Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    else
        Btn.Text = "START"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 80)
    end
end)

task.spawn(function()
    while true do
        if isCatching and targetRemote then
            pcall(function() targetRemote:FireServer(true, catchValue + math.random(-1,1)) end)
            task.wait(catchDelay + (math.random(-5, 5) / 100))
        end
        task.wait(0.1)
    end
end)
