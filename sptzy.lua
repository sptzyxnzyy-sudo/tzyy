local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Fungsi untuk membuat UI bisa digeser (Draggable)
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

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyExecutorUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- --- MAIN GUI ---
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255) -- Neon Cyan
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SPTZYY MAIN LIST"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local FeatureList = Instance.new("ScrollingFrame")
FeatureList.Size = UDim2.new(1, -20, 1, -60)
FeatureList.Position = UDim2.new(0, 10, 0, 45)
FeatureList.BackgroundTransparency = 1
FeatureList.CanvasSize = UDim2.new(0, 0, 2, 0)
FeatureList.ScrollBarThickness = 2
FeatureList.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = FeatureList

-- Button to open Payload GUI
local OpenPayloadBtn = Instance.new("TextButton")
OpenPayloadBtn.Size = UDim2.new(1, 0, 0, 40)
OpenPayloadBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OpenPayloadBtn.Text = "Custom Payload Runner"
OpenPayloadBtn.TextColor3 = Color3.white
OpenPayloadBtn.Font = Enum.Font.Gotham
OpenPayloadBtn.Parent = FeatureList

-- --- PAYLOAD GUI ---
local PayloadFrame = Instance.new("Frame")
PayloadFrame.Name = "PayloadFrame"
PayloadFrame.Size = UDim2.new(0, 350, 0, 250)
PayloadFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
PayloadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PayloadFrame.Visible = false
PayloadFrame.Parent = ScreenGui

Instance.new("UICorner", PayloadFrame).CornerRadius = UDim.new(0, 8)
local PStroke = Instance.new("UIStroke", PayloadFrame)
PStroke.Color = Color3.fromRGB(0, 255, 255)
PStroke.Thickness = 2

local PTitle = Instance.new("TextLabel")
PTitle.Size = UDim2.new(1, 0, 0, 40)
PTitle.Text = "PAYLOAD INJECTOR"
PTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
PTitle.BackgroundTransparency = 1
PTitle.Font = Enum.Font.GothamBold
PTitle.Parent = PayloadFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.9, 0, 0, 100)
InputBox.Position = UDim2.new(0.05, 0, 0.2, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InputBox.Text = ""
InputBox.PlaceholderText = "Masukkan script payload di sini..."
InputBox.TextColor3 = Color3.white
InputBox.ClearTextOnFocus = false
InputBox.MultiLine = true
InputBox.TextWrapped = true
InputBox.Parent = PayloadFrame

local RunBtn = Instance.new("TextButton")
RunBtn.Size = UDim2.new(0.4, 0, 0, 40)
RunBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
RunBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
RunBtn.Text = "FIRE REMOTE"
RunBtn.TextColor3 = Color3.white
RunBtn.Parent = PayloadFrame

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0.4, 0, 0, 40)
BackBtn.Position = UDim2.new(0.55, 0, 0.75, 0)
BackBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
BackBtn.Text = "BACK"
BackBtn.TextColor3 = Color3.white
BackBtn.Parent = PayloadFrame

-- --- LOGIC ---

makeDraggable(MainFrame)
makeDraggable(PayloadFrame)

OpenPayloadBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	PayloadFrame.Visible = true
end)

BackBtn.MouseButton1Click:Connect(function()
	PayloadFrame.Visible = false
	MainFrame.Visible = true
end)

RunBtn.MouseButton1Click:Connect(function()
	local customPayload = InputBox.Text
	for _, remote in ipairs(game.ReplicatedStorage:GetDescendants()) do
		if remote:IsA("RemoteEvent") then
			pcall(function()
				remote:FireServer(customPayload)
			end)
		end
	end
	
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Status",
		Text = "Payload Fired to Remotes!",
		Duration = 3
	})
end)
