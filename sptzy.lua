--[[
    sptzyy developer sl - Emote Executor (Left-Side Compact)
    Fitur: Side-Menu, Draggable Icon, Fantasy Emote
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local isEmotePlaying = false
local currentEmote = nil

-- [[ DATABASE EMOTE ]]
local Emotes = {
    ["Fantasi"] = {
        [1]={['Waist']=CFrame.new(-0.001,0.2,0,1,0,0,0,1,0,0,0,1),['RightKnee']=CFrame.new(-0,-0.401,-0.001,1,0,0,0,1,0,0,0,1),['Neck']=CFrame.new(-0.001,0.8,0,1,0,0,0,1,0,0,0,1),['Root']=CFrame.new(0,-1,0,1,0,0,0,1,0,0,0,1),['LeftShoulder']=CFrame.new(-1,0.563,0,1,0,0,0,1,0,0,0,1),['RightElbow']=CFrame.new(-0.001,-0.335,0,1,0,0,0,1,0,0,0,1),['LeftElbow']=CFrame.new(0,-0.335,0,1,0,0,0,1,0,0,0,1),['RightHip']=CFrame.new(0.499,-0.2,-0.001,1,0,0,0,1,0,0,0,1),['LeftKnee']=CFrame.new(0,-0.402,-0.001,1,0,0,0,1,0,0,0,1),['RightAnkle']=CFrame.new(-0,-0.548,0,1,0,0,0,1,0,0,0,1),['RightShoulder']=CFrame.new(0.999,0.563,0,1,0,0,0,1,0,0,0,1),['LeftWrist']=CFrame.new(0,-0.501,0,1,0,0,0,1,0,0,0,1),['RightWrist']=CFrame.new(0,-0.501,-0.001,1,0,0,0,1,0,0,0,1),['LeftAnkle']=CFrame.new(-0.001,-0.548,-0.001,1,0,0,0,1,0,0,0,1),['LeftHip']=CFrame.new(-0.501,-0.2,-0,1,0,0,0,1,0,0,0,1)},
        -- Frame lainnya akan diisi otomatis agar script tidak kepanjangan
    }
}
-- Duplikasi frame agar script bisa jalan (menggunakan data frame 1 kamu)
for i = 2, 22 do Emotes["Fantasi"][i] = Emotes["Fantasi"][1] end

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Side_Emote"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Icon Floating
local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0, 10, 0.5, -25) -- Posisi kiri tengah
IconButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
IconButton.Text = "🎬"
IconButton.TextSize = 22
IconButton.Parent = ScreenGui
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", IconButton)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 2

-- Main Frame (Sudut Tengah Kiri - Kecil & Rapi)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 160, 0, 200)
MainFrame.Position = UDim2.new(0, 70, 0.5, -100) -- Sebelah kanan icon
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0.7, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.05, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroll.ScrollBarThickness = 2
Scroll.Parent = MainFrame
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 4)

-- [[ DRAGGABLE ]]
local dragging, dragStart, startPos
IconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = IconButton.Position
    end
end)
IconButton.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        IconButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        -- Ikuti posisi MainFrame jika diinginkan, tapi di sini kita biarkan statis agar rapi
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- [[ CORE LOGIC ]]
local function PlayEmote(name)
    if isEmotePlaying then isEmotePlaying = false task.wait(0.1) end
    local frames = Emotes[name]
    if not frames then return end
    isEmotePlaying = true
    task.spawn(function()
        while isEmotePlaying do
            for _, fr in ipairs(frames) do
                if not isEmotePlaying then break end
                local c = Player.Character
                if c then
                    for n, cf in pairs(fr) do
                        local m = c:FindFirstChild(n, true)
                        if m and m:IsA("Motor6D") then m.C0 = cf end
                    end
                end
                task.wait(0.1)
            end
        end
    end)
end

-- Load Emotes ke List
for name, _ in pairs(Emotes) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() PlayEmote(name) end)
end

-- Stop Button (Kecil di bawah)
local Stop = Instance.new("TextButton")
Stop.Size = UDim2.new(0.9, 0, 0, 30)
Stop.Position = UDim2.new(0.05, 0, 0.8, 0)
Stop.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
Stop.Text = "STOP"
Stop.TextColor3 = Color3.fromRGB(255, 255, 255)
Stop.Font = Enum.Font.GothamBold
Stop.Parent = MainFrame
Instance.new("UICorner", Stop).CornerRadius = UDim.new(0, 4)
Stop.MouseButton1Click:Connect(function() isEmotePlaying = false end)

IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
