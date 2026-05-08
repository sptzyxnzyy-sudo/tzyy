local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Membersihkan GUI lama
local old = CoreGui:FindFirstChild("SptzyyCopyGame")
if old then old:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "SptzyyCopyGame"
sg.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "SPTZYY COPYY GAME"
title.TextColor3 = Color3.new(0, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Parent = frame

local cp = Instance.new("TextButton")
cp.Size = UDim2.new(0.8, 0, 0, 50)
cp.Position = UDim2.new(0.1, 0, 0.2, 0)
cp.Text = "COPY MAP"
cp.Parent = frame

local ps = Instance.new("TextButton")
ps.Size = UDim2.new(0.8, 0, 0, 50)
ps.Position = UDim2.new(0.1, 0, 0.5, 0)
ps.Text = "PASTE MAP"
ps.Parent = frame

local cl = Instance.new("TextButton")
cl.Size = UDim2.new(0, 30, 0, 30)
cl.Position = UDim2.new(1, -35, 0, 5)
cl.Text = "X"
cl.BackgroundColor3 = Color3.new(1, 0, 0)
cl.Parent = frame
cl.MouseButton1Click:Connect(function() sg:Destroy() end)

-----------------------------------------------------------
-- LOGIKA UTAMA
-----------------------------------------------------------

local file = "sptzyy_map.json"

cp.MouseButton1Click:Connect(function()
    local t = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("Terrain") then
            local model = v:FindFirstAncestorOfClass("Model")
            if not (model and model:FindFirstChild("Humanoid")) then
                table.insert(t, {
                    c = v.ClassName,
                    n = v.Name,
                    s = {v.Size.X, v.Size.Y, v.Size.Z},
                    cf = {v.CFrame:GetComponents()},
                    col = {v.Color.r, v.Color.g, v.Color.b},
                    m = v.Material.Name,
                    a = v.Anchored
                })
            end
        end
    end
    writefile(file, HttpService:JSONEncode(t))
    print("Saved: " .. #t)
end)

ps.MouseButton1Click:Connect(function()
    if not isfile(file) then return end
    local data = HttpService:JSONDecode(readfile(file))
    local f = Instance.new("Folder", workspace)
    f.Name = "Copied_Map"
    for _, d in pairs(data) do
        local p = Instance.new(d.c)
        p.Name = d.n
        p.Size = Vector3.new(d.s[1], d.s[2], d.s[3])
        p.CFrame = CFrame.new(unpack(d.cf))
        p.Color = Color3.new(d.col[1], d.col[2], d.col[3])
        p.Material = Enum.Material[d.m]
        p.Anchored = d.a
        p.Parent = f
    end
end)
