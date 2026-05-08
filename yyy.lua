local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama jika ada agar tidak double
if CoreGui:FindFirstChild("SptzyyCopyGame") then
    CoreGui.SptzyyCopyGame:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyCopyGame"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "SPTZYY COPYY GAME"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Parent = MainFrame
CopyBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
CopyBtn.Size = UDim2.new(0.8, 0, 0, 50)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyBtn.Text = "COPY MAP (Save File)"
CopyBtn.TextColor3 = Color3.new(1, 1, 1)

local PasteBtn = Instance.new("TextButton")
PasteBtn.Parent = MainFrame
PasteBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
PasteBtn.Size = UDim2.new(0.8, 0, 0, 50)
PasteBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
PasteBtn.Text = "PASTE MAP (Load File)"
PasteBtn.TextColor3 = Color3.new(1, 1, 1)

local Status = Instance.new("TextLabel")
Status.Parent = MainFrame
Status.Position = UDim2.new(0, 0, 0.85, 0)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.BackgroundTransparency = 1
Status.Text = "Status: Ready"
Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
Status.TextSize = 12

-----------------------------------------------------------
-- LOGIKA UTAMA
-----------------------------------------------------------

local FILENAME = "sptzyy_data.json"

CopyBtn.MouseButton1Click:Connect(function()
    local data = {}
    Status.Text = "Status: Scanning..."
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("Terrain") then
            local isPlayer = false
            -- Cek apakah bagian dari karakter
            if v:FindFirstAncestorOfClass("Model") and v:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                isPlayer = true
            end
            
            if not isPlayer then
                table.insert(data, {
                    ["Class"] = v.ClassName,
                    ["Name"] = v.Name,
                    ["Size"] = {v.Size.X, v.Size.Y, v.Size.Z},
                    ["CFrame"] = {v.CFrame:GetComponents()},
                    ["Color"] = {v.Color.r, v.Color.g, v.Color.b},
                    ["Mat"] = v.Material.Name,
                    ["Trans"] = v.Transparency,
                    ["Anch"] = v.Anchored,
                    ["Coll"] = v.CanCollide
                })
            end
        end
    end
    
    local success, err = pcall(function()
        writefile(FILENAME, HttpService:JSONEncode(data))
    end)
    
    if success then
        Status.Text = "Status: Saved " .. #data .. " Parts!"
    else
        Status.Text = "Status: Save Error!"
        warn(err)
    end
end)

PasteBtn.MouseButton1Click:Connect(function()
    if not isfile(FILENAME) then
        Status.Text = "Status: No File Found!"
        return
    end
    
    Status.Text = "Status: Pasting..."
    local raw = readfile(FILENAME)
    local data = HttpService:JSONDecode(raw)
    
    local Folder = Instance.new("Folder", workspace)
    Folder.Name = "PastedMap_Sptzyy"
    
    for _, d in pairs(data) do
        local success, p = pcall(function()
            local part = Instance.new(d.Class)
            part.Name = d.Name
            part.Size = Vector3.new(d.Size[1], d.Size[2], d.Size[3])
            part.CFrame = CFrame.new(unpack(d.CFrame))
            part.Color = Color3.new(d.Color[1], d.Color[2], d.Color[3])
            part.Material = Enum.Material[d.Mat]
            part.Transparency = d.Trans
            part.Anchored = d.Anch
            part.CanCollide = d.Coll
            part.Parent = Folder
            return part
        end)
    end
    Status.Text = "Status: Paste Done!"
end)
