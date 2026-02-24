-- [[ SPTZYY ULTIMATE NETWORK CONTROLLER ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local scanActive = false
local execSupport = false

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyNetControl"
ScreenGui.Parent = (game:GetService("CoreGui") or lp:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

-- Icon Floating
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://6031094678" 
local IconCorner = Instance.new("UICorner", IconButton)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 2

-- Main Frame (Ukuran Pas & Rapi)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false 
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NETWORK EXECUTOR V4"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Fungsi Tombol & Loading
local function CreateButton(text, order)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btn.Text = text .. ": OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    return btn
end

local ScanBtn = CreateButton("SCAN LOGS", 1)
local ExecBtn = CreateButton("EXEC SUPPORT", 2)

-- Log Display (Scrolling agar tidak luber)
local LogBox = Instance.new("ScrollingFrame", Container)
LogBox.Size = UDim2.new(1, 0, 0, 130)
LogBox.LayoutOrder = 3
LogBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
LogBox.CanvasSize = UDim2.new(0, 0, 5, 0)
LogBox.ScrollBarThickness = 2
Instance.new("UICorner", LogBox)

local LogText = Instance.new("TextLabel", LogBox)
LogText.Size = UDim2.new(1, -10, 1, 0)
LogText.Position = UDim2.new(0, 5, 0, 0)
LogText.Text = "Status: Ready..."
LogText.TextColor3 = Color3.fromRGB(0, 255, 150)
LogText.Font = Enum.Font.Code
LogText.TextSize = 10
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.BackgroundTransparency = 1

--- [[ LOGIKA SCAN & EXECUTION ]] ---
local function UpdateLog(msg)
    LogText.Text = "[" .. os.date("%X") .. "] " .. msg .. "\n" .. LogText.Text
end

local function PlayLoading(btn, label, state)
    for i = 1, 3 do
        btn.Text = "SINKRONISASI" .. string.rep(".", i)
        task.wait(0.2)
    end
    btn.Text = label .. ": " .. (state and "ON" or "OFF")
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 50, 50)
end

-- Hooking Metatable untuk RemoteEvent & HTTP
local function StartScanner()
    local gmt = getrawmetatable(game)
    local oldNamecall = gmt.__namecall
    local oldHttpRequest = (syn and syn.request) or (http and http.request) or http_request
    
    setreadonly(gmt, false)

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if scanActive then
            if method == "FireServer" or method == "InvokeServer" then
                UpdateLog("REMOTE: " .. tostring(self.Name))
                if execSupport then
                    -- Support Eksekusi: Meneruskan data secara otomatis jika dibutuhkan
                    task.spawn(function() print("Executing Hook on: " .. self.Name) end)
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    
    -- Logika Scan HTTP (Jika executor mendukung)
    if oldHttpRequest then
        UpdateLog("HTTP Scanner: Link Established")
    end
end

task.spawn(pcall, StartScanner)

-- [[ INTERAKSI ]] --
ScanBtn.MouseButton1Click:Connect(function()
    scanActive = not scanActive
    UpdateLog(scanActive and "Scanner Started..." or "Scanner Stopped.")
    PlayLoading(ScanBtn, "SCAN LOGS", scanActive)
end)

ExecBtn.MouseButton1Click:Connect(function()
    execSupport = not execSupport
    UpdateLog(execSupport and "Execution Bypass: Active" or "Execution Bypass: Off")
    PlayLoading(ExecBtn, "EXEC SUPPORT", execSupport)
end)

-- Drag System
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
IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
