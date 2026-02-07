-- [[ SPTZYY ULTIMATE V12: ALL-IN-ONE FINAL ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125        
local followStrength = 100  
local walkSpeedValue = 16

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Sptzyy_V12_Final"

local function showNotify(title, message, isSuccess)
    local notifyFrame = Instance.new("Frame", ScreenGui)
    notifyFrame.Size = UDim2.new(0, 220, 0, 50)
    notifyFrame.Position = UDim2.new(1, 10, 0.1, 0)
    notifyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notifyFrame.BorderSizePixel = 0
    Instance.new("UICorner", notifyFrame)
    local stroke = Instance.new("UIStroke", notifyFrame)
    stroke.Color = isSuccess and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 50, 50)
    
    local tLabel = Instance.new("TextLabel", notifyFrame)
    tLabel.Size = UDim2.new(1, 0, 0, 20)
    tLabel.Text = "  " .. title
    tLabel.TextColor3 = stroke.Color
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 10
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1

    local mLabel = Instance.new("TextLabel", notifyFrame)
    mLabel.Size = UDim2.new(1, -10, 0, 25)
    mLabel.Position = UDim2.new(0, 5, 0, 20)
    mLabel.Text = message
    mLabel.TextColor3 = Color3.new(1, 1, 1)
    mLabel.Font = Enum.Font.GothamMedium
    mLabel.TextSize = 9
    mLabel.TextWrapped = true
    mLabel.BackgroundTransparency = 1

    notifyFrame:TweenPosition(UDim2.new(1, -230, 0.1, 0), "Out", "Back", 0.5)
    task.delay(3, function()
        if notifyFrame and notifyFrame.Parent then
            notifyFrame:TweenPosition(UDim2.new(1, 10, 0.1, 0), "In", "Quad", 0.5)
            task.wait(0.5)
            notifyFrame:Destroy()
        end
    end)
end

-- [[ CORE LOOPS ]] --
RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = walkSpeedValue
    end
end)

local angle = 0
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            if (part.Position - rootPart.Position).Magnitude <= pullRadius then
                pcall(function()
                    part:SetNetworkOwner(lp) 
                    part.Velocity = (targetPos - part.Position) * followStrength
                end)
            end
        end
    end
end)

-- [[ UI CONSTRUCTION ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 45, 0, 45)
IconButton.Position = UDim2.new(0.02, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 200, 255)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(0, 200, 255)

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 35)
TabBar.Position = UDim2.new(0, 10, 0, 10)
TabBar.BackgroundTransparency = 1

local function createTab(name, xPos, width)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(width, -5, 1, 0)
    btn.Position = UDim2.new(xPos, 2.5, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    Instance.new("UICorner", btn)
    return btn
end

local Tab1 = createTab("MAIN", 0, 0.33)
local Tab2 = createTab("PLAYERS", 0.33, 0.33)
local Tab3 = createTab("SCANNER", 0.66, 0.34)

local MagnetPage = Instance.new("Frame", MainFrame)
MagnetPage.Size = UDim2.new(1, -20, 1, -60)
MagnetPage.Position = UDim2.new(0, 10, 0, 55)
MagnetPage.BackgroundTransparency = 1

local PlayerPage = Instance.new("ScrollingFrame", MainFrame)
PlayerPage.Size = UDim2.new(1, -20, 1, -60)
PlayerPage.Position = UDim2.new(0, 10, 0, 55)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = false
PlayerPage.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", PlayerPage)
layout.Padding = UDim.new(0, 6)

local ScanPage = Instance.new("Frame", MainFrame)
ScanPage.Size = UDim2.new(1, -20, 1, -60)
ScanPage.Position = UDim2.new(0, 10, 0, 55)
ScanPage.BackgroundTransparency = 1
ScanPage.Visible = false

-- [[ TAB 1: MAIN HACK ]] --
local StatusBtn = Instance.new("TextButton", MagnetPage)
StatusBtn.Size = UDim2.new(1, 0, 0, 35)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
StatusBtn.Text = "MAGNET: ACTIVE"
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", StatusBtn)

local SpeedLabel = Instance.new("TextLabel", MagnetPage)
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0, 0, 0, 45)
SpeedLabel.Text = "WALKSPEED: 16"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 10
SpeedLabel.BackgroundTransparency = 1

