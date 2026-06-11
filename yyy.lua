local player = game.Players.LocalPlayer

-- ==========================================
-- 1. PEMBUATAN GUI (Ukuran 300x300)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptDecompilerGui"
screenGui.ResetOnSpawn = false

-- Proteksi GUI dari Anti-Cheat Game
if gethui then
    screenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(screenGui)
else
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
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
titleLabel.Text = "LocalScript Scanner & Decompiler"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
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
scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
textDisplay.Text = "Menunggu perintah scan..."
textDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
textDisplay.TextSize = 12
textDisplay.Font = Enum.Font.Code
textDisplay.TextXAlignment = Enum.TextXAlignment.Left
textDisplay.TextYAlignment = Enum.TextYAlignment.Top
textDisplay.ClearTextOnFocus = false
textDisplay.TextEditable = false
textDisplay.TextWrapped = true
textDisplay.Parent = scrollFrame

local actionButton = Instance.new("TextButton")
actionButton.Size = UDim2.new(1, -20, 0, 35)
actionButton.Position = UDim2.new(0, 10, 1, -45)
actionButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
actionButton.Text = "SCAN & DECOMPILE"
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.TextSize = 14
actionButton.Font = Enum.Font.SourceSansBold
actionButton.Parent = mainFrame

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 6)
actionCorner.Parent = actionButton

-- ==========================================
-- 2. LOGIKA SCANNER & COPY
-- ==========================================

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local isiKodeGabungan = ""
local statusMode = "scan" -- Mode tombol: "scan" atau "copy"

-- Fungsi Utama untuk Scan dan Bongkar Kode Script
local function mulaiDecompile()
    textDisplay.Text = "Sedang mencari dan membongkar script...\nMohon tunggu, game mungkin akan sedikit freeze."
    actionButton.Text = "Processing..."
    actionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    task.wait(0.5)
    
    local targetScripts = {}
    isiKodeGabungan = ""
    
    -- Mencari ke seluruh penjuru game yang bisa diakses client
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            table.insert(targetScripts, v)
        end
    end
    
    if #targetScripts == 0 then
        textDisplay.Text = "Tidak ditemukan LocalScript atau ModuleScript."
        actionButton.Text = "SCAN & DECOMPILE"
        actionButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        return
    end
    
    -- Cek ketersediaan fungsi decompiler bawaan executor
    local decompiler = decompile or disassemble or nil
    
    -- Mulai menyusun hasil kode
    for i, scr in ipairs(targetScripts) do
        local path = scr:GetFullName()
        local tipe = scr.ClassName
        local isiKode = ""
        
        if decompiler then
            -- Sukses jika executor punya fitur decompile
            local status, result = pcall(function() return decompiler(scr) end)
            isiKode = status and result or "-- [Gagal Mendekompresi Kode Script]"
        else
            -- Jika executor gratisan/lemah tidak punya decompiler
            isiKode = "-- [Executor kamu tidak support fitur Decompile. Properti .Source diblokir oleh Roblox]"
        end
        
        isiKodeGabungan = isiKodeGabungan .. string.format("-- TIPE: %s | PATH: %s\n%s\n\n---------------------------------------\n\n", tipe, path, isiKode)
    end
    
    -- Tampilkan di GUI
    textDisplay.Text = isiKodeGabungan
    
    -- Ubah fungsi tombol utama menjadi Tombol Copy All
    statusMode = "copy"
    actionButton.Text = "COPY ALL RESULTS"
    actionButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Hijau
end

-- Logika Tombol saat Diklik
actionButton.MouseButton1Click:Connect(function()
    if statusMode == "scan" then
        mulaiDecompile()
    elseif statusMode == "copy" then
        if isiKodeGabungan == "" then return end
        
        -- Fitur Copy Otomatis via Clipboard Executor
        if setclipboard then
            setclipboard(isiKodeGabungan)
            actionButton.Text = "Berhasil Disalin!"
            task.wait(1.5)
            actionButton.Text = "COPY ALL RESULTS"
        else
            -- Trik seleksi manual jika executor tidak punya fungsi setclipboard
            textDisplay.TextEditable = true
            textDisplay:CaptureFocus()
            textDisplay.SelectionStart = 1
            textDisplay.CursorPosition = #textDisplay.Text + 1
            
            actionButton.Text = "Tekan Ctrl + C sekarang!"
            actionButton.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
            task.wait(2)
            textDisplay.TextEditable = false
            actionButton.Text = "COPY ALL RESULTS"
            actionButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        end
    end
end)
