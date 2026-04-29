--[[
    Sptzyy Developer SL - Motion Recorder System
    Dirancang untuk Mobile (Studio Lite / Executor)
]]

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Variables untuk Recording
local isRecording = false
local recordedData = {}
local startTime = 0

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyRecorder"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Tombol Floating (Icon Emote)
local IconButton = Instance.new("TextButton")
IconButton.Size = UDim2.new(0, 60, 0, 60)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Text = "🕺"
IconButton.TextSize = 30
IconButton.Parent = ScreenGui

local UICornerIcon = Instance.new("UICorner")
UICornerIcon.CornerRadius = UDim.new(1, 0)
UICornerIcon.Parent = IconButton

local UIStrokeIcon = Instance.new("UIStroke")
UIStrokeIcon.Thickness = 2
UIStrokeIcon.Color = Color3.fromRGB(255, 255, 255)
UIStrokeIcon.Parent = IconButton

-- Membuat Icon bisa Digeser (Mobile Friendly)
local dragging, dragInput, dragStart, startPos
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

-- Main GUI (300x300)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MOTION RECORDER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local ConsoleBox = Instance.new("ScrollingFrame")
ConsoleBox.Size = UDim2.new(0.9, 0, 0.5, 0)
ConsoleBox.Position = UDim2.new(0.05, 0, 0.15, 0)
ConsoleBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ConsoleBox.CanvasSize = UDim2.new(0, 0, 5, 0)
ConsoleBox.Parent = MainFrame

local CodeOutput = Instance.new("TextBox")
CodeOutput.Size = UDim2.new(1, -10, 1, 0)
CodeOutput.Position = UDim2.new(0, 5, 0, 0)
CodeOutput.Text = "-- Kode hasil rekaman muncul di sini --"
CodeOutput.ClearTextOnFocus = false
CodeOutput.MultiLine = true
CodeOutput.TextWrapped = true
CodeOutput.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeOutput.TextXAlignment = Enum.TextXAlignment.Left
CodeOutput.TextYAlignment = Enum.TextYAlignment.Top
CodeOutput.BackgroundTransparency = 1
CodeOutput.Font = Enum.Font.Code
CodeOutput.TextSize = 10
CodeOutput.Parent = ConsoleBox

local RecordBtn = Instance.new("TextButton")
RecordBtn.Size = UDim2.new(0.8, 0, 0, 40)
RecordBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
RecordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
RecordBtn.Text = "START RECORDING"
RecordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RecordBtn.Font = Enum.Font.GothamBold
RecordBtn.Parent = MainFrame
Instance.new("UICorner", RecordBtn).CornerRadius = UDim.new(0, 10)

-- Logic Recording
local function getCFrameData()
    local char = Player.Character
    if not char then return nil end
    local data = {}
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            data[part.Name] = part.CFrame
        end
    end
    return data
end

RecordBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    if isRecording then
        recordedData = {}
        startTime = tick()
        RecordBtn.Text = "STOP & GENERATE"
        RecordBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        RecordBtn.Text = "START RECORDING"
        RecordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        -- Generate Code
        local finalScript = "local data = {\n"
        for i, frame in ipairs(recordedData) do
            finalScript = finalScript .. "  ["..i.."] = { "
            for partName, cf in pairs(frame) do
                finalScript = finalScript .. "['"..partName.."'] = CFrame.new("..tostring(cf).."), "
            end
            finalScript = finalScript .. " },\n"
        end
        finalScript = finalScript .. "}\n\n-- Script Playback:\nfor _, v in pairs(data) do\n  for p, cf in pairs(v) do\n    pcall(function() game.Players.LocalPlayer.Character[p].CFrame = cf end)\n  end\n  task.wait(0.03)\nend"
        
        CodeOutput.Text = finalScript
    end
end)

RunService.RenderStepped:Connect(function()
    if isRecording then
        local cfData = getCFrameData()
        if cfData then
            table.insert(recordedData, cfData)
        end
    end
end)

-- Open/Close Logic
IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
