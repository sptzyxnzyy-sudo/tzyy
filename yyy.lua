-- [[ SERVER-REPLICATED SHARP SQUARE 300x300 PHYSICS PRO V13 ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")
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
HeaderLabel.Text = "  SERVER REPLICATED PHYSICS V13"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLabel.Font = Enum.Font.SourceSansBold
HeaderLabel.TextSize = 11
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = MainFrame

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(28, 28, 33)
HeaderStroke.Thickness = 1
HeaderStroke.Parent = HeaderLabel

-- --- KONTROL NAVIGASI SUB-PANEL ---
local FeatureFrame = Instance.new("Frame")
FeatureFrame.Size = UDim2.new(1, 0, 1, -30)
FeatureFrame.Position = UDim2.new(0, 0, 0, 30)
FeatureFrame.BackgroundTransparency = 1
FeatureFrame.Parent = MainFrame

-- Kontainer Utama Vertikal (Untuk Fitur Physics)
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -12, 1, -10)
ScrollContainer.Position = UDim2.new(0, 6, 0, 5)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 370)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.Parent = FeatureFrame

-- --- PANEL CONSOLE SPYING (Overlay Rapi Samping/Bawah jika Diaktifkan) ---
local SpyConsoleFrame = Instance.new("Frame")
SpyConsoleFrame.Size = UDim2.new(0, 288, 0, 110)
SpyConsoleFrame.Position = UDim2.new(0, 6, 0, 150) -- Mengambil area bawah saat Spy Aktif
SpyConsoleFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
SpyConsoleFrame.BorderSizePixel = 0
SpyConsoleFrame.Visible = false
SpyConsoleFrame.Parent = FeatureFrame

local SpyStroke = Instance.new("UIStroke")
SpyStroke.Color = Color3.fromRGB(255, 60, 60) -- Warna merah penanda Logger/Spy
SpyStroke.Thickness = 1
SpyStroke.Parent = SpyConsoleFrame

local SpyTitle = Instance.new("TextLabel")
SpyTitle.Size = UDim2.new(1, 0, 0, 18)
SpyTitle.BackgroundColor3 = Color3.fromRGB(15, 10, 10)
SpyTitle.Text = "  REMOTE TRAFFIC LOG (CLIENT -> SERVER)"
SpyTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
SpyTitle.Font = Enum.Font.SourceSansBold
SpyTitle.TextSize = 10
SpyTitle.TextXAlignment = Enum.TextXAlignment.Left
SpyTitle.Parent = SpyConsoleFrame

-- Tombol Clear Log
local ClearLogBtn = Instance.new("TextButton")
ClearLogBtn.Size = UDim2.new(0, 45, 0, 14)
ClearLogBtn.Position = UDim2.new(1, -50, 0, 2)
ClearLogBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
ClearLogBtn.Text = "CLEAR"
ClearLogBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
ClearLogBtn.Font = Enum.Font.SourceSansBold
ClearLogBtn.TextSize = 9
ClearLogBtn.BorderSizePixel = 0
ClearLogBtn.Parent = SpyConsoleFrame

local SpyScroll = Instance.new("ScrollingFrame")
SpyScroll.Size = UDim2.new(1, -6, 1, -22)
SpyScroll.Position = UDim2.new(0, 3, 0, 20)
SpyScroll.BackgroundTransparency = 1
SpyScroll.BorderSizePixel = 0
SpyScroll.CanvasSize = UDim2.new(0, 0, 0, 20)
SpyScroll.ScrollBarThickness = 2
SpyScroll.Parent = SpyConsoleFrame

local SpyList = Instance.new("UIListLayout")
SpyList.Padding = UDim.new(0, 2)
SpyList.SortOrder = Enum.SortOrder.LayoutOrder
SpyList.Parent = SpyScroll

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollContainer

-- [[ VARIABLE & LOGIKA REPLIKASI FISIKA ]] --
local States = {
    MassSpin = false,
    BlackHole = false,
    FlingSlingshot = false,
    BreakTethers = false,
    GlitchMagnet = false,
    QuantumTether = false,
    RemoteSpy = false
}

