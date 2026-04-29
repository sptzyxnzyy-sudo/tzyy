local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

-- Cleanup UI & Sound Lama
if CoreGui:FindFirstChild("SptzyyToolboxFinal") then CoreGui.SptzyyToolboxFinal:Destroy() end
local oldSound = SoundService:FindFirstChild("SptzyyPreview")
if oldSound then oldSound:Destroy() end

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
local searchMode = "10" -- 10: Model, 3: Audio

-- Preview Sound Setup
local PreviewSound = Instance.new("Sound")
PreviewSound.Name = "SptzyyPreview"
PreviewSound.Parent = SoundService

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end

-- ==========================================
-- OPEN BUTTON
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
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Main

-- HEADER & CREDIT
local HeaderContainer = Instance.new("Frame")
HeaderContainer.Size = UDim2.new(1, 0, 0, 60)
HeaderContainer.BackgroundTransparency = 1
HeaderContainer.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Text = "SEARCH TOOLBOX"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = HeaderContainer

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0, 15)
Credit.Position = UDim2.new(0, 0, 0, 30)
Credit.Text = "by @sptzyy"
Credit.Font = Enum.Font.SourceSans
Credit.TextSize = 13
Credit.TextColor3 = Color3.fromRGB(180, 180, 180)
Credit.BackgroundTransparency = 1
Credit.Parent = HeaderContainer

-- SYMMETRICAL INPUT AREA
local PrevBtn = Instance.new("TextButton")
PrevBtn.Size = UDim2.new(0, 25, 0, 25)
PrevBtn.Position = UDim2.new(0, 10, 0, 65)
PrevBtn.Text = "<"
PrevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PrevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PrevBtn.Visible = false
PrevBtn.Parent = Main
addCorner(PrevBtn)

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(0, 180, 0, 25)
Input.Position = UDim2.new(0, 45, 0, 65)
Input.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Input.PlaceholderText = "Cari asset..."
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.SourceSans
Input.Parent = Main
addCorner(Input, 4)

local ModeBtn = Instance.new("ImageButton")
ModeBtn.Size = UDim2.new(0, 25, 0, 25)
ModeBtn.Position = UDim2.new(0, 230, 0, 65)
ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ModeBtn.Image = "rbxassetid://10734950309"
ModeBtn.Parent = Main
addCorner(ModeBtn)

local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(0, 25, 0, 25)
NextBtn.Position = UDim2.new(0, 265, 0, 65)
NextBtn.Text = ">"
NextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NextBtn.Visible = false
NextBtn.Parent = Main
addCorner(NextBtn)

local PageIndicator = Instance.new("TextLabel")
PageIndicator.Size = UDim2.new(1, 0, 0, 15)
PageIndicator.Position = UDim2.new(0, 0, 0, 92)
PageIndicator.Text = "MODE: MODEL"
PageIndicator.TextColor3 = Color3.fromRGB(0, 170, 255)
PageIndicator.Font = Enum.Font.SourceSansBold
PageIndicator.TextSize = 10
PageIndicator.BackgroundTransparency = 1
PageIndicator.Parent = Main

-- LIST & GRID
local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -120)
ListPage.Position = UDim2.new(0, 5, 0, 110)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 2
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 92, 0, 110)
Grid.CellPadding = UDim2.new(0, 3, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

local WelcomeMsg = Instance.new("TextLabel")
WelcomeMsg.Size = UDim2.new(1, -20, 0, 80)
WelcomeMsg.Position = UDim2.new(0, 10, 0.2, 0)
WelcomeMsg.Text = "Ketik keyword, lalu tekan Enter."
WelcomeMsg.Font = Enum.Font.SourceSansItalic
WelcomeMsg.TextColor3 = Color3.fromRGB(100, 100, 100)
WelcomeMsg.BackgroundTransparency = 1
WelcomeMsg.Parent = ListPage

-- DETAIL PAGE
local DetailPage = Instance.new("Frame")
DetailPage.Size = UDim2.new(1, 0, 1, -35)
DetailPage.Position = UDim2.new(0, 0, 0, 35)
DetailPage.BackgroundColor3 = Main.BackgroundColor3
DetailPage.Visible = false
DetailPage.Parent = Main
addCorner(DetailPage, 8)

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 30, 0, 30)
BackBtn.Position = UDim2.new(0, 5, 0, 5)
BackBtn.Text = "←"
BackBtn.Font = Enum.Font.SourceSansBold
BackBtn.TextSize = 25
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.BackgroundTransparency = 1
BackBtn.Parent = DetailPage

