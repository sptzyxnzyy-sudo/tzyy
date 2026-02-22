-- [[ PHANTOM SQUARE: NETWORK OWNERSHIP EXPANDER ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- [[ STATE ]] --
local serverExpandActive = false

-- [[ UI SCREEN SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomNetworkSystem"
ScreenGui.ResetOnSpawn = false

-- [[ 1. LAUNCHER ICON ]] --
local IconBtn = Instance.new("ImageButton", ScreenGui)
IconBtn.Size = UDim2.new(0, 55, 0, 55)
IconBtn.Position = UDim2.new(0, 30, 0.5, -27)
IconBtn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
IconBtn.Image = "rbxassetid://12503521360"
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", IconBtn).Color = Color3.fromRGB(0, 255, 255)

-- [[ 2. MAIN FRAME ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NETWORK EXPANDER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- [[ TOMBOL TOGGLE ]] --
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0, 240, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -120, 0.5, -10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.Text = "SERVER VISIBLE: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local BtnStroke = Instance.new("UIStroke", ToggleBtn)
BtnStroke.Color = Color3.fromRGB(255, 50, 50)

-- [[ LOGIKA MANIPULASI AKSESORIS (NETWORK REPLICATION) ]] --
local function updateAksesoris()
    local char = lp.Character
    if not char then return end

    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Accessory") then
            local handle = v:FindFirstChild("Handle")
            if handle then
                local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                if mesh then
                    if serverExpandActive then
                        -- Ukuran raksasa (Sumbu X dan Z lebar, Y tipis untuk menutupi pandangan)
                        mesh.Scale = Vector3.new(100, 0.05, 100) 
                    else
                        -- Reset ke ukuran normal
                        mesh.Scale = Vector3.new(1, 1, 1)
                    end
                end
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    serverExpandActive = not serverExpandActive
    
    if serverExpandActive then
        ToggleBtn.Text = "SERVER VISIBLE: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 150)
        BtnStroke.Color = Color3.fromRGB(50, 255, 150)
    else
        ToggleBtn.Text = "SERVER VISIBLE: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        BtnStroke.Color = Color3.fromRGB(255, 50, 50)
    end
    updateAksesoris()
end)

-- Loop Heartbeat untuk memastikan perubahan tetap terkunci (Mencegah auto-reset server)
RunService.Heartbeat:Connect(function()
    if serverExpandActive then
        updateAksesoris()
    end
end)

-- [[ UI INTERACTION ]] --
IconBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Draggable Logic
local function makeDraggable(obj)
    local dragging, input, startPos, startObjPos
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startPos = i.Position; startObjPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - startPos
            obj.Position = UDim2.new(startObjPos.X.Scale, startObjPos.X.Offset + delta.X, startObjPos.Y.Scale, startObjPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

makeDraggable(MainFrame)
makeDraggable(IconBtn)

print("PHANTOM SYSTEM: NETWORK OWNERSHIP CLOTHES LOADED")
