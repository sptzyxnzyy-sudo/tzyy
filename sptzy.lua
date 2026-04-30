local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Membersihkan UI lama jika ada
if CoreGui:FindFirstChild("SptzyyToolboxSmall") then 
    CoreGui.SptzyyToolboxSmall:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyToolboxSmall"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- State Management
local isFetching = false

local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = obj
end

-- ==========================================
-- MAIN FRAME (Ukuran 150x150)
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

-- Shadow/Border Glow sederhana
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = Main

-- ==========================================
-- LOADING ANIMATION (Ikon Berputar)
-- ==========================================
local LoadingIcon = Instance.new("ImageLabel")
LoadingIcon.Size = UDim2.new(0, 35, 0, 35)
LoadingIcon.Position = UDim2.new(0.5, -17, 0.5, -17)
LoadingIcon.BackgroundTransparency = 1
LoadingIcon.Image = "rbxassetid://6031082988" -- Asset loading standar
LoadingIcon.ImageColor3 = Color3.fromRGB(0, 170, 255)
LoadingIcon.Visible = false
LoadingIcon.ZIndex = 50
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
-- HEADER & INPUT
-- ==========================================
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -22, 0, 2)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = Main

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -16, 0, 22)
Input.Position = UDim2.new(0, 8, 0, 25)
Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Input.PlaceholderText = "Cari asset..."
Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.SourceSans
Input.TextSize = 12
Input.Parent = Main
addCorner(Input, 4)

-- ==========================================
-- HASIL PENCARIAN (Scrolling)
-- ==========================================
local ListPage = Instance.new("ScrollingFrame")
ListPage.Size = UDim2.new(1, -10, 1, -55)
ListPage.Position = UDim2.new(0, 5, 0, 52)
ListPage.BackgroundTransparency = 1
ListPage.ScrollBarThickness = 2
ListPage.CanvasSize = UDim2.new(0,0,0,0)
ListPage.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 65, 0, 85)
Grid.CellPadding = UDim2.new(0, 5, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = ListPage

-- ==========================================
-- LOGIC PENCARIAN
-- ==========================================
local function httpRequest(opt)
    local f = (syn and syn.request) or (http and http.request) or http_request or request
    return f(opt)
end

local function Search(kw)
    if isFetching then return end
    isFetching = true
    setLoader(true)
    
    -- Bersihkan hasil lama
    for _, v in pairs(ListPage:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    task.spawn(function()
        local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/10?limit=10&keyword="..HttpService:UrlEncode(kw)
        local success, res = pcall(function() return httpRequest({Url = url, Method = "GET"}) end)
        
        if success and res and res.StatusCode == 200 then
            local body = HttpService:JSONDecode(res.Body)
            local ids = {}
            for _, v in pairs(body.data) do table.insert(ids, tostring(v.id)) end
            
            if #ids > 0 then
                local detUrl = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="..table.concat(ids, ",")
                local detRes = httpRequest({Url = detUrl, Method = "GET"})
                
                if detRes and detRes.StatusCode == 200 then
                    for _, data in pairs(HttpService:JSONDecode(detRes.Body).data) do
                        local Card = Instance.new("Frame")
                        Card.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        Card.Parent = ListPage
                        addCorner(Card, 4)
                        
                        local Img = Instance.new("ImageLabel")
                        Img.Size = UDim2.new(1, 0, 0, 60)
                        Img.Image = "rbxthumb://type=Asset&id="..data.asset.id.."&w=150&h=150"
                        Img.BackgroundTransparency = 1
                        Img.Parent = Card
                        
                        local CopyBtn = Instance.new("TextButton")
                        CopyBtn.Size = UDim2.new(1, -4, 0, 18)
                        CopyBtn.Position = UDim2.new(0, 2, 0, 63)
                        CopyBtn.Text = "ID"
                        CopyBtn.TextSize = 10
                        CopyBtn.Font = Enum.Font.SourceSansBold
                        CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                        CopyBtn.TextColor3 = Color3.white
                        CopyBtn.Parent = Card
                        addCorner(CopyBtn, 3)
                        
                        CopyBtn.MouseButton1Click:Connect(function()
                            setclipboard(tostring(data.asset.id))
                            CopyBtn.Text = "OK!"
                            task.wait(1)
                            CopyBtn.Text = "ID"
                        end)
                    end
                end
            end
        end
        
        ListPage.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 10)
        setLoader(false)
        isFetching = false
    end)
end

-- ==========================================
-- INPUT & CLOSE
-- ==========================================
Input.FocusLost:Connect(function(enter)
    if enter and Input.Text ~= "" then
        Search(Input.Text)
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
