local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

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
local searchMode = "10" 

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end

-- ==========================================
-- MAIN FRAME (Pembaruan: 150x150)
-- ==========================================
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 150, 0, 150) 
Main.Position = UDim2.new(0.5, -75, 0.5, -75)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
addCorner(Main, 8)

-- ==========================================
-- LOADING ANIMATION (Fitur Baru)
-- ==========================================
local LoadingIcon = Instance.new("ImageLabel")
LoadingIcon.Size = UDim2.new(0, 30, 0, 30)
LoadingIcon.Position = UDim2.new(0.5, -15, 0.5, -15)
LoadingIcon.BackgroundTransparency = 1
LoadingIcon.Image = "rbxassetid://6031082988" -- Ikon putar/loading
LoadingIcon.ImageColor3 = Color3.fromRGB(0, 170, 255)
LoadingIcon.Visible = false
LoadingIcon.ZIndex = 20
LoadingIcon.Parent = Main

local rotateAnim = TweenService:Create(LoadingIcon, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})

local function setLoader(state)
    if state then
        LoadingIcon.Visible = true
        rotateAnim:Play()
    else
        LoadingIcon.Visible = false
        rotateAnim:Stop()
    end
end

-- ==========================================
-- UI ELEMENTS (Disesuaikan untuk 150x150)
-- ==========================================
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -22, 0, 2)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Main

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -20, 0, 20)
Input.Position = UDim2.new(0, 10, 0, 25)
Input.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Input.PlaceholderText = "Search..."
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextSize = 12
Input.Parent = Main
addCorner(Input, 4)

local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -55)
ListPage.Position = UDim2.new(0, 5, 0, 50)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 2
ListPage.CanvasSize = UDim2.new(0,0,0,0)
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 65, 0, 75)
Grid.CellPadding = UDim2.new(0, 5, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

-- ==========================================
-- SEARCH LOGIC WITH LOADING
-- ==========================================
local function httpRequest(opt)
    local f = (syn and syn.request) or (http and http.request) or http_request or request
    return f(opt)
end

local function Search(kw, cursor, pageNum)
    if isFetching then return end
    isFetching = true
    setLoader(true) -- Mulai Animasi
    
    -- Bersihkan List
    for _, v in pairs(ListPage:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/10?limit=10&keyword="..HttpService:UrlEncode(kw)
    if cursor and cursor ~= "" then url = url.."&cursor="..cursor end
    
    task.spawn(function()
        local success, res = pcall(function() return httpRequest({Url = url, Method = "GET"}) end)
        
        if success and res and res.StatusCode == 200 then
            local body = HttpService:JSONDecode(res.Body)
            local ids = {}
            for _, v in pairs(body.data) do table.insert(ids, tostring(v.id)) end
            
            if #ids > 0 then
                local detRes = httpRequest({Url = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="..table.concat(ids, ","), Method = "GET"})
                if detRes and detRes.StatusCode == 200 then
                    for _, data in pairs(HttpService:JSONDecode(detRes.Body).data) do
                        local Card = Instance.new("Frame")
                        Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        Card.Parent = ListPage
                        addCorner(Card, 4)
                        
                        local Img = Instance.new("ImageLabel")
                        Img.Size = UDim2.new(1, 0, 0, 50)
                        Img.Image = "rbxthumb://type=Asset&id="..data.asset.id.."&w=150&h=150"
                        Img.BackgroundTransparency = 1
                        Img.Parent = Card
                        
                        local Info = Instance.new("TextButton")
                        Info.Size = UDim2.new(1, 0, 0, 20)
                        Info.Position = UDim2.new(0, 0, 0, 50)
                        Info.Text = "Copy ID"
                        Info.TextSize = 10
                        Info.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                        Info.TextColor3 = Color3.white
                        Info.Parent = Card
                        addCorner(Info, 4)
                        
                        Info.MouseButton1Click:Connect(function()
                            setclipboard(tostring(data.asset.id))
                            Info.Text = "Copied!"
                            task.wait(1)
                            Info.Text = "Copy ID"
                        end)
                    end
                end
            end
        end
        
        ListPage.CanvasSize = UDim2.new(0,0,0,Grid.AbsoluteContentSize.Y + 10)
        setLoader(false) -- Berhenti Animasi
        isFetching = false
    end)
end

-- ==========================================
-- CONNECTIONS
-- ==========================================
Input.FocusLost:Connect(function(enter)
    if enter and Input.Text ~= "" then
        Search(Input.Text, "", 1)
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
