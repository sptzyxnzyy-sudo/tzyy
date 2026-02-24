-- [[ SPTZYY NETWORK ANALYZER - DEEP SCAN VERSION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local scanActive = false
local execSupport = false

-- [[ UI SETUP: SQUARE FIXED ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyScanner_V7"
-- Cek apakah CoreGui tersedia (untuk executor premium), jika tidak gunakan PlayerGui
local parentUI = game:GetService("CoreGui") or lp:WaitForChild("PlayerGui")
ScreenGui.Parent = parentUI

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 310)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "DEEP SCANNER [ACTIVE]"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local LogBox = Instance.new("ScrollingFrame", MainFrame)
LogBox.Size = UDim2.new(1, -20, 0, 200)
LogBox.Position = UDim2.new(0, 10, 0, 40)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.CanvasSize = UDim2.new(0, 0, 100, 0) -- Canvas lebih panjang
LogBox.ScrollBarThickness = 2

local LogText = Instance.new("TextLabel", LogBox)
LogText.Size = UDim2.new(1, -5, 1, 0)
LogText.Position = UDim2.new(0, 5, 0, 0)
LogText.Text = "> WAITING FOR NETWORK DATA..."
LogText.TextColor3 = Color3.fromRGB(0, 255, 150)
LogText.Font = Enum.Font.Code
LogText.TextSize = 10
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.BackgroundTransparency = 1

-- [[ ALUR EKSEKUSI REVISI ]] --
local function ForceLog(msg)
    LogText.Text = "[" .. os.date("%X") .. "] " .. tostring(msg) .. "\n" .. LogText.Text
end

-- Fungsi Hook Utama
local function StartDeepHook()
    local gmt = getrawmetatable(game)
    local oldNamecall = gmt.__namecall
    if setreadonly then setreadonly(gmt, false) else make_writeable(gmt) end

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if scanActive then
            -- Menangkap semua variasi Remote
            if method == "FireServer" or method == "InvokeServer" or method == "fireServer" then
                ForceLog("DETECTED: " .. self.Name .. " (" .. method .. ")")
                
                if execSupport then
                    task.spawn(function()
                        self[method](self, unpack(args))
                    end)
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    ForceLog("SYSTEM: Hook Injected Successfully")
end

-- Menjalankan hook dengan proteksi error
local success, err = pcall(StartDeepHook)
if not success then
    ForceLog("ERROR: Executor not compatible - " .. tostring(err))
end

-- [[ TOMBOL KOTAK ]] --
local function CreateBtn(name, x, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 125, 0, 45)
    btn.Position = UDim2.new(0, x, 0, 255)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 25)
        callback(active)
    end)
end

CreateBtn("SCANNER", 10, function(v) scanActive = v end)
CreateBtn("EXEC FLOW", 145, function(v) execSupport = v end)

-- Draggable Fixed
local d, s, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - s; MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
