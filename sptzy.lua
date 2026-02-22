-- [[ PHANTOM SQUARE: V7 ULTIMATE PAYLOAD & SUCCESS LOGGER ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- [[ SETTINGS & PAYLOAD ]] --
local LocalPlayer = Players.LocalPlayer
local myUserId = LocalPlayer.UserId
local payloadMessage = "Notification by sptzyy | ID: " .. myUserId
local waitTime = 0.15 -- Kecepatan gilir (0.15 detik)

local isLooping = false
local foundRemotes = {}
local successCount = 0

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SptzyyLogV7"

-- TOGGLE BUTTON
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, 0)
OpenBtn.Text = "LOG"
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
OpenBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- MAIN PANEL
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 200, 0)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "V7 PAYLOAD & LOGGER"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.15, 0)
Status.Text = "Logger: Waiting for Scan..."
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code

-- BUTTONS
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.85, 0, 0, 45)
ScanBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
ScanBtn.Text = "1. SCAN REPLICATED"
ScanBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ScanBtn)

local ForceBtn = Instance.new("TextButton", Main)
ForceBtn.Size = UDim2.new(0.85, 0, 0, 45)
ForceBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
ForceBtn.Text = "2. RUN BRUTE-FORCE"
ForceBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 0)
ForceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ForceBtn)

-- CONSOLE MOCKUP (DI UI)
local LogBox = Instance.new("ScrollingFrame", Main)
LogBox.Size = UDim2.new(0.85, 0, 0, 120)
LogBox.Position = UDim2.new(0.075, 0, 0.65, 0)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.CanvasSize = UDim2.new(0, 0, 5, 0)

local LogList = Instance.new("UIListLayout", LogBox)
LogList.Padding = UDim.new(0, 2)

local function addToLog(msg, color)
    local l = Instance.new("TextLabel", LogBox)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = " > " .. msg
    l.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextSize = 12
    l.Font = Enum.Font.Code
    LogBox.CanvasPosition = Vector2.new(0, LogBox.CanvasSize.Y.Offset)
end

---

-- LOGIKA SCAN
ScanBtn.MouseButton1Click:Connect(function()
    foundRemotes = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            table.insert(foundRemotes, v)
        end
    end
    Status.Text = "SCAN: " .. #foundRemotes .. " REMOTES READY"
    addToLog("Scanned " .. #foundRemotes .. " remotes.", Color3.fromRGB(0, 255, 255))
end)

-- LOGIKA BRUTE-FORCE + LOGGER
local function startBruteForce()
    while isLooping do
        for i, remote in pairs(foundRemotes) do
            if not isLooping then break end
            
            local success, err = pcall(function()
                -- Payload Variasi
                remote:FireServer(payloadMessage)
                remote:FireServer(myUserId, payloadMessage)
                remote:FireServer("Notify", payloadMessage)
            end)
            
            if success then
                successCount = successCount + 1
                addToLog("SUCCESS: " .. remote.Name, Color3.fromRGB(0, 255, 0))
                -- Juga kirim ke konsol asli (F9)
                print("[!] Payload Sent to: " .. remote.GetFullName(remote))
            else
                addToLog("FAILED: " .. remote.Name, Color3.fromRGB(255, 0, 0))
            end
            
            Status.Text = "TOTAL SUCCESS: " .. successCount
            task.wait(waitTime)
        end
        task.wait(1)
    end
end

ForceBtn.MouseButton1Click:Connect(function()
    if #foundRemotes == 0 then return end
    
    isLooping = not isLooping
    if isLooping then
        ForceBtn.Text = "STOPPING..."
        ForceBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        addToLog("Starting Brute-Force...", Color3.fromRGB(255, 255, 0))
        task.spawn(startBruteForce)
    else
        ForceBtn.Text = "2. RUN BRUTE-FORCE"
        ForceBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 0)
        addToLog("Stopped.", Color3.fromRGB(255, 100, 100))
    end
end)

-- Basic Drag & Toggle
local d=false;local s,p;Main.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true;s=i.Position;p=Main.Position end end)
UserInputService.InputChanged:Connect(function(i)if d and i.UserInputType==Enum.UserInputType.MouseMovement then local delta=i.Position-s;Main.Position=UDim2.new(p.X.Scale,p.X.Offset+delta.X,p.Y.Scale,p.Y.Offset+delta.Y)end end)
Main.InputEnded:Connect(function()d=false end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
