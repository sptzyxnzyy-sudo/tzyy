-- [[ SPTZYY REQABLE X-SCANNER - PRO EDITION ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

local snifferActive = false

-- [[ UI ENGINE ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Reqable_" .. math.random(100, 999)
ScreenGui.Parent = gethui and gethui() or CoreGui or lp:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Position = UDim2.new(0.5, -225, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0

-- Shadow & Border
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 1.5

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "REQABLE NETWORK | STEALTH SNIFFER"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Container Log (Scroll Luas)
local LogContainer = Instance.new("ScrollingFrame", MainFrame)
LogContainer.Size = UDim2.new(1, -20, 0, 280)
LogContainer.Position = UDim2.new(0, 10, 0, 45)
LogContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogContainer.CanvasSize = UDim2.new(2, 0, 0, 0) -- Lebar 2x agar data panjang tidak terpotong
LogContainer.ScrollBarThickness = 4
LogContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
LogContainer.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", LogContainer)
UIList.Padding = UDim.new(0, 4)

-- [[ LOGIC: SCANNER & COPY ]] --
local function GetPath(obj)
    local p = obj:GetFullName()
    return p
end

local function FormatTable(t)
    local s = "{"
    for i, v in pairs(t) do
        s = s .. tostring(i) .. ":" .. tostring(v) .. ", "
    end
    return s:sub(1, #s-2) .. "}"
end

local function CreateLog(type, remote, args, result)
    local argStr = FormatTable(args)
    local resStr = result and tostring(result) or "nil"
    local fullPath = GetPath(remote)

    local LogBtn = Instance.new("TextButton", LogContainer)
    LogBtn.Size = UDim2.new(1, 0, 0, 65)
    LogBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogBtn.AutoButtonColor = true
    LogBtn.Text = ""
    LogBtn.BorderSizePixel = 0

    local TypeTag = Instance.new("TextLabel", LogBtn)
    TypeTag.Size = UDim2.new(0, 70, 0, 15)
    TypeTag.Position = UDim2.new(0, 5, 0, 5)
    TypeTag.BackgroundColor3 = type == "FIRE" and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 150, 0)
    TypeTag.Text = type
    TypeTag.TextColor3 = Color3.fromRGB(255, 255, 255)
    TypeTag.Font = Enum.Font.CodeBold
    TypeTag.TextSize = 10

    local PathLbl = Instance.new("TextLabel", LogBtn)
    PathLbl.Size = UDim2.new(1, -85, 0, 15)
    PathLbl.Position = UDim2.new(0, 80, 0, 5)
    PathLbl.Text = fullPath
    PathLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    PathLbl.BackgroundTransparency = 1
    PathLbl.TextXAlignment = Enum.TextXAlignment.Left
    PathLbl.Font = Enum.Font.Code
    PathLbl.TextSize = 10

    local Content = Instance.new("TextLabel", LogBtn)
    Content.Size = UDim2.new(1, -10, 0, 40)
    Content.Position = UDim2.new(0, 5, 0, 22)
    Content.Text = "Data: " .. argStr .. "\nRet: " .. resStr
    Content.TextColor3 = Color3.fromRGB(0, 255, 150)
    Content.TextWrapped = true
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.BackgroundTransparency = 1
    Content.Font = Enum.Font.Code
    Content.TextSize = 9

    -- Fitur Copy Klik
    LogBtn.MouseButton1Click:Connect(function()
        local copyData = string.format("-- REQABLE LOG --\nPath: %s\nArgs: %s\nResult: %s", fullPath, argStr, resStr)
        if setclipboard then
            setclipboard(copyData)
            PathLbl.Text = "COPIED TO CLIPBOARD!"
            task.wait(1)
            PathLbl.Text = fullPath
        end
    end)

    LogContainer.CanvasSize = UDim2.new(2, 0, 0, UIList.AbsoluteContentSize.Y + 10)
end

-- [[ HOOKING ENGINE ]] --
local oldNC
oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if snifferActive then
        if method == "FireServer" then
            task.spawn(CreateLog, "FIRE", self, args)
        elseif method == "InvokeServer" then
            local res = {oldNC(self, ...)}
            task.spawn(CreateLog, "INVOKE", self, args, res[1])
            return unpack(res)
        end
    end

    return oldNC(self, ...)
end))

-- [[ CONTROLS ]] --
local function CreateActionBtn(text, pos, color, callback)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0, 210, 0, 50)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.BorderSizePixel = 1
    b.BorderColor3 = color
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.Code
    b.TextSize = 11

    b.MouseButton1Click:Connect(function() callback(b) end)
end

CreateActionBtn("START SCANNER", UDim2.new(0, 10, 0, 340), Color3.fromRGB(0, 255, 150), function(b)
    snifferActive = not snifferActive
    b.Text = snifferActive and "STOP SCANNER" or "START SCANNER"
    b.BackgroundColor3 = snifferActive and Color3.fromRGB(0, 80, 50) or Color3.fromRGB(20, 20, 20)
end)

CreateActionBtn("CLEAR LOGS", UDim2.new(0, 230, 0, 340), Color3.fromRGB(255, 50, 50), function()
    for _, v in pairs(LogContainer:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    LogContainer.CanvasSize = UDim2.new(2, 0, 0, 0)
end)

-- Draggable UI
local d, s, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; s = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - s; MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
