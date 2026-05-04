-- Memastikan script hanya jalan satu kali
if game:GetService("CoreGui"):FindFirstChild("DeltaExecutorUI") then
    game:GetService("CoreGui").DeltaExecutorUI:Destroy()
end

-- SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- GUI ROOT (Menggunakan CoreGui agar tidak hilang saat mati/reset)
local sgui = Instance.new("ScreenGui")
sgui.Name = "DeltaExecutorUI"
sgui.ResetOnSpawn = false
sgui.Parent = game:GetService("CoreGui") 

-- MAIN PANEL (300x300)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.fromOffset(300, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Parent = sgui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(50, 50, 50)
stroke.Thickness = 2

-- TITLE BAR (Area untuk menyeret/drag)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local tCorner = Instance.new("UICorner", titleBar)
tCorner.CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "DELTA EXECUTOR"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

-- CONTAINER BUTTONS
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -30, 1, -60)
container.Position = UDim2.new(0, 15, 0, 55)
container.BackgroundTransparency = 1
container.Parent = mainFrame

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- LOGIC FUNCTIONS (Tanpa Remote)
local function executeReset()
    local char = player.Character
    if char then
        char:BreakJoints() -- Cara simpel untuk /re di executor
    end
end

local function executeRejoin()
    local ts = game:GetService("TeleportService")
    local p = game:GetService("Players").LocalPlayer
    ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
end

-- CREATE BUTTON FUNCTION
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.Parent = container
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
end

-- DAFTAR FITUR
createButton("Reset Character (/re)", executeReset)
createButton("Rejoin Game (/rejoin)", executeRejoin)

-- DRAGGABLE SYSTEM
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- TOGGLE LOGIC
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- TOMBOL FLOATING UNTUK OPEN KEMBALI
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.fromOffset(50, 50)
openBtn.Position = UDim2.new(0, 20, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openBtn.Text = "EXE"
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.GothamBold
openBtn.Parent = sgui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local opStroke = Instance.new("UIStroke", openBtn)
opStroke.Color = Color3.new(1, 1, 1)
opStroke.Thickness = 2

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
