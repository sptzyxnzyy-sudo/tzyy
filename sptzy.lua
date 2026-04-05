local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Cleanup
if CoreGui:FindFirstChild("Ikyy_SkyTerminator_V21") then CoreGui:FindFirstChild("Ikyy_SkyTerminator_V21"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_SkyTerminator_V21"
ScreenGui.Parent = CoreGui

-- UI Design (Neon Pink/Red - Aggressive)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 140)
Main.Position = UDim2.new(0.5, -110, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(10, 0, 5)
Main.Parent = ScreenGui
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 15) Corner.Parent = Main
local Stroke = Instance.new("UIStroke") Stroke.Thickness = 3 Stroke.Color = Color3.fromRGB(255, 0, 100) Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "SKY TERMINATOR V21"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 0, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.Parent = Main

-- SWITCH COMPONENT
local SwitchBG = Instance.new("Frame")
SwitchBG.Size = UDim2.new(0, 100, 0, 40)
SwitchBG.Position = UDim2.new(0.5, -50, 0.5, 0)
SwitchBG.BackgroundColor3 = Color3.fromRGB(30, 20, 25)
SwitchBG.Parent = Main
local SCorner = Instance.new("UICorner") SCorner.CornerRadius = UDim.new(1, 0) SCorner.Parent = SwitchBG

local SwitchCircle = Instance.new("TextButton")
SwitchCircle.Size = UDim2.new(0, 34, 0, 34)
SwitchCircle.Position = UDim2.new(0, 3, 0, 3)
SwitchCircle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SwitchCircle.Text = ""
SwitchCircle.Parent = SwitchBG
local CCorner = Instance.new("UICorner") CCorner.CornerRadius = UDim.new(1, 0) CCorner.Parent = SwitchCircle

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "FLING: READY"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -25)
StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 10
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Main

-- LOGIKA YEET/FLING TO SKY
local FlingEnabled = false

local function SkyFling(otherPart)
    if not FlingEnabled then return end
    
    local character = otherPart.Parent
    -- Jika menyentuh part dalam model, cek parent-nya lagi (antisipasi aksesori)
    if not character:IsA("Model") then character = character.Parent end
    
    local player = Players:GetPlayerFromCharacter(character)
    
    if player and player ~= LocalPlayer then
        local targetHRP = character:FindFirstChild("HumanoidRootPart")
        
        if targetHRP then
            pcall(function()
                -- Memberikan gaya dorong vertikal ekstrem (Sumbu Y)
                -- 9e9 adalah nilai angka yang sangat besar
                targetHRP.Velocity = Vector3.new(0, 1000000, 0) 
                
                -- Memberikan putaran ekstrem agar karakter mereka terpental berantakan
                targetHRP.RotVelocity = Vector3.new(5000, 5000, 5000)
                
                -- Memaksa posisi ke langit sedikit agar fisika server merespon
                targetHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 10, 0)
            end)
        end
    end
end

-- Listener Touched untuk Karakter Kamu
local function SetupFlingListener()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(SkyFling)
        end
    end
end

-- SWITCH ACTION
SwitchCircle.MouseButton1Click:Connect(function()
    FlingEnabled = not FlingEnabled
    
    if FlingEnabled then
        SwitchCircle:TweenPosition(UDim2.new(0, 63, 0, 3), "Out", "Quad", 0.2)
        SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
        SwitchBG.BackgroundColor3 = Color3.fromRGB(60, 0, 30)
        StatusLabel.Text = "FLING: ACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 100)
        
        SetupFlingListener()
    else
        SwitchCircle:TweenPosition(UDim2.new(0, 3, 0, 3), "Out", "Quad", 0.2)
        SwitchCircle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        SwitchBG.BackgroundColor3 = Color3.fromRGB(30, 20, 25)
        StatusLabel.Text = "READY"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- Re-setup on Spawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if FlingEnabled then SetupFlingListener() end
end)

-- Draggable Logic
local d, di, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)

print("V21 Sky Terminator Active - Touch anyone to launch them!")
