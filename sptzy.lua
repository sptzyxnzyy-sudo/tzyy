-- [[ PHANTOM SQUARE: PROFILE SYSTEM (SQUARE EDITION) ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ AMBIL DATA PROFIL ]] --
local userId = lp.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomSquareUI"
ScreenGui.ResetOnSpawn = false

-- [[ 1. ICON (LAUNCHER) ]] --
local IconBtn = Instance.new("ImageButton", ScreenGui)
IconBtn.Size = UDim2.new(0, 50, 0, 50)
IconBtn.Position = UDim2.new(0, 50, 0.5, -25)
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
IconBtn.Image = content
IconBtn.BorderSizePixel = 0
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(0, 8) -- Square-ish round

local IconStroke = Instance.new("UIStroke", IconBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- [[ 2. GUI FITUR (SQUARE FRAME) ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 300) -- Persegi Sempurna
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Visible = false
MainFrame.BorderSizePixel = 0

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 1.5

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 30
CloseBtn.Font = Enum.Font.GothamBold

-- Avatar Box (Square)
local AvatarImg = Instance.new("ImageLabel", MainFrame)
AvatarImg.Size = UDim2.new(0, 80, 0, 80)
AvatarImg.Position = UDim2.new(0, 20, 0, 20)
AvatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
AvatarImg.Image = content
AvatarImg.BorderSizePixel = 0
local AvStroke = Instance.new("UIStroke", AvatarImg)
AvStroke.Color = Color3.fromRGB(0, 255, 255)

-- Info Box (Text Labels)
local function addLabel(text, pos, font, size, color)
    local l = Instance.new("TextLabel", MainFrame)
    l.Size = UDim2.new(1, -120, 0, 20)
    l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color
    l.Font = font
    l.TextSize = size
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

addLabel(lp.DisplayName, UDim2.new(0, 115, 0, 30), Enum.Font.GothamBold, 18, Color3.fromRGB(255,255,255))
addLabel("@"..lp.Name, UDim2.new(0, 115, 0, 50), Enum.Font.Gotham, 14, Color3.fromRGB(150,150,150))
addLabel("ID: "..lp.UserId, UDim2.new(0, 115, 0, 70), Enum.Font.Code, 12, Color3.fromRGB(0, 255, 255))

-- Bio / Status Section (Persegi Bawah)
local BioBox = Instance.new("Frame", MainFrame)
BioBox.Size = UDim2.new(1, -40, 0, 150)
BioBox.Position = UDim2.new(0, 20, 0, 120)
BioBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UIStroke", BioBox).Color = Color3.fromRGB(30, 30, 40)

local BioText = Instance.new("TextLabel", BioBox)
BioText.Size = UDim2.new(1, -10, 1, -10)
BioText.Position = UDim2.new(0, 5, 0, 5)
BioText.BackgroundTransparency = 1
BioText.Text = "ACCOUNT INFO\n\n• Membership: "..lp.MembershipType.Name.."\n• Age: "..lp.AccountAge.." Days\n• Platform: "..UserInputService:GetPlatform().Name
BioText.TextColor3 = Color3.fromRGB(200, 200, 200)
BioText.Font = Enum.Font.Gotham
BioText.TextSize = 14
BioText.TextWrapped = true
BioText.TextYAlignment = Enum.TextYAlignment.Top
BioText.TextXAlignment = Enum.TextXAlignment.Left

-- [[ INTERACTION LOGIC ]] --

-- Buka GUI
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
end)

-- Tutup GUI
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Fungsi Geser (Draggable)
local function makeDraggable(obj)
    local dragging, input, startPos, startObjPos
    obj.InputBegan:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; startPos = inp.Position; startObjPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - startPos
            obj.Position = UDim2.new(startObjPos.X.Scale, startObjPos.X.Offset + delta.X, startObjPos.Y.Scale, startObjPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then dragging = false end
    end)
end

makeDraggable(IconBtn)
makeDraggable(MainFrame)

print("PHANTOM SQUARE UI: PROFILE SYSTEM LOADED")
