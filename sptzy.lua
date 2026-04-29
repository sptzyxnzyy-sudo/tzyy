local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("SptzyyToolboxPro") then 
    CoreGui.SptzyyToolboxPro:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyToolboxPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- State Management
local cursors = { [1] = "" } 
local currentPage = 1
local currentKeyword = ""
local isFetching = false
local currentAssetId = ""

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end

-- ==========================================
-- MAIN FRAME (300x300)
-- ==========================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 300)
Main.Position = UDim2.new(0.5, -150, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
addCorner(Main, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 25
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Text = "SEARCH TOOLBOX"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Main

-- ==========================================
-- INPUT SECTION (DIPERPENDEK) & NAV ICON
-- ==========================================
local Input = Instance.new("TextBox")
Input.Size = UDim2.new(0, 180, 0, 25) -- Ukuran diperpendek
Input.Position = UDim2.new(0, 10, 0, 40)
Input.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Input.PlaceholderText = "Cari asset..."
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.SourceSans
Input.TextSize = 13
Input.ClearTextOnFocus = false
Input.Parent = Main
addCorner(Input, 4)

-- Panah Navigasi di samping Input
local PrevBtn = Instance.new("TextButton")
PrevBtn.Size = UDim2.new(0, 25, 0, 25)
PrevBtn.Position = UDim2.new(0, 200, 0, 40) -- Di samping kanan input
PrevBtn.Text = "<"
PrevBtn.Font = Enum.Font.SourceSansBold
PrevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PrevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PrevBtn.Visible = false -- Sembunyi di awal
PrevBtn.Parent = Main
addCorner(PrevBtn)

local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(0, 25, 0, 25)
NextBtn.Position = UDim2.new(0, 230, 0, 40) -- Di samping panah kiri
NextBtn.Text = ">"
NextBtn.Font = Enum.Font.SourceSansBold
NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NextBtn.Visible = false -- Sembunyi di awal
NextBtn.Parent = Main
addCorner(NextBtn)

-- Info Total & Page
local PageIndicator = Instance.new("TextLabel")
PageIndicator.Size = UDim2.new(1, -20, 0, 20)
PageIndicator.Position = UDim2.new(0, 10, 0, 68)
PageIndicator.Text = ""
PageIndicator.TextColor3 = Color3.fromRGB(150, 150, 150)
PageIndicator.Font = Enum.Font.SourceSans
PageIndicator.TextSize = 10
PageIndicator.TextXAlignment = Enum.TextXAlignment.Left
PageIndicator.BackgroundTransparency = 1
PageIndicator.Parent = Main

-- ==========================================
-- LIST CONTAINER
-- ==========================================
local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -105)
ListPage.Position = UDim2.new(0, 5, 0, 90)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 2
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 92, 0, 110)
Grid.CellPadding = UDim2.new(0, 3, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

-- ==========================================
-- OPEN BUTTON & DETAIL PAGE (LOGIC TETAP SAMA)
-- ==========================================
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
OpenBtn.Image = "rbxassetid://10734950309"
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui
addCorner(OpenBtn, 10)

-- ==========================================
-- CORE SEARCH LOGIC
-- ==========================================
local function httpRequest(opt)
    local f = (syn and syn.request) or (http and http.request) or http_request or request
    return f(opt)
end

local function renderItems(dataList)
    for _, v in pairs(ListPage:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, data in pairs(dataList) do
        local Card = Instance.new("Frame")
        Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Card.Parent = ListPage
        addCorner(Card, 6)
        
        local Img = Instance.new("ImageLabel")
        Img.Size = UDim2.new(1, -10, 0, 70)
        Img.Position = UDim2.new(0, 5, 0, 5)
        Img.Image = "rbxassetid://10734950309" -- Placeholder
        pcall(function() Img.Image = "rbxthumb://type=Asset&id="..data.asset.id.."&w=150&h=150" end)
        Img.BackgroundTransparency = 1
        Img.Parent = Card
        
        local Info = Instance.new("TextLabel")
        Info.Size = UDim2.new(1, -6, 0, 30)
        Info.Position = UDim2.new(0, 3, 0, 78)
        Info.Text = data.asset.name.."\nID: "..data.asset.id
        Info.TextColor3 = Color3.fromRGB(255, 255, 255)
        Info.TextSize = 9
        Info.Font = Enum.Font.SourceSansBold
        Info.TextWrapped = true
        Info.BackgroundTransparency = 1
        Info.Parent = Card
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = Card
        btn.MouseButton1Click:Connect(function() setclipboard(tostring(data.asset.id)) end)
    end
    ListPage.CanvasPosition = Vector2.new(0,0)
    ListPage.CanvasSize = UDim2.new(0,0,0,Grid.AbsoluteContentSize.Y + 10)
end

local function Search(kw, cursor, pageNum)
    if isFetching then return end
    isFetching = true
    
    local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/10?limit=30&keyword="..HttpService:UrlEncode(kw)
    if cursor and cursor ~= "" then url = url.."&cursor="..cursor end
    
    local res = httpRequest({Url = url, Method = "GET"})
    if res and res.StatusCode == 200 then
        local body = HttpService:JSONDecode(res.Body)
        
        currentPage = pageNum
        cursors[currentPage + 1] = body.nextPageCursor or ""
        
        -- Tampilkan Panah dan Info setelah berhasil
        PrevBtn.Visible = (currentPage > 1)
        NextBtn.Visible = (body.nextPageCursor ~= nil and body.nextPageCursor ~= "")
        PageIndicator.Text = "PAGE: "..currentPage.."  |  TOTAL: ".. (body.totalResults or "0")
        
        local ids = {}
        for _, v in pairs(body.data) do table.insert(ids, tostring(v.id)) end
        
        if #ids > 0 then
            local detRes = httpRequest({Url = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="..table.concat(ids, ","), Method = "GET"})
            if detRes and detRes.StatusCode == 200 then
                renderItems(HttpService:JSONDecode(detRes.Body).data)
            end
        end
    end
    isFetching = false
end

-- Events
Input.FocusLost:Connect(function(enter)
    if enter and Input.Text ~= "" then
        currentKeyword = Input.Text
        cursors = { [1] = "" }
        Search(currentKeyword, "", 1)
    end
end)

NextBtn.MouseButton1Click:Connect(function()
    if not isFetching and cursors[currentPage + 1] ~= "" then
        Search(currentKeyword, cursors[currentPage + 1], currentPage + 1)
    end
end)

PrevBtn.MouseButton1Click:Connect(function()
    if not isFetching and currentPage > 1 then
        Search(currentKeyword, cursors[currentPage - 1], currentPage - 1)
    end
end)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenBtn.Visible = false end)
