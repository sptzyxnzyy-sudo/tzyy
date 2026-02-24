-- Beckdeer Mobile Executor - Square Rainbow Edition (RE-FIXED)
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Pastikan GUI lama dihapus
local oldGui = pgui:FindFirstChild("BeckMobileRainbow") or game:GetService("CoreGui"):FindFirstChild("BeckMobileRainbow")
if oldGui then oldGui:Destroy() end

-- Container dengan DisplayOrder Tinggi
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BeckMobileRainbow"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999 -- Memastikan di atas GUI game

-- Coba taruh di CoreGui jika bisa, kalau tidak ke PlayerGui
local success_parent, _ = pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)
if not success_parent then
    screenGui.Parent = pgui
end

-- 1. Main Square Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 220, 0, 220)
main.Position = UDim2.new(0.5, -110, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Visible = true -- Langsung muncul
main.Parent = screenGui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- Rainbow Stroke
local uiStroke = Instance.new("UIStroke", main)
uiStroke.Thickness = 3
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 2. Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "BECKDEER ADMIN EXEC"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.Parent = main
Instance.new("UICorner", title)

-- 3. Status Display
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.88, 0, 0.5, 0)
status.Position = UDim2.new(0.06, 0, 0.2, 0)
status.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
status.Text = "USER: " .. player.Name .. "\nID: " .. player.UserId .. "\n\nREADY TO ADMIN"
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.TextSize = 10
status.Font = Enum.Font.Code
status.Parent = main
Instance.new("UICorner", status)

-- 4. Execute Button (Tanpa Ketik)
local exec = Instance.new("TextButton")
exec.Size = UDim2.new(0.88, 0, 0, 40)
exec.Position = UDim2.new(0.06, 0, 0.75, 0)
exec.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
exec.Text = "EKSEKUSI ADMIN"
exec.TextColor3 = Color3.white
exec.Font = Enum.Font.GothamBold
exec.TextSize = 14
exec.Parent = main
Instance.new("UICorner", exec)

-- 5. Floating Icon B
local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(0, 55, 0, 55)
toggle.Position = UDim2.new(0, 20, 0.5, -27)
toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggle.Text = "B"
toggle.TextColor3 = Color3.white
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 28
toggle.Parent = screenGui
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

local toggleStroke = Instance.new("UIStroke", toggle)
toggleStroke.Thickness = 3

--- LOGIC SISTEM ---

-- Rainbow Effect
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    local color = Color3.fromHSV(hue, 0.8, 1)
    uiStroke.Color = color
    toggleStroke.Color = color
    exec.TextColor3 = color
end)

-- Dragging System (Manual agar lebih stabil di Mobile)
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(main)
makeDraggable(toggle)

-- Eksekusi & Admin Logic
exec.MouseButton1Click:Connect(function()
    status.Text = "Executing Asset..."
    local success, result = pcall(function()
        return require(3239236979)
    end)

    if success then
        status.Text = "SUCCESS!\nAdmin Applied."
        -- Mencoba memasukkan Admin
        pcall(function()
            if type(result) == "table" then
                if result.AddAdmin then result.AddAdmin(player.UserId)
                elseif result.Admin then result.Admin(player.UserId) end
            elseif type(result) == "function" then
                result(player.UserId)
            end
        end)
    else
        status.Text = "FAILED\nModule Error or Blocked"
    end
end)

-- Open/Close
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

print("Beckdeer Executor Loaded.")
