local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup UI
if CoreGui:FindFirstChild("IkyyPremium_V12") then CoreGui:FindFirstChild("IkyyPremium_V12"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V12"
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
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Parent = ScreenGui
AddCorner(MainFrame, 15)
MakeDraggable(MainFrame)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
Title.Text = "IKYY SERVER TAKEOVER V12"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- List Section
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 0, 280)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 8)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- SERVER CONTROL PANEL (NEW)
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(1, -20, 0, 110)
ControlPanel.Position = UDim2.new(0, 10, 1, -120)
ControlPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ControlPanel.Parent = MainFrame
AddCorner(ControlPanel, 10)

local MsgInput = Instance.new("TextBox")
MsgInput.Size = UDim2.new(1, -20, 0, 35)
MsgInput.Position = UDim2.new(0, 10, 0, 10)
MsgInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MsgInput.PlaceholderText = "Masukkan Pesan Broadcast..."
MsgInput.Text = ""
MsgInput.TextColor3 = Color3.new(1, 1, 1)
MsgInput.Font = Enum.Font.Gotham
MsgInput.TextSize = 12
MsgInput.Parent = ControlPanel
AddCorner(MsgInput, 8)

local SendBtn = Instance.new("TextButton")
SendBtn.Size = UDim2.new(1, -20, 0, 40)
SendBtn.Position = UDim2.new(0, 10, 0, 55)
SendBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SendBtn.Text = "SEND TO ALL SERVERS"
SendBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SendBtn.Font = Enum.Font.GothamBold
SendBtn.TextSize = 12
SendBtn.Parent = ControlPanel
AddCorner(SendBtn, 8)

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -15)
Footer.Text = "READY | ikyynih60"
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.Font = Enum.Font.Code
Footer.TextSize = 8
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

-- LOGIKA: PAYLOAD BROADCAST
local function BroadcastMessage(text)
    if text == "" then return end
    Footer.Text = "ATTEMPTING SERVER BROADCAST..."
    Footer.TextColor3 = Color3.fromRGB(255, 255, 0)

    -- Mencari Remote yang berhubungan dengan Pengumuman/Chat
    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("chat") or n:find("msg") or n:find("announce") or n:find("admin") or n:find("say") or n:find("server") then
                pcall(function()
                    v:FireServer(text)
                    v:FireServer("All", text)
                    v:FireServer(LocalPlayer.Name, text)
                end)
                count = count + 1
            end
        end
    end

    -- Tampilkan Hasil ke User (Local Chat Feedback)
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = "[V12-BROADCAST]: Sent to " .. count .. " channels: " .. text;
        Color = Color3.fromRGB(0, 255, 255);
        Font = Enum.Font.GothamBold;
    })
    
    Footer.Text = "BROADCAST COMPLETE"
    Footer.TextColor3 = Color3.fromRGB(0, 255, 150)
    task.wait(2)
    Footer.Text = "READY | ikyynih60"
end

SendBtn.MouseButton1Click:Connect(function()
    BroadcastMessage(MsgInput.Text)
end)

-- LOGIKA: DETEKSI & KELOLA REMOTE
local RunningRemotes = {}

local function AddRemote(remote)
    if Scroll:FindFirstChild(remote.Name) then return end
    local Btn = Instance.new("TextButton")
    Btn.Name = remote.Name
    Btn.Size = UDim2.new(1, -5, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.Text = "  " .. remote.Name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Scroll
    AddCorner(Btn, 8)

    local Tag = Instance.new("TextLabel")
    Tag.Text = "IDLE"
    Tag.Size = UDim2.new(0, 60, 1, 0)
    Tag.Position = UDim2.new(1, -65, 0, 0)
    Tag.TextColor3 = Color3.fromRGB(80, 80, 80)
    Tag.Font = Enum.Font.GothamBold
    Tag.TextSize = 9
    Tag.BackgroundTransparency = 1
    Tag.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        RunningRemotes[remote] = not RunningRemotes[remote]
        if RunningRemotes[remote] then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 60, 60)
            Tag.Text = "ACTIVE"
            Tag.TextColor3 = Color3.fromRGB(0, 255, 255)
            task.spawn(function()
                while RunningRemotes[remote] do
                    pcall(function() remote:FireServer("Purchase", 1) end)
                    task.wait(1.5)
                end
            end)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Tag.Text = "IDLE"
            Tag.TextColor3 = Color3.fromRGB(80, 80, 80)
        end
    end)
end

-- Scanner Initialization
local function Init()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            AddRemote(v)
        end
    end
    ReplicatedStorage.ChildAdded:Connect(function(c)
        if c:IsA("RemoteEvent") then AddRemote(c) end
    end)
end

RunService.RenderStepped:Connect(function()
    Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)
end)

task.spawn(Init)
