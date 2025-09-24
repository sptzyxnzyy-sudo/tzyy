local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- 🔽 Status Hapus Tangga 🔽
local deleteModeEnabled = false

-- 🔽 GUI Utama 🔽
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.4, -110, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Judul GUI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Mount Atin V2"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Tombol SUMMIT
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0.5, -80, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.Text = "SUMMIT"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 15
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button

-- Tombol Hapus Tangga (ON/OFF)
local deleteButton = Instance.new("TextButton")
deleteButton.Size = UDim2.new(0, 160, 0, 40)
deleteButton.Position = UDim2.new(0.5, -80, 0.5, 30)
deleteButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
deleteButton.Text = "Hapus Tangga OFF"
deleteButton.TextColor3 = Color3.new(1, 1, 1)
deleteButton.Font = Enum.Font.GothamBold
deleteButton.TextSize = 15
deleteButton.Parent = frame

local deleteButtonCorner = Instance.new("UICorner")
deleteButtonCorner.CornerRadius = UDim.new(0, 10)
deleteButtonCorner.Parent = deleteButton

-- Fungsi untuk mengaktifkan atau menonaktifkan mode hapus tangga
deleteButton.MouseButton1Click:Connect(function()
    deleteModeEnabled = not deleteModeEnabled
    if deleteModeEnabled then
        deleteButton.Text = "Hapus Tangga ON"
        deleteButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        deleteButton.Text = "Hapus Tangga OFF"
        deleteButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- 🔽 Fungsi untuk menghapus tangga ketika disentuh 🔽
local function onTouchedTangga(part)
    -- Periksa jika objek yang disentuh adalah tangga
    if deleteModeEnabled and part.Parent and part.Parent:FindFirstChild("Humanoid") then
        -- Jika part tersebut adalah tangga dan disentuh oleh pemain, hancurkan
        if part.Parent:FindFirstChild("Tangga") then
            part.Parent.Tangga:Destroy()  -- Hapus tangga yang ada
        end
    end
end

-- 🔽 Mendaftarkan event sentuhan untuk objek tangga 🔽
workspace.ChildAdded:Connect(function(child)
    -- Jika model baru yang ditambahkan adalah tangga
    if child:IsA("Model") and child:FindFirstChild("Tangga") then
        -- Daftarkan event Touched untuk objek tangga
        child.Tangga.Touched:Connect(onTouchedTangga)
    end
end)

-- 🔽 Fungsi untuk memeriksa objek tangga yang sudah ada 🔽
local function checkExistingTangga()
    for _, tangga in pairs(workspace:GetChildren()) do
        if tangga:IsA("Model") and tangga:FindFirstChild("Tangga") then
            tangga.Tangga.Touched:Connect(onTouchedTangga)
        end
    end
end

-- Panggil fungsi untuk memeriksa tangga yang sudah ada saat permainan dimulai
checkExistingTangga()

-- Fungsi untuk teleportasi ke posisi tertentu (misalnya untuk fitur farm atau teleportasi)
local function teleportTo(pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- Tombol SUMMIT untuk teleportasi otomatis
local position1 = Vector3.new(625.27, 1799.83, 3432.84)
local position2 = Vector3.new(780.47, 2183.38, 3945.07)
local teleporting = false

local function autoFarmLoop()
    teleportTo(position1)
    task.wait(2)
    teleportTo(position2)
    task.wait(1)
end

local function toggleAutoFarm(state)
    teleporting = state
    if teleporting then
        button.Text = "RUNNING..."
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.spawn(autoFarmLoop)
    else
        button.Text = "SUMMIT"
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end

button.MouseButton1Click:Connect(function()
    toggleAutoFarm(not teleporting)
end)
