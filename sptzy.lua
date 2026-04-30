local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- PEMBERSIHAN & INISIALISASI
-- ==========================================
if CoreGui:FindFirstChild("SptzyyMultiTool") then 
    CoreGui.SptzyyMultiTool:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyMultiTool"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- State Management
local cursors = { [1] = "" } 
local currentPage = 1
local currentKeyword = ""
local isFetching = false
local currentId = ""
local searchMode = "10" -- "10"=Model, "3"=Audio, "USER"=User

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = obj
end

-- ==========================================
-- UI: MAIN FRAME
-- ==========================================
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 300, 0, 300)
Main.Position = UDim2.new(0.5, -150, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
addCorner(Main, 10)

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Main
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SPTZYY MULTI-TOOL V1.5"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Parent = Main

-- Input Area
local Input = Instance.new("TextBox")
Input.Size = UDim2.new(0, 180, 0, 30)
Input.Position = UDim2.new(0.5, -90, 0, 45)
Input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Input.PlaceholderText = "Ketik & Enter..."
Input.Text = ""
Input.TextColor3 = Color3.new(1,1,1)
Input.Font = Enum.Font.SourceSans
Input.Parent = Main
addCorner(Input, 5)

-- Mode Button
local ModeBtn = Instance.new("ImageButton")
ModeBtn.Size = UDim2.new(0, 30, 0, 30)
ModeBtn.Position = UDim2.new(1, -45, 0, 45)
ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
ModeBtn.Image = "rbxassetid://10734950309"
ModeBtn.Parent = Main
addCorner(ModeBtn, 5)

local Indicator = Instance.new("TextLabel")
Indicator.Size = UDim2.new(1, 0, 0, 20)
Indicator.Position = UDim2.new(0, 0, 0, 75)
Indicator.Text = "MODE: MODEL"
Indicator.TextColor3 = Color3.fromRGB(0, 160, 255)
Indicator.Font = Enum.Font.SourceSansBold
Indicator.TextSize = 10
Indicator.BackgroundTransparency = 1
Indicator.Parent = Main

-- Navigasi Halaman
local PrevBtn = Instance.new("TextButton")
PrevBtn.Size = UDim2.new(0, 30, 0, 30)
PrevBtn.Position = UDim2.new(0, 10, 0, 45)
PrevBtn.Text = "<"
PrevBtn.TextColor3 = Color3.new(1,1,1)
PrevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PrevBtn.Visible = false
PrevBtn.Parent = Main
addCorner(PrevBtn)

local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(0, 30, 0, 30)
NextBtn.Position = UDim2.new(1, -45, 0, 45) -- Akan tumpang tindih dengan mode jika aktif
NextBtn.Text = ">"
NextBtn.TextColor3 = Color3.new(1,1,1)
NextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NextBtn.Visible = false
NextBtn.Parent = Main
addCorner(NextBtn)

-- ==========================================
-- UI: LIST & DETAIL
-- ==========================================
local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -105)
ListPage.Position = UDim2.new(0, 5, 0, 100)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 2
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 90, 0, 110)
Grid.CellPadding = UDim2.new(0, 5, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

local DetailPage = Instance.new("Frame")
DetailPage.Size = UDim2.new(1, 0, 1, -40)
DetailPage.Position = UDim2.new(0, 0, 0, 40)
DetailPage.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DetailPage.Visible = false
DetailPage.Parent = Main
addCorner(DetailPage)

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 35, 0, 35)
BackBtn.Text = "←"
BackBtn.Font = Enum.Font.SourceSansBold
BackBtn.TextSize = 25
BackBtn.TextColor3 = Color3.new(1,1,1)
BackBtn.BackgroundTransparency = 1
BackBtn.Parent = DetailPage

local GroupScroll = Instance.new("ScrollingFrame")
GroupScroll.Size = UDim2.new(1, -20, 0, 100)
GroupScroll.Position = UDim2.new(0, 10, 0, 155)
GroupScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
GroupScroll.ScrollBarThickness = 2
GroupScroll.Visible = false
GroupScroll.Parent = DetailPage
addCorner(GroupScroll)

