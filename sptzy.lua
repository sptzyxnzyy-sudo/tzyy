-- [[ SPTZYY PART CONTROLLER: ADMIN BLUE BEAM EDITION 👑 ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local ropeBreakerActive = true 
local showLines = true -- Fitur Baru: Garis Biru
local pullRadius = 150      
local orbitHeight = 10      
local orbitRadius = 12     
local spinSpeed = 125       
local followStrength = 100  

-- [[ OVERHEAD TITLE ADMIN ]] --
local function CreateOverhead(char)
    local head = char:WaitForChild("Head")
    if head:FindFirstChild("AdminTitle") then head.AdminTitle:Destroy() end
    local bgui = Instance.new("BillboardGui", head)
    bgui.Name = "AdminTitle"
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 3.5, 0)
    bgui.AlwaysOnTop = true
    local lbl = Instance.new("TextLabel", bgui)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "SAYA ADMIN 👑"
    lbl.TextColor3 = Color3.fromRGB(0, 170, 255) -- Biru Admin
    lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 22
    task.spawn(function()
        while bgui.Parent do
            bgui.StudsOffset = Vector3.new(0, 3.5 + math.sin(tick()*4)*0.5, 0)
            task.wait()
        end
    end)
end
lp.CharacterAdded:Connect(CreateOverhead)
if lp.Character then CreateOverhead(lp.Character) end

-- [[ FUNGSI BEAM ESP (LINE BLUE) ]] --
local lines = {}
local function GetLine()
    for _, l in pairs(lines) do
        if not l.Visible then return l end
    end
    local newLine = Drawing.new("Line")
    newLine.Color = Color3.fromRGB(0, 160, 255)
    newLine.Thickness = 1.5
    newLine.Transparency = 0.7
    table.insert(lines, newLine)
    return newLine
end

-- [[ LOGIKA PHYSICS, ROPE & LINES ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    -- Reset Lines
    for _, l in pairs(lines) do l.Visible = false end
    
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * spinSpeed)
    local root = lp.Character.HumanoidRootPart
    local cam = workspace.CurrentCamera
    local targetPos = root.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            local dist = (part.Position - root.Position).Magnitude
            
            if dist <= pullRadius then
                -- 1. Physics Magnet
                pcall(function() part:SetNetworkOwner(lp) end)
                part.Velocity = (targetPos - part.Position) * followStrength
                
                -- 2. Line ESP (Blue Beam)
                if showLines then
                    local pPos, onScreen = cam:WorldToViewportPoint(part.Position)
                    local rPos = cam:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local l = GetLine()
                        l.From = Vector2.new(rPos.X, rPos.Y)
                        l.To = Vector2.new(pPos.X, pPos.Y)
                        l.Visible = true
                    end
                end

                -- 3. Rope Breaker Logic
                if ropeBreakerActive and dist < 20 then
                    for _, cons in pairs(part:GetChildren()) do
                        if cons:IsA("Constraint") or cons:IsA("RopeConstraint") then cons:Destroy() end
                    end
                end
            end
        end
    end
end)

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
IconButton.Image = "rbxassetid://6031094678"
Instance.new("UICorner", IconButton).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(0, 160, 255)
IconStroke.Thickness = 3

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 230, 0, 250)
MainFrame.Position = UDim2.new(0.5, -115, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ADMIN BEAST V5 👑"
Title.TextColor3 = Color3.fromRGB(0, 160, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local function CreateBtn(name, pos, color, action)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = name .. ": ON"
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() action(b) end)
    return b
end

local MagnetBtn = CreateBtn("MAGNET", UDim2.new(0.05, 0, 0.2, 0), Color3.fromRGB(0, 160, 255), function(b)
    botActive = not botActive
    b.Text = botActive and "MAGNET: ON" or "MAGNET: OFF"
    b.BackgroundColor3 = botActive and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(60, 60, 60)
end)

local RopeBtn = CreateBtn("ROPE BREAK", UDim2.new(0.05, 0, 0.4, 0), Color3.fromRGB(255, 80, 80), function(b)
    ropeBreakerActive = not ropeBreakerActive
    b.Text = ropeBreakerActive and "ROPE BREAK: ON" or "ROPE BREAK: OFF"
    b.BackgroundColor3 = ropeBreakerActive and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(60, 60, 60)
end)

local LineBtn = CreateBtn("BLUE BEAM", UDim2.new(0.05, 0, 0.6, 0), Color3.fromRGB(0, 220, 255), function(b)
    showLines = not showLines
    b.Text = showLines and "BLUE BEAM: ON" or "BLUE BEAM: OFF"
    b.BackgroundColor3 = showLines and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(60, 60, 60)
end)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 40)
Info.Position = UDim2.new(0, 0, 0.82, 0)
Info.Text = "👑 ADMIN PRIVILEGE ACTIVE"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextSize = 10
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamMedium

-- [[ DRAG LOGIC ]] --
local function MakeDrag(obj)
    local drag, start, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true; start = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - start
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() drag = false end)
end

MakeDrag(IconButton)
MakeDrag(MainFrame)
IconButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
