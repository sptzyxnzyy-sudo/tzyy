-- [[ KRIPTOS PHYSICAL MANIPULATION TOOL v5.1 FIXED ICON ]] --
-- Cocok untuk Executor Mobile & PC (Delta, Fluxus, Hydrogen, Wave, dll)
-- PERBAIKAN: Ikon Gambar diganti dengan TextButton Simbol "⚙" agar 100% pasti muncul.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Bersihkan UI lama jika ada
if CoreGui:FindFirstChild("KriptosConstraintUI_v5_1") then
    CoreGui.KriptosConstraintUI_v5_1:Destroy()
end

local SGUI = Instance.new("ScreenGui")
SGUI.Name = "KriptosConstraintUI_v5_1"
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

-- [[ 1. FIXED ICON SETTINGS (Menggunakan TextButton Murni Simbol Roda Gigi) ]] --
local SettingsIcon = Instance.new("TextButton")
SettingsIcon.Name = "SettingsIcon"
SettingsIcon.Size = UDim2.new(0, 45, 0, 45)
SettingsIcon.Position = UDim2.new(0, 20, 0, 150) -- Letak tombol di kiri layar (bisa digeser)
SettingsIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SettingsIcon.Text = "⚙" -- Simbol Roda Gigi Universal font bawaan system
SettingsIcon.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan Neon
SettingsIcon.Font = Enum.Font.SourceSansBold
SettingsIcon.TextSize = 28 -- Ukuran tombol dibuat besar dan jelas
SettingsIcon.BorderSizePixel = 0
SettingsIcon.Parent = SGUI

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 10)
IconCorner.Parent = SettingsIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 1.5
IconStroke.Parent = SettingsIcon

makeDraggable(SettingsIcon) -- Ikon pembuka bisa kamu geser bebas di layar

-- [[ 2. MAIN PANEL GUI ]] --
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 400)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Tersembunyi saat awal disuntik
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
Header.Text = "PHYSICS ENGINE BENCH v5.1"
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

-- [[ 3. DATA & LOGIKA ENGINE FISIKA RE RADIUS ]] --
local ActiveStates = {
    ["Mass Drag"] = false,
    ["Mass Spin"] = false,
    ["Black Hole"] = false,
    ["Fling Slingshot"] = false,
    ["Break Constraints"] = false
}

local FeatureDescriptions = {
    ["Mass Drag"] = "Menarik part unanchored di sekitar radius Anda menggunakan tali elastis (Rope). Jalankan karakter untuk menyeret objek map tersebut.",
    ["Mass Spin"] = "Menyuntikkan gaya putar AngularVelocity konstan pada objek map di dekat Anda hingga berputar kencang di tempat.",
    ["Black Hole"] = "Menciptakan titik gravitasi hampa tepat di atas kepala Anda. Objek unanchored di sekitar radius akan terangkat dan melayang.",
    ["Fling Slingshot"] = "Melontarkan paksa seluruh properti map terdekat menggunakan impuls VectorForce acak berdaya hancur tinggi.",
    ["Break Constraints"] = "Memotong las mekanis bawaan objek map (Weld/Snap/Motor6D) dalam jangkauan Anda agar model langsung rontok ke tanah."
}

local StoredObjects = {}

