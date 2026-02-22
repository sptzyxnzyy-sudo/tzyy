-- [[ PHANTOM SQUARE: ULTRA MINIMALIST ICON ]] --
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local isActive = false

-- [[ UI SCREEN ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "PhantomIconOnly"
ScreenGui.ResetOnSpawn = false

-- [[ THE ICON BUTTON ]] --
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 50, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.Text = "OFF"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- Efek Garis Luar (Stroke)
local Stroke = Instance.new("UIStroke", ToggleBtn)
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2

-- [[ TOGGLE LOGIC ]] --
ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    if isActive then
        -- Tampilan saat Aktif
        ToggleBtn.Text = "ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
        Stroke.Color = Color3.fromRGB(255, 255, 255)
        print("PHANTOM: Fitur Diaktifkan")
    else
        -- Tampilan saat Mati
        ToggleBtn.Text = "OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        Stroke.Color = Color3.fromRGB(0, 255, 255)
        print("PHANTOM: Fitur Dimatikan")
    end
end)

-- [[ DRAG SUPPORT (Bisa Digeser) ]] --
local dragging, startPos, startObjPos
ToggleBtn.InputBegan:Connect(function(inp)
    if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        startPos = inp.Position
        startObjPos = ToggleBtn.Position
    end
end)

ToggleBtn.InputChanged:Connect(function(inp)
    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - startPos
        ToggleBtn.Position = UDim2.new(
            startObjPos.X.Scale, startObjPos.X.Offset + delta.X, 
            startObjPos.Y.Scale, startObjPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
        dragging = false
    end
end)

print("PHANTOM ICON LOADED - NO REMOTES")
