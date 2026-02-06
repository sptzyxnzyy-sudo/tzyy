-- [[ SPTZYY ULTIMATE AUTO-EXECUTE WITH ANIMATION ]] --
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
local Corner = Instance.new("UICorner", MainFrame)

-- Glow Effect (Animasi Background)
local Glow = Instance.new("Frame", MainFrame)
Glow.Size = UDim2.new(1.5, 0, 1.5, 0)
Glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
Glow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Glow.BackgroundTransparency = 0.9
Glow.ZIndex = 0
Instance.new("UICorner", Glow, {CornerRadius = UDim.new(1, 0)})

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SYSTEM SCANNER V2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- Progress Bar Background
local BarBg = Instance.new("Frame", MainFrame)
BarBg.Size = UDim2.new(0.8, 0, 0, 10)
BarBg.Position = UDim2.new(0.1, 0, 0.45, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", BarBg)

-- Progress Bar Fill (Animasi)
local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
Instance.new("UICorner", BarFill)

-- Status Text
local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0.6, 0)
Status.Text = "WAITING FOR COMMAND..."
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Code
Status.TextSize = 12
Status.BackgroundTransparency = 1

-- [[ ANIMASI LOGIC ]] --

-- 1. Animasi Glow Berputar
task.spawn(function()
    while true do
        Glow.Rotation = Glow.Rotation + 1
        task.wait(0.02)
    end
end)

-- 2. Fungsi Proses Scan Animasi
local function startCoolLoop()
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then table.insert(remotes, v) end
    end

    for i, remote in ipairs(remotes) do
        local progress = i / #remotes
        Status.Text = "INJECTING: " .. remote.Name:sub(1, 15) .. "..."
        
        -- Animasi Bar yang halus
        TweenService:Create(BarFill, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Size = UDim2.new(progress, 0, 1, 0),
            BackgroundColor3 = Color3.fromHSV(progress * 0.3, 1, 1) -- Berubah warna dari Merah ke Hijau
        }):Play()

        -- EKSEKUSI CULIK (PAYLOAD)
        pcall(function()
            local payload = "local TS = game:GetService('TeleportService') for _,v in pairs(game.Players:GetPlayers()) do TS:Teleport(game.PlaceId, v) end"
            remote:FireServer(payload)
        end)

        task.wait(0.1) -- Kecepatan scan
    end
    
    Status.Text = "SCAN COMPLETE - BYPASS FAILED"
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- Button Trigger
local Btn = Instance.new("TextButton", MainFrame)
Btn.Size = UDim2.new(0.6, 0, 0, 35)
Btn.Position = UDim2.new(0.2, 0, 0.75, 0)
Btn.Text = "START ATTACK"
Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
Btn.TextColor3 = Color3.new(1, 1, 1)
Btn.Font = Enum.Font.GothamBold
Instance.new("UICorner", Btn)

Btn.MouseButton1Click:Connect(function()
    Btn:Destroy()
    startCoolLoop()
end)

-- Dragging logic
local d = false local s local p
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true s = i.Position p = MainFrame.Position end end)
game:GetService("UserInputService").InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - s MainFrame.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) end end)
game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
