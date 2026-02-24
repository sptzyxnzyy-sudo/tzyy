-- [[ SPTZYY NETWORK ANALYZER - CODE GENERATOR + COPY ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local scanActive = false
local execSupport = false
local monitored = {}

-- [[ UI SETUP: SQUARE INDUSTRIAL ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui") or lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "Sptzyy_ScriptSpy"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 340)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "REMOTE CODE SPY (AUTO-GEN)"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local LogBox = Instance.new("ScrollingFrame", MainFrame)
LogBox.Size = UDim2.new(1, -20, 0, 230)
LogBox.Position = UDim2.new(0, 10, 0, 40)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.BorderSizePixel = 1
LogBox.BorderColor3 = Color3.fromRGB(40, 40, 40)
LogBox.CanvasSize = UDim2.new(0, 0, 0, 0)
LogBox.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", LogBox)
UIList.Padding = UDim.new(0, 5)

-- [[ LOGIKA GENERATOR KODE ]] --
local function GetPath(obj)
    local path = obj.Name
    local parent = obj.Parent
    while parent and parent ~= game do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end
    return "game." .. path
end

local function GenerateCode(obj, args)
    local path = GetPath(obj)
    local method = obj:IsA("RemoteEvent") and "FireServer" or "InvokeServer"
    -- Membersihkan argumen menjadi string kode
    local argStr = ""
    if args then
        for i, v in pairs(args) do
            local val = type(v) == "string" and '"'..v..'"' or tostring(v)
            argStr = argStr .. val .. (i < #args and ", " or "")
        end
    end
    return string.format('%s:%s(%s)', path, method, argStr)
end

local function AddLog(fullCode)
    local LogEntry = Instance.new("TextButton", LogBox)
    LogEntry.Size = UDim2.new(1, 0, 0, 40)
    LogEntry.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    LogEntry.BorderSizePixel = 0
    LogEntry.Text = "  " .. fullCode
    LogEntry.TextColor3 = Color3.fromRGB(0, 255, 150)
    LogEntry.Font = Enum.Font.Code
    LogEntry.TextSize = 9
    LogEntry.TextXAlignment = Enum.TextXAlignment.Left
    LogEntry.ClipsDescendants = true

    LogEntry.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(fullCode)
            LogEntry.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            task.wait(0.2)
            LogEntry.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
    end)
    LogBox.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 40)
end

-- [[ MONITORING TANPA METATABLE ]] --
-- Menggunakan pcall scan untuk mendapatkan struktur pengirimnya
local function ScanRemoteActivity()
    for _, v in pairs(game:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and not monitored[v] then
            monitored[v] = true
            
            -- Karena tanpa Metatable Hooking, kita generate kode 'Template' 
            -- atau intercept via OnClientEvent jika itu adalah respon balik
            task.spawn(function()
                if scanActive then
                    local codeSnippet = GenerateCode(v, {"arg1", "arg2"}) -- Template logika
                    AddLog(codeSnippet)
                end
            end)
        end
    end
end

-- [[ CONTROLS ]] --
local function CreateBtn(name, x, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 135, 0, 40)
    btn.Position = UDim2.new(0, x, 0, 285)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.RobotoMono
    btn.TextSize = 10

    local act = false
    btn.MouseButton1Click:Connect(function()
        act = not act
        btn.BackgroundColor3 = act and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(20, 20, 20)
        callback(act)
    end)
end

CreateBtn("GENERATE CODE", 10, function(v) 
    scanActive = v 
    if v then ScanRemoteActivity() end 
end)

CreateBtn("CLEAR LOGS", 155, function() 
    for _, child in pairs(LogBox:GetChildren()) do 
        if child:IsA("TextButton") then child:Destroy() end 
    end 
    LogBox.CanvasSize = UDim2.new(0,0,0,0)
end)

-- Draggable
local d, s, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - s; MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
