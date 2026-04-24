--[[ 
    PHYSICS-BASED LED MANIPULATOR (NO REMOTE BYPASS)
    Size: 300x300 Square
    Features: Drag, Scroll, Physics Hijack, Rainbow, Blink
]]

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

-- Cleanup
if coreGui:FindFirstChild("PhysicsLED") then coreGui.PhysicsLED:Destroy() end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = "PhysicsLED"

-- Main Frame
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 300)
main.Position = UDim2.new(0.5, -150, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.Active = true
main.Draggable = true 

-- Aesthetic
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 255)
stroke.Thickness = 2
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "PHYSICS LED OVERRIDE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

-- Scroll Area
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 3, 0) -- Scroll luas
scroll.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local currentLoop = nil

-- FUNGSI INTI: PHYSICS REPLICATION
-- Teknik ini mencoba memperluas radius simulasi agar server "percaya" pada client
local function claimOwnership(part)
    if part:IsA("BasePart") and not part.Anchored then
        -- Mencoba mengambil otoritas fisik objek
        player.SimulationRadius = math.huge
        pcall(function()
            part.CanCollide = part.CanCollide -- Memicu update jaringan
            -- Beberapa executor mendukung ini:
            -- setsimulationradius(math.huge)
        end)
    end
end

local function getTargets()
    local char = player.Character
    if not char then return {} end
    local t = {}
    -- Prioritas aksesoris karena paling mudah direplikasi
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            table.insert(t, v)
        end
    end
    return t
end

local function apply(mode, color)
    if currentLoop then currentLoop:Disconnect() end
    local targets = getTargets()
    
    currentLoop = runService.RenderStepped:Connect(function()
        for _, p in pairs(targets) do
            claimOwnership(p) -- Terus menerus mencoba claim
            p.Material = Enum.Material.Neon
            
            if mode == "Static" then
                p.Color = color
            elseif mode == "Rainbow" then
                p.Color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
            elseif mode == "Blink" then
                p.Transparency = math.sin(tick() * 20) > 0 and 0 or 1
            elseif mode == "Disco" then
                p.Color = Color3.new(math.random(), math.random(), math.random())
            end
        end
    end)
end

-- UI Helpers
local function addBtn(name, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0, 250, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = name
    b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

addBtn("Static: Cyan LED", function() apply("Static", Color3.fromRGB(0, 255, 255)) end)
addBtn("Static: Neon Pink", function() apply("Static", Color3.fromRGB(255, 0, 150)) end)
addBtn("Anim: Rainbow Flow", function() apply("Rainbow") end)
addBtn("Anim: Strobe Blink", function() apply("Blink") end)
addBtn("Anim: Chaos Disco", function() apply("Disco") end)

-- Tombol Reset
local stopBtn = Instance.new("TextButton", main)
stopBtn.Size = UDim2.new(0, 280, 0, 45)
stopBtn.Position = UDim2.new(0, 10, 1, -55)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
stopBtn.Text = "RESET CHARACTER"
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", stopBtn)

stopBtn.MouseButton1Click:Connect(function()
    if currentLoop then currentLoop:Disconnect() currentLoop = nil end
    for _, p in pairs(getTargets()) do
        p.Material = Enum.Material.Plastic
        p.Transparency = 0
    end
end)
