-- [[ PHANTOM EXPLORER V7: SMART TP LIST ]]
-- Fitur: Tombol TP di setiap item list (Tanpa Ketik Manual)
-- UI: Modern Neon Cyan, Mobile Optimized

local LP = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local currentFolder = workspace

-- Cleanup UI
if CoreGui:FindFirstChild("PhantomV7") then CoreGui.PhantomV7:Destroy() end

-- [[ UI ROOT ]]
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "PhantomV7"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "EXPLORER: WORKSPACE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local BackBtn = Instance.new("TextButton", Header)
BackBtn.Size = UDim2.new(0, 45, 0, 35)
BackBtn.Position = UDim2.new(1, -55, 0.5, -17)
BackBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BackBtn.Text = "<-"
BackBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
BackBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BackBtn)

-- List
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -80)
Scroll.Position = UDim2.new(0, 10, 0, 65)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 6)

-- [[ LOGIKA REFRESH & SMART BUTTONS ]]
local function RefreshList(folder)
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    currentFolder = folder
    Title.Text = "DIR: " .. string.sub(folder.Name, 1, 18):upper()
    
    local items = folder:GetChildren()
    for _, v in pairs(items) do
        -- Container Baris
        local Row = Instance.new("Frame", Scroll)
        Row.Size = UDim2.new(1, -5, 0, 45)
        Row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Instance.new("UICorner", Row)
        
        -- Tombol Nama (Untuk Navigasi Folder)
        local NameBtn = Instance.new("TextButton", Row)
        NameBtn.Size = UDim2.new(1, -60, 1, 0)
        NameBtn.BackgroundTransparency = 1
        NameBtn.Text = "  [" .. v.ClassName .. "] " .. v.Name
        NameBtn.TextColor3 = v:IsA("Folder") and Color3.fromRGB(0, 255, 255) or Color3.new(0.8, 0.8, 0.8)
        NameBtn.TextXAlignment = Enum.TextXAlignment.Left
        NameBtn.Font = Enum.Font.Gotham
        NameBtn.TextSize = 10
        NameBtn.TextTruncate = Enum.TextTruncate.AtEnd

        -- Tombol Teleport (Di sebelah kanan)
        local TpBtn = Instance.new("TextButton", Row)
        TpBtn.Size = UDim2.new(0, 50, 0, 30)
        TpBtn.Position = UDim2.new(1, -55, 0.5, -15)
        TpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
        TpBtn.Text = "TP"
        TpBtn.TextColor3 = Color3.new(1, 1, 1)
        TpBtn.Font = Enum.Font.GothamBold
        TpBtn.TextSize = 10
        Instance.new("UICorner", TpBtn)

        -- Logika Navigasi Folder
        NameBtn.MouseButton1Click:Connect(function()
            if #v:GetChildren() > 0 then RefreshList(v) end
        end)

        -- Logika Teleport Langsung
        TpBtn.MouseButton1Click:Connect(function()
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local cf = nil
                if v:IsA("BasePart") then
                    cf = v.CFrame
                elseif v:IsA("Model") then
                    cf = v:GetModelCFrame() or (v.PrimaryPart and v.PrimaryPart.CFrame)
                end
                
                if cf then
                    root.CFrame = cf + Vector3.new(0, 4, 0)
                    TpBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    task.wait(0.5)
                    TpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
                end
            end
        end)
        
        -- Sembunyikan tombol TP jika objek bukan part/model
        if not (v:IsA("BasePart") or v:IsA("Model")) then
            TpBtn.Visible = false
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, #items * 51)
end

BackBtn.MouseButton1Click:Connect(function()
    if currentFolder ~= workspace then RefreshList(currentFolder.Parent) end
end)

RefreshList(workspace)
