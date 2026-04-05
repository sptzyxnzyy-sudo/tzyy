local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup UI Lama
if CoreGui:FindFirstChild("IkyyPremium_V11") then 
    CoreGui:FindFirstChild("IkyyPremium_V11"):Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V11"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- UI Helpers
local function AddCorner(p, r) 
    local c = Instance.new("UICorner") 
    c.CornerRadius = UDim.new(0, r) 
    c.Parent = p 
end

local function MakeDraggable(f)
    local d, di, ds, sp
    f.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            d = true ds = i.Position sp = f.Position 
        end 
    end)
    f.InputChanged:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then 
            di = i 
        end 
    end)
    UserInputService.InputChanged:Connect(function(i) 
        if i == di and d then 
            local del = i.Position - ds 
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) 
        end 
    end)
    UserInputService.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            d = false 
        end 
    end)
end

-- Main Frame (Modern Cyberpunk)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
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
Title.Text = "IKYY PREMIUM V11 - FINAL"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Scrolling Frame (Infinite Scroll Logic)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -110)
Scroll.Position = UDim2.new(0, 10, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will auto-update
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Auto-Update Scroll Height
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end)

-- Footer Status
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -45)
Footer.Text = "ikyynih60 | SCANNING SERVER REMOTES..."
Footer.TextColor3 = Color3.fromRGB(120, 120, 120)
Footer.Font = Enum.Font.Code
Footer.TextSize = 9
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

-- Injection Payloads
local PayloadData = {"Buy", "Purchase", 1, true, {["Action"]="Buy"}, "All", 999999}
local RunningRemotes = {} -- Store individual toggle states

-- FUNCTION: CREATE TOGGLE ITEM
local function AddRemoteItem(remote)
    if Scroll:FindFirstChild(remote.Name) then return end
    
    local ItemBtn = Instance.new("TextButton")
    ItemBtn.Name = remote.Name
    ItemBtn.Size = UDim2.new(1, -5, 0, 50)
    ItemBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ItemBtn.Text = "  " .. remote.Name
    ItemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    ItemBtn.Font = Enum.Font.GothamSemibold
    ItemBtn.TextSize = 11
    ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
    ItemBtn.Parent = Scroll
    AddCorner(ItemBtn, 10)

    local StatusTxt = Instance.new("TextLabel")
    StatusTxt.Text = "READY"
    StatusTxt.Size = UDim2.new(0, 60, 1, 0)
    StatusTxt.Position = UDim2.new(1, -65, 0, 0)
    StatusTxt.TextColor3 = Color3.fromRGB(80, 80, 80)
    StatusTxt.Font = Enum.Font.GothamBold
    StatusTxt.TextSize = 9
    StatusTxt.BackgroundTransparency = 1
    StatusTxt.Parent = ItemBtn

    -- Logic Click Toggle (1x ON, 2x OFF)
    ItemBtn.MouseButton1Click:Connect(function()
        RunningRemotes[remote] = not RunningRemotes[remote]
        local isEnabled = RunningRemotes[remote]

        if isEnabled then
            -- Visual ON
            ItemBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 50)
            ItemBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
            StatusTxt.Text = "INJECTING"
            StatusTxt.TextColor3 = Color3.fromRGB(0, 255, 255)
            Footer.Text = "EXECUTING: " .. remote.Name
            
            -- Multi-Payload Loop
            task.spawn(function()
                while RunningRemotes[remote] do
                    for _, data in pairs(PayloadData) do
                        if not RunningRemotes[remote] then break end
                        pcall(function()
                            if remote:IsA("RemoteEvent") then 
                                remote:FireServer(data)
                                remote:FireServer(data, 1)
                            elseif remote:IsA("RemoteFunction") then 
                                remote:InvokeServer(data) 
                            end
                        end)
                    end
                    task.wait(1.5) -- Safe interval to prevent kick
                end
            end)
            
            -- Chat Notification
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[IKYY-V11]: Injection Loop Started -> " .. remote.Name;
                Color = Color3.fromRGB(0, 255, 255);
                Font = Enum.Font.GothamBold;
            })
        else
            -- Visual OFF
            ItemBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            ItemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            StatusTxt.Text = "READY"
            StatusTxt.TextColor3 = Color3.fromRGB(80, 80, 80)
            Footer.Text = "STOPPED: " .. remote.Name
            
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[IKYY-V11]: Injection Loop Stopped -> " .. remote.Name;
                Color = Color3.fromRGB(255, 50, 50);
                Font = Enum.Font.GothamBold;
            })
        end
    end)
end

-- REAL-TIME SERVER SCANNER
local function InitScanner()
    local count = 0
    local locations = {ReplicatedStorage, game:GetService("Workspace")}
    
    for _, folder in pairs(locations) do
        -- Scan Existing Remotes
        for _, obj in pairs(folder:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local n = obj.Name:lower()
                -- Smart Filter (Hanya ambil yang berhubungan dengan Shop/Donate/Item)
                if n:find("buy") or n:find("shop") or n:find("donate") or n:find("purchase") or n:find("item") or n:find("remote") then
                    AddRemoteItem(obj)
                    count = count + 1
                end
            end
        end
        
        -- Listen for Auto-Generated Remotes (Server-side creation)
        folder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                Footer.Text = "NEW SERVER REMOTE DETECTED!"
                AddRemoteItem(child)
            end
        end)
    end
    Footer.Text = "FOUND " .. count .. " SERVER PRODUCTS"
end

-- Rainbow Pulse Effect
RunService.RenderStepped:Connect(function()
    Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)
end)

-- Initialize
task.spawn(InitScanner)
print("IkyyPremium V11 Final Loaded!")
