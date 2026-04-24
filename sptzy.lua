-- Nama: sptzyy developer sl
-- Ukuran Frame: 300x300 (Square)

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local RemoteList = Instance.new("ScrollingFrame")
local LogList = Instance.new("ScrollingFrame")
local InputData = Instance.new("TextBox")
local SendBtn = Instance.new("TextButton")
local UIList1 = Instance.new("UIListLayout")
local UIList2 = Instance.new("UIListLayout")

-- Setup UI
ScreenGui.Name = "SptzyyDev_Square"
ScreenGui.Parent = game.CoreGui

-- Main Frame (300x300)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255) -- Neon Cyan Border
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150) -- Center Screen
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "SPTZYY DEVELOPER SL"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13

-- Box List Remote (Kiri - 135x120)
RemoteList.Parent = MainFrame
RemoteList.Position = UDim2.new(0, 10, 0, 40)
RemoteList.Size = UDim2.new(0, 135, 0, 120)
RemoteList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
RemoteList.CanvasSize = UDim2.new(0, 0, 10, 0)
RemoteList.ScrollBarThickness = 3

UIList1.Parent = RemoteList
UIList1.Padding = UDim.new(0, 2)

-- Box Log (Kanan - 135x120)
LogList.Parent = MainFrame
LogList.Position = UDim2.new(0, 155, 0, 40)
LogList.Size = UDim2.new(0, 135, 0, 120)
LogList.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LogList.CanvasSize = UDim2.new(0, 0, 10, 0)
LogList.ScrollBarThickness = 3

UIList2.Parent = LogList
UIList2.Padding = UDim.new(0, 2)

-- Input Teks (Bersih & Rapi)
InputData.Parent = MainFrame
InputData.Position = UDim2.new(0, 10, 0, 175)
InputData.Size = UDim2.new(0, 280, 0, 45)
InputData.PlaceholderText = "Masukkan data..."
InputData.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InputData.TextColor3 = Color3.new(1, 1, 1)
InputData.Text = ""
InputData.Font = Enum.Font.Gotham
InputData.TextSize = 14

-- Tombol Send
SendBtn.Parent = MainFrame
SendBtn.Position = UDim2.new(0, 10, 0, 235)
SendBtn.Size = UDim2.new(0, 280, 0, 50)
SendBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
SendBtn.Text = "PILIH REMOTE"
SendBtn.TextColor3 = Color3.new(1, 1, 1)
SendBtn.Font = Enum.Font.GothamBold

local selectedRemote = nil

-- Fungsi Log
local function addLog(msg, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "> " .. msg
    l.TextColor3 = color
    l.TextSize = 10
    l.Font = Enum.Font.Code
    l.Parent = LogList
end

-- Scan Remote
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 25)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = v.Name
        b.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        b.TextSize = 11
        b.Parent = RemoteList
        
        b.MouseButton1Click:Connect(function()
            selectedRemote = v
            SendBtn.Text = "KIRIM KE: " .. v.Name:sub(1, 15)
            SendBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
        end)
    end
end

-- Logika Kirim
SendBtn.MouseButton1Click:Connect(function()
    if selectedRemote and InputData.Text ~= "" then
        local ok, err = pcall(function() selectedRemote:FireServer(InputData.Text) end)
        if ok then
            addLog("Success: " .. selectedRemote.Name, Color3.fromRGB(0, 255, 100))
        else
            addLog("Error: " .. tostring(err), Color3.fromRGB(255, 50, 50))
        end
        InputData.Text = "" -- Bersihkan input
    else
        addLog("Pilih & Isi teks!", Color3.fromRGB(255, 165, 0))
    end
end)
