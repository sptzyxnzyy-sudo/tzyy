--[[
    sptzyy developer sl - Motion Recorder (3s Auto-Limit)
    Fitur: Auto-Stop 3 Detik, Minimalist UI, Fast Copy
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local setclipboard = setclipboard or print

local isRecording = false
local recordedFrames = {}
local lastRecordTime = 0
local recordInterval = 0.1 

-- [[ UI CONSTRUCTION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_3s_Recorder"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Text = "🎬"
IconButton.TextSize = 20
IconButton.Parent = ScreenGui
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 255, 150)

-- Draggable Logic
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
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local ConsoleBox = Instance.new("ScrollingFrame")
ConsoleBox.Size = UDim2.new(0.9, 0, 0.35, 0)
ConsoleBox.Position = UDim2.new(0.05, 0, 0.1, 0)
ConsoleBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
ConsoleBox.BorderSizePixel = 0
ConsoleBox.Parent = MainFrame

local CodeOutput = Instance.new("TextBox")
CodeOutput.Size = UDim2.new(1, -6, 1, 0)
CodeOutput.Position = UDim2.new(0, 3, 0, 3)
CodeOutput.Text = "-- Ready --"
CodeOutput.MultiLine = true
CodeOutput.TextWrapped = true
CodeOutput.TextEditable = false 
CodeOutput.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeOutput.Font = Enum.Font.Code
CodeOutput.TextSize = 7
CodeOutput.BackgroundTransparency = 1
CodeOutput.Parent = ConsoleBox

local RecordBtn = Instance.new("TextButton")
RecordBtn.Size = UDim2.new(0.9, 0, 0, 35)
RecordBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
RecordBtn.Text = "START (3s)"
RecordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RecordBtn.Font = Enum.Font.GothamBold
RecordBtn.Parent = MainFrame
Instance.new("UICorner", RecordBtn).CornerRadius = UDim.new(0, 6)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.9, 0, 0, 35)
CopyBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyBtn.Text = "COPY"
CopyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)

-- [[ LOGIC ]]
local function getJoints()
    local char = Player.Character
    if not char then return nil end
    local data = {}
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Motor6D") and v.Part0 and v.Part1 then data[v.Name] = v.C0 end
    end
    return data
end

local function generateCode()
    RecordBtn.Text = "GENERATING..."
    task.delay(0.1, function()
        local ot = {"local f = {"}
        for i, frame in ipairs(recordedFrames) do
            table.insert(ot, "["..i.."]={")
            for name, c0 in pairs(frame) do
                local comp = {c0:GetComponents()}
                local r = {}
                for _, v in ipairs(comp) do table.insert(r, math.floor(v*1000)/1000) end
                table.insert(ot, "['"..name.."']=CFrame.new("..table.concat(r, ",").."),")
            end
            table.insert(ot, "},")
        end
        table.insert(ot, "}\nlocal c = game.Players.LocalPlayer.Character\nwhile task.wait() do\n for _, fr in ipairs(f) do\n  for n, cf in pairs(fr) do\n   local m = c:FindFirstChild(n, true)\n   if m and m:IsA('Motor6D') then m.C0 = cf end\n  end\n  task.wait(0.1)\n end\nend")
        CodeOutput.Text = table.concat(ot, "")
        RecordBtn.Text = "START (3s)"
        RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    end)
end

RecordBtn.MouseButton1Click:Connect(function()
    if isRecording then return end -- Cegah double klik
    
    isRecording = true
    recordedFrames = {}
    RecordBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    
    -- Auto Stop Logic (3 Detik)
    task.spawn(function()
        for i = 3, 1, -1 do
            RecordBtn.Text = "RECORDING ("..i.."s)"
            task.wait(1)
        end
        isRecording = false
        generateCode()
    end)
end)

CopyBtn.MouseButton1Click:Connect(function()
    if CodeOutput.Text ~= "" and CodeOutput.Text ~= "-- Ready --" then
        setclipboard(CodeOutput.Text)
        CopyBtn.Text = "COPIED!"
        task.wait(1)
        CopyBtn.Text = "COPY"
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if isRecording then
        local now = tick()
        if now - lastRecordTime >= recordInterval then
            lastRecordTime = now
            local j = getJoints()
            if j then table.insert(recordedFrames, j) end
        end
    end
end)

IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
