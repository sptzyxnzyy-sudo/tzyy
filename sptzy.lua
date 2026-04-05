local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- UI Cleanup
if CoreGui:FindFirstChild("Ikyy_ToolGrabber_V19") then CoreGui:FindFirstChild("Ikyy_ToolGrabber_V19"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Ikyy_ToolGrabber_V19"
ScreenGui.Parent = CoreGui

-- UI Design (Modern Purple)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 160)
Main.Position = UDim2.new(0.5, -120, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
Main.Parent = ScreenGui
local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 12) Corner.Parent = Main
local Stroke = Instance.new("UIStroke") Stroke.Thickness = 2 Stroke.Color = Color3.fromRGB(170, 0, 255) Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "IKYY TOOL GRABBER V19"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = Main

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 180, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -90, 0.5, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
ToggleBtn.Text = "GRABBER: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.Parent = Main
local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(0, 10) BCorner.Parent = ToggleBtn

-- LOGIKA TOOL GRABBER
local IsGrabbing = false

local function GrabAllTools()
    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not Backpack then return end
    
    -- Lokasi yang discan
    local Locations = {game.Workspace, ReplicatedStorage, Lighting}
    
    for _, folder in pairs(Locations) do
        for _, obj in pairs(folder:GetDescendants()) do
            if not IsGrabbing then break end
            
            -- Cek apakah objek adalah Tool dan bukan milik orang lain
            if obj:IsA("Tool") or obj:IsA("HopperBin") then
                pcall(function()
                    -- Ambil tool ke Backpack
                    obj.Parent = Backpack
                end)
            end
        end
    end
end

-- Monitor jika ada Tool baru muncul saat ON
local function ListenForNewTools()
    game.Workspace.DescendantAdded:Connect(function(descendant)
        if IsGrabbing and descendant:IsA("Tool") then
            local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
            if Backpack then
                pcall(function() descendant.Parent = Backpack end)
            end
        end
    end)
end

ToggleBtn.MouseButton1Click:Connect(function()
    IsGrabbing = not IsGrabbing
    if IsGrabbing then
        ToggleBtn.Text = "GRABBER: ACTIVE"
        ToggleBtn.TextColor3 = Color3.fromRGB(200, 100, 255)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 60)
        
        -- Jalankan scan pertama
        task.spawn(GrabAllTools)
        -- Beritahu user lewat Chat
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[V19]: Scanning and collecting all tools...";
            Color = Color3.fromRGB(170, 0, 255);
        })
    else
        ToggleBtn.Text = "GRABBER: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
    end
end)

-- Jalankan listener satu kali
task.spawn(ListenForNewTools)

-- Draggable Logic
local d, di, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = Main.Position end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
UserInputService.InputChanged:Connect(function(i) if i == di and d then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
