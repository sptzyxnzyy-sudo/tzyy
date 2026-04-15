-- [[ PHANTOM INSTANT MAP CLONER ]]
-- Logika: Klik COPY (Simpan data) -> Klik PASTE (Munculkan hasil)

local LP = game.Players.LocalPlayer
local Terrain = workspace.Terrain
local CoreGui = game:GetService("CoreGui")

-- Penyimpanan Data Internal (Memory)
local ClipboardData = {
    Parts = {},
    Terrain = {}
}

-- [[ UI MODERN ]]
local SG = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 260, 0, 180)
Main.Position = UDim2.new(0.5, -130, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MAP CLONER (INSTANT)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- Tombol Copy
local CopyBtn = Instance.new("TextButton", Main)
CopyBtn.Size = UDim2.new(0, 220, 0, 45)
CopyBtn.Position = UDim2.new(0.5, -110, 0.3, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CopyBtn.Text = "COPY MAP & TERRAIN"
CopyBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold

-- Tombol Paste
local PasteBtn = Instance.new("TextButton", Main)
PasteBtn.Size = UDim2.new(0, 220, 0, 45)
PasteBtn.Position = UDim2.new(0.5, -110, 0.65, 0)
PasteBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 120)
PasteBtn.Text = "PASTE HERE"
PasteBtn.TextColor3 = Color3.new(1, 1, 1)
PasteBtn.Font = Enum.Font.GothamBold

Instance.new("UICorner", CopyBtn)
Instance.new("UICorner", PasteBtn)

-- [[ LOGIKA COPY ]]
CopyBtn.MouseButton1Click:Connect(function()
    ClipboardData.Parts = {}
    ClipboardData.Terrain = {}
    
    local root = LP.Character.HumanoidRootPart
    local scanPos = root.Position
    
    -- 1. Scan Parts (Sekitar 50 studs)
    for _, v in pairs(workspace:GetPartBoundsInRadius(scanPos, 50)) do
        if v.Anchored and not v.Parent:FindFirstChild("Humanoid") then
            table.insert(ClipboardData.Parts, {
                Name = v.Name,
                ClassName = v.ClassName,
                Size = v.Size,
                CFrame = root.CFrame:ToObjectSpace(v.CFrame), -- Simpan posisi relatif terhadap player
                Material = v.Material,
                Color = v.Color,
                Transparency = v.Transparency
            })
        end
    end
    
    -- 2. Scan Terrain
    local region = Region3.new(scanPos - Vector3.new(20, 10, 20), scanPos + Vector3.new(20, 5, 20)):ExpandToGrid(4)
    local material, occupancy = Terrain:ReadVoxels(region, 4)
    local size = material.Size
    
    for z = 1, size.Z do
        for y = 1, size.Y do
            for x = 1, size.X do
                local mat = material[x][y][z]
                if mat ~= Enum.Material.Air then
                    local vPos = region.CFrame * CFrame.new((x - size.X/2 - 0.5) * 4, (y - size.Y/2 - 0.5) * 4, (z - size.Z/2 - 0.5) * 4)
                    table.insert(ClipboardData.Terrain, {
                        Pos = root.CFrame:ToObjectSpace(vPos),
                        Mat = mat
                    })
                end
            end
        end
    end
    
    CopyBtn.Text = "COPIED: " .. (#ClipboardData.Parts + #ClipboardData.Terrain) .. " OBJS"
    task.wait(1)
    CopyBtn.Text = "COPY MAP & TERRAIN"
end)

-- [[ LOGIKA PASTE ]]
PasteBtn.MouseButton1Click:Connect(function()
    local root = LP.Character.HumanoidRootPart
    local currentCF = root.CFrame
    
    -- Paste Parts
    local folder = Instance.new("Folder", workspace)
    folder.Name = "Pasted_Map_" .. math.random(100, 999)
    
    for _, data in pairs(ClipboardData.Parts) do
        local p = Instance.new(data.ClassName)
        p.Size = data.Size
        p.CFrame = currentCF:ToWorldSpace(data.CFrame)
        p.Material = data.Material
        p.Color = data.Color
        p.Transparency = data.Transparency
        p.Anchored = true
        p.Parent = folder
    end
    
    -- Paste Terrain
    for _, tData in pairs(ClipboardData.Terrain) do
        local worldPos = currentCF:ToWorldSpace(tData.Pos)
        Terrain:FillBlock(worldPos, Vector3.new(4, 4, 4), tData.Mat)
    end
    
    PasteBtn.Text = "SUCCESS!"
    task.wait(1)
    PasteBtn.Text = "PASTE HERE"
end)
