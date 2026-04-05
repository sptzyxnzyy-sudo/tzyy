local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Cleanup
if CoreGui:FindFirstChild("Ikyy_TargetV24") then CoreGui:FindFirstChild("Ikyy_TargetV24"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_TargetV24"
ScreenGui.Parent = CoreGui

-- Main UI Design
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 250, 0, 350)
Main.Position = UDim2.new(0.5, -125, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Parent = ScreenGui
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 15) Corner.Parent = Main
local Stroke = Instance.new("UIStroke") Stroke.Thickness = 2 Stroke.Color = Color3.fromRGB(255, 0, 50) Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "IKYY TARGET FLING V24"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 5)

-- LOGIKA CORE: FLING & HEADSIT
local SelectedTarget = nil

local function KillTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if hrp and targetHRP then
        -- 1. Auto Headsit Logic (Teleport ke kepala target agar posisi pas)
        hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 1.5, 0)
        
        -- 2. Force Physics (Velocity Overload)
        local Velocity = Instance.new("BodyAngularVelocity")
        Velocity.Name = "FlingForce"
        Velocity.Parent = hrp
        Velocity.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        Velocity.P = 10^12
        Velocity.AngularVelocity = Vector3.new(9e9, 9e9, 9e9)
        
        -- 3. Collision Anti-Self Fling
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        hrp.CanCollide = true
        
        -- Berikan dorongan selama 1 detik lalu matikan agar kamu tidak out
        task.wait(0.5)
        Velocity:Destroy()
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

-- UI PLAYER LIST GENERATOR
local function UpdateList()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            Btn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
            Btn.TextColor3 = Color3.new(1, 1, 1)
            Btn.Font = Enum.Font.GothamSemibold
            Btn.TextSize = 10
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Scroll
            local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(0, 5) BCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
                Btn.Text = "  KILLING: " .. p.Name:upper()
                KillTarget(p)
                task.wait(0.5)
                Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                Btn.Text = "  " .. p.DisplayName
            end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end

-- Refresh List
UpdateList()
Players.PlayerAdded:Connect(UpdateList)
Players.PlayerRemoving:Connect(UpdateList)

-- Draggable UI
local d, di, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
