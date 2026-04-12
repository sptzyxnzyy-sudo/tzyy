-- RAJUAUTO SCANNER v7.0 [FINAL]
-- Micro-Square UI | Server-Side Payload Manipulation

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Cleanup UI lama
if CoreGui:FindFirstChild("RajuFinal_V7") then
    CoreGui["RajuFinal_V7"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajuFinal_V7"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local selectedRemotes = {}

-- [1] Tombol Toggle (Floating Icon)
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 35, 0, 35)
Toggle.Position = UDim2.new(0, 15, 0.4, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Toggle.Text = "⚡"
Toggle.TextColor3 = Color3.fromRGB(0, 255, 255)
Toggle.TextSize = 18
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)
local TStroke = Instance.new("UIStroke", Toggle)
TStroke.Color = Color3.fromRGB(0, 255, 255)
TStroke.Thickness = 1.5

-- [2] Main Frame (Compact Square: 180x240)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 240)
Main.Position = UDim2.new(0.5, -90, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Visible = false
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MCorner = Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(0, 255, 255)
MStroke.Thickness = 1.2

-- [3] Header (Draggable Area)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Header.Parent = Main
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "MICRO EXECUTOR v7"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.BackgroundTransparency = 1
Title.Parent = Header

-- [4] Scroll List (Fungsi Scroll Penuh)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0, 130)
Scroll.Position = UDim2.new(0.05, 0, 0, 70)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 3)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

-- [5] Control Buttons
local function createBtn(txt, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 24)
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

local ScanBtn = createBtn("REFRESH NETWORK", 38, Color3.fromRGB(35, 35, 45))
local ExecBtn = createBtn("EXECUTE SERVER-SIDE", 205, Color3.fromRGB(0, 100, 150))
ExecBtn.Visible = false

--- FUNGSI LOGIKA ---

-- Dragging System
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

-- Open/Close UI
Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Toggle.Text = Main.Visible and "X" or "⚡"
end)

-- List Item Generator
local function addRemote(remote)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 24)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    b.Text = "  " .. remote.Name
    b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.Font = Enum.Font.Gotham
    b.TextSize = 8
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    b.MouseButton1Click:Connect(function()
        if selectedRemotes[remote] then
            selectedRemotes[remote] = nil
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            b.TextColor3 = Color3.fromRGB(180, 180, 180)
        else
            selectedRemotes[remote] = true
            b.BackgroundColor3 = Color3.fromRGB(0, 60, 80)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        ExecBtn.Visible = next(selectedRemotes) ~= nil
    end)
end

-- Scanner Feature (Berfungsi Mendeteksi Semua)
ScanBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    table.clear(selectedRemotes)
    ExecBtn.Visible = false
    
    local found = game:GetDescendants()
    for _, obj in pairs(found) do
        if obj:IsA("RemoteEvent") then
            addRemote(obj)
        end
    end
end)

-- Execution Feature (Server-Side Data Manipulation)
ExecBtn.MouseButton1Click:Connect(function()
    for remote, _ in pairs(selectedRemotes) do
        task.spawn(function()
            -- PAYLOAD MANIPULATION: Data yang dikirim ke server
            -- Silahkan sesuaikan isi tabel ini dengan data manipulasi kamu
            local payload = {
                ["Status"] = "Activated",
                ["Amount"] = 999999,
                ["Admin"] = true
            }
            
            local success, err = pcall(function()
                remote:FireServer(payload)
            end)
            
            if success then
                ExecBtn.Text = "SUCCESS!"
                ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            else
                ExecBtn.Text = "FAILED"
                ExecBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            end
            
            task.wait(0.5)
            ExecBtn.Text = "EXECUTE SERVER-SIDE"
            ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
        end)
    end
end)
