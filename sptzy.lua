-- Beckdeer Mobile Executor - Square Rainbow Edition (Admin & Icon Integrated)
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BeckMobileRainbow"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

-- 1. Main Square Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 220, 0, 220)
main.Position = UDim2.new(0.5, -110, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Visible = true
main.Parent = screenGui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- Rainbow Stroke (Garis Tepi)
local uiStroke = Instance.new("UIStroke", main)
uiStroke.Thickness = 2.5
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 2. Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "BECKDEER EXECUTOR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.Parent = main
Instance.new("UICorner", title)

-- 3. Editor Box (Tanpa Ketik / Status)
local editor = Instance.new("TextBox")
editor.Size = UDim2.new(0.88, 0, 0.5, 0)
editor.Position = UDim2.new(0.06, 0, 0.2, 0)
editor.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
editor.Text = ""
editor.PlaceholderText = "-- Fitur Admin Aktif --\nTekan Eksekusi untuk Memanggil Module"
editor.TextColor3 = Color3.fromRGB(255, 255, 255)
editor.TextSize = 10
editor.Font = Enum.Font.Code
editor.MultiLine = true
editor.ClearTextOnFocus = false
editor.Parent = main
Instance.new("UICorner", editor)

-- 4. Execute Button (Pemicu Admin)
local exec = Instance.new("TextButton")
exec.Size = UDim2.new(0.88, 0, 0, 35)
exec.Position = UDim2.new(0.06, 0, 0.78, 0)
exec.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
exec.Text = "EKSEKUSI & ADMIN"
exec.TextColor3 = Color3.white
exec.Font = Enum.Font.GothamBold
exec.TextSize = 13
exec.Parent = main
Instance.new("UICorner", exec)

-- 5. Floating Toggle Button (Icon B)
local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(0, 50, 0, 50)
toggle.Position = UDim2.new(0, 20, 0.5, -25)
toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggle.Text = "B" -- Icon B dari fitur sebelumnya
toggle.TextColor3 = Color3.white
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 24
toggle.Parent = screenGui
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

local toggleStroke = Instance.new("UIStroke", toggle)
toggleStroke.Thickness = 2.5

--- LOGIC SISTEM ---

-- 1. Efek Rainbow (UI & Icon)
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    local color = Color3.fromHSV(hue, 1, 1)
    uiStroke.Color = color
    toggleStroke.Color = color
    exec.TextColor3 = color
end)

-- 2. Smooth Dragging (Geser)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- 3. Tombol Eksekusi & Admin Logic
exec.MouseButton1Click:Connect(function()
    -- Memanggil Module Asset ID
    local success, result = pcall(function()
        return require(3239236979)
    end)

    -- Jika berhasil, coba jadikan User sebagai Admin
    if success then
        pcall(function()
            -- Menjalankan fungsi admin (asumsi AddAdmin atau memanggil player)
            if type(result) == "table" then
                if result.AddAdmin then result.AddAdmin(player.UserId)
                elseif result.Admin then result.Admin(player.UserId)
                end
            elseif type(result) == "function" then
                result(player.UserId) -- Jika module langsung berupa function admin
            end
        end)
        print("Asset 3239236979 Berhasil Dipanggil!")
    else
        warn("Gagal Eksekusi Module.")
    end

    -- Tetap bisa eksekusi script manual jika diketik
    local code = editor.Text
    if code ~= "" then
        local f = loadstring(code)
        if f then pcall(f) end
        editor.Text = ""
    end
end)

-- 4. Toggle/Close System
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
