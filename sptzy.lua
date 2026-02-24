-- [[ PHANTOM SQUARE: V11 HYBRID SCANNER - SQUARE EDITION ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- [[ STATE ]] --
local remoteButtons = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SptzyyHybridV11"
ScreenGui.ResetOnSpawn = false

-- TOGGLE ICON (SQUARE)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.Text = "V11"
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
OpenBtn.Font = Enum.Font.Code
OpenBtn.BorderSizePixel = 2
OpenBtn.BorderColor3 = Color3.fromRGB(0, 255, 255)

-- MAIN PANEL (SQUARE)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 480) -- Lebih luas sedikit
Main.Position = UDim2.new(0.5, -240, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(0, 255, 255)
Main.Visible = false

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "HYBRID REMOTE EXECUTOR V11"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.Code
Title.TextSize = 16

-- SCROLLING LIST
local ListFrame = Instance.new("ScrollingFrame", Main)
ListFrame.Size = UDim2.new(0.94, 0, 0, 310)
ListFrame.Position = UDim2.new(0.03, 0, 0.22, 0)
ListFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
ListFrame.BorderSizePixel = 1
ListFrame.BorderColor3 = Color3.fromRGB(40, 40, 45)
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.ScrollBarThickness = 6

local ListLayout = Instance.new("UIListLayout", ListFrame)
ListLayout.Padding = UDim.new(0, 2)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- SCAN BUTTON
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.94, 0, 0, 40)
ScanBtn.Position = UDim2.new(0.03, 0, 0.11, 0)
ScanBtn.Text = "SCAN ALL REMOTES (RE/RF)"
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.BorderSizePixel = 1
ScanBtn.BorderColor3 = Color3.fromRGB(0, 255, 255)
ScanBtn.Font = Enum.Font.Code

-- STATUS BAR
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 35)
Status.Position = UDim2.new(0, 0, 0.9, 0)
Status.Text = "[WAITING FOR SCAN]"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code
Status.TextSize = 11

---

-- [[ DRAGGING SYSTEM ]] --
local function ApplyDrag(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

ApplyDrag(Main)
ApplyDrag(OpenBtn)

---

-- [[ CORE LOGIC ]] --
local function clearList()
    for _, btn in pairs(remoteButtons) do btn:Destroy() end
    remoteButtons = {}
end

local function executeObject(obj)
    local success, _ = pcall(function()
        if obj:IsA("RemoteEvent") then
            obj:FireServer()
        elseif obj:IsA("RemoteFunction") then
            -- Note: InvokeServer bisa membuat script "hang" jika server tidak merespon. 
            -- Di sini kita batasi agar tidak merusak UI.
            task.spawn(function() obj:InvokeServer() end)
        end
    end)
    
    if success then
        Status.Text = "[SUCCESS] TRIGGERED: " .. obj.Name
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        Status.Text = "[FAILED] BLOCKED: " .. obj.Name
        Status.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

ScanBtn.MouseButton1Click:Connect(function()
    clearList()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            count = count + 1
            local Btn = Instance.new("TextButton", ListFrame)
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            Btn.BorderSizePixel = 1
            Btn.BorderColor3 = Color3.fromRGB(45, 45, 50)
            
            -- Pembeda Visual
            local prefix = obj:IsA("RemoteEvent") and "[RE]" or "[RF]"
            local textColor = obj:IsA("RemoteEvent") and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 0, 255)
            
            Btn.Text = "  " .. prefix .. " " .. obj.Name
            Btn.TextColor3 = textColor
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Font = Enum.Font.Code
            Btn.TextSize = 12
            
            Btn.MouseButton1Click:Connect(function()
                Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                executeObject(obj)
                task.wait(0.2)
                Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            end)
            table.insert(remoteButtons, Btn)
        end
    end
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 32)
    Status.Text = "[SCAN COMPLETE: " .. count .. " OBJECTS]"
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
