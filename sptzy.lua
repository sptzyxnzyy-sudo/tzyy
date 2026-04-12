-- Auto RemoteEvent Scanner & Executor for Roblox
-- By RajuAI - Full Bypass Version

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "RajuAI_Scanner"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "RAJUAUTO SCANNER v3.0"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local ScanButton = Instance.new("TextButton")
ScanButton.Size = UDim2.new(0.9, 0, 0, 40)
ScanButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ScanButton.Text = "🔍 SCAN REMOTEEVENTS"
ScanButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.Font = Enum.Font.Gotham
ScanButton.TextSize = 14
ScanButton.Parent = MainFrame

local EventsFrame = Instance.new("ScrollingFrame")
EventsFrame.Size = UDim2.new(0.9, 0, 0, 300)
EventsFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
EventsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
EventsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
EventsFrame.ScrollBarThickness = 8
EventsFrame.Parent = MainFrame

local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Size = UDim2.new(0.9, 0, 0, 40)
ExecuteButton.Position = UDim2.new(0.05, 0, 0.85, 0)
ExecuteButton.Text = "🚀 EXECUTE SELECTED"
ExecuteButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.Font = Enum.Font.GothamBold
ExecuteButton.TextSize = 16
ExecuteButton.Visible = false
ExecuteButton.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.95, 0)
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = MainFrame

local selectedEvents = {}
local eventButtons = {}

-- NOTIFIKASI SYSTEM
local function showNotification(message, color)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(1, 10, 0.8, 0)
    notif.Text = "📢 " .. message
    notif.TextColor3 = color
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    notif.BorderSizePixel = 2
    notif.BorderColor3 = Color3.fromRGB(50, 50, 70)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 12
    notif.Parent = ScreenGui
    
    game:GetService("TweenService"):Create(
        notif,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {Position = UDim2.new(1, -320, 0.8, 0)}
    ):Play()
    
    wait(3)
    
    game:GetService("TweenService"):Create(
        notif,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {Position = UDim2.new(1, 10, 0.8, 0)}
    ):Play()
    
    wait(0.5)
    notif:Destroy()
end

-- SCAN SEMUA REMOTEEVENTS
ScanButton.MouseButton1Click:Connect(function()
    showNotification("Memulai scan...", Color3.fromRGB(255, 200, 50))
    StatusLabel.Text = "Status: Scanning..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    
    -- Clear previous
    for _, btn in pairs(eventButtons) do
        btn:Destroy()
    end
    table.clear(eventButtons)
    table.clear(selectedEvents)
    EventsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local yOffset = 5
    local foundCount = 0
    
    -- Scan workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            foundCount = foundCount + 1
            createEventButton(obj, "Workspace", yOffset)
            yOffset = yOffset + 35
        end
    end
    
    -- Scan ReplicatedStorage
    for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            foundCount = foundCount + 1
            createEventButton(obj, "ReplicatedStorage", yOffset)
            yOffset = yOffset + 35
        end
    end
    
    -- Scan semua services
    for _, service in pairs(game:GetServices()) do
        pcall(function()
            for _, obj in pairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    foundCount = foundCount + 1
                    createEventButton(obj, service.Name, yOffset)
                    yOffset = yOffset + 35
                end
            end
        end)
    end
    
    EventsFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    ExecuteButton.Visible = (foundCount > 0)
    
    StatusLabel.Text = "Status: Found " .. foundCount .. " RemoteEvents"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    showNotification("Scan selesai! " .. foundCount .. " events ditemukan", Color3.fromRGB(100, 255, 100))
end)

-- BUAT BUTTON UNTUK SETIAP REMOTEEVENT
function createEventButton(remoteEvent, location, yPos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.95, 0, 0, 30)
    button.Position = UDim2.new(0.025, 0, 0, yPos)
    button.Text = "📡 " .. remoteEvent.Name .. " (" .. location .. ")"
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Font = Enum.Font.Gotham
    button.TextSize = 11
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = EventsFrame
    
    local selectIndicator = Instance.new("Frame")
    selectIndicator.Size = UDim2.new(0, 5, 1, 0)
    selectIndicator.Position = UDim2.new(0, 0, 0, 0)
    selectIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    selectIndicator.Visible = false
    selectIndicator.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if selectedEvents[remoteEvent] then
            selectedEvents[remoteEvent] = nil
            selectIndicator.Visible = false
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        else
            selectedEvents[remoteEvent] = {
                Object = remoteEvent,
                Location = location
            }
            selectIndicator.Visible = true
            button.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        end
        showNotification("Selected: " .. remoteEvent.Name, Color3.fromRGB(100, 150, 255))
    end)
    
    table.insert(eventButtons, button)
end

-- EXECUTE SEMUA YANG DIPILIH
ExecuteButton.MouseButton1Click:Connect(function()
    local selectedCount = 0
    for _ in pairs(selectedEvents) do
        selectedCount = selectedCount + 1
    end
    
    if selectedCount == 0 then
        showNotification("Pilih event terlebih dahulu!", Color3.fromRGB(255, 50, 50))
        return
    end
    
    StatusLabel.Text = "Status: Executing " .. selectedCount .. " events..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
    
    showNotification("⚡ Executing " .. selectedCount .. " RemoteEvents...", Color3.fromRGB(255, 100, 100))
    
    -- Hook semua remote events yang dipilih
    for _, data in pairs(selectedEvents) do
        local remote = data.Object
        
        pcall(function()
            -- Hook FireServer
            local oldFire = remote.FireServer
            remote.FireServer = function(self, ...)
                showNotification("🔥 " .. remote.Name .. " FIRED", Color3.fromRGB(255, 50, 50))
                return oldFire(self, ...)
            end
            
            -- Hook OnClientEvent jika ada
            if remote.OnClientEvent then
                local oldOnClient = remote.OnClientEvent
                remote.OnClientEvent = function(self, ...)
                    showNotification("📥 " .. remote.Name .. " RECEIVED", Color3.fromRGB(50, 150, 255))
                    return oldOnClient(self, ...)
                end
            end
        end)
        
        -- Trigger otomatis jika ingin
        pcall(function()
            remote:FireServer()
            wait(0.1)
        end)
    end
    
    StatusLabel.Text = "Status: Executed " .. selectedCount .. " events"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    showNotification("✅ Execution complete!", Color3.fromRGB(100, 255, 100))
end)

-- DRAGGABLE WINDOW
local dragging
local dragInput
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- INITIAL NOTIF
showNotification("RAJUAUTO SCANNER LOADED", Color3.fromRGB(255, 50, 50))
StatusLabel.Text = "Status: Ready - Click SCAN to begin"
