-- [[ CONFIGURATION ]]
local IsEnabled = false
local TargetRemote = nil
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- [[ NOTIFICATION SYSTEM ]]
local function SendNotification(title, text, color)
    local NotifGui = Instance.new("ScreenGui", CoreGui)
    
    local Frame = Instance.new("Frame", NotifGui)
    Frame.Size = UDim2.new(0, 220, 0, 60)
    Frame.Position = UDim2.new(1, 10, 0.8, 0) -- Mulai dari luar layar
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    
    -- Accent Line
    local Line = Instance.new("Frame", Frame)
    Line.Size = UDim2.new(0, 4, 1, 0)
    Line.BackgroundColor3 = color or Color3.fromRGB(0, 255, 255)
    Line.BorderSizePixel = 0
    
    local TLabel = Instance.new("TextLabel", Frame)
    TLabel.Size = UDim2.new(1, -15, 0.5, 0)
    TLabel.Position = UDim2.new(0, 10, 0, 5)
    TLabel.Text = title
    TLabel.TextColor3 = Color3.new(1, 1, 1)
    TLabel.Font = Enum.Font.GothamBold
    TLabel.TextXAlignment = Enum.TextXAlignment.Left
    TLabel.BackgroundTransparency = 1
    
    local DLabel = Instance.new("TextLabel", Frame)
    DLabel.Size = UDim2.new(1, -15, 0.5, 0)
    DLabel.Position = UDim2.new(0, 10, 0.5, 0)
    DLabel.Text = text
    DLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DLabel.Font = Enum.Font.Gotham
    DLabel.TextSize = 12
    DLabel.TextXAlignment = Enum.TextXAlignment.Left
    DLabel.BackgroundTransparency = 1

    -- Animasi Masuk
    Frame:TweenPosition(UDim2.new(1, -230, 0.8, 0), "Out", "Quart", 0.5, true)
    
    task.delay(3, function()
        Frame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quart", 0.5, true)
        task.wait(0.5)
        NotifGui:Destroy()
    end)
end

-- [[ HEURISTIC SCANNER ]]
local function FindRemoteByLogic()
    SendNotification("SYSTEM", "Memulai Scanning...", Color3.fromRGB(255, 165, 0))
    task.wait(0.5)
    
    local potentialRemotes = {}
    for _, obj in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            -- Logika: Cari yang berada di folder dalam (gameplay logic)
            if not obj.Name:lower():find("chat") and not obj.Name:lower():find("voice") then
                table.insert(potentialRemotes, obj)
            end
        end
    end
    
    if #potentialRemotes > 0 then
        table.sort(potentialRemotes, function(a, b)
            return #a:GetFullName() > #b:GetFullName()
        end)
        local found = potentialRemotes[1]
        SendNotification("SUCCESS", "Remote Terhubung: " .. found.Name, Color3.fromRGB(0, 255, 0))
        return found
    end
    
    SendNotification("ERROR", "Remote Tidak Ditemukan!", Color3.fromRGB(255, 0, 0))
    return nil
end

-- [[ MAIN UI DESIGN ]]
local SG = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 240, 0, 160)
Main.Position = UDim2.new(0.5, -120, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Neon Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 3)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "PHANTOM EXECUTOR"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Switch = Instance.new("TextButton", Main)
Switch.Size = UDim2.new(0, 200, 0, 45)
Switch.Position = UDim2.new(0.5, -100, 0.45, 0)
Switch.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Switch.Text = "STATUS: OFF"
Switch.TextColor3 = Color3.new(1, 1, 1)
Switch.Font = Enum.Font.Gotham
Switch.BorderSizePixel = 0

local Footer = Instance.new("TextLabel", Main)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.Text = "Logic: Heuristic (No Keywords)"
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.TextSize = 10
Footer.BackgroundTransparency = 1

-- [[ EXECUTION ]]
TargetRemote = FindRemoteByLogic()

Switch.MouseButton1Click:Connect(function()
    IsEnabled = not IsEnabled
    if IsEnabled then
        Switch.Text = "STATUS: ACTIVE"
        Switch.BackgroundColor3 = Color3.fromRGB(0, 80, 80)
        SendNotification("LOGIC", "Sistem Aktif", Color3.fromRGB(0, 255, 255))
    else
        Switch.Text = "STATUS: OFF"
        Switch.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        SendNotification("LOGIC", "Sistem Mati", Color3.fromRGB(150, 0, 0))
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if IsEnabled and TargetRemote then
            pcall(function()
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = plr.Character.HumanoidRootPart
                        local hum = plr.Character:FindFirstChild("Humanoid")
                        -- Mengirimkan paket koordinat server-side
                        TargetRemote:FireServer(hrp.Position, hum, hrp)
                    end
                end
            end)
        end
    end
end)
