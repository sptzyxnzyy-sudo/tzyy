-- [[ PHANTOM SQUARE: FIXED REALTIME EXPANDER ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Pastikan PlayerGui tersedia
local PlayerGui = lp:WaitForChild("PlayerGui")

-- [[ STATE ]] --
local active = false
local originalData = {}

-- [[ HAPUS UI LAMA JIKA ADA ]] --
if PlayerGui:FindFirstChild("PhantomNetworkFinal") then
    PlayerGui.PhantomNetworkFinal:Destroy()
end

-- [[ UI SCREEN SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomNetworkFinal"
ScreenGui.Parent = PlayerGui -- Menggunakan PlayerGui agar pasti muncul
ScreenGui.ResetOnSpawn = false

-- [[ 1. LAUNCHER ICON ]] --
local IconBtn = Instance.new("ImageButton", ScreenGui)
IconBtn.Size = UDim2.new(0, 55, 0, 55)
IconBtn.Position = UDim2.new(0, 50, 0.5, -27)
IconBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconBtn.Image = "rbxassetid://12503521360"
IconBtn.ZIndex = 10
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", IconBtn)
IconStroke.Color = Color3.fromRGB(0, 255, 150)
IconStroke.Thickness = 2

-- [[ 2. MAIN FRAME ]] --
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 150)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Visible = false
MainFrame.ZIndex = 11
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NETWORK EXPANDER v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- [[ TOMBOL TOGGLE ]] --
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0, 220, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -110, 0.6, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 18
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- [[ LOGIKA EXPAND ]] --
local function doExpand()
    local char = lp.Character
    if not char then return end
    
    for _, acc in pairs(char:GetChildren()) do
        if acc:IsA("Accessory") then
            local handle = acc:FindFirstChild("Handle")
            if handle then
                local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                if mesh then
                    -- Simpan ukuran asli jika belum ada
                    if not originalData[acc] then
                        originalData[acc] = {S = handle.Size, M = mesh.Scale}
                    end
                    -- Paksa perubahan secara fisik (Network Ownership)
                    handle.Size = Vector3.new(30, 0.5, 30) -- Tebal piringan di Server
                    mesh.Scale = Vector3.new(60, 0.1, 60) -- Visual raksasa
                end
            end
        end
    end
end

local function doReset()
    for acc, data in pairs(originalData) do
        if acc and acc.Parent then
            local handle = acc:FindFirstChild("Handle")
            if handle then
                handle.Size = data.S
                local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                if mesh then mesh.Scale = data.M end
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        ToggleBtn.Text = "ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 150)
        doExpand()
    else
        ToggleBtn.Text = "OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        doReset()
    end
end)

-- Paksa update setiap frame agar server tidak mereset
RunService.Heartbeat:Connect(function()
    if active then doExpand() end
end)

-- [[ INTERAKSI UI ]] --
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Draggable Logic (Simple & Working)
local function drag(gui)
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

drag(MainFrame)
drag(IconBtn)

print("PHANTOM FIX: LOADED TO PLAYERGUI")
