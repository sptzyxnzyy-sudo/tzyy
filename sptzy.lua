-- [[ PHANTOM SQUARE: ULTRA TURBO & ANTI-FRAME ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local lp = game:GetService("Players").LocalPlayer

local isBrutal = false
local catchValue = 100
local lastFish = "None"
local remoteCache = {}

-- [[ FUNGSI PENCARI REMOTE (OPTIMIZED) ]] --
local function refreshRemotes()
    remoteCache = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local name = v.Name:lower()
            if name:find("click") or name:find("fish") or name:find("reel") or name:find("cast") then
                table.insert(remoteCache, v)
            end
        end
    end
end
refreshRemotes()

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomUltra_V2"
ScreenGui.ResetOnSpawn = false

-- [[ DRAGGABLE ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenBtn.Text = "⚡"
OpenBtn.TextSize = 25
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- [[ SQUARE MAIN FRAME ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 200) 
Main.Position = UDim2.new(0.5, -90, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
Main.Visible = false
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [[ OPTIMIZED STATUS ]] --
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 80)
Status.Position = UDim2.new(0, 0, 0, 10)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.Code
Status.TextSize = 10
Status.Text = "INITIALIZING..."

task.spawn(function()
    while task.wait(0.5) do
        local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Status.Text = string.format("PING: %dms\nLAST: %s\nMODE: %s\nFPS: %d", 
            p, lastFish:sub(1, 15), (isBrutal and "ULTRA-TURBO" or "IDLE"), math.floor(game:GetService("Workspace"):GetRealPhysicsFPS()))
    end
end)

-- [[ FISH LOG DETECTOR ]] --
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            for _, v in pairs(lp.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible then
                    local txt = v.Text:lower()
                    if txt:find("mendapatkan") or txt:find("caught") or txt:find("shiny") then
                        lastFish = v.Text:gsub("<[^>]*>", ""):gsub("Anda mendapatkan:", "")
                    end
                end
            end
        end)
    end
end)

-- [[ ACTION BUTTON ]] --
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0.85, 0, 0, 40)
ActionBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
ActionBtn.Text = "START TURBO"
ActionBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ActionBtn.Font = Enum.Font.GothamBold
ActionBtn.TextSize = 14
Instance.new("UICorner", ActionBtn)
local BtnStroke = Instance.new("UIStroke", ActionBtn)
BtnStroke.Color = Color3.fromRGB(0, 255, 255)

ActionBtn.MouseButton1Click:Connect(function()
    isBrutal = not isBrutal
    if isBrutal then
        refreshRemotes() -- Refresh remote saat start untuk memastikan validitas
        ActionBtn.Text = "TURBO ACTIVE"
        ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120)
    else
        ActionBtn.Text = "START TURBO"
        ActionBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        ActionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    end
end)

-- [[ ENGINE: ANTI-FRAME TURBO CLICKER ]] --
RunService.Heartbeat:Connect(function()
    if isBrutal then
        for i = 1, #remoteCache do
            local remote = remoteCache[i]
            if remote and remote.Parent then
                -- Menggunakan pcall minimalis agar tidak drop FPS
                task.spawn(function()
                    remote:FireServer(true, catchValue)
                    remote:FireServer(catchValue)
                end)
            end
        end
    end
end)

-- [[ DRAG SUPPORT ]] --
local function drag(o)
    local dragging, input, startPos, startObjPos
    o.InputBegan:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; startPos = inp.Position; startObjPos = o.Position
        end
    end)
    o.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - startPos
            o.Position = UDim2.new(startObjPos.X.Scale, startObjPos.X.Offset + delta.X, startObjPos.Y.Scale, startObjPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then dragging = false end
    end)
end

drag(Main); drag(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("PHANTOM SQUARE LOADED - ANTI FRAME ENABLED")