-- ==========================================
-- CORE LOGIC (HTTP & SEARCH)
-- ==========================================
local function request(options)
    local fn = (syn and syn.request) or (http and http.request) or http_request or request or fluxus.request
    return fn(options)
end

ModeBtn.MouseButton1Click:Connect(function()
    if isFetching then return end
    if searchMode == "10" then
        searchMode = "3"
        Indicator.Text = "MODE: AUDIO"; Indicator.TextColor3 = Color3.fromRGB(255, 160, 0)
        ModeBtn.BackgroundColor3 = Color3.fromRGB(255, 160, 0); ModeBtn.Image = "rbxassetid://10734951121"
    elseif searchMode == "3" then
        searchMode = "USER"
        Indicator.Text = "MODE: USER"; Indicator.TextColor3 = Color3.fromRGB(0, 255, 120)
        ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100); ModeBtn.Image = "rbxassetid://10734951437"
    else
        searchMode = "10"
        Indicator.Text = "MODE: MODEL"; Indicator.TextColor3 = Color3.fromRGB(0, 160, 255)
        ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255); ModeBtn.Image = "rbxassetid://10734950309"
    end
end)

local function showDetail(id, name, isUser)
    currentId = tostring(id)
    DetailPage.Visible = true
    ListPage.Visible = false
    ModeBtn.Visible = false
    
    -- Bersihkan detail sebelumnya
    for _, v in pairs(DetailPage:GetChildren()) do 
        if v.Name == "Dynamic" then v:Destroy() end 
    end
    for _, v in pairs(GroupScroll:GetChildren()) do 
        if v:IsA("TextLabel") then v:Destroy() end 
    end

    local img = Instance.new("ImageLabel", DetailPage)
    img.Name = "Dynamic"; img.Size = UDim2.new(0, 80, 0, 80); img.Position = UDim2.new(0.5, -40, 0, 10)
    addCorner(img)

    local title = Instance.new("TextLabel", DetailPage)
    title.Name = "Dynamic"; title.Size = UDim2.new(1, -20, 0, 40); title.Position = UDim2.new(0, 10, 0, 95)
    title.Text = name; title.TextColor3 = Color3.new(1,1,1); title.TextWrapped = true; title.BackgroundTransparency = 1

    local copy = Instance.new("TextButton", DetailPage)
    copy.Name = "Dynamic"; copy.Size = UDim2.new(0, 100, 0, 25); copy.Position = UDim2.new(0.5, -50, 0, 125)
    copy.BackgroundColor3 = Color3.fromRGB(60, 60, 60); copy.Text = "Copy ID"; copy.TextColor3 = Color3.new(1,1,1)
    addCorner(copy)
    copy.MouseButton1Click:Connect(function() setclipboard(currentId); copy.Text = "Copied!" end)

    if isUser then
        img.Image = "rbxthumb://type=AvatarHeadShot&id="..id.."&w=150&h=150"
        GroupScroll.Visible = true
        local success, res = pcall(function() 
            return request({Url = "https://groups.roblox.com/v1/users/"..id.."/groups/roles", Method = "GET"}) 
        end)
        if success and res.StatusCode == 200 then
            local gData = HttpService:JSONDecode(res.Body).data
            for i, v in pairs(gData) do
                local gl = Instance.new("TextLabel", GroupScroll)
                gl.Size = UDim2.new(1, -10, 0, 20); gl.Position = UDim2.new(0, 5, 0, (i-1)*20)
                gl.Text = "• "..v.group.name.." ("..v.role.name..")"
                gl.TextColor3 = Color3.new(0.8,0.8,0.8); gl.TextSize = 10; gl.TextXAlignment = "Left"; gl.BackgroundTransparency = 1
            end
            GroupScroll.CanvasSize = UDim2.new(0,0,0, #gData * 20)
        end
    else
        img.Image = (searchMode == "3") and "rbxassetid://10734951121" or "rbxthumb://type=Asset&id="..id.."&w=150&h=150"
        GroupScroll.Visible = false
    end
end

local function Search(kw, cursor, pageNum)
    if isFetching or kw == "" then return end
    isFetching = true
    
    -- Clear list
    for _, v in pairs(ListPage:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    local url = ""
    if searchMode == "USER" then
        url = "https://apis.roblox.com/search-api/omni-search?searchQuery="..HttpService:UrlEncode(kw).."&verticalType=user"
        NextBtn.Visible = false
        PrevBtn.Visible = false
        ModeBtn.Visible = true
    else
        url = "https://apis.roblox.com/toolbox-service/v1/marketplace/"..searchMode.."?limit=30&keyword="..HttpService:UrlEncode(kw)
        if cursor and cursor ~= "" then url = url.."&cursor="..cursor end
    end

    local success, res = pcall(function() return request({Url = url, Method = "GET"}) end)
    
    if success and res.StatusCode == 200 then
        local body = HttpService:JSONDecode(res.Body)
        
        if searchMode == "USER" then
            local contents = body.searchResults[1] and body.searchResults[1].contents or {}
            for _, u in pairs(contents) do
                local card = Instance.new("Frame", ListPage)
                card.BackgroundColor3 = Color3.fromRGB(30, 30, 30); addCorner(card)
                local btn = Instance.new("TextButton", card)
                btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""
                local i = Instance.new("ImageLabel", card)
                i.Size = UDim2.new(1,-10,0,75); i.Position = UDim2.new(0,5,0,5); addCorner(i)
                i.Image = "rbxthumb://type=AvatarHeadShot&id="..u.contentId.."&w=150&h=150"
                local t = Instance.new("TextLabel", card)
                t.Size = UDim2.new(1,0,0,25); t.Position = UDim2.new(0,0,0,80); t.Text = u.username
                t.TextColor3 = Color3.new(1,1,1); t.TextSize = 10; t.BackgroundTransparency = 1
                btn.MouseButton1Click:Connect(function() showDetail(u.contentId, u.username, true) end)
            end
        else
            currentPage = pageNum
            cursors[currentPage + 1] = body.nextPageCursor or ""
            NextBtn.Visible = (body.nextPageCursor ~= nil and body.nextPageCursor ~= "")
            PrevBtn.Visible = (currentPage > 1)
            ModeBtn.Visible = not NextBtn.Visible -- Sembunyikan mode jika tombol next muncul agar tidak tumpang tindih
            
            for _, asset in pairs(body.data) do
                local card = Instance.new("Frame", ListPage)
                card.BackgroundColor3 = Color3.fromRGB(30, 30, 30); addCorner(card)
                local btn = Instance.new("TextButton", card)
                btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""
                local i = Instance.new("ImageLabel", card)
                i.Size = UDim2.new(1,-10,0,75); i.Position = UDim2.new(0,5,0,5); addCorner(i)
                i.Image = (searchMode == "3") and "rbxassetid://10734951121" or "rbxthumb://type=Asset&id="..asset.id.."&w=150&h=150"
                local t = Instance.new("TextLabel", card)
                t.Size = UDim2.new(1,0,0,25); t.Position = UDim2.new(0,0,0,80); t.Text = asset.name
                t.TextColor3 = Color3.new(1,1,1); t.TextSize = 8; t.TextWrapped = true; t.BackgroundTransparency = 1
                btn.MouseButton1Click:Connect(function() showDetail(asset.id, asset.name, false) end)
            end
        end
    end
    isFetching = false
end

-- ==========================================
-- CONNECTIONS
-- ==========================================
Input.FocusLost:Connect(function(enter)
    if enter then
        currentKeyword = Input.Text
        currentPage = 1
        Search(currentKeyword, "", 1)
    end
end)

BackBtn.MouseButton1Click:Connect(function()
    DetailPage.Visible = false
    ListPage.Visible = true
    ModeBtn.Visible = true
end)

NextBtn.MouseButton1Click:Connect(function()
    Search(currentKeyword, cursors[currentPage + 1], currentPage + 1)
end)

PrevBtn.MouseButton1Click:Connect(function()
    Search(currentKeyword, cursors[currentPage - 1], currentPage - 1)
end)