local DetImg = Instance.new("ImageLabel")
DetImg.Size = UDim2.new(0, 120, 0, 120)
DetImg.Position = UDim2.new(0.5, -60, 0, 20)
DetImg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
DetImg.Parent = DetailPage
addCorner(DetImg)

local DetName = Instance.new("TextLabel")
DetName.Size = UDim2.new(1, -40, 0, 45)
DetName.Position = UDim2.new(0, 20, 0, 140)
DetName.Font = Enum.Font.SourceSansBold
DetName.TextColor3 = Color3.fromRGB(255, 255, 255)
DetName.TextWrapped = true
DetName.BackgroundTransparency = 1
DetName.Parent = DetailPage

-- DETAIL ACTIONS (NEW)
local ActionFrame = Instance.new("Frame")
ActionFrame.Size = UDim2.new(1, 0, 0, 30)
ActionFrame.Position = UDim2.new(0, 0, 0, 190)
ActionFrame.BackgroundTransparency = 1
ActionFrame.Parent = DetailPage

local ActionLayout = Instance.new("UIListLayout")
ActionLayout.FillDirection = Enum.FillDirection.Horizontal
ActionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ActionLayout.Padding = UDim.new(0, 10)
ActionLayout.Parent = ActionFrame

local function createBtn(txt, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 80, 0, 25)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.Parent = ActionFrame
    addCorner(b, 4)
    return b
end

local CopyBtn = createBtn("Copy ID", Color3.fromRGB(45, 45, 45))
local PlayBtn = createBtn("Play", Color3.fromRGB(0, 170, 100))

-- ==========================================
-- LOGIC
-- ==========================================
local function httpRequest(opt)
    local f = (syn and syn.request) or (http and http.request) or http_request or request
    return f(opt)
end

local function showDetail(data)
    currentId = tostring(data.asset.id)
    PreviewSound:Stop()
    
    if searchMode == "3" then
        DetImg.Image = "rbxassetid://10734951121"
        PlayBtn.Visible = true
    else
        DetImg.Image = "rbxthumb://type=Asset&id="..currentId.."&w=420&h=420"
        PlayBtn.Visible = false
    end
    
    DetName.Text = data.asset.name
    ListPage.Visible = false
    HeaderContainer.Visible = false
    Input.Visible = false
    PrevBtn.Visible = false
    ModeBtn.Visible = false
    NextBtn.Visible = false
    PageIndicator.Visible = false
    DetailPage.Visible = true
end

