-- [[ KRIPTOS PHYSICAL MANIPULATION TOOL v4.6 FIX ]] --
-- Cocok untuk Executor Mobile & PC (Delta, Fluxus, Hydrogen, Wave, dll)
-- FIX: Perbaikan logika loop yang menghapus objek gaya secara tidak sengaja.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Bersihkan UI lama jika ada
if CoreGui:FindFirstChild("KriptosConstraintUI_v4_6") then
    CoreGui.KriptosConstraintUI_v4_6:Destroy()
end

local SGUI = Instance.new("ScreenGui")
SGUI.Name = "KriptosConstraintUI_v4_6"
SGUI.Parent = CoreGui
SGUI.ResetOnSpawn = false

-- [[ UTILITY: FUNGSI SYSTEM DRAGGABLE ]] --
local function makeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ 1. ICON SETTINGS (Ditambahkan teks alternatif jika Gambar Aset Gagal Muat) ]] --
local SettingsIcon = Instance.new("ImageButton")
SettingsIcon.Name = "SettingsIcon"
SettingsIcon.Size = UDim2.new(0, 45, 0, 45)
SettingsIcon.Position = UDim2.new(0, 20, 0, 150)
SettingsIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SettingsIcon.Image = "rbxassetid://7059346373"
SettingsIcon.ImageColor3 = Color3.fromRGB(0, 255, 255)
SettingsIcon.BorderSizePixel = 0
SettingsIcon.Parent = SGUI

local BackupText = Instance.new("TextLabel")
BackupText.Size = UDim2.new(1, 0, 1, 0)
BackupText.BackgroundTransparency = 1
BackupText.Text = "[ K ]"
BackupText.TextColor3 = Color3.fromRGB(0, 255, 255)
BackupText.Font = Enum.Font.SourceSansBold
BackupText.TextSize = 14
BackupText.ZIndex = 0 -- Berada di belakang gambar, muncul jika gambar transparan/gagal muat
BackupText.Parent = SettingsIcon

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 10)
IconCorner.Parent = SettingsIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 1.5
IconStroke.Parent = SettingsIcon

makeDraggable(SettingsIcon)

-- [[ 2. MAIN PANEL GUI ]] --
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 400)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = SGUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 45)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

makeDraggable(MainFrame)

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Text = "PHYSICS & REPLICATION v4.6"
Header.TextColor3 = Color3.fromRGB(0, 255, 255)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 14
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -20, 1, -55)
ScrollContainer.Position = UDim2.new(0, 10, 0, 48)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.Parent = MainFrame

local UILayout = Instance.new("UIListLayout")
UILayout.Parent = ScrollContainer
UILayout.SortOrder = Enum.SortOrder.LayoutOrder
UILayout.Padding = UDim.new(0, 6)

UILayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y + 10)
end)

-- [[ 3. LOGIKA ENGINE FISIKA RE-OPTIMIZED ]] --
local ActiveStates = {
    ["Mass Drag"] = false,
    ["Mass Spin"] = false,
    ["Black Hole"] = false,
    ["Fling Slingshot"] = false,
    ["Break Constraints"] = false
}

local FeatureDescriptions = {
    ["Mass Drag"] = "Menghubungkan seluruh part unanchored di map ke tubuh Anda menggunakan RopeConstraint elastis. Objek akan terseret ke mana pun Anda bergerak.",
    ["Mass Spin"] = "Menyuntikkan daya AngularVelocity ekstrem ke sumbu Y pusat objek map. Membuat objek berputar di tempat seperti baling-baling helikopter.",
    ["Black Hole"] = "Membuat pusaran gravitasi buatan tepat 15 stud di atas kepala Anda. Seluruh objek map valid akan melayang ditarik menuju satu titik.",
    ["Fling Slingshot"] = "Memberikan dorongan impuls daya VectorForce acak yang sangat besar (X, Y, Z). Objek akan terlempar acak menabrak seisi server game.",
    ["Break Constraints"] = "Memindai las mekanis bawaan objek map (Weld, Snap, Motor6D, dll), mengklaim ownership lokal, lalu menghancurkannya agar properti copot terberai."
}

local StoredObjects = {
    ["Mass Drag"] = {},
    ["Mass Spin"] = {},
    ["Black Hole"] = {},
    ["Fling Slingshot"] = {}
}

local function ClearSpecificFisika(featureName)
    if StoredObjects[featureName] then
        for _, item in pairs(StoredObjects[featureName]) do
            if item and item.Parent then item:Destroy() end
        end
        StoredObjects[featureName] = {}
    end
end

local function isAPlayerCharacterPart(part)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and part:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end

