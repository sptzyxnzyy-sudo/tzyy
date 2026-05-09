-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteFinder_Square"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame (Ukuran diubah menjadi 300x300)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 15)

-- Rainbow border (Stroke)
local border = Instance.new("UIStroke", mainFrame)
border.Thickness = 2
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
border.Color = Color3.fromHSV(0, 1, 1)

task.spawn(function()
    local hue = 0
    while task.wait() do
        hue = (hue + 0.005) % 1
        border.Color = Color3.fromHSV(hue, 1, 1)
    end
end)

-- Top Bar (Header)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner", topBar)
topCorner.CornerRadius = UDim.new(0, 15)

-- Cover Rounded Bottom (Agar bagian bawah topbar tetap kotak/rapi menyatu dengan frame)
local cover = Instance.new("Frame")
cover.Size = UDim2.new(1, 0, 0, 10)
cover.Position = UDim2.new(0, 0, 1, -10)
cover.BackgroundColor3 = topBar.BackgroundColor3
cover.BorderSizePixel = 0
cover.Parent = topBar

local topText = Instance.new("TextLabel")
topText.Size = UDim2.new(1, -40, 1, 0)
topText.Position = UDim2.new(0, 12, 0, 0)
topText.Text = "RemoteEvent Finder"
topText.TextColor3 = Color3.fromRGB(255, 255, 255)
topText.TextSize = 14
topText.TextXAlignment = Enum.TextXAlignment.Left
topText.BackgroundTransparency = 1
topText.Font = Enum.Font.GothamBold
topText.Parent = topBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = topBar

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Scrolling Container (Area List)
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
scroll.Parent = mainFrame

local uiList = Instance.new("UIListLayout", scroll)
uiList.Padding = UDim.new(0, 5)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Loading UI
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0.8, 0, 0, 60)
loadingFrame.Position = UDim2.new(0.1, 0, 0.5, -30)
loadingFrame.BackgroundTransparency = 1
loadingFrame.Parent = mainFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.5, 0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 14
loadingText.Text = "Scanning Assets"
loadingText.Parent = loadingFrame

local progressBarBG = Instance.new("Frame")
progressBarBG.Size = UDim2.new(1, 0, 0, 6)
progressBarBG.Position = UDim2.new(0, 0, 0.7, 0)
progressBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressBarBG.Parent = loadingFrame
Instance.new("UICorner", progressBarBG)

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
progressBar.Parent = progressBarBG
Instance.new("UICorner", progressBar)

-- Mobile Dragging Logic
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Functionality
task.spawn(function()
    -- Animasi Loading
    for i = 1, 100 do
        progressBar.Size = UDim2.new(i/100, 0, 1, 0)
        loadingText.Text = "Scanning Remotes ("..i.."%)"
        task.wait(0.02)
    end
    
    loadingFrame:Destroy()

    -- Scan Remotes
    local function getRemotes()
        local found = {}
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(found, obj)
            end
        end
        return found
    end

    for _, remote in pairs(getRemotes()) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 35)
        btn.Text = "  " .. remote.Name
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.Parent = scroll
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        btn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(remote:GetFullName())
                btn.Text = "  COPIED!"
                task.wait(1)
                btn.Text = "  " .. remote.Name
            end
        end)
    end
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)
end)
