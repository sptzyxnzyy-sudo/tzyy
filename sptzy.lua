local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- 1. Inisialisasi Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToolboxGui"
ScreenGui.Parent = game.CoreGui -- Gunakan CoreGui agar tidak hilang saat mati (untuk executor)
ScreenGui.ResetOnSpawn = false

-- 2. Frame Utama (Kotak Alat)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true -- Fitur geser dasar (deprecated tapi efektif di executor)
MainFrame.Parent = ScreenGui

-- 3. Header / Judul
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Kotak Alat"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Header

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- 4. Input Pencarian
local SearchBox = Instance.new("TextBox")
SearchBox.PlaceholderText = "nama keyword..."
SearchBox.Size = UDim2.new(0.7, -10, 0, 35)
SearchBox.Position = UDim2.new(0, 5, 0, 40)
SearchBox.Parent = MainFrame

local SearchBtn = Instance.new("TextButton")
SearchBtn.Text = "Dapatkan"
SearchBtn.Size = UDim2.new(0.3, -5, 0, 35)
SearchBtn.Position = UDim2.new(0.7, 0, 0, 40)
SearchBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchBtn.Parent = MainFrame

-- 5. Area Hasil (Scrolling Frame)
local ItemList = Instance.new("ScrollingFrame")
ItemList.Size = UDim2.new(1, -10, 1, -85)
ItemList.Position = UDim2.new(0, 5, 0, 80)
ItemList.CanvasSize = UDim2.new(0, 0, 0, 0)
ItemList.ScrollBarThickness = 6
ItemList.Parent = MainFrame

local Layout = Instance.new("UIGridLayout")
Layout.Parent = ItemList
Layout.CellSize = UDim2.new(0, 135, 0, 150)
Layout.Padding = UDim2.new(0, 5, 0, 5)

-- 6. Logika Mengambil Data API
local function searchModels(keyword)
    -- Membersihkan hasil lama
    for _, child in pairs(ItemList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/10?limit=30&pageNumber=0&keyword=" .. keyword
    
    -- Catatan: Di executor, HttpService:GetAsync biasanya dibatasi. 
    -- Kebanyakan executor menggunakan fungsi custom seperti 'request' atau 'http_get'.
    local success, response = pcall(function()
        -- Gunakan fungsi request executor jika ada, jika tidak pakai standard (mungkin butuh proxy)
        return game:HttpGet(url) 
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        for _, item in pairs(data.data) do
            -- Frame Item
            local ItemFrame = Instance.new("Frame")
            ItemFrame.BackgroundColor3 = Color3.new(1, 1, 1)
            ItemFrame.Parent = ItemList

            -- Thumbnail
            local Thumb = Instance.new("ImageLabel")
            Thumb.Size = UDim2.new(1, 0, 0, 100)
            Thumb.Image = "rbxassetid://" .. (item.assetId or 0) -- Simulasi thumb
            Thumb.Parent = ItemFrame

            -- Judul & Pembuat
            local Label = Instance.new("TextLabel")
            Label.Text = item.name .. "\noleh " .. (item.creatorName or "Unknown")
            Label.Size = UDim2.new(1, 0, 0, 50)
            Label.Position = UDim2.new(0, 0, 0, 100)
            Label.TextWrapped = true
            Label.TextSize = 12
            Label.Parent = ItemFrame
        end
        ItemList.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    else
        warn("Gagal mengambil data: " .. tostring(response))
    end
end

SearchBtn.MouseButton1Click:Connect(function()
    searchModels(SearchBox.Text)
end)

-- Fitur Toggle (Tekan "K" untuk buka/tutup kembali)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
