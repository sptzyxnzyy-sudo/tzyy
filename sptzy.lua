-- [[ SPTZYY ADMIN FLOW EXECUTOR - SQUARE EDITION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local adminFlowActive = false
local myID = lp.UserId

-- [[ UI SETUP: SQUARE INDUSTRIAL ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui") or lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "Sptzyy_AdminFlow"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)

-- Header baris tajam
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "ADMIN FLOW SUPPORT V10"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Terminal Box
local LogBox = Instance.new("ScrollingFrame", MainFrame)
LogBox.Size = UDim2.new(1, -20, 0, 220)
LogBox.Position = UDim2.new(0, 10, 0, 45)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.BorderSizePixel = 1
LogBox.BorderColor3 = Color3.fromRGB(40, 40, 40)
LogBox.CanvasSize = UDim2.new(0, 0, 0, 0)
LogBox.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", LogBox)
UIList.Padding = UDim.new(0, 4)

-- [[ LOGIKA ALUR EKSEKUSI ]] --
local function GetPath(obj)
    local path = obj.Name
    local p = obj.Parent
    while p and p ~= game do
        path = p.Name .. "." .. path
        p = p.Parent
    end
    return "game." .. path
end

local function AddLog(remote, code)
    local LogBtn = Instance.new("TextButton", LogBox)
    LogBtn.Size = UDim2.new(1, 0, 0, 50)
    LogBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogBtn.BorderSizePixel = 0
    LogBtn.Text = "  [REMOTE] " .. remote.Name .. "\n  [FLOW] Injected ID: " .. myID
    LogBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
    LogBtn.Font = Enum.Font.Code
    LogBtn.TextSize = 9
    LogBtn.TextXAlignment = Enum.TextXAlignment.Left

    LogBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(code)
            LogBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(0.2)
            LogBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        end
    end)
    LogBox.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

local function ExecuteAdminFlow()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            task.spawn(function()
                if adminFlowActive then
                    local path = GetPath(v)
                    local method = v:IsA("RemoteEvent") and "FireServer" or "InvokeServer"
                    
                    -- Alur Manipulasi ID yang Berfungsi
                    -- Mencoba 3 alur admin umum: ID saja, String Admin, dan Boolean
                    local flowCode = string.format('%s:%s(%s, "Admin", true)', path, method, myID)
                    
                    AddLog(v, flowCode)
                    
                    -- Eksekusi Langsung ke Server
                    pcall(function()
                        v[method](v, myID, "Admin", true)
                        v[method](v, "Admin", myID)
                        v[method](v, true, myID)
                    end)
                end
            end)
        end
    end
end

-- [[ BUTTON CONTROLS ]] --
local function CreateSquareBtn(text, x, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 135, 0, 45)
    btn.Position = UDim2.new(0, x, 0, 285)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.RobotoMono
    btn.TextSize = 10

    local st = false
    btn.MouseButton1Click:Connect(function()
        st = not st
        btn.BackgroundColor3 = st and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)
        callback(st)
    end)
end

CreateSquareBtn("EXECUTE FLOW", 10, function(v)
    adminFlowActive = v
    if v then ExecuteAdminFlow() end
end)

CreateSquareBtn("CLEAR LOGS", 155, function()
    for _, c in pairs(LogBox:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    LogBox.CanvasSize = UDim2.new(0,0,0,0)
end)

-- Drag System
local d, s, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - s; MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