local SliderBack = Instance.new("Frame", MagnetPage)
SliderBack.Size = UDim2.new(1, -10, 0, 6)
SliderBack.Position = UDim2.new(0, 5, 0, 75)
SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", SliderBack)

local SliderFill = Instance.new("Frame", SliderBack)
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Instance.new("UICorner", SliderFill)

local SliderDot = Instance.new("TextButton", SliderBack)
SliderDot.Size = UDim2.new(0, 14, 0, 14)
SliderDot.Position = UDim2.new(0, -7, 0.5, -7)
SliderDot.BackgroundColor3 = Color3.new(1, 1, 1)
SliderDot.Text = ""
Instance.new("UICorner", SliderDot)

local SkyBtn = Instance.new("TextButton", MagnetPage)
SkyBtn.Size = UDim2.new(1, 0, 0, 35)
SkyBtn.Position = UDim2.new(0, 0, 0, 95)
SkyBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
SkyBtn.Text = "FORCE DAYLIGHT"
SkyBtn.Font = Enum.Font.GothamBold
SkyBtn.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", SkyBtn)

-- [[ TAB 3: SCANNER PAGE ]] --
local ScanActionBtn = Instance.new("TextButton", ScanPage)
ScanActionBtn.Size = UDim2.new(1, 0, 0, 40)
ScanActionBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ScanActionBtn.Text = "START WEBHOOK SCAN"
ScanActionBtn.Font = Enum.Font.GothamBold
ScanActionBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ScanActionBtn)

local LoadingBarBack = Instance.new("Frame", ScanPage)
LoadingBarBack.Size = UDim2.new(1, 0, 0, 10)
LoadingBarBack.Position = UDim2.new(0, 0, 0, 50)
LoadingBarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LoadingBarBack.Visible = false
Instance.new("UICorner", LoadingBarBack)

local LoadingBarFill = Instance.new("Frame", LoadingBarBack)
LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadingBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Instance.new("UICorner", LoadingBarFill)

local ResultBox = Instance.new("TextBox", ScanPage)
ResultBox.Size = UDim2.new(1, 0, 0, 150)
ResultBox.Position = UDim2.new(0, 0, 0, 70)
ResultBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ResultBox.TextColor3 = Color3.fromRGB(0, 255, 150)
ResultBox.Font = Enum.Font.Code
ResultBox.TextSize = 10
ResultBox.Text = "Scan results will appear here..."
ResultBox.TextWrapped = true
ResultBox.ClearTextOnFocus = false
ResultBox.TextYAlignment = Enum.TextYAlignment.Top
ResultBox.TextXAlignment = Enum.TextXAlignment.Left
ResultBox.ReadOnly = true
Instance.new("UICorner", ResultBox)

local CopyBtn = Instance.new("TextButton", ScanPage)
CopyBtn.Size = UDim2.new(1, 0, 0, 35)
CopyBtn.Position = UDim2.new(0, 0, 0, 230)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CopyBtn.Text = "COPY WEBHOOK"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextColor3 = Color3.new(1, 1, 1)
CopyBtn.Visible = false
Instance.new("UICorner", CopyBtn)

-- [[ LOGIC HANDLERS ]] --
ScanActionBtn.MouseButton1Click:Connect(function()
    ScanActionBtn.Text = "SCANNING..."
    LoadingBarBack.Visible = true
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    ResultBox.Text = "Searching descendants..."
    
    local hooks = {}
    for i = 1, 100 do
        LoadingBarFill.Size = UDim2.new(i/100, 0, 1, 0)
        task.wait(0.015)
    end
    
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("StringValue") and v.Value:find("discord.com/api/webhooks") then table.insert(hooks, v.Value) end
        end)
    end

    if #hooks > 0 then
        ResultBox.Text = table.concat(hooks, "\n")
        CopyBtn.Visible = true
        showNotify("SCAN COMPLETE", "Found " .. #hooks .. " Webhooks", true)
    else
        ResultBox.Text = "No webhooks found in reachable scripts."
        showNotify("SCAN COMPLETE", "Zero Results", false)
    end
    ScanActionBtn.Text = "RE-SCAN"
end)

