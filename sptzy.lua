--[[
    WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
if jumpscare_jeffwuz_loaded and not (_G.jumpscarefucking123 == true) then
    warn("Already Loading")
    return
end

pcall(function() getgenv().jumpscare_jeffwuz_loaded = true end)

getgenv().Notify = false
local Notify_Webhook = "Your Discord Webhook"

if not getcustomasset then
    warn("getcustomasset tidak ditemukan.")
    return
end

local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService('HttpService')
local Players = game:GetService("Players")

local ScreenGui = Instance.new("ScreenGui")
local VideoScreen = Instance.new("VideoFrame")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.Name = "JeffTheKillerWuzHere"

VideoScreen.Parent = ScreenGui
VideoScreen.Size = UDim2.new(1, 0, 1, 0)

-- Untuk download dan menampilkan video, Anda harus pastikan ini berjalan dengan benar di Studio
writefile("yes.mp4", game:HttpGet("https://github.com/HappyCow91/RobloxScripts/blob/main/Videos/videoplayback.mp4?raw=true"))

VideoScreen.Video = getcustomasset("yes.mp4")
VideoScreen.Looped = true
VideoScreen.Playing = true
VideoScreen.Volume = 10

function notify_hook()
    -- Thumb API
    local ThumbnailAPI = game:HttpGet("https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="..player.UserId.."&size=420x420&format=Png&isCircular=true")
    local thumbJson = HttpService:JSONDecode(ThumbnailAPI)
    local avatardata = thumbJson.data[1].imageUrl

    -- User API Script
    local UserAPI = game:HttpGet("https://users.roproxy.com/v1/users/"..player.UserId)
    local userJson = HttpService:JSONDecode(UserAPI)

    -- Description Data
    local DescriptionData = userJson.description
    -- Created Data
    local CreatedData = userJson.created

    local send_data = {
        ["username"] = "Jumpscare Notify",
        ["avatar_url"] = "https://static.wikia.nocookie.net/19dbe80e-0ae6-48c7-98c7-3c32a39b2d7c/scale-to-width/370",
        ["content"] = "Jeff Wuz Here !",
        ["embeds"] = {
            {
                ["title"] = "Jeff's Log",
                ["description"] = "**Game : https://www.roblox.com/games/"..game.PlaceId.."**\n\n**Profile : https://www.roblox.com/users/"..player.UserId.."/profile**\n\n**Job ID : "..game.JobId.."**",
                ["color"] = 4915083,
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = player.Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Display Name",
                        ["value"] = player.DisplayName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "User ID",
                        ["value"] = player.UserId,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Account Age",
                        ["value"] = player.AccountAge.." Day",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Membership",
                        ["value"] = player.MembershipType.Name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Account Created Day",
                        ["value"] = string.match(CreatedData, "^([%d-]+)"),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Profile Description",
                        ["value"] = "```\n"..DescriptionData.."\n```",
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "JTK Log",
                    ["icon_url"] = "https://miro.medium.com/v2/resize:fit:1280/0*c6-eGC3Dd_3HoF-B"
                },
                ["thumbnail"] = {
                    ["url"] = avatardata
                }
            }
        },
    }

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local response = HttpService:RequestAsync({
        Url = Notify_Webhook,
        Method = "POST",
        Headers = headers,
        Body = HttpService:JSONEncode(send_data)
    })
end

if getgenv().Notify == true then
    if Notify_Webhook == '' then
        return
    else
        notify_hook()
    end
elseif getgenv().Notify == false then
    return
else
    warn("True or False")
end

-- Tambahkan GUI untuk cek list pemain dan fitur menarik pemain
local buttonCheckPlayers = Instance.new("TextButton")
buttonCheckPlayers.Text = "Cek List Pemain"
buttonCheckPlayers.Size = UDim2.new(0, 200, 0, 50)
buttonCheckPlayers.Position = UDim2.new(0, 10, 0, 10)
buttonCheckPlayers.Parent = ScreenGui
buttonCheckPlayers.BackgroundColor3 = Color3.fromRGB(0, 0, 255)

local buttonTeleport = Instance.new("TextButton")
buttonTeleport.Text = "Tarik Pemain"
buttonTeleport.Size = UDim2.new(0, 200, 0, 50)
buttonTeleport.Position = UDim2.new(0, 10, 0, 70)
buttonTeleport.Parent = ScreenGui
buttonTeleport.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0, 300, 0, 300)
playerListFrame.Position = UDim2.new(0, 220, 0, 10)
playerListFrame.Parent = ScreenGui
playerListFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
playerListFrame.Visible = false

local playerListScroll = Instance.new("ScrollingFrame")
playerListScroll.Size = UDim2.new(1, 0, 1, 0)
playerListScroll.Position = UDim2.new(0, 0, 0, 0)
playerListScroll.Parent = playerListFrame
playerListScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
playerListScroll.ScrollBarThickness = 10

-- Tampilkan daftar pemain ketika tombol cek list pemain diklik
buttonCheckPlayers.MouseButton1Click:Connect(function()
    playerListFrame.Visible = true
    -- Hapus daftar pemain sebelumnya
    for _, child in pairs(playerListScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Tampilkan pemain yang ada
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local playerButton = Instance.new("TextButton")
            playerButton.Text = p.Name
            playerButton.Size = UDim2.new(1, 0, 0, 30)
            playerButton.Parent = playerListScroll
            playerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.MouseButton1Click:Connect(function()
                -- Ketika pemain diklik, teleport ke mereka
                player.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
            end)
        end
    end
end)

-- Menutup daftar pemain
playerListFrame.MouseButton1Click:Connect(function()
    playerListFrame.Visible = false
end)

-- Fitur untuk menarik pemain ke diri sendiri
buttonTeleport.MouseButton1Click:Connect(function()
    local targetPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]  -- Ambil pemain acak
    if targetPlayer and targetPlayer.Character then
        -- Teleport pemain lain ke posisi pemain lokal
        targetPlayer.Character:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
    end
end)
