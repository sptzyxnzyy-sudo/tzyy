-- [[ SPTZYY PART CONTROLLER: BEAST MOBILE EDITION + MODULE LOADER ]] --

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local magnetActive = false
local moduleActive = false
local pullRadius = 150      
local orbitHeight = 8      
local orbitRadius = 10     
local spinSpeed = 125        
local followStrength = 100  

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SptzyyUltraControl"
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
MainFrame.Size = UDim2.new(0, 240, 0, 220)
MainFrame.Position = UDim2.new(0.5, -120, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false 
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "BEAST CONTROLLER V2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", MainFrame)
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Spacer untuk Title
local TitleSpacer = Instance.new("Frame", MainFrame)
TitleSpacer.Size = UDim2.new(1, 0, 0, 45)
TitleSpacer.BackgroundTransparency = 1
TitleSpacer.LayoutOrder = 0

--- [[ FUNGSI LOADING LOOP ]] ---
local function PlayLoading(button, targetText, finalStatus)
    button.AutoButtonColor = false
    local dots = {"", ".", "..", "..."}
    for i = 1, 6 do -- Loop animasi 6 kali
        button.Text = "LOADING" .. dots[(i % 4) + 1]
        button.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
        task.wait(0.2)
    end
    button.Text = targetText .. ": " .. (finalStatus and "ON" or "OFF")
    button.BackgroundColor3 = finalStatus and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80)
    button.AutoButtonColor = true
end

--- [[ TOMBOL 1: MAGNET ]] ---
local MagnetBtn = Instance.new("TextButton", MainFrame)
MagnetBtn.Size = UDim2.new(0.9, 0, 0, 50)
MagnetBtn.LayoutOrder = 1
MagnetBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
MagnetBtn.Text = "MAGNET: OFF"
MagnetBtn.Font = Enum.Font.GothamBold
MagnetBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", MagnetBtn)

MagnetBtn.MouseButton1Click:Connect(function()
    magnetActive = not magnetActive
    PlayLoading(MagnetBtn, "MAGNET", magnetActive)
end)

--- [[ TOMBOL 2: MODULE LOADER ]] ---
local ModuleBtn = Instance.new("TextButton", MainFrame)
ModuleBtn.Size = UDim2.new(0.9, 0, 0, 50)
ModuleBtn.LayoutOrder = 2
ModuleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
ModuleBtn.Text = "MODULE: OFF"
ModuleBtn.Font = Enum.Font.GothamBold
ModuleBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", ModuleBtn)

ModuleBtn.MouseButton1Click:Connect(function()
    moduleActive = not moduleActive
    
    if moduleActive then
        task.spawn(function()
            PlayLoading(ModuleBtn, "MODULE", true)
            local success, result = pcall(function()
                return require(3239236979)
            end)
            if success and result and result.initialize then
                result.initialize(MainFrame)
            end
        end)
    else
        PlayLoading(ModuleBtn, "MODULE", false)
    end
end)

-- [[ LOGIKA MAGNET PHYSICS ]] --
local angle = 0
RunService.Heartbeat:Connect(function()
    if not magnetActive or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    angle = angle + (0.05 * spinSpeed)
    local rootPart = lp.Character.HumanoidRootPart
    local targetPos = rootPart.Position + Vector3.new(math.cos(angle) * orbitRadius, orbitHeight, math.sin(angle) * orbitRadius)

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(lp.Character) then
            local distance = (part.Position - rootPart.Position).Magnitude
            if distance <= pullRadius then
                -- Break Constraints
                for _, c in pairs(part:GetChildren()) do
                    if c:IsA("Constraint") then c:Destroy() end
                end
                -- Physics
                pcall(function() part:SetNetworkOwner(lp) end)
                part.Velocity = (targetPos - part.Position) * followStrength
                part.RotVelocity = Vector3.new(0, 10, 0) 
            end
        end
    end
end)

-- [[ SISTEM DRAG & TOGGLE ]] --
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
