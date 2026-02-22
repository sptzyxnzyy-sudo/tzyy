-- [[ PHANTOM SQUARE: ULTIMATE MONITOR REBORN ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- [[ SETTINGS & STATE ]] --
local autoListen = true
local historyLog = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomLogV3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- [[ TOGGLE ICON (⚡) ]] --
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "MainIcon"
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenBtn.Text = "⚡"
OpenBtn.TextSize = 25
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
OpenBtn.ZIndex = 10
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(0, 255, 255)

-- [[ MAIN PANEL ]] --
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 320, 0, 380)
Main.Position = UDim2.new(0.5, -160, 0.4, -190)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 255)

-- [[ HEADER & ON/OFF BUTTON ]] --
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Text = "SYSTEM MONITOR"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local ToggleBtn = Instance.new("TextButton", Header)
ToggleBtn.Size = UDim2.new(0, 80, 0, 25)
ToggleBtn.Position = UDim2.new(0.68, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ToggleBtn.Text = "AUTO: ON"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 10
Instance.new("UICorner", ToggleBtn)

-- [[ DISPLAY LOG (HISTORY) ]] --
local LogFrame = Instance.new("Frame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0, 150)
LogFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Instance.new("UICorner", LogFrame)

local LogText = Instance.new("TextLabel", LogFrame)
LogText.Size = UDim2.new(0.95, 0, 0.9, 0)
LogText.Position = UDim2.new(0.025, 0, 0.05, 0)
LogText.BackgroundTransparency = 1
LogText.Text = "--- History Log ---"
LogText.TextColor3 = Color3.fromRGB(200, 200, 200)
LogText.TextSize = 10
LogText.Font = Enum.Font.Code
LogText.TextWrapped = true
LogText.TextYAlignment = Enum.TextYAlignment.Top

-- [[ INPUT AREA ]] --
local InputBox = Instance.new("TextBox", Main)
InputBox.Size = UDim2.new(0.9, 0, 0, 40)
InputBox.Position = UDim2.new(0.05, 0, 0.55, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
InputBox.PlaceholderText = "Ketik pesan manual..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 12
Instance.new("UICorner", InputBox)

local UpdateBtn = Instance.new("TextButton", Main)
UpdateBtn.Size = UDim2.new(0.9, 0, 0, 40)
UpdateBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
UpdateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
UpdateBtn.Text = "ADD MANUAL LOG"
UpdateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UpdateBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", UpdateBtn)

-- [[ DRAG SYSTEM ]] --
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function() dragging = false end)
end
makeDraggable(Main)
makeDraggable(OpenBtn)

-- [[ CORE LOGIC ]] --

local function updateDisplay()
    local fullText = ""
    for i, msg in ipairs(historyLog) do
        fullText = fullText .. "[" .. i .. "] " .. msg .. "\n\n"
    end
    LogText.Text = fullText
end

local function addLog(msg)
    table.insert(historyLog, 1, msg) -- Masukkan ke urutan paling atas
    if #historyLog > 5 then
        table.remove(historyLog, 6) -- Simpan hanya 5 terakhir
    end
    updateDisplay()
end

-- Listener NotifyEvent
ReplicatedStorage:WaitForChild("NotifyEvent").OnClientEvent:Connect(function(message)
    if autoListen then
        addLog(tostring(message))
    end
end)

-- Tombol On/Off
ToggleBtn.MouseButton1Click:Connect(function()
    autoListen = not autoListen
    ToggleBtn.Text = autoListen and "AUTO: ON" or "AUTO: OFF"
    ToggleBtn.BackgroundColor3 = autoListen and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

-- Tombol Manual
UpdateBtn.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        addLog("MANUAL: " .. InputBox.Text)
        InputBox.Text = ""
    end
end)

-- Toggle Menu
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
