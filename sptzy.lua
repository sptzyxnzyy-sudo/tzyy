local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup
if CoreGui:FindFirstChild("IkyyPremium_V7") then CoreGui:FindFirstChild("IkyyPremium_V7"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V7"
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
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.Parent = ScreenGui
AddCorner(MainFrame, 15)
MakeDraggable(MainFrame)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
Title.Text = "IKYY PAYLOAD INJECTOR V7"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Scrolling Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -130)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -45)
Footer.Text = "PAYLOAD STATUS: WAITING..."
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.Font = Enum.Font.Code
Footer.TextSize = 10
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

-- GLOBAL PAYLOAD LIST (Daftar Argumen Umum)
local UniversalPayloads = {
    "Purchase", "Buy", "BuyItem", "Unlock", "Equip", 1, true, 
    {["Action"] = "Buy"}, {["Item"] = "All"}, "AllItems", 999999
}

local Toggles = { InjectActive = false }

-- 1. SWITCH: GLOBAL INJECTOR
local function CreateSwitch(name, callback)
    local Sw = Instance.new("Frame")
    Sw.Size = UDim2.new(1, -5, 0, 45)
    Sw.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Sw.Parent = Scroll
    AddCorner(Sw, 10)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = "PAYLOAD ENGINE: OFF"
    Lbl.Size = UDim2.new(1, -60, 1, 0)
    Lbl.Position = UDim2.new(0, 15, 0, 0)
    Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 11
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1
    Lbl.Parent = Sw

    local Tgl = Instance.new("TextButton")
    Tgl.Size = UDim2.new(0, 40, 0, 20)
    Tgl.Position = UDim2.new(1, -50, 0.5, -10)
    Tgl.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Tgl.Text = ""
    Tgl.Parent = Sw
    AddCorner(Tgl, 12)

    local Circ = Instance.new("Frame")
    Circ.Size = UDim2.new(0, 16, 0, 16)
    Circ.Position = UDim2.new(0, 2, 0.5, -8)
    Circ.BackgroundColor3 = Color3.new(1, 1, 1)
    Circ.Parent = Tgl
    AddCorner(Circ, 10)

    Tgl.MouseButton1Click:Connect(function()
        Toggles[name] = not Toggles[name]
        local s = Toggles[name]
        Lbl.Text = s and "PAYLOAD ENGINE: ON" or "PAYLOAD ENGINE: OFF"
        Lbl.TextColor3 = s and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
        TweenService:Create(Circ, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(Tgl, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)}):Play()
        callback(s)
    end)
end

-- 2. LOGIKA: PAYLOAD INJECTION
local function InjectPayload(remoteObj)
    if not Toggles["InjectActive"] then 
        Footer.Text = "ERR: TURN ON PAYLOAD ENGINE!"
        Footer.TextColor3 = Color3.fromRGB(255, 50, 50)
        return 
    end

    Title.Text = "INJECTING..."
    Footer.Text = "SCANNING ARGUMENTS FOR: " .. remoteObj.Name
    Footer.TextColor3 = Color3.fromRGB(255, 255, 0)
    task.wait(1)

    -- Mencoba semua payload sampai ada yang "nyangkut"
    for _, payload in pairs(UniversalPayloads) do
        pcall(function()
            if remoteObj:IsA("RemoteEvent") then
                remoteObj:FireServer(payload)
                remoteObj:FireServer(payload, 1)
                remoteObj:FireServer(LocalPlayer.Name, payload)
            elseif remoteObj:IsA("RemoteFunction") then
                remoteObj:InvokeServer(payload)
            end
        end)
    end

    Title.Text = "PAYLOAD SENT! ✅"
    Footer.Text = "SUCCESS: PACKET BROADCASTED"
    Footer.TextColor3 = Color3.fromRGB(0, 255, 150)
    
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = "[IKYY-V7]: Payload Injection to " .. remoteObj.Name .. " Success!";
        Color = Color3.fromRGB(0, 255, 255);
        Font = Enum.Font.GothamBold;
    })

    task.wait(2)
    Title.Text = "IKYY PAYLOAD INJECTOR V7"
    Footer.Text = "SYSTEM READY"
    Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
end

-- 3. PRODUCT LIST GENERATOR
local function AddRemoteToList(remote)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 50)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Btn.Text = "  " .. remote.Name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Scroll
    AddCorner(Btn, 8)

    local Tag = Instance.new("TextLabel")
    Tag.Text = "PAYLOAD"
    Tag.Size = UDim2.new(0, 70, 1, 0)
    Tag.Position = UDim2.new(1, -75, 0, 0)
    Tag.TextColor3 = Color3.fromRGB(0, 255, 255)
    Tag.Font = Enum.Font.GothamBold
    Tag.TextSize = 9
    Tag.BackgroundTransparency = 1
    Tag.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        InjectPayload(remote)
    end)
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end

-- Initialize
CreateSwitch("InjectActive", function(s) end)

local function Scan()
    local count = 0
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("buy") or n:find("shop") or n:find("purchase") or n:find("remote") or n:find("sell") then
                AddRemoteToList(v)
                count = count + 1
            end
        end
    end
    Footer.Text = count > 0 and "FOUND " .. count .. " VULNERABLE REMOTES" or "NO REMOTES FOUND"
end

-- Rainbow Effect
RunService.RenderStepped:Connect(function()
    Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)
end)

task.spawn(Scan)
print("IkyyPremium V7 Loaded Successfully!")