local Configs = {
    MassSpin_Speed = 150,
    BlackHole_Force = 65,
    Fling_Power = 500,
    Scan_Radius = 150,
    Glitch_Multi = 2000,
    Quantum_Power = 45
}

-- [[ HOOKING LOGIKA REMOTE SPY (PENCEGAT ARGUMEN) ]] --
local function formatTable(tbl, indent)
    indent = indent or 0
    local tabs = string.rep("  ", indent)
    local str = "{\n"
    for k, v in pairs(tbl) do
        local key = type(k) == "string" and string.format("[%q]", k) or "["..tostring(k).."]"
        local val = type(v) == "table" and formatTable(v, indent + 1) or string.format("%q", tostring(v))
        str = str .. tabs .. "  " .. key .. " = " .. val .. ",\n"
    end
    return str .. tabs .. "}"
end

local function addLogToConsole(remoteName, remoteType, args)
    -- Parsing argumen menjadi string terbaca
    local argsStr = ""
    if #args > 0 then
        local cleanArgs = {}
        for i, v in ipairs(args) do
            if type(v) == "table" then
                table.insert(cleanArgs, formatTable(v))
            else
                table.insert(cleanArgs, tostring(v).." ("..type(v)..")")
            end
        end
        argsStr = table.concat(cleanArgs, ", ")
    else
        argsStr = "none"
    end

    local logText = string.format("[%s] %s -> Args: %s", remoteType, remoteName, argsStr)

    -- Buat UI Baris Log Baru
    local LogRow = Instance.new("Frame")
    LogRow.Size = UDim2.new(1, 0, 0, 18)
    LogRow.BackgroundTransparency = 1
    LogRow.Parent = SpyScroll

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -40, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = " " .. logText
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel.Font = Enum.Font.Code
    TextLabel.TextSize = 8.5
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = LogRow

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0, 32, 1, -2)
    CopyBtn.Position = UDim2.new(1, -34, 0, 1)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    CopyBtn.Text = "COPY"
    CopyBtn.TextColor3 = Color3.fromRGB(0, 180, 255)
    CopyBtn.Font = Enum.Font.SourceSansBold
    CopyBtn.TextSize = 8
    CopyBtn.BorderSizePixel = 0
    CopyBtn.Parent = LogRow

    local CopyStroke = Instance.new("UIStroke")
    CopyStroke.Color = Color3.fromRGB(45, 45, 50)
    CopyStroke.Thickness = 1
    CopyStroke.Parent = CopyBtn

    -- Fungsi Copy Clipboard Tergantung Executor (Support setclipboard)
    CopyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(logText)
            CopyBtn.Text = "DONE"
            task.wait(1)
            CopyBtn.Text = "COPY"
        else
            CopyBtn.Text = "FAIL"
        end
    end)

    -- Atur Canvas Otomatis Turun Ke Bawah
    SpyScroll.CanvasSize = UDim2.new(0, 0, 0, SpyList.AbsoluteContentSize.Y + 10)
    SpyScroll.CanvasPosition = Vector2.new(0, SpyList.AbsoluteContentSize.Y)
end

ClearLogBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(SpyScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    SpyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

-- Metamethod Hooking Engine (Hanya berjalan mulus di executor yang mendukung hookmetamethod)
local rawmt = getrawmetatable and getrawmetatable(game)
if rawmt and makewriteable then
    makewriteable(rawmt)
    local oldNamecall = rawmt.__namecall
    
    rawmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if States.RemoteSpy and (method == "FireServer" or method == "InvokeServer") then
            task.spawn(function()
                addLogToConsole(self.Name, method == "FireServer" and "Event" or "Function", args)
            end)
        end
        return oldNamecall(self, ...)
    end)
end

-- [[ METODE REPLIKASI FISIKA ]] --
local function claimNetworkOwnership(part)
    if settings().Physics.AllowSleep then settings().Physics.AllowSleep = false end
    part.RotVelocity = part.RotVelocity + Vector3.new(0, 0.01, 0)
