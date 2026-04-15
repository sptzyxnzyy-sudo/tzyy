-- [[ PHANTOM PURE TERRAIN CLONER ]]
-- Fokus: Hanya Voxel Terrain (Tanpa Model/Part)
-- Output: Kode Lua Kompatibel Studio Lite

local LP = game.Players.LocalPlayer
local Terrain = workspace.Terrain
local CoreGui = game:GetService("CoreGui")

-- Bersihkan UI lama
if CoreGui:FindFirstChild("PureTerrainScanner") then
    CoreGui.PureTerrainScanner:Destroy()
end

-- [[ UI DESIGN MODERN MOBILE ]]
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "PureTerrainScanner"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 300, 0, 380)
Main.Position = UDim2.new(0.5, -150, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 1.8

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "PURE TERRAIN SCANNER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- Result Box
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0, 260, 0, 180)
Scroll.Position = UDim2.new(0.5, -130, 0, 60)
Scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 15, 0)

local ResultBox = Instance.new("TextBox", Scroll)
ResultBox.Size = UDim2.new(1, -10, 1, 0)
ResultBox.Position = UDim2.new(0, 5, 0, 5)
ResultBox.Text = "-- Klik SCAN untuk data tanah --"
ResultBox.TextColor3 = Color3.fromRGB(0, 255, 200)
ResultBox.TextSize = 11
ResultBox.Font = Enum.Font.Code
ResultBox.MultiLine = true
ResultBox.ClearTextOnFocus = false
ResultBox.TextXAlignment = Enum.TextXAlignment.Left
ResultBox.TextYAlignment = Enum.TextYAlignment.Top
ResultBox.BackgroundTransparency = 1

-- Buttons
local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0, 125, 0, 45)
ScanBtn.Position = UDim2.new(0, 20, 0, 260)
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ScanBtn.Text = "SCAN TERRAIN"
ScanBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold

local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Size = UDim2.new(0, 125, 0, 45)
CopyBtn.Position = UDim2.new(0, 155, 0, 260)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
CopyBtn.Text = "COPY CODE"
CopyBtn.TextColor3 = Color3.new(1, 1, 1)
CopyBtn.Font = Enum.Font.GothamBold

Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

-- [[ LOGIKA SCANNER ]]
local function ScanPureTerrain()
    local char = LP.Character
    if not char then return 0 end
    
    local pos = char.HumanoidRootPart.Position
    local scanSize = 12 -- Luas area (X, Z)
    local region = Region3.new(pos - Vector3.new(scanSize, 6, scanSize), pos + Vector3.new(scanSize, 4, scanSize))
    region = region:ExpandToGrid(4)
    
    -- Membaca Voxel (Hanya data terrain)
    local material, occupancy = Terrain:ReadVoxels(region, 4)
    local size = material.Size
    
    local output = "local T = workspace.Terrain\n"
    local count = 0
    
    for z = 1, size.Z do
        for y = 1, size.Y do
            for x = 1, size.X do
                local mat = material[x][y][z]
                local occ = occupancy[x][y][z]
                
                -- Validasi: Hanya ambil jika ada material dan bukan Udara (Air)
                if occ > 0 and mat ~= Enum.Material.Air then
                    local vPos = region.CFrame * CFrame.new(
                        (x - size.X/2 - 0.5) * 4,
                        (y - size.Y/2 - 0.5) * 4,
                        (z - size.Z/2 - 0.5) * 4
                    )
                    -- Menghasilkan perintah FillBlock untuk setiap Voxel tanah
                    output = output .. string.format("T:FillBlock(CFrame.new(%.1f,%.1f,%.1f),Vector3.new(4,4,4),Enum.Material.%s)\n", vPos.X, vPos.Y, vPos.Z, mat.Name)
                    count = count + 1
                end
            end
        end
    end
    
    ResultBox.Text = output
    return count
end

-- [[ INTERACTION ]]
ScanBtn.MouseButton1Click:Connect(function()
    ScanBtn.Text = "SCANNING..."
    task.wait(0.2)
    local total = ScanPureTerrain()
    ScanBtn.Text = "DONE (" .. total .. ")"
    task.wait(1)
    ScanBtn.Text = "SCAN TERRAIN"
end)

CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(ResultBox.Text)
        CopyBtn.Text = "COPIED!"
        task.wait(1)
        CopyBtn.Text = "COPY CODE"
    end
end)
