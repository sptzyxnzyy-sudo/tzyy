local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup
if CoreGui:FindFirstChild("IkyyPremium_V8") then CoreGui:FindFirstChild("IkyyPremium_V8"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V8"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- UI Helpers
local function AddCorner(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = p end
local function MakeDraggable(f)
    local d, di, ds, sp
    f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = f.Position end end)
    f.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
    UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Parent = ScreenGui
AddCorner(MainFrame, 15)
MakeDraggable(MainFrame)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
Title.Text = "IKYY AUTO-SCANNER V8"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Scrolling Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -140)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Footer / Real-time Logs
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 50)
Footer.Position = UDim2.new(0, 0, 1, -55)
Footer.Text = "MONITORING SERVER EVENTS..."
Footer.TextColor3 = Color3.fromRGB(0, 255, 150)
Footer.Font = Enum.Font.Code
Footer.TextSize = 9
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

-- PAYLOADS
local Payloads = {"Buy", "Purchase", "Get", 1, true, {["Action"]="Buy"}, "All"}
local Toggles = { Engine = false }

-- UI: ENGINE SWITCH
local function CreateEngineSwitch()
    local Sw = Instance.new("TextButton")
    Sw.Size = UDim2.new(1, -10, 0, 40)
    Sw.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Sw.Text = "PAYLOAD ENGINE: OFF"
    Sw.TextColor3 = Color3.fromRGB(200, 200, 200)
    Sw.Font = Enum.Font.GothamBold
    Sw.TextSize = 11
    Sw.Parent = Scroll
    AddCorner(Sw, 10)

    Sw.MouseButton1Click:Connect(function()
        Toggles.Engine = not Toggles.Engine
        Sw.Text = Toggles.Engine and "PAYLOAD ENGINE: ACTIVE" or "PAYLOAD ENGINE: OFF"
        Sw.TextColor3 = Toggles.Engine and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
        Footer.Text = Toggles.Engine and "ENGINE READY FOR INJECTION" or "ENGINE IDLE"
    end)
end

-- FUNCTION: INJECT AUTO-GENERATED REMOTE
local function Inject(remote)
    if not Toggles.Engine then 
        Footer.Text = "SYSTEM: ENABLE ENGINE FIRST!"
        Footer.TextColor3 = Color3.fromRGB(255, 50, 50)
        return 
    end

    Title.Text = "BYPASSING..."
    Footer.Text = "INJECTING PAYLOAD TO: " .. remote.Name
    
    for _, p in pairs(Payloads) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(p)
                remote:FireServer(p, 1)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(p)
            end
        end)
    end

    task.wait(1)
    Title.Text = "IKYY AUTO-SCANNER V8"
    Footer.Text = "SUCCESS: PACKET SENT TO " .. remote.Name
    Footer.TextColor3 = Color3.fromRGB(0, 255, 255)
end

-- FUNCTION: ADD REMOTE TO UI
local function AddToUI(remote)
    if Scroll:FindFirstChild(remote.Name) then return end
    
    local Btn = Instance.new("TextButton")
    Btn.Name = remote.Name
    Btn.Size = UDim2.new(1, -5, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.Text = "  " .. remote.Name .. " (" .. remote.ClassName .. ")"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 10
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Scroll
    AddCorner(Btn, 8)

    local Tag = Instance.new("TextLabel")
    Tag.Text = "AUTO-GEN"
    Tag.Size = UDim2.new(0, 60, 1, 0)
    Tag.Position = UDim2.new(1, -65, 0, 0)
    Tag.TextColor3 = Color3.fromRGB(0, 255, 255)
    Tag.Font = Enum.Font.GothamBold
    Tag.TextSize = 8
    Tag.BackgroundTransparency = 1
    Tag.Parent = Btn

    Btn.MouseButton1Click:Connect(function() Inject(remote) end)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end

-- REAL-TIME MONITORING LOGIC
local function StartMonitoring(folder)
    folder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            Footer.Text = "NEW REMOTE DETECTED: " .. child.Name
            Footer.TextColor3 = Color3.fromRGB(255, 255, 0)
            AddToUI(child)
            task.wait(1)
            Footer.TextColor3 = Color3.fromRGB(0, 255, 150)
        end
    end)
end

-- INITIAL SCAN & START LISTENERS
CreateEngineSwitch()

-- Scan ReplicatedStorage & Workspace
local targets = {ReplicatedStorage, game:GetService("Workspace")}
for _, area in pairs(targets) do
    for _, v in pairs(area:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            AddToUI(v)
        end
    end
    StartMonitoring(area)
end

-- Rainbow Pulse
RunService.RenderStepped:Connect(function()
    Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)
end)

print("IkyyPremium V8 Final: Auto-Generated Scanner Active!")
