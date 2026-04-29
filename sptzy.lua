-- Global Config & Services
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Fungsi Helper: Request (Support berbagai executor)
local function httpRequest(options)
    local fn = syn and syn.request or http_request or request or HTTPrequest
    if fn then
        return fn(options)
    else
        warn("Executor tidak mendukung HTTP Request!")
        return nil
    end
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxMarketplaceExplorer"
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame (Persegi Empat Kecil)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Support Geser
MainFrame.Parent = ScreenGui

-- Corner UI
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Marketplace Explorer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Scrolling Frame (Hasil Pencarian)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
ScrollFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.Padding = UDim.new(0, 5)

-- Input Area (Di bawah)
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.7, 0, 0, 35)
InputBox.Position = UDim2.new(0.05, 0, 0.85, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InputBox.PlaceholderText = "Cari keyword (warung, kursi...)"
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.Parent = MainFrame

local SearchBtn = Instance.new("TextButton")
SearchBtn.Size = UDim2.new(0.2, 0, 0, 35)
SearchBtn.Position = UDim2.new(0.76, 0, 0.85, 0)
SearchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SearchBtn.Text = "Cari"
SearchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBtn.Parent = MainFrame

-- Function: Create Item Card
local function createItemCard(id, name, creator)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -10, 0, 70)
    Card.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 60, 0, 60)
    Icon.Position = UDim2.new(0, 5, 0.5, -30)
    -- Thumbnail URL Generator
    Icon.Image = "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
    Icon.Parent = Card
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
    NameLabel.Position = UDim2.new(0, 75, 0.1, 0)
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.BackgroundTransparency = 1
    NameLabel.Parent = Card

    local CreatorLabel = Instance.new("TextLabel")
    CreatorLabel.Size = UDim2.new(0.6, 0, 0.3, 0)
    CreatorLabel.Position = UDim2.new(0, 75, 0.6, 0)
    CreatorLabel.Text = "By: " .. creator
    CreatorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    CreatorLabel.TextXAlignment = Enum.TextXAlignment.Left
    CreatorLabel.BackgroundTransparency = 1
    CreatorLabel.Parent = Card

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0, 50, 0, 30)
    CopyBtn.Position = UDim2.new(1, -55, 0.5, -15)
    CopyBtn.Text = "Copy ID"
    CopyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.Parent = Card
    
    CopyBtn.MouseButton1Click:Connect(function()
        setclipboard(tostring(id))
        CopyBtn.Text = "Done!"
        task.wait(1)
        CopyBtn.Text = "Copy ID"
    end)

    Card.Parent = ScrollFrame
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- Logic: Fetch Data
local function fetchData(keyword)
    -- Bersihkan hasil lama
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local baseUrl = "https://apis.roblox.com/toolbox-service/v1/marketplace/10"
    local searchUrl = baseUrl .. "?limit=30&keyword=" .. HttpService:UrlEncode(keyword) .. "&includeOnlyVerifiedCreators=true"
    
    local response = httpRequest({
        Url = searchUrl,
        Method = "GET"
    })
    
    if response and response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body).data
        local ids = {}
        for _, item in pairs(data) do
            table.insert(ids, tostring(item.id))
        end
        
        -- Get Detail
        local detailUrl = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds=" .. table.concat(ids, ",")
        local detailRes = httpRequest({Url = detailUrl, Method = "GET"})
        
        if detailRes and detailRes.StatusCode == 200 then
            local details = HttpService:JSONDecode(detailRes.Body).data
            for _, item in pairs(details) do
                createItemCard(item.asset.id, item.asset.name, item.creator.name)
            end
        end
    else
        print("Gagal mengambil data.")
    end
end

-- Event Search
SearchBtn.MouseButton1Click:Connect(function()
    local kw = InputBox.Text
    if kw ~= "" then
        fetchData(kw)
        InputBox.Text = "" -- Bersihkan input setelah klik
    end
end)

-- Support 'Enter' key untuk search
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        SearchBtn.MouseButton1Click:Fire()
    end
end)
