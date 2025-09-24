local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer

-- 🔽 GUI Utama 🔽
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScanServerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 400)
frame.Position = UDim2.new(0.5, -200, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Judul GUI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Server Scan"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Tombol Scan Server
local scanButton = Instance.new("TextButton")
scanButton.Size = UDim2.new(0, 160, 0, 40)
scanButton.Position = UDim2.new(0.5, -80, 0.1, 0)
scanButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
scanButton.Text = "Scan Server"
scanButton.TextColor3 = Color3.new(1, 1, 1)
scanButton.Font = Enum.Font.GothamBold
scanButton.TextSize = 15
scanButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = scanButton

-- Tombol Salin Hasil (Copy)
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 160, 0, 40)
copyButton.Position = UDim2.new(0.5, -80, 0.2, 0)
copyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
copyButton.Text = "Copy Results"
copyButton.TextColor3 = Color3.new(1, 1, 1)
copyButton.Font = Enum.Font.GothamBold
copyButton.TextSize = 15
copyButton.Parent = frame

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 10)
copyButtonCorner.Parent = copyButton

-- Scroll Frame untuk Menampilkan Hasil Scan
local resultFrame = Instance.new("ScrollingFrame")
resultFrame.Size = UDim2.new(1, 0, 1, -80)
resultFrame.Position = UDim2.new(0, 0, 0, 40)
resultFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
resultFrame.ScrollBarThickness = 6
resultFrame.BackgroundTransparency = 1
resultFrame.Parent = frame

local resultListLayout = Instance.new("UIListLayout")
resultListLayout.Padding = UDim.new(0, 5)
resultListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
resultListLayout.SortOrder = Enum.SortOrder.LayoutOrder
resultListLayout.Parent = resultFrame

resultListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    resultFrame.CanvasSize = UDim2.new(0, 0, 0, resultListLayout.AbsoluteContentSize.Y + 10)
end)

-- Fungsi untuk Menampilkan Hasil Scan Server
local function showScanResults(objects)
    -- Bersihkan hasil sebelumnya
    for _, child in pairs(resultFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    -- Tampilkan hasil scan
    for _, obj in pairs(objects) do
        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(1, -10, 0, 25)
        resultLabel.BackgroundTransparency = 1
        resultLabel.Text = obj.Name
        resultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        resultLabel.Font = Enum.Font.SourceSans
        resultLabel.TextSize = 14
        resultLabel.TextTruncate = Enum.TextTruncate.AtEnd
        resultLabel.Parent = resultFrame
    end
end

-- Fungsi untuk Scan Server
local function scanServer()
    local objects = {}

    -- Ambil semua objek di Workspace dan masukkan nama-nama objeknya
    for _, obj in pairs(Workspace:GetChildren()) do
        table.insert(objects, obj)
    end

    -- Tampilkan hasil scan
    showScanResults(objects)
end

-- Fungsi untuk Menyalin Hasil Scan
local function copyResults()
    local resultText = ""
    
    -- Gabungkan semua nama objek menjadi satu string
    for _, label in pairs(resultFrame:GetChildren()) do
        if label:IsA("TextLabel") then
            resultText = resultText .. label.Text .. "\n"
        end
    end

    -- Menyalin teks ke clipboard
    if GuiService:IsClipboardAvailable() then
        GuiService:SetClipboard(resultText)
    else
        warn("Clipboard not available.")
    end
end

-- Tombol Scan Server
scanButton.MouseButton1Click:Connect(function()
    scanServer()
end)

-- Tombol Salin Hasil Scan
copyButton.MouseButton1Click:Connect(function()
    copyResults()
end)

-- 🔽 Tombol Tutup/Open GUI (X/Lingkaran) 🔽
local closeButton = Instance.new("ImageButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Image = "rbxassetid://6031097229"  -- Gambar Ikon X
closeButton.Parent = frame

-- Fungsi untuk Menyembunyikan/Menampilkan GUI
local guiVisible = true
closeButton.MouseButton1Click:Connect(function()
    if guiVisible then
        frame.Visible = false
        -- Ganti ikon X dengan ikon lingkaran
        closeButton.Image = "rbxassetid://6031097229"  -- Gambar Ikon Lingkaran
    else
        frame.Visible = true
        -- Ganti ikon lingkaran kembali ke X
        closeButton.Image = "rbxassetid://6031097229"  -- Gambar Ikon X
    end
    guiVisible = not guiVisible
end)
