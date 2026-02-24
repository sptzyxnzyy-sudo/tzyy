-- [[ SPTZYY NETWORK CONTROLLER: SQUARE EXECUTION FLOW ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local scanActive = false
local execSupport = false

-- [[ UI SETUP: SQUARE INDUSTRIAL ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Sptzyy_SquareFlow"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 310)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)

-- Header baris tajam
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "REMOTE FLOW EXECUTOR"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Terminal Box
local LogBox = Instance.new("ScrollingFrame", MainFrame)
LogBox.Size = UDim2.new(1, -20, 0, 200)
LogBox.Position = UDim2.new(0, 10, 0, 40)
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.BorderSizePixel = 1
LogBox.BorderColor3 = Color3.fromRGB(40, 40, 40)
LogBox.CanvasSize = UDim2.new(0, 0, 50, 0)
LogBox.ScrollBarThickness = 2

local LogText = Instance.new("TextLabel", LogBox)
LogText.Size = UDim2.new(1, -10, 1, 0)
LogText.Position = UDim2.new(0, 5, 0, 0)
LogText.Text = "> INITIALIZING FLOW...\n> READY TO INTERCEPT"
LogText.TextColor3 = Color3.fromRGB(0, 255, 150)
LogText.Font = Enum.Font.Code
LogText.TextSize = 10
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.BackgroundTransparency = 1

-- [[ ALUR EKSEKUSI (CORE LOGIC) ]] --
local function LogEvent(name, method)
    LogText.Text = string.format("[%s] %s: %s\n", os.date("%X"), method, name) .. LogText.Text
end

local function HookSystem()
    local gmt = getrawmetatable(game)
    local oldNamecall = gmt.__namecall
    setreadonly(gmt, false)

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if scanActive and (method == "FireServer" or method == "InvokeServer") then
            -- 1. Scan/Capture
            LogEvent(tostring(self.Name), method == "FireServer" and "FIRE" or "INVOKE")

            -- 2. Support Eksekusi (Alur Bypass/Duplikasi)
            if execSupport then
                -- Menjalankan eksekusi tambahan di thread berbeda agar tidak membeku
                task.spawn(function()
                    -- Di sini Remote dikirim ulang secara manual untuk 'support' aksi server-side
                    self[method](self, unpack(args))
                end)
            end
        end
        return oldNamecall(self, ...)
    end)
end

task.spawn(pcall, HookSystem)

-- [[ CONTROLS: RECTANGLE BUTTONS ]] --
local function CreateButton(name, xPos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 125, 0, 45)
    btn.Position = UDim2.new(0, xPos, 0, 255)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0, 255, 150)
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.RobotoMono
    btn.TextSize = 10

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(20, 20, 20)
        callback(active)
    end)
end

CreateButton("SCANNER", 10, function(v) scanActive = v end)
CreateButton("EXEC FLOW", 145, function(v) execSupport = v end)

-- [[ DRAGGABLE SYSTEM ]] --
local drag, inputPos, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = true; inputPos = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - inputPos
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = false
    end
end)
