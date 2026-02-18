-- [[ PHANTOM SQUARE: BRATAL TURBO EDITION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local lp = game:GetService("Players").LocalPlayer

local isBrutal = false
local catchValue = 100
local lastFish = "None"

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomBrutal"
ScreenGui.ResetOnSpawn = false

-- [[ DRAGGABLE ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
OpenBtn.Text = "⚡"
OpenBtn.TextSize = 25
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(255, 0, 0)
IconStroke.Thickness = 2

-- [[ SQUARE MAIN FRAME ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 180) 
Main.Position = UDim2.new(0.5, -90, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(255, 0, 0)

-- [[ BRUTAL STATUS ]] --
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 60)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.Code
Status.TextSize = 8
Status.Text = "BRUTAL MODE READY"

task.spawn(function()
    while task.wait(0.3) do
        local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Status.Text = string.format("PING: %dms\nFISH: %s\nMODE: %s", 
            p, lastFish, (isBrutal and "ULTRA-FAST" or "STABLE"))
    end
end)

-- [[ FISH NAME DETECTOR ]] --
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            for _, v in pairs(lp.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and (v.Text:find("mendapatkan") or v.Text:find("Caught")) then
                    lastFish = v.Text:gsub("Anda mendapatkan:", ""):gsub("<[^>]*>", "")
                end
            end
        end)
    end
end)

-- [[ BRUTAL ACTION BUTTON ]] --
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0.8, 0, 0, 40)
ActionBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ActionBtn.Text = "START BRUTAL"
ActionBtn.TextColor3 = Color3.new(1, 1, 1)
ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)

ActionBtn.MouseButton1Click:Connect(function()
    isBrutal = not isBrutal
    ActionBtn.Text = isBrutal and "BRUTAL ACTIVE" or "START BRUTAL"
    ActionBtn.BackgroundColor3 = isBrutal and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 0, 0)
end)

-- [[ ENGINE: REALTIME BRUTAL CLICKER ]] --
RunService.RenderStepped:Connect(function()
    if isBrutal then
        pcall(function()
            -- Mencari semua RemoteEvent yang berhubungan dengan pancingan
            for _, remote in pairs(game:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("fish") or remote.Name:lower():find("click") or remote.Name:lower():find("reel")) then
                    -- Mengirim sinyal tanpa jeda task.wait (Brutal Speed)
                    remote:FireServer(true, catchValue)
                    remote:FireServer(catchValue)
                end
            end
        end)
    end
end)

-- [[ DRAG LOGIC ]] --
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Main); drag(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
