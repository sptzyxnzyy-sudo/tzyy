-- SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada
if pgui:FindFirstChild("DeltaQuickCmd") then
    pgui.DeltaQuickCmd:Destroy()
end

-- ROOT GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaQuickCmd"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

-- ICON BULAT (SUPPORT GESER & KLIK)
local icon = Instance.new("ImageButton")
icon.Name = "DeltaIcon"
icon.Parent = screenGui
icon.Size = UDim2.fromOffset(50, 50)
icon.Position = UDim2.new(0.1, 0, 0.1, 0)
icon.BackgroundColor3 = Color3.fromRGB(255, 85, 0) -- Warna Oranye Delta
icon.Image = "rbxassetid://6031068433" -- Icon Gear
icon.Draggable = true -- Support Geser Luas
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

-- MAIN PANEL (300x300)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.fromOffset(300, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Sembunyi dulu
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

-- STROKE (GARIS TEPI)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 85, 0)
stroke.Thickness = 2

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "DELTA EXECUTOR"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- BUTTON: RESET (/RE)
local reBtn = Instance.new("TextButton")
reBtn.Parent = mainFrame
reBtn.Size = UDim2.new(0.8, 0, 0, 60)
reBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
reBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
reBtn.Text = "Reset Character (/re)"
reBtn.TextColor3 = Color3.new(1, 1, 1)
reBtn.Font = Enum.Font.GothamMedium
reBtn.TextSize = 16
Instance.new("UICorner", reBtn).CornerRadius = UDim.new(0, 10)

-- BUTTON: REJOIN (/REJOIN)
local rjBtn = Instance.new("TextButton")
rjBtn.Parent = mainFrame
rjBtn.Size = UDim2.new(0.8, 0, 0, 60)
rjBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
rjBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
rjBtn.Text = "Rejoin Server (/rejoin)"
rjBtn.TextColor3 = Color3.new(1, 1, 1)
rjBtn.Font = Enum.Font.GothamMedium
rjBtn.TextSize = 16
Instance.new("UICorner", rjBtn).CornerRadius = UDim.new(0, 10)

-- LOGIC: OPEN/CLOSE
icon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        mainFrame:TweenSize(UDim2.fromOffset(300, 300), "Out", "Back", 0.3, true)
    end
end)

-- LOGIC: RESET
reBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
    end
end)

-- LOGIC: REJOIN
rjBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- DRAGGABLE SCRIPT UNTUK MAINFRAME
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("Delta UI Loaded Successfully!")
