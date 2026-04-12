-- RAJUAUTO SCANNER v8.0 [API CONNECT & EXECUTE]
-- Design: Micro Square | Purpose: Server-Side Data Injection

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Membersihkan UI lama jika ada
if CoreGui:FindFirstChild("RajuMicro_V8") then CoreGui["RajuMicro_V8"]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajuMicro_V8"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local apiServerList = {} -- Tabel untuk menampung Remote yang ditemukan

-- [1] Tombol Ikon (Micro Toggle)
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 35, 0, 35)
Toggle.Position = UDim2.new(0, 15, 0.45, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Toggle.Text = "🔗"
Toggle.TextColor3 = Color3.fromRGB(0, 180, 255)
Toggle.TextSize = 18
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Toggle).Color = Color3.fromRGB(0, 180, 255)

-- [2] Main Frame (Persegi Kecil)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 250)
Main.Position = UDim2.new(0.5, -90, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main)
local Border = Instance.new("UIStroke", Main)
Border.Color = Color3.fromRGB(0, 180, 255)
Border.Thickness = 1.2

-- [3] Header (Drag Area)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 25)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "API EXECUTOR v8"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10
Title.BackgroundTransparency = 1

-- [4] Scroll List
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0, 145)
Scroll.Position = UDim2.new(0.05, 0, 0, 65)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 3)

-- [5] Control Buttons
local function createBtn(txt, y, color)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 24)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 9
    Instance.new("UICorner", b)
    return b
end

local ScanBtn = createBtn("SEARCH SERVER API", 35, Color3.fromRGB(30, 30, 40))
local ExecBtn = createBtn("CONNECT & EXECUTE", 215, Color3.fromRGB(0, 80, 150))
ExecBtn.Visible = false

-- LOGIKA ALUR: SEARCH -> CONNECT -> EXECUTE

-- Dragging & Toggle
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
Toggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- 1. SEARCH API (Mencari RemoteEvents)
ScanBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    table.clear(apiServerList)
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local btn = Instance.new("TextButton", Scroll)
            btn.Size = UDim2.new(1, 0, 0, 22)
            btn.Text = "  " .. obj.Name
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            btn.Font = Enum.Font.Gotham; btn.TextSize = 8
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn)
            
            btn.MouseButton1Click:Connect(function()
                apiServerList[obj] = not apiServerList[obj]
                btn.BackgroundColor3 = apiServerList[obj] and Color3.fromRGB(0, 100, 150) or Color3.fromRGB(20, 20, 25)
                btn.TextColor3 = apiServerList[obj] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
                ExecBtn.Visible = true
            end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

-- 2. CONNECT & EXECUTE (Koneksi ke Server & Kirim Payload)
ExecBtn.MouseButton1Click:Connect(function()
    ExecBtn.Text = "CONNECTING..."
    
    for remote, active in pairs(apiServerList) do
        if active then
            task.spawn(function()
                -- ALUR MANIPULASI PAYLOAD
                local payload = {
                    ["Method"] = "Bypass_Execute",
                    ["Request"] = "Server_Side_Data",
                    ["Value"] = math.huge, -- Contoh data manipulasi
                    ["Origin"] = "RajuAuto_V8"
                }
                
                local success, err = pcall(function()
                    -- MENGHUBUNGKAN DAN MENGIRIM KE SERVER
                    remote:FireServer(payload)
                end)
                
                if success then
                    ExecBtn.Text = "API CONNECTED!"
                    ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
                else
                    ExecBtn.Text = "CONN ERROR"
                    ExecBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
                end
                
                task.wait(0.8)
                ExecBtn.Text = "CONNECT & EXECUTE"
                ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 150)
            end)
        end
    end
end)
