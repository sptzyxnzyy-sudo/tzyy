-- Beckdeer Mobile Executor - Square Rainbow Edition
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BeckMobileRainbow"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

-- 1. Main Square Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 220, 0, 220)
main.Position = UDim2.new(0.5, -110, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Visible = true
main.Parent = screenGui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 6)

-- Rainbow Stroke (Garis Tepi Pelangi)
local uiStroke = Instance.new("UIStroke", main)
uiStroke.Thickness = 2.5
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 2. Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "BECKDEER EXECUTOR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.Parent = main
Instance.new("UICorner", title)

-- 3. Editor Box
local editor = Instance.new("TextBox")
editor.Size = UDim2.new(0.88, 0, 0.55, 0)
editor.Position = UDim2.new(0.06, 0, 0.18, 0)
editor.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
editor.Text = ""
editor.PlaceholderText = "-- Masukkan script..."
editor.TextColor3 = Color3.fromRGB(255, 255, 255)
editor.TextSize = 11
editor.Font = Enum.Font.Code
editor.MultiLine = true
editor.ClearTextOnFocus = false
editor.TextXAlignment = Enum.TextXAlignment.Left
editor.TextYAlignment = Enum.TextYAlignment.Top
editor.Parent = main
Instance.new("UICorner", editor)

-- 4. Execute Button
local exec = Instance.new("TextButton")
exec.Size = UDim2.new(0.88, 0, 0, 35)
exec.Position = UDim2.new(0.06, 0, 0.78, 0)
exec.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
exec.Text = "EXECUTE"
exec.TextColor3 = Color3.white
exec.Font = Enum.Font.GothamBold
exec.TextSize = 14
exec.Parent = main
Instance.new("UICorner", exec)

-- 5. Floating Toggle Button (Tombol Buka/Tutup)
local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(0, 45, 0, 45)
toggle.Position = UDim2.new(0, 10, 0.5, -22)
toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggle.Text = "B"
toggle.TextColor3 = Color3.white
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 20
toggle.Parent = screenGui
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggle)
toggleStroke.Thickness = 2

--- LOGIC SISTEM ---

-- Efek Rainbow (Pelangi)
RunService.RenderStepped:Connect(function()
	local hue = tick() % 5 / 5
	local color = Color3.fromHSV(hue, 1, 1)
	uiStroke.Color = color
	toggleStroke.Color = color
	exec.TextColor3 = color
end)

-- Smooth Dragging Logic untuk Mobile
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- Execute & Auto-Clear Logic
exec.MouseButton1Click:Connect(function()
	if remoteInfo.foundBackdoor then
		local code = editor.Text
		if code ~= "" then
			execScript(code)
			editor.Text = "" -- Menghapus teks secara otomatis
			newNotification("Executed & Cleared!")
		end
	else
		newNotification("Error: Backdoor not found!")
	end
end)

-- Toggle Menu
toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

newNotification("Beckdeer Mobile Loaded! Rainbow Active.")
