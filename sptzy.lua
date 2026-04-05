local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Cleanup
if CoreGui:FindFirstChild("Ikyy_Fling_V22") then CoreGui:FindFirstChild("Ikyy_Fling_V22"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_Fling_V22"
ScreenGui.Parent = CoreGui

-- UI Design (Toxic Green - Alert Look)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 140)
Main.Position = UDim2.new(0.5, -110, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(5, 15, 5)
Main.Parent = ScreenGui
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 15) Corner.Parent = Main
local Stroke = Instance.new("UIStroke") Stroke.Thickness = 3 Stroke.Color = Color3.fromRGB(0, 255, 100) Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "SERVER FLING V22"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.Parent = Main

-- SWITCH COMPONENT
local SwitchBG = Instance.new("Frame")
SwitchBG.Size = UDim2.new(0, 80, 0, 35)
SwitchBG.Position = UDim2.new(0.5, -40, 0.5, 0)
SwitchBG.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
SwitchBG.Parent = Main
local SCorner = Instance.new("UICorner") SCorner.CornerRadius = UDim.new(1, 0) SCorner.Parent = SwitchBG

local SwitchCircle = Instance.new("TextButton")
SwitchCircle.Size = UDim2.new(0, 29, 0, 29)
SwitchCircle.Position = UDim2.new(0, 3, 0, 3)
SwitchCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
SwitchCircle.Text = ""
SwitchCircle.Parent = SwitchBG
local CCorner = Instance.new("UICorner") CCorner.CornerRadius = UDim.new(1, 0) CCorner.Parent = SwitchCircle

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "STABILIZED"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -25)
StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 10
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Main

-- LOGIKA FLING SERVER-SIDE (REPLICATED)
local FlingActive = false
local FlingPart = nil

local function CreateFlingPart()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Membuat BodyAngularVelocity untuk memutar karaktermu dengan sangat cepat
    -- Putaran inilah yang akan melempar orang lain saat bersentuhan
    local bAV = Instance.new("BodyAngularVelocity")
    bAV.Name = "FlingForce"
    bAV.Parent = hrp
    bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bAV.P = 1250000 -- Power
    
    return bAV
end

-- Loop Utama Fling
RunService.Stepped:Connect(function()
    if FlingActive then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- Memberikan gaya putar acak agar tidak bisa ditebak sistem anti-cheat
            local force = hrp:FindFirstChild("FlingForce") or CreateFlingPart()
            force.AngularVelocity = Vector3.new(999999, 999999, 999999)
            
            -- Menghilangkan gesekan kaki agar kamu bisa meluncur menabrak mereka
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Velocity = Vector3.new(0, 0, 0) -- Mencegah kamu sendiri terlempar keluar map
                end
            end
            hrp.CanCollide = true -- HRP tetap colide agar bisa menabrak orang
        end
    else
        -- Bersihkan gaya saat OFF
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("FlingForce") then
            hrp.FlingForce:Destroy()
        end
    end
end)

-- TOGGLE ACTION
SwitchCircle.MouseButton1Click:Connect(function()
    FlingActive = not FlingActive
    
    if FlingActive then
        SwitchCircle:TweenPosition(UDim2.new(0, 48, 0, 3), "Out", "Quad", 0.2)
        SwitchCircle.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        SwitchBG.BackgroundColor3 = Color3.fromRGB(0, 60, 20)
        StatusLabel.Text = "FLING: ACTIVE (TOUCH SOMEONE)"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        SwitchCircle:TweenPosition(UDim2.new(0, 3, 0, 3), "Out", "Quad", 0.2)
        SwitchCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        SwitchBG.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        StatusLabel.Text = "STABILIZED"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- Draggable UI
local d, di, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
