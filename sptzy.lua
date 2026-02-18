-- [[ PHANTOM SQUARE: ULTRA TURBO & ANTI-FRAME ]] --
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
ScreenGui.Name = "PhantomUltra"
ScreenGui.ResetOnSpawn = false

-- [[ DRAGGABLE ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenBtn.Text = "⚡"
OpenBtn.TextSize = 25
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- [[ SQUARE MAIN FRAME ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 180) 
Main.Position = UDim2.new(0.5, -90, 0.4, -90)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 255)

-- [[ OPTIMIZED STATUS ]] --
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 60)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.Code
Status.TextSize = 8
Status.Text = "SYSTEM OPTIMIZED"

task.spawn(function()
    while task.wait(0.5) do
        local p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        Status.Text = string.format("PING: %dms\nFISH: %s\nMODE: %s", 
            p, lastFish, (isBrutal and "ULTRA-FAST" or "IDLE"))
    end
end)

-- [[ FISH LOG DETECTOR ]] --
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            for _, v in pairs(lp.PlayerGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and (v.Text:find("mendapatkan") or v.Text:find("Shiny")) then
                    lastFish = v.Text:gsub("Anda mendapatkan:", ""):gsub("<[^>]*>", "")
                end
            end
        end)
    end
end)

-- [[ ULTRA-FAST ACTION BUTTON ]] --
local ActionBtn = Instance.new("TextButton", Main)
ActionBtn.Size = UDim2.new(0.8, 0, 0, 35)
ActionBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ActionBtn.Text = "START TURBO"
ActionBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn)
local BtnStroke = Instance.new("UIStroke", ActionBtn)
BtnStroke.Color = Color3.fromRGB(0, 255, 255)

ActionBtn.MouseButton1Click:Connect(function()
    isBrutal = not isBrutal
    ActionBtn.Text = isBrutal and "TURBO ON" or "START TURBO"
    ActionBtn.TextColor3 = isBrutal and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 255, 255)
    ActionBtn.BackgroundColor3 = isBrutal and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(20, 20, 30)
end)

-- [[ ENGINE: ANTI-FRAME TURBO CLICKER ]] --
-- Menggunakan Heartbeat untuk stabilitas frame rate tinggi
RunService.Heartbeat:Connect(function()
    if isBrutal then
        pcall(function()
            -- Mencari Remote secara spesifik untuk alur Klik & Tarik
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local name = v.Name:lower()
                    if name:find("click") or name:find("fish") or name:find("reel") or name:find("cast") then
                        -- Mengirim sinyal berantai secara realtime
                        v:FireServer(true, catchValue)
                        v:FireServer(catchValue)
                    end
                end
            end
        end)
    end
end)

-- [[ DRAG SUPPORT ]] --
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then s = false end end)
end
drag(Main); drag(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
