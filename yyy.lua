--[[ 
    DELTA EXECUTOR - INSTANT RESET (DANCE SUPPORT)
    - Fitur: Force Reset (Bisa re saat dance/animasi)
    - UI: 300x300 Draggable & Floating Icon
    - Style: Native Notification
]]

if _G.DeltaFinalLoaded then return end
_G.DeltaFinalLoaded = true

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- 1. FUNGSI NOTIFIKASI
local function Notify(title, msg)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = msg,
        Duration = 2,
        Icon = "rbxassetid://6031068433"
    })
end

-- 2. CLEANUP & ROOT UI
if pgui:FindFirstChild("DeltaDanceSupport") then pgui.DeltaDanceSupport:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaDanceSupport"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

-- 3. FLOATING ICON (ORANGE DELTA)
local icon = Instance.new("ImageButton")
icon.Parent = screenGui
icon.Size = UDim2.fromOffset(45, 45)
icon.Position = UDim2.new(0, 15, 0.5, 0)
icon.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
icon.Image = "rbxassetid://6031068433"
icon.ZIndex = 10
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", icon).Thickness = 2

-- 4. MAIN PANEL (300x300)
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.fromOffset(300, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(255, 85, 0)
mainStroke.Thickness = 1.5

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "DELTA EXECUTOR"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- 5. LOGIKA RESET (SUPPORT SAAT DANCE/ANIMASI)
local function ForceReset()
    local char = player.Character
    if char then
        -- Hentikan semua animasi yang sedang berjalan (dance, dll)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            hum.Health = 0
        end
        
        -- Bypass proteksi game: Paksa hancurkan karakter
        char:BreakJoints()
        
        -- Pemicu reset tercepat (Hapus Head & HumanoidRootPart)
        if char:FindFirstChild("Head") then char.Head:Destroy() end
        if char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart:Destroy() end
        
        Notify("Reset", "Berhasil reset karakter!")
    end
end

-- 6. LOGIKA REJOIN
local function Rejoin()
    Notify("Rejoin", "Menyambung ulang ke server...")
    task.wait(0.3)
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end

-- 7. BUTTON CREATOR
local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0.85, 0, 0, 60)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function() task.spawn(callback) end)
end

createBtn("RESET CHARACTER (/re)", UDim2.new(0.075, 0, 0.3, 0), ForceReset)
createBtn("REJOIN SERVER (/rejoin)", UDim2.new(0.075, 0, 0.6, 0), Rejoin)

-- 8. DRAGGABLE (SMOOTH & ANTI BUG MOBILE)
local function makeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(icon)
makeDraggable(mainFrame)

-- 9. TOGGLE ANIMATION
icon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        mainFrame.Size = UDim2.fromOffset(0,0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.BackOut), {Size = UDim2.fromOffset(300, 300)}):Play()
    end
end)

Notify("Delta Executor", "Script Siap! Support Reset saat Dance.")
