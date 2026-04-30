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
local searchMode = "10" -- 10: Model, 3: Audio

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end

-- ==========================================
-- MAIN FRAME (150x150)
-- ==========================================
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 150, 0, 150) 
Main.Position = UDim2.new(0.5, -75, 0.5, -75)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
addCorner(Main, 8)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = Main

-- ==========================================
-- LOADING ANIMATION
-- ==========================================
local LoadingIcon = Instance.new("ImageLabel")
LoadingIcon.Size = UDim2.new(0, 35, 0, 35)
LoadingIcon.Position = UDim2.new(0.5, -17, 0.5, -17)
LoadingIcon.BackgroundTransparency = 1
LoadingIcon.Image = "rbxassetid://6031082988"
LoadingIcon.ImageColor3 = Color3.fromRGB(0, 170, 255)
LoadingIcon.Visible = false
LoadingIcon.ZIndex = 100
LoadingIcon.Parent = Main

local rotateAnim = TweenService:Create(LoadingIcon, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})

local function setLoader(state)
    if state then
        LoadingIcon.Visible = true
        rotateAnim:Play()
    else
        LoadingIcon.Visible = false
        rotateAnim:Stop()
        LoadingIcon.Rotation = 0
    end
end

-- ==========================================
-- HEADER & CONTROLS
-- ==========================================
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -22, 0, 2)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Main

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -45, 0, 20)
Input.Position = UDim2.new(0, 5, 0, 25)
Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Input.PlaceholderText = "Search..."
Input.Text = ""
Input.TextColor3 = Color3.white
Input.TextSize = 10
Input.Parent = Main
addCorner(Input, 4)

local ModeBtn = Instance.new("ImageButton")
ModeBtn.Size = UDim2.new(0, 20, 0, 20)
ModeBtn.Position = UDim2.new(1, -35, 0, 25)
ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ModeBtn.Image = "rbxassetid://10734950309" -- Model Icon
ModeBtn.Parent = Main
addCorner(ModeBtn)

local NavFrame = Instance.new("Frame")
NavFrame.Size = UDim2.new(1, 0, 0, 15)
NavFrame.Position = UDim2.new(0, 0, 0, 47)
NavFrame.BackgroundTransparency = 1
NavFrame.Parent = Main

local PrevBtn = Instance.new("TextButton")
PrevBtn.Size = UDim2.new(0, 30, 1, 0)
PrevBtn.Position = UDim2.new(0, 5, 0, 0)
PrevBtn.Text = "<<"
PrevBtn.TextSize = 10
PrevBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PrevBtn.TextColor3 = Color3.white
PrevBtn.Visible = false
PrevBtn.Parent = NavFrame
addCorner(PrevBtn)

local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(0, 30, 1, 0)
NextBtn.Position = UDim2.new(1, -35, 0, 0)
NextBtn.Text = ">>"
NextBtn.TextSize = 10
NextBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NextBtn.TextColor3 = Color3.white
NextBtn.Visible = false
NextBtn.Parent = NavFrame
addCorner(NextBtn)

-- ==========================================
-- LIST & GRID
-- ==========================================
local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -70)
ListPage.Position = UDim2.new(0, 5, 0, 65)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 2
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 65, 0, 75)
Grid.CellPadding = UDim2.new(0, 5, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

-- ==========================================
-- LOGIC
-- ==========================================
local function httpRequest(opt)
    local f = (syn and syn.request) or (http and http.request) or http_request or request
    return f(opt)
end

local function Search(kw, cursor, pageNum)
    if isFetching then return end
    isFetching = true
    
    for _, v in pairs(ListPage:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    setLoader(true)
    
    task.spawn(function()
        -- Simulasi loading 10 detik
        task.wait(10)
        
        local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/"..searchMode.."?limit=10&keyword="..HttpService:UrlEncode(kw)
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
                    for _, data in pairs(HttpService:JSONDecode(detRes.Body).data) do
                        local Card = Instance.new("Frame")
                        Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        Card.Parent = ListPage
                        addCorner(Card, 4)
                        
                        local Img = Instance.new("ImageLabel")
                        Img.Size = UDim2.new(1, 0, 0, 50)
                        Img.Image = (searchMode == "3") and "rbxassetid://10734951121" or "rbxthumb://type=Asset&id="..data.asset.id.."&w=150&h=150"
                        Img.BackgroundTransparency = 1
                        Img.Parent = Card
                        
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1, -4, 0, 18)
                        btn.Position = UDim2.new(0, 2, 0, 53)
                        btn.Text = "Copy"
                        btn.TextSize = 8
                        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                        btn.TextColor3 = Color3.white
                        btn.Parent = Card
                        addCorner(btn, 3)
                        
                        btn.MouseButton1Click:Connect(function()
                            setclipboard(tostring(data.asset.id))
                            btn.Text = "Saved"
                            task.wait(0.5)
                            btn.Text = "Copy"
                        end)
                    end
                end
            end
        end
        ListPage.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 5)
        setLoader(false)
        isFetching = false
    end)
end

-- ==========================================
-- CONNECTIONS
-- ==========================================
ModeBtn.MouseButton1Click:Connect(function()
    if searchMode == "10" then
        searchMode = "3"
        ModeBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
        ModeBtn.Image = "rbxassetid://10734951121"
    else
        searchMode = "10"
        ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        ModeBtn.Image = "rbxassetid://10734950309"
    end
end)

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

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
