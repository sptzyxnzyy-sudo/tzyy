local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Membersihkan UI lama jika ada
if CoreGui:FindFirstChild("SptzyyToolboxFinal") then 
    CoreGui.SptzyyToolboxFinal:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyToolboxFinal"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- State Management
local cursors = { [1] = "" } 
local currentPage = 1
local currentKeyword = ""
local isFetching = false
local currentId = ""
local searchMode = "10" -- Default: Model (10). Audio adalah (3).

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end

-- ==========================================
-- MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 300, 0, 320) -- Tinggi ditambah sedikit untuk info mode
Main.Position = UDim2.new(0.5, -150, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
addCorner(Main, 8)

-- Header Section (Centered)
local HeaderContainer = Instance.new("Frame")
HeaderContainer.Size = UDim2.new(1, 0, 0, 60)
HeaderContainer.BackgroundTransparency = 1
HeaderContainer.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Text = "SPTZYY TOOLBOX"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.BackgroundTransparency = 1
Title.Parent = HeaderContainer

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, 0, 0, 10)
Version.Position = UDim2.new(0, 0, 0, 30)
Version.Text = "Multi-Search v1.1"
Version.Font = Enum.Font.SourceSans
Version.TextSize = 10
Version.TextColor3 = Color3.fromRGB(150, 150, 150)
Version.TextXAlignment = Enum.TextXAlignment.Center
Version.BackgroundTransparency = 1
Version.Parent = HeaderContainer

-- ==========================================
-- INPUT & MODE SELECTION (<- INPUT [ICON] ->)
-- ==========================================
local PrevBtn = Instance.new("TextButton")
PrevBtn.Size = UDim2.new(0, 25, 0, 25)
PrevBtn.Position = UDim2.new(0, 10, 0, 50)
PrevBtn.Text = "<"
PrevBtn.Font = Enum.Font.SourceSansBold
PrevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PrevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PrevBtn.Visible = false
PrevBtn.Parent = Main
addCorner(PrevBtn)

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(0, 180, 0, 25)
Input.Position = UDim2.new(0, 45, 0, 50)
Input.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Input.PlaceholderText = "Cari asset..."
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.SourceSans
Input.TextSize = 13
Input.Parent = Main
addCorner(Input, 4)

-- Tombol Pilihan Fitur (Icon)
local ModeBtn = Instance.new("ImageButton")
ModeBtn.Size = UDim2.new(0, 25, 0, 25)
ModeBtn.Position = UDim2.new(0, 230, 0, 50)
ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ModeBtn.Image = "rbxassetid://10734950309" -- Icon Model
ModeBtn.Parent = Main
addCorner(ModeBtn)

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0, 50, 0, 15)
ModeLabel.Position = UDim2.new(0, 230, 0, 77)
ModeLabel.Text = "MODE: MODEL"
ModeLabel.TextSize = 8
ModeLabel.Font = Enum.Font.SourceSansBold
ModeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Parent = Main

local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(0, 25, 0, 25)
NextBtn.Position = UDim2.new(0, 265, 0, 50)
NextBtn.Text = ">"
NextBtn.Font = Enum.Font.SourceSansBold
NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NextBtn.Visible = false
NextBtn.Parent = Main
addCorner(NextBtn)

-- ==========================================
-- LOGIC: TOGGLE MODE (MODEL/AUDIO)
-- ==========================================
ModeBtn.MouseButton1Click:Connect(function()
    if searchMode == "10" then
        searchMode = "3"
        ModeLabel.Text = "MODE: AUDIO"
        ModeBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
        ModeBtn.Image = "rbxassetid://10734951121" -- Icon Music
    else
        searchMode = "10"
        ModeLabel.Text = "MODE: MODEL"
        ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        ModeBtn.Image = "rbxassetid://10734950309"
    end
end)

-- ==========================================
-- LIST & SCROLLING SECTION
-- ==========================================
local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -135)
ListPage.Position = UDim2.new(0, 5, 0, 100)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 2
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 92, 0, 110)
Grid.CellPadding = UDim2.new(0, 3, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

-- ==========================================
-- SEARCH ENGINE (ALUR SAMA DENGAN API PYTHON)
-- ==========================================
local function httpRequest(opt)
    local f = (syn and syn.request) or (http and http.request) or http_request or request
    return f(opt)
end

local function Search(kw, cursor, pageNum)
    if isFetching then return end
    isFetching = true
    for _, v in pairs(ListPage:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    -- API Alur Dua Tahap (Sama dengan Python Scraper)
    local searchUrl = "https://apis.roblox.com/toolbox-service/v1/marketplace/"..searchMode.."?limit=30&keyword="..HttpService:UrlEncode(kw)
    if cursor and cursor ~= "" then searchUrl = searchUrl.."&cursor="..cursor end
    
    local success, res = pcall(function() return httpRequest({Url = searchUrl, Method = "GET"}) end)
    
    if success and res.StatusCode == 200 then
        local body = HttpService:JSONDecode(res.Body)
        currentPage = pageNum
        cursors[currentPage + 1] = body.nextPageCursor or ""
        
        -- Update Navigasi UI
        PrevBtn.Visible = (currentPage > 1)
        NextBtn.Visible = (body.nextPageCursor ~= nil and body.nextPageCursor ~= "")
        
        local ids = {}
        for _, v in pairs(body.data) do table.insert(ids, tostring(v.id)) end
        
        -- Tahap Detail (Agar dapat Info Creator & Thumbnail)
        local detRes = httpRequest({Url = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="..table.concat(ids, ","), Method = "GET"})
        
        if detRes.StatusCode == 200 then
            local details = HttpService:JSONDecode(detRes.Body).data
            for _, data in pairs(details) do
                local Card = Instance.new("Frame")
                Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Card.Parent = ListPage
                addCorner(Card, 6)
                
                local Img = Instance.new("ImageLabel")
                Img.Size = UDim2.new(1, -10, 0, 70)
                Img.Position = UDim2.new(0, 5, 0, 5)
                -- Logic Thumbnail: Jika audio tampilkan icon musik, jika model tampilkan asset thumb
                if searchMode == "3" then
                    Img.Image = "rbxassetid://10734951121"
                else
                    Img.Image = "rbxthumb://type=Asset&id="..data.asset.id.."&w=150&h=150"
                end
                Img.BackgroundTransparency = 1
                Img.Parent = Card
                
                local Info = Instance.new("TextLabel")
                Info.Size = UDim2.new(1, -6, 0, 30)
                Info.Position = UDim2.new(0, 3, 0, 78)
                Info.Text = data.asset.name.."\nID: "..data.asset.id
                Info.TextColor3 = Color3.fromRGB(255, 255, 255)
                Info.TextSize = 8
                Info.Font = Enum.Font.SourceSansBold
                Info.TextWrapped = true
                Info.BackgroundTransparency = 1
                Info.Parent = Card
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.Parent = Card
                btn.MouseButton1Click:Connect(function()
                    setclipboard(tostring(data.asset.id))
                    local old = Info.Text
                    Info.Text = "COPIED ID!"
                    task.wait(1)
                    Info.Text = old
                end)
            end
        end
    end
    ListPage.CanvasSize = UDim2.new(0,0,0,Grid.AbsoluteContentSize.Y + 10)
    isFetching = false
end

-- ==========================================
-- INPUT TRIGGER
-- ==========================================
Input.FocusLost:Connect(function(enter)
    if enter and Input.Text ~= "" then
        currentKeyword = Input.Text
        cursors = { [1] = "" }
        Search(currentKeyword, "", 1)
    end
end)

-- Navigasi Click
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
