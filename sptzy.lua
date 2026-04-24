--[[
    OMNI-LED EXECUTOR V2 (FULL FEATURES)
    - Size: 300x300 (Square)
    - Interaction: Drag & Scrollable
    - Material: Neon Glassmorphism
    - Target: Character Accessories (For Server Replication)
]]

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

-- Clean up UI lama agar tidak menumpuk
if coreGui:FindFirstChild("OmniLedFinal") then coreGui.OmniLedFinal:Destroy() end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "OmniLedFinal"

-- FRAME UTAMA (300x300)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 300)
main.Position = UDim2.new(0.5, -150, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true -- Support Geser Luas

-- Styling Visual
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 255) -- Neon Cyan
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Judul GUI
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "LED CONTROL PANEL"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
Instance.new("UICorner", title)

-- SCROLLING FRAME (Luas & Rapi)
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 4, 0) -- Scroll sangat luas
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- LOGIC VARIABLE
local currentLoop = nil

-- Fungsi mencari Part Karakter
local function getTargets()
    local character = player.Character
    if not character then return {} end
    local targets = {}
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            table.insert(targets, v)
        end
    end
    return targets
end

local function stopAll()
    if currentLoop then currentLoop:Disconnect() currentLoop = nil end
    for _, p in pairs(getTargets()) do
        p.Material = Enum.Material.Plastic
        p.Transparency = 0
    end
end

-- Fungsi Apply Efek
local function apply(mode, color)
    stopAll()
    local parts = getTargets()
    
    currentLoop = runService.Heartbeat:Connect(function()
        for _, p in pairs(parts) do
            p.Material = Enum.Material.Neon
            if mode == "Static" then
                p.Color = color
            elseif mode == "Rainbow" then
                p.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            elseif mode == "Blink" then
                p.Transparency = math.sin(tick() * 15) > 0 and 0 or 1
            elseif mode == "Disco" then
                p.Color = Color3.new(math.random(), math.random(), math.random())
            end
        end
    end)
end

-- PEMBUAT TOMBOL LIST
local function createBtn(txt, callback, color)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0, 250, 0, 35)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- ISI LIST FITUR (Bisa ditambah sesukamu)
createBtn("🔵 Cyan LED (Static)", function() apply("Static", Color3.fromRGB(0, 255, 255)) end)
createBtn("🔴 Red LED (Static)", function() apply("Static", Color3.fromRGB(255, 0, 0)) end)
createBtn("🟢 Green LED (Static)", function() apply("Static", Color3.fromRGB(0, 255, 0)) end)
createBtn("🟡 Yellow LED (Static)", function() apply("Static", Color3.fromRGB(255, 255, 0)) end)
createBtn("🟣 Purple LED (Static)", function() apply("Static", Color3.fromRGB(170, 0, 255)) end)
createBtn("🌈 RAINBOW ANIMATION", function() apply("Rainbow") end, Color3.fromRGB(45, 45, 45))
createBtn("⚡ BLINK EFFECT", function() apply("Blink") end, Color3.fromRGB(45, 45, 45))
createBtn("🎲 DISCO RANDOM", function() apply("Disco") end, Color3.fromRGB(45, 45, 45))

-- BUTTON PROSES / STOP (Paling Bawah)
local stopBtn = Instance.new("TextButton", main)
stopBtn.Size = UDim2.new(0, 280, 0, 45)
stopBtn.Position = UDim2.new(0, 10, 1, -55)
stopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
stopBtn.Text = "STOP & RESET"
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
Instance.new("UICorner", stopBtn)

stopBtn.MouseButton1Click:Connect(stopAll)

-- Animasi Masuk (Fade In)
main.GroupTransparency = 1
for i = 1, 0, -0.1 do
    main.BackgroundTransparency = i
    task.wait(0.01)
end
