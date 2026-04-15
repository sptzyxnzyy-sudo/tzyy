-- [[ PHANTOM ACCESSORY & RIG ANALYZER ]]
-- Murni untuk Scan, Tampil, dan Copy (No Auto-Modify)

local LP = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- [[ 1. NOTIFIKASI SYSTEM ]]
local function SendNotif(title, msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = msg,
        Duration = 3
    })
end

-- [[ 2. LOGIKA SCANNER & CODE GENERATOR ]]
local function RunScanner()
    local char = LP.Character
    if not char then 
        SendNotif("ERROR", "Karakter tidak ditemukan!")
        return 
    end
    
    -- Pembersihan Console agar rapi saat di copy
    for i = 1, 30 do print(" ") end 
    
    print("================================================")
    print("   PHANTOM ACCESSORY SCANNER - REPORT LOG   ")
    print("================================================")
    print("User: " .. LP.Name)
    print("Time Scan: " .. os.date("%X"))
    print("------------------------------------------------")
    
    local foundCount = 0
    
    for _, acc in pairs(char:GetChildren()) do
        if acc:IsA("Accessory") then
            foundCount = foundCount + 1
            local handle = acc:FindFirstChild("Handle")
            local mesh = handle and (handle:FindFirstChildOfClass("SpecialMesh") or handle:FindFirstChildOfClass("MeshPart"))
            
            -- Informasi Detail
            local meshType = mesh and mesh.ClassName or "None"
            local currentScale = "N/A"
            if mesh then
                currentScale = (mesh:IsA("SpecialMesh") and tostring(mesh.Scale)) or (mesh:IsA("MeshPart") and tostring(handle.Size))
            end

            -- Print format rapi untuk dicopy
            print(string.format("[%d] ACCESSORY: %s", foundCount, acc.Name))
            print(string.format("    > Type: %s", meshType))
            print(string.format("    > Current Scale: %s", currentScale))
            print("    > ID: " .. (acc:FindFirstChild("AssetId") and acc.AssetId or "Custom/Generated"))
            
            -- Generate Snippet Kode untuk Manual Edit
            print("    > CODE SNIPPET (Copy below):")
            print(string.format("      game.Players.LocalPlayer.Character['%s'].Handle.%s.Scale = Vector3.new(200, 200, 200)", acc.Name, meshType))
            print("------------------------------------------------")
        end
    end
    
    print("TOTAL ACCESSORIES FOUND: " .. foundCount)
    print("================================================")
    print("TIPS: Tekan F9, lalu blok teks di atas dan tekan CTRL+C untuk Copy.")
    
    SendNotif("SCAN COMPLETE", foundCount .. " Aksesori terdeteksi di Console!")
end

-- [[ 3. UI SETUP (DARK NEON CYAN) ]]
local SG = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 250, 0, 120)
Main.Position = UDim2.new(0.5, -125, 0.5, -60)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Garis Neon Atas
local Neon = Instance.new("Frame", Main)
Neon.Size = UDim2.new(1, 0, 0, 2)
Neon.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Neon.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ACC SCANNER v3"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0, 210, 0, 45)
ScanBtn.Position = UDim2.new(0.5, -105, 0.45, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScanBtn.Text = "START SCAN"
ScanBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ScanBtn.Font = Enum.Font.Gotham
ScanBtn.BorderSizePixel = 0

local Hint = Instance.new("TextLabel", Main)
Hint.Size = UDim2.new(1, 0, 0, 20)
Hint.Position = UDim2.new(0, 0, 1, -20)
Hint.Text = "Output will be shown in Console (F9)"
Hint.TextColor3 = Color3.fromRGB(100, 100, 100)
Hint.TextSize = 10
Hint.BackgroundTransparency = 1

-- [[ 4. INTERACTION ]]
ScanBtn.MouseButton1Click:Connect(function()
    ScanBtn.Text = "SCANNING..."
    ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 80)
    
    task.wait(0.5)
    RunScanner()
    
    ScanBtn.Text = "START SCAN"
    ScanBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)
