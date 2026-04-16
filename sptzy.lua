-- [[ PHANTOM WORKSPACE EXPLORER ]]
-- Spesialisasi: Scan, Klik, & Navigasi Workspace
-- UI: Modern Neon Cyan Mobile Optimized

local LP = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local currentFolder = workspace

-- Bersihkan UI lama
if CoreGui:FindFirstChild("WorkspaceExplorer") then
    CoreGui.WorkspaceExplorer:Destroy()
end

-- [[ 1. UI DESIGN ]]
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "WorkspaceExplorer"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Position = UDim2.new(0.5, -150, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

-- Header & Navigasi
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "WORKSPACE/"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local BackBtn = Instance.new("TextButton", Header)
BackBtn.Size = UDim2.new(0, 40, 0, 30)
BackBtn.Position = UDim2.new(1, -50, 0.5, -15)
BackBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BackBtn.Text = "<-"
BackBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
BackBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 8)

-- Container List
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -70)
Scroll.Position = UDim2.new(0, 10, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ 2. LOGIKA EXPLORER ]]
local function RefreshList(folder)
    -- Bersihkan list lama
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    currentFolder = folder
    Title.Text = "DIR: " .. string.sub(folder:GetFullName(), 1, 25)
    
    local children = folder:GetChildren()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, #children * 45)

    for i, v in pairs(children) do
        local ItemBtn = Instance.new("TextButton", Scroll)
        ItemBtn.Size = UDim2.new(1, -5, 0, 40)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        ItemBtn.Text = "  [" .. v.ClassName .. "] " .. v.Name
        ItemBtn.TextColor3 = v:IsA("Folder") and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
        ItemBtn.Font = Enum.Font.Gotham
        ItemBtn.TextSize = 12
        ItemBtn.AutoButtonColor = true
        
        Instance.new("UICorner", ItemBtn).CornerRadius = UDim.new(0, 6)
        
        -- Garis tipis pinggir (Neon cyan hanya untuk folder)
        if v:IsA("Folder") or v:IsA("Model") then
            local SideBar = Instance.new("Frame", ItemBtn)
            SideBar.Size = UDim2.new(0, 3, 1, 0)
            SideBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
            SideBar.BorderSizePixel = 0
        end

        ItemBtn.MouseButton1Click:Connect(function()
            if #v:GetChildren() > 0 then
                RefreshList(v)
            else
                -- Notifikasi jika item tidak memiliki isi
                local oldText = ItemBtn.Text
                ItemBtn.Text = "  (No Contents)"
                task.wait(1)
                ItemBtn.Text = oldText
            end
        end)
    end
end

-- [[ 3. INTERAKSI ]]
BackBtn.MouseButton1Click:Connect(function()
    if currentFolder ~= workspace then
        RefreshList(currentFolder.Parent)
    end
end)

-- Inisialisasi awal
RefreshList(workspace)
