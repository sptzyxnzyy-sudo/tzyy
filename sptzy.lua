-- RAJUAUTO SCANNER v6.0 - Server-Side Manipulation (Micro-Square)
-- Optimized for Mobile & PC Executors

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup UI lama agar tidak menumpuk
if CoreGui:FindFirstChild("RajuMicro_Server") then
    CoreGui["RajuMicro_Server"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajuMicro_Server"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local selectedRemotes = {}

-- 1. Ikon Toggle (Kecil & Kece)
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 35, 0, 35)
Toggle.Position = UDim2.new(0, 15, 0.4, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Toggle.Text = "🌐"
Toggle.TextColor3 = Color3.fromRGB(0, 255, 180) -- Neon Cyan-Green
Toggle.TextSize = 18
Toggle.Parent = ScreenGui

Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)
local TStroke = Instance.new("UIStroke", Toggle)
TStroke.Color = Color3.fromRGB(0, 255, 180)
TStroke.Thickness = 1.5

-- 2. Main Frame (Persegi Kecil: 180x240)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 240)
Main.Position = UDim2.new(0.5, -90, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Main.Visible = false
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(0, 255, 180)
MStroke.Thickness = 1.2

-- 3. Header (Area Drag)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Header.Parent = Main
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "SERVER PAYLOAD"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.BackgroundTransparency = 1
Title.Parent = Header

-- 4. Scrolling List (List Remote)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(0.9, 0, 0, 130)
Scroll.Position = UDim2.new(0.05, 0, 0, 70)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 180)
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 3)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

-- 5. Tombol Aksi
local function createBtn(txt, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 24)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 9
    b.Parent = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local ScanBtn = createBtn("REFRESH NETWORK", 38, Color3.fromRGB(40, 40, 50))
local ExecBtn = createBtn("SEND TO SERVER", 205, Color3.fromRGB(0, 120, 90))
ExecBtn.Visible = false

--- LOGIKA INTERAKSI ---

-- Dragging (Support Mobile/PC)
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Open/Close
Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Toggle.Text = Main.Visible and "X" or "🌐"
end)

-- Tambah Remote ke List
local function addRemote(remote)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 24)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    b.Text = "  " .. remote.Name
    b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.Font = Enum.Font.Gotham
    b.TextSize = 8
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    b.MouseButton1Click:Connect(function()
        if selectedRemotes[remote] then
            selectedRemotes[remote] = nil
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            b.TextColor3 = Color3.fromRGB(180, 180, 180)
        else
            selectedRemotes[remote] = true
            b.BackgroundColor3 = Color3.fromRGB(0, 80, 60)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        ExecBtn.Visible = next(selectedRemotes) ~= nil
    end)
end

-- Scan Logic
ScanBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    table.clear(selectedRemotes)
    ExecBtn.Visible = false
    
    -- Mencari RemoteEvents secara mendalam
    for _, obj in pairs(game:GetDescendants()) do
        pcall(function()
            if obj:IsA("RemoteEvent") then
                addRemote(obj)
            end
        end)
    end
end)

-- SERVER-SIDE MANIPULATION EXECUTION
-- Mengirim payload manipulasi ke server agar efeknya global
ExecBtn.MouseButton1Click:Connect(function()
    for remote, _ in pairs(selectedRemotes) do
        task.spawn(function()
            pcall(function()
                -- PAYLOAD: Ganti data di bawah sesuai target manipulasi (Global)
                local payload = {
                    [1] = "UpdateStatus", -- Contoh aksi
                    [2] = 999999,         -- Contoh nilai manipulasi
                    ["Manipulated"] = true
                }
                
                -- Kirim ke Server
                remote:FireServer(payload)
                
                -- Efek Visual pada Tombol (Konfirmasi Terkirim)
                ExecBtn.Text = "SENT!"
                task.wait(0.3)
                ExecBtn.Text = "SEND TO SERVER"
            end)
        end)
    end
end)

print("RajuAI Micro-Server Scanner Loaded!")
