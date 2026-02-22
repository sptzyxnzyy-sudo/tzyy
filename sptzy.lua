-- [[ PHANTOM SQUARE: CUSTOM MESSAGE REBORN ]] --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomMessengerV2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- [[ TOGGLE ICON (⚡) SUPPORT GESER ]] --
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

local IconCorner = Instance.new("UICorner", OpenBtn)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- [[ MAIN PANEL (PERSEGI RAPI) ]] --
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 280, 0, 220) -- Ukuran sedikit lebih besar untuk input
Main.Position = UDim2.new(0.5, -140, 0.4, -110)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Visible = false

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 1.5

-- [[ TITLE ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "MESSAGE EXECUTOR"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- [[ DISPLAY AREA (HASIL TEKS) ]] --
local DisplayLabel = Instance.new("TextLabel", Main)
DisplayLabel.Name = "DisplayLabel"
DisplayLabel.Size = UDim2.new(0.9, 0, 0, 50)
DisplayLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
DisplayLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
DisplayLabel.Text = "Menunggu Input..."
DisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayLabel.Font = Enum.Font.Code
DisplayLabel.TextSize = 11
DisplayLabel.TextWrapped = true
Instance.new("UICorner", DisplayLabel)

-- [[ INPUT BOX (TEMPAT KETIK) ]] --
local InputBox = Instance.new("TextBox", Main)
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(0.9, 0, 0, 40)
InputBox.Position = UDim2.new(0.05, 0, 0.48, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
InputBox.PlaceholderText = "Ketik pesan di sini..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 12
Instance.new("UICorner", InputBox)
local InputStroke = Instance.new("UIStroke", InputBox)
InputStroke.Color = Color3.fromRGB(0, 255, 255)
InputStroke.Thickness = 1

-- [[ ACTION BUTTON (UPDATE) ]] --
local UpdateBtn = Instance.new("TextButton", Main)
UpdateBtn.Name = "UpdateBtn"
UpdateBtn.Size = UDim2.new(0.9, 0, 0, 35)
UpdateBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
UpdateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
UpdateBtn.Text = "UPDATE PESAN"
UpdateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UpdateBtn.Font = Enum.Font.GothamBold
UpdateBtn.TextSize = 12
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
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(Main)
makeDraggable(OpenBtn)

-- [[ LOGIKA FITUR ]] --

-- 1. Fungsi Ganti Teks Manual
UpdateBtn.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        DisplayLabel.Text = InputBox.Text
        InputBox.Text = "" -- Bersihkan input setelah update
    end
end)

-- 2. Integrasi Event (Tetap jalan jika event dikirim dari server)
task.spawn(function()
    pcall(function()
        ReplicatedStorage:WaitForChild("NotifyEvent").OnClientEvent:Connect(function(customMsg)
            -- Jika event mengirim data, tampilkan. Jika tidak, gunakan teks default kamu.
            local msg = customMsg or "🎶 Lagu Dimainkan: Budak Ciamis (Requested by: Lawraa06)"
            DisplayLabel.Text = msg
        end)
    end)
end)

-- Toggle Menu
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