local function Search(kw, cursor, pageNum)
    if isFetching then return end
    isFetching = true
    WelcomeMsg.Text = "Searching..."
    WelcomeMsg.Visible = true
    
    for _, v in pairs(ListPage:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/"..searchMode.."?limit=30&keyword="..HttpService:UrlEncode(kw)
    if cursor and cursor ~= "" then url = url.."&cursor="..cursor end
    
    local success, res = pcall(function() return httpRequest({Url = url, Method = "GET"}) end)
    
    if success and res and res.StatusCode == 200 then
        local body = HttpService:JSONDecode(res.Body)
        currentPage = pageNum
        cursors[currentPage + 1] = body.nextPageCursor or ""
        
        PrevBtn.Visible = (currentPage > 1)
        NextBtn.Visible = (body.nextPageCursor ~= nil and body.nextPageCursor ~= "")
        
        local ids = {}
        for _, v in pairs(body.data) do table.insert(ids, tostring(v.id)) end
        
        if #ids > 0 then
            local detRes = httpRequest({Url = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="..table.concat(ids, ","), Method = "GET"})
            if detRes and detRes.StatusCode == 200 then
                WelcomeMsg.Visible = false
                for _, data in pairs(HttpService:JSONDecode(detRes.Body).data) do
                    local Card = Instance.new("Frame")
                    Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    Card.Parent = ListPage
                    addCorner(Card, 6)
                    
                    local Img = Instance.new("ImageLabel")
                    Img.Size = UDim2.new(1, -10, 0, 70)
                    Img.Position = UDim2.new(0, 5, 0, 5)
                    Img.Image = (searchMode == "3") and "rbxassetid://10734951121" or "rbxthumb://type=Asset&id="..data.asset.id.."&w=150&h=150"
                    Img.BackgroundTransparency = 1
                    Img.Parent = Card
                    
                    local Ttl = Instance.new("TextLabel")
                    Ttl.Size = UDim2.new(1, -6, 0, 25)
                    Ttl.Position = UDim2.new(0, 3, 0, 78)
                    Ttl.Text = data.asset.name
                    Ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Ttl.TextSize = 8
                    Ttl.Font = Enum.Font.SourceSansBold
                    Ttl.TextWrapped = true
                    Ttl.BackgroundTransparency = 1
                    Ttl.Parent = Card
                    
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, 0, 1, 0)
                    btn.BackgroundTransparency = 1
                    btn.Text = ""
                    btn.Parent = Card
                    btn.MouseButton1Click:Connect(function() showDetail(data) end)
                end
            end
        else
            WelcomeMsg.Text = "No results found."
        end
    end
    ListPage.CanvasPosition = Vector2.new(0,0)
    ListPage.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 10)
    isFetching = false
end

-- ==========================================
-- CONNECTIONS
-- ==========================================
ModeBtn.MouseButton1Click:Connect(function()
    if searchMode == "10" then
        searchMode = "3"; PageIndicator.Text = "MODE: AUDIO"; PageIndicator.TextColor3 = Color3.fromRGB(255, 170, 0)
        ModeBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0); ModeBtn.Image = "rbxassetid://10734951121"
    else
        searchMode = "10"; PageIndicator.Text = "MODE: MODEL"; PageIndicator.TextColor3 = Color3.fromRGB(0, 170, 255)
        ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); ModeBtn.Image = "rbxassetid://10734950309"
    end
end)

Input.FocusLost:Connect(function(e) if e and Input.Text ~= "" then currentKeyword = Input.Text; cursors={[1]=""}; Search(currentKeyword, "", 1) end end)
NextBtn.MouseButton1Click:Connect(function() Search(currentKeyword, cursors[currentPage+1], currentPage+1) end)
PrevBtn.MouseButton1Click:Connect(function() Search(currentKeyword, cursors[currentPage-1], currentPage-1) end)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true; PreviewSound:Stop() end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)
BackBtn.MouseButton1Click:Connect(function() DetailPage.Visible = false; HeaderContainer.Visible = true; Input.Visible = true; ModeBtn.Visible = true; ListPage.Visible = true; PageIndicator.Visible = true; PreviewSound:Stop() end)

CopyBtn.MouseButton1Click:Connect(function() setclipboard(currentId); CopyBtn.Text = "Copied!"; task.wait(1); CopyBtn.Text = "Copy ID" end)

PlayBtn.MouseButton1Click:Connect(function()
    if PlayBtn.Text == "Play" then
        PreviewSound.SoundId = "rbxassetid://"..currentId
        PreviewSound:Play()
        PlayBtn.Text = "Stop"
        PlayBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        PreviewSound:Stop()
        PlayBtn.Text = "Play"
        PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    end
end)
