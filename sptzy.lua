local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ SISTEM NOTIFIKASI ]]
local function SendStatus(title, msg, type)
    local color = type == "error" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = msg,
        Duration = 4,
        Button1 = "OK"
    })
end

-- Mobile Controls
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyySquare_V4_Final"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -100)
MainFrame.Size = UDim2.new(0, 210, 0, 320)
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

-- Header Profile
local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(1, 0, 0, 50)
Profile.BackgroundTransparency = 1
Profile.Parent = MainFrame

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 35, 0, 35)
Avatar.Position = UDim2.new(0, 10, 0, 10)
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Avatar.Parent = Profile

local NameLabel = Instance.new("TextLabel")
NameLabel.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
NameLabel.Position = UDim2.new(0, 55, 0, 15)
NameLabel.Size = UDim2.new(0, 140, 0, 15)
NameLabel.TextColor3 = Color3.new(1, 1, 1)
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 10
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.BackgroundTransparency = 1
NameLabel.Parent = Profile

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Position = UDim2.new(0, 5, 0, 60)
Container.Size = UDim2.new(1, -10, 1, -80)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.Padding = UDim.new(0, 6)

-- Function Create Button
local function MakeButton(name, color, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.BorderSizePixel = 0
    Btn.Parent = Container
    
    local act = false
    Btn.MouseButton1Click:Connect(function()
        act = not act
        Btn.BackgroundColor3 = act and color or Color3.fromRGB(20, 20, 20)
        func(act)
    end)
end

-- [[ FITUR: FE JACKET GLITCH V4 ]]
MakeButton("FE JACKET GLITCH (V4)", Color3.fromRGB(170, 0, 255), function(s)
    _G.JacketGlitchV4 = s
    if s then
        local found = false
        task.spawn(function()
            while _G.JacketGlitchV4 do
                local char = LocalPlayer.Character
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("WrapLayer") then
                            found = true
                            pcall(function()
                                -- Force stretching
                                v.Puffiness = 10
                                v.ReferenceBoundsMin = Vector3.new(-math.huge, -math.huge, -math.huge)
                                v.ReferenceBoundsMax = Vector3.new(math.huge, math.huge, math.huge)
                                -- Engine Jitter
                                v.Enabled = not v.Enabled
                            end)
                        end
                    end
                end
                
                if not found then
                    SendStatus("Peringatan!", "Gagal: Gunakan Jaket 3D (Layered Clothing) agar fitur ini bekerja!", "error")
                    _G.JacketGlitchV4 = false
                    break
                end
                task.wait(0.02)
            end
        end)
        if found then SendStatus("Berhasil", "Glitch Aktif! Visual meledak sekarang terlihat.", "success") end
    else
        SendStatus("Sistem", "Glitch dimatikan. Baju kembali normal.", "success")
    end
end)

-- [[ FITUR: FREECAM ]]
local freecamOn = false
local camPos = Vector3.zero
local camSpeed = 50

MakeButton("MOBILE FREECAM", Color3.fromRGB(0, 150, 0), function(s)
    freecamOn = s
    if s then
        camPos = Camera.CFrame.Position
        Camera.CameraType = Enum.CameraType.Scriptable
        SendStatus("Freecam", "Kamera Bebas Aktif", "success")
    else
        Camera.CameraType = Enum.CameraType.Custom
        SendStatus("Freecam", "Kembali ke Kamera Normal", "success")
    end
end)

-- [[ AUTO FARM PADI ]]
MakeButton("AUTO BUY SEED", Color3.fromRGB(0, 100, 200), function(s)
    _G.AutoBuy = s
    while _G.AutoBuy do
        pcall(function() 
            game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) 
        end)
        task.wait(0.5)
    end
end)

-- Rainbow Border Animation
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Border.BackgroundColor3 = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.05)
        end
    end
end)

-- Freecam Rendering
RunService.RenderStepped:Connect(function(dt)
    if freecamOn then
        local mv = Controls:GetMoveVector()
        local rot = Camera.CFrame
        local move = (rot.RightVector * mv.X) + (rot.LookVector * -mv.Z)
        camPos = camPos + move * camSpeed * dt
        Camera.CFrame = CFrame.new(camPos) * (rot - rot.Position)
    end
end)

SendStatus("IkyySquare V4", "Script Berhasil Dimuat!", "success")
