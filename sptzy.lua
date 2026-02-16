-- [[ PHANTOM ULTIMATE v3: FINAL INTEGRATED EDITION ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local JointService = game:GetService("JointsService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local activeRemotes = {}
local selectedRemote = nil

-- Hapus GUI lama agar tidak tumpang tindih
if CoreGui:FindFirstChild("PhantomUltimate_Final") then
    CoreGui.PhantomUltimate_Final:Destroy()
end

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomUltimate_Final"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 460) 
Main.Position = UDim2.new(0.5, -150, 0.4, -230)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.BorderSizePixel = 0
Main.Visible = true
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127)
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "PHANTOM ULTIMATE: FISH IT STYLE"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.BackgroundTransparency = 1

--- --- --- --- --- ---
-- [[ 1. ADVANCED RANK SPOOFER ]] --
--- --- --- --- --- ---
local SpooferBtn = Instance.new("TextButton", Main)
SpooferBtn.Size = UDim2.new(0.9, 0, 0, 35)
SpooferBtn.Position = UDim2.new(0.05, 0, 0.09, 0)
SpooferBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
SpooferBtn.Text = "SPOOF RANK: OWNER (5)"
SpooferBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
SpooferBtn.Font = Enum.Font.GothamBold
SpooferBtn.TextSize = 10
Instance.new("UICorner", SpooferBtn)

SpooferBtn.MouseButton1Click:Connect(function()
    if _G.HDAdminMain then
        local pdata = _G.HDAdminMain.pd[lp]
        if pdata then
            pdata.Rank = 5
            if pdata.SetupData then
                pdata.SetupData.Rank = 5
                pdata.SetupData.Permissions = _G.HDAdminMain.permissions
            end
            SpooferBtn.Text = "RANK SPOOFED!"
            task.wait(1)
            SpooferBtn.Text = "SPOOF RANK: OWNER (5)"
        end
    else
        SpooferBtn.Text = "HD ADMIN NOT DETECTED"
        task.wait(1)
        SpooferBtn.Text = "SPOOF RANK: OWNER (5)"
    end
end)

--- --- --- --- --- ---
-- [[ 2. REMOTE LIST & LOGGER ]] --
--- --- --- --- --- ---
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0, 100)
Scroll.Position = UDim2.new(0.05, 0, 0.18, 0)
Scroll.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 4)

local LogFrame = Instance.new("ScrollingFrame", Main)
LogFrame.Size = UDim2.new(0.9, 0, 0, 60)
LogFrame.Position = UDim2.new(0.05, 0, 0.41, 0)
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
-- [[ 3. DUAL-ARGUMENT EXECUTOR ]] --
--- --- --- --- --- ---
local Arg1 = Instance.new("TextBox", Main)
Arg1.Size = UDim2.new(0.9, 0, 0, 30)
Arg1.Position = UDim2.new(0.05, 0, 0.56, 0)
Arg1.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Arg1.PlaceholderText = "Argument 1 (Cmd/Value)"
Arg1.Text = ""
Arg1.TextColor3 = Color3.white
Arg1.TextSize = 10
Instance.new("UICorner", Arg1)

local Arg2 = Instance.new("TextBox", Main)
Arg2.Size = UDim2.new(0.9, 0, 0, 30)
Arg2.Position = UDim2.new(0.05, 0, 0.64, 0)
Arg2.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
Arg2.PlaceholderText = "Argument 2 (Target/Extra)"
Arg2.Text = ""
Arg2.TextColor3 = Color3.white
Arg2.TextSize = 10
Instance.new("UICorner", Arg2)

local ExecBtn = Instance.new("TextButton", Main)
ExecBtn.Size = UDim2.new(0.9, 0, 0, 35)
ExecBtn.Position = UDim2.new(0.05, 0, 0.73, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
ExecBtn.Text = "FIRE REMOTE"
ExecBtn.TextColor3 = Color3.fromRGB(15, 20, 30)
ExecBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ExecBtn)

-- [[ SCANNER LOGIC (FISH IT STYLE + BACKDOOR) ]] --
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
        AddLog("Selected: " .. remote.Name)
    end)
end

local function ScanAll()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    AddLog("Scanning Remotes...", Color3.fromRGB(255, 255, 100))
    
    -- Fish It Logic: Scan HD Admin Signals first
    if _G.HDAdminMain and _G.HDAdminMain.signals then
        for _, v in pairs(_G.HDAdminMain.signals:GetChildren()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then addRemoteItem(v, false) end
        end
        AddLog("HD Admin Signals Scanned.")
    end

    -- Scan ReplicatedStorage
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then addRemoteItem(v, false) end
    end
    
    -- Scan Backdoor Locations
    local locs = {JointService, game:GetService("LogService")}
    for _, loc in pairs(locs) do
        pcall(function()
            for _, v in pairs(loc:GetDescendants()) do
                if v:IsA("RemoteEvent") then addRemoteItem(v, true) end
            end
        end)
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
    AddLog("Scan Complete.", Color3.fromRGB(85, 255, 127))
end

local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0, 270, 0, 35)
ScanBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
ScanBtn.Text = "FULL REFRESH SCAN"
ScanBtn.TextColor3 = Color3.white
ScanBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ScanBtn)

ScanBtn.MouseButton1Click:Connect(ScanAll)

ExecBtn.MouseButton1Click:Connect(function()
    if selectedRemote then
        local a1 = Arg1.Text
        local a2 = Arg2.Text
        -- Convert simple booleans
        if a1 == "true" then a1 = true elseif a1 == "false" then a1 = false end
        if a2 == "true" then a2 = true elseif a2 == "false" then a2 = false end
        
        pcall(function()
            if selectedRemote:IsA("RemoteEvent") then
                selectedRemote:FireServer(a1, a2)
            elseif selectedRemote:IsA("RemoteFunction") then
                task.spawn(function() selectedRemote:InvokeServer(a1, a2) end)
            end
        end)
        AddLog("Fired: " .. selectedRemote.Name, Color3.fromRGB(85, 255, 127))
    else
        AddLog("Error: Select a remote!", Color3.fromRGB(255, 100, 100))
    end
end)

-- [[ UTILS (DRAG & TOGGLE) ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
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
AddLog("Phantom Ultimate V3 Final Loaded.", Color3.fromRGB(85, 255, 127))
