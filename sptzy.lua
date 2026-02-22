-- [[ PHANTOM SQUARE: V8 WIDE STEALTH SCANNER ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- [[ SETTINGS ]] --
local LocalPlayer = Players.LocalPlayer
local waitTime = 0.1 -- Kecepatan scanning (0.1 detik)
local isLooping = false
local foundRemotes = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SptzyyWideV8"

-- TOGGLE ICON
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, 0)
OpenBtn.Text = "V8"
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
OpenBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 170, 255)

-- MAIN PANEL (DIPERLEBAR)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 400) -- Luas 450px
Main.Position = UDim2.new(0.5, -225, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.Visible = false
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "STEALTH REMOTE BRUTE-FORCE V8"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.12, 0)
Status.Text = "System Idle - Waiting for Scan"
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code

-- BUTTONS
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 40)
ScanBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ScanBtn.Text = "SCAN REPLICATED STORAGE"
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", ScanBtn)

local ForceBtn = Instance.new("TextButton", Main)
ForceBtn.Size = UDim2.new(0.9, 0, 0, 40)
ForceBtn.Position = UDim2.new(0.05, 0, 0.38, 0)
ForceBtn.Text = "START BRUTE-FORCE (STEALTH)"
ForceBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 120)
ForceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ForceBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", ForceBtn)

-- CONSOLE LOG (WIDE)
local LogBox = Instance.new("ScrollingFrame", Main)
LogBox.Size = UDim2.new(0.9, 0, 0, 160)
LogBox.Position = UDim2.new(0.05, 0, 0.55, 0)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
LogBox.CanvasSize = UDim2.new(0, 0, 10, 0)
LogBox.ScrollBarThickness = 4

local LogList = Instance.new("UIListLayout", LogBox)
LogList.Padding = UDim.new(0, 2)

local function addToLog(msg, color)
    local l = Instance.new("TextLabel", LogBox)
    l.Size = UDim2.new(1, -10, 0, 20)
    l.Text = " [LOG] " .. msg
    l.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextSize = 11
    l.Font = Enum.Font.Code
    LogBox.CanvasPosition = Vector2.new(0, LogBox.CanvasSize.Y.Offset)
end

---

-- LOGIKA SCAN (Tanpa Payload Pesan)
ScanBtn.MouseButton1Click:Connect(function()
    foundRemotes = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            table.insert(foundRemotes, v)
        end
    end
    Status.Text = "FOUND " .. #foundRemotes .. " REMOTES"
    addToLog("Scan complete. " .. #foundRemotes .. " remotes detected.", Color3.fromRGB(0, 255, 255))
end)

-- LOGIKA BRUTE-FORCE (Stealth Mode)
local function startBruteForce()
    while isLooping do
        for i, remote in pairs(foundRemotes) do
            if not isLooping then break end
            
            local success, _ = pcall(function()
                -- Menembak tanpa argumen (Hanya trigger)
                remote:FireServer()
            end)
            
            if success then
                addToLog("Fired: " .. remote.Name, Color3.fromRGB(0, 255, 100))
                print("[V8] Successfully triggered: " .. remote:GetFullName())
            else
                addToLog("Blocked: " .. remote.Name, Color3.fromRGB(255, 80, 80))
            end
            
            task.wait(waitTime)
        end
        task.wait(0.5)
    end
end

ForceBtn.MouseButton1Click:Connect(function()
    if #foundRemotes == 0 then 
        Status.Text = "ERROR: Scan Remotes First!"
        return 
    end
    
    isLooping = not isLooping
    if isLooping then
        ForceBtn.Text = "STOPPING..."
        ForceBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        addToLog("Brute-Force started...", Color3.fromRGB(255, 255, 0))
        task.spawn(startBruteForce)
    else
        ForceBtn.Text = "START BRUTE-FORCE (STEALTH)"
        ForceBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 120)
        addToLog("Brute-Force paused.", Color3.fromRGB(200, 200, 200))
    end
end)

-- SISTEM GESER GUI (Drag Logic Luas)
local d = false; local s, p;
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        d = true; s = i.Position; p = Main.Position 
    end 
end)
UserInputService.InputChanged:Connect(function(i)
    if d and i.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = i.Position - s
        Main.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
    end 
end)
Main.InputEnded:Connect(function() d = false end)

-- SISTEM GESER TOMBOL OPEN
local d2 = false; local s2, p2;
OpenBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
        d2 = true; s2 = i.Position; p2 = OpenBtn.Position 
    end 
end)
UserInputService.InputChanged:Connect(function(i)
    if d2 and i.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = i.Position - s2
        OpenBtn.Position = UDim2.new(p2.X.Scale, p2.X.Offset + delta.X, p2.Y.Scale, p2.Y.Offset + delta.Y)
    end 
end)
OpenBtn.InputEnded:Connect(function() d2 = false end)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
