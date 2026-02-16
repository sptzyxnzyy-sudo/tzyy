-- [[ PHANTOM ULTIMATE: FISH IT STYLE ]] --
-- Integrated with HD Admin Framework Logic & Advanced Executor

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- << WAIT FOR HD ADMIN FRAMEWORK >>
local mainHD = _G.HDAdminMain
task.spawn(function()
    if not mainHD then
        print("Searching for HD Admin...")
        local timeout = 0
        while not _G.HDAdminMain and timeout < 20 do
            task.wait(0.5)
            timeout = timeout + 0.5
        end
        mainHD = _G.HDAdminMain
    end
end)

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomUltimate_HD"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 360) -- Ukuran lebih proporsional
Main.Position = UDim2.new(0.5, -130, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127)
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "PHANTOM ULTIMATE v2"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

-- [[ 1. RANK SPOOFER ]] --
local SpooferFrame = Instance.new("Frame", Main)
SpooferFrame.Size = UDim2.new(0.9, 0, 0, 35)
SpooferFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
SpooferFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
Instance.new("UICorner", SpooferFrame)

local SpooferBtn = Instance.new("TextButton", SpooferFrame)
SpooferBtn.Size = UDim2.new(1, 0, 1, 0)
SpooferBtn.BackgroundTransparency = 1
SpooferBtn.Text = "SPOOF RANK: OWNER"
SpooferBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
SpooferBtn.Font = Enum.Font.GothamBold
SpooferBtn.TextSize = 10

SpooferBtn.MouseButton1Click:Connect(function()
    if _G.HDAdminMain then
        local pdata = _G.HDAdminMain.pd[lp]
        if pdata then
            pdata.Rank = 5
            if pdata.SetupData then
                pdata.SetupData.Rank = 5
            end
            SpooferBtn.Text = "RANK SPOOFED!"
            task.wait(1)
            SpooferBtn.Text = "SPOOF RANK: OWNER"
        end
    else
        SpooferBtn.Text = "HD ADMIN NOT FOUND"
        task.wait(1)
        SpooferBtn.Text = "SPOOF RANK: OWNER"
    end
end)

-- [[ 2. REMOTE LIST (SCROLL) ]] --
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0, 110)
Scroll.Position = UDim2.new(0.05, 0, 0.25, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 4)

local selectedRemote = nil

local function ScanRemotes()
    for _, child in pairs(Scroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    
    local target = ReplicatedStorage
    for _, v in pairs(target:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local Item = Instance.new("Frame", Scroll)
            Item.Size = UDim2.new(1, -6, 0, 28)
            Item.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
            Instance.new("UICorner", Item)

            local btn = Instance.new("TextButton", Item)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = "  " .. v.Name
            btn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 12

            btn.MouseButton1Click:Connect(function()
                selectedRemote = v
                Title.Text = "TARGET: " .. v.Name:upper()
                Title.TextColor3 = Color3.fromRGB(85, 255, 127)
            end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0,0,0, ListLayout.AbsoluteContentSize.Y)
end

-- [[ 3. ARGUMENTS & EXECUTION ]] --
local Arg1 = Instance.new("TextBox", Main)
Arg1.Size = UDim2.new(0.9, 0, 0, 30)
Arg1.Position = UDim2.new(0.05, 0, 0.6, 0)
Arg1.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Arg1.PlaceholderText = "Arg 1 (String/Command)"
Arg1.Text = ""
Arg1.TextColor3 = Color3.white
Arg1.Font = Enum.Font.SourceSans
Instance.new("UICorner", Arg1)

local Arg2 = Instance.new("TextBox", Main)
Arg2.Size = UDim2.new(0.9, 0, 0, 30)
Arg2.Position = UDim2.new(0.05, 0, 0.7, 0)
Arg2.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Arg2.PlaceholderText = "Arg 2 (Value/Target)"
Arg2.Text = ""
Arg2.TextColor3 = Color3.white
Arg2.Font = Enum.Font.SourceSans
Instance.new("UICorner", Arg2)

local ExecBtn = Instance.new("TextButton", Main)
ExecBtn.Size = UDim2.new(0.43, 0, 0, 32)
ExecBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
ExecBtn.Text = "FIRE"
ExecBtn.TextColor3 = Color3.fromRGB(15, 20, 30)
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextSize = 12
Instance.new("UICorner", ExecBtn)

local RefreshBtn = Instance.new("TextButton", Main)
RefreshBtn.Size = UDim2.new(0.43, 0, 0, 32)
RefreshBtn.Position = UDim2.new(0.52, 0, 0.82, 0)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
RefreshBtn.Text = "SCAN"
RefreshBtn.TextColor3 = Color3.white
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 12
Instance.new("UICorner", RefreshBtn)

-- [[ LOGIC ]] --
RefreshBtn.MouseButton1Click:Connect(ScanRemotes)

ExecBtn.MouseButton1Click:Connect(function()
    if selectedRemote then
        local a1 = Arg1.Text
        local a2 = Arg2.Text
        pcall(function()
            if selectedRemote:IsA("RemoteEvent") then
                selectedRemote:FireServer(a1, a2)
            elseif selectedRemote:IsA("RemoteFunction") then
                task.spawn(function() selectedRemote:InvokeServer(a1, a2) end)
            end
        end)
        ExecBtn.Text = "SENT!"
        task.wait(0.5)
        ExecBtn.Text = "FIRE"
    end
end)

-- [[ ICON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
OpenBtn.Text = "ULT"
OpenBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
OpenBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", OpenBtn)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(85, 255, 127)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(OpenBtn); drag(Main)
ScanRemotes()
