local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Fungsi Notifikasi
local function Notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 3;
    })
end

-- Mobile Controls
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyySquare_V3_Notif"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -100)
MainFrame.Size = UDim2.new(0, 200, 0, 310)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Border = Instance.new("Frame")
Border.Name = "Border"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.BorderSizePixel = 0
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.ZIndex = 0

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 20, 0, 20)
MiniBtn.Position = UDim2.new(1, -25, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MiniBtn.Text = "_"
MiniBtn.TextColor3 = Color3.new(1, 1, 1)
MiniBtn.BorderSizePixel = 0
MiniBtn.Parent = MainFrame

-- [PROFILE]
local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(1, 0, 0, 50)
Profile.BackgroundTransparency = 1
Profile.Parent = MainFrame

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 35, 0, 35)
Avatar.Position = UDim2.new(0, 8, 0, 8)
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Avatar.Parent = Profile

local NameLabel = Instance.new("TextLabel")
NameLabel.Text = LocalPlayer.DisplayName
NameLabel.Position = UDim2.new(0, 50, 0, 10)
NameLabel.Size = UDim2.new(0, 120, 0, 15)
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.Font = Enum.Font.SourceSansBold
NameLabel.BackgroundTransparency = 1
NameLabel.Parent = Profile

-- [CONTAINER]
local Container = Instance.new("ScrollingFrame")
Container.Position = UDim2.new(0, 0, 0, 55)
Container.Size = UDim2.new(1, 0, 1, -70)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 5)

-- Logic Variables
local freecamOn = false
local camSpeed, yaw, pitch = 50, 0, 0
local camPos = Vector3.zero

-- [MINIMIZE]
local isMinimized = false
MiniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 40, 0, 40), "Out", "Quad", 0.2, true)
        for _, v in pairs(MainFrame:GetChildren()) do if v ~= MiniBtn and v ~= Border then v.Visible = false end end
    else
        MainFrame:TweenSize(UDim2.new(0, 200, 0, 310), "Out", "Quad", 0.2, true)
        task.wait(0.1)
        for _, v in pairs(MainFrame:GetChildren()) do v.Visible = true end
    end
end)

local function AddSquareButton(name, icon, color, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.BorderSizePixel = 0
    Btn.Text = "          " .. name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Container
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Position = UDim2.new(0, 8, 0.5, -8)
    Icon.Image = icon
    Icon.BackgroundTransparency = 1
    Icon.Parent = Btn
    
    local act = false
    Btn.MouseButton1Click:Connect(function()
        act = not act
        Btn.BackgroundColor3 = act and color or Color3.fromRGB(25, 25, 25)
        func(act)
    end)
    return Btn
end

-- [FITUR: AUTO FARM]
AddSquareButton("AUTO BUY PADI", "rbxassetid://6031764630", Color3.fromRGB(0, 85, 150), function(s)
    _G.AutoBuy = s
    if s then Notify("Sistem", "Auto Buy Dimulai...", 2) end
    while _G.AutoBuy do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) end)
        task.wait(0.5)
    end
end)

-- [FITUR: FE JACKET GLITCH - WITH STATUS NOTIF]
AddSquareButton("FE JACKET GLITCH", "rbxassetid://6034287525", Color3.fromRGB(130, 0, 255), function(s)
    _G.JacketGlitch = s
    if s then
        Notify("Sistem", "Mencari Layered Clothing...", 2)
        task.spawn(function()
            local foundLayer = false
            while _G.JacketGlitch do
                local char = LocalPlayer.Character
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("WrapLayer") then
                            foundLayer = true
                            pcall(function()
                                v.Puffiness = 10
                                v.ReferenceBoundsMin = Vector3.new(-1000, -1000, -1000)
                                v.ReferenceBoundsMax = Vector3.new(1000, 1000, 1000)
                                local handle = v.Parent
                                if handle and handle:IsA("BasePart") then
                                    handle.CFrame = handle.CFrame * CFrame.new(0, 0.05, 0)
                                    task.wait()
                                    handle.CFrame = handle.CFrame * CFrame.new(0, -0.05, 0)
                                end
                            end)
                        end
                    end
                end
                
                -- Notifikasi Status Sukses/Gagal
                if not foundLayer then
                    Notify("Gagal", "Tidak ada Baju 3D terdeteksi!", 3)
                    _G.JacketGlitch = false
                    break
                else
                    -- Hanya kirim notif berhasil sekali
                    if foundLayer then
                         Notify("Berhasil", "Jacket Glitch Aktif!", 2)
                         foundLayer = "done" -- stop repeat notif
                    end
                end
                task.wait(0.01)
            end
        end)
    else
        Notify("Sistem", "Jacket Glitch Dimatikan", 2)
    end
end)

-- [FITUR: MOBILE FREECAM]
AddSquareButton("MOBILE FREECAM", "rbxassetid://6034289542", Color3.fromRGB(0, 120, 0), function(s)
    freecamOn = s
    if s then
        Notify("Freecam", "Mode Kamera Bebas Aktif", 2)
        camPos = Camera.CFrame.Position
        Camera.CameraType = Enum.CameraType.Scriptable
    else
        Notify("Freecam", "Kembali ke Kamera Normal", 2)
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- [SPEED CONTROL]
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 35)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedFrame.BorderSizePixel = 0
SpeedFrame.Parent = Container

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
SpeedLabel.Text = "CAM SPEED: " .. camSpeed
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextSize = 10
SpeedLabel.Parent = SpeedFrame

local Plus = Instance.new("TextButton")
Plus.Size = UDim2.new(0.2, 0, 1, 0)
Plus.Position = UDim2.new(0.6, 0, 0, 0)
Plus.Text = "+" 
Plus.Parent = SpeedFrame
Plus.MouseButton1Click:Connect(function() camSpeed = camSpeed + 10 SpeedLabel.Text = "CAM SPEED: "..camSpeed end)

local Minus = Instance.new("TextButton")
Minus.Size = UDim2.new(0.2, 0, 1, 0)
Minus.Position = UDim2.new(0.8, 0, 0, 0)
Minus.Text = "-" 
Minus.Parent = SpeedFrame
Minus.MouseButton1Click:Connect(function() camSpeed = math.max(10, camSpeed - 10) SpeedLabel.Text = "CAM SPEED: "..camSpeed end)

-- [RAINBOW BORDER]
task.spawn(function()
    while true do 
        for i = 0, 1, 0.01 do 
            Border.BackgroundColor3 = Color3.fromHSV(i, 0.8, 1) 
            task.wait(0.03) 
        end 
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if freecamOn then
        local mv = Controls:GetMoveVector()
        local rot = Camera.CFrame
        local move = (rot.RightVector * mv.X) + (rot.LookVector * -mv.Z)
        camPos = camPos + move * camSpeed * dt
        Camera.CFrame = CFrame.new(camPos) * (rot - rot.Position)
    end
end)

local WM = Instance.new("TextLabel")
WM.Text = "IKYY SQUARE EXECUTOR V3"
WM.Position = UDim2.new(0, 0, 1, -20)
WM.Size = UDim2.new(1, 0, 0, 15)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(100, 100, 100)
WM.TextSize = 8
WM.Parent = MainFrame

-- Notif Awal
Notify("IkyySquare V3", "Script berhasil dijalankan!", 4)
