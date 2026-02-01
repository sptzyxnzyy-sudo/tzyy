-- [[ COPY FITUR SPTZYY - FULL MAP CLONER ]] --

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local DATA_FILE = "Sptzyy_FullMap_Storage.json"

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_UltraCopy"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Icon Support (Bisa Digeser)
local SupportIcon = Instance.new("ImageButton")
SupportIcon.Parent = ScreenGui
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.Active = true
SupportIcon.Draggable = true

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = SupportIcon

-- Main GUI
local MainGui = Instance.new("Frame")
MainGui.Parent = ScreenGui
MainGui.Size = UDim2.new(0, 240, 0, 260)
MainGui.Position = UDim2.new(0.5, -120, 0.5, -130)
MainGui.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainGui.BorderSizePixel = 0
MainGui.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainGui

local Title = Instance.new("TextLabel")
Title.Parent = MainGui
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 220)
Title.Text = "COPY FITUR SPTZYY"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = Title

-- Fungsi Notifikasi Melayang
local function Notify(text)
    local Label = Instance.new("TextLabel")
    Label.Parent = ScreenGui
    Label.Size = UDim2.new(0, 250, 0, 45)
    Label.Position = UDim2.new(0.5, -125, 0.9, 0)
    Label.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Label.TextColor3 = Color3.fromRGB(0, 255, 120)
    Label.Text = "⚡ " .. text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    
    local c = Instance.new("UICorner")
    c.Parent = Label
    
    Label:TweenPosition(UDim2.new(0.5, -125, 0.45, 0), "Out", "Back", 1.5)
    task.delay(2, function()
        TweenService:Create(Label, TweenInfo.new(1), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        task.wait(1)
        Label:Destroy()
    end)
end

-- Fungsi Copy Semua ke File
local function CopyAll()
    Notify("Memulai Proses Copy Semua...")
    local fullMapData = {}
    
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(fullMapData, {
                ["Type"] = v.ClassName,
                ["Name"] = v.Name,
                ["Pos"] = {v.Position.X, v.Position.Y, v.Position.Z},
                ["Size"] = {v.Size.X, v.Size.Y, v.Size.Z},
                ["Color"] = {v.Color.r, v.Color.g, v.Color.b},
                ["Mat"] = v.Material.Name,
                ["Anc"] = v.Anchored
            })
        end
    end
    
    local success, result = pcall(function()
        writefile(DATA_FILE, HttpService:JSONEncode(fullMapData))
    end)
    
    if success then
        Notify("Berhasil Copy & Simpan ke File!")
    else
        Notify("Gagal Simpan: " .. tostring(result))
    end
end

-- Fungsi Paste dari File
local function PasteAll()
    if not isfile(DATA_FILE) then
        Notify("Data file tidak ditemukan!")
        return
    end
    
    Notify("Proses Menempel Map...")
    local data = HttpService:JSONDecode(readfile(DATA_FILE))
    
    for _, info in pairs(data) do
        pcall(function()
            local part = Instance.new(info.Type)
            part.Name = info.Name
            part.Position = Vector3.new(info.Pos[1], info.Pos[2], info.Pos[3])
            part.Size = Vector3.new(info.Size[1], info.Size[2], info.Size[3])
            part.Color = Color3.new(info.Color[1], info.Color[2], info.Color[3])
            part.Material = Enum.Material[info.Mat]
            part.Anchored = info.Anc
            part.Parent = game.Workspace
        end)
    end
    Notify("Map Berhasil Ditempel!")
end

-- Tombol-Tombol
local function CreateButton(name, pos, color, func)
    local btn = Instance.new("TextButton")
    btn.Parent = MainGui
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    
    local c = Instance.new("UICorner")
    c.Parent = btn
    btn.MouseButton1Click:Connect(func)
end

CreateButton("COPY SEMUA ASSET", UDim2.new(0.075, 0, 0, 70), Color3.fromRGB(0, 150, 70), CopyAll)
CreateButton("PASTE KE MAP MANAPUN", UDim2.new(0.075, 0, 0, 130), Color3.fromRGB(0, 100, 200), PasteAll)
CreateButton("CLOSE GUI", UDim2.new(0.075, 0, 0, 190), Color3.fromRGB(150, 0, 0), function()
    MainGui.Visible = false
end)

SupportIcon.MouseButton1Click:Connect(function()
    MainGui.Visible = not MainGui.Visible
end)

Notify("Sptzyy Copy-Paste Ready!")
