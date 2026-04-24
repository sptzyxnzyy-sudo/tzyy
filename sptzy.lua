-- BAGIAN LOGIKA DALAM SCRIPT LED KAMU
local function apply(mode, color)
    stop()
    currentLoop = runService.Heartbeat:Connect(function()
        local finalColor = color
        
        if mode == "Rainbow" then
            finalColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        elseif mode == "Disco" then
            finalColor = Color3.new(math.random(), math.random(), math.random())
        end
        
        -- KITA TEBENGIN (BYPASS) KE REMOTE BAWAAN GAME
        -- Ini akan memaksa server mengubah warna karena pesannya "resmi" dari game
        game:GetService("ReplicatedStorage").UpdateVehicle:FireServer("WheelColor", finalColor)
    end)
end
