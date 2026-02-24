-- [[ SPTZYY STEALTH ADMIN SYSTEM - ANTI-DETECTION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local manipulationActive = false
local antiKickActive = true
local myID = lp.UserId
local monitoredRemotes = {}

-- [[ STEALTH UI INITIALIZATION ]] --
local ScreenGui = Instance.new("ScreenGui")
-- Menggunakan nama acak agar tidak bisa di-find oleh script Anti-Cheat
ScreenGui.Name = "System_" .. math.random(1000, 9999)
ScreenGui.Parent = game:GetService("CoreGui") or lp:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 340)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150) -- Stealth Green

-- Header Stealth
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "STEALTH NETWORK MANIPULATOR"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Terminal Box
local LogBox = Instance.new("ScrollingFrame", MainFrame)
LogBox.Size = UDim2.new(1, -20, 0, 220)
LogBox.Position = UDim2.new(0, 10, 0, 40)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.BorderSizePixel = 1
LogBox.BorderColor3 = Color3.fromRGB(30, 30, 30)
LogBox.CanvasSize = UDim2.new(0, 0, 0, 0)
LogBox.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", LogBox)
UIList.Padding = UDim.new(0, 3)

-- [[ STEALTH CORE: BYPASS & ANTI-KICK ]] --
local function SecureHook()
    local gmt = getrawmetatable(game)
    local oldNamecall = gmt.__namecall
    local oldIndex = gmt.__index
    setreadonly(gmt, false)

    -- Mencegah Script Admin menemukan UI ini melalui Namecall
    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() then
            if method == "FindFirstChild" or method == "GetChildren" then
                if tostring(self) == "CoreGui" or tostring(self) == "PlayerGui" then
                    local res = oldNamecall(self, ...)
                    if res == ScreenGui then return nil end
                end
            end
        end
        
        -- Anti-Kick Stealth
        if antiKickActive and (method == "Kick" or method == "kick") then
            return nil 
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(gmt, true)
end
pcall(SecureHook)

-- [[ LOGIKA MANIPULASI STEALTH ]] --
local function GetCleanPath(obj)
    local path = obj.Name
    local parent = obj.Parent
    while parent and parent ~= game do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end
    return "game." .. path
end

local function AddLog(remote, injectedCode)
    local LogBtn = Instance.new("TextButton", LogBox)
    LogBtn.Size = UDim2.new(1, 0, 0, 40)
    LogBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogBtn.Text = "  [SAFE] " .. remote.Name
    LogBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    LogBtn.Font = Enum.Font.Code
    LogBtn.TextSize = 9
    LogBtn.TextXAlignment = Enum.TextXAlignment.Left
    LogBtn.BorderSizePixel = 0

    LogBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(injectedCode) end
    end)
    LogBox.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

local function StealthScan()
    local descendants = game:GetDescendants()
    for i, v in pairs(descendants) do
        -- Delay kecil setiap 20 objek untuk menghindari deteksi lag/freeze
        if i % 20 == 0 then task.wait() end
        
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and not monitoredRemotes[v] then
            monitoredRemotes[v] = true
            if manipulationActive then
                local path = GetCleanPath(v)
                local method = v:IsA("RemoteEvent") and "FireServer" or "InvokeServer"
                local flow = string.format('%s:%s(%s, "Admin", true)', path, method, myID)
                
                AddLog(v, flow)
                
                -- Eksekusi dengan proteksi pcall
                task.spawn(function()
                    pcall(function() v[method](v, myID, "Admin", true) end)
                end)
            end
        end
    end
end

-- [[ BUTTON CONTROLS ]] --
local function CreateSquareBtn(text, x, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 135, 0, 45)
    btn.Position = UDim2.new(0, x, 0, 275)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0, 255, 150)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.RobotoMono
    btn.TextSize = 10

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 50) or Color3.fromRGB(25, 25, 25)
        callback(state)
    end)
end

CreateSquareBtn("STEALTH ADMIN", 10, function(v)
    manipulationActive = v
    if v then task.spawn(StealthScan) end
end)

CreateSquareBtn("CLEAR LOGS", 155, function()
    for _, c in pairs(LogBox:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    LogBox.CanvasSize = UDim2.new(0,0,0,0)
end)

-- Standard Drag System
local d, s, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - s; MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
