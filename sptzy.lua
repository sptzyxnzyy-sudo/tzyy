local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Modules for Mobile Controls
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner_M = Instance.new("UICorner")
UICorner_M.CornerRadius = UDim.new(0, 8)
UICorner_M.Parent = MainFrame

-- Rainbow Border
local Border = Instance.new("Frame")
Border.Name = "RainbowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.BorderSizePixel = 0
Border.Position = UDim2.new(0, -2, 0, -2)
Border.Size = UDim2.new(1, 4, 1, 4)
Border.ZIndex = 0
local UICorner_B = Instance.new("UICorner")
UICorner_B.CornerRadius = UDim.new(0, 8)
UICorner_B.Parent = Border

-- Container
local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 0, 0, 70)
Container.Size = UDim2.new(1, 0, 1, -70)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

-- Rainbow Logic
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Border.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
            task.wait(0.02)
        end
    end
end)

-- FREECAM VARIABLES
local freecamOn = false
local camSpeed = 50
local yaw, pitch = 0, 0
local camPos = Vector3.new(0,0,0)
local lookTouch = nil
local lastLookPos = nil
local frozenPosition = nil
local upHeld, downHeld = false, false

-- UI FREECAM CONTROLS (Hanya muncul saat Freecam ON)
local FreecamUI = Instance.new("Frame")
FreecamUI.Size = UDim2.new(1, 0, 1, 0)
FreecamUI.BackgroundTransparency = 1
FreecamUI.Visible = false
FreecamUI.Parent = ScreenGui

local function createControlBtn(name, text, pos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 25
    btn.Font = Enum.Font.GothamBold
    btn.Parent = FreecamUI
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 10) c.Parent = btn
    return btn
end

local upBtn = createControlBtn("Up", "▲", UDim2.new(1, -70, 0.5, -70))
local downBtn = createControlBtn("Down", "▼", UDim2.new(1, -70, 0.5, 10))

-- Speed Panel
local speedPanel = Instance.new("Frame")
speedPanel.Size = UDim2.new(0, 180, 0, 40)
speedPanel.Position = UDim2.new(0.5, -90, 1, -60)
speedPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedPanel.Parent = FreecamUI
local c2 = Instance.new("UICorner") c2.Parent = speedPanel

local speedDisplay = Instance.new("TextLabel")
speedDisplay.Size = UDim2.new(1, 0, 1, 0)
speedDisplay.BackgroundTransparency = 1
speedDisplay.Text = "Speed: " .. camSpeed
speedDisplay.TextColor3 = Color3.new(1,1,1)
speedDisplay.Parent = speedPanel

-- Input Handling for 360 Rotation
UserInputService.TouchStarted:Connect(function(input, gp)
    if not freecamOn or gp then return end
    if input.Position.X > Camera.ViewportSize.X * 0.4 then -- Hanya bagian kanan layar
        lookTouch = input
        lastLookPos = input.Position
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if freecamOn and input == lookTouch then
        local delta = input.Position - lastLookPos
        yaw = yaw - delta.X * 0.25
        pitch = math.clamp(pitch - delta.Y * 0.25, -89, 89)
        lastLookPos = input.Position
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    if input == lookTouch then lookTouch = nil end
end)

-- Button Logic for Up/Down
upBtn.InputBegan:Connect(function() upHeld = true end)
upBtn.InputEnded:Connect(function() upHeld = false end)
downBtn.InputBegan:Connect(function() downHeld = true end)
downBtn.InputEnded:Connect(function() downHeld = false end)

-- Speed Adjust via Screen Click (Panel)
speedPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        camSpeed = (camSpeed >= 200) and 10 or camSpeed + 20
        speedDisplay.Text = "Speed: " .. camSpeed
    end
end)

-- MAIN FUNCTION: ENABLE/DISABLE
local function toggleFreecam(state)
    freecamOn = state
    FreecamUI.Visible = state
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if state then
        camPos = Camera.CFrame.Position
        local lv = Camera.CFrame.LookVector
        yaw = math.deg(math.atan2(-lv.X, -lv.Z))
        pitch = math.deg(math.asin(math.clamp(lv.Y, -1, 1)))
        
        Camera.CameraType = Enum.CameraType.Scriptable
        if hrp then
            frozenPosition = hrp.CFrame
            hrp.Anchored = true
        end
    else
        Camera.CameraType = Enum.CameraType.Custom
        if hrp then hrp.Anchored = false end
        lookTouch = nil
    end
end

-- BUTTON CREATOR (Styled)
local function CreateStyledButton(name, icon, color, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = "          " .. name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Container
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = Btn
    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 20, 0, 20)
    IconImg.Position = UDim2.new(0, 10, 0.5, -10)
    IconImg.Image = icon
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = Btn
    
    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.BackgroundColor3 = toggled and color or Color3.fromRGB(35, 35, 35)
        func(toggled)
    end)
end

-- ADD BUTTONS
CreateStyledButton("AUTO BUY", "rbxassetid://6031764630", Color3.fromRGB(0, 102, 204), function(state)
    _G.AutoBuy = state
    while _G.AutoBuy do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1) end)
        task.wait(0.5)
    end
end)

CreateStyledButton("AUTO SELL", "rbxassetid://6031154871", Color3.fromRGB(153, 0, 0), function(state)
    _G.AutoSell = state
    while _G.AutoSell do
        pcall(function() game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45) end)
        task.wait(0.5)
    end
end)

CreateStyledButton("MOBILE FREECAM", "rbxassetid://6034289542", Color3.fromRGB(0, 153, 76), function(state)
    toggleFreecam(state)
end)

-- RENDER UPDATE
RunService.RenderStepped:Connect(function(dt)
    if freecamOn then
        local moveVector = Controls:GetMoveVector()
        local rotation = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        
        local vertInput = 0
        if upHeld then vertInput = 1 elseif downHeld then vertInput = -1 end
        
        local move = (rotation.RightVector * moveVector.X) + (rotation.LookVector * -moveVector.Z) + (Vector3.yAxis * vertInput)
        camPos = camPos + move * camSpeed * dt
        
        Camera.CFrame = CFrame.new(camPos) * rotation
        
        -- Anti-Bug Character Lock
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and frozenPosition then
            hrp.CFrame = frozenPosition
            hrp.Velocity = Vector3.zero
        end
    end
end)

-- Watermark
local WM = Instance.new("TextLabel")
WM.Text = "IKYY EXECUTOR v3"
WM.Position = UDim2.new(0, 0, 1, -20)
WM.Size = UDim2.new(1, 0, 0, 20)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(80, 80, 80)
WM.TextSize = 10
WM.Parent = MainFrame
