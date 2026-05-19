-- [[ KRIPTOS PHYSICAL MANIPULATION TOOL v4.5 PRO ]] --
-- Cocok untuk Executor Mobile & PC (Delta, Fluxus, Hydrogen, Wave, dll)
-- Desain UI Baru: Setiap tombol memiliki kolom keterangan fitur langsung di bawahnya!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Bersihkan UI lama jika sudah pernah dijalankan sebelumnya
if CoreGui:FindFirstChild("KriptosConstraintUI_v4_5") then
    CoreGui.KriptosConstraintUI_v4_5:Destroy()
end

-- ScreenGui Utama (Disimpan di CoreGui agar anti-reset saat karakter mati/respawn)
local SGUI = Instance.new("ScreenGui")
SGUI.Name = "KriptosConstraintUI_v4_5"
SGUI.Parent = CoreGui
SGUI.ResetOnSpawn = false

-- [[ UTILITY: FUNGSI SYSTEM DRAGGABLE (GESER LUAS) ]] --
local function makeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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

-- [[ 1. ICON SETTINGS (Tombol Pemicu Buka/Tutup - Draggable) ]] --
local SettingsIcon = Instance.new("ImageButton")
SettingsIcon.Name = "SettingsIcon"
SettingsIcon.Size = UDim2.new(0, 45, 0, 45)
SettingsIcon.Position = UDim2.new(0, 20, 0, 150)
SettingsIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SettingsIcon.Image = "rbxassetid://7059346373"
SettingsIcon.ImageColor3 = Color3.fromRGB(0, 255, 255)
SettingsIcon.BorderSizePixel = 0
SettingsIcon.Parent = SGUI

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 10)
IconCorner.Parent = SettingsIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 1.5
IconStroke.Parent = SettingsIcon

makeDraggable(SettingsIcon)

-- [[ 2. MAIN PANEL GUI (Bentuk Persegi Empat 310x400 - Tengah Layar) ]] --
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

-- Header Judul Menu Panel
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Text = "PHYSICS & REPLICATION v4.5"
Header.TextColor3 = Color3.fromRGB(0, 255, 255)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 14
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Menggunakan SCROLLING FRAME agar muat banyak tombol + kolom keterangan di layar HP/PC
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -20, 1, -55)
ScrollContainer.Position = UDim2.new(0, 10, 0, 48)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Otomatis membesar berkat UIListLayout
ScrollContainer.Parent = MainFrame

local UILayout = Instance.new("UIListLayout")
UILayout.Parent = ScrollContainer
UILayout.SortOrder = Enum.SortOrder.LayoutOrder
UILayout.Padding = UDim.new(0, 6)

-- Otomatis memperbarui ukuran canvas scroll bar setiap kali ada elemen baru masuk
UILayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y + 10)
end)


-- [[ 3. DATA KETERANGAN FITUR DAN LOGIKA ENGINE INDEPENDEN ]] --
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

-- Penyimpanan instansi objek gaya fisika tiruan
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

local function ClearAllFisika()
    for fName, _ in pairs(StoredObjects) do
        ClearSpecificFisika(fName)
    end
end

-- Filter pelindung agar anggota tubuh pemain di server aman dari modifikasi
local function isAPlayerCharacterPart(part)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and part:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end

