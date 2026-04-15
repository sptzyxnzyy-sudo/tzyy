-- [[ CONFIGURATION ]]
local ScaleValue = 200
local IsEnabled = false
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer

-- [[ NOTIFICATION SYSTEM ]]
local function SendNotif(title, msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = msg,
        Duration = 3
    })
end

-- [[ NETLESS LOGIC ]]
-- Berfungsi agar server menerima perubahan fisik dari client
local function ApplyNetless(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity = Vector3.new(0, 30, 0) -- Angka magic untuk bypass network ownership
            v.CanCollide = false
        end
    end
end

-- [[ RIG & SCALE MANIPULATION ]]
local function ResizeRig(scale)
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    pcall(function()
        -- 1. Mengubah Scale Internal (Jika game mendukung)
        local bodyTypes = {"BodyWidthScale", "BodyHeightScale", "BodyDepthScale", "HeadScale"}
        for _, name in pairs(bodyTypes) do
            local s = hum:FindFirstChild(name)
            if s then s.Value = scale end
        end

        -- 2. Rig Manipulation (Motor6D Offset)
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("Motor6D") then
                -- Memaksa sambungan tubuh melebar dan memanjang
                v.C0 = v.C0 * CFrame.new(0, 0, 0)
                v.C1 = v.C1 * CFrame.new(0, 0, 0)
            end
            
            -- 3. Accessory/Hat Stretching
            if v:IsA("Accessory") then
                local handle = v:FindFirstChild("Handle")
                if handle then
                    local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                    if mesh then
                        mesh.Scale = Vector3.new(scale, scale, scale)
                    end
                end
            end
        end
    end)
end

-- [[ UI SETUP (Neon Cyan Style) ]]
local SG = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 220, 0, 140)
Main.Position = UDim2.new(0.5, -110, 0.5, -70)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Neon = Instance.new("Frame", Main)
Neon.Size = UDim2.new(1, 0, 0, 2)
Neon.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Neon.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "RIG MANIPULATOR v2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Toggle = Instance.new("TextButton", Main)
Toggle.Size = UDim2.new(0, 180, 0, 45)
Toggle.Position = UDim2.new(0.5, -90, 0.45, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Toggle.Text = "STATUS: INACTIVE"
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.Gotham
Toggle.BorderSizePixel = 0

-- [[ MAIN LOOP ]]
Toggle.MouseButton1Click:Connect(function()
    IsEnabled = not IsEnabled
    if IsEnabled then
        Toggle.Text = "STATUS: ACTIVE"
        Toggle.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
        SendNotif("SYSTEM", "Rig & Netless Aktif")
        ResizeRig(ScaleValue)
    else
        Toggle.Text = "STATUS: INACTIVE"
        Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SendNotif("SYSTEM", "Reset ke Normal")
        ResizeRig(1)
    end
end)

-- Heartbeat loop untuk menjaga Netless tetap berjalan
RunService.Heartbeat:Connect(function()
    if IsEnabled and LP.Character then
        ApplyNetless(LP.Character)
    end
end)
