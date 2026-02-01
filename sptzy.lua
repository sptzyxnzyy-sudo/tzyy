-- [[ SPTZYY PHYSICS REPLICATION - NO REMOTE ]] --
-- Fokus: Server-Sided Replication via Physics & Attachments

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [[ 🖥️ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "SPTZYY PHYSICAL FE"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.Code
Instance.new("UICorner", Title)

-- [[ ⚙️ REAL-REPLICATION LOGIC ]] --

-- Fitur 1: Lebarkan Item/Avatar (Replicated via Hat/Tool)
-- Catatan: Mengubah Size Part karakter langsung tanpa Remote seringkali ter-reset, 
-- tapi mengubah posisi Mesh/Attachment di Hat/Tool biasanya terlihat orang lain.
local function MakeWide()
    local char = lp.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            -- Kita targetkan Handle Tool atau Hat agar terlihat orang lain
            if v:IsA("BasePart") and (v.Name == "Handle" or v.Parent:IsA("Accessory")) then
                v.Massless = true
                -- Menggunakan Force untuk menarik part ke samping secara fisik
                local thrust = Instance.new("BodyThrust", v)
                thrust.Force = Vector3.new(5000, 0, 0) -- Menarik secara fisik (terlihat server)
                v.Size = v.Size + Vector3.new(20, 0, 0)
            end
        end
    end
end

-- Fitur 2: Spin Kencang (Replicated via AngularVelocity)
-- Ini 100% terlihat orang lain karena kamu pemilik fisik karaktermu.
local spinning = false
local function ToggleSpin()
    spinning = not spinning
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local existing = hrp:FindFirstChild("PhysicsSpin")
        if existing then existing:Destroy() end
        
        if spinning then
            -- AngularVelocity adalah objek Physics yang tereplikasi ke server
            local av = Instance.new("AngularVelocity", hrp)
            av.Name = "PhysicsSpin"
            av.MaxTorque = math.huge
            av.AngularVelocity = Vector3.new(0, 200, 0) -- Sangat Kencang
            
            local att = hrp:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", hrp)
            av.Attachment0 = att
        end
    end
end

-- [[ BUTTONS ]] --

local WideBtn = Instance.new("TextButton", MainFrame)
WideBtn.Size = UDim2.new(0.9, 0, 0, 40)
WideBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
WideBtn.Text = "WIDE PHYSICAL (HATS/TOOLS)"
WideBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
WideBtn.TextColor3 = Color3.new(1, 1, 1)
WideBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", WideBtn)
WideBtn.MouseButton1Click:Connect(MakeWide)

local SpinBtn = Instance.new("TextButton", MainFrame)
SpinBtn.Size = UDim2.new(0.9, 0, 0, 40)
SpinBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
SpinBtn.Text = "SPIN REPLICATED (REAL)"
SpinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpinBtn.TextColor3 = Color3.new(1, 1, 1)
SpinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", SpinBtn)
SpinBtn.MouseButton1Click:Connect(ToggleSpin)

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
