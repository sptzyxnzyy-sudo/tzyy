-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE EDITION + BACKDOOR NOTIF ]] --
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
                for _, constraint in pairs(part:GetChildren()) do
                    if constraint:IsA("RopeConstraint") or constraint:IsA("RodConstraint") or constraint:IsA("SpringConstraint") then
                        constraint:Destroy()
                    end
                end
                pcall(function() part:SetNetworkOwner(lp) end)
                part.Velocity = (targetPos - part.Position) * followStrength
                part.RotVelocity = Vector3.new(0, 10, 0)
            end
        end
    end
end)

-- [[ BACKDOOR LOGIC (HD ADMIN FRAMEWORK) ]] --
local function GetHDAdmin()
    return _G.HDAdminMain
end

local function SendGlobal(mode, text)
    local main = GetHDAdmin()
    if not main then warn("HD Admin Main not found!") return end
    
    local msgModule = main.modules.messages
    if mode == "Announcement" then
        msgModule:GlobalAnnouncement({
            Title = "SERVER BREAKER",
            Message = text,
            Color = {1, 0.2, 0.2},
            SenderId = lp.UserId,
            SenderName = lp.Name,
            DisplayFrom = true
        })
    elseif mode == "Countdown" then
        -- Menggunakan logic Message dengan tipe Countdown
        msgModule:Message({lp, "Countdown", "COUNTDOWN", "", tonumber(text) or 10, Color3.fromRGB(255, 255, 255)})
    end
end

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 300) -- Ukuran ditambah untuk fitur baru
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BEAST CONTROLLER ❤️"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.85, 0, 0, 40)
StatusBtn.Position = UDim2.new(0.075, 0, 0.15, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
StatusBtn.Text = "MAGNET: ON"
StatusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusBtn)

-- Input Box untuk Pesan/Angka
local InputBox = Instance.new("TextBox", MainFrame)
InputBox.Size = UDim2.new(0.85, 0, 0, 35)
InputBox.Position = UDim2.new(0.075, 0, 0.35, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InputBox.PlaceholderText = "Ketik Pesan / Angka..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox)

-- Tombol Pengumuman
local AnnounceBtn = Instance.new("TextButton", MainFrame)
AnnounceBtn.Size = UDim2.new(0.85, 0, 0, 35)
AnnounceBtn.Position = UDim2.new(0.075, 0, 0.52, 0)
AnnounceBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
AnnounceBtn.Text = "GLOBAL MESSAGE"
AnnounceBtn.Font = Enum.Font.GothamBold
AnnounceBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AnnounceBtn)

-- Tombol Countdown
local CountBtn = Instance.new("TextButton", MainFrame)
CountBtn.Size = UDim2.new(0.85, 0, 0, 35)
CountBtn.Position = UDim2.new(0.075, 0, 0.68, 0)
CountBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
CountBtn.Text = "START COUNTDOWN"
CountBtn.Font = Enum.Font.GothamBold
CountBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CountBtn)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 40)
Info.Position = UDim2.new(0, 0, 0.85, 0)
Info.Text = "HD ADMIN BACKDOOR ACTIVE\nSptzyy Mobile Edition"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextSize = 9
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamMedium

-- [[ ICON FLOATING ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://6031094678"
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 2
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)

-- [[ DRAG LOGIC ]] --
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
MakeDraggable(IconButton); MakeDraggable(MainFrame)

-- [[ EVENTS ]] --
IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80)
end)

AnnounceBtn.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        SendGlobal("Announcement", InputBox.Text)
    end
end)

CountBtn.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        SendGlobal("Countdown", InputBox.Text)
    end
end)
