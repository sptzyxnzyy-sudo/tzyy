--[[
    sptzyy developer sl - Motion Recorder Pro (Looping Edition)
    Optimized for Mobile/Executor
]]

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local isRecording = false
local recordedFrames = {}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyRecorderLoop"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Floating Icon (Draggable)
local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 60, 0, 60)
IconButton.Position = UDim2.new(0.1, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
IconButton.Text = "💃"
IconButton.TextSize = 30
IconButton.Parent = ScreenGui
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", IconButton)
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 2

-- Draggable Logic (Mobile Friendly)
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

-- Main Frame (300x300)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "EMOTE RECORDER (LOOP)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local ConsoleBox = Instance.new("ScrollingFrame")
ConsoleBox.Size = UDim2.new(0.9, 0, 0.55, 0)
ConsoleBox.Position = UDim2.new(0.05, 0, 0.15, 0)
ConsoleBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
ConsoleBox.BorderSizePixel = 0
ConsoleBox.CanvasSize = UDim2.new(0, 0, 15, 0) -- Lebih panjang untuk data frame
ConsoleBox.Parent = MainFrame

local CodeOutput = Instance.new("TextBox")
CodeOutput.Size = UDim2.new(1, -10, 1, 0)
CodeOutput.Position = UDim2.new(0, 5, 0, 0)
CodeOutput.Text = "-- Klik 'START' untuk merekam gerakan --"
CodeOutput.MultiLine = true
CodeOutput.TextWrapped = true
CodeOutput.ClearTextOnFocus = false
CodeOutput.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeOutput.Font = Enum.Font.Code
CodeOutput.TextSize = 10
CodeOutput.BackgroundTransparency = 1
CodeOutput.TextXAlignment = Enum.TextXAlignment.Left
CodeOutput.TextYAlignment = Enum.TextYAlignment.Top
CodeOutput.Parent = ConsoleBox

local RecordBtn = Instance.new("TextButton")
RecordBtn.Size = UDim2.new(0.8, 0, 0, 45)
RecordBtn.Position = UDim2.new(0.1, 0, 0.78, 0)
RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
RecordBtn.Text = "START RECORD"
RecordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RecordBtn.Font = Enum.Font.GothamBold
RecordBtn.Parent = MainFrame
Instance.new("UICorner", RecordBtn).CornerRadius = UDim.new(0, 8)

-- Fungsi mengambil Motor6D
local function captureJoints()
    local char = Player.Character
    if not char then return nil end
    local joints = {}
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Motor6D") then
            joints[v.Name] = v.C0
        end
    end
    return joints
end

RecordBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    if isRecording then
        recordedFrames = {}
        RecordBtn.Text = "🔴 RECORDING..."
        RecordBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        RecordBtn.Text = "GENERATING CODE..."
        RecordBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        -- Generate Result dengan Looping Logic
        local s = "--[[ SPTZYY MOTION SYSTEM ]]\n"
        s = s .. "local frames = {\n"
        for i, joints in ipairs(recordedFrames) do
            s = s .. "  [" .. i .. "] = {"
            for name, c0 in pairs(joints) do
                local c = {c0:GetComponents()}
                -- Membulatkan angka agar teks tidak terlalu panjang untuk Mobile clipboard
                local shortC = {}
                for _, val in ipairs(c) do table.insert(shortC, math.floor(val*1000)/1000) end
                s = s .. "['" .. name .. "']=CFrame.new(" .. table.concat(shortC, ",") .. "),"
            end
            s = s .. "},\n"
        end
        s = s .. "}\n\n"
        s = s .. "-- PLAYBACK WITH INFINITE LOOP\n"
        s = s .. "local char = game.Players.LocalPlayer.Character\n"
        s = s .. "while task.wait() do\n"
        s = s .. "  for _, f in ipairs(frames) do\n"
        s = s .. "    for name, c0 in pairs(f) do\n"
        s = s .. "      local m = char:FindFirstChild(name, true)\n"
        s = s .. "      if m and m:IsA('Motor6D') then m.C0 = c0 end\n"
        s = s .. "    end\n"
        s = s .. "    task.wait(0.03) -- Atur kecepatan di sini\n"
        s = s .. "  end\n"
        s = s .. "end"
        
        CodeOutput.Text = s
        RecordBtn.Text = "START RECORD"
        RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end
end)

RunService.RenderStepped:Connect(function()
    if isRecording then
        local data = captureJoints()
        if data then table.insert(recordedFrames, data) end
    end
end)

IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
