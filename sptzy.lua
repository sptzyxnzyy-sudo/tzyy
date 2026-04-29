--[[
    sptzyy developer sl - Emote Database Runner
    Fitur: Full-Frame Loop, Stationary (Diam di tempat), Side-Compact UI
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local isEmotePlaying = false

-- [[ DATABASE EMOTE ]]
-- Masukkan semua frame hasil rekamanmu di sini
local Emotes = {
    ["Fantasi"] = {
        [1]={['Waist']=CFrame.new(-0.001,0.2,0,1,0,0,0,1,0,0,0,1),['RightKnee']=CFrame.new(-0,-0.401,-0.001,1,0,0,0,1,0,0,0,1),['Neck']=CFrame.new(-0.001,0.8,0,1,0,0,0,1,0,0,0,1),['Root']=CFrame.new(0,-1,0,1,0,0,0,1,0,0,0,1),['LeftShoulder']=CFrame.new(-1,0.563,0,1,0,0,0,1,0,0,0,1),['RightElbow']=CFrame.new(-0.001,-0.335,0,1,0,0,0,1,0,0,0,1),['LeftElbow']=CFrame.new(0,-0.335,0,1,0,0,0,1,0,0,0,1),['RightHip']=CFrame.new(0.499,-0.2,-0.001,1,0,0,0,1,0,0,0,1),['LeftKnee']=CFrame.new(0,-0.402,-0.001,1,0,0,0,1,0,0,0,1),['RightAnkle']=CFrame.new(-0,-0.548,0,1,0,0,0,1,0,0,0,1),['RightShoulder']=CFrame.new(0.999,0.563,0,1,0,0,0,1,0,0,0,1),['LeftWrist']=CFrame.new(0,-0.501,0,1,0,0,0,1,0,0,0,1),['RightWrist']=CFrame.new(0,-0.501,-0.001,1,0,0,0,1,0,0,0,1),['LeftAnkle']=CFrame.new(-0.001,-0.548,-0.001,1,0,0,0,1,0,0,0,1),['LeftHip']=CFrame.new(-0.501,-0.2,-0,1,0,0,0,1,0,0,0,1)},
        -- [2] = { ... }, [3] = { ... } dst
    }
}

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Runner"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 45, 0, 45)
IconButton.Position = UDim2.new(0, 10, 0.5, -22)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Text = "🎬"
IconButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IconButton.Parent = ScreenGui
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 255, 150)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 140, 0, 150)
MainFrame.Position = UDim2.new(0, 65, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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

-- [[ LOGIKA RUNNER (MENJALANKAN DATABASE) ]]
local function RunEmoteFromDatabase(name)
    if isEmotePlaying then isEmotePlaying = false task.wait(0.1) end
    
    local frames = Emotes[name]
    if not frames or #frames == 0 then return end
    
    isEmotePlaying = true
    
    task.spawn(function()
        local currentFrame = 1
        
        while isEmotePlaying do
            local data = frames[currentFrame]
            local char = Player.Character
            
            if char then
                -- Terapkan setiap Motor6D yang ada di database ke avatar
                for partName, cframeValue in pairs(data) do
                    local joint = char:FindFirstChild(partName, true)
                    if joint and joint:IsA("Motor6D") then
                        joint.C0 = cframeValue
                    end
                end
            end
            
            -- Pindah ke frame berikutnya, jika habis balik ke frame 1
            currentFrame = (currentFrame % #frames) + 1
            
            -- Kecepatan putar (0.05 - 0.1 pas untuk gerakan menari)
            task.wait(0.08) 
        end
    end)
end

-- Generate Button
for emoteName, _ in pairs(Emotes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = emoteName
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = Scroll
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() RunEmoteFromDatabase(emoteName) end)
end

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0.9, 0, 0, 30)
StopBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StopBtn.Text = "STOP"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Parent = MainFrame
Instance.new("UICorner", StopBtn)
StopBtn.MouseButton1Click:Connect(function() isEmotePlaying = false end)

IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
