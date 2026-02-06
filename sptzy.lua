-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE EDITION + SCANNER ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125
local followStrength = 100

-- [[ LOGIKA PHYSICS ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            local distance = (part.Position - rootPart.Position).Magnitude
            if distance <= pullRadius then
                pcall(function() 
                    part:SetNetworkOwner(lp) 
                    part.Velocity = (targetPos - part.Position) * followStrength
                    part.RotVelocity = Vector3.new(0, 10, 0)
                end)
            end
        end
    end
end)

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BEAST CONTROLLER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- Kontainer untuk Fitur (Sembunyi saat loading)
local FeatureFrame = Instance.new("Frame", MainFrame)
FeatureFrame.Size = UDim2.new(1, 0, 1, -40)
FeatureFrame.Position = UDim2.new(0, 0, 0, 40)
FeatureFrame.BackgroundTransparency = 1
FeatureFrame.Visible = false

-- Loading Overlay
local LoadingLabel = Instance.new("TextLabel", MainFrame)
LoadingLabel.Size = UDim2.new(1, 0, 0, 100)
LoadingLabel.Position = UDim2.new(0, 0, 0.3, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "SCANNING FOR VULNERABILITY..."
LoadingLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
LoadingLabel.Font = Enum.Font.Code
LoadingLabel.TextSize = 14

-- [[ FITUR DALAM FEATURE FRAME ]] --
local StatusBtn = Instance.new("TextButton", FeatureFrame)
StatusBtn.Size = UDim2.new(0.85, 0, 0, 40)
StatusBtn.Position = UDim2.new(0.075, 0, 0.05, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
StatusBtn.Text = "MAGNET: ON"
StatusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusBtn)

local InputBox = Instance.new("TextBox", FeatureFrame)
InputBox.Size = UDim2.new(0.85, 0, 0, 35)
InputBox.Position = UDim2.new(0.075, 0, 0.25, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InputBox.PlaceholderText = "Ketik Pesan / Angka..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox)

local AnnounceBtn = Instance.new("TextButton", FeatureFrame)
AnnounceBtn.Size = UDim2.new(0.85, 0, 0, 35)
AnnounceBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
AnnounceBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
AnnounceBtn.Text = "GLOBAL ANNOUNCE"
AnnounceBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", AnnounceBtn)

local CountBtn = Instance.new("TextButton", FeatureFrame)
CountBtn.Size = UDim2.new(0.85, 0, 0, 35)
CountBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
CountBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
CountBtn.Text = "START COUNTDOWN"
CountBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CountBtn)

-- [[ ANIMASI & LOGIKA CHECK ]] --
local function StartBackdoorCheck()
    local frames = {"|", "/", "-", "\\"}
    local success = false
    
    -- Loop Animasi Loading
    for i = 1, 12 do
        LoadingLabel.Text = "SCANNING VULNERABILITY " .. frames[i % 4 + 1]
        task.wait(0.2)
    end
    
    if _G.HDAdminMain then
        success = true
        LoadingLabel.Text = "SUCCESS: BACKDOOR INJECTED!"
        LoadingLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        LoadingLabel.Text = "FAILED: NO FRAMEWORK FOUND\n(Magnet Only Mode)"
        LoadingLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
    
    task.wait(1.5)
    LoadingLabel.Visible = false
    FeatureFrame.Visible = true
    
    -- Jika gagal, sembunyikan tombol backdoor agar tidak error
    if not success then
        AnnounceBtn.Visible = false
        CountBtn.Visible = false
        InputBox.PlaceholderText = "BACKDOOR UNAVAILABLE"
        InputBox.Active = false
    end
end

-- [[ BUTTON EVENTS ]] --
AnnounceBtn.MouseButton1Click:Connect(function()
    local main = _G.HDAdminMain
    if main and InputBox.Text ~= "" then
        main.modules.messages:GlobalAnnouncement({
            Title = "BEAST SYSTEM",
            Message = InputBox.Text,
            Color = {0, 1, 1},
            SenderId = lp.UserId,
            SenderName = lp.Name,
            DisplayFrom = true
        })
        InputBox.Text = ""
    end
end)

CountBtn.MouseButton1Click:Connect(function()
    local main = _G.HDAdminMain
    if main and InputBox.Text ~= "" then
        main.modules.messages:Message({lp, "Countdown", "BEAST TIMER", "", tonumber(InputBox.Text) or 10, Color3.new(1,1,1)})
        InputBox.Text = ""
    end
end)

StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80)
end)

-- [[ ICON & DRAG ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)

IconButton.MouseButton1Click:Connect(function() 
    MainFrame.Visible = not MainFrame.Visible 
end)

-- Jalankan Check saat GUI pertama dibuka
local firstOpen = true
IconButton.MouseButton1Click:Connect(function()
    if firstOpen then
        firstOpen = false
        StartBackdoorCheck()
    end
end)

-- Dragging Logic (Simple)
local function drag(obj)
    local inputBegan = obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local startPos = obj.Position
            local startInput = input.Position
            local moveCon
            moveCon = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - startInput
                    obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then moveCon:Disconnect() end
            end)
        end
    end)
end
drag(MainFrame); drag(IconButton)
