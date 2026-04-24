local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UsernameInput = Instance.new("TextBox")
local InjectBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UIStroke = Instance.new("UIStroke")

-- UI Styling (Minimalist Dark Cyan)
ScreenGui.Name = "SecurityTesterGui"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Morph Security Test"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1

UsernameInput.Parent = MainFrame
UsernameInput.Position = UDim2.new(0.1, 0, 0.25, 0)
UsernameInput.Size = UDim2.new(0.8, 0, 0, 30)
UsernameInput.PlaceholderText = "Target Username..."
UsernameInput.Text = ""

InjectBtn.Name = "InjectBtn"
InjectBtn.Parent = MainFrame
InjectBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
InjectBtn.Size = UDim2.new(0.8, 0, 0, 40)
InjectBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
InjectBtn.Text = "Scan & Inject Morph"
InjectBtn.TextColor3 = Color3.white

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 20)
StatusLabel.Text = "Idle"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextScaled = true

-- Logic Scanner & Injection
InjectBtn.MouseButton1Click:Connect(function()
    local targetUser = UsernameInput.Text
    if targetUser == "" then StatusLabel.Text = "Input Username!" return end
    
    StatusLabel.Text = "Scanning Remotes..."
    local foundAny = false

    -- Mencari semua Remote yang ada
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            -- Payload mencoba mengasumsikan Server butuh UserId atau Username untuk Morph
            local targetId = game:GetService("Players"):GetUserIdFromNameAsync(targetUser)
            
            -- Mencoba berbagai variasi payload yang umum digunakan di sistem Morph
            local payloads = {
                {targetUser},
                {targetId},
                {["Character"] = targetUser},
                {["UserId"] = targetId}
            }

            for _, payload in pairs(payloads) do
                pcall(function()
                    remote:FireServer(unpack(payload))
                end)
            end
            
            foundAny = true
            warn("✅ Test Payload dikirim ke: " .. remote:GetFullName())
        end
    end

    if foundAny then
        StatusLabel.Text = "Payload Sent! Check Avatar."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "No Remotes Found."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
