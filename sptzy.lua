-- [[ PHANTOM MAP CLONER - ALL IN ONE ]]
-- Mendukung: Model, Parts, Terrain, Folder, Mesh, dll.
-- Logika: Objek -> String Kode Lua -> Paste ke Map Lain.

local LP = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Terrain = workspace.Terrain

-- Hapus UI lama jika ada
if CoreGui:FindFirstChild("MapClonerGUI") then
    CoreGui.MapClonerGUI:Destroy()
end

-- [[ UI MODERN ]]
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "MapClonerGUI"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0.5, -160, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "MAP CLONER V1 (MOBILE)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0, 280, 0, 240)
Scroll.Position = UDim2.new(0.5, -140, 0, 60)
Scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Scroll.CanvasSize = UDim2.new(0, 0, 50, 0) -- Muat ribuan baris data

local OutputBox = Instance.new("TextBox", Scroll)
OutputBox.Size = UDim2.new(1, -10, 1, 0)
OutputBox.Position = UDim2.new(0, 5, 0, 5)
OutputBox.Text = "-- Klik SCAN untuk mengonversi seluruh Map --"
OutputBox.TextColor3 = Color3.fromRGB(0, 255, 200)
OutputBox.TextSize = 10
OutputBox.Font = Enum.Font.Code
OutputBox.MultiLine = true
OutputBox.ClearTextOnFocus = false
OutputBox.TextXAlignment = Enum.TextXAlignment.Left
OutputBox.TextYAlignment = Enum.TextYAlignment.Top
OutputBox.BackgroundTransparency = 1

local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0, 130, 0, 45)
ScanBtn.Position = UDim2.new(0, 20, 0, 320)
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ScanBtn.Text = "SCAN MAP"
ScanBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold

local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Size = UDim2.new(0, 130, 0, 45)
CopyBtn.Position = UDim2.new(0, 170, 0, 320)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
CopyBtn.Text = "COPY ALL"
CopyBtn.TextColor3 = Color3.new(1, 1, 1)
CopyBtn.Font = Enum.Font.GothamBold

Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

-- [[ LOGIKA CLONING ]]
local function SerializeMap()
    local finalCode = "-- PHANTOM MAP CLONER DATA\nlocal F = Instance.new('Folder', workspace)\nF.Name = 'ClonedMap_Save'\n\n"
    local count = 0

    -- 1. CLONE MODELS/PARTS (Objek Fisik)
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Part") or v:IsA("Model") or v:IsA("MeshPart") then
            -- Lewati LocalPlayer, Camera, dan Terrain
            if v.Name ~= LP.Name and v.Name ~= "Camera" and v.Name ~= "Terrain" then
                pcall(function()
                    if v:IsA("Part") or v:IsA("MeshPart") then
                        finalCode = finalCode .. string.format(
                            "local p = Instance.new('%s', F) p.Size = Vector3.new(%.2f,%.2f,%.2f) p.CFrame = CFrame.new(%.2f,%.2f,%.2f) p.Material = Enum.Material.%s p.Color = Color3.fromRGB(%d,%d,%d) p.Anchored = true p.CanCollide = %s\n",
                            v.ClassName, v.Size.X, v.Size.Y, v.Size.Z, v.Position.X, v.Position.Y, v.Position.Z, v.Material.Name, v.Color.R*255, v.Color.G*255, v.Color.B*255, tostring(v.CanCollide)
                        )
                    elseif v:IsA("Model") then
                        -- Untuk Model, kita ambil posisi PrimaryPart
                        local cf, size = v:GetBoundingBox()
                        finalCode = finalCode .. string.format("-- Model: %s terdeteksi (Hanya direpresentasikan sebagai Part/BoundingBox di Lite)\n", v.Name)
                    end
                    count = count + 1
                end)
            end
        end
    end

    -- 2. CLONE TERRAIN (Hanya area sekitar player agar tidak lag)
    local pos = LP.Character.HumanoidRootPart.Position
    local region = Region3.new(pos - Vector3.new(20, 10, 20), pos + Vector3.new(20, 5, 20)):ExpandToGrid(4)
    local material, occupancy = Terrain:ReadVoxels(region, 4)
    local size = material.Size

    finalCode = finalCode .. "\n-- Terrain Data\nlocal T = workspace.Terrain\n"
    for z = 1, size.Z do
        for y = 1, size.Y do
            for x = 1, size.X do
                local mat = material[x][y][z]
                if mat ~= Enum.Material.Air then
                    local vPos = region.CFrame * CFrame.new((x - size.X/2 - 0.5) * 4, (y - size.Y/2 - 0.5) * 4, (z - size.Z/2 - 0.5) * 4)
                    finalCode = finalCode .. string.format("T:FillBlock(CFrame.new(%.1f,%.1f,%.1f), Vector3.new(4,4,4), Enum.Material.%s)\n", vPos.X, vPos.Y, vPos.Z, mat.Name)
                    count = count + 1
                end
            end
        end
    end

    OutputBox.Text = finalCode
    return count
end

-- [[ INTERACTION ]]
ScanBtn.MouseButton1Click:Connect(function()
    ScanBtn.Text = "CLONING..."
    task.wait(0.5)
    local total = SerializeMap()
    ScanBtn.Text = "DONE (" .. total .. ")"
    task.wait(1)
    ScanBtn.Text = "SCAN MAP"
end)

CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(OutputBox.Text)
        CopyBtn.Text = "COPIED!"
    else
        CopyBtn.Text = "USE SELECT ALL"
    end
    task.wait(1)
    CopyBtn.Text = "COPY ALL"
end)
