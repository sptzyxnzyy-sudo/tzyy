-- [[ SERVER-REPLICATED SHARP SQUARE 300x300 PHYSICS PRO V13 - VOICE EDITION ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

-- Fungsi untuk mendapatkan Core Gui / UI Parent Executor dengan aman
local function getUIParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then return game:GetService("CoreGui") end
    return game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
end

-- Hapus GUI lama jika ada agar tidak menumpuk saat di-execute ulang
local oldGui = getUIParent():FindFirstChild("ServerPhysicsGUI")
if oldGui then oldGui:Destroy() end

-- [[ SETUP GUI UTAMA ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ServerPhysicsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = getUIParent()

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

-- Kontainer Utama Vertikal
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -12, 1, -10)
ScrollContainer.Position = UDim2.new(0, 6, 0, 5)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 560)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.Parent = FeatureFrame

-- --- PANEL CONSOLE SPYING ---
local SpyConsoleFrame = Instance.new("Frame")
SpyConsoleFrame.Size = UDim2.new(0, 288, 0, 110)
SpyConsoleFrame.Position = UDim2.new(0, 6, 0, 150)
SpyConsoleFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
SpyConsoleFrame.BorderSizePixel = 0
SpyConsoleFrame.Visible = false
SpyConsoleFrame.Parent = FeatureFrame

local SpyStroke = Instance.new("UIStroke")
SpyStroke.Color = Color3.fromRGB(255, 60, 60)
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


-- ==========================================
-- INTEGRASI: PANEL KHUSUS VOICE SETTINGS
-- ==========================================
local VoicePanel = Instance.new("Frame")
VoicePanel.Name = "VoiceSettingsPanel"
VoicePanel.Size = UDim2.new(1, -6, 0, 185)
VoicePanel.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
VoicePanel.BorderSizePixel = 0
VoicePanel.LayoutOrder = 1
VoicePanel.Parent = ScrollContainer

local VoicePanelStroke = Instance.new("UIStroke")
VoicePanelStroke.Color = Color3.fromRGB(0, 150, 255)
VoicePanelStroke.Thickness = 1
VoicePanelStroke.Parent = VoicePanel

local VoicePadding = Instance.new("UIPadding")
VoicePadding.PaddingTop = UDim.new(0, 6)
VoicePadding.PaddingBottom = UDim.new(0, 6)
VoicePadding.PaddingLeft = UDim.new(0, 10)
VoicePadding.PaddingRight = UDim.new(0, 10)
VoicePadding.Parent = VoicePanel

local VoiceLayout = Instance.new("UIListLayout")
VoiceLayout.SortOrder = Enum.SortOrder.LayoutOrder
VoiceLayout.Padding = UDim.new(0, 4)
VoiceLayout.Parent = VoicePanel

local function createVoiceLabel(text, order, styleType)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.LayoutOrder = order
    label.Parent = VoicePanel
    
    if styleType == "Title" then
        label.Size = UDim2.new(1, 0, 0, 14)
        label.TextColor3 = Color3.fromRGB(0, 180, 255)
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Font = Enum.Font.SourceSansBold
    elseif styleType == "Copyright" then
        label.Size = UDim2.new(1, 0, 0, 10)
        label.TextColor3 = Color3.fromRGB(100, 100, 105)
        label.TextSize = 8
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Font = Enum.Font.SourceSansItalic
    else
        label.Size = UDim2.new(1, 0, 0, 11)
        label.TextColor3 = Color3.fromRGB(170, 170, 175)
        label.TextSize = 9
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.SourceSansBold
    end
    return label
end

local function createVoiceInput(placeholder, order)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 20)
    box.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderColor3 = Color3.fromRGB(90, 90, 95)
    box.TextSize = 10
    box.Font = Enum.Font.Code
    box.LayoutOrder = order
    box.ClearTextOnFocus = false
    box.Parent = VoicePanel
    
    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(40, 40, 45)
    bStroke.Thickness = 1
    bStroke.Parent = box
    return box
end

createVoiceLabel("VOICE SETTINGS", 1, "Title")
createVoiceLabel("Copyright by sptzyy", 2, "Copyright")
createVoiceLabel("API KEY:", 3, "Normal")
local InputAPI = createVoiceInput("Masukkan Open Cloud Key...", 4)
createVoiceLabel("UNIVERSE ID:", 5, "Normal")
local InputUniverse = createVoiceInput("Masukkan Universe ID...", 6)

-- --- CONTAINER SWITCH ROW UNTUK MICROPHONE ---
local VoiceRowFrame = Instance.new("Frame")
VoiceRowFrame.Size = UDim2.new(1, 0, 0, 22)
VoiceRowFrame.BackgroundTransparency = 1
VoiceRowFrame.LayoutOrder = 7
VoiceRowFrame.Parent = VoicePanel

local VoiceRowLabel = Instance.new("TextLabel")
VoiceRowLabel.Size = UDim2.new(1, -44, 1, 0)
VoiceRowLabel.BackgroundTransparency = 1
VoiceRowLabel.Text = "ENABLE MICROPHONE:"
VoiceRowLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
VoiceRowLabel.Font = Enum.Font.SourceSansBold
VoiceRowLabel.TextSize = 10
VoiceRowLabel.TextXAlignment = Enum.TextXAlignment.Left
VoiceRowLabel.Parent = VoiceRowFrame

local ActionButton = Instance.new("TextButton")
ActionButton.Size = UDim2.new(0, 36, 0, 20)
ActionButton.Position = UDim2.new(1, -36, 0.5, -10)
ActionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ActionButton.BorderSizePixel = 0
ActionButton.Text = "OFF"
ActionButton.TextColor3 = Color3.fromRGB(150, 150, 150)
ActionButton.Font = Enum.Font.SourceSansBold
ActionButton.TextSize = 9
ActionButton.Parent = VoiceRowFrame

local ActionStroke = Instance.new("UIStroke")
ActionStroke.Color = Color3.fromRGB(50, 50, 55)
ActionStroke.Thickness = 1
ActionStroke.Parent = ActionButton

local ConsoleLog = Instance.new("TextLabel")
ConsoleLog.Size = UDim2.new(1, 0, 0, 26)
ConsoleLog.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
ConsoleLog.Text = "Status: Menunggu input..."
ConsoleLog.TextColor3 = Color3.fromRGB(0, 255, 150)
ConsoleLog.TextSize = 9
ConsoleLog.Font = Enum.Font.Code
ConsoleLog.TextWrapped = true
ConsoleLog.LayoutOrder = 8
ConsoleLog.Parent = VoicePanel

local ConsoleLogStroke = Instance.new("UIStroke")
ConsoleLogStroke.Color = Color3.fromRGB(25, 25, 30)
ConsoleLogStroke.Thickness = 1
ConsoleLogStroke.Parent = ConsoleLog


-- ==========================================
-- VARIABLE & LOGIKA REPLIKASI FISIKA
-- ==========================================
local States = {
    MassSpin = false,
    BlackHole = false,
    FlingSlingshot = false,
    BreakTethers = false,
    GlitchMagnet = false,
    QuantumTether = false,
    RemoteSpy = false,
    VoiceActive = false
}

local Configs = {
    MassSpin_Speed = 150,
    BlackHole_Force = 65,
    Fling_Power = 500,
    Scan_Radius = 150,
    Glitch_Multi = 2000,
    Quantum_Power = 45
}

-- [[ LOGIKA SAKLAR SWITCH ON/OFF MICROPHONE ]] --
ActionButton.MouseButton1Click:Connect(function()
    local apiKey = string.gsub(InputAPI.Text, "%s+", "") 
    local universeId = string.gsub(InputUniverse.Text, "%s+", "")
    local requestFunc = request or http_request or (syn and syn.request)
    
    if apiKey == "" or universeId == "" then
        ConsoleLog.Text = "Status: Gagal! Input kosong."
        ConsoleLog.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    if not requestFunc then
        ConsoleLog.Text = "Status: Executor tidak support Http Request!"
        ConsoleLog.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    local targetState = not States.VoiceActive
    ConsoleLog.Text = targetState and "Status: Mengaktifkan Mic..." or "Status: Mematikan Mic..."
    ConsoleLog.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    task.spawn(function()
        local success, response = pcall(function()
            return requestFunc({
                Url = "https://apis.roblox.com/universes/v1/universes/" .. universeId .. "?updateMask=voiceChatSettings",
                Method = "PATCH",
                Headers = {
                    ["x-api-key"] = apiKey,
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    voiceChatSettings = {
                        isVoiceChatEnabled = targetState -- Parameter payload Roblox untuk merubah status mic game
                    }
                })
            })
        end)
        
        if success and response then
            local statusCode = response.StatusCode or 0
            local bodyText = response.Body or "No response body string"
            
            if statusCode == 200 or statusCode == 201 then
                States.VoiceActive = targetState
                
                -- Perubahan visual switch setelah server mengonfirmasi sukses
                if States.VoiceActive then
                    ActionButton.BackgroundColor3 = Color3.fromRGB(0, 85, 160)
                    ActionStroke.Color = Color3.fromRGB(0, 180, 255)
                    ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ActionButton.Text = "ON"
                    ConsoleLog.Text = "Status: Sukses! Microphone Game AKTIF."
                    ConsoleLog.TextColor3 = Color3.fromRGB(0, 255, 150)
                else
                    ActionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                    ActionStroke.Color = Color3.fromRGB(50, 50, 55)
                    ActionButton.TextColor3 = Color3.fromRGB(150, 150, 150)
                    ActionButton.Text = "OFF"
                    ConsoleLog.Text = "Status: Sukses! Microphone Game NONAKTIF."
                    ConsoleLog.TextColor3 = Color3.fromRGB(150, 150, 150)
                end
            else
                ConsoleLog.Text = "Err (" .. tostring(statusCode) .. "): Periksa kembali Universe ID game!"
                ConsoleLog.TextColor3 = Color3.fromRGB(255, 80, 80)
                warn("Roblox Open Cloud Debug:", bodyText)
            end
        else
            ConsoleLog.Text = "Status: Gagal melakukan request jaringan."
            ConsoleLog.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end)
end)

