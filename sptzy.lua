-- [[ PHANTOM ULTIMATE EXPLORER & FINDER V2 ]]
-- UI: Modern Dark Neon Cyan | Support: Mobile Executor
-- Fitur: Workspace Browser + Recursive Object Finder (Folder -> Model/Part)

local LP = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local currentFolder = workspace

-- Cleanup UI
if CoreGui:FindFirstChild("PhantomUltimate") then CoreGui.PhantomUltimate:Destroy() end

-- [[ 1. UI ROOT CONSTRUCTION ]]
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "PhantomUltimate"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0.5, -160, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

-- [[ 2. PAGES (EXPLORER & TELEPORT) ]]
local ExplorerPage = Instance.new("Frame", Main)
ExplorerPage.Size = UDim2.new(1, 0, 1, -60)
ExplorerPage.BackgroundTransparency = 1

local TeleportPage = Instance.new("Frame", Main)
TeleportPage.Size = UDim2.new(1, 0, 1, -60)
TeleportPage.BackgroundTransparency = 1
TeleportPage.Visible = false

-- [[ EXPLORER COMPONENTS ]]
local EHeader = Instance.new("Frame", ExplorerPage)
EHeader.Size = UDim2.new(1, 0, 0, 50)
EHeader.BackgroundTransparency = 1

local ETitle = Instance.new("TextLabel", EHeader)
ETitle.Size = UDim2.new(1, -70, 1, 0)
ETitle.Position = UDim2.new(0, 15, 0, 0)
ETitle.Text = "DIR: WORKSPACE"
ETitle.TextColor3 = Color3.new(1, 1, 1)
ETitle.Font = Enum.Font.GothamBold
ETitle.TextSize = 13
ETitle.TextXAlignment = Enum.TextXAlignment.Left
ETitle.BackgroundTransparency = 1

local BackBtn = Instance.new("TextButton", EHeader)
BackBtn.Size = UDim2.new(0, 40, 0, 30)
BackBtn.Position = UDim2.new(1, -50, 0.5, -15)
BackBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BackBtn.Text = "<-"
BackBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", BackBtn)

local Scroll = Instance.new("ScrollingFrame", ExplorerPage)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)

-- [[ TELEPORT COMPONENTS ]]
local TTitle = Instance.new("TextLabel", TeleportPage)
TTitle.Size = UDim2.new(1, 0, 0, 80)
TTitle.Text = "FOLDER-MODEL FINDER"
TTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
TTitle.Font = Enum.Font.GothamBold
TTitle.TextSize = 16
TTitle.BackgroundTransparency = 1

local InputBox = Instance.new("TextBox", TeleportPage)
InputBox.Size = UDim2.new(0, 260, 0, 50)
InputBox.Position = UDim2.new(0.5, -130, 0, 100)
InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputBox.PlaceholderText = "Nama Model/Part..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.new(1, 1, 1)
InputBox.Font = Enum.Font.Gotham
Instance.new("UICorner", InputBox)

-- Logika Input Bersih Otomatis
InputBox.Focused:Connect(function() InputBox.Text = "" end)

local TpBtn = Instance.new("TextButton", TeleportPage)
TpBtn.Size = UDim2.new(0, 260, 0, 50)
TpBtn.Position = UDim2.new(0.5, -130, 0, 170)
TpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
TpBtn.Text = "SCAN & TELEPORT"
TpBtn.TextColor3 = Color3.new(1, 1, 1)
TpBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TpBtn)

local Status = Instance.new("TextLabel", TeleportPage)
Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 230)
Status.Text = "Alur: Workspace > Folder > Model"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.BackgroundTransparency = 1

-- [[ 3. LOGIKA CORE ]]

-- Fungsi Refresh List Explorer
local function RefreshList(folder)
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    currentFolder = folder
    ETitle.Text = "DIR: " .. string.sub(folder.Name, 1, 20):upper()
    local children = folder:GetChildren()
    for _, v in pairs(children) do
        local btn = Instance.new("TextButton", Scroll)
        btn.Size = UDim2.new(1, -5, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.Text = "  [" .. v.ClassName .. "] " .. v.Name
        btn.TextColor3 = (v:IsA("Folder") or v:IsA("Model")) and Color3.fromRGB(0, 255, 255) or Color3.new(0.8, 0.8, 0.8)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function() 
            if #v:GetChildren() > 0 then RefreshList(v) end 
        end)
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, #children * 45)
end

BackBtn.MouseButton1Click:Connect(function() if currentFolder ~= workspace then RefreshList(currentFolder.Parent) end end)

-- Logika Scan Workspace (Folder -> Model)
TpBtn.MouseButton1Click:Connect(function()
    local name = InputBox.Text
    if name == "" then 
        Status.Text = "Input kosong!"
        Status.TextColor3 = Color3.new(1, 0.5, 0)
        return 
    end

    Status.Text = "Scanning workspace..."
    Status.TextColor3 = Color3.new(1, 1, 1)
    task.wait(0.1)

    -- Logika Pencarian: Cek di workspace, lalu masuk ke setiap folder secara recursive
    local target = workspace:FindFirstChild(name, true) 

    if target and (target:IsA("BasePart") or target:IsA("Model")) then
        local cf
        if target:IsA("Model") then
            cf = target.PrimaryPart and target.PrimaryPart.CFrame or target:GetModelCFrame()
        else
            cf = target.CFrame
        end

        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = cf + Vector3.new(0, 3, 0)
            Status.Text = "Teleported to: " .. target.Name
            Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    else
        Status.Text = "Model '" .. name .. "' tidak ditemukan!"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- [[ 4. NAVIGATION TAB ]]
local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(1, 0, 0, 55)
Nav.Position = UDim2.new(0, 0, 1, -55)
Nav.BackgroundColor3 = Color3.fromRGB(18, 18, 18)

local TabE = Instance.new("TextButton", Nav)
TabE.Size = UDim2.new(0.5, 0, 1, 0)
TabE.Text = "EXPLORER"
TabE.TextColor3 = Color3.fromRGB(0, 255, 255)
TabE.BackgroundTransparency = 1

local TabT = Instance.new("TextButton", Nav)
TabT.Size = UDim2.new(0.5, 0, 1, 0)
TabT.Position = UDim2.new(0.5, 0, 0, 0)
TabT.Text = "SCAN & TP"
TabT.TextColor3 = Color3.new(0.6, 0.6, 0.6)
TabT.BackgroundTransparency = 1

TabE.MouseButton1Click:Connect(function()
    ExplorerPage.Visible, TeleportPage.Visible = true, false
    TabE.TextColor3, TabT.TextColor3 = Color3.fromRGB(0, 255, 255), Color3.new(0.6, 0.6, 0.6)
end)

TabT.MouseButton1Click:Connect(function()
    ExplorerPage.Visible, TeleportPage.Visible = false, true
    TabT.TextColor3, TabE.TextColor3 = Color3.fromRGB(0, 255, 255), Color3.new(0.6, 0.6, 0.6)
end)

RefreshList(workspace)
