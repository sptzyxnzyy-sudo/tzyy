-- [[ PHANTOM SQUARE: FULL SYSTEM - GUNGLITCH & LASER ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Pastikan PlayerGui tersedia
local PlayerGui = lp:WaitForChild("PlayerGui")

-- [[ STATE VARIABLE ]] --
local glitchActive = false
local originalData = {}

-- [[ HAPUS UI LAMA JIKA ADA ]] --
if PlayerGui:FindFirstChild("PhantomFinalSystem") then
    PlayerGui.PhantomFinalSystem:Destroy()
end

-- [[ UI SCREEN SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomFinalSystem"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- [[ 1. LAUNCHER ICON ]] --
local IconBtn = Instance.new("ImageButton", ScreenGui)
IconBtn.Size = UDim2.new(0, 60, 0, 60)
IconBtn.Position = UDim2.new(0, 50, 0.5, -30)
IconBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IconBtn.Image = "rbxassetid://12503521360" -- Default Icon
IconBtn.ZIndex = 10
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)

local IconStroke = Instance.new("UIStroke", IconBtn)
IconStroke.Color = Color3.fromRGB(255, 0, 100)
IconStroke.Thickness = 2

-- [[ 2. MAIN FRAME ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Visible = false
MainFrame.ZIndex = 11
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 0, 100)
MainStroke.Thickness = 1.5

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "PHANTOM GUNGLITCH + LASER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- [[ LASER GENERATOR ]] --
local function createLaser(parent)
    if parent:FindFirstChild("PhantomLaser") then return end
    
    local att0 = Instance.new("Attachment", parent)
    local att1 = Instance.new("Attachment", parent)
    att1.Position = Vector3.new(0, 0, -200) -- Panjang laser
    
    local beam = Instance.new("Beam", parent)
    beam.Name = "PhantomLaser"
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Width0 = 1 -- Ketebalan laser
    beam.Width1 = 1
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)) -- Merah
    beam.LightEmission = 1
    beam.FaceCamera = true
    beam.Enabled = true
end

-- [[ LOGIKA UTAMA: REALTIME EXPAND & GLITCH ]] --
local function toggleGlitch(state)
    local char = lp.Character
    if not char then return end

    -- Loop melalui Tools dan Accessories
    for _, item in pairs(char:GetDescendants()) do
        if item:IsA("Accessory") or item:IsA("Tool") then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local mesh = handle:FindFirstChildOfClass("SpecialMesh") or handle:FindFirstChildOfClass("MeshPart")
                
                if state then
                    -- Simpan data asli jika belum ada
                    if not originalData[handle] then
                        originalData[handle] = {
                            Size = handle.Size,
                            Scale = mesh and (mesh:IsA("SpecialMesh") and mesh.Scale or nil)
                        }
                    end
                    
                    -- Manipulasi Physics (Realtime Server-Side)
                    handle.Size = Vector3.new(40, 0.5, 40) -- Melebar raksasa
                    if mesh and mesh:IsA("SpecialMesh") then
                        mesh.Scale = Vector3.new(80, 0.05, 80) -- Visual menutupi pandangan
                    end
                    
                    -- Tambahkan Laser
                    createLaser(handle)
                else
                    -- RESET ke normal
                    if originalData[handle] then
                        handle.Size = originalData[handle].Size
                        if mesh and mesh:IsA("SpecialMesh") then
                            mesh.Scale = originalData[handle].Scale
                        end
                    end
                    -- Hapus Laser
                    if handle:FindFirstChild("PhantomLaser") then
                        handle.PhantomLaser:Destroy()
                    end
                end
            end
        end
    end
end

-- [[ TOMBOL ON/OFF ]] --
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0, 240, 0, 55)
ToggleBtn.Position = UDim2.new(0.5, -120, 0.5, -10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleBtn.Text = "SYSTEM: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 18
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

local BtnStroke = Instance.new("UIStroke", ToggleBtn)
BtnStroke.Color = Color3.fromRGB(255, 50, 50)
BtnStroke.Thickness = 2

ToggleBtn.MouseButton1Click:Connect(function()
    glitchActive = not glitchActive
    
    if glitchActive then
        ToggleBtn.Text = "SYSTEM: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 150)
        BtnStroke.Color = Color3.fromRGB(50, 255, 150)
        toggleGlitch(true)
    else
        ToggleBtn.Text = "SYSTEM: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        BtnStroke.Color = Color3.fromRGB(255, 50, 50)
        toggleGlitch(false)
    end
end)

-- Sinkronisasi agar tidak di-reset server (Heartbeat)
RunService.Heartbeat:Connect(function()
    if glitchActive then
        toggleGlitch(true)
    end
end)

-- [[ INTERAKSI UI ]] --
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Fungsi Geser (Draggable)
local function drag(gui)
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

drag(MainFrame)
drag(IconBtn)

print("PHANTOM SYSTEM: SUCCESS LOADED IN PLAYERGUI")
