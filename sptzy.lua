--[[
    ROBLOX SECURITY TESTER - MORPH INJECTOR
    Fitur: Auto-Scan Remotes, High-Contrast UI, Draggable GUI.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- 1. Pembersihan GUI Lama (Agar tidak menumpuk)
if CoreGui:FindFirstChild("MorphSecurityPro") then
    CoreGui.MorphSecurityPro:Destroy()
end

-- 2. Setup ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorphSecurityPro"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 3. Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Hitam Pekat
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -110)
MainFrame.Size = UDim2.new(0, 250, 0, 230)
MainFrame.Active = true
MainFrame.Draggable = true -- Support geser untuk sebagian besar executor

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 255) -- Cyan Neon
UIStroke.Thickness = 2

-- 4. Judul (Header)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "MORPH SECURITY TEST"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- 5. Input Username (Teks Putih Jelas)
local UsernameInput = Instance.new("TextBox", MainFrame)
UsernameInput.Name = "UsernameInput"
UsernameInput.Position = UDim2.new(0.1, 0, 0.28, 0)
UsernameInput.Size = UDim2.new(0.8, 0, 0, 40)
UsernameInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
UsernameInput.PlaceholderText = "Input Username..."
UsernameInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
UsernameInput.Text = ""
UsernameInput.TextColor3 = Color3.fromRGB(255, 255, 255) -- Teks Putih Terang
UsernameInput.Font = Enum.Font.Gotham
UsernameInput.TextSize = 14
UsernameInput.ClearTextOnFocus = false

local InputCorner = Instance.new("UICorner", UsernameInput)
InputCorner.CornerRadius = UDim.new(0, 6)

-- 6. Tombol Inject
local InjectBtn = Instance.new("TextButton", MainFrame)
InjectBtn.Name = "InjectBtn"
InjectBtn.Position = UDim2.new(0.1, 0, 0.53, 0)
InjectBtn.Size = UDim2.new(0.8, 0, 0, 45)
InjectBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 170)
InjectBtn.Text = "SCAN & INJECT"
InjectBtn.TextColor3 = Color3.white
InjectBtn.Font = Enum.Font.GothamBold
InjectBtn.TextSize = 14
InjectBtn.AutoButtonColor = true

local BtnCorner = Instance.new("UICorner", InjectBtn)
BtnCorner.CornerRadius = UDim.new(0, 6)

-- 7. Status Label (Keterangan Proses)
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0.1, 0, 0.78, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Menunggu Perintah"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextWrapped = true

-- 8. Logika Inti (Hanya jalan jika diklik)
InjectBtn.MouseButton1Click:Connect(function()
    local targetUser = UsernameInput.Text
    
    if targetUser == "" then 
        StatusLabel.Text = "⚠️ Masukkan username terlebih dahulu!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return 
    end
    
    StatusLabel.Text = "🔍 Mencari Remote & Mengirim Payload..."
    StatusLabel.TextColor3 = Color3.white
    
    -- Mencari UserId secara otomatis
    local successId, targetId = pcall(function()
        return Players:GetUserIdFromNameAsync(targetUser)
    end)

    if not successId or not targetId then
        StatusLabel.Text = "❌ Username '" .. targetUser .. "' tidak ditemukan!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end

    local foundCount = 0
    
    -- Mulai Pemindaian (Scan)
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            -- Daftar payload yang umum digunakan untuk exploit morph
            local payloads = {
                {targetUser},
                {targetId},
                {["Character"] = targetUser},
                {"Morph", targetUser},
                {["UserId"] = targetId}
            }

            for _, data dalam pairs(payloads) do
                pcall(function()
                    remote:FireServer(unpack(data))
                end)
            end
            foundCount = foundCount + 1
        end
    end

    -- Hasil Akhir
    if foundCount > 0 then
        StatusLabel.Text = "✅ Berhasil! Payload terkirim ke " .. foundCount .. " Remote."
        StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
        print("Security Test Selesai. Total Remote diuji: " .. foundCount)
    else
        StatusLabel.Text = "⚠️ Tidak ada RemoteEvent ditemukan di ReplicatedStorage."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    end
end)

-- Efek Hover Sederhana untuk Tombol
InjectBtn.MouseEnter:Connect(function()
    TweenService:Create(InjectBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 210, 210)}):Play()
end)

InjectBtn.MouseLeave:Connect(function()
    TweenService:Create(InjectBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 170)}):Play()
end)
