-- [[ SPTZYY PART DESTROYER: REAL-TIME PHYSICS EDITION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local destroyRadius = 100    -- Jarak kehancuran (dalam unit)
local physicsKick = 15      -- Kekuatan dorongan saat part lepas

-- [[ LOGIKA PENGHANCUR REAL-TIME ]] --
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = lp.Character.HumanoidRootPart

    -- Mencari objek di sekitar pemain
    for _, part in pairs(workspace:GetDescendants()) do
        -- Validasi: Harus berupa Part, bukan milik karakter pemain, dan bukan Baseplate
        if part:IsA("BasePart") and not part:IsDescendantOf(lp.Character) and part.Name ~= "Baseplate" and part.Name ~= "Terrain" then
            
            local distance = (part.Position - rootPart.Position).Magnitude
            
            if distance <= destroyRadius then
                -- 1. AMBIL ALIH KONTROL (Network Ownership)
                -- Agar perubahan 'Anchored' dan 'Velocity' terlihat oleh semua orang di server
                pcall(function() 
                    if part.ReceiveAge > 0 then 
                        part:SetNetworkOwner(lp) 
                    end
                end)

                -- 2. HANCURKAN STRUKTUR (Break Welds/Joints)
                -- Ini membuat part copot dari bangunan secara permanen
                part:BreakJoints()

                -- 3. NONAKTIFKAN ANCHOR (Matikan paku udara)
                if part.Anchored then
                    part.Anchored = false
                end

                -- 4. BERIKAN EFEK JATUH NYATA
                -- Memberi sedikit dorongan ke bawah dan acak agar tidak kaku
                if part.Velocity.Magnitude < 1 then
                    part.Velocity = Vector3.new(math.random(-2, 2), -physicsKick, math.random(-2, 2))
                end
                
                -- Hancurkan segala jenis tali/constraint yang tersisa
                for _, constraint in pairs(part:GetChildren()) do
                    if constraint:IsA("Constraint") then
                        constraint:Destroy()
                    end
                end
            end
        end
    end
end)

---

-- [[ UI SETUP: ICON & MAIN GUI ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SptzyyDestroyer"

-- Tombol Icon (Floating)
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://6031225818" -- Icon Destroyer/Warning
IconButton.BorderSizePixel = 0
local IconCorner = Instance.new("UICorner", IconButton)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(255, 50, 50)
IconStroke.Thickness = 2

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false 
local MainCorner = Instance.new("UICorner", MainFrame)
MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BEAST DESTROYER 🧨"
Title.TextColor3 = Color3.new(1, 0.2, 0.2)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.85, 0, 0, 45)
StatusBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
StatusBtn.Text = "DESTRUCTION: ON"
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", StatusBtn)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 50)
Info.Position = UDim2.new(0, 0, 0.65, 0)
Info.Text = "STATUS: REAL-TIME SERVER\nAUTO-ANCHOR: OFF\nJoints Breaker: ACTIVE"
Info.TextColor3 = Color3.fromRGB(180, 180, 180)
Info.TextSize = 10
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamMedium

-- [[ FUNGSI DRAG ]] --
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

MakeDraggable(IconButton)
MakeDraggable(MainFrame)

-- Event Handlers
IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    if botActive then
        StatusBtn.Text = "DESTRUCTION: ON"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        IconStroke.Color = Color3.fromRGB(255, 50, 50)
    else
        StatusBtn.Text = "DESTRUCTION: OFF"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        IconStroke.Color = Color3.fromRGB(255, 255, 255)
    end
end)
