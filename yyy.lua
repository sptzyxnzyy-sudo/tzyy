-- [[ SHARP SQUARE 300x300 PHYSICS EXECUTOR ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

-- [[ SETUP GUI UTAMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SquarePhysics"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Frame Utama (Bentuk Persegi Empat Sempurna 300x300)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 300) -- Kotak presisi 300x300 pixel
MainFrame.Position = UDim2.new(0.5, -150, 0.3, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser luas di layar mobile
MainFrame.Parent = ScreenGui

-- Border Cyan Tajam Persegi Empat (Tanpa Lengkungan/UICorner)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 180, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Header Menu Atas
local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, 0, 0, 30)
HeaderLabel.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
HeaderLabel.BorderSizePixel = 0
HeaderLabel.Text = "  PHYSICS TOOLKIT (300x300)"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLabel.Font = Enum.Font.SourceSansBold
HeaderLabel.TextSize = 12
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = MainFrame

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(30, 30, 35)
HeaderStroke.Thickness = 1
HeaderStroke.Parent = HeaderLabel

-- Kontainer Utama (Scrollable Vertikal)
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -12, 1, -40)
ScrollContainer.Position = UDim2.new(0, 6, 0, 34)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 290) -- Ruang pas untuk 5 fitur
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical -- Menyusun ke bawah agar pas di bentuk kotak
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollContainer

-- [[ VARIABLE & LOGIKA PHYSICS ]] --
local States = {
    MassDrag = false,
    MassSpin = false,
    BlackHole = false,
    FlingSlingshot = false
}

local Radius = 65
local ActiveRopes = {}
local ActiveSpins = {}

local function getUnanchoredParts()
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

-- Runtime Loop untuk Fungsi Utama
RunService.Heartbeat:Connect(function()
    local root = Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local targets = getUnanchoredParts()

    -- 1. Mass Drag
    if States.MassDrag then
        local attachmentChar = root:FindFirstChild("DragAttachment") or Instance.new("Attachment", root)
        attachmentChar.Name = "DragAttachment"

        for _, part in pairs(targets) do
            if not part:FindFirstChild("DragRope") then
                local attPart = Instance.new("Attachment", part)
                attPart.Name = "PartAttachment"
                
                local rope = Instance.new("RopeConstraint", part)
                rope.Name = "DragRope"
                rope.Attachment0 = attachmentChar
                rope.Attachment1 = attPart
                rope.Length = 6
                rope.Visible = true
                table.insert(ActiveRopes, {part, rope, attPart})
            end
        end
    else
        for _, data in pairs(ActiveRopes) do
            if data[2] then data[2]:Destroy() end
            if data[3] then data[3]:Destroy() end
        end
        ActiveRopes = {}
    end

    -- 2. Mass Spin
    if States.MassSpin then
        for _, part in pairs(targets) do
            if not part:FindFirstChild("SpinVelocity") then
                local spin = Instance.new("AngularVelocity", part)
                spin.Name = "SpinVelocity"
                spin.Attachment0 = part:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", part)
                spin.MaxTorque = math.huge
                spin.AngularVelocity = Vector3.new(0, 80, 0)
                table.insert(ActiveSpins, spin)
            end
        end
    else
        for _, spin in pairs(ActiveSpins) do
            if spin then spin:Destroy() end
        end
        ActiveSpins = {}
    end

    -- 3. Black Hole
    if States.BlackHole then
        local targetPos = root.Position + Vector3.new(0, 18, 0)
        for _, part in pairs(targets) do
            local direction = (targetPos - part.Position)
            part.Velocity = direction.Unit * 45
        end
    end

    -- 4. Fling Slingshot
    if States.FlingSlingshot then
        for _, part in pairs(targets) do
            part.Velocity = Vector3.new(
                math.random(-350, 350),
                math.random(250, 550),
                math.random(-350, 350)
            )
        end
    end
end)

-- 5. Break Constraints
local function breakConstraints()
    local targets = getUnanchoredParts()
    for _, part in pairs(targets) do
        for _, joint in pairs(part:GetDescendants()) do
            if joint:IsA("Weld") or joint:IsA("WeldConstraint") or joint:IsA("Snap") or joint:IsA("Motor6D") then
                joint:Destroy()
            end
        end
        if part.Parent then
            for _, joint in pairs(part.Parent:GetChildren()) do
                if joint:IsA("Constraint") or joint:IsA("WeldConstraint") or joint:IsA("Weld") then
                    joint:Destroy()
                end
            end
        end
    end
end

-- [[ CONSTRUCT COMPONENT: MODUL PERSEGI EMPAT KECIL + BUTTON ON/OFF ]] --
local function createSquareComponent(title, desc, isToggle, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, -6, 0, 48) -- Menyesuaikan lebar kontainer 300x300
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = true
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = ScrollContainer

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(40, 40, 45)
    Stroke.Thickness = 1
    Stroke.Parent = ButtonFrame

    -- Judul Fitur
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 0.4, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0.1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ButtonFrame

    -- Deskripsi Keterangan Fitur
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -55, 0.5, 0)
    DescLabel.Position = UDim2.new(0, 8, 0.45, 0)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(135, 135, 140)
    DescLabel.Font = Enum.Font.SourceSansItalic
    DescLabel.TextSize = 9.5
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.Parent = ButtonFrame

    -- Desain Kotak Indikator Tombol ON/OFF (Persegi Empat Tajam)
    local Indicator = Instance.new("TextLabel")
    local IndicatorStroke = Instance.new("UIStroke")
    Indicator.Size = UDim2.new(0, 36, 0, 20)
    Indicator.Position = UDim2.new(1, -44, 0.5, -10)
    Indicator.BorderSizePixel = 0
    Indicator.Font = Enum.Font.SourceSansBold
    Indicator.TextSize = 9.5
    Indicator.Parent = ButtonFrame

    if isToggle then
        Indicator.BackgroundColor3 = Color3.fromRGB(38, 38, 43)
        Indicator.Text = "OFF"
        Indicator.TextColor3 = Color3.fromRGB(150, 150, 150)
        IndicatorStroke.Color = Color3.fromRGB(55, 55, 60)
    else
        Indicator.BackgroundColor3 = Color3.fromRGB(48, 22, 22)
        Indicator.Text = "RUN"
        Indicator.TextColor3 = Color3.fromRGB(240, 90, 90)
        IndicatorStroke.Color = Color3.fromRGB(90, 35, 35)
    end
    IndicatorStroke.Thickness = 1
    IndicatorStroke.Parent = Indicator

    local toggled = false

    ButtonFrame.MouseButton1Click:Connect(function()
        if isToggle then
            toggled = not toggled
            if toggled then
                Stroke.Color = Color3.fromRGB(0, 180, 255)
                Indicator.BackgroundColor3 = Color3.fromRGB(0, 85, 160)
                Indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
                Indicator.Text = "ON"
                IndicatorStroke.Color = Color3.fromRGB(0, 180, 255)
            else
                Stroke.Color = Color3.fromRGB(40, 40, 45)
                Indicator.BackgroundColor3 = Color3.fromRGB(38, 38, 43)
                Indicator.TextColor3 = Color3.fromRGB(150, 150, 150)
                Indicator.Text = "OFF"
                IndicatorStroke.Color = Color3.fromRGB(55, 55, 60)
            end
            callback(toggled)
        else
            -- Animasi Kedip Instan saat Fitur Run Ditekan
            Indicator.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            Indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(0.12)
            Indicator.BackgroundColor3 = Color3.fromRGB(48, 22, 22)
            Indicator.TextColor3 = Color3.fromRGB(240, 90, 90)
            callback()
        end
    end)
end

-- [[ REGISTRASI FITUR LENGKAP ]] --
local desc1 = "Mengikat objek unanchored terdekat ke tubuh menggunakan tali virtual."
local desc2 = "Menyuntikkan AngularVelocity maksimal membuat objek berputar kencang."
local desc3 = "Menciptakan titik gravitasi melayang tepat 18 stud di atas kepala."
local desc4 = "Memanfaatkan VectorForce melempar part ke arah acak instan."
local desc5 = "Menghapus (Destroy) sambungan las jembatan/mobil secara instan."

createSquareComponent("Mass Drag", desc1, true, function(state) States.MassDrag = state end)
createSquareComponent("Mass Spin", desc2, true, function(state) States.MassSpin = state end)
createSquareComponent("Black Hole", desc3, true, function(state) States.BlackHole = state end)
createSquareComponent("Fling Slingshot", desc4, true, function(state) States.FlingSlingshot = state end)
createSquareComponent("Break Constraints", desc5, false, function() breakConstraints() end)

print("Sharp Square 300x300 Physics Toolkit v5 Berhasil Dimuat!")
