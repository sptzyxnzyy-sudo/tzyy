-- [[ SPTZYY TOOLBOX FINAL v1.3 MOBILE OPTIMIZED ]] --
-- Cocok untuk Executor Mobile & PC (Delta, Fluxus, Hydrogen, Wave, dll)
-- FIX: Pembenahan sistem drag (Anti-Crash Touch), perbaikan inisialisasi Open Button.

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Membersihkan UI lama jika ada
if CoreGui:FindFirstChild("SptzyyToolboxFinal") then 
    CoreGui.SptzyyToolboxFinal:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyToolboxFinal"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- State Management (Logika Halaman & Data)
local cursors = { [1] = "" } 
local currentPage = 1
local currentKeyword = ""
local isFetching = false
local currentId = ""
local searchMode = "10" -- Default: 10 (Model). Audio adalah 3.

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end

-- ==========================================
-- UTILITY: SMART MOBILE DRAGGABLE SYSTEM
-- ==========================================
local function makeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- OPEN BUTTON (Menggunakan Alternatif Teks "🔍" Jika Gambar Diblokir)
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
OpenBtn.Text = "🔍"
OpenBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 22
OpenBtn.Visible = false -- Menjadi true saat Main Frame ditutup
OpenBtn.Parent = ScreenGui
addCorner(OpenBtn, 10)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(0, 170, 255)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

makeDraggable(OpenBtn)

-- ==========================================
-- MAIN FRAME (300x300)
-- ==========================================
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 300, 0, 300) 
Main.Position = UDim2.new(0.5, -150, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Visible = true -- Pastikan aktif saat pertama disuntik
Main.Parent = ScreenGui
addCorner(Main, 8)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 45)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

makeDraggable(Main)

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Main

-- ==========================================
-- CENTERED HEADER
-- ==========================================
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
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.BackgroundTransparency = 1
Title.Parent = HeaderContainer

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0, 15)
Credit.Position = UDim2.new(0, 0, 0, 30)
Credit.Text = "by @sptzyy"
Credit.Font = Enum.Font.SourceSans
Credit.TextSize = 13
Credit.TextColor3 = Color3.fromRGB(180, 180, 180)
Credit.TextXAlignment = Enum.TextXAlignment.Center
Credit.BackgroundTransparency = 1
Credit.Parent = HeaderContainer

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, 0, 0, 10)
Version.Position = UDim2.new(0, 0, 0, 45)
Version.Text = "version 1.3 (Mobile Fix)"
Version.Font = Enum.Font.SourceSans
Version.TextSize = 10
Version.TextColor3 = Color3.fromRGB(100, 100, 100)
Version.TextXAlignment = Enum.TextXAlignment.Center
Version.BackgroundTransparency = 1
Version.Parent = HeaderContainer

-- ==========================================
-- INPUT & NAVIGATION INTERFACE
-- ==========================================
local PrevBtn = Instance.new("TextButton")
PrevBtn.Size = UDim2.new(0, 25, 0, 25)
PrevBtn.Position = UDim2.new(0, 10, 0, 65)
PrevBtn.Text = "<"
PrevBtn.Font = Enum.Font.SourceSansBold
PrevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PrevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
Input.TextSize = 13
Input.ClearTextOnFocus = false
Input.Parent = Main
addCorner(Input, 4)

local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(0, 25, 0, 25)
ModeBtn.Position = UDim2.new(0, 230, 0, 65)
ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ModeBtn.Text = "🧱" -- Emoticon representasi Blok/Model
ModeBtn.TextSize = 14
ModeBtn.Parent = Main
addCorner(ModeBtn)

local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(0, 25, 0, 25)
NextBtn.Position = UDim2.new(0, 265, 0, 65)
NextBtn.Text = ">"
NextBtn.Font = Enum.Font.SourceSansBold
NextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
NextBtn.Visible = false
NextBtn.Parent = Main
addCorner(NextBtn)

