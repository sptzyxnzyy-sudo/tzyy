local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup UI
if CoreGui:FindFirstChild("IkyyPremium_V10") then CoreGui:FindFirstChild("IkyyPremium_V10"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V10"
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
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
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
Title.Text = "IKYY SMART INJECTOR V10"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Scrolling Frame (Auto-Expand)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -100)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Auto Scroll Logic
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- Footer Status
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.Text = "TAP ITEM TO START/STOP INJECTION"
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.Font = Enum.Font.Code
Footer.TextSize = 9
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

-- Global Payloads
local Payloads = {"Buy", "Purchase", 1, true, {["Action"]="Buy"}, 999999}
local ActiveRemotes = {} -- Tabel untuk menyimpan status ON/OFF tiap remote

-- FUNCTION: ADD PRODUCT WITH TOGGLE LOGIC
local function AddSmartProduct(remote)
    if Scroll:FindFirstChild(remote.Name) then return end
    
    local Btn = Instance.new("TextButton")
    Btn.Name = remote.Name
    Btn.Size = UDim2.new(1, -5, 0, 50)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Btn.Text = "  " .. remote.Name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Scroll
    AddCorner(Btn, 10)

    local StatusTag = Instance.new("TextLabel")
    StatusTag.Text = "IDLE"
    StatusTag.Size = UDim2.new(0, 60, 1, 0)
    StatusTag.Position = UDim2.new(1, -65, 0, 0)
    StatusTag.TextColor3 = Color3.fromRGB(80, 80, 80)
    StatusTag.Font = Enum.Font.GothamBold
    StatusTag.TextSize = 9
    StatusTag.BackgroundTransparency = 1
    StatusTag.Parent = Btn

    -- Logic Click Toggle
    Btn.MouseButton1Click:Connect(function()
        ActiveRemotes[remote] = not ActiveRemotes[remote]
        local isON = ActiveRemotes[remote]

        if isON then
            -- Visual ON
            Btn.BackgroundColor3 = Color3.fromRGB(0, 40, 40)
            Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
            StatusTag.Text = "RUNNING"
            StatusTag.TextColor3 = Color3.fromRGB(0, 255, 255)
            Footer.Text = "INJECTING: " .. remote.Name
            
            -- Loop Injection Logic
            task.spawn(function()
                while ActiveRemotes[remote] do
                    for _, p in pairs(Payloads) do
                        if not ActiveRemotes[remote] then break end
                        pcall(function()
                            if remote:IsA("RemoteEvent") then remote:FireServer(p)
                            elseif remote:IsA("RemoteFunction") then remote:InvokeServer(p) end
                        end)
                    end
                    task.wait(1.5) -- Delay per cycle agar tidak kick
                end
            end)
            
            -- Success Message Visual
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[IKYY-V10]: Started Loop for " .. remote.Name;
                Color = Color3.fromRGB(0, 255, 255);
                Font = Enum.Font.GothamBold;
            })
        else
            -- Visual OFF
            Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            StatusTag.Text = "IDLE"
            StatusTag.TextColor3 = Color3.fromRGB(80, 80, 80)
            Footer.Text = "STOPPED: " .. remote.Name
            
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[IKYY-V10]: Stopped Loop for " .. remote.Name;
                Color = Color3.fromRGB(255, 50, 50);
                Font = Enum.Font.GothamBold;
            })
        end
    end)
end

-- INITIAL SCAN & AUTO-SYNC
local function FullScan()
    local targets = {ReplicatedStorage, game:GetService("Workspace")}
    for _, area in pairs(targets) do
        for _, v in pairs(area:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local n = v.Name:lower()
                if n:find("buy") or n:find("shop") or n:find("purchase") or n:find("remote") or n:find("item") then
                    AddSmartProduct(v)
                end
            end
        end
        -- Auto-add if server creates new remote
        area.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                AddSmartProduct(child)
            end
        end)
    end
end

-- Rainbow Pulse
RunService.RenderStepped:Connect(function()
    Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)
end)

task.spawn(FullScan)
print("IkyyPremium V10: Smart Toggle & Auto-Expand Loaded!")
