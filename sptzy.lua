local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- RemoteEvent untuk komunikasi antara client dan server
local removeObjectEvent = Instance.new("RemoteEvent")
removeObjectEvent.Name = "RemoveObject"
removeObjectEvent.Parent = ReplicatedStorage

-- Fungsi untuk menghapus objek yang disentuh oleh karakter
local isTouchingEnabled = false  -- Menyimpan status on/off fitur

local function onTouched(part)
    if not isTouchingEnabled then return end  -- Cek jika fitur on
    local object = part.Parent  -- Mengambil objek yang bersentuhan

    -- Pastikan objek adalah model yang valid dan bukan karakter pemain atau objek yang tidak diinginkan
    if object:IsA("Model") and object ~= character then
        -- Menghapus objek pada server (untuk semua pemain)
        game.ReplicatedStorage.RemoveObject:FireServer(object)
    end
end

-- Menangkap event sentuhan pada bagian yang ada di Workspace
humanoidRootPart.Touched:Connect(onTouched)

-- Fungsi untuk menghapus objek pada server
local function removeObjectOnServer(object)
    if object and object.Parent then
        object:Destroy()
    end
end

-- RemoteEvent untuk menghapus objek pada server
removeObjectEvent.OnServerEvent:Connect(removeObjectOnServer)

-- GUI untuk mengontrol tombol on/off
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TouchDeleteGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.5, -80)
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
title.Text = "Delete On Touch"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Tombol On/Off
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 40)
toggleButton.Position = UDim2.new(0.5, -80, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 15
toggleButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = toggleButton

-- Fungsi untuk mengubah status On/Off
local function toggleFeature()
    isTouchingEnabled = not isTouchingEnabled
    if isTouchingEnabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  -- Warna hijau
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)  -- Warna merah
    end
end

-- Ketika tombol ditekan, toggle on/off
toggleButton.MouseButton1Click:Connect(toggleFeature)

-- Icon X untuk menutup GUI
local closeButton = Instance.new("ImageButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Image = "rbxassetid://6031097229"  -- Ganti dengan ID ikon X
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()  -- Tutup GUI
end)
