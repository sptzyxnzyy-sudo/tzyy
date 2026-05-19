local a = game:GetService("Players")
local b = a.LocalPlayer
local runService = game:GetService("RunService")

-- Buat ScreenGui (Metode lokal andalanmu)
local c = Instance.new("ScreenGui")
c.Parent = b:WaitForChild("PlayerGui")
c.Name = "KriptosPhysicsGui"
c.ResetOnSpawn = false

-- Frame Utama (Ukuran disesuaikan jadi 310x350 agar muat deskripsi teks)
local d = Instance.new("Frame")
d.Parent = c
d.Size = UDim2.new(0, 310, 0, 350)
d.Position = UDim2.new(0.5, -155, 0.5, -175) -- Auto tengah layar, bisa di-drag
d.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
d.BorderSizePixel = 0
d.Active = true
d.Visible = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = d

-- Fungsi Dragging Pengganti .Draggable (Anti-Crash Mobile)
local dragging, dragInput, dragStart, startPos
d.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = d.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
d.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
runService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        d.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title Label
local e = Instance.new("TextLabel")
e.Parent = d
e.Size = UDim2.new(1, 0, 0, 45)
e.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
e.Text = "KRIPTOS PHYSICAL ENGINE v6.1"
e.TextColor3 = Color3.new(0, 1, 1)
e.Font = Enum.Font.SourceSansBold
e.TextSize = 16

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = e

-- Scrolling Frame
local f = Instance.new("ScrollingFrame")
f.Parent = d
f.Size = UDim2.new(1, -20, 1, -65)
f.Position = UDim2.new(0, 10, 0, 55)
f.CanvasSize = UDim2.new(0, 0, 0, 0)
f.ScrollBarThickness = 5
f.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
f.BorderSizePixel = 0

-- Data Fitur & Deskripsi Persis Sebelumnya
local activeStates = {
    ["Mass Drag"] = false,
    ["Mass Spin"] = false,
    ["Black Hole"] = false,
    ["Fling Slingshot"] = false,
    ["Break Constraints"] = false
}

local featureDescriptions = {
    ["Mass Drag"] = "Menarik part unanchored di dekat radius Anda menggunakan tali elastis (Rope). Jalankan karakter untuk menyeret objek map.",
    ["Mass Spin"] = "Menyuntikkan gaya putar AngularVelocity konstan pada objek map di dekat Anda hingga berputar kencang.",
    ["Black Hole"] = "Menciptakan titik gravitasi hampa tepat di atas kepala Anda. Objek unanchored di sekitar akan terangkat melayang.",
    ["Fling Slingshot"] = "Melontarkan paksa seluruh properti map terdekat menggunakan impuls VectorForce acak berdaya hancur tinggi.",
    ["Break Constraints"] = "Memotong las mekanis bawaan objek map (Weld/Snap/Motor6D) dalam jangkauan Anda agar model rontok."
}

local storedObjects = {}

local function clearFisika()
    for _, obj in pairs(storedObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    storedObjects = {}
end

-- Generator List Tombol + Deskripsi Otomatis (Gaya clean custom script)
local featureList = {"Mass Drag", "Mass Spin", "Black Hole", "Fling Slingshot", "Break Constraints"}
local h = 5

for i, featureName in ipairs(featureList) do
    -- Container per item agar rapi
    local itemFrame = Instance.new("Frame")
    itemFrame.Parent = f
    itemFrame.Size = UDim2.new(1, -6, 0, 90)
    itemFrame.Position = UDim2.new(0, 3, 0, h)
    itemFrame.BackgroundTransparency = 1
    
    -- Tombol Fitur
    local k = Instance.new("TextButton")
    k.Parent = itemFrame
    k.Size = UDim2.new(1, 0, 0, 35)
    k.Text = featureName .. " : [OFF]"
    k.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    k.TextColor3 = Color3.fromRGB(180, 180, 180)
    k.Font = Enum.Font.SourceSansBold
    k.TextSize = 14
    k.BorderSizePixel = 0
    
    local btnBtnCorner = Instance.new("UICorner")
    btnBtnCorner.CornerRadius = UDim.new(0, 6)
    btnBtnCorner.Parent = k
    
    -- Teks Deskripsi di bawah tombol
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = itemFrame
    descLabel.Size = UDim2.new(1, 0, 0, 48)
    descLabel.Position = UDim2.new(0, 0, 0, 40)
    descLabel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    descLabel.Text = featureDescriptions[featureName]
    descLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    descLabel.Font = Enum.Font.SourceSans
    descLabel.TextSize = 11
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local descCorner = Instance.new("UICorner")
    descCorner.CornerRadius = UDim.new(0, 4)
    descCorner.Parent = descLabel
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 5)
    padding.Parent = descLabel
    
    h = h + 98
    
    -- Logika Klik Switch ON/OFF
    k.MouseButton1Click:Connect(function()
        activeStates[featureName] = not activeStates[featureName]
        if activeStates[featureName] then
            k.Text = featureName .. " : [ON]"
            k.BackgroundColor3 = Color3.fromRGB(0, 90, 90)
            k.TextColor3 = Color3.new(0, 1, 1)
            descLabel.TextColor3 = Color3.fromRGB(180, 255, 255)
        else
            k.Text = featureName .. " : [OFF]"
            k.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            k.TextColor3 = Color3.fromRGB(180, 180, 180)
            descLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
            clearFisika()
        end
    end)
