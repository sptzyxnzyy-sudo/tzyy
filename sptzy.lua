local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("IkyyPremium_V3") then CoreGui:FindFirstChild("IkyyPremium_V3"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true -- Penting untuk efek minimize

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Rainbow Border
local Border = Instance.new("Frame")
Border.Name = "GlowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.ZIndex = -1
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 13)

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
}
UIGradient.Parent = Border

-- Toggle Button (Minimize/Maximize)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Position = UDim2.new(1, -35, 0, 10)
ToggleBtn.Size = UDim2.new(0, 25, 0, 25)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "-"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18
ToggleBtn.AutoButtonColor = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

-- Content Frame (Wadah untuk semua elemen selain tombol close)
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.Size = UDim2.new(1, 0, 1, 0)
Content.BackgroundTransparency = 1

-- Profile Section
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, 0, 0, 70)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = Content

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 45, 0, 45)
AvatarImg.Position = UDim2.new(0, 15, 0, 15)
AvatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
AvatarImg.Parent = ProfileFrame
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local UserName = Instance.new("TextLabel")
UserName.Text = LocalPlayer.DisplayName
UserName.Position = UDim2.new(0, 70, 0, 28)
UserName.Size = UDim2.new(0, 140, 0, 20)
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.Font = Enum.Font.GothamBold
UserName.BackgroundTransparency = 1
UserName.TextSize = 14
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.Parent = ProfileFrame

-- Scrolling Container
local Container = Instance.new("ScrollingFrame")
Container.Position = UDim2.new(0, 0, 0, 80)
Container.Size = UDim2.new(1, 0, 1, -110)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.Parent = Content

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)

-- Minimize Logic
local IsMinimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    
    local targetSize = IsMinimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 320)
    local targetText = IsMinimized and "+" or "-"
    local targetTrans = IsMinimized and 1 or 0
    
    -- Animate Main Frame
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
    
    -- Animate Content Alpha
    for _, obj in pairs(Content:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
            TweenService:Create(obj, TweenInfo.new(0.2), {TextTransparency = targetTrans, ImageTransparency = targetTrans}):Play()
        end
    end
    
    ToggleBtn.Text = targetText
    Content.Visible = not IsMinimized
end)

-- Rainbow Loop
task.spawn(function()
    local rot = 0
    RunService.RenderStepped:Connect(function(dt)
        rot = rot + (dt * 100)
        UIGradient.Rotation = rot
    end)
end)

-- Button Builder
local function CreateStyledButton(name, icon, activeColor, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = "          " .. name
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 11
    Btn.AutoButtonColor = false
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Container
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 20, 0, 20)
    IconImg.Position = UDim2.new(0, 10, 0.5, -10)
    IconImg.Image = icon
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = Btn
    
    local IsToggled = false
    Btn.MouseButton1Click:Connect(function()
        IsToggled = not IsToggled
        local targetColor = IsToggled and activeColor or Color3.fromRGB(25, 25, 25)
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()

        task.spawn(function()
            while IsToggled do
                pcall(func)
                task.wait(0.5)
            end
        end)
    end)
end

-- DATA BUTTONS
CreateStyledButton("AUTO BUY BIBIT", "rbxassetid://6031764630", Color3.fromRGB(0, 120, 215), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
end)

CreateStyledButton("AUTO PLANT CROP", "rbxassetid://6034287525", Color3.fromRGB(46, 204, 113), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.PlantCrop:FireServer(Vector3.new(-55.03845977783203, 37.296875, -299.0332946777344))
end)

CreateStyledButton("AUTO SELL PADI", "rbxassetid://6031154871", Color3.fromRGB(180, 0, 0), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45)
end)

local Footer = Instance.new("TextLabel")
Footer.Text = "IKYY PREMIUM v3.3"
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.BackgroundTransparency = 1
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.Parent = Content
