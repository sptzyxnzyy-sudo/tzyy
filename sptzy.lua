-- [[ SPTZYY AUTO-TAG: ANTI-SPAM & TOGGLE EDITION ]] --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local MarketplaceService = game:GetService("MarketplaceService")
local lp = Players.LocalPlayer

-- [[ SETTINGS ]] --
local botActive = true
local chatQueue = {}
local isProcessingQueue = false
local spamDelay = 4 -- Jeda antar pesan (detik) agar aman dari sensor

-- [[ AUTO-DETECT MAP ]] --
local success, gameInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
local mapName = success and gameInfo.Name or "Map Donasi"

-- [[ FUNGSI PENGIRIMAN CHAT (QUEUE SYSTEM) ]] --
local function AddToQueue(msg)
    if not botActive then return end
    table.insert(chatQueue, msg)
end

task.spawn(function()
    while true do
        if #chatQueue > 0 and botActive then
            local msg = chatQueue[1]
            table.remove(chatQueue, 1)
            
            -- Kirim ke sistem chat lama
            local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
            if chatRemote then chatRemote:FireServer(msg, "All") end
            
            -- Kirim ke sistem chat baru
            if TextChatService.TextChannels:FindFirstChild("RBXGeneral") then
                TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
            end
            task.wait(spamDelay)
        end
        task.wait(0.5)
    end
end)

-- [[ 1. JOIN ANNOUNCE ]] --
task.spawn(function()
    task.wait(10)
    AddToQueue("Halo semua! Saya baru mendarat di " .. mapName .. ". Salam kenal ya!")
end)

-- [[ 2. AUTO WELCOME JOIN ]] --
Players.PlayerAdded:Connect(function(newPlayer)
    task.wait(5)
    AddToQueue("Selamat datang @" .. newPlayer.Name .. " di " .. mapName .. "! Semoga betah ya.")
end)

-- [[ 3. AUTO REPLY CHAT ]] --
Players.PlayerChatted:Connect(function(chatType, player, message)
    if player == lp or not botActive then return end
    local msg = message:lower()
    local tag = "@" .. player.Name
    
    if msg:find("donasi") or msg:find("bagi") or msg:find("bantu") or msg:find("cek") then
        AddToQueue("Halo " .. tag .. ", kalau ada rezeki boleh mampir ke stand saya ya. Terima kasih!")
    elseif msg:find("makasih") or msg:find("tq") or msg:find("done") or msg:find("sudah") then
        AddToQueue("MasyaAllah, terima kasih banyak " .. tag .. "! Semoga rezekinya dilipatgandakan. Aamiin!")
    end
end)

-- [[ 4. UI SETUP (ON/OFF BUTTON) ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainBtn = Instance.new("TextButton", ScreenGui)
MainBtn.Size = UDim2.new(0, 150, 0, 45)
MainBtn.Position = UDim2.new(0.5, -75, 0, 20)
MainBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
MainBtn.Text = "BOT: ACTIVE"
MainBtn.TextColor3 = Color3.new(1,1,1)
MainBtn.Font = Enum.Font.GothamBold
MainBtn.Draggable = true
Instance.new("UICorner", MainBtn)

MainBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    if botActive then
        MainBtn.Text = "BOT: ACTIVE"
        MainBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        chatQueue = {} -- Reset antrean saat aktif kembali
    else
        MainBtn.Text = "BOT: OFF"
        MainBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)
