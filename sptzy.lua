-- [[ SPTZYY ULTIMATE BACKDOOR + ANTI-KICK ]] --

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- ==========================================
-- LOGIKA ANTI-KICK (REAL BYPASS)
-- ==========================================
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Jika game mencoba memanggil fungsi Kick pada pemain
    if tostring(method) == "Kick" or tostring(method) == "kick" then
        print("🛡️ SPTZYY PROTECT: Mencegah Kick dari server!")
        return nil -- Membatalkan perintah kick
    end
    
    return old(self, unpack(args))
end)

setreadonly(mt, true)
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Security_System"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Variabel Global
_G.BruteActive = false
local FoundRemotes = {}

-- ICON SUPPORT
local SupportIcon = Instance.new("ImageButton", ScreenGui)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.Draggable = true
SupportIcon.Active = true
Instance.new("UICorner", SupportIcon).CornerRadius = UDim.new(1, 0)

-- GUI 1: BRUTE CONSOLE (LOADING ANIMATION)
local ConsoleGui = Instance.new("Frame", ScreenGui)
ConsoleGui.Size = UDim2.new(0, 300, 0, 350)
ConsoleGui.Position = UDim2.new(0.3, -150, 0.5, -175)
ConsoleGui.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
ConsoleGui.Visible = false
Instance.new("UICorner", ConsoleGui)

local Title1 = Instance.new("TextLabel", ConsoleGui)
Title1.Size = UDim2.new(1, 0, 0, 40)
Title1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title1.Text = "SECURITY & BRUTE CONSOLE"
Title1.TextColor3 = Color3.fromRGB(0, 255, 150)
Title1.Font = Enum.Font.Code
Instance.new("UICorner", Title1)

local LogScroll = Instance.new("ScrollingFrame", ConsoleGui)
LogScroll.Size = UDim2.new(0.9, 0, 0.7, 0)
LogScroll.Position = UDim2.new(0.05, 0, 0.15, 0)
LogScroll.BackgroundTransparency = 1
LogScroll.CanvasSize = UDim2.new(0, 0, 10, 0)
LogScroll.ScrollBarThickness = 2
local LogList = Instance.new("UIListLayout", LogScroll)

local function AddLog(txt, col)
    local l = Instance.new("TextLabel", LogScroll)
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "> " .. txt
    l.TextColor3 = col or Color3.new(1,1,1)
    l.Font = Enum.Font.Code
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    LogScroll.CanvasPosition = Vector2.new(0, LogScroll.AbsoluteCanvasSize.Y)
end

-- GUI 2: REMOTE FINDER (SCROLL LUAS)
local FinderGui = Instance.new("Frame", ScreenGui)
FinderGui.Size = UDim2.new(0, 250, 0, 350)
FinderGui.Position = UDim2.new(0.7, -125, 0.5, -175)
FinderGui.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FinderGui.Visible = false
Instance.new("UICorner", FinderGui)

local Title2 = Instance.new("TextLabel", FinderGui)
Title2.Size = UDim2.new(1, 0, 0, 40)
Title2.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Title2.Text = "REMOTE EXPLORER"
Title2.TextColor3 = Color3.new(1,1,1)
Title2.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title2)

local FinderScroll = Instance.new("ScrollingFrame", FinderGui)
FinderScroll.Size = UDim2.new(0.9, 0, 0.8, 0)
FinderScroll.Position = UDim2.new(0.05, 0, 0.15, 0)
FinderScroll.BackgroundTransparency = 1
FinderScroll.ScrollBarThickness = 3
Instance.new("UIListLayout", FinderScroll).Padding = UDim.new(0, 5)

-- SCAN & BRUTE LOGIC
local function Scan()
    for _, c in pairs(FinderScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    FoundRemotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(FoundRemotes, v)
            local b = Instance.new("TextButton", FinderScroll)
            b.Size = UDim2.new(1, 0, 0, 30); b.Text = v.Name; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", b)
        end
    end
    FinderScroll.CanvasSize = UDim2.new(0, 0, 0, #FoundRemotes * 35)
    AddLog("🛡️ ANTI-KICK ACTIVE", Color3.fromRGB(0, 255, 0))
    AddLog("Found " .. #FoundRemotes .. " Remotes", Color3.new(1,1,1))
end

-- BUTTONS
local function NewBtn(p, t, pos, col, f)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(0.4, 0, 0, 35); b.Position = pos; b.Text = t; b.BackgroundColor3 = col; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(f)
end

NewBtn(ConsoleGui, "START BRUTE", UDim2.new(0.05, 0, 0.88, 0), Color3.fromRGB(0, 150, 0), function()
    _G.BruteActive = true
    AddLog("LOOP STARTED...", Color3.new(1,1,0))
    task.spawn(function()
        while _G.BruteActive do
            for _, r in pairs(FoundRemotes) do
                if not _G.BruteActive then break end
                AddLog("Testing: " .. r.Name, Color3.fromRGB(150,150,150))
                pcall(function() r:FireServer("sptzyy_payload_v3") end)
                task.wait(0.1)
            end
        end
    end)
end)

NewBtn(ConsoleGui, "STOP", UDim2.new(0.55, 0, 0.88, 0), Color3.fromRGB(150, 0, 0), function() _G.BruteActive = false; AddLog("STOPPED", Color3.new(1,0,0)) end)
NewBtn(FinderGui, "SCAN MAP", UDim2.new(0.1, 0, 0.88, 0), Color3.fromRGB(0, 80, 200), Scan)

SupportIcon.MouseButton1Click:Connect(function()
    ConsoleGui.Visible = not ConsoleGui.Visible
    FinderGui.Visible = ConsoleGui.Visible
    if ConsoleGui.Visible then Scan() end
end)
