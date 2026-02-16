-- [[ FISH IT: ROD & BOAT BRINGER ]] --
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local isBringing = false
local bringMode = "Rod"

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FishItBringer"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 180) 
Main.Position = UDim2.new(0.5, -120, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(85, 255, 127) -- Hijau khas Fish It
Stroke.Thickness = 2

-- [[ HEADER ]] --
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "FISH IT! BRINGER"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1

-- [[ SELECTOR BARS ]] --
local function CreateModeBtn(name, pos)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.4, 0, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    btn.Text = name
    btn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn)
    return btn
end

local rodBtn = CreateModeBtn("BOBBER", UDim2.new(0.075, 0, 0, 50))
local boatBtn = CreateModeBtn("BOAT", UDim2.new(0.525, 0, 0, 50))

local function updateButtons()
    rodBtn.BackgroundColor3 = (bringMode == "Rod") and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(30, 35, 45)
    boatBtn.BackgroundColor3 = (bringMode == "Boat") and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(30, 35, 45)
    rodBtn.TextColor3 = (bringMode == "Rod") and Color3.new(0,0,0) or Color3.new(0.6, 0.6, 0.6)
    boatBtn.TextColor3 = (bringMode == "Boat") and Color3.new(0,0,0) or Color3.new(0.6, 0.6, 0.6)
end
updateButtons()

rodBtn.MouseButton1Click:Connect(function() bringMode = "Rod"; updateButtons() end)
boatBtn.MouseButton1Click:Connect(function() bringMode = "Boat"; updateButtons() end)

-- [[ TOGGLE SWITCH ]] --
local ToggleBg = Instance.new("TextButton", Main)
ToggleBg.Size = UDim2.new(0.85, 0, 0, 35)
ToggleBg.Position = UDim2.new(0.075, 0, 0, 100)
ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
ToggleBg.Text = "ACTIVATE BRING"
ToggleBg.TextColor3 = Color3.new(1,1,1)
ToggleBg.Font = Enum.Font.GothamBold
ToggleBg.TextSize = 10
Instance.new("UICorner", ToggleBg)

-- [[ BRING ENGINE ]] --
task.spawn(function()
    while true do
        if isBringing and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lp.Character.HumanoidRootPart
            local targetPos = hrp.Position + (hrp.CFrame.LookVector * 3) -- 3 studs didepan
            
            pcall(function()
                if bringMode == "Rod" then
                    -- Scan Bobber di Workspace
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") and (v.Name == "Bobber" or v.Name == "FishingLine") then
                            -- Pindahkan bobber ke depan pemain
                            v.CFrame = CFrame.new(targetPos)
                            v.Velocity = Vector3.new(0,0,0)
                        end
                    end
                elseif bringMode == "Boat" then
                    -- Scan Boat milik pemain
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v.Name:lower():find("boat") then
                            if v:FindFirstChild("Owner") and v.Owner.Value == lp.Name then
                                v:SetPrimaryPartCFrame(CFrame.new(targetPos))
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.05)
    end
end)

ToggleBg.MouseButton1Click:Connect(function()
    isBringing = not isBringing
    if isBringing then
        ToggleBg.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
        ToggleBg.TextColor3 = Color3.new(0,0,0)
        ToggleBg.Text = "BRINGING ACTIVE"
    else
        ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
        ToggleBg.TextColor3 = Color3.new(1,1,1)
        ToggleBg.Text = "ACTIVATE BRING"
    end
end)

-- [[ OPEN BUTTON ]] --
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
OpenBtn.Text = "FISH"
OpenBtn.TextColor3 = Color3.fromRGB(85, 255, 127)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 10
Instance.new("UICorner", OpenBtn)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(85, 255, 127)

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- DRAG LOGIC
local function drag(o)
    local s, i, sp
    o.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = true; i = inp.Position; sp = o.Position end end)
    o.InputChanged:Connect(function(inp) if s and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local d = inp.Position - i; o.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then s = false end end)
end
drag(OpenBtn); drag(Main)
