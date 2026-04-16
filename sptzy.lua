-- [[ PHANTOM STUDIO MOBILE EDITION ]]
-- Theme: Classic Studio (White/Gray)
-- Fitur: Toolbar Atas, Explorer Kanan, Auto-Teleport

local LP = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local currentFolder = workspace

-- Cleanup
if CoreGui:FindFirstChild("PhantomStudio") then CoreGui.PhantomStudio:Destroy() end

local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "PhantomStudio"

-- [[ 1. TOP TOOLBAR (BARIS ATAS) ]]
local Toolbar = Instance.new("Frame", SG)
Toolbar.Size = UDim2.new(1, 0, 0, 50)
Toolbar.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
Toolbar.BorderSizePixel = 1
Toolbar.BorderColor3 = Color3.fromRGB(200, 200, 200)

local Title = Instance.new("TextLabel", Toolbar)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "PHANTOM STUDIO"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(50, 50, 50)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Input Teleport di Toolbar (Modern)
local SearchBox = Instance.new("TextBox", Toolbar)
SearchBox.Size = UDim2.new(0, 200, 0, 30)
SearchBox.Position = UDim2.new(1, -220, 0.5, -15)
SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = " Cari Model & TP..."
SearchBox.Text = ""
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 14
SearchBox.ClearTextOnFocus = true
Instance.new("UIStroke", SearchBox).Color = Color3.fromRGB(200, 200, 200)

-- [[ 2. RIGHT PANEL (EXPLORER) ]]
local RightPanel = Instance.new("Frame", SG)
RightPanel.Size = UDim2.new(0, 250, 1, -50)
RightPanel.Position = UDim2.new(1, -250, 0, 50)
RightPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RightPanel.BorderSizePixel = 1
RightPanel.BorderColor3 = Color3.fromRGB(200, 200, 200)

local ExplorerHeader = Instance.new("TextLabel", RightPanel)
ExplorerHeader.Size = UDim2.new(1, 0, 0, 25)
ExplorerHeader.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
ExplorerHeader.Text = "  Penjelajah (Explorer)"
ExplorerHeader.Font = Enum.Font.SourceSans
ExplorerHeader.TextSize = 14
ExplorerHeader.TextColor3 = Color3.fromRGB(80, 80, 80)
ExplorerHeader.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame", RightPanel)
Scroll.Size = UDim2.new(1, 0, 1, -25)
Scroll.Position = UDim2.new(0, 0, 0, 25)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Tombol Kembali (Back)
local BackBtn = Instance.new("TextButton", RightPanel)
BackBtn.Size = UDim2.new(0, 30, 0, 20)
BackBtn.Position = UDim2.new(1, -35, 0, 2)
BackBtn.Text = "UP"
BackBtn.Font = Enum.Font.SourceSansBold
BackBtn.TextSize = 12
BackBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- [[ 3. CORE LOGIC ]]

local function RefreshExplorer(folder)
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    currentFolder = folder
    ExplorerHeader.Text = "  DIR: " .. folder.Name:upper()
    
    local items = folder:GetChildren()
    for _, v in pairs(items) do
        local btn = Instance.new("TextButton", Scroll)
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BorderSizePixel = 0
        btn.Text = "    " .. v.Name
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.TextColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Ikon Dummy (Warna)
        local Icon = Instance.new("Frame", btn)
        Icon.Size = UDim2.new(0, 14, 0, 14)
        Icon.Position = UDim2.new(0, 5, 0.5, -7)
        Icon.BackgroundColor3 = v:IsA("Folder") and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(150, 255, 150)
        
        btn.MouseButton1Click:Connect(function()
            if #v:GetChildren() > 0 then
                RefreshExplorer(v)
            else
                -- Auto Teleport jika diklik (Part/Model)
                local char = LP.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local targetPos = nil
                    if v:IsA("BasePart") then targetPos = v.CFrame
                    elseif v:IsA("Model") then targetPos = v:GetModelCFrame() end
                    
                    if targetPos then
                        char.HumanoidRootPart.CFrame = targetPos + Vector3.new(0, 5, 0)
                    end
                end
            end
        end)
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, #items * 25)
end

-- Teleport via Input Manual (Search Bar)
SearchBox.FocusLost:Connect(function(enter)
    if enter then
        local name = SearchBox.Text
        local target = workspace:FindFirstChild(name, true)
        if target and LP.Character then
            local cf = target:IsA("Model") and target:GetModelCFrame() or target.CFrame
            LP.Character.HumanoidRootPart.CFrame = cf + Vector3.new(0, 5, 0)
            SearchBox.Text = "Success!"
            task.wait(1)
            SearchBox.Text = ""
        end
    end
end)

BackBtn.MouseButton1Click:Connect(function()
    if currentFolder ~= workspace then RefreshExplorer(currentFolder.Parent) end
end)

RefreshExplorer(workspace)
