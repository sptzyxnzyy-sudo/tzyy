local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Bersihkan instance lama jika ada
if CoreGui:FindFirstChild("RobloxToolboxCustom") then
    CoreGui.RobloxToolboxCustom:Destroy()
end

-- ==========================================
-- MAIN UI SETUP (STRUKTUR KOTAK ALAT)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxToolboxCustom"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 480) -- Ukuran vertikal seperti Toolbox
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Warna gelap Studio
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner pembulatan sedikit (khas Modern Studio)
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 4)
MainCorner.Parent = MainFrame

-- ==========================================
-- TOP BAR (KATEGORI TAB)
-- ==========================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabBar

local currentCategory = 10 -- Default: Models

local function CreateTab(name, id)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(0.25, 0, 1, 0)
    Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Tab.BorderSizePixel = 0
    Tab.Text = name
    Tab.TextColor3 = (currentCategory == id) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    Tab.Font = Enum.Font.SourceSansBold
    Tab.TextSize = 13
    Tab.Parent = TabBar
    
    Tab.MouseButton1Click:Connect(function()
        currentCategory = id
        for _, v in pairs(TabBar:GetChildren()) do
            if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

CreateTab("Models", 10)
CreateTab("Images", 11)
CreateTab("Audio", 13)
CreateTab("Meshes", 40)

-- ==========================================
-- SEARCH BAR (INPUT)
-- ==========================================
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -20, 0, 30)
SearchFrame.Position = UDim2.new(0, 10, 0, 45)
SearchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SearchFrame.BorderSizePixel = 1
SearchFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
SearchFrame.Parent = MainFrame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -35, 1, 0)
InputBox.Position = UDim2.new(0, 5, 0, 0)
InputBox.BackgroundTransparency = 1
InputBox.PlaceholderText = "Search..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.ClearTextOnFocus = false
InputBox.Parent = SearchFrame

local SearchIcon = Instance.new("TextButton")
SearchIcon.Size = UDim2.new(0, 30, 1, 0)
SearchIcon.Position = UDim2.new(1, -30, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchIcon.Parent = SearchFrame

-- ==========================================
-- SCROLLING CONTENT
-- ==========================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -90)
ScrollFrame.Position = UDim2.new(0, 5, 0, 85)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
ScrollFrame.Parent = MainFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 135, 0, 160)
Grid.CellPadding = UDim2.new(0, 10, 0, 10)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ScrollFrame

-- ==========================================
-- LOGIC & DATA FETCHING
-- ==========================================
local function httpRequest(options)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    return req(options)
end

local function CreateAssetCard(id, name, creator)
    local Card = Instance.new("Frame")
    Card.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Card.BorderSizePixel = 0
    Card.Parent = ScrollFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Card

    local Image = Instance.new("ImageLabel")
    Image.Size = UDim2.new(1, -10, 0, 100)
    Image.Position = UDim2.new(0, 5, 0, 5)
    Image.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Image.Image = "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
    Image.BorderSizePixel = 0
    Image.Parent = Card

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -10, 0, 30)
    NameLabel.Position = UDim2.new(0, 5, 0, 105)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    NameLabel.TextSize = 12
    NameLabel.TextWrapped = true
    NameLabel.Font = Enum.Font.SourceSans
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Card

    local CreatorLabel = Instance.new("TextLabel")
    CreatorLabel.Size = UDim2.new(1, -10, 0, 15)
    CreatorLabel.Position = UDim2.new(0, 5, 0, 135)
    CreatorLabel.BackgroundTransparency = 1
    CreatorLabel.Text = "by " .. creator
    CreatorLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    CreatorLabel.TextSize = 10
    CreatorLabel.TextXAlignment = Enum.TextXAlignment.Left
    CreatorLabel.Parent = Card

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(1, 0, 1, 0)
    CopyBtn.BackgroundTransparency = 1
    CopyBtn.Text = ""
    CopyBtn.Parent = Card
    
    CopyBtn.MouseButton1Click:Connect(function()
        setclipboard(tostring(id))
        local oldColor = Card.BackgroundColor3
        Card.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(0.2)
        Card.BackgroundColor3 = oldColor
    end)
end

local function Search(keyword)
    -- Bersihkan hasil lama
    for _, v in pairs(ScrollFrame:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
    
    local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/" .. currentCategory .. "?limit=30&keyword=" .. HttpService:UrlEncode(keyword)
    
    local success, response = pcall(function()
        return httpRequest({Url = url, Method = "GET"})
    end)
    
    if success and response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body).data
        local ids = {}
        for _, item in pairs(data) do table.insert(ids, tostring(item.id)) end
        
        local detailUrl = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds=" .. table.concat(ids, ",")
        local detailRes = httpRequest({Url = detailUrl, Method = "GET"})
        
        if detailRes and detailRes.StatusCode == 200 then
            local details = HttpService:JSONDecode(detailRes.Body).data
            for _, item in pairs(details) do
                CreateAssetCard(item.asset.id, item.asset.name, item.creator.name)
            end
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 20)
        end
    end
end

-- Events
SearchIcon.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        Search(InputBox.Text)
        InputBox.Text = "" -- Bersihkan input setelah klik cari
    end
end)

InputBox.FocusLost:Connect(function(enter)
    if enter and InputBox.Text ~= "" then
        Search(InputBox.Text)
        InputBox.Text = "" -- Bersihkan input setelah tekan enter
    end
end)
