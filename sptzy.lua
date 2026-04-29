--[[
    sptzyy developer sl - Ultra Fast Motion Recorder
    Optimasi: Fast Sampling & Table Concat
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local isRecording = false
local recordedFrames = {}
local lastRecordTime = 0
local recordInterval = 0.1 -- Rekam setiap 0.1 detik agar ringan & cepat

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Fast_Recorder"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 65, 0, 65)
IconButton.Position = UDim2.new(0.1, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Text = "🎬"
IconButton.TextSize = 30
IconButton.Parent = ScreenGui
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", IconButton)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 2

-- Draggable Logic
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
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local ConsoleBox = Instance.new("ScrollingFrame")
ConsoleBox.Size = UDim2.new(0.9, 0, 0.5, 0)
ConsoleBox.Position = UDim2.new(0.05, 0, 0.18, 0)
ConsoleBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ConsoleBox.CanvasSize = UDim2.new(0, 0, 10, 0)
ConsoleBox.Parent = MainFrame

local CodeOutput = Instance.new("TextBox")
CodeOutput.Size = UDim2.new(1, -10, 1, 0)
CodeOutput.Position = UDim2.new(0, 5, 0, 5)
CodeOutput.Text = "-- Klik Start --"
CodeOutput.MultiLine = true
CodeOutput.TextWrapped = true
CodeOutput.ClearTextOnFocus = false
CodeOutput.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeOutput.Font = Enum.Font.Code
CodeOutput.TextSize = 8
CodeOutput.BackgroundTransparency = 1
CodeOutput.Parent = ConsoleBox

local RecordBtn = Instance.new("TextButton")
RecordBtn.Size = UDim2.new(0.8, 0, 0, 45)
RecordBtn.Position = UDim2.new(0.1, 0, 0.78, 0)
RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
RecordBtn.Text = "START RECORDING"
RecordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RecordBtn.Font = Enum.Font.GothamBold
RecordBtn.Parent = MainFrame
Instance.new("UICorner", RecordBtn).CornerRadius = UDim.new(0, 10)

-- [[ LOGIKA OPTIMASI ]]

local function getJoints()
    local char = Player.Character
    if not char then return nil end
    local data = {}
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Motor6D") and v.Part0 and v.Part1 then
            data[v.Name] = v.C0
        end
    end
    return data
end

RecordBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    if isRecording then
        recordedFrames = {}
        RecordBtn.Text = "🔴 STOP & GENERATE"
        RecordBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    else
        RecordBtn.Text = "FAST GENERATING..."
        
        task.delay(0.1, function()
            local outputTable = {"local f = {"}
            
            for i, frame in ipairs(recordedFrames) do
                table.insert(outputTable, "["..i.."]={")
                for name, c0 in pairs(frame) do
                    local comp = {c0:GetComponents()}
                    local rounded = {}
                    for _, v in ipairs(comp) do table.insert(rounded, math.floor(v*1000)/1000) end
                    table.insert(outputTable, "['"..name.."']=CFrame.new("..table.concat(rounded, ",").."),")
                end
                table.insert(outputTable, "},")
            end
            
            table.insert(outputTable, "}\nlocal c = game.Players.LocalPlayer.Character\nwhile task.wait() do\n for _, fr in ipairs(f) do\n  for n, cf in pairs(fr) do\n   local m = c:FindFirstChild(n, true)\n   if m and m:IsA('Motor6D') then m.C0 = cf end\n  end\n  task.wait(0.1)\n end\nend")
            
            -- Konversi tabel ke string sekaligus (Jauh lebih cepat dari ..)
            CodeOutput.Text = table.concat(outputTable, "")
            RecordBtn.Text = "START RECORDING"
            RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if isRecording then
        local now = tick()
        if now - lastRecordTime >= recordInterval then
            lastRecordTime = now
            local joints = getJoints()
            if joints then table.insert(recordedFrames, joints) end
        end
    end
end)

IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
