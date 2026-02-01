-- [[ ULTIMATE TP & BRING ASSETS - SPTZYY PREM ]] --
-- Fitur: Auto-Refresh List, Unanchor All, Bring Assets, Smooth Toggle

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Final_System"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Variabel State
_G.BringAssets = false
_G.UnanchoredAll = false

-- UI Setup (Icon Support)
local SupportIcon = Instance.new("ImageButton", ScreenGui)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.Draggable = true
SupportIcon.Active = true
Instance.new("UICorner", SupportIcon).CornerRadius = UDim.new(1, 0)

-- Main Frame
local MainGui = Instance.new("Frame", ScreenGui)
MainGui.Size = UDim2.new(0, 300, 0, 420)
MainGui.Position = UDim2.new(0.5, -150, 0.5, -210)
MainGui.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainGui.Visible = false
Instance.new("UICorner", MainGui)

local Title = Instance.new("TextLabel", MainGui)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
Title.Text = "FORCE TP - SPTZYY"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title)

-- Container Toggle
local ToggleContainer = Instance.new("Frame", MainGui)
ToggleContainer.Size = UDim2.new(1, 0, 0, 100)
ToggleContainer.Position = UDim2.new(0, 0, 0, 60)
ToggleContainer.BackgroundTransparency = 1

-- Player List Scroll
local ScrollFrame = Instance.new("ScrollingFrame", MainGui)
ScrollFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
ScrollFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
ScrollFrame.BackgroundTransparency = 0.95
ScrollFrame.BackgroundColor3 = Color3.new(1,1,1)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Fungsi Switch Toggle Rapi
local function CreateToggle(name, pos, callback)
    local tFrame = Instance.new("Frame", ToggleContainer)
    tFrame.Size = UDim2.new(0.9, 0, 0, 40)
    tFrame.Position = pos
    tFrame.BackgroundTransparency = 1
    
    local tLabel = Instance.new("TextLabel", tFrame)
    tLabel.Size = UDim2.new(0.7, 0, 1, 0)
    tLabel.Text = name
    tLabel.TextColor3 = Color3.new(1,1,1)
    tLabel.Font = Enum.Font.Gotham
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1

    local tBtn = Instance.new("TextButton", tFrame)
    tBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
    tBtn.Position = UDim2.new(0.7, 0, 0.15, 0)
    tBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    tBtn.Text = "OFF"
    tBtn.TextColor3 = Color3.new(1,1,1)
    tBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", tBtn)

    local active = false
    tBtn.MouseButton1Click:Connect(function()
        active = not active
        tBtn.Text = active and "ON" or "OFF"
        tBtn.BackgroundColor3 = active and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        callback(active)
    end)
end

-- AKTIVASI FITUR
CreateToggle("UNANCHOR SEMUA MAP", UDim2.new(0.05, 0, 0, 0), function(state)
    _G.UnanchoredAll = state
    if state then
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(lp.Character) then
                v.Anchored = false
            end
        end
    end
end)

CreateToggle("BAWA BENDA SEKITAR", UDim2.new(0.05, 0, 0.45, 0), function(state)
    _G.BringAssets = state
end)

-- LOGIKA TP NYATA + BRING
local function TeleportTo(targetPlayer)
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local tRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if root and tRoot then
        if _G.BringAssets then
            for _, part in pairs(game.Workspace:GetDescendants()) do
                if part:IsA("BasePart") and not part.Anchored and (part.Position - root.Position).Magnitude < 60 then
                    -- Alur membawa part: pindahkan ke depan karakter sebelum teleport
                    part.CFrame = root.CFrame * CFrame.new(0, -3, -2)
                    part.Velocity = Vector3.new(0,0,0)
                end
            end
            task.wait(0.1) -- Jeda sebentar agar engine mencatat perpindahan part
        end
        root.CFrame = tRoot.CFrame * CFrame.new(0, 5, 2)
    end
end

-- LOGIKA AUTO-REFRESH PLAYER LIST
local function UpdateList()
    for _, c in pairs(ScrollFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local b = Instance.new("TextButton", ScrollFrame)
            b.Size = UDim2.new(0.95, 0, 0, 35)
            b.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            b.TextColor3 = Color3.new(1,1,1)
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() TeleportTo(p) end)
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 40)
end

-- Connect Auto-Refresh
Players.PlayerAdded:Connect(UpdateList)
Players.PlayerRemoving:Connect(UpdateList)

-- Tombol Close
local Close = Instance.new("TextButton", MainGui)
Close.Size = UDim2.new(0.9, 0, 0, 40)
Close.Position = UDim2.new(0.05, 0, 0.9, 0)
Close.Text = "TUTUP MENU"
Close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close)

SupportIcon.MouseButton1Click:Connect(function() 
    MainGui.Visible = not MainGui.Visible 
    if MainGui.Visible then UpdateList() end
end)
Close.MouseButton1Click:Connect(function() MainGui.Visible = false end)
