-- [[ PHANTOM SQUARE: V9 CLEAN STEALTH - NO NOTIF ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- [[ SETTINGS ]] --
local remoteButtons = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SptzyyCleanV9"
ScreenGui.ResetOnSpawn = false

-- TOGGLE ICON (Draggable)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -27)
OpenBtn.Text = "V9"
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
OpenBtn.TextSize = 20
OpenBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 2

-- MAIN PANEL (Wide & Draggable)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 450)
Main.Position = UDim2.new(0.5, -225, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.Visible = false
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "REMOTE SELECTOR V9 (STEALTH)"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- SCROLLING LIST
local ListFrame = Instance.new("ScrollingFrame", Main)
ListFrame.Size = UDim2.new(0.9, 0, 0, 280)
ListFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
ListFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.ScrollBarThickness = 4
ListFrame.BorderSizePixel = 0

local ListLayout = Instance.new("UIListLayout", ListFrame)
ListLayout.Padding = UDim.new(0, 5)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- SCAN BUTTON
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 45)
ScanBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
ScanBtn.Text = "SCAN REMOTEEVENTS"
ScanBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 30)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", ScanBtn)

-- LOG STATUS
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0.88, 0)
Status.Text = "System Idle"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code
Status.TextSize = 12

---

-- Fungsi Utility: Bersihkan List
local function clearList()
    for _, btn in pairs(remoteButtons) do
        btn:Destroy()
    end
    remoteButtons = {}
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end

-- Fungsi Eksekusi Stealth (TANPA NOTIF/PAYLOAD)
local function executeRemote(remote)
    local success, _ = pcall(function()
        -- Hanya memicu event tanpa mengirim data apa pun
        remote:FireServer() 
    end)
    
    if success then
        Status.Text = "Fired: " .. remote.Name
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        print("[V9 Success] Executed: " .. remote:GetFullName())
    else
        Status.Text = "Blocked: " .. remote.Name
        Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

-- Fungsi Scan & List Generator
ScanBtn.MouseButton1Click:Connect(function()
    clearList()
    local count = 0
    
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            count = count + 1
            
            local Btn = Instance.new("TextButton", ListFrame)
            Btn.Size = UDim2.new(0.95, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Btn.Text = "  " .. obj.Name
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Font = Enum.Font.SourceSansSemibold
            Btn.TextSize = 14
            Instance.new("UICorner", Btn)
            
            Btn.MouseButton1Click:Connect(function()
                Btn.BackgroundColor3 = Color3.fromRGB(0, 80, 150)
                executeRemote(obj)
                task.wait(0.15)
                Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            end)
            
            table.insert(remoteButtons, Btn)
        end
    end
    
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 40)
    Status.Text = "Total Remotes: " .. count
    Status.TextColor3 = Color3.fromRGB(0, 255, 150)
end)

---

-- SISTEM DRAG STABIL (ICON & MAIN GUI)
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

makeDraggable(Main)
makeDraggable(OpenBtn)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
