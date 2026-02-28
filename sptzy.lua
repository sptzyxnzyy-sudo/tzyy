local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local InputBox = Instance.new("TextBox")
local ToggleBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- Properti GUI
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "SpamGui_Ikyy"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Fitur geser aktif

Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Spam Executor"
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

InputBox.Size = UDim2.new(0.9, 0, 0, 30)
InputBox.Position = UDim2.new(0.05, 0, 0.3, 0)
InputBox.PlaceholderText = "Ketik pesan di sini..."
InputBox.Text = "⚡ ikyynih43 vote skip (1/55)"
InputBox.Parent = MainFrame

ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
ToggleBtn.Text = "START SPAM"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = MainFrame

-- Logika Spam
local isSpamming = false

ToggleBtn.MouseButton1Click:Connect(function()
    isSpamming = not isSpamming
    
    if isSpamming then
        ToggleBtn.Text = "STOP SPAM"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        
        -- Loop Spam
        task.spawn(function()
            while isSpamming do
                local args = {
                    [1] = InputBox.Text
                }
                game:GetService("ReplicatedStorage").NotifyEvent:FireServer(unpack(args))
                task.wait(0.5) -- Jeda waktu antar pesan (biar tidak kena kick/lag)
            end
        end)
    else
        ToggleBtn.Text = "START SPAM"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)
