-- [[ PHANTOM ULTIMATE v3: INTEGRATED EDITION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local JointService = game:GetService("JointsService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local activeRemotes = {}
local selectedRemote = nil

-- Hapus GUI lama agar tidak double
if CoreGui:FindFirstChild("PhantomIntegrated_V3") then
    CoreGui.PhantomIntegrated_V3:Destroy()
end

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomIntegrated_V3"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 420) 
Main.Position = UDim2.new(0.5, -140, 0.4, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.BorderSizePixel = 0
Main.Visible = true
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127)
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "PHANTOM ULTIMATE: ALL-IN-ONE"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.BackgroundTransparency = 1

--- --- --- --- --- ---
-- [[ 1. RANK SPOOFER (HD ADMIN) ]] --
--- --- --- --- --- ---
local SpooferBtn = Instance.new("TextButton", Main)
SpooferBtn.Size = UDim2.new(0.9, 0, 0, 30)
SpooferBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
SpooferBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
SpooferBtn.Text = "SPOOF RANK (HD ADMIN)"
SpooferBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
SpooferBtn.Font = Enum.Font.GothamBold
SpooferBtn.TextSize = 10
Instance.new("UICorner", SpooferBtn)

SpooferBtn.MouseButton1Click:Connect(function()
    if _G.HDAdminMain and _G.HDAdminMain.pd then
        local pdata = _G.HDAdminMain.pd[lp]
        if pdata then
            pdata.Rank = 5
            SpooferBtn.Text = "RANK SPOOFED (LVL 5)!"
            task.wait(1)
            SpooferBtn.Text = "SPOOF RANK (HD ADMIN)"
        end
    else
        SpooferBtn.Text = "HD ADMIN NOT FOUND"
        task.wait(1)
        SpooferBtn.Text = "SPOOF RANK (HD ADMIN)"
    end
end)

--- --- --- --- --- ---
-- [[ 2. REMOTE LIST & LOGGER ]] --
--- --- --- --- --- ---
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0, 110)
Scroll.Position = UDim2.new(0.05, 0, 0.19, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 4)

local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0, 70)
LogFrame.Position = UDim2.new(0.05, 0, 0.47, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 2
local LogList = Instance.new("UIListLayout", LogFrame)

local function AddLog(text, color)
    local l = Instance.new("TextLabel", LogFrame)
    l.Size = UDim2.new(1, -10, 0, 16)
    l.BackgroundTransparency = 1
    l.Text = "[" .. os.date("%X") .. "] " .. text
    l.TextColor3 = color or Color3.new(1, 1, 1)
    l.Font = Enum.Font.Code
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogList.AbsoluteContentSize.Y)
    LogFrame.CanvasPosition = Vector2.new(0, LogList.AbsoluteContentSize.Y)
end

--- --- --- --- --- ---
-- [[ 3. MANUAL EXECUTION ]] --
--- --- --- --- --- ---
local ArgInput = Instance.new("TextBox", Main)
ArgInput.Size = UDim2.new(0.9, 0, 0, 30)
ArgInput.Position = UDim2.new(0.05, 0, 0.66, 0)
ArgInput.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
ArgInput.PlaceholderText = "Argument (String/Boolean)"
ArgInput.Text = ""
ArgInput.TextColor3 = Color3.white
ArgInput.TextSize = 10
Instance.new("UICorner", ArgInput)

local ExecBtn = Instance.new("TextButton", Main)
ExecBtn.Size = UDim2.new(0.9, 0, 0, 35)
ExecBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
ExecBtn.Text = "FIRE SELECTED REMOTE"
ExecBtn.TextColor3 = Color3.fromRGB(15, 20, 30)
ExecBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ExecBtn)

-- [[ SCANNER LOGIC ]] --
local function addRemoteItem(remote, isBackdoor)
    local Frame = Instance.new("Frame", Scroll)
    Frame.Size = UDim2.new(1, -6, 0, 30)
    Frame.BackgroundColor3 = isBackdoor and Color3.fromRGB(45, 20, 20) or Color3.fromRGB(25, 30, 40)
    Instance.new("UICorner", Frame)

    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. (isBackdoor and "[BD] " or "") .. remote.Name
    btn.TextColor3 = isBackdoor and Color3.fromRGB(255, 100, 100) or Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseButton1Click:Connect(function()
        selectedRemote = remote
        Title.Text = "SELECTED: " .. remote.Name:upper()
        Title.TextColor3 = Color3.fromRGB(85, 255, 127)
        AddLog("Selected: " .. remote.Name, Color3.fromRGB(255, 255, 255))
    end)
end

local function ScanAll()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    AddLog("Scanning Remotes...", Color3.fromRGB(255, 255, 100))
    
    -- Scan ReplicatedStorage
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then addRemoteItem(v, false) end
    end
    
    -- Scan Potential Backdoor Locations
    local locs = {JointService, game:GetService("LogService")}
    for _, loc in pairs(locs) do
        pcall(function()
            for _, v in pairs(loc:GetDescendants()) do
                if v:IsA("RemoteEvent") then addRemoteItem(v, true) end
            end
        end)
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 30)
ScanBtn.Position = UDim2.new(0.05, 0, 0.88, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
ScanBtn.Text = "REFRESH & SCAN LIST"
ScanBtn.TextColor3 = Color3.white
ScanBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ScanBtn)

ScanBtn.MouseButton1Click:Connect(ScanAll)

ExecBtn.MouseButton1Click:Connect(function()
    if selectedRemote then
        local val = ArgInput.Text
        if val == "true" then val = true elseif val == "false" then val = false end
        
        pcall(function()
            if selectedRemote:IsA("RemoteEvent") then
                selectedRemote:FireServer(val)
            elseif selectedRemote:IsA("RemoteFunction") then
                selectedRemote:InvokeServer(val)
            end
        end)
        AddLog("Executed " .. selectedRemote.Name, Color3.fromRGB(85, 255, 127))
    else
        AddLog("Error: No remote selected!", Color3.fromRGB(255, 100, 100))
    end
end)

-- [[ UTILS ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
OpenBtn.Text = "PH"
OpenBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
OpenBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(85, 255, 127)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(Main); makeDraggable(OpenBtn)
ScanAll()
AddLog("Phantom Integrated V3 Loaded.", Color3.fromRGB(85, 255, 127))
