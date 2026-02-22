-- [[ PHANTOM SQUARE: PROFILE UI SYSTEM ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ GET PLAYER DATA ]] --
local userId = lp.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size150x150
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
local playerBio = game:HttpGet("https://users.roblox.com/v1/users/"..userId):match('"description":"(.-)"') or "No Bio Available"

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomProfileSystem"
ScreenGui.ResetOnSpawn = false

-- [[ COMPACT ICON ]] --
local IconBtn = Instance.new("ImageButton", ScreenGui)
IconBtn.Name = "MainIcon"
IconBtn.Size = UDim2.new(0, 50, 0, 50)
IconBtn.Position = UDim2.new(0, 20, 0.5, -25)
IconBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
IconBtn.Image = content
IconBtn.ClipsDescendants = true
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- [[ PROFILE MAIN FRAME ]] --
local ProfileFrame = Instance.new("Frame", ScreenGui)
ProfileFrame.Name = "ProfileFrame"
ProfileFrame.Size = UDim2.new(0, 280, 0, 380)
ProfileFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
ProfileFrame.Visible = false
ProfileFrame.BorderSizePixel = 0
Instance.new("UICorner", ProfileFrame).CornerRadius = UDim.new(0, 15)

local MainStroke = Instance.new("UIStroke", ProfileFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 1.5

-- [[ PROFILE COMPONENTS ]] --
local function createLabel(name, text, pos, size, font, color, parent)
    local l = Instance.new("TextLabel", parent)
    l.Name = name
    l.Size = size
    l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color
    l.Font = font
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Center
    return l
end

-- Big Avatar Image
local AvatarImg = Instance.new("ImageLabel", ProfileFrame)
AvatarImg.Size = UDim2.new(0, 100, 0, 100)
AvatarImg.Position = UDim2.new(0.5, -50, 0, 30)
AvatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
AvatarImg.Image = content
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
local AvStroke = Instance.new("UIStroke", AvatarImg)
AvStroke.Color = Color3.fromRGB(0, 255, 255)

-- Display Name & Username
local DisplayName = createLabel("DisplayName", lp.DisplayName, UDim2.new(0,0,0,140), UDim2.new(1,0,0,20), Enum.Font.GothamBold, Color3.fromRGB(255,255,255), ProfileFrame)
DisplayName.TextSize = 18

local UserName = createLabel("UserName", "@"..lp.Name, UDim2.new(0,0,0,160), UDim2.new(1,0,0,20), Enum.Font.Gotham, Color3.fromRGB(150,150,150), ProfileFrame)

-- Separator
local Line = Instance.new("Frame", ProfileFrame)
Line.Size = UDim2.new(0.8, 0, 0, 1)
Line.Position = UDim2.new(0.1, 0, 0, 190)
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Line.BackgroundTransparency = 0.5

-- ID & Info Section
local InfoBox = Instance.new("Frame", ProfileFrame)
InfoBox.Size = UDim2.new(0.9, 0, 0, 150)
InfoBox.Position = UDim2.new(0.05, 0, 0, 205)
InfoBox.BackgroundTransparency = 1

local UserID = createLabel("UserID", "ID: "..lp.UserId, UDim2.new(0,0,0,0), UDim2.new(1,0,0,20), Enum.Font.Code, Color3.fromRGB(0, 255, 255), InfoBox)
local AccountAge = createLabel("Age", "Account Age: "..lp.AccountAge.." days", UDim2.new(0,0,0,20), UDim2.new(1,0,0,20), Enum.Font.Gotham, Color3.fromRGB(200,200,200), InfoBox)

-- Bio Section (Scrolling)
local BioScroll = Instance.new("ScrollingFrame", InfoBox)
BioScroll.Size = UDim2.new(1, 0, 0, 80)
BioScroll.Position = UDim2.new(0, 0, 0, 50)
BioScroll.BackgroundTransparency = 1
BioScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
BioScroll.ScrollBarThickness = 2

local BioLabel = createLabel("Bio", "BIO:\n"..playerBio, UDim2.new(0,0,0,0), UDim2.new(1,0,1,0), Enum.Font.GothamItalic, Color3.fromRGB(180,180,180), BioScroll)
BioLabel.TextWrapped = true
BioLabel.TextYAlignment = Enum.TextYAlignment.Top

-- [[ INTERACTION ]] --
IconBtn.MouseButton1Click:Connect(function()
    ProfileFrame.Visible = not ProfileFrame.Visible
end)

-- Dragging Logic
local function makeDraggable(obj)
    local dragging, startPos, startObjPos
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
makeDraggable(ProfileFrame)

print("PHANTOM PROFILE SYSTEM READY")