end
f.CanvasSize = UDim2.new(0, 0, 0, h)

-- Core Backend Loop Engine Fisika
runService.Stepped:Connect(function()
    local char = b.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    local anyActive = false
    for _, state in pairs(activeStates) do if state then anyActive = true break end end
    
    if not hrp or not anyActive then 
        clearFisika() 
        return 
    end
    
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(char) then
            local dist = (part.Position - hrp.Position).Magnitude
            if dist <= 150 then
                if part.Velocity.Magnitude < 1 then part.Velocity = Vector3.new(0, -0.1, 0) end
                
                -- [1] MASS DRAG
                if activeStates["Mass Drag"] and not part:FindFirstChild("DragAtt") then
                    local a1 = Instance.new("Attachment", part) a1.Name = "DragAtt"
                    local a0 = Instance.new("Attachment", hrp) a0.Name = "PlayerDragAtt"
                    local r = Instance.new("RopeConstraint", part)
                    r.Attachment0 = a0 r.Attachment1 = a1 r.Length = 10 r.Visible = true
                    table.insert(storedObjects, a1) table.insert(storedObjects, a0) table.insert(storedObjects, r)
                end
                
                -- [2] MASS SPIN
                if activeStates["Mass Spin"] and not part:FindFirstChild("SpinVelocity") then
                    local att = Instance.new("Attachment", part) att.Name = "SpinAtt"
                    local av = Instance.new("AngularVelocity", part)
                    av.Name = "SpinVelocity" av.Attachment0 = att av.MaxTorque = math.huge av.AngularVelocity = Vector3.new(0, 80, 0)
                    table.insert(storedObjects, att) table.insert(storedObjects, av)
                end
                
                -- [3] BLACK HOLE
                if activeStates["Black Hole"] then
                    local lv = part:FindFirstChild("BHVelocity")
                    if not lv then
                        local att = Instance.new("Attachment", part) att.Name = "BHAtt"
                        lv = Instance.new("LinearVelocity", part)
                        lv.Name = "BHVelocity" lv.Attachment0 = att lv.MaxForce = math.huge
                        table.insert(storedObjects, att) table.insert(storedObjects, lv)
                    end
                    lv.VectorVelocity = ((hrp.Position + Vector3.new(0, 18, 0)) - part.Position).Unit * 55
                end
                
                -- [4] FLING SLINGSHOT
                if activeStates["Fling Slingshot"] and not part:FindFirstChild("FlingForce") then
                    local att = Instance.new("Attachment", part)
                    local vf = Instance.new("VectorForce", part)
                    vf.Name = "FlingForce" vf.Attachment0 = att
                    vf.Force = Vector3.new(math.random(-85000, 85000), 110000, math.random(-85000, 85000))
                    table.insert(storedObjects, att) table.insert(storedObjects, vf)
                end
                
                -- [5] BREAK CONSTRAINTS
                if activeStates["Break Constraints"] then
                    for _, j in pairs(part:GetChildren()) do
                        if j:IsA("Constraint") or j:IsA("Weld") or j:IsA("WeldConstraint") or j:IsA("Motor6D") then j:Destroy() end
                    end
                end
            end
        end
    end
end)

-- Tombol Bulat Toggle Utama ("PHY") - Letak & gaya persis punyamu
local o = Instance.new("TextButton")
o.Parent = c
o.Size = UDim2.new(0, 50, 0, 50)
o.Position = UDim2.new(0, 10, 0, 10) -- Letak awal di kiri atas dekat frame luar
o.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
o.Text = "PHY"
o.TextColor3 = Color3.new(1, 1, 1)
o.Font = Enum.Font.SourceSansBold
o.TextSize = 16
o.BorderSizePixel = 0
o.Active = true

local p = Instance.new("UICorner")
p.CornerRadius = UDim.new(1, 0)
p.Parent = o

o.MouseButton1Click:Connect(function()
    d.Visible = not d.Visible
end)
