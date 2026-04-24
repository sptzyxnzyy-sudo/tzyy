local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hapus GUI lama jika ada agar tidak double
if CoreGui:FindFirstChild("MorphSecurityPro") then
    CoreGui.MorphSecurityPro:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MorphSecurityPro"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true -- Aktifkan geser

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SECURITY TESTER V2"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local UsernameInput = Instance.new("TextBox", MainFrame)
UsernameInput.Position = UDim2.new(0.1, 0, 0.25, 0)
UsernameInput.Size = UDim2.new(0.8, 0, 0, 35)
UsernameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UsernameInput.PlaceholderText = "Target Username..."
UsernameInput.Text = ""
UsernameColor = Color3.white
UsernameInput.TextColor3 = Color3.white

local InjectBtn = Instance.new("TextButton", MainFrame)
InjectBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
InjectBtn.Size = UDim2.new(0.8, 0, 0, 45)
InjectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
InjectBtn.Text = "START SCAN & INJECT"
InjectBtn.TextColor3 = Color3.white
InjectBtn.Font = Enum.Font.GothamBold

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 40)
StatusLabel.Text = "Status: Idle (Ready)"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextWrapped = true
StatusLabel.TextSize = 12

--- FUNGSI UTAMA (Hanya jalan saat diklik) ---
InjectBtn.MouseButton1Click:Connect(function()
    local targetUser = UsernameInput.Text
    if targetUser == "" then 
        StatusLabel.Text = "⚠️ Masukkan nama player!"
        return 
    end
    
    StatusLabel.Text = "🔍 Mencari Remote..."
    local foundCount = 0
    
    -- Ambil ID target
    local successId, targetId = pcall(function()
        return Players:GetUserIdFromNameAsync(targetUser)
    end)

    if not successId then
        StatusLabel.Text = "❌ User tidak valid!"
        return
    end

    -- SCANNING HANYA DIMULAI DI SINI
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

    StatusLabel.Text = "✅ Selesai! Terkirim ke " .. foundCount .. " Remote."
    warn("Security Test Selesai untuk user: " .. targetUser)
end)
