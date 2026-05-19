-- [[ HORIZONTAL MINIMALIST PHYSICS EXECUTOR ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

-- [[ SETUP GUI UTAMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HorizontalPhysics"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Frame Utama (Bentuk Persegi Panjang ke Samping)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 75) -- Lebar ke samping, sangat tipis ke bawah
MainFrame.Position = UDim2.new(0.5, -340, 0.05, 0) -- Default di bagian atas tengah layar
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser bebas ke mana saja
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 180, 255) -- Aksen Cyan Modern
UIStroke.Thickness = 1.2
UIStroke.Parent = MainFrame

-- Kontainer Horizontal untuk Fitur
local RowLayout = Instance.new("ScrollingFrame")
RowLayout.Size = UDim2.new(1, -10, 1, -10)
RowLayout.Position = UDim2.new(0, 5, 0, 5)
RowLayout.BackgroundTransparency = 1
RowLayout.BorderSizePixel = 0
RowLayout.CanvasSize = UDim2.new(0, 850, 0, 0) -- Scroll ke samping jika layar HP terlalu kecil
RowLayout.ScrollBarThickness = 3
RowLayout.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal -- Menyusun ke samping
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = RowLayout

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

    -- 3. Black Hole (18 Studs Above)
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

-- [[ METODE SEEDING TOMBOL DENGAN SUB-TEKS KETERANGAN ]] --
local function createHorizontalComponent(title, desc, isToggle, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(0, 155, 0, 52) -- Ukuran kotak modul fitur yang pas
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = true
    ButtonFrame.Parent = RowLayout

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = ButtonFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 50)
    Stroke.Thickness = 1
    Stroke.Parent = ButtonFrame

    -- Label Nama Fitur
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0.5, 0)
    TitleLabel.Position = UDim2.new(0, 0, 0.1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 13
    TitleLabel.Parent = ButtonFrame

    -- Label Keterangan Fitur (Deskripsi)
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -10, 0.4, 0)
    DescLabel.Position = UDim2.new(0, 5, 0.55, 0)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    DescLabel.Font = Enum.Font.SourceSansItalic
    DescLabel.TextSize = 10
    DescLabel.TextWrapped = true
    DescLabel.Parent = ButtonFrame

    local toggled = false

    ButtonFrame.MouseButton1Click:Connect(function()
        if isToggle then
            toggled = not toggled
            if toggled then
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
                Stroke.Color = Color3.fromRGB(0, 180, 255)
                TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                DescLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            else
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                Stroke.Color = Color3.fromRGB(45, 45, 50)
                TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
                DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            callback(toggled)
        else
            -- Kilasan warna untuk tombol aksi instan (Break Constraints)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(150, 35, 35)
            task.wait(0.12)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            callback()
        end
    end)
end

-- [[ INTEGRASI SEMUA FITUR + KETERANGAN ]] --
createHorizontalComponent("Mass Drag", "Mengikat objek unanchored di sekitar dengan tali virtual.", true, function(state) States.MassDrag = state end)
createHorizontalComponent("Mass Spin", "Membuat objek berputar sangat cepat menggunakan gaya maksimal.", true, function(state) States.MassSpin = state end)
createHorizontalComponent("Black Hole", "Menyedot semua material melayang 18 stud di atas kepala.", true, function(state) States.BlackHole = state end)
createHorizontalComponent("Fling Slingshot", "Melontarkan objek secara acak dengan daya dorong besar.", true, function(state) States.FlingSlingshot = state end)
createHorizontalComponent("Break Constraints", "Menghancurkan las (weld) objek jembatan/mobil instan.", false, function() breakConstraints() end)

print("Horizontal Sleek Physics Toolkit v3 Berhasil Dimuat!")
