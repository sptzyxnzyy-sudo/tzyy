-- Sptzyy Toolbox Optimized V2
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Bersihkan instance lama dengan lebih aman
local existing = CoreGui:FindFirstChild("SptzyyToolboxFinal")
if existing then existing:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyToolboxFinal"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- State Management (Local Optimization)
local State = {
    Cursors = { [1] = "" },
    CurrentPage = 1,
    Keyword = "",
    Fetching = false,
    Mode = "10", -- 10: Model, 3: Audio
    CurrentAssetId = ""
}

-- Utility: Quick Rounding
local function addCorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = obj
end

-- ==========================================
-- UI CONSTRUCT (Main Frame)
-- ==========================================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 350)
Main.Position = UDim2.new(0.5, -160, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
addCorner(Main, 10)

-- Header Section
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "TOOLBOX PRO"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Header
addCorner(CloseBtn, 15)

-- Search Bar Area
local SearchContainer = Instance.new("Frame")
SearchContainer.Size = UDim2.new(1, -20, 0, 35)
SearchContainer.Position = UDim2.new(0, 10, 0, 45)
SearchContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SearchContainer.Parent = Main
addCorner(SearchContainer, 6)

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -70, 1, 0)
Input.Position = UDim2.new(0, 10, 0, 0)
Input.PlaceholderText = "Search assets..."
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.BackgroundTransparency = 1
Input.ClearTextOnFocus = false
Input.Parent = SearchContainer

local ModeBtn = Instance.new("TextButton")
ModeBtn.Size = UDim2.new(0, 55, 0, 25)
ModeBtn.Position = UDim2.new(1, -60, 0.5, -12)
ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ModeBtn.Text = "MODEL"
ModeBtn.Font = Enum.Font.GothamBold
ModeBtn.TextSize = 10
ModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeBtn.Parent = SearchContainer
addCorner(ModeBtn, 4)

-- List Area
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -130)
Scroll.Position = UDim2.new(0, 5, 0, 90)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Main

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 95, 0, 120)
Grid.CellPadding = UDim2.new(0, 5, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.Parent = Scroll

-- Pagination Controls
local Nav = Instance.new("Frame")
Nav.Size = UDim2.new(1, 0, 0, 30)
Nav.Position = UDim2.new(0, 0, 1, -35)
Nav.BackgroundTransparency = 1
Nav.Parent = Main

local Prev = Instance.new("TextButton")
Prev.Size = UDim2.new(0, 80, 0, 25)
Prev.Position = UDim2.new(0.5, -85, 0, 0)
Prev.Text = "Previous"
Prev.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Prev.TextColor3 = Color3.fromRGB(200, 200, 200)
Prev.Visible = false
Prev.Parent = Nav
addCorner(Prev)

local Next = Instance.new("TextButton")
Next.Size = UDim2.new(0, 80, 0, 25)
Next.Position = UDim2.new(0.5, 5, 0, 0)
Next.Text = "Next"
Next.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Next.TextColor3 = Color3.fromRGB(200, 200, 200)
Next.Visible = false
Next.Parent = Nav
addCorner(Next)

-- Detail View (Overlay)
local DetailFrame = Instance.new("Frame")
DetailFrame.Size = UDim2.new(1, 0, 1, 0)
DetailFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DetailFrame.Visible = false
DetailFrame.ZIndex = 5
DetailFrame.Parent = Main
addCorner(DetailFrame)

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 30, 0, 30)
BackBtn.Position = UDim2.new(0, 10, 0, 10)
BackBtn.Text = "←"
BackBtn.BackgroundTransparency = 1
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.TextSize = 20
BackBtn.Parent = DetailFrame

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0, 200, 0, 40)
CopyBtn.Position = UDim2.new(0.5, -100, 0.8, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
CopyBtn.Text = "Copy Asset ID"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Parent = DetailFrame
addCorner(CopyBtn)

-- ==========================================
-- LOGIC (Optimized)
-- ==========================================

local function fastRequest(url)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    return req({Url = url, Method = "GET"})
end

local function updateScroll()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 10)
end

