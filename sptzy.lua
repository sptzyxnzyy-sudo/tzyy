-- [[ SPTZYY PART CONTROLLER + MORPH BEAST ULTIMATE BYPASS ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125        
local followStrength = 100  

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SptzyyUltraControl_Aggressive"

local function showNotify(message, isSuccess)
    local notifyFrame = Instance.new("Frame", ScreenGui)
    notifyFrame.Size = UDim2.new(0, 220, 0, 45)
    notifyFrame.Position = UDim2.new(1, 10, 0.15, 0)
    notifyFrame.BackgroundColor3 = isSuccess and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 50, 50)
    notifyFrame.BorderSizePixel = 0
    Instance.new("UICorner", notifyFrame)
    local stroke = Instance.new("UIStroke", notifyFrame)
    stroke.Thickness = 2
    stroke.Color = Color3.new(1, 1, 1)

    local text = Instance.new("TextLabel", notifyFrame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.TextWrapped = true

    notifyFrame:TweenPosition(UDim2.new(1, -230, 0.15, 0), "Out", "Back", 0.5)
    task.delay(2.5, function()
        if notifyFrame then
            notifyFrame:TweenPosition(UDim2.new(1, 10, 0.15, 0), "In", "Quad", 0.5)
            task.wait(0.5)
            notifyFrame:Destroy()
        end
    end)
end

-- [[ LOGIKA MAGNET ]] --
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
                end)
            end
        end
    end
end)

-- [[ FUNGSI MORPH ULTIMATE BYPASS ]] --
local function aggressiveMorph(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local myChar = lp.Character
    if not myChar then return end

    showNotify("Memulai Injeksi Avatar...", true)

    -- Langkah 1: Amankan objek di folder sementara (Bypass Detection)
    local tempFolder = Instance.new("Folder")
    
    pcall(function()
        -- Salin semua item target ke folder sementara dulu
        for _, item in pairs(targetPlayer.Character:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("BodyColors") then
                local cl = item:Clone()
                cl.Parent = tempFolder
            end
        end

        -- Salin Wajah
        local tHead = targetPlayer.Character:FindFirstChild("Head")
        if tHead and tHead:FindFirstChild("face") then
            tHead.face:Clone().Parent = tempFolder
        end

        -- Langkah 2: Hapus item kamu dengan sangat cepat (Aggressive Wipe)
        for _, item in pairs(myChar:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("BodyColors") then
                item:Destroy()
            end
        end

        -- Langkah 3: Masukkan hasil kloning
        for _, item in pairs(tempFolder:GetChildren()) do
            if item:IsA("Decal") then -- Jika itu wajah
                if myChar:FindFirstChild("Head") then
                    if myChar.Head:FindFirstChild("face") then myChar.Head.face:Destroy() end
                    item.Parent = myChar.Head
                end
            else
                item.Parent = myChar
            end
        end
    end)

    tempFolder:Destroy()
    showNotify("INJEKSI SELESAI!", true)
end

-- [[ UI CONSTRUCTION ]] --
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", IconButton).Color = Color3.fromRGB(0, 255, 150)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 340)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.BackgroundTransparency = 1

local function createTab(name, xPos)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.5, -5, 1, -5)
    btn.Position = UDim2.new(xPos, 2.5, 0, 5)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn)
    return btn
end

local Tab1 = createTab("MAGNET", 0)
local Tab2 = createTab("ULTIMATE COPY", 0.5)

local MagnetPage = Instance.new("Frame", MainFrame)
MagnetPage.Size = UDim2.new(1, 0, 1, -40)
MagnetPage.Position = UDim2.new(0, 0, 0, 40)
MagnetPage.BackgroundTransparency = 1

local MorphPage = Instance.new("ScrollingFrame", MainFrame)
MorphPage.Size = UDim2.new(1, -10, 1, -50)
MorphPage.Position = UDim2.new(0, 5, 0, 45)
MorphPage.BackgroundTransparency = 1
MorphPage.Visible = false
MorphPage.ScrollBarThickness = 2
Instance.new("UIListLayout", MorphPage).Padding = UDim.new(0, 5)

local StatusBtn = Instance.new("TextButton", MagnetPage)
StatusBtn.Size = UDim2.new(0.8, 0, 0, 45)
StatusBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
StatusBtn.Text = "MAGNET: ON"
StatusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusBtn)

local function refreshList()
    for _, c in pairs(MorphPage:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= lp then
            local pFrame = Instance.new("Frame", MorphPage)
            pFrame.Size = UDim2.new(1, 0, 0, 50)
            pFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", pFrame)

            local pName = Instance.new("TextLabel", pFrame)
            pName.Size = UDim2.new(1, -80, 1, 0)
            pName.Position = UDim2.new(0, 10, 0, 0)
            pName.Text = target.DisplayName
            pName.TextColor3 = Color3.new(1, 1, 1)
            pName.Font = Enum.Font.GothamMedium
            pName.TextXAlignment = Enum.TextXAlignment.Left
            pName.BackgroundTransparency = 1

            local copyBtn = Instance.new("TextButton", pFrame)
            copyBtn.Size = UDim2.new(0, 70, 0, 30)
            copyBtn.Position = UDim2.new(1, -75, 0, 10)
            copyBtn.Text = "FORCE COPY"
            copyBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
            copyBtn.TextColor3 = Color3.new(1, 1, 1)
            copyBtn.Font = Enum.Font.GothamBold
            copyBtn.TextSize = 8
            Instance.new("UICorner", copyBtn)

            copyBtn.MouseButton1Click:Connect(function() aggressiveMorph(target) end)
        end
    end
end

Tab1.MouseButton1Click:Connect(function() MagnetPage.Visible = true; MorphPage.Visible = false end)
Tab2.MouseButton1Click:Connect(function() MagnetPage.Visible = false; MorphPage.Visible = true; refreshList() end)

local function drag(obj)
    local draggin, startPos, dragStart
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggin = true; startPos = obj.Position; dragStart = i.Position end end)
    obj.InputChanged:Connect(function(i) if draggin and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - dragStart; obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggin = false end end)
end

drag(IconButton); drag(MainFrame)
IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    StatusBtn.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    StatusBtn.BackgroundColor3 = botActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80)
end)

showNotify("ULTIMATE BYPASS LOADED", true)
