-- [[ SPTZYY NEW GEN: CHAT ATTACK & FAKE LAG ]] --
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- [[ STATE ]] --
local chatAttack = false
local fakeLagActive = false

-- [[ 🖥️ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 180) 
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
Title.Text = "SPTZYY ATTACKER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Instance.new("UICorner", Title)

-- [[ ⚙️ FUNCTIONS ]] --

-- 1. Chat Attack (Membisukan Chat Server)
local function ToggleChatAttack()
    chatAttack = not chatAttack
    task.spawn(function()
        while chatAttack do
            -- Target sistem chat lama
            local remote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
            if remote then
                remote:FireServer("‎", "All") 
            end
            -- Target sistem chat baru (TextChatService)
            if TextChatService.TextChannels:FindFirstChild("RBXGeneral") then
                TextChatService.TextChannels.RBXGeneral:SendAsync("‎")
            end
            task.wait(0.05) -- Interval sangat cepat
        end
    end)
    return chatAttack
end

-- 2. Fake Lag (Membuat Replikasi Patah-patah)
local function ToggleFakeLag()
    fakeLagActive = not fakeLagActive
    if fakeLagActive then
        -- Nilai 1 dianggap tinggi untuk simulasi desinkronisasi
        settings().Network.IncomingReplicationLag = 1 
    else
        settings().Network.IncomingReplicationLag = 0
    end
    return fakeLagActive
end

-- [[ 🔘 UI BUTTONS ]] --

local function CreateBtn(text, pos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn)
    return btn
end

local AttackBtn = CreateBtn("CHAT ATTACK: OFF", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(40, 40, 40))
local LagBtn = CreateBtn("FAKE LAG: OFF", UDim2.new(0.05, 0, 0.65, 0), Color3.fromRGB(40, 40, 40))

AttackBtn.MouseButton1Click:Connect(function()
    local s = ToggleChatAttack()
    AttackBtn.Text = s and "CHAT ATTACK: ACTIVE" or "CHAT ATTACK: OFF"
    AttackBtn.BackgroundColor3 = s and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
end)

LagBtn.MouseButton1Click:Connect(function()
    local s = ToggleFakeLag()
    LagBtn.Text = s and "FAKE LAG: ON" or "FAKE LAG: OFF"
    LagBtn.BackgroundColor3 = s and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(40, 40, 40)
end)

-- [[ 🕹️ TOGGLE ICON ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 45, 0, 45)
Icon.Position = UDim2.new(0.02, 0, 0.15, 0)
Icon.Image = "rbxassetid://6031280227"
Icon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Icon.Draggable = true
Icon.Active = true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

Icon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