local function ClearAllFisika()
    for _, obj in pairs(StoredObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    StoredObjects = {}
end

local function isAPlayerCharacterPart(part)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and part:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end

-- ENGINE UTAMA RUNTIME STEPPED
RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    local anyFeatureActive = false
    for _, state in pairs(ActiveStates) do
        if state then anyFeatureActive = true break end
    end
    
    if not hrp or not anyFeatureActive then
        ClearAllFisika()
        return
    end
    
    local scanRadius = 150
    local targetParts = {}
    
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not isAPlayerCharacterPart(part) then
            local distance = (part.Position - hrp.Position).Magnitude
            if distance <= scanRadius then
                table.insert(targetParts, part)
            end
        end
    end
    
    for _, part in pairs(targetParts) do
        -- Pengambilalihan hak fisik
        if part.Velocity.Magnitude < 1 then
            part.Velocity = Vector3.new(0, -0.1, 0)
        end
        
        -- [A] MASS DRAG
        if ActiveStates["Mass Drag"] then
            if not part:FindFirstChild("DragAtt") then
                local att1 = Instance.new("Attachment")
                att1.Name = "DragAtt"
                att1.Parent = part
                
                local att0 = Instance.new("Attachment")
                att0.Name = "PlayerDragAtt"
                att0.Parent = hrp
                
                local rope = Instance.new("RopeConstraint")
                rope.Name = "DragRope"
                rope.Attachment0 = att0
                rope.Attachment1 = att1
                rope.Length = 10
                rope.Visible = true
                rope.Color = BrickColor.new("Cyan")
                rope.Parent = part
                
                table.insert(StoredObjects, att1)
                table.insert(StoredObjects, att0)
                table.insert(StoredObjects, rope)
            end
        end
        
        -- [B] MASS SPIN
        if ActiveStates["Mass Spin"] then
            if not part:FindFirstChild("SpinVelocity") then
                local att = Instance.new("Attachment")
                att.Name = "SpinAtt"
                att.Parent = part
                
                local av = Instance.new("AngularVelocity")
                av.Name = "SpinVelocity"
                av.Attachment0 = att
                av.MaxTorque = math.huge
                av.AngularVelocity = Vector3.new(0, 80, 0)
                av.Parent = part
                
                table.insert(StoredObjects, att)
                table.insert(StoredObjects, av)
            end
        end
        
        -- [C] BLACK HOLE
        if ActiveStates["Black Hole"] then
            local lv = part:FindFirstChild("BlackHoleVelocity")
            local att = part:FindFirstChild("BlackHoleAtt")
            
            if not lv then
                att = Instance.new("Attachment")
                att.Name = "BlackHoleAtt"
                att.Parent = part
                
                lv = Instance.new("LinearVelocity")
                lv.Name = "BlackHoleVelocity"
                lv.Attachment0 = att
                lv.MaxForce = math.huge
                lv.Parent = part
                
                table.insert(StoredObjects, att)
                table.insert(StoredObjects, lv)
            end
            local targetPos = hrp.Position + Vector3.new(0, 18, 0)
            lv.VectorVelocity = (targetPos - part.Position).Unit * 55
        end
        
        -- [D] FLING SLINGSHOT
        if ActiveStates["Fling Slingshot"] then
            if not part:FindFirstChild("FlingForce") then
                local att = Instance.new("Attachment")
                att.Name = "FlingAtt"
                att.Parent = part
                
                local vf = Instance.new("VectorForce")
                vf.Name = "FlingForce"
                vf.Attachment0 = att
                vf.Force = Vector3.new(math.random(-85000, 85000), 110000, math.random(-85000, 85000))
                vf.Parent = part
                
                table.insert(StoredObjects, att)
                table.insert(StoredObjects, vf)
            end
        end
        
        -- [E] BREAK CONSTRAINTS
        if ActiveStates["Break Constraints"] then
            for _, joint in pairs(part:GetChildren()) do
                if joint:IsA("Constraint") or joint:IsA("Weld") or joint:IsA("ManualWeld") or joint:IsA("WeldConstraint") or joint:IsA("Motor6D") or joint:IsA("Snap") then
                    joint:Destroy()
                end
            end
        end
    end
end)

-- [[ 4. DYNAMIC BUTTON GENERATOR WITH LAYOUT ]] --
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
            ClearAllFisika()
        end
    end)
end

-- Bangun Struktur Daftar Tombol Menu Utama
CreateMenuButton("Mass Drag")
CreateMenuButton("Mass Spin")
CreateMenuButton("Black Hole")
CreateMenuButton("Fling Slingshot")
CreateMenuButton("Break Constraints")

-- [[ 5. KENDALI OPEN/CLOSE PANEL UTAMA ]] --
SettingsIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
