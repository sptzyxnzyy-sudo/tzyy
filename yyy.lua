local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local LogService = game:GetService("LogService") -- Untuk fitur Copy (jika di Studio) atau pakai alternatif TextBox

-- ==========================================
-- 1. PEMBUATAN GUI (Ukuran 300x300)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimTrackerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150) -- Di tengah layar
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- GUI bisa digeser/drag
mainFrame.Parent = screenGui

-- Corner/Lengkungan Frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Title Bar (Judul)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 35)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Animation Tracker"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

-- Tombol Close (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Scrolling Frame untuk Hasil Log
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -95)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Otomatis membesar nanti
scrollFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 4)
scrollCorner.Parent = scrollFrame

-- TextBox di dalam Scroll (Supaya teksnya bisa di-block/copy manual juga)
local textDisplay = Instance.new("TextBox")
textDisplay.Size = UDim2.new(1, -10, 1, 0)
textDisplay.Position = UDim2.new(0, 5, 0, 0)
textDisplay.BackgroundTransparency = 1
textDisplay.Text = "Belum ada animasi dideteksi...\n"
textDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
textDisplay.TextSize = 13
textDisplay.Font = Enum.Font.Code
textDisplay.TextXAlignment = Enum.TextXAlignment.Left
textDisplay.TextYAlignment = Enum.TextYAlignment.Top
textDisplay.ClearTextOnFocus = false
textDisplay.TextEditable = false -- Hanya untuk dibaca & dicopy
textDisplay.TextWrapped = true
textDisplay.Parent = scrollFrame

-- Tombol Copy All
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, -20, 0, 35)
copyButton.Position = UDim2.new(0, 10, 1, -45)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
copyButton.Text = "Copy All"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 14
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = mainFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyButton


-- ==========================================
-- 2. LOGIKA & FUNGSI FITUR
-- ==========================================

-- Fungsi Menutup GUI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() -- Menghapus GUI sepenuhnya dari layar
end)

-- Tabel penyimpanan data mentah untuk dicopy
local hasilLog = {}

-- Fungsi update tampilan teks di GUI
local function updateTampilan()
    local textGabungan = ""
    for _, log in ipairs(hasilLog) do
        textGabungan = textGabungan .. string.format("ID: %s\nLink: %s\n-------------------\n", log.id, log.link)
    end
    textDisplay.Text = textGabungan
end

-- Fungsi deteksi animasi baru
animator.AnimationPlayed:Connect(function(animationTrack)
    local rawId = animationTrack.Animation.AnimationId
    local hanyaId = string.match(rawId, "%d+") or "000000" -- Ambil angkanya saja
    local linkWebsite = "https://www.roblox.com/library/" .. hanyaId
    
    -- Cek jika ID ini sudah tercatat sebelumnya agar tidak double
    local sudahAda = false
    for _, v in ipairs(hasilLog) do
        if v.id == hanyaId then sudahAda = true break end
    end
    
    if not sudahAda then
        -- Masukkan ke tabel penampung
        table.insert(hasilLog, {id = hanyaId, link = linkWebsite})
        updateTampilan()
    end
end)

-- Fungsi Copy All
copyButton.MouseButton1Click:Connect(function()
    if #hasilLog == 0 then 
        copyButton.Text = "Kosong!"
        task.wait(1)
        copyButton.Text = "Copy All"
        return 
    end
    
    -- Format string akhir untuk dicopy
    local teksCopy = ""
    for _, log in ipairs(hasilLog) do
        teksCopy = teksCopy .. string.format("ID: %s\nLink: %s\n\n", log.id, log.link)
    end
    
    -- Trik Roblox: Menjadikan TextBox fokus dan otomatis menyeleksi semua teks 
    -- agar user tinggal menekan Ctrl+C (karena Roblox membatasi setclipboard otomatis demi keamanan script)
    textDisplay.TextEditable = true
    textDisplay:CaptureFocus()
    textDisplay.SelectionStart = 1
    textDisplay.CursorPosition = #textDisplay.Text + 1
    
    -- Mengubah nama tombol sementara sebagai indikator
    local textLama = copyButton.Text
    copyButton.Text = "Tekan Ctrl + C sekarang!"
    copyButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    
    task.wait(2)
    textDisplay.TextEditable = false
    copyButton.Text = textLama
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
end)
