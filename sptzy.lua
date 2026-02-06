-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE EDITION + SCANNER FIXED ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125
local followStrength = 100

-- [[ LOGIKA PHYSICS ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            local distance = (part.Position - rootPart.Position).Magnitude
            if distance <= pullRadius then
                pcall(function() 
                    -- Putuskan koneksi fisik yang mengikat part
                    for _, joint in pairs(part:GetChildren()) do
                        if joint:IsA("Constraint") or joint:IsA("JointInstance") then
                            joint:Destroy()
                        end
                    end
                    
                    -- Klaim kepemilikan part (Hanya jika unanchored)
                    if part.ReceiveAge == 0 then -- Cek kepemilikan dasar
                        part:SetNetworkOwner(lp) 
                    end
                    
                    part.Velocity = (targetPos - part.Position) * followStrength
                    part.RotVelocity = Vector3.new(0, 15, 0)
                end)
            end
        end
    end
end)

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BeastV2_Control"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BEAST CONTROLLER V2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

local FeatureFrame = Instance.new("Frame", MainFrame)
FeatureFrame.Size = UDim2.new(1, 0, 1, -40)
FeatureFrame.Position = UDim2.new(0, 0, 0, 40)
FeatureFrame.BackgroundTransparency = 1
FeatureFrame.Visible = false

local LoadingLabel = Instance.new("TextLabel", MainFrame)
LoadingLabel.Size = UDim2.new(1, 0, 0, 100)
LoadingLabel.Position = UDim2.new(0, 0, 0.35, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "INITIALIZING..."
LoadingLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
LoadingLabel.Font = Enum.Font.Code
LoadingLabel.TextSize = 14

-- [[ TOMBOL & INPUT ]] --
local function CreateButton(name, pos, color, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    return btn
end

local StatusBtn = CreateButton("MAGNET: ON", UDim2.new(0.075, 0, 0.05, 0), Color3.fromRGB(0, 200, 100), FeatureFrame)

local InputBox = Instance.new("TextBox", FeatureFrame)
InputBox.Size = UDim2.new(0.85, 0, 0, 40)
InputBox.Position = UDim2.new(0.075, 0, 0.22, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InputBox.PlaceholderText = "Pesan / Waktu..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.new(1, 1, 1)
InputBox.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", InputBox)

local AnnounceBtn = CreateButton("GLOBAL ANNOUNCE", UDim2.new(0.075, 0, 0.45, 0), Color3.fromRGB(200, 50, 50), FeatureFrame)
local CountBtn = CreateButton("START COUNTDOWN", UDim2.new(0.075, 0, 0.62, 0), Color3.fromRGB(200, 120, 0), FeatureFrame)

local Info = Instance.new("TextLabel", FeatureFrame)
Info.Size = UDim2.new(1, 0, 0, 30)
Info.Position = UDim2.new(0, 0, 0.85, 0)
Info.Text = "READY TO BYPASS"
Info.TextColor3 = Color3.fromRGB(100, 100, 100)
Info.TextSize = 10
Info.BackgroundTransparency = 1

-- [[ SISTEM SCANNING ]] --
local function StartCheck()
    local main = _G.HDAdminMain
    local frames = {"[ . ]", "[ .. ]", "[ ... ]", "[  ]"}
    
    for i = 1, 15 do
        LoadingLabel.Text = "SCANNING SYSTEM " .. frames[i % 4 + 1]
        task.wait(0.15)
    end
    
    if main and main.modules and main.modules.messages then
        LoadingLabel.Text = "BACKDOOR FOUND!"
        LoadingLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        Info.Text = "STATUS: CONNECTED TO HD ADMIN"
    else
        LoadingLabel.Text = "BACKDOOR FAILED\nMAGNET MODE ONLY"
        LoadingLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        AnnounceBtn.Visible = false
        CountBtn.Visible = false
        InputBox.Visible = false
        Info.Text = "STATUS: HD ADMIN NOT DETECTED"
    end
    
    task.wait(1)
    LoadingLabel.Visible = false
    FeatureFrame.Visible = true
end

-- [[ EVENT HANDLER ]] --
StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

AnnounceBtn.MouseButton1Click:Connect(function()
    local main = _G.HDAdminMain
    if main and InputBox.Text ~= "" then
        pcall(function()
            main.modules.messages:GlobalAnnouncement({
                Title = "BEAST ANNOUNCEMENT",
                Message = InputBox.Text,
                Color = {1, 0, 0}, -- Red
                SenderId = lp.UserId,
                SenderName = lp.Name,
                DisplayFrom = true
            })
        end)
        InputBox.Text = ""
    end
end)

CountBtn.MouseButton1Click:Connect(function()
    local main = _G.HDAdminMain
    if main and InputBox.Text ~= "" then
        pcall(function()
            local seconds = tonumber(InputBox.Text) or 10
            main.modules.messages:Message({lp, "Countdown", "COUNTDOWN", "", seconds, Color3.new(1,1,1)})
        end)
        InputBox.Text = ""
    end
end)

-- [[ FLOATING ICON & DRAG ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.05, 0, 0.45, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", IconButton)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

local firstTime = true
IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if firstTime then
        firstTime = false
        StartCheck()
    end
end)

-- Draggable Logic
local function makeDraggable(frame, handle)
    local dragging, dragInput, startPos, startPosFrame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startPosFrame = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(startPosFrame.X.Scale, startPosFrame.X.Offset + delta.X, startPosFrame.Y.Scale, startPosFrame.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(MainFrame, Title)
makeDraggable(IconButton, IconButton)
