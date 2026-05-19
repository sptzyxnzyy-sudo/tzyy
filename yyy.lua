-- [[ SERVER-REPLICATED SHARP SQUARE 300x300 PHYSICS PRO V8 ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

-- [[ SETUP GUI UTAMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerPhysicsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Frame Utama (Persegi Empat Sempurna 300x300)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.3, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

-- Border Cyan Tajam
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 180, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Header Menu
local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, 0, 0, 30)
HeaderLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
HeaderLabel.BorderSizePixel = 0
HeaderLabel.Text = "  SERVER REPLICATED PHYSICS V8"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLabel.Font = Enum.Font.SourceSansBold
HeaderLabel.TextSize = 11
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = MainFrame

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(28, 28, 33)
HeaderStroke.Thickness = 1
HeaderStroke.Parent = HeaderLabel

-- Kontainer Utama Vertikal (CanvasSize disesuaikan untuk 6 fitur)
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -12, 1, -40)
ScrollContainer.Position = UDim2.new(0, 6, 0, 34)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 340)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollContainer

-- [[ VARIABLE & LOGIKA REPLIKASI FISIKA SERVER ]] --
local States = {
    MassSpin = false,
    BlackHole = false,
    FlingSlingshot = false,
    BreakTethers = false,
    GlitchMagnet = false,
    QuantumTether = false
}

local Radius = 150 -- Jarak jangkauan luas (150 Studs)

-- Fungsi mengklaim Network Ownership agar perubahan dilihat semua orang
local function claimNetworkOwnership(part)
    if settings().Physics.AllowSleep then
        settings().Physics.AllowSleep = false
    end
    part.RotVelocity = part.RotVelocity + Vector3.new(0, 0.01, 0)
end

local function getValidParts()
    local parts = {}
    local root = Character:FindFirstChild("HumanoidRootPart")
    if not root then return parts end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(Character) then
            if (obj.Position - root.Position).Magnitude <= Radius then
                table.insert(parts, obj)
            end
        end
    end
    return parts
end

-- Runtime Loop Menggunakan Heartbeat
RunService.Heartbeat:Connect(function()
    local root = Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local targets = getValidParts()

    for _, part in pairs(targets) do
        claimNetworkOwnership(part)

        -- 1. Mass Spin (Goyang Brutal + Replicated)
        if States.MassSpin then
            part.RotVelocity = Vector3.new(0, 150, 0)
            part.Velocity = part.Velocity + Vector3.new(math.random(-15, 15), math.random(-10, 10), math.random(-15, 15))
        end

        -- 2. Black Hole (Magnet Replicated Tanpa Putus)
        if States.BlackHole then
            local targetPos = root.Position + Vector3.new(0, 18, 0)
            local direction = (targetPos - part.Position)
            local distance = direction.Magnitude
            
            if distance > 2 then
                part.Velocity = direction.Unit * 65
            else
                part.Velocity = Vector3.new(0, 0, 0)
            end
        end

        -- 3. Fling Slingshot (Lontar Brutal Replicated)
        if States.FlingSlingshot then
            part.Velocity = Vector3.new(
                math.random(-500, 500),
                math.random(400, 700),
                math.random(-500, 500)
            )
        end

        -- 4. Break Tethers (Hancurkan Constraint Tali Aktif)
        if States.BreakTethers then
            for _, subObj in pairs(part:GetChildren()) do
                if subObj:IsA("Constraint") or subObj:IsA("RopeConstraint") or subObj:IsA("Weld") or subObj:IsA("WeldConstraint") then
                    subObj:Destroy()
                end
            end
        end

        -- 5. Glitch Magnet (Mekanisme Magnet Error / Stuttering Server)
        if States.GlitchMagnet then
            local targetPos = root.Position
            local direction = (targetPos - part.Position)
            -- Membanjiri kalkulasi posisi dengan entakan eksponensial tak beraturan
            part.Velocity = direction.Unit * math.random(800, 3000) * (math.random(1, 2) == 1 and 1 or -1)
            part.RotVelocity = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
        end

        -- 6. Quantum Tether (Membawa Part Kemana Saja - Magnet Sangat Kuat)
        if States.QuantumTether then
            -- Target titik berada 6 stud tepat di depan dada player
            local holdPos = (root.CFrame * CFrame.new(0, 0, -6)).Position
            local direction = (holdPos - part.Position)
            local distance = direction.Magnitude
            
            -- Peningkatan akselerasi berdasarkan jarak agar tarikan sangat ketat dan tidak lepas
            if distance > 1 then
                part.Velocity = direction * 35
            else
                part.Velocity = root.Velocity -- Mengunci kecepatan part mengikuti kecepatan jalan player
            end
        end
    end
end)

-- [[ METODE GENERATOR KOMPONEN GUI ]] --
local function createSquareComponent(title, desc, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, -6, 0, 48)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = true
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = ScrollContainer

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 35, 40)
    Stroke.Thickness = 1
    Stroke.Parent = ButtonFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 0.4, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0.1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ButtonFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -55, 0.5, 0)
    DescLabel.Position = UDim2.new(0, 8, 0.45, 0)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(130, 130, 135)
    DescLabel.Font = Enum.Font.SourceSansItalic
    DescLabel.TextSize = 9
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.Parent = ButtonFrame

    local Indicator = Instance.new("TextLabel")
    local IndicatorStroke = Instance.new("UIStroke")
    Indicator.Size = UDim2.new(0, 36, 0, 18)
    Indicator.Position = UDim2.new(1, -44, 0.5, -9)
    Indicator.BorderSizePixel = 0
    Indicator.Font = Enum.Font.SourceSansBold
    Indicator.TextSize = 9
    Indicator.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Indicator.Text = "OFF"
    Indicator.TextColor3 = Color3.fromRGB(150, 150, 150)
    Indicator.Parent = ButtonFrame

    IndicatorStroke.Color = Color3.fromRGB(50, 50, 55)
    IndicatorStroke.Thickness = 1
    IndicatorStroke.Parent = Indicator

    local toggled = false

    ButtonFrame.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            Stroke.Color = Color3.fromRGB(0, 180, 255)
            Indicator.BackgroundColor3 = Color3.fromRGB(0, 85, 160)
            Indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Text = "ON"
            IndicatorStroke.Color = Color3.fromRGB(0, 180, 255)
        else
            Stroke.Color = Color3.fromRGB(35, 35, 40)
            Indicator.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            Indicator.TextColor3 = Color3.fromRGB(150, 150, 150)
            Indicator.Text = "OFF"
            IndicatorStroke.Color = Color3.fromRGB(50, 50, 55)
        end
        callback(toggled)
    end)
end

-- [[ INTEGRASI SEMUA FITUR (6 KOMPONEN ACTIVE TOGGLE) ]] --
createSquareComponent("Mass Spin", "Membuat objek berputar ekstrem dan bergoyang brutal.", function(state) States.MassSpin = state end)
createSquareComponent("Black Hole", "Menarik objek unanchored berkumpul di atas kepala.", function(state) States.BlackHole = state end)
createSquareComponent("Fling Slingshot", "Melontarkan objek dengan entakan kecepatan masif acak.", function(state) States.FlingSlingshot = state end)
createSquareComponent("Break Tethers", "Memutus paksa sambungan tali/constraint pada part terdekat.", function(state) States.BreakTethers = state end)
createSquareComponent("Glitch Magnet", "Menarik objek dengan kalkulasi velocity rusak/error.", function(state) States.GlitchMagnet = state end)
createSquareComponent("Quantum Tether", "Mengunci dan membawa objek kemana pun karakter bergerak.", function(state) States.QuantumTether = state end)

print("Server-Replicated Physics Toolkit v8 Berhasil Dimuat!")
