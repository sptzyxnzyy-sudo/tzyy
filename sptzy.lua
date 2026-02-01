-- [[ SPTZYY SS MORPH + TARGET LIST ]] --
-- Logika: Backdoor Payload + UserID Stealer + Auto-Refresh List

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- ==========================================
-- SILENT ANTI-KICK BYPASS
-- ==========================================
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" then return nil end
    return old(self, ...)
end)
setreadonly(mt, true)

-- ==========================================
-- UI SETUP (Satu GUI Rapi)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Sptzyy_Morph_Hub"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "SS MORPH EXPLORER"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

local SubTitle = Instance.new("TextLabel", MainFrame)
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 50)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "PILIH TARGET UNTUK COPY AVATAR"
SubTitle.TextColor3 = Color3.new(0.6, 0.6, 0.6)
SubTitle.Font = Enum.Font.SourceSansItalic
SubTitle.TextSize = 12

-- Scrolling Player List
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(0.9, 0, 0.65, 0)
ScrollFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 5)

-- Console Log Mini
local LogLabel = Instance.new("TextLabel", MainFrame)
LogLabel.Size = UDim2.new(0.9, 0, 0, 30)
LogLabel.Position = UDim2.new(0.05, 0, 0.88, 0)
LogLabel.BackgroundColor3 = Color3.new(0, 0, 0)
LogLabel.Text = "Status: Idle"
LogLabel.TextColor3 = Color3.new(1, 1, 1)
LogLabel.TextSize = 10
Instance.new("UICorner", LogLabel)

-- ==========================================
-- LOGIKA MORPH SERVER-SIDE (REAL)
-- ==========================================
local function MorphToPlayer(target)
    LogLabel.Text = "Mencoba SS Morph ke: " .. target.Name
    LogLabel.TextColor3 = Color3.new(1, 1, 0)
    
    local targetId = target.UserId
    local found = false

    -- Mencari Backdoor Remote yang bisa dieksekusi
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            pcall(function()
                -- Payload 1: Mengubah ID Penampilan di Server
                v:FireServer("game.Players['"..lp.Name.."'].CharacterAppearanceId = "..targetId)
                -- Payload 2: Memaksa Respawn agar Avatar Berubah Secara Nyata
                v:FireServer("game.Players['"..lp.Name.."']:LoadCharacter()")
                found = true
            end)
        end
    end

    if found then
        LogLabel.Text = "Sukses! Avatar Terganti (Server-Side)"
        LogLabel.TextColor3 = Color3.new(0, 1, 0)
    else
        LogLabel.Text = "Gagal: Game tidak memiliki Backdoor."
        LogLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end

-- ==========================================
-- UPDATE LIST PLAYER OTOMATIS
-- ==========================================
local function RefreshList()
    for _, c in pairs(ScrollFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local b = Instance.new("TextButton", ScrollFrame)
            b.Size = UDim2.new(1, 0, 0, 35)
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            b.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
            b.TextColor3 = Color3.new(1, 1, 1)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            Instance.new("UICorner", b)

            b.MouseButton1Click:Connect(function()
                MorphToPlayer(p)
            end)
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 40)
end

-- Event Auto-Update
Players.PlayerAdded:Connect(RefreshList)
Players.PlayerRemoving:Connect(RefreshList)

-- Toggle Menu
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
    if MainFrame.Visible then RefreshList() end
end)
