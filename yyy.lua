-- [[ DARK.CC PREMIUM EDITION ]]
-- Optimized for: Delta, Fluxus, Codex, and PC Executors

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // Configuration
local Window = Rayfield:CreateWindow({
    Name = "🌑 Dark.cc | Universal Pro",
    LoadingTitle = "Bypassing Security...",
    LoadingSubtitle = "by @iceglock66",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "dark_cc_v3"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = false
    },
    KeySystem = false
})

-- // Variables
local SelectedItem = nil
local CachedProducts = {}

-- // Function: Fetch Products (Safe Mode)
local function FetchProducts()
    local success, result = pcall(function()
        return MarketplaceService:GetDeveloperProductsAsync()
    end)
    
    if success and result then
        local names = {}
        CachedProducts = {} -- Reset cache
        local page = result:GetCurrentPage()
        
        for _, item in pairs(page) do
            table.insert(CachedProducts, {
                Name = item.Name or "Unknown",
                ID = item.ProductId or 0,
                Price = item.PriceInRobux or 0,
                Description = item.Description or "No Description"
            })
            table.insert(names, item.Name or "Unknown")
        end
        return names
    else
        return {"No Products Found"}
    end
end

-- // Function: Purchase Simulation (Executor Safe)
local function AttemptPurchase(id)
    if not id or id == 0 then return false end
    local s, _ = pcall(function()
        MarketplaceService:SignalPromptProductPurchaseFinished(LocalPlayer.UserId, id, true)
    end)
    return s
end

-- // Main Tab
local MainTab = Window:CreateTab("Automation", 4483362458)

-- // Initial Notification
Rayfield:Notify({
    Title = "🚀 EXECUTOR READY",
    Content = "Dark.cc has been loaded successfully for **" .. LocalPlayer.DisplayName .. "**",
    Duration = 5,
    Image = 4483362458,
})

MainTab:CreateSection("Target Settings")

local Dropdown = MainTab:CreateDropdown({
    Name = "Select Product",
    Options = FetchProducts(),
    CurrentOption = {"None Selected"},
    MultipleOptions = false,
    Flag = "ProductSelection",
    Callback = function(Option)
        local choice = Option[1]
        for _, item in ipairs(CachedProducts) do
            if item.Name == choice then
                SelectedItem = item
                break
            end
        end
    end
})

MainTab:CreateButton({
    Name = "💎 Purchase Selected",
    Callback = function()
        if SelectedItem then
            local success = AttemptPurchase(SelectedItem.ID)
            if success then
                Rayfield:Notify({
                    Title = "✅ SUCCESS",
                    Content = "Transaction triggered for: **" .. SelectedItem.Name .. "**",
                    Duration = 4,
                    Image = 11419719540
                })
            end
        else
            Rayfield:Notify({
                Title = "⚠️ WARNING",
                Content = "Please select an item first!",
                Duration = 3,
                Image = 11419713314
            })
        end
    end
})

MainTab:CreateButton({
    Name = "📦 Mass Purchase (Buy All)",
    Callback = function()
        Rayfield:Notify({
            Title = "⏳ PROCESSING",
            Content = "Executing mass purchase. Please wait...",
            Duration = 3,
            Image = 4483362458
        })

        local count = 0
        for _, item in ipairs(CachedProducts) do
            if AttemptPurchase(item.ID) then
                count = count + 1
            end
            task.wait(0.2) -- Safe delay for executors
        end

        Rayfield:Notify({
            Title = "🔥 COMPLETED",
            Content = "Successfully processed **" .. count .. "** items.",
            Duration = 5,
            Image = 11419719540
        })
    end
})

MainTab:CreateButton({
    Name = "🔄 Refresh Database",
    Callback = function()
        local list = FetchProducts()
        Dropdown:SetOptions(list)
        Rayfield:Notify({
            Title = "📡 SYNCED",
            Content = "Product list updated!",
            Duration = 2,
            Image = 4483362458
        })
    end
})

MainTab:CreateButton({
    Name = "📋 Copy Item ID",
    Callback = function()
        if SelectedItem then
            -- Safe Clipboard check for mobile/PC executors
            local clipboard = setclipboard or toclipboard or (Syn and Syn.set_clipboard)
            if clipboard then
                clipboard(tostring(SelectedItem.ID))
                Rayfield:Notify({
                    Title = "📝 COPIED",
                    Content = "ID: **" .. SelectedItem.ID .. "** copied to clipboard.",
                    Duration = 3,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "❌ ERROR",
                    Content = "Your executor doesn't support clipboard!",
                    Duration = 3,
                    Image = 11419713314
                })
            end
        end
    end
})

MainTab:CreateSection("Item Inspector")
local InfoLabel = MainTab:CreateLabel("Status: Waiting for selection...")

-- // Background Task (Optimized)
task.spawn(function()
    while task.wait(0.5) do
        if SelectedItem then
            InfoLabel:Set(string.format(
                "🏷️ **Item**: %s\n💵 **Price**: %d R$\n🆔 **ID**: %s", 
                SelectedItem.Name, 
                SelectedItem.Price, 
                SelectedItem.ID
            ))
        end
    end
end)
