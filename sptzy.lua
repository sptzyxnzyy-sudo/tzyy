local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- 1. ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniToolbox"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. Frame Utama (Persegi Kecil)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 320) -- Ukuran lebih kecil & persegi
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 235)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = MainFrame

-- Shadow/Border tipis
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(180, 180, 180)
Stroke.Parent = MainFrame

-- 3. Header (Tempat Drag)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(225, 225, 215)
Header.Parent = MainFrame

local HCorner = Instance.new("UICorner")
HCorner.CornerRadius = UDim.new(0, 6)
HCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "Kotak Alat Mini"
Title.Size = UDim2.new(1, -35, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(50, 50, 50)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 25, 0, 20)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = Header

local CCorner = Instance.new("UICorner")
CCorner.CornerRadius = UDim.new(0, 4)
CCorner.Parent = CloseBtn

-- 4. Input & Search Button (Sejajar)
local SearchContainer = Instance.new("Frame")
SearchContainer.Size = UDim2.new(1, -20, 0, 30)
SearchContainer.Position = UDim2.new(0, 10, 0, 40)
SearchContainer.BackgroundTransparency = 1
SearchContainer.Parent = MainFrame

local SearchBox = Instance.new("TextBox")
SearchBox.PlaceholderText = "Cari model..."
SearchBox.Size = UDim2.new(0.7, -5, 1, 0)
SearchBox.BackgroundColor3 = Color3.new(1, 1, 1)
SearchBox.BorderSizePixel = 0
SearchBox.Text = ""
SearchBox.Parent = SearchContainer

local SCorner = Instance.new("UICorner")
SCorner.CornerRadius = UDim.new(0, 4)
SCorner.Parent = SearchBox

local SearchBtn = Instance.new("TextButton")
SearchBtn.Text = "Cari"
SearchBtn.Size = UDim2.new(0.3, 0, 1, 0)
SearchBtn.Position = UDim2.new(0.7, 0, 0, 0)
SearchBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 250)
SearchBtn.TextColor3 = Color3.new(1, 1, 1)
SearchBtn.Font = Enum.Font.SourceSansBold
SearchBtn.Parent = SearchContainer

local BCorner = Instance.new("UICorner")
BCorner.CornerRadius = UDim.new(0, 4)
BCorner.Parent = SearchBtn

-- 5. Scrolling Hasil (Dikecilkan)
local ItemList = Instance.new("ScrollingFrame")
ItemList.Size = UDim2.new(1, -20, 1, -85)
ItemList.Position = UDim2.new(0, 10, 0, 75)
ItemList.BackgroundTransparency = 1
ItemList.ScrollBarThickness = 3
ItemList.CanvasSize = UDim2.new(0, 0, 0, 0)
ItemList.Parent = MainFrame

local Layout = Instance.new("UIGridLayout")
Layout.CellSize = UDim2.new(0, 120, 0, 140) -- Ukuran card lebih kecil
Layout.Padding = UDim2.new(0, 10, 0, 10)
Layout.Parent = ItemList

-- 6. Logika API & Fungsi
local function searchModels(keyword)
    if keyword == "" then return end
    
    -- Bersihkan list
    for _, child in pairs(ItemList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local cleanKeyword = HttpService:UrlEncode(keyword)
    local url = "https://apis.roproxy.com/toolbox-service/v1/marketplace/10?limit=20&keyword=" .. cleanKeyword
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response then
        local data = HttpService:JSONDecode(response)
        if data and data.data then
            for _, item in pairs(data.data) do
                local Card = Instance.new("Frame")
                Card.BackgroundColor3 = Color3.new(1, 1, 1)
                Card.Parent = ItemList
                
                local Cr = Instance.new("UICorner")
                Cr.CornerRadius = UDim.new(0, 4)
                Cr.Parent = Card

                local Thumb = Instance.new("ImageLabel")
                Thumb.Size = UDim2.new(1, -10, 0, 90)
                Thumb.Position = UDim2.new(0, 5, 0, 5)
                Thumb.BackgroundTransparency = 1
                Thumb.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. item.id .. "&width=150&height=150&format=png"
                Thumb.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Text = item.name
                Label.Size = UDim2.new(1, -10, 0, 35)
                Label.Position = UDim2.new(0, 5, 0, 100)
                Label.TextSize = 10
                Label.TextWrapped = true
                Label.BackgroundTransparency = 1
                Label.Parent = Card
            end
            ItemList.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
        end
    end
end

-- Klik Tombol
SearchBtn.MouseButton1Click:Connect(function()
    searchModels(SearchBox.Text)
end)

-- Support Enter di Keyboard
SearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        searchModels(SearchBox.Text)
    end
end)

-- Close & Drag
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
