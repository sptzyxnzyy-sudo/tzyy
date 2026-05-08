local HttpService = game:GetService("HttpService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CopyBtn = Instance.new("TextButton")
local PasteBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- GUI Setup
ScreenGui.Name = "SptzyyCopyGame_CrossServer"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "SPTZYY COPYY GAME"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold

CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.white
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

CopyBtn.Parent = MainFrame
CopyBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
CopyBtn.Size = UDim2.new(0.8, 0, 0, 50)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
CopyBtn.Text = "COPY MAP (Save to File)"
CopyBtn.TextColor3 = Color3.white

PasteBtn.Parent = MainFrame
PasteBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
PasteBtn.Size = UDim2.new(0.8, 0, 0, 50)
PasteBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
PasteBtn.Text = "PASTE MAP (Load from File)"
PasteBtn.TextColor3 = Color3.white

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready to Copy/Paste"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

-----------------------------------------------------------
-- LOGIKA DATA PERSISTENCE (WRITE/READ FILE)
-----------------------------------------------------------

local FILENAME = "sptzyy_map_data.txt"

-- Fungsi konversi CFrame/Color ke Tabel (agar bisa jadi JSON)
local function tableFromCFrame(cf)
    return {cf:GetComponents()}
end

local function tableFromColor(c)
    return {R = c.r, G = c.g, B = c.b}
end

-- Tombol Copy
CopyBtn.MouseButton1Click:Connect(function()
    local mapData = {}
    StatusLabel.Text = "Scanning... please wait"
    wait(0.5)

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("Terrain") then
            -- Pastikan bukan bagian dari karakter pemain
            if not obj:FindFirstAncestorOfClass("Model") or not obj:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                table.insert(mapData, {
                    ClassName = obj.ClassName,
                    Name = obj.Name,
                    Size = {obj.Size.X, obj.Size.Y, obj.Size.Z},
                    CFrame = tableFromCFrame(obj.CFrame),
                    Color = tableFromColor(obj.Color),
                    Material = obj.Material.Name,
                    Transparency = obj.Transparency,
                    Anchored = obj.Anchored,
                    CanCollide = obj.CanCollide
                })
            end
        end
    end

    -- Simpan ke file di folder executor
    local success, err = pcall(function()
        writefile(FILENAME, HttpService:JSONEncode(mapData))
    end)

    if success then
        StatusLabel.Text = "Saved! Go to another map and paste."
    else
        StatusLabel.Text = "Error saving file!"
        warn(err)
    end
end)

-- Tombol Paste
PasteBtn.MouseButton1Click:Connect(function()
    if not isfile(FILENAME) then
        StatusLabel.Text = "No copy data found!"
        return
    end

    StatusLabel.Text = "Loading file..."
    local dataRaw = readfile(FILENAME)
    local data = HttpService:JSONDecode(dataRaw)
    
    local NewFolder = Instance.new("Folder")
    NewFolder.Name = "Sptzyy_PastedMap"
    NewFolder.Parent = workspace

    for _, pData in pairs(data) do
        local p = Instance.new(pData.ClassName)
        p.Name = pData.Name
        p.Size = Vector3.new(pData.Size[1], pData.Size[2], pData.Size[3])
        p.CFrame = CFrame.new(unpack(pData.CFrame))
        p.Color = Color3.new(pData.Color.R, pData.Color.G, pData.Color.B)
        p.Material = Enum.Material[pData.Material]
        p.Transparency = pData.Transparency
        p.Anchored = pData.Anchored
        p.CanCollide = pData.CanCollide
        p.Parent = NewFolder
    end

    StatusLabel.Text = "Paste Success! " .. #data .. " parts."
end)
