-- [[ SPTZYY PART CONTROLLER: ROPE DESTROYER EDITION ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local pullRadius = 150      
local physicsKick = 20      -- Kekuatan dorongan saat jatuh

-- [[ LOGIKA PENGHANCUR SPESIFIK ]] --
RunService.Heartbeat:Connect(function()
    if not botActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = lp.Character.HumanoidRootPart

    for _, part in pairs(workspace:GetDescendants()) do
        -- FILTER: Harus BasePart, TIDAK Anchored, dan BUKAN bagian dari karakter kita
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            
            -- CEK APAKAH MEMILIKI ROPECONSTRAINT
            local hasRope = false
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("RopeConstraint") then
                    hasRope = true
                    break
                end
            end

            -- PROSES HANYA JIKA ADA TALI
            if hasRope then
                local distance = (part.Position - rootPart.Position).Magnitude
                
                if distance <= pullRadius then
                    -- 1. KLAIM KONTROL SERVER (Network Ownership)
                    pcall(function() 
                        if part.ReceiveAge > 0 then
                            part:SetNetworkOwner(lp) 
                        end
                    end)

                    -- 2. HANCURKAN TALI & SAMBUNGAN LAINNYA
                    for _, obj in pairs(part:GetChildren()) do
                        if obj:IsA("RopeConstraint") or obj:IsA("RodConstraint") or obj:IsA("SpringConstraint") or obj:IsA("Weld") then
                            obj:Destroy()
                        end
                    end
                    
                    -- 3. PUTUSKAN JOINTS BAWAAN
                    part:BreakJoints()

                    -- 4. PHYSICS KICK (Jatuh Realtime)
                    -- Memberikan sedikit dorongan agar gravitasi server langsung merespon
                    part.Velocity = Vector3.new(0, -physicsKick, 0)
                    part.RotVelocity = Vector3.new(math.random(-5,5), 0, math.random(-5,5))
                end
            end
        end
    end
end)

---

-- [[ UI SETUP: ICON & MAIN GUI ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SptzyyRopeControl"

-- Tombol Icon (Floating)
local IconButton = Instance.new("ImageButton", ScreenGui)
IconButton.Size = UDim2.new(0, 50, 0, 50)
IconButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
IconButton.Image = "rbxassetid://6031225818" 
IconButton.BorderSizePixel = 0
local IconCorner = Instance.new("UICorner", IconButton)
IconCorner.CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconButton)
IconStroke.Color = Color3.fromRGB(255, 165, 0) -- Orange (Warning Style)
IconStroke.Thickness = 2

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false 
local MainCorner = Instance.new("UICorner", MainFrame)
MainFrame.Active = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ROPE DESTROYER ⛓️"
Title.TextColor3 = Color3.new(1, 0.6, 0)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local StatusBtn = Instance.new("TextButton", MainFrame)
StatusBtn.Size = UDim2.new(0.85, 0, 0, 45)
StatusBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
StatusBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
StatusBtn.Text = "STATUS: ACTIVE"
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", StatusBtn)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 50)
Info.Position = UDim2.new(0, 0, 0.65, 0)
Info.Text = "TARGET: UNANCHORED + ROPE\nOWNERSHIP: SERVER-SYNC\nKlik Icon untuk sembunyi"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.TextSize = 10
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.GothamMedium

-- [[ FUNGSI DRAG ]] --
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
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

StatusBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    if botActive then
        StatusBtn.Text = "STATUS: ACTIVE"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        IconStroke.Color = Color3.fromRGB(255, 165, 0)
    else
        StatusBtn.Text = "STATUS: OFF"
        StatusBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        IconStroke.Color = Color3.fromRGB(255, 255, 255)
    end
end)
