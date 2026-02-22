-- [[ PHANTOM SQUARE: REMOTE SCANNER & CLICK-SELECT ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- [[ STATE MANAGEMENT ]] --
local selectedRemote = nil
local isLooping = false
local remoteButtons = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomScannerV5"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- [[ TOGGLE ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenBtn.Text = "⚡"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
OpenBtn.TextSize = 25
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)

-- [[ MAIN PANEL ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 400)
Main.Position = UDim2.new(0.5, -175, 0.4, -200)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 255)

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "REMOTE SELECTOR"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- [[ SCROLLING LIST (REPLACES MANUAL INPUT) ]] --
local ListFrame = Instance.new("ScrollingFrame", Main)
ListFrame.Size = UDim2.new(0.9, 0, 0, 220)
ListFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
ListFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Dynamic
ListFrame.ScrollBarThickness = 4

local ListLayout = Instance.new("UIListLayout", ListFrame)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 5)

-- [[ SCAN & EXECUTE BUTTONS ]] --
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.42, 0, 0, 40)
ScanBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ScanBtn.Text = "SCAN ALL"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
Instance.new("UICorner", ScanBtn)

local LoopBtn = Instance.new("TextButton", Main)
LoopBtn.Size = UDim2.new(0.42, 0, 0, 40)
LoopBtn.Position = UDim2.new(0.53, 0, 0.7, 0)
LoopBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
LoopBtn.Text = "START LOOP"
LoopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", LoopBtn)

-- [[ STATUS BAR ]] --
local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0.85, 0)
StatusLabel.Text = "TARGET: NONE"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Code

---

-- Fungsi untuk membersihkan list lama
local function clearList()
    for _, btn in pairs(remoteButtons) do
        btn:Destroy()
    end
    remoteButtons = {}
end

-- Fungsi Scan dan Buat Tombol di List
ScanBtn.MouseButton1Click:Connect(function()
    clearList()
    local count = 0
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            count = count + 1
            local Btn = Instance.new("TextButton", ListFrame)
            Btn.Size = UDim2.new(1, -10, 0, 30)
            Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            Btn.Text = "  " .. obj.Name
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Font = Enum.Font.SourceSans
            Instance.new("UICorner", Btn)
            
            -- Logika Klik Pilihan
            Btn.MouseButton1Click:Connect(function()
                selectedRemote = obj
                StatusLabel.Text = "TARGET: " .. obj.Name
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                
                -- Efek visual saat diklik
                for _, b in pairs(remoteButtons) do b.BackgroundColor3 = Color3.fromRGB(20, 20, 35) end
                Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
            end)
            
            table.insert(remoteButtons, Btn)
        end
    end
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 35)
    StatusLabel.Text = "FOUND " .. count .. " REMOTES"
end)

-- Loop Eksekusi
local function runExecutionLoop()
    while isLooping do
        if selectedRemote and selectedRemote.Parent then
            -- Simulasi pemanggilan remote (FireServer)
            -- Kamu bisa ganti logic ini dengan listener atau executor
            pcall(function()
                -- selectedRemote:FireServer() -- UNCOMMENT JIKA INGIN SPAM (HATI-HATI)
                print("Interacting with: " .. selectedRemote.Name)
            end)
        end
        task.wait(1)
    end
end

LoopBtn.MouseButton1Click:Connect(function()
    if not selectedRemote then 
        StatusLabel.Text = "SELECT A REMOTE FIRST!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return 
    end

    isLooping = not isLooping
    if isLooping then
        LoopBtn.Text = "STOP LOOP"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.spawn(runExecutionLoop)
    else
        LoopBtn.Text = "START LOOP"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

-- Draggable Logic (Utility)
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function() dragging = false end)
end

makeDraggable(Main); makeDraggable(OpenBtn)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