-- [[ HOOKING LOGIKA REMOTE SPY ]] --
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
    local argsStr = ""
    if #args > 0 then
        local cleanArgs = {}
        for i, v in ipairs(args) do
            if type(v) == "table" then table.insert(cleanArgs, formatTable(v)) else table.insert(cleanArgs, tostring(v).." ("..type(v)..")") end
        end
        argsStr = table.concat(cleanArgs, ", ")
    else
        argsStr = "none"
    end

    local logText = string.format("[%s] %s -> Args: %s", remoteType, remoteName, argsStr)
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

    SpyScroll.CanvasSize = UDim2.new(0, 0, 0, SpyList.AbsoluteContentSize.Y + 10)
    SpyScroll.CanvasPosition = Vector2.new(0, SpyList.AbsoluteContentSize.Y)
end

ClearLogBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(SpyScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    SpyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

local rawmt = getrawmetatable and getrawmetatable(game)
if rawmt and makewriteable then
    makewriteable(rawmt)
    local oldNamecall = rawmt.__namecall
    rawmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if States.RemoteSpy and (method == "FireServer" or method == "InvokeServer") then
            task.spawn(function() addLogToConsole(self.Name, method == "FireServer" and "Event" or "Function", args) end)
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
            if (obj.Position - root.Position).Magnitude <= Configs.Scan_Radius then table.insert(parts, obj) end
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
                if subObj:IsA("Constraint") or subObj:IsA("RopeConstraint") or subObj:IsA("Weld") or subObj:IsA("WeldConstraint") then subObj:Destroy() end
            end
            local targetPos = root.Position + Vector3.new(0, 12, 0)
            local direction = (targetPos - part.Position)
            if direction.Magnitude > 1.5 then part.Velocity = direction * Configs.Quantum_Power else part.Velocity = root.Velocity end
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
local function createSquareComponent(title, desc, defaultVal, configKey, isSpyButton, layoutOrder, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, -6, 0, 50)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.LayoutOrder = layoutOrder
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

-- [[ LOAD SEMUA FITUR MENU BERURUTAN ]] --
createSquareComponent("Remote Spying", "Mengintip & menyalin argumen FireServer.", nil, nil, true, 2, function(state) 
    States.RemoteSpy = state 
    SpyConsoleFrame.Visible = state
    ScrollContainer.Size = state and UDim2.new(1, -12, 0, 140) or UDim2.new(1, -12, 1, -10)
end)

createSquareComponent("Quantum Tether", "Scan -> Break -> Magnet -> Spin di atas kepala.", Configs.Quantum_Power, "Quantum_Power", false, 3, function(state) States.QuantumTether = state end)
createSquareComponent("Mass Spin", "Membuat objek berputar ekstrem & bergoyang.", Configs.MassSpin_Speed, "MassSpin_Speed", false, 4, function(state) States.MassSpin = state end)
createSquareComponent("Black Hole", "Menarik objek berkumpul statis di atas kepala.", Configs.BlackHole_Force, "BlackHole_Force", false, 5, function(state) States.BlackHole = state end)
createSquareComponent("Fling Slingshot", "Melontarkan objek dengan gaya entakan masif.", Configs.Fling_Power, "Fling_Power", false, 6, function(state) States.FlingSlingshot = state end)
createSquareComponent("Break Tethers", "Membatasi jarak radius scan & memutus tali.", Configs.Scan_Radius, "Scan_Radius", false, 7, function(state) States.BreakTethers = state end)
createSquareComponent("Glitch Magnet", "Menarik objek dengan keanehan velocity acak.", Configs.Glitch_Multi, "Glitch_Multi", false, 8, function(state) States.GlitchMagnet = state end)

print("Server-Replicated Physics Toolkit v13 (Protected Crash Nil String) Loaded!")