end

local function isAPlayerPart(part)
    for _, player in pairs(Players:GetPlayers()) do
        local pChar = player.Character
        if pChar and part:IsDescendantOf(pChar) then return true end
    end
    if part.Parent and (part.Parent:FindFirstChildOfClass("Humanoid") or (part.Parent.Parent and part.Parent.Parent:FindFirstChildOfClass("Humanoid"))) then return true end
    if part.Parent and (part.Parent:IsA("Accessory") or part.Parent:IsA("Tool") or part.Parent:IsA("Hat")) then return true end
    local name = part.Name:lower()
    if name:find("head") or name:find("torso") or name:find("root") or name:find("arm") or name:find("leg") or name:find("hand") or name:find("foot") or name:find("limb") then return true end
    return false
end

local function getValidParts()
    local parts = {}
    local root = Character:FindFirstChild("HumanoidRootPart")
    if not root then return parts end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and not isAPlayerPart(obj) then
            if (obj.Position - root.Position).Magnitude <= Configs.Scan_Radius then
                table.insert(parts, obj)
            end
        end
    end
    return parts
end

RunService.Heartbeat:Connect(function()
    local root = Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local targets = getValidParts()

    for _, part in pairs(targets) do
        claimNetworkOwnership(part)

        if States.QuantumTether then
            for _, subObj in pairs(part:GetChildren()) do
                if subObj:IsA("Constraint") or subObj:IsA("RopeConstraint") or subObj:IsA("Weld") or subObj:IsA("WeldConstraint") then
                    subObj:Destroy()
                end
            end
            local targetPos = root.Position + Vector3.new(0, 12, 0)
            local direction = (targetPos - part.Position)
            if direction.Magnitude > 1.5 then
                part.Velocity = direction * Configs.Quantum_Power
            else
                part.Velocity = root.Velocity
            end
            part.RotVelocity = Vector3.new(0, 120, 0)
        end

        if States.MassSpin and not States.QuantumTether then
            part.RotVelocity = Vector3.new(0, Configs.MassSpin_Speed, 0)
            part.Velocity = part.Velocity + Vector3.new(math.random(-15, 15), math.random(-10, 10), math.random(-15, 15))
        end

        if States.BlackHole and not States.QuantumTether then
            local targetPos = root.Position + Vector3.new(0, 18, 0)
            local direction = (targetPos - part.Position)
            if direction.Magnitude > 2 then part.Velocity = direction.Unit * Configs.BlackHole_Force else part.Velocity = Vector3.new(0, 0, 0) end
        end

        if States.FlingSlingshot then
            local power = Configs.Fling_Power
            part.Velocity = Vector3.new(math.random(-power, power), math.random(power * 0.8, power * 1.4), math.random(-power, power))
        end

        if States.BreakTethers and not States.QuantumTether then
            for _, subObj in pairs(part:GetChildren()) do
                if subObj:IsA("Constraint") or subObj:IsA("RopeConstraint") or subObj:IsA("Weld") or subObj:IsA("WeldConstraint") then subObj:Destroy() end
            end
        end

        if States.GlitchMagnet then
            local targetPos = root.Position
            local direction = (targetPos - part.Position)
            local multi = Configs.Glitch_Multi
            part.Velocity = direction.Unit * math.random(multi * 0.4, multi) * (math.random(1, 2) == 1 and 1 or -1)
            part.RotVelocity = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
        end
    end
end)

