local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // Configuration Window
local Window = Rayfield:CreateWindow({
    Name = "🌑 Dark.cc | Premium Product",
    LoadingTitle = "Securing Connection...",
    LoadingSubtitle = "Created by @iceglock66",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "dark_cc_v2"
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

-- // Function: Ambil Data Produk
local function UpdateProductList()
    CachedProducts = {}
    local success, result = pcall(function()
        return MarketplaceService:GetDeveloperProductsAsync()
    end)
    
    if success then
        for _, item in pairs(result:GetCurrentPage()) do
            table.insert(CachedProducts, {
                Name = item.Name,
                ID = item.ProductId,
                Description = item.Description or "No Description",
                Price = item.PriceInRobux or 0
            })
        end
    else
        warn("Critical Error: Gagal mengambil data produk.")
    end
    
    local names = {}
    for _, item in ipairs(CachedProducts) do
        table.insert(names, item.Name)
    end
    return #names > 0 and names or {"No Items Found"}
end

-- // Function: Trigger Purchase (Simulasi)
local function TriggerPurchase(id)
    local s, e = pcall(function()
        MarketplaceService:SignalPromptProductPurchaseFinished(LocalPlayer.UserId, id, true)
    end)
    return s, e
end

-- // Notifikasi Welcome
Rayfield:Notify({
    Title = "🚀 SYSTEM INJECTED",
    Content = "Welcome, **" .. LocalPlayer.Name .. "**. Service is now active.",
    Duration = 4.5,
    Image = 11419713314,
})

-- // Main Tab
local MainTab = Window:CreateTab("Automation", 4483362458)

MainTab:CreateSection("Product Management")

local Dropdown = MainTab:CreateDropdown({
    Name = "Select Target Product",
    Options = UpdateProductList(),
    CurrentOption = {"Choose an item"},
    MultipleOptions = false,
    Flag = "MainDropdown",
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
    Name = "💸 Purchase Selected",
    Callback = function()
        if not SelectedItem then
            Rayfield:Notify({
                Title = "⚠️ VOID",
                Content = "Please select a product from the list first!",
                Duration = 3,
                Image = "rbxassetid://11419713314"
            })
            return
        end

        local success = TriggerPurchase(SelectedItem.ID)
        if success then
            Rayfield:Notify({
                Title = "✅ TRANSACTION SUCCESS",
                Content = "Successfully processed: **" .. SelectedItem.Name .. "**",
                Duration = 4,
                Image = "rbxassetid://11419719540"
            })
        end
    end
})

MainTab:CreateButton({
    Name = "📦 Buy All (Mass Purchase)",
    Callback = function()
        Rayfield:Notify({
            Title = "⏳ MASS PROCESSING",
            Content = "Executing all items in queue...",
            Duration = 3,
            Image = 4483362458
        })

        local count = 0
        for _, item in ipairs(CachedProducts) do
            local s = TriggerPurchase(item.ID)
            if s then count = count + 1 end
            task.wait(0.4) -- Delay agar tidak crash
        end

        Rayfield:Notify({
            Title = "🔥 COMPLETED",
            Content = "Successfully processed **" .. count .. "** products.",
            Duration = 5,
            Image = "rbxassetid://11419719540"
        })
    end
})

MainTab:CreateButton({
    Name = "🔄 Sync/Refresh List",
    Callback = function()
        local updated = UpdateProductList()
        Dropdown:SetOptions(updated)
        Rayfield:Notify({
            Title = "📡 SYNCED",
            Content = "Database refreshed. Found **" .. #updated .. "** items.",
            Duration = 3,
            Image = 4483362458
        })
    end
})

MainTab:CreateButton({
    Name = "📋 Copy Item ID",
    Callback = function()
        if SelectedItem and setclipboard then
            setclipboard(tostring(SelectedItem.ID))
            Rayfield:Notify({
                Title = "📝 COPIED",
                Content = "ID: **" .. SelectedItem.ID .. "** added to clipboard.",
                Duration = 3,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "❌ ERROR",
                Content = "Action failed. Make sure item is selected.",
                Duration = 3,
                Image = "rbxassetid://11419713314"
            })
        end
    end
})

MainTab:CreateSection("Item Inspector")
local InfoLabel = MainTab:CreateLabel("Waiting for selection...")

-- // Background Task untuk Update Label
task.spawn(function()
    while true do
        if SelectedItem then
            InfoLabel:Set(string.format(
                "🔹 **Name**: %s\n🔹 **Price**: %d R$\n🔹 **ID**: %s", 
                SelectedItem.Name, 
                SelectedItem.Price, 
                SelectedItem.ID
            ))
        end
        task.wait(0.5)
    end
end)
