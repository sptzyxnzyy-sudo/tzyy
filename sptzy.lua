-- RAJUAUTO SCANNER v5.5 - Updated Logic: Search -> Connect -> Execute
-- Design: Micro Square UI | Theme: Modern Neon

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajuPayload_V55_Updated"
ScreenGui.Parent = game.CoreGui

local selectedEvents = {}

-- 1. Toggle Button
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 35, 0, 35)
Toggle.Position = UDim2.new(0, 15, 0.45, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Toggle.Text = "🧪"
Toggle.TextColor3 = Color3.fromRGB(0, 255, 150)
Toggle.TextSize = 18
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)
local TStroke = Instance.new("UIStroke", Toggle)
TStroke.Color = Color3.fromRGB(0, 255, 150)
TStroke.Thickness = 1.5

-- 2. Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 250)
Main.Position = UDim2.new(0.5, -90, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Main.Visible = false
Main.Parent = ScreenGui

local MCorner = Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(0, 255, 150)
MStroke.Thickness = 1

-- 3. Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Header.Parent = Main
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "PAYLOAD SCANNER V5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.BackgroundTransparency = 1
Title.Parent = Header

-- 4. Status Label (New)
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 15)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 65)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 8
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = Main

-- 5. Scroll List
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0, 125)
Scroll.Position = UDim2.new(0.05, 0, 0, 85)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 3)

-- 6. Buttons Template
local function createBtn(txt, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 25)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 9
    b.Parent = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local ScanBtn = createBtn("1. SEARCH SERVER API", 35, Color3.fromRGB(35, 35, 45))
local SendBtn = createBtn("3. EXECUTE PAYLOAD", 218, Color3.fromRGB(0, 120, 80))
SendBtn.Visible = false

--- LOGIKA INTI ---

-- Fungsi Mencari API
local function searchAPI()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    table.clear(selectedEvents)
    StatusLabel.Text = "Status: Scanning..."
    
    local found = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            found = found + 1
            
            -- UI Item untuk API yang ditemukan
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 24)
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            b.Text = "  " .. obj.Name
            b.TextColor3 = Color3.fromRGB(180, 180, 180)
            b.Font = Enum.Font.Gotham
            b.TextSize = 8
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Parent = Scroll
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            
            -- Fungsi Menghubungkan (Connect)
            b.MouseButton1Click:Connect(function()
                if selectedEvents[obj] then
                    selectedEvents[obj] = nil
                    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                    b.TextColor3 = Color3.fromRGB(180, 180, 180)
                    StatusLabel.Text = "Status: Disconnected " .. obj.Name
                else
                    selectedEvents[obj] = true
                    b.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue for "Connected"
                    b.TextColor3 = Color3.fromRGB(255, 255, 255)
                    StatusLabel.Text = "Status: Connected to " .. obj.Name
                end
                SendBtn.Visible = next(selectedEvents) ~= nil
            end)
        end
    end
    StatusLabel.Text = "Status: Found " .. found .. " API Nodes"
end

-- Fungsi Eksekusi (Execute)
local function executePayload()
    StatusLabel.Text = "Status: Injecting Payload..."
    for remote, _ in pairs(selectedEvents) do
        local payload = {
            ["Value"] = math.random(1000, 9999),
            ["Action"] = "Bypass_Execute",
            ["Data"] = "Raju_System_v5"
        }
        
        task.spawn(function()
            pcall(function()
                remote:FireServer(payload)
            end)
        end)
    end
    
    -- Feedback Visual
    SendBtn.Text = "EXECUTING..."
    SendBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    task.wait(0.5)
    SendBtn.Text = "3. EXECUTE PAYLOAD"
    SendBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 80)
    StatusLabel.Text = "Status: Payload Sent Successfully"
end

-- Event Listeners
ScanBtn.MouseButton1Click:Connect(searchAPI)
SendBtn.MouseButton1Click:Connect(executePayload)

-- Dragging Logic (Fixed)
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Toggle.Text = Main.Visible and "X" or "🧪"
end)
