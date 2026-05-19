-- [[ ADVANCED PHYSICS EXECUTOR GUI ]] --
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Pastikan karakter update saat respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

-- [[ MEMBUAT GUI DRAGGABLE & RAPI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhysicsExecutor"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Ukuran Kecil & Compact)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 260) -- Ukuran kecil pas untuk mobile
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Support geser luas di layar
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 180, 255) -- Tema Cyan Modern
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Header Title
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Header.Text = "  PHYSICS TOOLKIT v2"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 14
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

-- Container untuk Tombol Fitur
local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Size = UDim2.new(1, -10, 1, -40)
ButtonContainer.Position = UDim2.new(0, 5, 0, 35)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.BorderSizePixel = 0
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 230) -- Scrollable jika penuh
ButtonContainer.ScrollBarThickness = 2
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonContainer

-- [[ LOGIKA UTAMA & STATE FITUR ]] --
local States = {
    MassDrag = false,
    MassSpin = false,
    BlackHole = false,
    FlingSlingshot = false
}

local Radius = 60 -- Jangkauan deteksi part unanchored
local ActiveRopes = {}
local ActiveSpins = {}

-- Helper Fungsi untuk Scan Part Terdekat
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

-- [[ LOOP UTAMA PHYSICS (RunService) ]] --
RunService.Heartbeat:Connect(function()
    local root = Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local targets = getUnanchoredParts()

    -- 1. Logika Mass Drag
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
                rope.Length = 5
                rope.Visible = true -- Menggambarkan tali virtual
                table.insert(ActiveRopes, {part, rope, attPart})
            end
        end
    else
        -- Bersihkan tali jika dimatikan
        for _, data in pairs(ActiveRopes) do
            if data[2] then data[2]:Destroy() end
            if data[3] then data[3]:Destroy() end
        end
        ActiveRopes = {}
    end

    -- 2. Logika Mass Spin
    if States.MassSpin then
        for _, part in pairs(targets) do
            if not part:FindFirstChild("SpinVelocity") then
                local spin = Instance.new("AngularVelocity", part)
                spin.Name = "SpinVelocity"
                spin.Attachment0 = part:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", part)
                spin.MaxTorque = math.huge
                spin.AngularVelocity = Vector3.new(0, 50, 0) -- Putar kencang di sumbu Y
                table.insert(ActiveSpins, spin)
            end
        end
    else
        for _, spin in pairs(ActiveSpins) do
            if spin then spin:Destroy() end
        end
        ActiveSpins = {}
    end

    -- 3. Logika Black Hole
    if States.BlackHole then
        local targetPos = root.Position + Vector3.new(0, 18, 0) -- 18 Stud di atas kepala
        for _, part in pairs(targets) do
            -- Menggunakan metode pengaturan Velocity langsung agar kompatibel di berbagai executor mobile
            local direction = (targetPos - part.Position)
            part.Velocity = direction.Unit * 40 -- Kecepatan hisap
        end
    end

    -- 4. Logika Fling Slingshot
    if States.FlingSlingshot then
        for _, part in pairs(targets) do
            -- Memberikan gaya sentak acak instan (Velocity Manipulation)
            local randomForce = Vector3.new(
                math.random(-300, 300),
                math.random(200, 500), -- Efek melontar ke atas
                math.random(-300, 300)
            )
            part.Velocity = randomForce
        end
    end
end)

-- 5. Logika Break Constraints (Instant Trigger)
local function breakConstraints()
    local targets = getUnanchoredParts()
    for _, part in pairs(targets) do
        for _, joint in pairs(part:GetDescendants()) do
            if joint:IsA("Weld") or joint:IsA("WeldConstraint") or joint:IsA("Snap") or joint:IsA("Motor6D") then
                joint:Destroy()
            end
        end
        -- Cek juga di parent objeknya untuk merontokkan model
        if part.Parent then
            for _, joint in pairs(part.Parent:GetChildren()) do
                if joint:IsA("Constraint") or joint:IsA("WeldConstraint") or joint:IsA("Weld") then
                    joint:Destroy()
                end
            end
        end
    end
end


-- [[ FUNCTION UNTUK MEMBUAT TOMBOL UI RAPI ]] --
local function createButton(name, isToggle, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -6, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 13
    Button.AutoButtonColor = true
    Button.Parent = ButtonContainer

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Button

    local toggled = false

    Button.MouseButton1Click:Connect(function()
        if isToggle then
            toggled = not toggled
            if toggled then
                Button.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            callback(toggled)
        else
            -- Animasi klik instant untuk non-toggle (Break Constraints)
            Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(0.1)
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            callback()
        end
    end)
end

-- [[ MENDAFTARKAN FITUR KE UI ]] --
createButton("Mass Drag", true, function(state) States.MassDrag = state end)
createButton("Mass Spin", true, function(state) States.MassSpin = state end)
createButton("Black Hole", true, function(state) States.BlackHole = state end)
createButton("Fling Slingshot", true, function(state) States.FlingSlingshot = state end)
createButton("Break Constraints", false, function() breakConstraints() end)

-- Notifikasi sukses saat inject script
print("Physics Toolkit v2 Berhasil Dimuat!")
