local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cleanup versi lama agar tidak terjadi penumpukan UI
if CoreGui:FindFirstChild("IkyyPremium_V4") then 
    CoreGui:FindFirstChild("IkyyPremium_V4"):Destroy() 
end

-- ==========================================
-- MAIN SETUP
-- ==========================================
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
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

-- Rainbow Glow Border
local Border = Instance.new("Frame")
Border.Name = "GlowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.ZIndex = -1
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 17)

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
}
UIGradient.Parent = Border

-- Floating Open Button (Muncul saat menu di-close)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Position = UDim2.new(0.02, 0, 0.5, -20)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Text = "IKY"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 12
OpenBtn.Visible = false
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

-- Rainbow Border untuk Open Button
local OpenBorder = Border:Clone()
OpenBorder.Parent = OpenBtn
OpenBorder.Size = UDim2.new(1, 2, 1, 2)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- UI CONTENT
-- ==========================================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Profile = Instance.new("Frame")
Profile.Size = UDim2.new(1, 0, 0, 75)
Profile.BackgroundTransparency = 1
Profile.Parent = Content

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 42, 0, 42)
Avatar.Position = UDim2.new(0, 15, 0, 18)
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
Avatar.Parent = Profile
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local UserText = Instance.new("TextLabel")
UserText.Text = LocalPlayer.DisplayName
UserText.Position = UDim2.new(0, 68, 0, 29)
UserText.Size = UDim2.new(0, 140, 0, 20)
UserText.TextColor3 = Color3.fromRGB(255, 255, 255)
UserText.Font = Enum.Font.GothamBold
UserText.TextSize = 14
UserText.BackgroundTransparency = 1
UserText.TextXAlignment = Enum.TextXAlignment.Left
UserText.Parent = Profile

-- Scroll Container
local Container = Instance.new("ScrollingFrame")
Container.Position = UDim2.new(0, 0, 0, 85)
Container.Size = UDim2.new(1, 0, 1, -120)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 0
Container.Parent = Content

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 10)

-- ==========================================
-- ANIMATION & LOGIC
-- ==========================================

-- Rainbow Rotation
task.spawn(function()
    local rot = 0
    RunService.RenderStepped:Connect(function(dt)
        rot = rot + (dt * 120)
        UIGradient.Rotation = rot
        OpenBorder.UIGradient.Rotation = rot
    end)
end)

-- Open/Close Logic
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true)
    task.wait(0.3)
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    OpenBtn.Visible = false
    MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 250, 0, 320), "Out", "Back", 0.4, true)
end)

-- Button Factory (Rapi & No Overlap)
local function CreateFitur(name, icon, activeColor, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = Container
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 22, 0, 22)
    IconImg.Position = UDim2.new(0, 12, 0.5, -11)
    IconImg.Image = icon
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = Btn

    local Label = Instance.new("TextLabel")
    Label.Text = name
    Label.Position = UDim2.new(0, 45, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.TextColor3 = Color3.fromRGB(210, 210, 210)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Btn
    
    local Toggled = false
    Btn.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Toggled and activeColor or Color3.fromRGB(20, 20, 20)}):Play()
        TweenService:Create(Label, TweenInfo.new(0.3), {TextColor3 = Toggled and Color3.new(1, 1, 1) or Color3.fromRGB(210, 210, 210)}):Play()

        task.spawn(function()
            while Toggled do
                local success, err = pcall(func)
                if not success then warn("Error: "..err) end
                task.wait(0.5)
            end
        end)
    end)
end

-- ==========================================
-- DATA FITUR (DAFTAR PILIHAN)
-- ==========================================

CreateFitur("AUTO BUY BIBIT", "rbxassetid://6031764630", Color3.fromRGB(0, 102, 204), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
end)

CreateFitur("AUTO PLANT CROP", "rbxassetid://6034287525", Color3.fromRGB(46, 204, 113), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.PlantCrop:FireServer(Vector3.new(-55.03845977783203, 37.296875, -299.0332946777344))
end)

CreateFitur("AUTO SELL PADI", "rbxassetid://6031154871", Color3.fromRGB(153, 0, 0), function()
    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45)
end)

-- FITUR BARU: HD ADMIN COMMAND
CreateFitur("SEND JAIL CMD", "rbxassetid://6031068833", Color3.fromRGB(255, 140, 0), function()
    game:GetService("ReplicatedStorage").HDAdminHDClient.Signals.RequestCommand:InvokeServer(";jail")
end)

-- Footer Info
local Footer = Instance.new("TextLabel")
Footer.Text = "IKYY PREMIUM • v4.8 STABLE"
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.BackgroundTransparency = 1
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.Parent = Content

print("IkyyPremium_V4.8 Loaded - Hubungi Owner Jika Error.")
