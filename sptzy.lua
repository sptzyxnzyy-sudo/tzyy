local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Cleanup
if CoreGui:FindFirstChild("Ikyy_Fling_V23") then CoreGui:FindFirstChild("Ikyy_Fling_V23"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_Fling_V23"
ScreenGui.Parent = CoreGui

-- UI Design (Cyber Red)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 140)
Main.Position = UDim2.new(0.5, -110, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(10, 5, 5)
Main.Parent = ScreenGui
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 15) Corner.Parent = Main
local Stroke = Instance.new("UIStroke") Stroke.Thickness = 3 Stroke.Color = Color3.fromRGB(255, 0, 0) Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "REAL FLING V23"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.Parent = Main

-- SWITCH COMPONENT
local SwitchBG = Instance.new("Frame")
SwitchBG.Size = UDim2.new(0, 80, 0, 35)
SwitchBG.Position = UDim2.new(0.5, -40, 0.5, 0)
SwitchBG.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
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
StatusLabel.Text = "READY TO FLING"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -25)
StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 10
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Main

-- LOGIKA FLING (SERVER-SIDE PHYSICS)
local FlingActive = false

local function StartFling()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Menambahkan Gaya Putar (Torque) Ekstrem
    local Velocity = Instance.new("BodyAngularVelocity")
    Velocity.Name = "IkyyForce"
    Velocity.Parent = hrp
    Velocity.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    Velocity.P = 10^10 -- Power tak terbatas
    Velocity.AngularVelocity = Vector3.new(9e9, 9e9, 9e9)

    -- Loop Sinkronisasi Posisi & Collision
    task.spawn(function()
        while FlingActive do
            RunService.Stepped:Wait()
            if not char or not hrp then break end
            
            -- Teknik "Ghost" agar tidak terpental sendiri tapi bisa melempar orang
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    -- Membuat massa part menjadi 0 agar tidak mengganggu putaran HRP
                    part.Velocity = Vector3.new(0, 50, 0) 
                end
            end
            hrp.CanCollide = true -- HRP wajib True untuk menabrak target
        end
        -- Hapus gaya saat dimatikan
        if Velocity then Velocity:Destroy() end
    end)
end

-- TOGGLE SWITCH
SwitchCircle.MouseButton1Click:Connect(function()
    FlingActive = not FlingActive
    
    if FlingActive then
        -- Visual ON
        SwitchCircle:TweenPosition(UDim2.new(0, 48, 0, 3), "Out", "Quad", 0.2)
        SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        SwitchBG.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        StatusLabel.Text = "FLING: ACTIVE (TABRAK TARGET!)"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        
        task.spawn(StartFling)
    else
        -- Visual OFF
        SwitchCircle:TweenPosition(UDim2.new(0, 3, 0, 3), "Out", "Quad", 0.2)
        SwitchCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        SwitchBG.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        StatusLabel.Text = "READY TO FLING"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- Draggable UI
local d, di, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
