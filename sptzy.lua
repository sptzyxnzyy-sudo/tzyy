local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Create Canvas
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IkyyPremium_V3"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
MainFrame.Size = UDim2.new(0, 220, 0, 310) -- Ukuran ditambah sedikit untuk status kembang api
MainFrame.Active = true
MainFrame.Draggable = true

-- UI Corner Helper
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

-- Rainbow Border Effect
local Border = Instance.new("Frame")
Border.Name = "RainbowBorder"
Border.Parent = MainFrame
Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Border.BorderSizePixel = 0
Border.Position = UDim2.new(0, -2, 0, -2)
Border.Size = UDim2.new(1, 4, 1, 4)
Border.ZIndex = 0

AddCorner(Border, 8)
AddCorner(MainFrame, 8)

-- Profile Section
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, 0, 0, 60)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = MainFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 45, 0, 45)
AvatarImg.Position = UDim2.new(0, 10, 0, 10)
AvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
-- Menggunakan rbxthumb untuk loading avatar yang lebih stabil
AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImg.Parent = ProfileFrame
AddCorner(AvatarImg, 100)

local UserName = Instance.new("TextLabel")
UserName.Text = LocalPlayer.DisplayName
UserName.Position = UDim2.new(0, 65, 0, 12)
UserName.Size = UDim2.new(0, 140, 0, 20)
UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.Font = Enum.Font.SourceSansBold
UserName.BackgroundTransparency = 1
UserName.TextSize = 16
UserName.Parent = ProfileFrame

local UserTag = Instance.new("TextLabel")
UserTag.Text = "@" .. LocalPlayer.Name
UserTag.Position = UDim2.new(0, 65, 0, 28)
UserTag.Size = UDim2.new(0, 140, 0, 20)
UserTag.TextColor3 = Color3.fromRGB(180, 180, 180)
UserTag.TextXAlignment = Enum.TextXAlignment.Left
UserTag.Font = Enum.Font.SourceSans
UserTag.BackgroundTransparency = 1
UserTag.TextSize = 12
UserTag.Parent = ProfileFrame

-- Buttons Container
local Container = Instance.new("Frame")
Container.Position = UDim2.new(0, 0, 0, 70)
Container.Size = UDim2.new(1, 0, 1, -110)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 10)

-- Smooth Rainbow Logic (RenderStepped lebih hemat resource dibanding task.wait loop)
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    Border.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 1)
end)

-- Fireworks Info Label
local FireworksStatus = Instance.new("TextLabel")
FireworksStatus.Name = "FireworksStatus"
FireworksStatus.Parent = MainFrame
FireworksStatus.Size = UDim2.new(1, 0, 0, 20)
FireworksStatus.Position = UDim2.new(0, 0, 1, -45)
FireworksStatus.BackgroundTransparency = 1
FireworksStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
FireworksStatus.TextSize = 11
FireworksStatus.Font = Enum.Font.SourceSansItalic
FireworksStatus.Text = "Status: No Fireworks"

-- Button Creation Function
local function CreateStyledButton(name, icon, activeColor, func)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = "          " .. name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Container
    AddCorner(Btn, 6)
    
    local IconImg = Instance.new("ImageLabel")
    IconImg.Size = UDim2.new(0, 22, 0, 22)
    IconImg.Position = UDim2.new(0, 10, 0.5, -11)
    IconImg.Image = icon
    IconImg.BackgroundTransparency = 1
    IconImg.Parent = Btn
    
    local Active = false
    Btn.MouseButton1Click:Connect(function()
        Active = not Active
        
        -- Animasi perubahan warna saat aktif/mati
        TweenService:Create(Btn, TweenInfo.new(0.3), {
            BackgroundColor3 = Active and activeColor or Color3.fromRGB(35, 35, 35)
        }):Play()

        if Active then
            task.spawn(function()
                while Active do
                    pcall(func)
                    task.wait(1) -- Jeda 1 detik agar tidak kena kick antispam server
                end
            end)
        end
    end)
end

-- ICONS
local CART_ICON = "rbxassetid://6031764630"
local SELL_ICON = "rbxassetid://6031154871"

-- Add Buttons
CreateStyledButton("AUTO BELI PADI", CART_ICON, Color3.fromRGB(0, 102, 204), function()
    ReplicatedStorage.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Padi", 1)
end)

CreateStyledButton("AUTO SELL PADI", SELL_ICON, Color3.fromRGB(153, 0, 0), function()
    ReplicatedStorage.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Padi", 45)
end)

-- === FIREWORKS BROADCAST REMOTE HANDLER ===
local FireworksRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FireworksBroadcast")

FireworksRemote.OnClientEvent:Connect(function(data)
    -- Asumsi data berisi {duration, from, startAt}
    local senderId = data.from or "Unknown"
    local duration = data.duration or 0
    
    FireworksStatus.Text = "🎆 Fireworks Active! (" .. senderId .. ")"
    FireworksStatus.TextColor3 = Color3.fromRGB(255, 215, 0)
    
    -- Reset status setelah durasi kembang api habis
    task.delay(duration, function()
        FireworksStatus.Text = "Status: No Fireworks"
        FireworksStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
    end)
end)

-- Watermark
local WM = Instance.new("TextLabel")
WM.Text = "IKYY EXECUTOR v3"
WM.Position = UDim2.new(0, 0, 1, -25)
WM.Size = UDim2.new(1, 0, 0, 20)
WM.BackgroundTransparency = 1
WM.TextColor3 = Color3.fromRGB(80, 80, 80)
WM.TextSize = 10
WM.Parent = MainFrame

print("IkyyPremium_V3 Loaded Successfully!")
