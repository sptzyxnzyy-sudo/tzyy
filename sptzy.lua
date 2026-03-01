local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Global variable untuk auto-run setelah teleport
if _G.SearchingFor == nil then _G.SearchingFor = "" end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyScroll_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME (FIXED SIZE)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -125)
MainFrame.Size = UDim2.new(0, 225, 0, 250) -- Kotak Persegi Rapi
MainFrame.Active = true
MainFrame.Draggable = true

-- Rainbow Border
local Border = Instance.new("Frame")
Border.Name = "RainbowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.BorderSizePixel = 0
Border.Position = UDim2.new(0, -2, 0, -2)
Border.Size = UDim2.new(1, 4, 1, 4)
Border.ZIndex = 0
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 8)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Profile Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 35, 0, 35)
AvatarImg.Position = UDim2.new(0, 10, 0, 7)
AvatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
AvatarImg.Parent = Header
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local UserName = Instance.new("TextLabel")
UserName.Text = LocalPlayer.DisplayName
UserName.Position = UDim2.new(0, 55, 0, 15)
UserName.Size = UDim2.new(0, 140, 0, 20)
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.Font = Enum.Font.SourceSansBold
UserName.BackgroundTransparency = 1
UserName.TextSize = 14
UserName.Parent = Header

-- SCROLLING CONTAINER
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ListContainer"
ScrollFrame.Parent = MainFrame
ScrollFrame.Active = true
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Position = UDim2.new(0, 5, 0, 55)
ScrollFrame.Size = UDim2.new(1, -10, 1, -80)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400) -- Area scroll panjang
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollFrame
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

-- Function Create Button
local function AddButton(name, color, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.95, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.TextSize = 14
    Btn.Parent = ScrollFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    local Active = false
    Btn.MouseButton1Click:Connect(function()
        Active = not Active
        Btn.BackgroundColor3 = Active and color or Color3.fromRGB(30, 30, 30)
        task.spawn(function()
            while Active do
                pcall(func)
                task.wait(0.1)
            end
        end)
    end)
end

-- FITUR 1 & 2
AddButton("AUTO BELI PADI", Color3.fromRGB(0, 102, 204), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
end)

AddButton("AUTO SELL PADI", Color3.fromRGB(153, 0, 0), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45)
end)

--- FITUR 3: USERNAME HUNTER (SCROLLABLE BOX) ---
local HunterBox = Instance.new("Frame")
HunterBox.Size = UDim2.new(0.95, 0, 0, 150)
HunterBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
HunterBox.Parent = ScrollFrame
Instance.new("UICorner", HunterBox)

local HTitle = Instance.new("TextLabel")
HTitle.Text = "🎯 TARGET HUNTER"
HTitle.Size = UDim2.new(1, 0, 0, 30)
HTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HTitle.Font = Enum.Font.SourceSansBold
HTitle.BackgroundTransparency = 1
HTitle.Parent = HunterBox

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(0.9, 0, 0, 35)
TargetInput.Position = UDim2.new(0.05, 0, 0.25, 0)
TargetInput.PlaceholderText = "Input Username..."
TargetInput.Text = _G.SearchingFor
TargetInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TargetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.Parent = HunterBox
Instance.new("UICorner", TargetInput)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0.55, 0)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextSize = 12
StatusLabel.Parent = HunterBox

local function StartHunting()
    local name = TargetInput.Text
    if name == "" then return end
    _G.SearchingFor = name
    StatusLabel.Text = "Checking..."
    task.wait(1)
    
    local found = false
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower() == name:lower() then found = true break end
    end
    
    if found then
        StatusLabel.Text = "✅ FOUND!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        _G.SearchingFor = ""
    else
        StatusLabel.Text = "❌ Not here. Hopping..."
        task.wait(1)
        local success, result = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        end)
        if success then
            local data = HttpService:JSONDecode(result).data
            for _, server in ipairs(data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                    break
                end
            end
        end
    end
end

local HuntBtn = Instance.new("TextButton")
HuntBtn.Size = UDim2.new(0.9, 0, 0, 35)
HuntBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
HuntBtn.Text = "START HUNTING"
HuntBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
HuntBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HuntBtn.Parent = HunterBox
Instance.new("UICorner", HuntBtn)
HuntBtn.MouseButton1Click:Connect(StartHunting)

-- Rainbow Logic
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Border.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
            task.wait(0.02)
        end
    end
end)

-- Watermark
local WM = Instance.new("TextLabel")
WM.Text = "IKYY PREMIUM v3.3"
WM.Position = UDim2.new(0, 0, 1, -20)
WM.Size = UDim2.new(1, 0, 0, 20)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(100, 100, 100)
WM.TextSize = 10
WM.Parent = MainFrame

-- Auto Run Hunter
if _G.SearchingFor ~= "" then task.spawn(StartHunting) end