-- RUNTIME CALCULATION ENGINE
local function JalankanLogikaFisika()
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for fName, _ in pairs(StoredObjects) do
        ClearSpecificFisika(fName)
    end
    
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not isAPlayerCharacterPart(part) then
            
            -- [FITUR A]: SERET MASAL
            if ActiveStates["Mass Drag"] then
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
            end
                
            -- [FITUR B]: PUTAR MASAL
            if ActiveStates["Mass Spin"] then
                local att = Instance.new("Attachment", part)
                local av = Instance.new("AngularVelocity")
                av.Attachment0 = att
                av.MaxTorque = math.huge
                av.AngularVelocity = Vector3.new(0, 75, 0)
                av.Parent = part
                
                table.insert(StoredObjects["Mass Spin"], att)
                table.insert(StoredObjects["Mass Spin"], av)
            end
                
            -- [FITUR C]: LUBANG HITAM
            if ActiveStates["Black Hole"] then
                local att = Instance.new("Attachment", part)
                local lv = Instance.new("LinearVelocity")
                lv.Attachment0 = att
                lv.MaxForce = math.huge
                lv.VectorVelocity = ((hrp.Position + Vector3.new(0, 15, 0)) - part.Position).Unit * 50
                lv.Parent = part
                
                table.insert(StoredObjects["Black Hole"], att)
                table.insert(StoredObjects["Black Hole"], lv)
            end
                
            -- [FITUR D]: KETAPEL LUAR ANGKASA
            if ActiveStates["Fling Slingshot"] then
                local att = Instance.new("Attachment", part)
                local vf = Instance.new("VectorForce")
                vf.Attachment0 = att
                vf.Force = Vector3.new(math.random(-70000, 70000), 95000, math.random(-70000, 70000))
                vf.Parent = part
                
                table.insert(StoredObjects["Fling Slingshot"], att)
                table.insert(StoredObjects["Fling Slingshot"], vf)
            end

            -- [FITUR E]: BREAK CONSTRAINTS MAP ENVIRONMENT (SINKRON REPLICATED)
            if ActiveStates["Break Constraints"] then
                local targetJoints = {}
                for _, joint in pairs(part:GetChildren()) do
                    if joint:IsA("Constraint") or joint:IsA("Weld") or joint:IsA("ManualWeld") or joint:IsA("WeldConstraint") or joint:IsA("Motor6D") or joint:IsA("Snap") then
                        table.insert(targetJoints, joint)
                    end
                end
                
                if #targetJoints > 0 then
                    part.Velocity = Vector3.new(0, -0.2, 0) -- Pemindahan paksa kepemilikan physics
                    for _, target in pairs(targetJoints) do
                        target:Destroy()
                    end
                end
            end
            
        end
    end
end

-- Thread loop konstan real-time (setiap 0.5 detik)
task.spawn(function()
    while true do
        local isAnyFeatureOn = false
        for _, state in pairs(ActiveStates) do
            if state then isAnyFeatureOn = true break end
        end
        
        if isAnyFeatureOn then
            JalankanLogikaFisika()
        else
            ClearAllFisika()
        end
        task.wait(0.5)
    end
end)


-- [[ 4. DYNAMIC BUTTON GENERATOR WITH DESCRIPTION COLUMN ]] --
local function CreateMenuButton(featureName)
    -- Frame pembungkus per-tombol agar tata letak rapi
    local ItemGroupFrame = Instance.new("Frame")
    ItemGroupFrame.Size = UDim2.new(1, -6, 0, 95) -- Menampung Tombol (38px) + Jarak (5px) + Deskripsi (52px)
    ItemGroupFrame.BackgroundTransparency = 1
    ItemGroupFrame.Parent = ScrollContainer
    
    -- Element Utama: Tombol Fitur
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
    
    -- Element Kedua: Kolom Keterangan di bawah tombol
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, 0, 0, 52)
    DescLabel.Position = UDim2.new(0, 0, 0, 43)
    DescLabel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    DescLabel.Text = FeatureDescriptions[featureName] or "Tidak ada deskripsi yang tersedia untuk fitur ini."
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
    DescPadding.PaddingBottom = UDim.new(0, 5)
    DescPadding.Parent = DescLabel

    -- Event Trigger Klik Switch Independen
    Btn.MouseButton1Click:Connect(function()
        ActiveStates[featureName] = not ActiveStates[featureName]
        
        if ActiveStates[featureName] then
            Btn.Text = featureName .. " : [ON]"
            Btn.BackgroundColor3 = Color3.fromRGB(0, 90, 90)
            Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
            Btn.UIStroke.Color = Color3.fromRGB(0, 255, 255)
            DescLabel.TextColor3 = Color3.fromRGB(180, 255, 255) -- Highlight warna teks keterangan
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

-- Daftarkan pembuatan seluruh tombol beserta kolom keterangannya secara berurutan
CreateMenuButton("Mass Drag")
CreateMenuButton("Mass Spin")
CreateMenuButton("Black Hole")
CreateMenuButton("Fling Slingshot")
CreateMenuButton("Break Constraints")

-- [[ 5. KENDALI TOMBOL OPEN / CLOSE UTAMA ]] --
SettingsIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
