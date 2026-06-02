-- [[ SHARP SQUARE 300x300 OPEN CLOUD VOICE SETTINGS V13 ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hapus GUI lama jika ada agar tidak menumpuk saat di-execute ulang
if (gethui and gethui()):FindFirstChild("ServerPhysicsGUI") then
    (gethui() components):FindFirstChild("ServerPhysicsGUI"):Destroy()
elseif game:GetService("CoreGui"):FindFirstChild("ServerPhysicsGUI") then
    game:GetService("CoreGui").ServerPhysicsGUI:Destroy()
end

-- [[ SETUP GUI UTAMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerPhysicsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Frame Utama (Persegi Empat Sempurna 300x300)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150) -- Presisi di Tengah Layar
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

-- Border Cyan Tajam
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 180, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Header Menu
local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, 0, 0, 30)
HeaderLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
HeaderLabel.BorderSizePixel = 0
HeaderLabel.Text = "  ROBLOX VOICE CHAT ACTIVATOR"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLabel.Font = Enum.Font.SourceSansBold
HeaderLabel.TextSize = 11
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = MainFrame

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(28, 28, 33)
HeaderStroke.Thickness = 1
HeaderStroke.Parent = HeaderLabel

-- Kontainer Konten Internal
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Auto Layout Vertikal Rapi di dalam Frame 300x300
local VoicePanel = Instance.new("Frame")
VoicePanel.Name = "VoiceSettingsPanel"
VoicePanel.Size = UDim2.new(1, -20, 1, -20)
VoicePanel.Position = UDim2.new(0, 10, 0, 10)
VoicePanel.BackgroundTransparency = 1
VoicePanel.Parent = ContentFrame

local VoiceLayout = Instance.new("UIListLayout")
VoiceLayout.SortOrder = Enum.SortOrder.LayoutOrder
VoiceLayout.Padding = UDim.new(0, 6) -- Jarak renggang antar elemen agar estetik dan luas
VoiceLayout.Parent = VoicePanel

-- Fungsi Pembantu Elemen Teks
local function createVoiceLabel(text, order, styleType)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.LayoutOrder = order
    label.Parent = VoicePanel
    
    if styleType == "Title" then
        label.Size = UDim2.new(1, 0, 0, 18)
        label.TextColor3 = Color3.fromRGB(0, 180, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Font = Enum.Font.SourceSansBold
    elseif styleType == "Copyright" then
        label.Size = UDim2.new(1, 0, 0, 12)
        label.TextColor3 = Color3.fromRGB(100, 100, 105)
        label.TextSize = 9
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Font = Enum.Font.SourceSansItalic
        
        -- Garis pembatas tipis di bawah copyright
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 1, 4)
        line.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        line.BorderSizePixel = 0
        line.Parent = label
    else
        label.Size = UDim2.new(1, 0, 0, 14)
        label.TextColor3 = Color3.fromRGB(180, 180, 185)
        label.TextSize = 10.5
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.SourceSansBold
    end
    return label
end

local function createVoiceInput(placeholder, order)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 28) -- TextBox lebih tebal dan nyaman diklik di HP
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    box.BorderSizePixel = 0
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(90, 90, 95)
    box.TextSize = 11
    box.Font = Enum.Font.Code
    box.LayoutOrder = order
    box.ClearTextOnFocus = false
    box.Parent = VoicePanel
    
    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(40, 40, 45)
    bStroke.Thickness = 1
    bStroke.Parent = box
    return box
end

-- ==========================================
-- STRUKTUR SUSUNAN FORM (MURNI VOICE FITUR)
-- ==========================================

createVoiceLabel("VOICE SETTINGS", 1, "Title")
createVoiceLabel("Copyright by sptzyy", 2, "Copyright")

-- Spacer pemisah setelah garis judul
local Spacer = Instance.new("Frame")
Spacer.Size = UDim2.new(1, 0, 0, 4)
Spacer.BackgroundTransparency = 1
Spacer.LayoutOrder = 3
Spacer.Parent = VoicePanel

createVoiceLabel("API KEY:", 4, "Normal")
local InputAPI = createVoiceInput("Masukkan Open Cloud Key...", 5)

createVoiceLabel("UNIVERSE ID:", 6, "Normal")
local InputUniverse = createVoiceInput("Masukkan Universe ID...", 7)

-- Tombol Eksekusi Utama (Gaya Sharp Sesuai Tema)
local ActionButton = Instance.new("TextButton")
ActionButton.Size = UDim2.new(1, 0, 0, 32)
ActionButton.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
ActionButton.BorderSizePixel = 0
ActionButton.Text = "AKTIFKAN VOICE CHAT"
ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActionButton.Font = Enum.Font.SourceSansBold
ActionButton.TextSize = 11
ActionButton.LayoutOrder = 8
ActionButton.Parent = VoicePanel

local ActionStroke = Instance.new("UIStroke")
ActionStroke.Color = Color3.fromRGB(0, 180, 255)
ActionStroke.Thickness = 1
ActionStroke.Parent = ActionButton

-- Kotak Konsol Log Status di Paling Bawah
local ConsoleLog = Instance.new("TextLabel")
ConsoleLog.Size = UDim2.new(1, 0, 0, 36)
ConsoleLog.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
ConsoleLog.BorderSizePixel = 0
ConsoleLog.Text = "Status: Menunggu input data..."
ConsoleLog.TextColor3 = Color3.fromRGB(0, 255, 150)
ConsoleLog.TextSize = 10
ConsoleLog.Font = Enum.Font.Code
ConsoleLog.TextWrapped = true
ConsoleLog.LayoutOrder = 9
ConsoleLog.Parent = VoicePanel

local ConsoleLogStroke = Instance.new("UIStroke")
ConsoleLogStroke.Color = Color3.fromRGB(25, 25, 30)
ConsoleLogStroke.Thickness = 1
ConsoleLogStroke.Parent = ConsoleLog

-- ==========================================
-- LOGIKA HTTP REQUEST VIA EXECUTOR
-- ==========================================
ActionButton.MouseButton1Click:Connect(function()
    local apiKey = InputAPI.Text
    local universeId = InputUniverse.Text
    local requestFunc = request or http_request or (syn and syn.request)
    
    if apiKey == "" or universeId == "" then
        ConsoleLog.Text = "Status: Gagal! Input tidak boleh kosong."
        ConsoleLog.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    if not requestFunc then
        ConsoleLog.Text = "Status: Executor tidak support Http Request!"
        ConsoleLog.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    ConsoleLog.Text = "Status: Mengirim permintaan ke Open Cloud..."
    ConsoleLog.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    task.spawn(function()
        local success, response = pcall(function()
            return requestFunc({
                Url = "https://api.roblox.com/universes/v1/universes/" .. universeId .. "/configuration",
                Method = "PATCH",
                Headers = {
                    ["x-api-key"] = apiKey,
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    isVoiceChatEnabled = true
                })
            })
        end)
        
        if success and response then
            if response.StatusCode == 200 then
                ConsoleLog.Text = "Status: Sukses! Voice Chat Berhasil Aktif."
                ConsoleLog.TextColor3 = Color3.fromRGB(0, 255, 150)
            else
                ConsoleLog.Text = "Err (" .. response.StatusCode .. "): " .. tostring(response.Body)
                ConsoleLog.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        else
            ConsoleLog.Text = "Status: Gagal mengirim request jaringan."
            ConsoleLog.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)
end)
