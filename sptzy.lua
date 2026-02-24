-- [[ SPTZYY ULTRA ADMIN SYSTEM + SAFE-SCAN PROTECTION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local adminFlowActive = false
local antiKickActive = true -- Default ON untuk keamanan
local lastTargetRemote = nil
local myID = lp.UserId

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui") or lp:WaitForChild("PlayerGui"))
ScreenGui.Name = "Sptzyy_SecuritySystem"

-- MAIN SCANNER FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150) -- Hijau Neon Aman

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "SAFE SCANNER & ADMIN INJECTOR"
Title.TextColor3 = Color3.new(0, 0, 0)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 10

-- COMMAND PANEL
local CmdFrame = Instance.new("Frame", ScreenGui)
CmdFrame.Size = UDim2.new(0, 220, 0, 220)
CmdFrame.Position = UDim2.new(0.6, 0, 0.4, 0)
CmdFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
CmdFrame.BorderSizePixel = 2
CmdFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
CmdFrame.Visible = false

-- [[ LOGIKA ANTI-KICK CORE ]] --
local function EnableSafeMode()
    -- Hook fungsi Kick dasar
    local oldKick
    oldKick = hookfunction(lp.Kick, function(self, reason)
        if antiKickActive then
            warn("SAFE-SCAN: Memblokir upaya Kick. Alasan: " .. tostring(reason))
            return nil
        end
        return oldKick(self, reason)
    end)
    
    -- Hook Namecall untuk memblokir Remote Kick Server-Side
    local gmt = getrawmetatable(game)
    local oldNamecall = gmt.__namecall
    setreadonly(gmt, false)
    
    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if antiKickActive and (tostring(self):lower():find("kick") or tostring(self):lower():find("ban")) then
            return nil -- Abaikan Remote yang mengandung kata kick/ban
        end
        return oldNamecall(self, ...)
    end)
end

pcall(EnableSafeMode)

-- [[ SCANNER LOGIC DENGAN PROTEKSI ]] --
local LogBox = Instance.new("ScrollingFrame", MainFrame)
LogBox.Size = UDim2.new(1, -20, 0, 160)
LogBox.Position = UDim2.new(0, 10, 0, 40)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.BorderSizePixel = 1
LogBox.BorderColor3 = Color3.fromRGB(40, 40, 40)
LogBox.CanvasSize = UDim2.new(0, 0, 0, 0)
LogBox.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", LogBox)
UIList.Padding = UDim.new(0, 2)

local function ScanRemotes()
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local l = Instance.new("TextButton", LogBox)
                l.Size = UDim2.new(1, 0, 0, 30)
                l.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                l.Text = " [SAFE] " .. v.Name
                l.TextColor3 = Color3.fromRGB(0, 255, 150)
                l.Font = Enum.Font.Code
                l.TextSize = 9
                l.BorderSizePixel = 0
                
                l.MouseButton1Click:Connect(function()
                    lastTargetRemote = v
                    CmdFrame.Visible = true
                end)
                LogBox.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
            end
        end)
    end
end

-- [[ UI BUTTONS ]] --
local function CreateBtn(text, x, y, parent, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 125, 0, 40)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.RobotoMono
    btn.TextSize = 10
    btn.BorderSizePixel = 1
    btn.BorderColor3 = color
    btn.MouseButton1Click:Connect(callback)
end

CreateBtn("SAFE SCAN", 10, 215, MainFrame, Color3.fromRGB(0, 255, 150), function()
    ScanRemotes()
end)

CreateBtn("STOP PROTECTION", 145, 215, MainFrame, Color3.fromRGB(255, 50, 50), function()
    antiKickActive = false
    Title.Text = "SECURITY DISABLED!"
end)

-- Command Buttons
local cmds = {"Kill", "Kick", "Ban", "Fly", "GodMode"}
for i, c in pairs(cmds) do
    local b = Instance.new("TextButton", CmdFrame)
    b.Size = UDim2.new(0.9, 0, 0, 28)
    b.Position = UDim2.new(0.05, 0, 0, 35 + (i*32))
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = c:upper()
    b.TextColor3 = Color3.fromRGB(255, 200, 0)
    b.Font = Enum.Font.Code
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function()
        if lastTargetRemote then
            pcall(function()
                local m = lastTargetRemote:IsA("RemoteEvent") and "FireServer" or "InvokeServer"
                lastTargetRemote[m](lastTargetRemote, myID, c, "All")
            end)
        end
    end)
end

-- Drag System
local function MakeDrag(obj)
    local d, s, sp
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; sp = obj.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - s; obj.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
end
MakeDrag(MainFrame)
MakeDrag(CmdFrame)
