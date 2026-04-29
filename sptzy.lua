--[[
    sptzyy developer sl - Emote Executor (Stationary Dance)
    Fitur: Hanya Gerakan Emote Rekaman (Diam di Tempat)
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local isEmotePlaying = false

-- [[ DATABASE EMOTE - PAKAI DATA REKAMANMU ]]
local Emotes = {
    ["Fantasi"] = {
        [1]={['Waist']=CFrame.new(-0.001,0.2,0,1,0,0,0,1,0,0,0,1),['RightKnee']=CFrame.new(-0,-0.401,-0.001,1,0,0,0,1,0,0,0,1),['Neck']=CFrame.new(-0.001,0.8,0,1,0,0,0,1,0,0,0,1),['Root']=CFrame.new(0,-1,0,1,0,0,0,1,0,0,0,1),['LeftShoulder']=CFrame.new(-1,0.563,0,1,0,0,0,1,0,0,0,1),['RightElbow']=CFrame.new(-0.001,-0.335,0,1,0,0,0,1,0,0,0,1),['LeftElbow']=CFrame.new(0,-0.335,0,1,0,0,0,1,0,0,0,1),['RightHip']=CFrame.new(0.499,-0.2,-0.001,1,0,0,0,1,0,0,0,1),['LeftKnee']=CFrame.new(0,-0.402,-0.001,1,0,0,0,1,0,0,0,1),['RightAnkle']=CFrame.new(-0,-0.548,0,1,0,0,0,1,0,0,0,1),['RightShoulder']=CFrame.new(0.999,0.563,0,1,0,0,0,1,0,0,0,1),['LeftWrist']=CFrame.new(0,-0.501,0,1,0,0,0,1,0,0,0,1),['RightWrist']=CFrame.new(0,-0.501,-0.001,1,0,0,0,1,0,0,0,1),['LeftAnkle']=CFrame.new(-0.001,-0.548,-0.001,1,0,0,0,1,0,0,0,1),['LeftHip']=CFrame.new(-0.501,-0.2,-0,1,0,0,0,1,0,0,0,1)},
    }
}

-- Mengisi frame secara otomatis jika datanya masih sedikit (untuk testing)
if #Emotes["Fantasi"] < 2 then
    for i = 2, 22 do Emotes["Fantasi"][i] = Emotes["Fantasi"][1] end
end

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Stationary_Emote"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 45, 0, 45)
IconButton.Position = UDim2.new(0, 10, 0.5, -22)
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconButton.Text = "🎬"
IconButton.Parent = ScreenGui
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 255, 150)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 140, 0, 150)
MainFrame.Position = UDim2.new(0, 65, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0.65, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.05, 0)
Scroll.BackgroundTransparency = 1
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 0
Scroll.Parent = MainFrame
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

-- [[ LOGIKA EMOTE TANPA JALAN ]]
local function PlayEmote(name)
    if isEmotePlaying then isEmotePlaying = false task.wait(0.1) end
    local frames = Emotes[name]
    if not frames then return end
    isEmotePlaying = true
    
    task.spawn(function()
        local frameCounter = 1
        while isEmotePlaying do
            local fr = frames[frameCounter]
            local char = Player.Character
            
            if char and char:FindFirstChild("Humanoid") then
                -- HANYA UPDATE SENDI (MOTOR6D) - Tanpa memindahkan RootPart
                for partName, cframeData in pairs(fr) do
                    local joint = char:FindFirstChild(partName, true)
                    if joint and joint:IsA("Motor6D") then
                        joint.C0 = cframeData
                    end
                end
            end
            
            frameCounter = (frameCounter % #frames) + 1
            task.wait(0.08) -- Kecepatan animasi
        end
    end)
end

-- Generate Button List
for n, _ in pairs(Emotes) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 30)
    b.Text = n
    b.Parent = Scroll
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() PlayEmote(n) end)
end

local Stop = Instance.new("TextButton")
Stop.Size = UDim2.new(0.9, 0, 0, 30)
Stop.Position = UDim2.new(0.05, 0, 0.75, 0)
Stop.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
Stop.Text = "STOP"
Stop.TextColor3 = Color3.fromRGB(255, 255, 255)
Stop.Parent = MainFrame
Instance.new("UICorner", Stop)
Stop.MouseButton1Click:Connect(function() isEmotePlaying = false end)

IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
