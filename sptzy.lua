-- [[ FISH IT: SONAR RADAR + INSTANT TELEPORT ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local isScanning = false
local foundSpots = {}
local nearestSpot = nil

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FishItSonarTP"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 280) -- Sedikit lebih tinggi untuk tombol TP
Main.Position = UDim2.new(0.5, -130, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "SONAR + TELEPORT"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

-- [[ MONITOR ]] --
local Monitor = Instance.new("Frame", Main)
Monitor.Size = UDim2.new(0.85, 0, 0, 90)
Monitor.Position = UDim2.new(0.075, 0, 0, 45)
Monitor.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
Instance.new("UICorner", Monitor)

local StatusTxt = Instance.new("TextLabel", Monitor)
StatusTxt.Size = UDim2.new(1, -16, 1, -16)
StatusTxt.Position = UDim2.new(0, 8, 0, 8)
StatusTxt.BackgroundTransparency = 1
StatusTxt.TextColor3 = Color3.fromRGB(0, 255, 255)
StatusTxt.Font = Enum.Font.Code
StatusTxt.TextSize = 10
StatusTxt.TextXAlignment = Enum.TextXAlignment.Left
StatusTxt.Text = "> RADAR: IDLE\n> NEAR: ---\n> DIST: 0m"

-- [[ TP FUNCTION ]] --
local function teleportTo(part)
    if part and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 3, 0)
    end
end

-- [[ SCANNER ENGINE ]] --
local function runScanner()
    for _, s in pairs(foundSpots) do
        if s.Part and s.Part:FindFirstChild("RadarTag") then s.Part.RadarTag:Destroy() end
    end
    foundSpots = {}

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local n = v.Name:lower()
            if n:find("secret") or n:find("rare") or n:find("hotspot") or n:find("special") or n:find("hidden") then
                local target = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or v
                if target then
                    -- Create ESP
                    local Billboard = Instance.new("BillboardGui", target)
                    Billboard.Name = "RadarTag"
                    Billboard.Size = UDim2.new(0, 150, 0, 60)
                    Billboard.AlwaysOnTop = true
                    Billboard.ExtentsOffset = Vector3.new(0, 4, 0)
                    
                    local Tag = Instance.new("TextLabel", Billboard)
                    Tag.Size = UDim2.new(1, 0, 1, 0)
                    Tag.BackgroundTransparency = 1
                    Tag.TextColor3 = Color3.fromRGB(0, 255, 255)
                    Tag.Font = Enum.Font.GothamBold
                    Tag.TextSize = 11
                    Tag.Text = v.Name:upper() .. "\n[ SCANNING ]"
                    
                    table.insert(foundSpots, {Part = target, Name = v.Name, Label = Tag})
                end
            end
        end
    end
end

-- [[ BUTTONS ]] --
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.85, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.075, 0, 0, 150)
ScanBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
ScanBtn.Text = "RUN RADAR SCAN"
ScanBtn.TextColor3 = Color3.new(1,1,1)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 10
Instance.new("UICorner", ScanBtn)

local TPBtn = Instance.new("TextButton", Main)
TPBtn.Size = UDim2.new(0.85, 0, 0, 45)
TPBtn.Position = UDim2.new(0.075, 0, 0, 200)
TPBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TPBtn.Text = "TELEPORT TO NEAREST"
TPBtn.TextColor3 = Color3.new(1,1,1)
TPBtn.Font = Enum.Font.GothamBold
TPBtn.TextSize = 11
Instance.new("UICorner", TPBtn)

-- [[ LOGIC ]] --
ScanBtn.MouseButton1Click:Connect(function()
    isScanning = not isScanning
    if isScanning then
        ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        ScanBtn.Text = "RADAR: ON"
        runScanner()
    else
        ScanBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
        ScanBtn.Text = "RUN RADAR SCAN"
        for _, s in pairs(foundSpots) do
            if s.Part:FindFirstChild("RadarTag") then s.Part.RadarTag:Destroy() end
        end
        foundSpots = {}
    end
end)

TPBtn.MouseButton1Click:Connect(function()
    if nearestSpot then
        teleportTo(nearestSpot.Part)
    end
end)

RunService.Heartbeat:Connect(function()
    if isScanning and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = lp.Character.HumanoidRootPart.Position
        local minDist = 9999
        nearestSpot = nil

        for _, spot in pairs(foundSpots) do
            if spot.Part and spot.Part.Parent then
                local dist = math.floor((myPos - spot.Part.Position).Magnitude)
                spot.Label.Text = spot.Name:upper() .. "\n[ " .. dist .. "m ]"
                if dist < minDist then
                    minDist = dist
                    nearestSpot = spot
                end
            end
        end
        
        if nearestSpot then
            StatusTxt.Text = string.format("> RADAR ACTIVE\n> NEAR: %s\n> DIST: %dm", nearestSpot.Name:upper(), minDist)
        end
    else
        StatusTxt.Text = "> RADAR: IDLE\n> READY TO SCAN"
    end
end)

-- [[ ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenBtn.Text = "SONAR"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 9
Instance.new("UICorner", OpenBtn)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 255, 255)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(OpenBtn); drag(Main)
