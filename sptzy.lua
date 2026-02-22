-- [[ PHANTOM SQUARE: ULTIMATE NETWORK EXPANDER ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ STATE ]] --
local serverExpandActive = false
local originalData = {} -- Menyimpan data asli agar bisa di-reset

-- [[ UI SCREEN SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomNetworkFinal"
ScreenGui.ResetOnSpawn = false

-- [[ 1. LAUNCHER ICON ]] --
local IconBtn = Instance.new("ImageButton", ScreenGui)
IconBtn.Size = UDim2.new(0, 55, 0, 55)
IconBtn.Position = UDim2.new(0, 30, 0.5, -27)
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
IconBtn.Image = "rbxassetid://12503521360"
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 100)
IconStroke.Thickness = 2

-- [[ 2. MAIN FRAME ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 100)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "REALTIME EXPANDER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- [[ TOMBOL TOGGLE ]] --
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0, 220, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -110, 0.5, -5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleBtn.Text = "SYSTEM: DISABLED"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local BtnStroke = Instance.new("UIStroke", ToggleBtn)
BtnStroke.Color = Color3.fromRGB(255, 50, 50)

-- [[ LOGIKA BYPASS NETWORK OWNERSHIP ]] --
local function toggleNetworkExpand(state)
    local char = lp.Character
    if not char then return end

    for _, acc in pairs(char:GetChildren()) do
        if acc:IsA("Accessory") then
            local handle = acc:FindFirstChild("Handle")
            if handle then
                -- Ambil Mesh di dalamnya
                local mesh = handle:FindFirstChildOfClass("SpecialMesh") or handle:FindFirstChildOfClass("MeshPart")
                
                if state then
                    -- Simpan data asli jika belum ada
                    if not originalData[acc.Name] then
                        originalData[acc.Name] = {
                            Size = handle.Size,
                            Scale = mesh and (mesh:IsA("SpecialMesh") and mesh.Scale or nil)
                        }
                    end
                    
                    -- LOGIKA UTAMA: Membesarkan PART (Handle) bukan cuma Mesh visual
                    -- Ini yang memaksa Server mengupdate posisi physics-nya
                    handle.Size = Vector3.new(20, 0.2, 20) -- Membentuk lempengan raksasa
                    
                    if mesh and mesh:IsA("SpecialMesh") then
                        mesh.Scale = Vector3.new(50, 0.1, 50) -- Melebarkan visual tekstur baju/topi
                    end
                else
                    -- RESET ke ukuran semula
                    if originalData[acc.Name] then
                        handle.Size = originalData[acc.Name].Size
                        if mesh and mesh:IsA("SpecialMesh") then
                            mesh.Scale = originalData[acc.Name].Scale
                        end
                    end
                end
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    serverExpandActive = not serverExpandActive
    
    if serverExpandActive then
        ToggleBtn.Text = "SYSTEM: ENABLED"
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        BtnStroke.Color = Color3.fromRGB(0, 255, 100)
        toggleNetworkExpand(true)
    else
        ToggleBtn.Text = "SYSTEM: DISABLED"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        BtnStroke.Color = Color3.fromRGB(255, 50, 50)
        toggleNetworkExpand(false)
    end
end)

-- Loop Heartbeat untuk mencegah Server/Game merefresh ukuran secara paksa
RunService.Heartbeat:Connect(function()
    if serverExpandActive then
        toggleNetworkExpand(true)
    end
end)

-- [[ UI INTERACTION ]] --
IconBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Draggable Logic
local function makeDraggable(obj)
    local dragging, input, startPos, startObjPos
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startPos = i.Position; startObjPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - startPos
            obj.Position = UDim2.new(startObjPos.X.Scale, startObjPos.X.Offset + delta.X, startObjPos.Y.Scale, startObjPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

makeDraggable(MainFrame)
makeDraggable(IconBtn)

print("PHANTOM SYSTEM: REALTIME SERVER-SIDE ENABLED")
