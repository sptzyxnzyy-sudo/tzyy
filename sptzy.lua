-- [[ PHANTOM SQUARE: FULL PROFILE & LAUNCHER SYSTEM ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ PENGAMBILAN DATA ]] --
local userId = lp.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local profilePic, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomProfileFinal"
ScreenGui.ResetOnSpawn = false

-- [[ 1. LAUNCHER ICON ]] --
local IconBtn = Instance.new("ImageButton", ScreenGui)
IconBtn.Name = "LauncherIcon"
IconBtn.Size = UDim2.new(0, 55, 0, 55)
IconBtn.Position = UDim2.new(0, 30, 0.5, -27)
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IconBtn.Image = profilePic
IconBtn.BorderSizePixel = 0
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0) -- Lingkaran sempurna untuk icon

local IconStroke = Instance.new("UIStroke", IconBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- [[ 2. MAIN SQUARE GUI ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 320) -- Persegi Sempurna
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 1.5

-- [[ KOMPONEN DALAM GUI ]] --

-- Tombol Close
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 35
CloseBtn.Font = Enum.Font.GothamBold

-- Avatar Image (Inside)
local AvatarImg = Instance.new("ImageLabel", MainFrame)
AvatarImg.Size = UDim2.new(0, 90, 0, 90)
AvatarImg.Position = UDim2.new(0, 20, 0, 25)
AvatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
AvatarImg.Image = profilePic
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", AvatarImg).Color = Color3.fromRGB(0, 255, 255)

-- Label Generator
local function createLabel(text, pos, font, size, color, parent)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, -130, 0, 25)
    l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color
    l.Font = font
    l.TextSize = size
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

createLabel(lp.DisplayName, UDim2.new(0, 125, 0, 35), Enum.Font.GothamBold, 18, Color3.fromRGB(255, 255, 255), MainFrame)
createLabel("@"..lp.Name, UDim2.new(0, 125, 0, 55), Enum.Font.Gotham, 14, Color3.fromRGB(150, 150, 150), MainFrame)
createLabel("ID: "..lp.UserId, UDim2.new(0, 125, 0, 75), Enum.Font.Code, 12, Color3.fromRGB(0, 255, 255), MainFrame)

-- Info Container (Lower Box)
local InfoBox = Instance.new("Frame", MainFrame)
InfoBox.Size = UDim2.new(1, -40, 0, 160)
InfoBox.Position = UDim2.new(0, 20, 0, 130)
InfoBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Instance.new("UICorner", InfoBox).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", InfoBox).Color = Color3.fromRGB(30, 30, 45)

local DetailText = Instance.new("TextLabel", InfoBox)
DetailText.Size = UDim2.new(1, -20, 1, -20)
DetailText.Position = UDim2.new(0, 10, 0, 10)
DetailText.BackgroundTransparency = 1
DetailText.Text = "ACCOUNT DETAILS\n\n" .. 
                 "• Membership: " .. lp.MembershipType.Name .. "\n" ..
                 "• Account Age: " .. lp.AccountAge .. " Days\n" ..
                 "• Device: " .. (UserInputService.TouchEnabled and "Mobile/Tablet" or "PC/Laptop") .. "\n" ..
                 "• Status: Active"
DetailText.TextColor3 = Color3.fromRGB(220, 220, 220)
DetailText.Font = Enum.Font.Gotham
DetailText.TextSize = 14
DetailText.TextWrapped = true
DetailText.TextXAlignment = Enum.TextXAlignment.Left
DetailText.TextYAlignment = Enum.TextYAlignment.Top

-- [[ LOGIKA INTERAKSI ]] --

-- Buka MainFrame
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
end)

-- Tutup MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Fungsi Geser (Draggable System)
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(IconBtn)
makeDraggable(MainFrame)

print("PHANTOM SYSTEM: SUCCESS LOADED")
