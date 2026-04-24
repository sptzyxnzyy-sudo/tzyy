-- [[ SPTZYY ULTIMATE INJECTOR V2 ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game.Players
local LocalPlayer = Players.LocalPlayer

-- Variables dari skrip lama Anda
local modelName = "sptzyy"
local zyy = nil
local lastFired = nil

-- Clean up model lama jika ada
for _, obj in ipairs(workspace:GetChildren()) do
	if obj.Name == modelName then
		obj:Destroy()
	end
end

-- Listener untuk mencari zyy
workspace.ChildAdded:Connect(function(child)
	if child.Name == modelName and zyy == nil then
		zyy = lastFired
		print("Found zyy via Listener!")
	end
end)

-- Fungsi Drag (Agar GUI bisa digeser)
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- [[ UI CONSTRUCTION ]] --

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyySystemUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- --- MAIN FRAME ---
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "SPTZYY HUB V2"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.Parent = MainFrame

local UIList = Instance.new("UIListLayout", ScrollingFrame)
UIList.Padding = UDim.new(0, 8)

-- Tombol Fitur 1: Payload Menu
local BtnPayload = Instance.new("TextButton")
BtnPayload.Size = UDim2.new(1, 0, 0, 45)
BtnPayload.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BtnPayload.Text = "Open Payload Injector"
BtnPayload.TextColor3 = Color3.white
BtnPayload.Font = Enum.Font.GothamMedium
BtnPayload.Parent = ScrollingFrame
Instance.new("UICorner", BtnPayload)

-- Tombol Fitur 2: Scan Remotes (Fungsi Lama Anda)
local BtnScan = Instance.new("TextButton")
BtnScan.Size = UDim2.new(1, 0, 0, 45)
BtnScan.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BtnScan.Text = "Run Auto Scan Remotes"
BtnScan.TextColor3 = Color3.white
BtnScan.Font = Enum.Font.GothamMedium
BtnScan.Parent = ScrollingFrame
Instance.new("UICorner", BtnScan)

-- --- PAYLOAD INJECTOR FRAME (Hidden by Default) ---
local PayloadFrame = Instance.new("Frame")
PayloadFrame.Size = UDim2.new(0, 350, 0, 300)
PayloadFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
PayloadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
PayloadFrame.Visible = false
PayloadFrame.Parent = ScreenGui

Instance.new("UICorner", PayloadFrame)
local PStroke = Instance.new("UIStroke", PayloadFrame)
PStroke.Color = Color3.fromRGB(0, 255, 255)

local PTitle = Instance.new("TextLabel")
PTitle.Size = UDim2.new(1, 0, 0, 40)
PTitle.Text = "CUSTOM PAYLOAD"
PTitle.TextColor3 = Color3.white
PTitle.BackgroundTransparency = 1
PTitle.Font = Enum.Font.GothamBold
PTitle.Parent = PayloadFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 150)
TextBox.Position = UDim2.new(0.05, 0, 0.2, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TextBox.TextColor3 = Color3.fromRGB(0, 255, 0)
TextBox.Text = ""
TextBox.PlaceholderText = "-- Tulis skrip di sini..."
TextBox.MultiLine = true
TextBox.Font = Enum.Font.Code
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.Parent = PayloadFrame

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0.4, 0, 0, 40)
ExecuteBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
ExecuteBtn.Text = "EXECUTE"
ExecuteBtn.TextColor3 = Color3.white
ExecuteBtn.Parent = PayloadFrame

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0.4, 0, 0, 40)
BackBtn.Position = UDim2.new(0.55, 0, 0.8, 0)
BackBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
BackBtn.Text = "BACK"
BackBtn.TextColor3 = Color3.white
BackBtn.Parent = PayloadFrame

-- [[ LOGIC & CONNECTORS ]] --

makeDraggable(MainFrame)
makeDraggable(PayloadFrame)

-- Navigasi
BtnPayload.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	PayloadFrame.Visible = true
end)

BackBtn.MouseButton1Click:Connect(function()
	PayloadFrame.Visible = false
	MainFrame.Visible = true
end)

-- Fungsi Scan Otomatis (Logika Lama Anda)
BtnScan.MouseButton1Click:Connect(function()
	local defaultPayload = " KONTOL MESUM😂 "
	for _, remote in ipairs(game.ReplicatedStorage:GetDescendants()) do
		if remote:IsA("RemoteEvent") then
			pcall(function()
				remote:FireServer(defaultPayload)
			end)
			lastFired = remote
			RunService.RenderStepped:Wait()
		end
	end
	
	task.wait(0.5)
	
	-- Cek apakah zyy ditemukan untuk injeksi lanjutan
	if zyy and typeof(zyy) == "Instance" then
		local playerName = LocalPlayer.Name
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
	else
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "SPTZYY",
			Text = "Remote zyy not found yet.",
			Duration = 3,
		})
	end
end)

-- Fungsi Execute Custom Payload
ExecuteBtn.MouseButton1Click:Connect(function()
	local customCode = TextBox.Text
	if customCode ~= "" then
		for _, remote in ipairs(game.ReplicatedStorage:GetDescendants()) do
			if remote:IsA("RemoteEvent") then
				pcall(function()
					remote:FireServer(customCode)
				end)
			end
		end
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Success",
			Text = "Custom payload sent to all remotes.",
			Duration = 2,
		})
	end
end)
