local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama jika ada
if CoreGui:FindFirstChild("KotakAlatMarketplace") then
    CoreGui.KotakAlatMarketplace:Destroy()
end

-- UI Setup
local KotakAlat = Instance.new("ScreenGui")
KotakAlat.Name = "KotakAlatMarketplace"
KotakAlat.Parent = CoreGui

-- Frame Utama (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = KotakAlat

-- Header (Bar Judul)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 25)
Header.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "Kotak Alat"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSans
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -25, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() KotakAlat:Destroy() end)

-- Area Pencarian (Input)
local SearchContainer = Instance.new("Frame")
SearchContainer.Size = UDim2.new(1, -10, 0, 30)
SearchContainer.Position = UDim2.new(0, 5, 0, 30)
SearchContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchContainer.BorderColor3 = Color3.fromRGB(200, 200, 200)
SearchContainer.Parent = MainFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -50, 1, 0)
InputBox.PlaceholderText = "Cari di Marketplace..."
InputBox.Text = ""
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 14
InputBox.BackgroundTransparency = 1
InputBox.Parent = SearchContainer

local SearchBtn = Instance.new("TextButton")
SearchBtn.Text = "Cari"
SearchBtn.Size = UDim2.new(0, 45, 1, 0)
SearchBtn.Position = UDim2.new(1, -45, 0, 0)
SearchBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
SearchBtn.BorderSizePixel = 1
SearchBtn.Parent = SearchContainer

-- Scroll Area (Hasil)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -100)
ScrollFrame.Position = UDim2.new(0, 5, 0, 65)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
ScrollFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollFrame
UIList.Padding = UDim.new(0, 2)

-- Tombol Kategori (Bawah)
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 25)
TabFrame.Position = UDim2.new(0, 0, 1, -25)
TabFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
TabFrame.Parent = MainFrame

local function createTab(name, pos, typeId)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 1
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.Parent = TabFrame
    return btn
end

local tabModel = createTab("Model", 0, 10)
local tabAudio = createTab("Suara", 0.25, 13)
local tabDecal = createTab("Gambar", 0.5, 11)
local tabMesh  = createTab("Jala", 0.75, 40)

-- Fungsi Helper Request
local function httpRequest(options)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then return req(options) end
    return nil
end

-- Fungsi Render Item
local function createAssetItem(id, name, creator)
    local ItemFrame = Instance.new("Frame")
    ItemFrame.Size = UDim2.new(1, -10, 0, 60)
    ItemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ItemFrame.BorderColor3 = Color3.fromRGB(230, 230, 230)
    
    local Thumb = Instance.new("ImageLabel")
    Thumb.Size = UDim2.new(0, 50, 0, 50)
    Thumb.Position = UDim2.new(0, 5, 0, 5)
    Thumb.Image = "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
    Thumb.Parent = ItemFrame
    
    local NameLbl = Instance.new("TextLabel")
    NameLbl.Text = name
    NameLbl.Size = UDim2.new(1, -110, 0, 20)
    NameLbl.Position = UDim2.new(0, 60, 0, 5)
    NameLbl.Font = Enum.Font.SourceSansBold
    NameLbl.TextSize = 14
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    NameLbl.BackgroundTransparency = 1
    NameLbl.Parent = ItemFrame
    
    local CreatorLbl = Instance.new("TextLabel")
    CreatorLbl.Text = "Oleh: " .. creator
    CreatorLbl.Size = UDim2.new(1, -110, 0, 15)
    CreatorLbl.Position = UDim2.new(0, 60, 0, 25)
    CreatorLbl.Font = Enum.Font.SourceSans
    CreatorLbl.TextSize = 12
    CreatorLbl.TextColor3 = Color3.fromRGB(100, 100, 100)
    CreatorLbl.TextXAlignment = Enum.TextXAlignment.Left
    CreatorLbl.BackgroundTransparency = 1
    CreatorLbl.Parent = ItemFrame
    
    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Text = "Salin ID"
    CopyBtn.Size = UDim2.new(0, 45, 0, 30)
    CopyBtn.Position = UDim2.new(1, -50, 0, 15)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    CopyBtn.TextSize = 10
    CopyBtn.Parent = ItemFrame
    
    CopyBtn.MouseButton1Click:Connect(function()
        setclipboard(tostring(id))
        CopyBtn.Text = "Salin!"
        task.wait(1)
        CopyBtn.Text = "Salin ID"
    end)
    
    ItemFrame.Parent = ScrollFrame
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

-- Logika Pencarian
local currentCategory = 10

local function searchMarketplace(keyword)
    for _, v in pairs(ScrollFrame:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
    
    local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/" .. currentCategory .. "?limit=30&keyword=" .. HttpService:UrlEncode(keyword)
    
    local res = httpRequest({Url = url, Method = "GET"})
    if res and res.StatusCode == 200 then
        local data = HttpService:JSONDecode(res.Body).data
        local ids = {}
        for _, item in pairs(data) do table.insert(ids, tostring(item.id)) end
        
        local detailUrl = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds=" .. table.concat(ids, ",")
        local detailRes = httpRequest({Url = detailUrl, Method = "GET"})
        
        if detailRes and detailRes.StatusCode == 200 then
            local details = HttpService:JSONDecode(detailRes.Body).data
            for _, item in pairs(details) do
                createAssetItem(item.asset.id, item.asset.name, item.creator.name)
            end
        end
    end
end

-- Events
SearchBtn.MouseButton1Click:Connect(function()
    searchMarketplace(InputBox.Text)
    InputBox.Text = ""
end)

InputBox.FocusLost:Connect(function(enter)
    if enter then SearchBtn.MouseButton1Click:Fire() end
end)

-- Ganti Kategori
local function setCategory(id, btn)
    currentCategory = id
    tabModel.BackgroundColor3 = Color3.fromRGB(255,255,255)
    tabAudio.BackgroundColor3 = Color3.fromRGB(255,255,255)
    tabDecal.BackgroundColor3 = Color3.fromRGB(255,255,255)
    tabMesh.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
end

tabModel.MouseButton1Click:Connect(function() setCategory(10, tabModel) end)
tabAudio.MouseButton1Click:Connect(function() setCategory(13, tabAudio) end)
tabDecal.MouseButton1Click:Connect(function() setCategory(11, tabDecal) end)
tabMesh.MouseButton1Click:Connect(function() setCategory(40, tabMesh) end)

-- Inisialisasi
setCategory(10, tabModel)