-- [[ GENERATOR KOMPONEN GUI ]] --
local function createSquareComponent(title, desc, defaultVal, configKey, isSpyButton, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, -6, 0, 50)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = ScrollContainer

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 35, 40)
    Stroke.Thickness = 1
    Stroke.Parent = ButtonFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -110, 0.4, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0.1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = isSpyButton and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(240, 240, 240)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ButtonFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -110, 0.5, 0)
    DescLabel.Position = UDim2.new(0, 8, 0.45, 0)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(130, 130, 135)
    DescLabel.Font = Enum.Font.SourceSansItalic
    DescLabel.TextSize = 8.5
    DescLabel.TextWrapped = true
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.Parent = ButtonFrame

    -- Sembunyikan TextBox jika ini adalah tombol Spying murni tanpa konfigurasi nilai numeric
    if defaultVal then
        local InputBox = Instance.new("TextBox")
        InputBox.Size = UDim2.new(0, 42, 0, 20)
        InputBox.Position = UDim2.new(1, -92, 0.5, -10)
        InputBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        InputBox.BorderSizePixel = 0
        InputBox.Text = tostring(defaultVal)
        InputBox.TextColor3 = Color3.fromRGB(0, 180, 255)
        InputBox.Font = Enum.Font.Code
        InputBox.TextSize = 10
        InputBox.ClearTextOnFocus = false
        InputBox.Parent = ButtonFrame

        local InputStroke = Instance.new("UIStroke")
        InputStroke.Color = Color3.fromRGB(45, 45, 50)
        InputStroke.Thickness = 1
        InputStroke.Parent = InputBox

        InputBox.FocusLost:Connect(function()
            local num = tonumber(InputBox.Text)
            if num then Configs[configKey] = num else InputBox.Text = tostring(Configs[configKey]) end
        end)
    end

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 36, 0, 20)
    ToggleButton.Position = UDim2.new(1, -44, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 9
    ToggleButton.Parent = ButtonFrame

    local IndicatorStroke = Instance.new("UIStroke")
    IndicatorStroke.Color = Color3.fromRGB(50, 50, 55)
    IndicatorStroke.Thickness = 1
    IndicatorStroke.Parent = ToggleButton

    local toggled = false
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            Stroke.Color = isSpyButton and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 180, 255)
            ToggleButton.BackgroundColor3 = isSpyButton and Color3.fromRGB(150, 40, 40) or Color3.fromRGB(0, 85, 160)
            ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleButton.Text = "ON"
        else
            Stroke.Color = Color3.fromRGB(35, 35, 40)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            ToggleButton.TextColor3 = Color3.fromRGB(150, 150, 150)
            ToggleButton.Text = "OFF"
        end
        callback(toggled)
    end)
end

-- [[ INTEGRASI LENGKAP ]] --
createSquareComponent("Remote Spying", "Mengintip & menyalin argumen FireServer.", nil, nil, true, function(state) 
    States.RemoteSpy = state 
    SpyConsoleFrame.Visible = state
    -- Sesuaikan tinggi canvas layout utama agar tidak bertabrakan dengan Console Log
    ScrollContainer.Size = state and UDim2.new(1, -12, 0, 140) or UDim2.new(1, -12, 1, -10)
end)

createSquareComponent("Quantum Tether", "Scan -> Break -> Magnet -> Spin di atas kepala.", Configs.Quantum_Power, "Quantum_Power", false, function(state) States.QuantumTether = state end)
createSquareComponent("Mass Spin", "Membuat objek berputar ekstrem & bergoyang.", Configs.MassSpin_Speed, "MassSpin_Speed", false, function(state) States.MassSpin = state end)
createSquareComponent("Black Hole", "Menarik objek berkumpul statis di atas kepala.", Configs.BlackHole_Force, "BlackHole_Force", false, function(state) States.BlackHole = state end)
createSquareComponent("Fling Slingshot", "Melontarkan objek dengan gaya entakan masif.", Configs.Fling_Power, "Fling_Power", false, function(state) States.FlingSlingshot = state end)
createSquareComponent("Break Tethers", "Membatasi jarak radius scan & memutus tali.", Configs.Scan_Radius, "Scan_Radius", false, function(state) States.BreakTethers = state end)
createSquareComponent("Glitch Magnet", "Menarik objek dengan keanehan velocity acak.", Configs.Glitch_Multi, "Glitch_Multi", false, function(state) States.GlitchMagnet = state end)

print("Server-Replicated Physics Toolkit v13 (With Remote Spy) Loaded!")