local function clearGrid()
    for _, item in ipairs(Scroll:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
end

local function Search(keyword, cursor, page)
    if State.Fetching then return end
    State.Fetching = true
    
    local loadText = Instance.new("TextLabel")
    loadText.Text = "Loading..."
    loadText.Size = UDim2.new(1,0,0,50)
    loadText.TextColor3 = Color3.fromRGB(150,150,150)
    loadText.BackgroundTransparency = 1
    loadText.Parent = Scroll

    local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/"..State.Mode.."?limit=20&keyword="..HttpService:UrlEncode(keyword)
    if cursor and cursor ~= "" then url = url.."&cursor="..cursor end

    task.spawn(function()
        local success, res = pcall(function() return fastRequest(url) end)
        loadText:Destroy()
        
        if success and res.StatusCode == 200 then
            clearGrid()
            local data = HttpService:JSONDecode(res.Body)
            State.CurrentPage = page
            State.Cursors[page + 1] = data.nextPageCursor or ""
            
            Prev.Visible = page > 1
            Next.Visible = (data.nextPageCursor ~= nil and data.nextPageCursor ~= "")

            for _, asset in ipairs(data.data) do
                local Card = Instance.new("Frame")
                Card.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Card.Parent = Scroll
                addCorner(Card, 6)

                local Thumb = Instance.new("ImageLabel")
                Thumb.Size = UDim2.new(1, -10, 0, 80)
                Thumb.Position = UDim2.new(0, 5, 0, 5)
                Thumb.BackgroundTransparency = 1
                Thumb.Image = (State.Mode == "3") and "rbxassetid://10734951121" or "rbxthumb://type=Asset&id="..asset.id.."&w=150&h=150"
                Thumb.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -10, 0, 30)
                Label.Position = UDim2.new(0, 5, 0, 85)
                Label.Text = asset.name
                Label.TextSize = 10
                Label.TextColor3 = Color3.fromRGB(230, 230, 230)
                Label.TextWrapped = true
                Label.BackgroundTransparency = 1
                Label.Parent = Card

                local Hitbox = Instance.new("TextButton")
                Hitbox.Size = UDim2.new(1, 0, 1, 0)
                Hitbox.BackgroundTransparency = 1
                Hitbox.Text = ""
                Hitbox.Parent = Card
                Hitbox.MouseButton1Click:Connect(function()
                    State.CurrentAssetId = tostring(asset.id)
                    DetailFrame.Visible = true
                end)
            end
            updateScroll()
        end
        State.Fetching = false
    end)
end

-- Events
ModeBtn.MouseButton1Click:Connect(function()
    if State.Mode == "10" then
        State.Mode = "3"
        ModeBtn.Text = "AUDIO"
        ModeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    else
        State.Mode = "10"
        ModeBtn.Text = "MODEL"
        ModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end)

Input.FocusLost:Connect(function(enter)
    if enter and Input.Text ~= "" then
        State.Keyword = Input.Text
        State.Cursors = {[1]=""}
        Search(State.Keyword, "", 1)
    end
end)

Next.MouseButton1Click:Connect(function()
    if not State.Fetching then Search(State.Keyword, State.Cursors[State.CurrentPage + 1], State.CurrentPage + 1) end
end)

Prev.MouseButton1Click:Connect(function()
    if not State.Fetching then Search(State.Keyword, State.Cursors[State.CurrentPage - 1], State.CurrentPage - 1) end
end)

BackBtn.MouseButton1Click:Connect(function() DetailFrame.Visible = false end)

CopyBtn.MouseButton1Click:Connect(function()
    setclipboard(State.CurrentAssetId)
    local oldText = CopyBtn.Text
    CopyBtn.Text = "COPIED!"
    task.wait(1)
    CopyBtn.Text = oldText
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
