-- [[ PHANTOM SQUARE: REAL-TIME INSTANT CATCH ]] --
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local isCatching = false
local catchValue = 100
local catchDelay = 0.5
local targetRemote = nil

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomRealTime"
ScreenGui.ResetOnSpawn = false

-- [[ DRAGGABLE ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenBtn.Text = "🐟"
OpenBtn.TextSize = 22
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 1.5

-- [[ SQUARE MAIN FRAME ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 180) 
Main.Position = UDim2.new(0.5, -90, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.Thickness = 1.5

-- [[ REALTIME STATUS (PING & CLOCK) ]] --
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 50)
Status.Position = UDim2.new(0, 0, 0, 5)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.Code
Status.TextSize = 9
Status.Text = "WAITING..."

task.spawn(function()
    local days = {"Ming", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"}
    while task.wait(0.5) do
        local d = os.date("*t")
        local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Status.Text = string.format("%s | %02d:%02d:%02d\nPING: %dms", 
            days[d.wday]:upper(), d.hour, d.min, d.sec, p)
    end
end)

-- [[ INPUTS ]] --
local function CreateInput(name, pos, default)
    local l = Instance.new("TextLabel", Main)
    l.Size = UDim2.new(0.5, 0, 0, 20)
    l.Position = pos
    l.Text = name
    l.TextColor3 = Color3.fromRGB(180, 180, 180)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 11

    local b = Instance.new("TextBox", Main)
    b.Size = UDim2.new(0.35, 0, 0, 20)
    b.Position = pos + UDim2.new(0.4, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Text = tostring(default)
    b.TextColor3 = Color3.fromRGB(0, 255, 150)
    b.Font = Enum.Font.Code
    b.TextSize = 10
    Instance.new("UICorner", b)
    return b
end

local ValBox = CreateInput("VALUE:", UDim2.new(0.1, 0, 0.35, 0), 100)
local SpdBox = CreateInput("DELAY:", UDim2.new(0.1, 0, 0.5, 0), 0.5)

ValBox.FocusLost:Connect(function() catchValue = tonumber(ValBox.Text) or 100 end)
SpdBox.FocusLost:Connect(function() catchDelay = tonumber(SpdBox.Text) or 0.5 end)

-- [[ REALTIME ACTION BUTTON ]] --
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0, 140, 0, 35)
ActionBtn.Position = UDim2.new(0.5, -70, 0.75, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ActionBtn.Text = "START"
ActionBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
ActionBtn.Font = Enum.Font.GothamBold
ActionBtn.TextSize = 14
Instance.new("UICorner", ActionBtn)
local BtnStroke = Instance.new("UIStroke", ActionBtn)
BtnStroke.Color = Color3.fromRGB(200, 50, 50)

-- [[ LOGIC ENGINE ]] --
ActionBtn.MouseButton1Click:Connect(function()
    isCatching = not isCatching
    if isCatching then
        -- Mencari Remote secara real-time saat ON ditekan
        targetRemote = nil
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and (v.Name:lower():find("fish") or v.Name:lower():find("catch")) then
                targetRemote = v
                break
            end
        end

        if targetRemote then
            ActionBtn.Text = "ON"
            ActionBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
            BtnStroke.Color = Color3.fromRGB(0, 255, 150)
        else
            isCatching = false
            ActionBtn.Text = "NOT FOUND"
            task.wait(1)
            ActionBtn.Text = "START"
        end
    else
        ActionBtn.Text = "OFF"
        ActionBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
        BtnStroke.Color = Color3.fromRGB(200, 50, 50)
    end
end)

-- LOOP EKSEKUSI REALTIME
task.spawn(function()
    while true do
        if isCatching and targetRemote then
            pcall(function()
                -- Mengirim data ke server secara nyata
                targetRemote:FireServer(true, catchValue + math.random(-1, 1))
            end)
            -- Jeda real-time sesuai input user + jitter anti-deteksi
            task.wait(catchDelay + (math.random(-5, 5) / 100))
        end
        task.wait(0.1)
    end
end)

-- [[ DRAG SUPPORT ]] --
local function makeDraggable(obj)
    local s, i, sp
    obj.InputBegan:Connect(function(inp) 
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then 
            s = true; i = inp.Position; sp = obj.Position 
        end 
    end)
    obj.InputChanged:Connect(function(inp) 
        if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then 
            local d = inp.Position - i; obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) 
        end 
    end)
    UserInputService.InputEnded:Connect(function(inp) 
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end 
    end)
end

makeDraggable(Main); makeDraggable(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
