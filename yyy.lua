local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ==========================================
-- 1. PEMBUATAN GUI (Tetap Aman & Bisa Di-drag)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerAnimScanner"
screenGui.ResetOnSpawn = false

-- Proteksi GUI agar tidak mudah dideteksi script anti-cheat bawaan game
if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
elseif gethui then
    screenGui.Parent = gethui()
else
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 35)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Universal Emote Scanner"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -95)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
scrollFrame.BorderSizePixel = 0
scrollFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 4)
scrollCorner.Parent = scrollFrame

local textDisplay = Instance.new("TextBox")
textDisplay.Size = UDim2.new(1, -10, 1, 0)
textDisplay.Position = UDim2.new(0, 5, 0, 5)
textDisplay.BackgroundTransparency = 1
textDisplay.Text = "[Ready] Aktifkan dance di game, lalu tunggu scan..."
textDisplay.TextColor3 = Color3.fromRGB(0, 255, 150) -- Hijau indikator siap
textDisplay.TextSize = 13
textDisplay.Font = Enum.Font.Code
textDisplay.TextXAlignment = Enum.TextXAlignment.Left
textDisplay.TextYAlignment = Enum.TextYAlignment.Top
textDisplay.ClearTextOnFocus = false
textDisplay.TextEditable = false
textDisplay.TextWrapped = true
textDisplay.Parent = scrollFrame

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, -20, 0, 35)
copyButton.Position = UDim2.new(0, 10, 1, -45)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
copyButton.Text = "Copy All Results"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 14
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = mainFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyButton

-- ==========================================
-- 2. LOGIKA SCANNER KHUSUS GAME ORANG LAIN
-- ==========================================

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local hasilLog = {}

local function updateTampilan()
    local textGabungan = ""
    for _, log in ipairs(hasilLog) do
        textGabungan = textGabungan .. string.format("Nama Anim: %s\nID: %s\nLink: https://www.roblox.com/library/%s\n-------------------\n", log.nama, log.id, log.id)
    end
    textDisplay.Text = textGabungan
end

-- Fungsi utama pencari track animasi (Membaca paksa dari Humanoid/Animator)
local function dapatkanAnimasiAktif()
    local char = player.Character or workspace:FindFirstChild(player.Name)
    if not char then return {} end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return {} end
    
    -- Cek di Animator (Roblox baru) atau langsung di Humanoid (Roblox lama)
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        return animator:GetPlayingAnimationTracks()
    else
        return hum:GetPlayingAnimationTracks()
    end
end

-- Loop Scanning Super Cepat (Setiap 0.2 detik sekali)
task.spawn(function()
    while true do
        local tracks = dapatkanAnimasiAktif()
        
        for _, track in ipairs(tracks) do
            if track.Animation and track.Animation.AnimationId ~= "" then
                local rawId = track.Animation.AnimationId
                local hanyaId = string.match(rawId, "%d+")
                
                -- Cari nama animasi (jika disetting oleh developernya)
                local namaAnim = track.Name or "Unknown Emote"
                
                if hanyaId and hanyaId ~= "0" then
                    -- Cek duplikat
                    local sudahAda = false
                    for _, v in ipairs(hasilLog) do
                        if v.id == hanyaId then sudahAda = true break end
                    end
                    
                    if not sudahAda then
                        table.insert(hasilLog, {id = hanyaId, nama = namaAnim})
                        updateTampilan()
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- Tombol Copy All (Gunakan Setclipboard bawaan Executor jika ada, jika tidak pakai trik Ctrl+C)
copyButton.MouseButton1Click:Connect(function()
    if #hasilLog == 0 then 
        copyButton.Text = "Belum ada data!"
        task.wait(1)
        copyButton.Text = "Copy All Results"
        return 
    end
    
    local teksCopy = ""
    for _, log in ipairs(hasilLog) do
        teksCopy = teksCopy .. string.format("Nama: %s | ID: %s | Link: https://www.roblox.com/library/%s\n", log.nama, log.id, log.id)
    end
    
    -- Jika menggunakan Executor bagus (Synapse, Wave, Solara, Celery, dll), pakai fungsi ini:
    if setclipboard then
        setclipboard(teksCopy)
        copyButton.Text = "Berhasil Disalin ke Clipboard!"
        copyButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        task.wait(2)
        copyButton.Text = "Copy All Results"
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    else
        -- Jika executor tidak mendukung setclipboard, pakai trik manual select
        textDisplay.TextEditable = true
        textDisplay:CaptureFocus()
        textDisplay.SelectionStart = 1
        textDisplay.CursorPosition = #textDisplay.Text + 1
        
        copyButton.Text = "Tekan Ctrl + C sekarang!"
        copyButton.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
        task.wait(2)
        textDisplay.TextEditable = false
        copyButton.Text = "Copy All Results"
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end
end)
