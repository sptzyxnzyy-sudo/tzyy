-- [[ SPTZYY NETWORK CONTROLLER: SERVER-SIDE SCANNER EDITION ]] --

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local scanActive = false
local executionSupport = false
local lastScannedEvent = "None"

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyNetworkControl"
ScreenGui.Parent = (game:GetService("CoreGui") or lp:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

-- Tombol Icon (Floating)
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0.1, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
IconButton.Image = "rbxassetid://6031094678" 
local IconCorner = Instance.new("UICorner", IconButton)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(255, 255, 255)
IconStroke.Thickness = 2

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 280)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false 
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "NETWORK SCANNER V3"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", MainFrame)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local TitleSpacer = Instance.new("Frame", MainFrame)
TitleSpacer.Size = UDim2.new(1, 0, 0, 45)
TitleSpacer.BackgroundTransparency = 1
TitleSpacer.LayoutOrder = 0

--- [[ FUNGSI LOADING LOOP ]] ---
local function PlayLoading(button, targetText, finalStatus)
    button.AutoButtonColor = false
    local dots = {"", ".", "..", "..."}
    for i = 1, 5 do
        button.Text = "PROCESSING" .. dots[(i % 4) + 1]
        button.BackgroundColor3 = Color3.fromRGB(180, 180, 40)
        task.wait(0.15)
    end
    button.Text = targetText .. ": " .. (finalStatus and "ACTIVE" or "OFF")
    button.BackgroundColor3 = finalStatus and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 80, 80)
    button.AutoButtonColor = true
end

--- [[ TOMBOL 1: SCAN SERVER RESPONSE ]] ---
local ScanBtn = Instance.new("TextButton", MainFrame)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 45)
ScanBtn.LayoutOrder = 1
ScanBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
ScanBtn.Text = "SCANNER: OFF"
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ScanBtn)

--- [[ TOMBOL 2: EXECUTION SUPPORT ]] ---
local ExecBtn = Instance.new("TextButton", MainFrame)
ExecBtn.Size = UDim2.new(0.9, 0, 0, 45)
ExecBtn.LayoutOrder = 2
ExecBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
ExecBtn.Text = "EXEC SUPPORT: OFF"
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ExecBtn)

--- [[ DISPLAY BOX: LAST REMOTE ]] ---
local Display = Instance.new("ScrollingFrame", MainFrame)
Display.Size = UDim2.new(0.9, 0, 0, 100)
Display.LayoutOrder = 3
Display.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Display.CanvasSize = UDim2.new(0, 0, 2, 0)
Display.ScrollBarThickness = 2
Instance.new("UICorner", Display)

local LogText = Instance.new("TextLabel", Display)
LogText.Size = UDim2.new(1, -10, 1, 0)
LogText.Position = UDim2.new(0, 5, 0, 0)
LogText.Text = "Waiting for Scan..."
LogText.TextColor3 = Color3.fromRGB(0, 255, 100)
LogText.Font = Enum.Font.Code
LogText.TextSize = 10
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.BackgroundTransparency = 1

-- [[ LOGIKA SCANNER (Spying RemoteEvents) ]] --
local function HookRemotes()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldNamecall = gmt.__namecall

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if scanActive and (method == "FireServer" or method == "InvokeServer") then
            lastScannedEvent = tostring(self.Name)
            LogText.Text = "Detected: " .. lastScannedEvent .. "\nArgs: " .. #args .. " data found\nMethod: " .. method
            
            -- Jika Exec Support aktif, kita bisa memodifikasi atau meneruskan otomatis
            if executionSupport then
                -- Logika otomatisasi eksekusi di sini (opsional)
            end
        end
        return oldNamecall(self, ...)
    end)
end

-- Menjalankan Hook dalam pcall agar aman dari deteksi dasar
pcall(HookRemotes)

-- [[ INTERAKSI TOMBOL ]] --
ScanBtn.MouseButton1Click:Connect(function()
    scanActive = not scanActive
    PlayLoading(ScanBtn, "SCANNER", scanActive)
end)

ExecBtn.MouseButton1Click:Connect(function()
    executionSupport = not executionSupport
    PlayLoading(ExecBtn, "EXEC SUPPORT", executionSupport)
end)

-- [[ SISTEM DRAG ]] --
local function MakeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

MakeDraggable(IconButton)
MakeDraggable(MainFrame)

IconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
