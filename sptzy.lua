local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UsernameInput = Instance.new("TextBox")
local InjectBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")

-- Setup GUI ke CoreGui agar tidak hilang saat reset
ScreenGui.Name = "MorphSecurityPro"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Frame Utama (Bisa Digeser)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true -- Mengaktifkan fitur geser otomatis

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Judul
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MORPH INJECTOR TEST"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- Input Username
UsernameInput.Parent = MainFrame
UsernameInput.Position = UDim2.new(0.1, 0, 0.25, 0)
UsernameInput.Size = UDim2.new(0.8, 0, 0, 35)
UsernameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UsernameInput.PlaceholderText = "Masukkan Username..."
UsernameInput.Text = ""
UsernameInput.TextColor3 = Color3.white
UsernameInput.Font = Enum.Font.Gotham

local InputCorner = Instance.new("UICorner", UsernameInput)
InputCorner.CornerRadius = UDim.new(0, 5)

-- Tombol Inject
InjectBtn.Name = "InjectBtn"
InjectBtn.Parent = MainFrame
InjectBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
InjectBtn.Size = UDim2.new(0.8, 0, 0, 45)
InjectBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
InjectBtn.Text = "SCAN & INJECT"
InjectBtn.TextColor3 = Color3.white
InjectBtn.Font = Enum.Font.GothamBold
InjectBtn.TextSize = 14

local BtnCorner = Instance.new("UICorner", InjectBtn)
BtnCorner.CornerRadius = UDim.new(0, 5)

-- Status
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 25)
StatusLabel.Text = "Ready to Scan"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamItalic
StatusLabel.TextSize = 12

-- LOGIC PENGOPERASIAN
InjectBtn.MouseButton1Click:Connect(function()
    local targetUser = UsernameInput.Text
    if targetUser == "" then 
        StatusLabel.Text = "Username Kosong!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return 
    end
    
    StatusLabel.Text = "Scanning & Injecting..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local found = 0
    local targetId = nil
    
    -- Ambil UserId secara aman
    pcall(function()
        targetId = game:GetService("Players"):GetUserIdFromNameAsync(targetUser)
    end)

    if not targetId then
        StatusLabel.Text = "User tidak ditemukan!"
        return
    end

    -- Cari semua RemoteEvent di ReplicatedStorage
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            -- Variasi payload untuk mencoba menembus celah morph
            local tests = {
                {targetUser},
                {targetId},
                {["Character"] = targetUser},
                {["Morph"] = targetUser},
                {"Morph", targetUser}
            }

            for _, p in pairs(tests) do
                pcall(function()
                    remote:FireServer(unpack(p))
                end)
            end
            found = found + 1
        end
    end

    if found > 0 then
        StatusLabel.Text = "Payload Sent to " .. found .. " Remotes!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        warn("✅ Test Selesai. Cek apakah avatar berubah di semua layar.")
    else
        StatusLabel.Text = "Tidak ada Remote ditemukan."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    end
end)
