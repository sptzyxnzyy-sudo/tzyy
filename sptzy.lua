-- [[ SPTZYY GIGA-WIDE REPLICATION - NO REMOTE ]] --
-- Fokus: Skala Mesh Maksimal dengan Fitur ON/OFF

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [[ PENYIMPANAN DATA ASLI ]] --
local originalScales = {}
local isWide = false
local spinning = false

-- [[ 🖥️ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Title.Text = "SPTZYY GIGA LASER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Instance.new("UICorner", Title)

-- [[ ⚙️ TOGGLE LOGIC ]] --

local function ToggleGigaWide()
    local char = lp.Character
    if not char then return end
    
    isWide = not isWide
    
    if isWide then
        -- AKTIFKAN (ON)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("SpecialMesh") or v:IsA("MeshPart") then
                -- Simpan data asli agar bisa di-reset
                originalScales[v] = v:IsA("SpecialMesh") and v.Scale or v.Size
                
                if v:IsA("SpecialMesh") then
                    v.Scale = Vector3.new(500, 0.5, 500)
                elseif v:IsA("MeshPart") then
                    v.Size = Vector3.new(2048, 1, 2048)
                end
            end
        end
        return true
    else
        -- MATIKAN (OFF)
        for v, originalValue in pairs(originalScales) do
            if v and v.Parent then
                if v:IsA("SpecialMesh") then
                    v.Scale = originalValue
                elseif v:IsA("MeshPart") then
                    v.Size = originalValue
                end
            end
        end
        originalScales = {}
        return false
    end
end

local function ToggleSpin()
    spinning = not spinning
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local existing = hrp:FindFirstChild("PhysicsSpin")
        if existing then existing:Destroy() end
        
        if spinning then
            local av = Instance.new("AngularVelocity", hrp)
            av.Name = "PhysicsSpin"
            av.MaxTorque = math.huge
            av.AngularVelocity = Vector3.new(0, 500, 0)
            av.Attachment0 = hrp:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", hrp)
            return true
        end
    end
    return false
end

-- [[ BUTTONS ]] --

local WideBtn = Instance.new("TextButton", MainFrame)
WideBtn.Size = UDim2.new(0.9, 0, 0, 40)
WideBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
WideBtn.Text = "GIGA LASER: OFF"
WideBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
WideBtn.TextColor3 = Color3.new(1, 1, 1)
WideBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", WideBtn)

WideBtn.MouseButton1Click:Connect(function()
    local active = ToggleGigaWide()
    WideBtn.Text = active and "GIGA LASER: ON" or "GIGA LASER: OFF"
    WideBtn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0)
end)

local SpinBtn = Instance.new("TextButton", MainFrame)
SpinBtn.Size = UDim2.new(0.9, 0, 0, 40)
SpinBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
SpinBtn.Text = "GIGA SPIN: OFF"
SpinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpinBtn.TextColor3 = Color3.new(1, 1, 1)
SpinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", SpinBtn)

SpinBtn.MouseButton1Click:Connect(function()
    local active = ToggleSpin()
    SpinBtn.Text = active and "GIGA SPIN: ON" or "GIGA SPIN: OFF"
    SpinBtn.BackgroundColor3 = active and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(50, 50, 50)
end)

-- Icon Toggle
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0.05, 0, 0.1, 0)
Icon.Image = "rbxassetid://6031280227"
Icon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Icon.Draggable = true
Icon.Active = true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

Icon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
