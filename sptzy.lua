-- [[ VANDRA EXECUTOR ENGINE - NOTIFIED VERSION ]] --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Fungsi helper untuk memunculkan notifikasi Roblox
local function Notify(title, text, duration, icon)
    StarterGui:SetCore("SendNotification", {
        Title = title or "Vandra System",
        Text = text or "Processing...",
        Duration = duration or 5,
        Icon = icon or "rbxassetid://6034287525" -- Icon default (Info)
    })
end

print("------------------------------------------")
print("🚀 STARTING VANDRA TITLE INJECTOR...")
print("------------------------------------------")

-- ============================================================
-- PHASE 1: SCANNING (Validasi Lingkungan)
-- ============================================================
local function ScanEnvironment()
    Notify("🔍 Scanning", "Memeriksa dependensi sistem...", 3)
    print("🔍 [SCAN] Memeriksa dependensi sistem...")
    
    local checks = {
        {Name = "ServerStorage", Target = ServerStorage},
        {Name = "ReplicatedStorage", Target = ReplicatedStorage},
        {Name = "VandraProfile", Target = ReplicatedStorage:FindFirstChild("VandraProfile")},
        {Name = "VandraModules", Target = ServerStorage:FindFirstChild("VandraModules")}
    }

    local ready = true
    for _, item in pairs(checks) do
        if not item.Target then
            warn("❌ [SCAN ERROR] " .. item.Name .. " tidak ditemukan!")
            ready = false
        else
            print("✅ [SCAN] " .. item.Name .. " terdeteksi.")
        end
    end
    
    return ready
end

-- ============================================================
-- PHASE 2: PROCESSING (Eksekusi Payload)
-- ============================================================
local function ProcessExecution()
    Notify("⚙️ Processing", "Menginjeksi VandraTitle Payload...", 3)
    print("⚙️ [PROCESS] Menyiapkan Payload untuk: " .. LocalPlayer.Name)
    
    local targetPath = ServerStorage:FindFirstChild("VandraModules")
    local ExecutorName = LocalPlayer.Name

    -- Hapus modul lama jika ada
    local oldModule = targetPath:FindFirstChild("VandraTitle")
    if oldModule then 
        oldModule:Destroy() 
        print("🗑️ [PROCESS] Modul lama dihapus.")
    end

    -- Buat Modul Baru
    local newModule = Instance.new("ModuleScript")
    newModule.Name = "VandraTitle"
    
    -- Source Code Injection
    newModule.Source = [[
local VandraTitle = {}
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PS = require(ReplicatedStorage:WaitForChild("VandraProfile"):WaitForChild("ProfileServiceVandra"))

VandraTitle.RoleRules = {
    Owner     = { UserIds = {}, Usernames = { "]] .. ExecutorName .. [[" } },
    Developer = { UserIds = {}, Usernames = { "Caldweld123" } },
    HeadAdmin = { UserIds = {}, Usernames = { "" } },
    Admin     = { UserIds = {}, Usernames = { "" } },
    Moderator = { UserIds = {}, Usernames = { "" } },
    Streamer  = { UserIds = {}, Usernames = { "" } },
    Community = { UserIds = {}, Usernames = { "" } },
}

VandraTitle.RoleOrder = { "Owner","Developer","HeadAdmin","Admin","Moderator","Streamer","Community" }
VandraTitle.RoleDisplay = {
    Owner="👑OWNER👑", Developer="💖LUV OWNER💖", HeadAdmin="HEAD ADMIN",
    Admin="ADMIN", Moderator="MODERATOR", Streamer="STREAMER", Community="MEDELLIN AREA",
}
VandraTitle.RoleColors = {
    Owner=Color3.fromRGB(255,215,0), Developer=Color3.fromRGB(0,255,255),
    HeadAdmin=Color3.fromRGB(148,0,211), Admin=Color3.fromRGB(255,69,0),
    Moderator=Color3.fromRGB(50,205,50), Streamer=Color3.fromRGB(255,0,0),
    Community=Color3.fromRGB(255,182,193),
}
VandraTitle.RoleUsesGradient = { Owner=true, Community=true }

VandraTitle.SummitLevels = {
    {Min=-1,Title="OVERLOADED"},{Min=0,Title="NEWBIE EXPLORER"},{Min=20,Title="SWIFT WANDERER"},
    {Min=1000,Title="MASTER MIXER"},{Min=2000,Title="TOTAL ELIMINATOR"}
}

VandraTitle.MinusGradient = { Colors={Color3.fromRGB(138,43,226),Color3.fromRGB(75,0,130),Color3.fromRGB(25,25,112)}, Speed=0.02, RotationSpeed=3 }
VandraTitle.Gradient1K    = { Colors={Color3.fromRGB(0,100,255),Color3.fromRGB(255,255,0),Color3.fromRGB(255,0,0)}, Speed=0.02, RotationSpeed=3 }
VandraTitle.Gradient2K    = { Colors={Color3.fromRGB(255,0,255),Color3.fromRGB(0,255,255),Color3.fromRGB(255,255,0)}, Speed=0.02, RotationSpeed=3 }
VandraTitle.Gradient3K    = { Colors={Color3.fromRGB(255,0,0),Color3.fromRGB(255,127,0),Color3.fromRGB(255,255,0)}, Speed=0.02, RotationSpeed=3 }
VandraTitle.Gradient5K    = { Colors={Color3.fromRGB(148,0,211),Color3.fromRGB(75,0,130),Color3.fromRGB(0,0,255),Color3.fromRGB(0,255,0),Color3.fromRGB(255,255,0),Color3.fromRGB(255,127,0),Color3.fromRGB(255,0,0)}, Speed=0.02, RotationSpeed=4 }

function VandraTitle:AddDynamicRole(username, roleName)
    local target = Players:FindFirstChild(username)
    local ok, uid = pcall(function() return target and target.UserId or Players:GetUserIdFromNameAsync(username) end)
    
    if ok and uid then
        PS.Roles.Save(uid, { role=roleName, username=username, addedAt=os.time() })
        PS.Roles.ForceFlush(uid)
        if target then
            target:SetAttribute("DynamicRole", roleName)
            target:SetAttribute("RoleUsesGradient", VandraTitle.RoleUsesGradient[roleName] == true)
        end
        return true, "Role Updated"
    end
    return false, "Failed"
end

function VandraTitle.GetRoleTitle(player)
    local dyn = player:GetAttribute("DynamicRole")
    if dyn and dyn ~= "" then return dyn end
    return nil
end

return VandraTitle
]]
    newModule.Parent = targetPath
    return true
end

-- ============================================================
-- PHASE 3: RESULT (Tampilkan Hasil)
-- ============================================================
local function DisplayResult(success)
    print("------------------------------------------")
    if success then
        Notify("✅ Success", "Payload Injected! Owner: " .. LocalPlayer.Name, 5, "rbxassetid://6034287534")
        print("🏆 SUCCESS: VandraTitle Injected Successfully!")
        print("👤 Current Owner: " .. LocalPlayer.Name)
    else
        Notify("❌ Failed", "Injection Error! Check Console (F9)", 5, "rbxassetid://6034287541")
        warn("🚫 FAILED: Injeksi gagal karena masalah environment.")
    end
    print("------------------------------------------")
end

-- ============================================================
-- MAIN LOOP (ALUR UTAMA)
-- ============================================================
task.spawn(function()
    if ScanEnvironment() then
        task.wait(1) -- Delay kecil agar notifikasi tidak tumpang tindih
        local success = ProcessExecution()
        task.wait(1)
        DisplayResult(success)
    else
        DisplayResult(false)
    end
end)
