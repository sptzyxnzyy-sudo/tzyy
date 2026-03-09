local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup GUI lama agar tidak duplikat
if CoreGui:FindFirstChild("IkyyPremium_V4") then 
    CoreGui:FindFirstChild("IkyyPremium_V4"):Destroy() 
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V4"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- Rainbow Glow Border
local Border = Instance.new("Frame")
Border.Name = "GlowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.ZIndex = -1
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 15)

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
ToggleBtn.ZIndex = 5
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Content Frame (Wadah elemen)
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.Size = UDim2.new(1, 0, 1, 0)
Content.BackgroundTransparency = 1

-- Profile Section
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, 0, 0, 75)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = Content

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 40, 0, 40)
AvatarImg.Position = UDim2.new(0, 15, 0, 15)
AvatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
AvatarImg.Parent = ProfileFrame
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local UserName = Instance.new("TextLabel")
UserName.Text = LocalPlayer.DisplayName
UserName.Position = UDim2.new(0, 65, 0, 25)
UserName.Size = UDim2.new(0, 140, 0, 20)
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.Font = Enum.Font.GothamBold
UserName.BackgroundTransparency = 1
UserName.TextSize = 13
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.Parent = ProfileFrame

-- Buttons Scrolling Container
local Container = Instance.new("ScrollingFrame")
Container.Position = UDim2.new(0, 0, 0, 80)
Container.Size = UDim2.new(1, 0, 1, -110)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 0
Container.Parent = Content

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 10)

-- Rainbow Animation
task.spawn(function()
    local rot = 0
    RunService.RenderStepped:Connect(function(dt)
        rot = rot + (dt * 120)
        UIGradient.Rotation = rot
    end)
end)

-- LOGIKA MINIMIZE (No Bug)
local IsMinimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    
    local targetSize = IsMinimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 320)
    local targetText = IsMinimized and "+" or "-"
    
    if not IsMinimized then Content.Visible = true end
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    
    local tweenContent = TweenService:Create(Content, TweenInfo.new(0.2), {GroupTransparency = IsMinimized and 1 or 0})
    -- Jika CanvasGroup tidak disupport, gunakan manual transparency:
    for _, obj in pairs(Content:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
            TweenService:Create(obj, TweenInfo.new(0.2), {TextTransparency = IsMinimized and 1 or 0, ImageTransparency = IsMinimized and 1 or 0}):Play()
        end
    end

    ToggleBtn.Text = targetText
    task.wait(0.2)
    if IsMinimized then Content.Visible = false end
end)

-- Button Factory (Rapi & No Icon Overlap)
local function CreateStyledButton(name, icon, activeColor, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.88, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.Text = "" -- Kosongkan agar tidak dempet
    Btn.AutoButtonColor = false
    Btn.Parent = Container
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 22, 0, 22)
    IconImg.Position = UDim2.new(0, 12, 0.5, -11)
    IconImg.Image = icon
    IconImg.BackgroundTransparency = 1
    IconImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    IconImg.Parent = Btn

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Position = UDim2.new(0, 45, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Btn
    
    local IsToggled = false
    Btn.MouseButton1Click:Connect(function()
        IsToggled = not IsToggled
        local targetColor = IsToggled and activeColor or Color3.fromRGB(22, 22, 22)
        local targetTextCol = IsToggled and Color3.new(1, 1, 1) or Color3.fromRGB(220, 220, 220)
        
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Label, TweenInfo.new(0.3), {TextColor3 = targetTextCol}):Play()

        task.spawn(function()
            while IsToggled do
                local success, err = pcall(func)
                if not success then warn("Fitur Error: " .. err) end
                task.wait(0.5) -- Loop delay
            end
        end)
    end)
end

-- LIST FITUR
CreateStyledButton("AUTO BUY BIBIT", "rbxassetid://6031764630", Color3.fromRGB(0, 120, 215), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
end)

CreateStyledButton("AUTO PLANT CROP", "rbxassetid://6034287525", Color3.fromRGB(46, 204, 113), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.PlantCrop:FireServer(Vector3.new(-55.03845977783203, 37.296875, -299.0332946777344))
end)

CreateStyledButton("AUTO SELL PADI", "rbxassetid://6031154871", Color3.fromRGB(180, 0, 0), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45)
end)

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Text = "IKYY PREMIUM v4.0 • STABLE"
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.BackgroundTransparency = 1
Footer.TextColor3 = Color3.fromRGB(80, 80, 80)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.Parent = Content

print("IkyyPremium_V4.0 Berhasil Dijalankan!")
