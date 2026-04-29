--[[
    sptzyy developer sl - Emote Executor Pro
    Logic: Animation ID System
    Theme: Monochrome Dark
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local currentTrack = nil

-- [[ DATABASE EMOTE ID ]]
local Emotes = {
    {name = "Mosh", id = "rbxassetid://96147994216119"},
    {name = "KedatKedut", id = "rbxassetid://124487025832160"},
    {name = "GetSturdy", id = "rbxassetid://122884053950359"},
    {name = "RatDance", id = "rbxassetid://96490284184113"},
    {name = "GangnamStyle", id = "rbxassetid://131104967711844"},
    {name = "Popular", id = "rbxassetid://93062298566806"},
    {name = "Baddie Hips", id = "rbxassetid://90802740360125"},
    {name = "Caramelldansen", id = "rbxassetid://73785690856046"},
    {name = "Aizen Pose", id = "rbxassetid://73878018081160"},
    {name = "Floating Aura", id = "rbxassetid://133364897841008"}
}

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Executor_Fixed"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Floating Icon (Draggable)
local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0, 10, 0.5, -25)
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconButton.Text = "🎬"
IconButton.TextSize = 24
IconButton.Parent = ScreenGui
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(255, 255, 255)
IconStroke.Thickness = 1.5

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 170, 0, 240)
MainFrame.Position = UDim2.new(0, 70, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(60, 60, 60)

-- Scrolling Area
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -16, 1, -60)
Scroll.Position = UDim2.new(0, 8, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
Scroll.Parent = MainFrame
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)

-- [[ DRAGGABLE LOGIC ]]
local dragging, dragStart, startPos
IconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = IconButton.Position
    end
end)
IconButton.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        IconButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- [[ CORE EMOTE LOGIC ]]
local function StopEmote()
    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
end

local function PlayEmote(id)
    StopEmote()
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hum then
        local anim = Instance.new("Animation")
        anim.AnimationId = id
        
        local success, track = pcall(function() return hum:LoadAnimation(anim) end)
        if success then
            track.Looped = true
            track:Play()
            currentTrack = track
        end
    end
end

-- Generate Buttons from Database
for _, emote in ipairs(Emotes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  " .. emote.name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        PlayEmote(emote.id)
    end)
end

-- Stop Button (Highlight Putih)
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, -16, 0, 35)
StopBtn.Position = UDim2.new(0, 8, 1, -45)
StopBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Text = "STOP EMOTE"
StopBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 12
StopBtn.Parent = MainFrame
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 6)

StopBtn.MouseButton1Click:Connect(StopEmote)

-- Toggle Menu
IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
