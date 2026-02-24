-- [[ SPTZYY NETWORK ANALYZER - OBJECT SPY & COPY ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local scanActive = false
local execSupport = false
local monitoredRemotes = {}

-- [[ UI SETUP: SQUARE INDUSTRIAL ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyScanner_V9"
ScreenGui.Parent = game:GetService("CoreGui") or lp:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, 0)
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
Title.Text = "REMOTE SENDER SPY + COPY"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local LogBox = Instance.new("ScrollingFrame", MainFrame)
LogBox.Size = UDim2.new(1, -20, 0, 210)
LogBox.Position = UDim2.new(0, 10, 0, 40)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.CanvasSize = UDim2.new(0, 0, 0, 0) -- Akan otomatis bertambah
LogBox.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", LogBox)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 2)

-- [[ FUNGSI COPY ]] --
local function SetClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    end
    return false
end

-- [[ FUNGSI ADD LOG (DENGAN CLICK TO COPY) ]] --
local function AddLog(remoteName, className)
    local LogEntry = Instance.new("TextButton", LogBox)
    LogEntry.Size = UDim2.new(1, 0, 0, 25)
    LogEntry.BackgroundTransparency = 1
    LogEntry.Text = string.format("[%s] %s", className:sub(1,3), remoteName)
    LogEntry.TextColor3 = Color3.fromRGB(0, 255, 150)
    LogEntry.Font = Enum.Font.Code
    LogEntry.TextSize = 10
    LogEntry.TextXAlignment = Enum.TextXAlignment.Left
    
    LogEntry.MouseButton1Click:Connect(function()
        if SetClipboard(remoteName) then
            LogEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
            LogEntry.Text = "COPIED!"
            task.wait(1)
            LogEntry.Text = string.format("[%s] %s", className:sub(1,3), remoteName)
            LogEntry.TextColor3 = Color3.fromRGB(0, 255, 150)
        end
    end)
    
    LogBox.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

-- [[ ALUR PENGIRIM & SCANNER (NON-HOOK) ]] --
local function ScanAndMonitor()
    for _, obj in pairs(game:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not monitoredRemotes[obj] then
            monitoredRemotes[obj] = true
            
            if scanActive then
                AddLog(obj.Name, obj.ClassName)
                
                -- Support Eksekusi Alur Pengirim
                if execSupport then
                    task.spawn(function()
                        pcall(function()
                            if obj:IsA("RemoteEvent") then
                                obj:FireServer("Sptzyy_Test") -- Alur pengiriman test
                            end
                        end)
                    end)
                end
            end
        end
    end
end

-- Loop Realtime Scan
task.spawn(function()
    while task.wait(2) do
        if scanActive then
            ScanAndMonitor()
        end
    end
end)

-- [[ TOMBOL KOTAK ]] --
local function CreateBtn(name, x, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 125, 0, 40)
    btn.Position = UDim2.new(0, x, 0, 265)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.RobotoMono
    btn.TextSize = 10
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(60, 60, 60)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(20, 20, 20)
        callback(active)
    end)
end

CreateBtn("SCAN SPY", 10, function(v) scanActive = v end)
CreateBtn("AUTO SEND", 145, function(v) execSupport = v end)

-- Drag System
local d, s, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - s; MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