local PageIndicator = Instance.new("TextLabel")
PageIndicator.Size = UDim2.new(1, -20, 0, 15)
PageIndicator.Position = UDim2.new(0, 10, 0, 92)
PageIndicator.Text = "MODE: MODEL"
PageIndicator.TextColor3 = Color3.fromRGB(0, 170, 255)
PageIndicator.Font = Enum.Font.SourceSansBold
PageIndicator.TextSize = 10
PageIndicator.TextXAlignment = Enum.TextXAlignment.Center
PageIndicator.BackgroundTransparency = 1
PageIndicator.Parent = Main

-- Mode Switcher Logic
ModeBtn.MouseButton1Click:Connect(function()
    if searchMode == "10" then
        searchMode = "3"
        PageIndicator.Text = "MODE: AUDIO"
        PageIndicator.TextColor3 = Color3.fromRGB(255, 170, 0)
        ModeBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
        ModeBtn.Text = "🎵"
    else
        searchMode = "10"
        PageIndicator.Text = "MODE: MODEL"
        PageIndicator.TextColor3 = Color3.fromRGB(0, 170, 255)
        ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        ModeBtn.Text = "🧱"
    end
end)

-- ==========================================
-- LIST PAGE & GRID CONTEXT
-- ==========================================
local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -120)
ListPage.Position = UDim2.new(0, 5, 0, 110)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 3
ListPage.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 92, 0, 110)
Grid.CellPadding = UDim2.new(0, 3, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

local WelcomeMsg = Instance.new("TextLabel")
WelcomeMsg.Size = UDim2.new(1, -20, 0, 80)
WelcomeMsg.Position = UDim2.new(0, 10, 0.2, 0)
WelcomeMsg.Text = "Pilih mode (Model/Audio), ketik kata kunci, lalu tekan Enter."
WelcomeMsg.Font = Enum.Font.SourceSansItalic
WelcomeMsg.TextSize = 14
WelcomeMsg.TextColor3 = Color3.fromRGB(140, 140, 140)
WelcomeMsg.TextWrapped = true
WelcomeMsg.BackgroundTransparency = 1
WelcomeMsg.Parent = ListPage

-- ==========================================
-- DETAIL VIEW PAGE
-- ==========================================
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
DetName.Size = UDim2.new(1, -40, 0, 35)
DetName.Position = UDim2.new(0, 20, 0, 145)
DetName.Font = Enum.Font.SourceSansBold
DetName.TextSize = 14
DetName.TextColor3 = Color3.fromRGB(255, 255, 255)
DetName.TextWrapped = true
DetName.BackgroundTransparency = 1
DetName.Parent = DetailPage

local DetCreator = Instance.new("TextLabel")
DetCreator.Size = UDim2.new(0, 160, 0, 20)
DetCreator.Position = UDim2.new(0, 20, 0, 180)
DetCreator.TextSize = 12
DetCreator.TextColor3 = Color3.fromRGB(180, 180, 180)
DetCreator.TextXAlignment = Enum.TextXAlignment.Left
DetCreator.BackgroundTransparency = 1
DetCreator.Parent = DetailPage

local MenuBtn = Instance.new("TextButton")
MenuBtn.Size = UDim2.new(0, 25, 0, 25)
MenuBtn.Position = UDim2.new(1, -40, 0, 178)
MenuBtn.Text = "≡"
MenuBtn.Font = Enum.Font.SourceSansBold
MenuBtn.TextSize = 22
MenuBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MenuBtn.BackgroundTransparency = 1
MenuBtn.Parent = DetailPage

local Dropdown = Instance.new("TextButton")
Dropdown.Size = UDim2.new(0, 80, 0, 25)
Dropdown.Position = UDim2.new(1, -90, 0, 205)
Dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Dropdown.Text = "Copy ID"
Dropdown.Font = Enum.Font.SourceSans
Dropdown.TextSize = 13
Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
Dropdown.Visible = false
Dropdown.ZIndex = 10
Dropdown.Parent = DetailPage
addCorner(Dropdown, 4)

-- ==========================================
-- API CORE METHOD EXECUTOR SECURITY
-- ==========================================
local function httpRequest(opt)
    local f = (syn and syn.request) or (http and http.request) or http_request or request
    if f then
        return f(opt)
    else
        warn("Executor tidak mendukung HTTP Request lokal!")
        return nil
    end
end

local function clearList()
    for _, v in pairs(ListPage:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
end

local function showDetail(data)
    currentId = tostring(data.asset.id)
    
    if searchMode == "3" then
        DetImg.Image = "rbxassetid://10734951121"
    else
        DetImg.Image = "rbxthumb://type=Asset&id="..currentId.."&w=420&h=420"
    end
    
    DetName.Text = data.asset.name
    DetCreator.Text = "by " .. (data.creator and data.creator.name or "Unknown")
    
    Dropdown.Visible = false
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
    clearList()
    WelcomeMsg.Visible = false
    
    local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/"..searchMode.."?limit=30&keyword="..HttpService:UrlEncode(kw)
    if cursor and cursor ~= "" then url = url.."&cursor="..cursor end
    
    local success, res = pcall(function() return httpRequest({Url = url, Method = "GET"}) end)
    
    if success and res and res.StatusCode == 200 then
        local body = HttpService:JSONDecode(res.Body)
        currentPage = pageNum
        cursors[currentPage + 1] = body.nextPageCursor or ""
        
        PrevBtn.Visible = (currentPage > 1)
        NextBtn.Visible = (body.nextPageCursor ~= nil and body.nextPageCursor ~= "")
        
        local labelMode = (searchMode == "10") and "MODELS" or "AUDIO"
        PageIndicator.Text = "MODE: "..labelMode.." | PAGE: "..currentPage
        PageIndicator.Visible = true

        local ids = {}
        for _, v in pairs(body.data) do table.insert(ids, tostring(v.id)) end
        
        if #ids == 0 then
            WelcomeMsg.Text = "Asset tidak ditemukan."
            WelcomeMsg.Visible = true
        else
            local detRes = httpRequest({Url = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="..table.concat(ids, ","), Method = "GET"})
            if detRes and detRes.StatusCode == 200 then
                for _, data in pairs(HttpService:JSONDecode(detRes.Body).data) do
                    local Card = Instance.new("Frame")
                    Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    Card.Parent = ListPage
                    addCorner(Card, 6)
                    
                    local Img = Instance.new("ImageLabel")
                    Img.Size = UDim2.new(1, -10, 0, 70)
                    Img.Position = UDim2.new(0, 5, 0, 5)
                    
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
                    btn.MouseButton1Click:Connect(function() showDetail(data) end)
                end
            end
        end
    else
        WelcomeMsg.Text = "Koneksi API Error atau Executor memblokir HTTP Request."
        WelcomeMsg.Visible = true
    end
    ListPage.CanvasPosition = Vector2.new(0,0)
    ListPage.CanvasSize = UDim2.new(0,0,0,Grid.AbsoluteContentSize.Y + 10)
    isFetching = false
end

-- ==========================================
-- INPUT CORRELATION HANDLER
-- ==========================================
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

BackBtn.MouseButton1Click:Connect(function()
    DetailPage.Visible = false
    HeaderContainer.Visible = true
    Input.Visible = true
    ModeBtn.Visible = true
    PrevBtn.Visible = (currentPage > 1)
    NextBtn.Visible = (cursors[currentPage+1] ~= "")
    PageIndicator.Visible = true
    ListPage.Visible = true
end)

MenuBtn.MouseButton1Click:Connect(function() Dropdown.Visible = not Dropdown.Visible end)
Dropdown.MouseButton1Click:Connect(function()
    local clip = setclipboard or toclipboard or (syn and syn.write_clipboard)
    if clip then
        clip(currentId)
        Dropdown.Text = "Copied!"
    else
        Dropdown.Text = "Not Supported"
    end
    task.wait(1)
    Dropdown.Text = "Copy ID"
    Dropdown.Visible = false
end)