-- LOGIKA APLIKASI GAYA FISIK INDEPENDEN (Hanya dieksekusi saat status ON)
local function TerapkanGayaKeObjek(featureName, part, hrp)
    if featureName == "Mass Drag" then
        local att0 = Instance.new("Attachment", hrp)
        local att1 = Instance.new("Attachment", part)
        local rope = Instance.new("RopeConstraint")
        rope.Attachment0 = att0
        rope.Attachment1 = att1
        rope.Length = 12
        rope.Visible = true
        rope.Color = BrickColor.new("Cyan")
        rope.Parent = hrp
        table.insert(StoredObjects["Mass Drag"], att0)
        table.insert(StoredObjects["Mass Drag"], att1)
        table.insert(StoredObjects["Mass Drag"], rope)
        
    elseif featureName == "Mass Spin" then
        local att = Instance.new("Attachment", part)
        local av = Instance.new("AngularVelocity")
        av.Attachment0 = att
        av.MaxTorque = math.huge
        av.AngularVelocity = Vector3.new(0, 75, 0)
        av.Parent = part
        table.insert(StoredObjects["Mass Spin"], att)
        table.insert(StoredObjects["Mass Spin"], av)
        
    elseif featureName == "Black Hole" then
        local att = Instance.new("Attachment", part)
        local lv = Instance.new("LinearVelocity")
        lv.Attachment0 = att
        lv.MaxForce = math.huge
        lv.VectorVelocity = ((hrp.Position + Vector3.new(0, 15, 0)) - part.Position).Unit * 60
        lv.Parent = part
        table.insert(StoredObjects["Black Hole"], att)
        table.insert(StoredObjects["Black Hole"], lv)
        
    elseif featureName == "Fling Slingshot" then
        local att = Instance.new("Attachment", part)
        local vf = Instance.new("VectorForce")
        vf.Attachment0 = att
        vf.Force = Vector3.new(math.random(-80000, 80000), 100000, math.random(-80000, 80000))
        vf.Parent = part
        table.insert(StoredObjects["Fling Slingshot"], att)
        table.insert(StoredObjects["Fling Slingshot"], vf)
        
    elseif featureName == "Break Constraints" then
        local targetJoints = {}
        for _, joint in pairs(part:GetChildren()) do
            if joint:IsA("Constraint") or joint:IsA("Weld") or joint:IsA("ManualWeld") or joint:IsA("WeldConstraint") or joint:IsA("Motor6D") or joint:IsA("Snap") then
                table.insert(targetJoints, joint)
            end
        end
        if #targetJoints > 0 then
            part.Velocity = Vector3.new(0, -0.5, 0) -- Paksa network ownership
            for _, target in pairs(targetJoints) do
                target:Destroy()
            end
        end
    end
end

-- THREAD LOOP UTAMA (FIXED: Tidak menghapus objek yang sedang aktif)
task.spawn(function()
    while true do
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- Cari tahu fitur apa saja yang saat ini berstatus ON
            local activeFeatures = {}
            for fName, state in pairs(ActiveStates) do
                if state then
                    table.insert(activeFeatures, fName)
                    -- Reset instansi lama khusus fitur bertipe looping kontinyu (seperti Black Hole/Drag agar posisinya terupdate)
                    if fName ~= "Break Constraints" then
                        ClearSpecificFisika(fName)
                    end
                end
            end
            
            -- Jika ada minimal satu fitur ON, scan workspace satu kali untuk frame ini
            if #activeFeatures > 0 then
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and not part.Anchored and not isAPlayerCharacterPart(part) then
                        for _, fName in pairs(activeFeatures) do
                            TerapkanGayaKeObjek(fName, part, hrp)
                        end
                    end
                end
            end
        end
        task.wait(0.6) -- Durasi delay dioptimalkan agar tidak lag/crash di perangkat mobile
    end
end)

-- [[ 4. DYNAMIC BUTTON GENERATOR ]] --
local function CreateMenuButton(featureName)
    local ItemGroupFrame = Instance.new("Frame")
    ItemGroupFrame.Size = UDim2.new(1, -6, 0, 95)
    ItemGroupFrame.BackgroundTransparency = 1
    ItemGroupFrame.Parent = ScrollContainer
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    Btn.Text = featureName .. " : [OFF]"
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 14
    Btn.BorderSizePixel = 0
    Btn.Parent = ItemGroupFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(45, 45, 45)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Btn
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, 0, 0, 52)
    DescLabel.Position = UDim2.new(0, 0, 0, 43)
    DescLabel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    DescLabel.Text = FeatureDescriptions[featureName]
    DescLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    DescLabel.Font = Enum.Font.SourceSans
    DescLabel.TextSize = 11
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.Parent = ItemGroupFrame
    
    local DescCorner = Instance.new("UICorner")
    DescCorner.CornerRadius = UDim.new(0, 4)
    DescCorner.Parent = DescLabel
    
    local DescPadding = Instance.new("UIPadding")
    DescPadding.PaddingLeft = UDim.new(0, 8)
    DescPadding.PaddingRight = UDim.new(0, 8)
    DescPadding.PaddingTop = UDim.new(0, 5)
    DescPadding.Parent = DescLabel

    Btn.MouseButton1Click:Connect(function()
        ActiveStates[featureName] = not ActiveStates[featureName]
        
        if ActiveStates[featureName] then
            Btn.Text = featureName .. " : [ON]"
            Btn.BackgroundColor3 = Color3.fromRGB(0, 90, 90)
            Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
            Btn.UIStroke.Color = Color3.fromRGB(0, 255, 255)
            DescLabel.TextColor3 = Color3.fromRGB(180, 255, 255)
        else
            Btn.Text = featureName .. " : [OFF]"
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            Btn.UIStroke.Color = Color3.fromRGB(45, 45, 45)
            DescLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
            
            ClearSpecificFisika(featureName)
        end
    end)
end

-- Membangun Tombol
CreateMenuButton("Mass Drag")
CreateMenuButton("Mass Spin")
CreateMenuButton("Black Hole")
CreateMenuButton("Fling Slingshot")
CreateMenuButton("Break Constraints")

-- [[ 5. KENDALI TOMBOL UTAMA ]] --
SettingsIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
