local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("MiniToolbox") then CoreGui.MiniToolbox:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniToolbox"
ScreenGui.Parent = CoreGui

-- Main Frame (300x300)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 300)
Main.Position = UDim2.new(0.5, -150, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end
addCorner(Main, 6)

-- Search Input (Tetap di Atas)
local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -20, 0, 30)
Input.Position = UDim2.new(0, 10, 0, 10)
Input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Input.PlaceholderText = "Cari asset..."
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.SourceSans
Input.TextSize = 14
Input.Parent = Main
addCorner(Input)

-- Container Pages
local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -55)
ListPage.Position = UDim2.new(0, 5, 0, 50)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 3
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 90, 0, 90) -- Fit 3 kolom di 300px
Grid.CellPadding = UDim2.new(0, 4, 0, 4)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

local DetailPage = Instance.new("Frame")
DetailPage.Size = ListPage.Size
DetailPage.Position = ListPage.Position
DetailPage.BackgroundColor3 = Main.BackgroundColor3
DetailPage.Visible = false
DetailPage.Parent = Main

-- Detail Components
local DetImg = Instance.new("ImageLabel")
DetImg.Size = UDim2.new(0, 100, 0, 100)
DetImg.Position = UDim2.new(0.5, -50, 0, 10)
DetImg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DetImg.Parent = DetailPage
addCorner(DetImg)

local DetName = Instance.new("TextLabel")
DetName.Size = UDim2.new(1, -20, 0, 40)
DetName.Position = UDim2.new(0, 10, 0, 115)
DetName.TextSize = 14
DetName.TextColor3 = Color3.fromRGB(255, 255, 255)
DetName.TextWrapped = true
DetName.BackgroundTransparency = 1
DetName.Parent = DetailPage

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.8, 0, 0, 30)
CopyBtn.Position = UDim2.new(0.1, 0, 0, 160)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
CopyBtn.Text = "COPY ID"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Parent = DetailPage
addCorner(CopyBtn)

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0.8, 0, 0, 25)
BackBtn.Position = UDim2.new(0.1, 0, 0, 195)
BackBtn.Text = "BACK"
BackBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
BackBtn.BackgroundTransparency = 1
BackBtn.Parent = DetailPage

-- Logic
local currentId = ""
local function httpRequest(opt)
    local f = (syn and syn.request) or (http and http.request) or http_request or request
    return f(opt)
end

local function showDetail(data)
    currentId = tostring(data.asset.id)
    DetImg.Image = "rbxthumb://type=Asset&id="..currentId.."&w=150&h=150"
    DetName.Text = data.asset.name
    ListPage.Visible = false
    DetailPage.Visible = true
end

BackBtn.MouseButton1Click:Connect(function()
    DetailPage.Visible = false
    ListPage.Visible = true
end)

CopyBtn.MouseButton1Click:Connect(function()
    setclipboard(currentId)
    CopyBtn.Text = "COPIED!"
    task.wait(0.5)
    CopyBtn.Text = "COPY ID"
end)

local function Search(kw)
    for _, v in pairs(ListPage:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local res = httpRequest({Url = "https://apis.roblox.com/toolbox-service/v1/marketplace/10?limit=30&keyword="..HttpService:UrlEncode(kw), Method = "GET"})
    if res and res.StatusCode == 200 then
        local items = HttpService:JSONDecode(res.Body).data
        local ids = {}
        for _, v in pairs(items) do table.insert(ids, tostring(v.id)) end
        local detRes = httpRequest({Url = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="..table.concat(ids, ","), Method = "GET"})
        if detRes and detRes.StatusCode == 200 then
            for _, data in pairs(HttpService:JSONDecode(detRes.Body).data) do
                local Card = Instance.new("Frame")
                Card.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Card.Parent = ListPage
                addCorner(Card)
                
                local Img = Instance.new("ImageLabel")
                Img.Size = UDim2.new(1, -6, 1, -6)
                Img.Position = UDim2.new(0, 3, 0, 3)
                Img.Image = "rbxthumb://type=Asset&id="..data.asset.id.."&w=150&h=150"
                Img.BackgroundTransparency = 1
                Img.Parent = Card
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Text = ""
                btn.Parent = Card
                btn.MouseButton1Click:Connect(function() showDetail(data) end)
            end
            ListPage.CanvasSize = UDim2.new(0,0,0,Grid.AbsoluteContentSize.Y)
        end
    end
end

Input.FocusLost:Connect(function(e)
    if e and Input.Text ~= "" then
        local k = Input.Text
        Input.Text = ""
        DetailPage.Visible = false
        ListPage.Visible = true
        Search(k)
    end
end)
