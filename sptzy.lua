-- [[ COPY FITUR SPTZYY - PREMIMUM VERSION ]] --

local ScreenGui = Instance.new("ScreenGui")
local SupportIcon = Instance.new("ImageButton")
local UICorner_Icon = Instance.new("UICorner")
local MainGui = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Setup UI Parent
ScreenGui.Name = "Sptzyy_Ultimate_Copy"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Variabel Global & Path
local FileName = "Sptzyy_MapData.txt"

-- Fungsi Notifikasi Animasi Melayang
local function Notify(text)
    local NotifyLabel = Instance.new("TextLabel")
    NotifyLabel.Parent = ScreenGui
    NotifyLabel.Size = UDim2.new(0, 250, 0, 40)
    NotifyLabel.Position = UDim2.new(0.5, -125, 0.9, 0)
    NotifyLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotifyLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    NotifyLabel.Text = "🚀 " .. text
    NotifyLabel.Font = Enum.Font.GothamBold
    NotifyLabel.TextSize = 14
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifyLabel

    -- Animasi Melayang ke Atas dan Menghilang
    NotifyLabel:TweenPosition(UDim2.new(0.5, -125, 0.4, 0), "Out", "Quart", 2)
    game:GetService("TweenService"):Create(NotifyLabel, TweenInfo.new(2), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    
    task.delay(2, function() NotifyLabel:Destroy() end)
end

-- Tombol Icon (Bisa Digeser)
SupportIcon.Name = "SupportIcon"
SupportIcon.Parent = ScreenGui
SupportIcon.Position = UDim2.new(0.05, 0, 0.2, 0)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Image = "rbxassetid://15132611620" -- Icon Modern
SupportIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SupportIcon.Active = true
SupportIcon.Draggable = true

UICorner_Icon.Parent = SupportIcon
UICorner_Icon.CornerRadius = UDim.new(1, 0)

-- Main Menu GUI
MainGui.Name = "MainGui"
MainGui.Parent = ScreenGui
MainGui.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainGui.Position = UDim2.new(0.5, -100, 0.5, -125)
MainGui.Size = UDim2.new(0, 220, 0, 280)
MainGui.Visible = false
MainGui.ClipsDescendants = true

UICorner_Main.Parent = MainGui

Title.Parent = MainGui
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 200)
Title.Text = "COPY FITUR SPTZYY"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

Container.Parent = MainGui
Container.Position = UDim2.new(0, 0, 0, 50)
Container.Size = UDim2.new(1, 0, 1, -60)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.2, 0)
Container.ScrollBarThickness = 2

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Fungsi Membuat Tombol Modern
local function CreateButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- LOGIKA FITUR
CreateButton("COPY WORKSPACE", Color3.fromRGB(0, 150, 0), function()
    Notify("Scanning Map Assets...")
    _G.CopiedData = {}
    local count = 0
    for _, obj in pairs(game.Workspace:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("Folder") then
            table.insert(_G.CopiedData, obj:Clone())
            count = count + 1
        end
    end
    Notify("Berhasil Copy " .. count .. " Items!")
end)

CreateButton("SAVE TO FILE", Color3.fromRGB(200, 150, 0), function()
    if not _G.CopiedData or #_G.CopiedData == 0 then
        Notify("Gagal: Data Kosong!")
        return
    end
    -- Mencatat histori copy ke file teks (Log)
    writefile(FileName, "Last Copy: " .. os.date() .. " | Items: " .. #_G.CopiedData)
    Notify("Data Info Tersimpan di " .. FileName)
end)

CreateButton("PASTE ASSETS", Color3.fromRGB(0, 100, 255), function()
    if not _G.CopiedData or #_G.CopiedData == 0 then
        Notify("Tidak ada data untuk ditempel!")
        return
    end
    Notify("Proses Menempel...")
    for _, item in pairs(_G.CopiedData) do
        pcall(function()
            item:Clone().Parent = game.Workspace
        end)
    end
    Notify("Paste Berhasil (Client Side)")
end)

CreateButton("CLOSE GUI", Color3.fromRGB(150, 0, 0), function()
    MainGui.Visible = false
end)

-- Toggle Menu via Icon
SupportIcon.MouseButton1Click:Connect(function()
    MainGui.Visible = not MainGui.Visible
end)

Notify("Sptzyy Script Ready!")
