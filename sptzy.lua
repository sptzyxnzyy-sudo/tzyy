-- [[ SPTZYY MULTIPLAYER REJOIN & HOPPER ]] --
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- [[ FUNGSI REJOIN ]] --
local function rejoinCurrentServer()
    -- Memaksa kamu masuk kembali ke server (JobId) yang sama
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
end

-- [[ FUNGSI COPY SERVER ID (Untuk ajak orang lain) ]] --
local function copyServerId()
    local jobId = game.JobId
    setclipboard(jobId) -- Menyalin ID Server ke clipboard HP/PC kamu
    -- Catatan: Gunakan ID ini untuk diberikan ke teman agar mereka bisa join server yang sama
end

-- [[ UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 190)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "SERVER CONTROLLER 🌐"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- Tombol 1: Rejoin (Untuk Kamu)
local RejoinBtn = Instance.new("TextButton", MainFrame)
RejoinBtn.Size = UDim2.new(0.85, 0, 0, 40)
RejoinBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
RejoinBtn.Text = "REJOIN ME"
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", RejoinBtn)

-- Tombol 2: Copy Server ID (Agar Player lain bisa ikut)
local CopyBtn = Instance.new("TextButton", MainFrame)
CopyBtn.Size = UDim2.new(0.85, 0, 0, 40)
CopyBtn.Position = UDim2.new(0.075, 0, 0.50, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CopyBtn.Text = "COPY SERVER ID"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CopyBtn)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, 0, 0, 40)
Info.Position = UDim2.new(0, 0, 0.75, 0)
Info.Text = "Note: Client cannot force\nother players to teleport."
Info.TextColor3 = Color3.fromRGB(180, 180, 180)
Info.TextSize = 10
Info.BackgroundTransparency = 1

-- [[ LOGIC ]] --
RejoinBtn.MouseButton1Click:Connect(function()
    rejoinCurrentServer()
end)

CopyBtn.MouseButton1Click:Connect(function()
    copyServerId()
    CopyBtn.Text = "COPIED TO CLIPBOARD!"
    task.wait(2)
    CopyBtn.Text = "COPY SERVER ID"
end)
