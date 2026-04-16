-- [[ PHANTOM FINDER & TELEPORTER ]]
-- Fitur: Cari Nama Part/Model -> Teleport ke lokasinya
-- UI: Modern Neon Cyan, Auto-Clear Input

local LP = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Cleanup UI
if CoreGui:FindFirstChild("PhantomFinder") then CoreGui.PhantomFinder:Destroy() end

-- [[ UI CONSTRUCTION ]]
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "PhantomFinder"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 300, 0, 250)
Main.Position = UDim2.new(0.5, -150, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "OBJECT TELEPORTER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- Input Box (Nama Objek)
local InputObj = Instance.new("TextBox", Main)
InputObj.Size = UDim2.new(0, 240, 0, 50)
InputObj.Position = UDim2.new(0.5, -120, 0, 70)
InputObj.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputObj.PlaceholderText = "Ketik Nama Part/Model..."
InputObj.Text = ""
InputObj.TextColor3 = Color3.new(1, 1, 1)
InputObj.Font = Enum.Font.Gotham
Instance.new("UICorner", InputObj)

-- LOGIKA: Input Bersih Otomatis
InputObj.Focused:Connect(function()
    InputObj.Text = ""
end)

-- Tombol Teleport
local TpBtn = Instance.new("TextButton", Main)
TpBtn.Size = UDim2.new(0, 240, 0, 50)
TpBtn.Position = UDim2.new(0.5, -120, 0, 140)
TpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
TpBtn.Text = "TELEPORT KE OBJEK"
TpBtn.TextColor3 = Color3.new(1, 1, 1)
TpBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TpBtn)

-- Status Label
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 1, -35)
Status.Text = "Ready"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextSize = 11
Status.BackgroundTransparency = 1

-- [[ LOGIKA TELEPORT KE OBJEK ]]
local function TeleportToName(name)
    local target = workspace:FindFirstChild(name, true) -- 'true' agar mencari sampai ke dalam folder
    
    if target then
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            local cf = nil
            if target:IsA("BasePart") then
                cf = target.CFrame
            elseif target:IsA("Model") then
                cf = target:GetModelCFrame() or (target.PrimaryPart and target.PrimaryPart.CFrame)
            end
            
            if cf then
                root.CFrame = cf + Vector3.new(0, 3, 0)
                Status.Text = "Success: Berhasil ke " .. target.Name
                Status.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                Status.Text = "Error: Objek tidak punya posisi"
                Status.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    else
        Status.Text = "Error: Objek '" .. name .. "' tidak ditemukan"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

TpBtn.MouseButton1Click:Connect(function()
    local targetName = InputObj.Text
    if targetName ~= "" then
        TeleportToName(targetName)
    else
        Status.Text = "Warning: Input tidak boleh kosong!"
        Status.TextColor3 = Color3.fromRGB(255, 165, 0)
    end
end)