CopyBtn.MouseButton1Click:Connect(function()
    setclipboard(ResultBox.Text)
    showNotify("COPIED", "Results sent to clipboard", true)
end)

SkyBtn.MouseButton1Click:Connect(function()
    Lighting.ClockTime = 14
    Lighting.Brightness = 2
    showNotify("SKY", "Daylight Applied!", true)
end)

local function updateSlider(input)
    local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
    SliderDot.Position = UDim2.new(pos, -7, 0.5, -7)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    walkSpeedValue = math.floor(16 + (pos * 184))
    SpeedLabel.Text = "WALKSPEED: " .. walkSpeedValue
end

local draggingS = false
SliderDot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingS = true end end)
UserInputService.InputChanged:Connect(function(i) if draggingS and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updateSlider(i) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingS = false end end)

-- [[ TAB 2: PLAYER LIST ]] --
local function refreshList()
    for _, c in pairs(PlayerPage:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= lp then
            local pFrame = Instance.new("Frame", PlayerPage)
            pFrame.Size = UDim2.new(1, -5, 0, 50)
            pFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", pFrame)

            local icon = Instance.new("ImageLabel", pFrame)
            icon.Size = UDim2.new(0, 35, 0, 35)
            icon.Position = UDim2.new(0, 8, 0.5, -17.5)
            icon.Image = Players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            icon.BackgroundTransparency = 1
            Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

            local name = Instance.new("TextLabel", pFrame)
            name.Size = UDim2.new(1, -160, 1, 0)
            name.Position = UDim2.new(0, 50, 0, 0)
            name.Text = target.DisplayName
            name.TextColor3 = Color3.new(1,1,1)
            name.Font = Enum.Font.GothamBold
            name.TextSize = 8
            name.TextXAlignment = Enum.TextXAlignment.Left
            name.BackgroundTransparency = 1

            local row = Instance.new("Frame", pFrame)
            row.Size = UDim2.new(0, 105, 0, 22)
            row.Position = UDim2.new(1, -110, 0.5, -11)
            row.BackgroundTransparency = 1

            local function bttn(t, x, c, f)
                local b = Instance.new("TextButton", row)
                b.Size = UDim2.new(0, 32, 1, 0)
                b.Position = UDim2.new(0, x, 0, 0)
                b.Text = t; b.BackgroundColor3 = c; b.TextColor3 = Color3.new(1,1,1)
                b.Font = Enum.Font.GothamBold; b.TextSize = 7; Instance.new("UICorner", b)
                b.MouseButton1Click:Connect(f)
            end

            bttn("TP", 0, Color3.fromRGB(0, 120, 255), function() pcall(function() lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end) end)
            bttn("EYE", 35, Color3.fromRGB(60, 60, 60), function() Camera.CameraSubject = target.Character.Humanoid end)
            bttn("INF", 70, Color3.fromRGB(150, 0, 255), function() showNotify("PLAYER INFO", "Age: "..target.AccountAge.."d | ID: "..target.UserId, true) end)
        end
    end
    PlayerPage.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

-- Navigation
Tab1.MouseButton1Click:Connect(function() MagnetPage.Visible = true; PlayerPage.Visible = false; ScanPage.Visible = false end)
Tab2.MouseButton1Click:Connect(function() MagnetPage.Visible = false; PlayerPage.Visible = true; ScanPage.Visible = false; refreshList() end)
Tab3.MouseButton1Click:Connect(function() MagnetPage.Visible = false; PlayerPage.Visible = false; ScanPage.Visible = true end)

-- Dragging
local function drag(obj)
    local d, s, ds
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = obj.Position; ds = i.Position end end)
    obj.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local del = i.Position - ds; obj.Position = UDim2.new(s.X.Scale, s.X.Offset + del.X, s.Y.Scale, s.Y.Offset + del.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

drag(IconButton); drag(MainFrame)
IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ACTIVE" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(200, 50, 50)
end)

showNotify("SPTZYY V12", "All Features Loaded Successfully!", true)
