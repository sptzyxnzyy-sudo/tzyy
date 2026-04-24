local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Pembersihan GUI Lama
if CoreGui:FindFirstChild("MorphSecurityPro") then
    CoreGui.MorphSecurityPro:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorphSecurityPro"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -110)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true -- Masih didukung di banyak executor

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 255) -- Cyan Neon
UIStroke.Thickness = 2

-- Judul (Agar jelas sedang pakai tool apa)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "MORPH SECURITY TEST"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Input Username (Warna Teks Putih Terang agar Jelas)
local UsernameInput = Instance.new("TextBox", MainFrame)
UsernameInput.Name = "UsernameInput"
UsernameInput.Position = UDim2.new(0.1, 0, 0.25, 0)
UsernameInput.Size = UDim2.new(0.8, 0, 0, 40)
UsernameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
UsernameInput.PlaceholderText = "Ketik Username Di Sini..."
UsernameInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
UsernameInput.Text = ""
UsernameInput.TextColor3 = Color3.fromRGB(255, 255, 255) -- Teks yang diketik jadi Putih
UsernameInput.Font = Enum.Font.Gotham
UsernameInput.TextSize = 14
UsernameInput.ClipsDescendants = true

Instance.new("UICorner", UsernameInput).CornerRadius = UDim.new(0, 6)

-- Tombol Inject (Tombol Utama)
local InjectBtn = Instance.new("TextButton", MainFrame)
InjectBtn.Name = "InjectBtn"
InjectBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
InjectBtn.Size = UDim2.new(0.8, 0, 0, 45)
InjectBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 180) -- Cyan Gelap
InjectBtn.Text = "MULAI SCAN & TEST"
InjectBtn.TextColor3 = Color3.white
InjectBtn.Font = Enum.Font.GothamBold
InjectBtn.TextSize = 14

Instance.new("UICorner", InjectBtn).CornerRadius = UDim.new(0, 6)

-- Status Label
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Menunggu Input"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

-- Logika Eksekusi
InjectBtn.MouseButton1Click:Connect(function()
    local targetUser = UsernameInput.Text
    if targetUser == "" then 
        StatusLabel.Text = "⚠️ Error: Username tidak boleh kosong!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return 
    end
    
    StatusLabel.Text = "🔍 Mencari Remote & Mengirim Payload..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local foundCount = 0
    local successId, targetId = pcall(function()
        return Players:GetUserIdFromNameAsync(targetUser)
    end)

    if not successId then
        StatusLabel.Text = "❌ Username tidak terdaftar di Roblox!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local payloads = {
                {targetUser},
                {targetId},
                {["Character"] = targetUser},
                {"Morph", targetUser}
            }

            for _, p in pairs(payloads) do
                pcall(function()
                    remote:FireServer(unpack(p))
                end)
            end
            foundCount = foundCount + 1
        end
    end

    StatusLabel.Text = "✅ Berhasil! Menguji " .. foundCount .. " Remote."
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
end)
