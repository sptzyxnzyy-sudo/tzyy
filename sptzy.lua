local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup UI Lama
if CoreGui:FindFirstChild("IkyyPremium_V6") then
    CoreGui:FindFirstChild("IkyyPremium_V6"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V6"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Helper Functions
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
MainFrame.Size = UDim2.new(0, 280, 0, 420)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
MainFrame.Parent = ScreenGui
AddCorner(MainFrame, 12)
MakeDraggable(MainFrame)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Transparency = 0.4
Stroke.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
Title.Text = "IKYY PREMIUM V6"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Scrolling Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -110)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Footer Status
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 1, -35)
Footer.Text = "SYSTEM: READY"
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.Font = Enum.Font.Code
Footer.TextSize = 10
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

-- State Management
local Toggles = { FakeDonate = false }

-- 1. FUNCTION: CREATE SWITCH (Top Section)
local function CreateSwitch(name, callback)
    local Sw = Instance.new("Frame")
    Sw.Size = UDim2.new(1, 0, 0, 40)
    Sw.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Sw.Parent = Scroll
    AddCorner(Sw, 8)

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = name:upper()
    Lbl.Size = UDim2.new(1, -50, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 11
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.BackgroundTransparency = 1
    Lbl.Parent = Sw

    local Tgl = Instance.new("TextButton")
    Tgl.Size = UDim2.new(0, 34, 0, 16)
    Tgl.Position = UDim2.new(1, -44, 0.5, -8)
    Tgl.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Tgl.Text = ""
    Tgl.Parent = Sw
    AddCorner(Tgl, 10)

    local Circ = Instance.new("Frame")
    Circ.Size = UDim2.new(0, 12, 0, 12)
    Circ.Position = UDim2.new(0, 2, 0.5, -6)
    Circ.BackgroundColor3 = Color3.new(1, 1, 1)
    Circ.Parent = Tgl
    AddCorner(Circ, 10)

    Tgl.MouseButton1Click:Connect(function()
        Toggles[name] = not Toggles[name]
        local s = Toggles[name]
        TweenService:Create(Circ, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        TweenService:Create(Tgl, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)}):Play()
        callback(s)
    end)
end

-- Section Separator
local function CreateSeparator(text)
    local Sep = Instance.new("TextLabel")
    Sep.Text = "—— " .. text .. " ——"
    Sep.Size = UDim2.new(1, 0, 0, 25)
    Sep.TextColor3 = Color3.fromRGB(80, 80, 80)
    Sep.Font = Enum.Font.GothamBold
    Sep.TextSize = 9
    Sep.BackgroundTransparency = 1
    Sep.Parent = Scroll
end

-- 2. FUNCTION: CREATE PRODUCT ITEM (Bottom Section)
local function AddProduct(remoteObj)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    Btn.Text = "  " .. remoteObj.Name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Scroll
    AddCorner(Btn, 8)

    local StrokeBtn = Instance.new("UIStroke")
    StrokeBtn.Thickness = 1
    StrokeBtn.Color = Color3.fromRGB(40, 40, 45)
    StrokeBtn.Parent = Btn

    local ExecuteTag = Instance.new("TextLabel")
    ExecuteTag.Text = "FAKE BUY"
    ExecuteTag.Size = UDim2.new(0, 60, 1, 0)
    ExecuteTag.Position = UDim2.new(1, -65, 0, 0)
    ExecuteTag.TextColor3 = Color3.fromRGB(0, 255, 255)
    ExecuteTag.Font = Enum.Font.GothamBold
    ExecuteTag.TextSize = 9
    ExecuteTag.BackgroundTransparency = 1
    ExecuteTag.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        if not Toggles["FakeDonate"] then
            Footer.Text = "ERR: ENABLE SWITCH FIRST!"
            Footer.TextColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(1)
            Footer.Text = "SYSTEM: READY"
            Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
            return
        end

        -- Logic Scan & Execute
        Title.Text = "INJECTING..."
        Footer.Text = "SENDING PACKET TO: " .. remoteObj.Name
        task.wait(1)

        pcall(function()
            if remoteObj:IsA("RemoteEvent") then remoteObj:FireServer("Purchase_Request", 1)
            elseif remoteObj:IsA("RemoteFunction") then remoteObj:InvokeServer("Purchase_Request", 1) end
        end)

        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[SERVER]: Verified Transaction for " .. remoteObj.Name .. " Success!";
            Color = Color3.fromRGB(0, 255, 255);
            Font = Enum.Font.GothamBold;
        })

        Title.Text = "SUCCESS ✅"
        task.wait(1.5)
        Title.Text = "IKYY PREMIUM V6"
    end)
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end

-- INITIALIZE UI STRUCTURE
CreateSeparator("MAIN CONTROLS")
CreateSwitch("FakeDonate", function(s)
    Footer.Text = s and "INJECTOR: ACTIVE" or "INJECTOR: IDLE"
end)

CreateSeparator("DETECTED PRODUCTS (REMOTES)")

-- Auto Scan Remotes
local function Scan()
    local found = 0
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("buy") or n:find("shop") or n:find("purchase") or n:find("item") or n:find("remote") then
                AddProduct(v)
                found = found + 1
            end
        end
    end
    if found == 0 then
        Footer.Text = "NO SHOP REMOTES FOUND"
    else
        Footer.Text = "SCAN COMPLETE: " .. found .. " REMOTES"
    end
end

-- Rainbow Effect
RunService.RenderStepped:Connect(function()
    Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)
end)

-- Execute
task.spawn(Scan)
print("IkyyPremium V6 Loaded!")
