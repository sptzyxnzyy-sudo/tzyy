-- [[ PHANTOM ULTIMATE v3: FIXED VISIBILITY ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Hapus GUI lama jika ada agar tidak tumpang tindih
if CoreGui:FindFirstChild("PhantomUltimate_HD") then
    CoreGui.PhantomUltimate_HD:Destroy()
end

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomUltimate_HD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- Memastikan koordinat tepat

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 360) 
Main.Position = UDim2.new(0.5, -130, 0.5, -180) -- Tengah Layar
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.BorderSizePixel = 0
Main.Visible = true -- Langsung muncul untuk tes
Main.ZIndex = 10
Instance.new("UICorner", Main)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127)
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "PHANTOM ULTIMATE v3"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

--- --- --- --- --- ---
-- [[ 1. RANK SPOOFER ]] --
--- --- --- --- --- ---
local SpooferFrame = Instance.new("Frame", Main)
SpooferFrame.Size = UDim2.new(0.9, 0, 0, 35)
SpooferFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
SpooferFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
Instance.new("UICorner", SpooferFrame)

local SpooferBtn = Instance.new("TextButton", SpooferFrame)
SpooferBtn.Size = UDim2.new(1, 0, 1, 0)
SpooferBtn.BackgroundTransparency = 1
SpooferBtn.Text = "SPOOF RANK (HD ADMIN)"
SpooferBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
SpooferBtn.Font = Enum.Font.GothamBold
SpooferBtn.TextSize = 10

SpooferBtn.MouseButton1Click:Connect(function()
    if _G.HDAdminMain and _G.HDAdminMain.pd then
        local pdata = _G.HDAdminMain.pd[lp]
        if pdata then
            pdata.Rank = 5
            SpooferBtn.Text = "RANK SPOOFED!"
            task.wait(1)
            SpooferBtn.Text = "SPOOF RANK (HD ADMIN)"
        end
    else
        SpooferBtn.Text = "HD ADMIN NOT DETECTED"
        task.wait(1)
        SpooferBtn.Text = "SPOOF RANK (HD ADMIN)"
    end
end)

--- --- --- --- --- ---
-- [[ 2. REMOTE LIST ]] --
--- --- --- --- --- ---
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0, 120)
Scroll.Position = UDim2.new(0.05, 0, 0.25, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 4)

local selectedRemote = nil

local function ScanRemotes()
    for _, child in pairs(Scroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
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
                Title.Text = "SELECTED: " .. v.Name:upper()
                Title.TextColor3 = Color3.fromRGB(85, 255, 127)
            end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0,0,0, ListLayout.AbsoluteContentSize.Y)
end

--- --- --- --- --- ---
-- [[ 3. EXECUTION ]] --
--- --- --- --- --- ---
local Arg1 = Instance.new("TextBox", Main)
Arg1.Size = UDim2.new(0.9, 0, 0, 30)
Arg1.Position = UDim2.new(0.05, 0, 0.62, 0)
Arg1.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Arg1.PlaceholderText = "Argument 1"
Arg1.Text = ""
Arg1.TextColor3 = Color3.white
Instance.new("UICorner", Arg1)

local ExecBtn = Instance.new("TextButton", Main)
ExecBtn.Size = UDim2.new(0.9, 0, 0, 35)
ExecBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
ExecBtn.Text = "EXECUTE"
ExecBtn.TextColor3 = Color3.fromRGB(15, 20, 30)
ExecBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ExecBtn)

local RefreshBtn = Instance.new("TextButton", Main)
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 30)
RefreshBtn.Position = UDim2.new(0.05, 0, 0.88, 0)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
RefreshBtn.Text = "REFRESH LIST"
RefreshBtn.TextColor3 = Color3.white
RefreshBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RefreshBtn)

-- [[ BUTTON LOGIC ]] --
RefreshBtn.MouseButton1Click:Connect(ScanRemotes)
ExecBtn.MouseButton1Click:Connect(function()
    if selectedRemote then
        pcall(function()
            if selectedRemote:IsA("RemoteEvent") then
                selectedRemote:FireServer(Arg1.Text)
            elseif selectedRemote:IsA("RemoteFunction") then
                selectedRemote:InvokeServer(Arg1.Text)
            end
        end)
        ExecBtn.Text = "SUCCESS!"
        task.wait(0.5)
        ExecBtn.Text = "EXECUTE"
    end
end)

-- [[ ICON / OPEN BUTTON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "ToggleIcon"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25) -- Di sisi kiri layar
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
OpenBtn.Text = "PH"
OpenBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 14
OpenBtn.ZIndex = 11
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", OpenBtn)
IconStroke.Color = Color3.fromRGB(85, 255, 127)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- [[ DRAG LOGIC ]] --
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(Main)
makeDraggable(OpenBtn)
ScanRemotes()
