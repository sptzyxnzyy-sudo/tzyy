-- 👑 Local Invisible Switch Script (Client Only)
-- Dibuat oleh: Sptzy
-- Fitur:
-- - Tombol toggle INVISIBLE ON/OFF
-- - Label OWNER di atas kepala
-- - Chat prefix OWNER
-- - Notifikasi sistem lokal

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- 🟢 Buat pesan sistem di chat
local function systemMessage(text, color)
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = text or "",
		Color = color or Color3.fromRGB(255,255,255),
	})
end

-- 🟣 Fungsi ubah visibilitas karakter
local function setInvisible(isInvisible)
	local char = player.Character or player.CharacterAdded:Wait()
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			part.Transparency = isInvisible and 1 or 0
			if part:IsA("BasePart") then
				part.CanCollide = not isInvisible
			end
		end
	end
end

-- 🟡 Tambahkan label OWNER di atas kepala
local function addOwnerLabel()
	local char = player.Character or player.CharacterAdded:Wait()
	local head = char:WaitForChild("Head")

	if head:FindFirstChild("OwnerBillboard") then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "OwnerBillboard"
	billboard.Size = UDim2.new(0, 130, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Font = Enum.Font.SourceSansBold
	label.TextColor3 = Color3.fromRGB(255, 215, 0)
	label.TextStrokeTransparency = 0
	label.Text = "👑 OWNER 👑"
	label.Parent = billboard

	billboard.Parent = head
end

-- 🔵 Fungsi buat GUI tombol
local function createToggleGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InvisibleToggleGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local button = Instance.new("TextButton")
	button.Name = "ToggleButton"
	button.Size = UDim2.new(0, 160, 0, 40)
	button.Position = UDim2.new(0.5, -80, 0.85, 0)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.BorderSizePixel = 2
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSansBold
	button.TextScaled = true
	button.Text = "🟢 INVISIBLE: OFF"
	button.Parent = screenGui

	local invisible = false

	button.MouseButton1Click:Connect(function()
		invisible = not invisible
		setInvisible(invisible)

		if invisible then
			button.Text = "🔴 INVISIBLE: ON"
			button.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
			systemMessage("[System] Mode tak terlihat diaktifkan 👻", Color3.fromRGB(0,255,0))
		else
			button.Text = "🟢 INVISIBLE: OFF"
			button.BackgroundColor3 = Color3.fromRGB(45,45,45)
			systemMessage("[System] Mode tak terlihat dimatikan ✅", Color3.fromRGB(255,255,0))
		end
	end)
end

-- 🟠 Saat karakter muncul
player.CharacterAdded:Connect(function()
	task.wait(0.8)
	addOwnerLabel()
end)

-- 🟢 Saat script dijalankan
systemMessage("[System] Local Invisible Switch aktif untuk " .. player.Name, Color3.fromRGB(0,255,255))
addOwnerLabel()
createToggleGUI()