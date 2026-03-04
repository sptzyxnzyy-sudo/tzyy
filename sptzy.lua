local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ SISTEM NOTIFIKASI MODERN ]]
local function SendNotify(title, msg, mode)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = msg,
        Duration = 5,
        Button1 = "Paham"
    })
end

-- Mobile Control Module
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- [[ UI CONSTRUCT ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyySquare_V5_Final"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -100)
MainFrame.Size = UDim2.new(0, 200, 0, 310)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Border = Instance.new("Frame")
Border.Size = UDim2.new(1, 2, 1, 2)
Border.Position = UDim2.new(0, -1, 0, -1)
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.ZIndex = 0
Border.Parent = MainFrame

-- Profile Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local pfp = Instance.new("ImageLabel")
pfp.Size = UDim2.new(0, 35, 0, 35)
pfp.Position = UDim2.new(0, 10, 0, 8)
pfp.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
pfp.Parent = Header

local userTxt = Instance.new("TextLabel")
userTxt.Text = LocalPlayer.DisplayName
userTxt.Position = UDim2.new(0, 52, 0, 10)
userTxt.Size = UDim2.new(0, 140, 0, 15)
userTxt.TextColor3 = Color3.new(1, 1, 1)
userTxt.Font = Enum.Font.GothamBold
userTxt.TextXAlignment = Enum.TextXAlignment.Left
userTxt.BackgroundTransparency = 1
userTxt.Parent = Header

-- Scroll Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -70)
Scroll.Position = UDim2.new(0, 5, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.Parent = MainFrame

local List = Instance.new("UIListLayout")
List.Parent = Scroll
List.Padding = UDim.new(0, 5)

-- Button Creator
local function NewButton(text, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.Parent = Scroll
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and color or Color3.fromRGB(30, 30, 30)
        callback(state)
    end)
end

-- [[ 1. FITUR: FE GLITCH V5 (ULTRA) ]]
NewButton("FE JACKET GLITCH V5", Color3.fromRGB(150, 0, 255), function(s)
    _G.GlitchV5 = s
    if s then
        task.spawn(function()
            local checkCount = 0
            while _G.GlitchV5 do
                local char = LocalPlayer.Character
                local has3D = false
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("WrapLayer") then
                            has3D = true
                            pcall(function()
                                -- Super Stretch
                                v.Puffiness = 10
                                v.ReferenceBoundsMin = Vector3.new(-10000, -10000, -10000)
                                v.ReferenceBoundsMax = Vector3.new(10000, 10000, 10000)
                                -- Force Replication to Server
                                v.Enabled = false
                                v.Enabled = true
                            end)
                        end
                    end
                end
                
                if not has3D and checkCount < 1 then
                    SendNotify("Gagal", "Avatar kamu TIDAK memakai baju 3D (Layered Clothing). Glitch tidak akan terlihat!", "error")
                    _G.GlitchV5 = false
                    break
                elseif has3D and checkCount < 1 then
                    SendNotify("Berhasil", "Layered Clothing terdeteksi. Glitch diaktifkan!", "success")
                    checkCount = 1
                end
                task.wait(0.05)
            end
        end)
    else
        SendNotify("Sistem", "Glitch dimatikan.", "success")
    end
end)

-- [[ 2. FITUR: MOBILE FREECAM ]]
local freecamOn = false
local camPos = Vector3.zero
NewButton("MOBILE FREECAM", Color3.fromRGB(0, 120, 0), function(s)
    freecamOn = s
    if s then
        camPos = Camera.CFrame.Position
        Camera.CameraType = Enum.CameraType.Scriptable
        SendNotify("Freecam", "Gunakan joystick untuk bergerak", "success")
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- [[ 3. FITUR: AUTO BUY & SELL ]]
NewButton("AUTO BUY PADI", Color3.fromRGB(0, 100, 255), function(s)
    _G.Buy = s
    while _G.Buy do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) end)
        task.wait(0.5)
    end
end)

NewButton("AUTO SELL PADI", Color3.fromRGB(200, 0, 0), function(s)
    _G.Sell = s
    while _G.Sell do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45) end)
        task.wait(0.5)
    end
end)

-- [[ 4. FITUR: SPEED & JUMP ]]
NewButton("FAST WALK (80)", Color3.fromRGB(200, 200, 0), function(s)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = s and 80 or 16 end
end)

-- Systems: Rainbow & Rendering
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Border.BackgroundColor3 = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.05)
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if freecamOn then
        local mv = Controls:GetMoveVector()
        local rot = Camera.CFrame
        local move = (rot.RightVector * mv.X) + (rot.LookVector * -mv.Z)
        camPos = camPos + move * 100 * dt
        Camera.CFrame = CFrame.new(camPos) * (rot - rot.Position)
    end
end)

SendNotify("IkyySquare V5", "Script Siap Digunakan!", "success")
