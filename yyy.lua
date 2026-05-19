-- [[ KRIPTOS PHYSICAL ENGINE v6.0 - EXECUTOR MOBILE EDITION ]] --
-- Menggunakan Rayfield Library: Dijamin muncul di Delta, Hydrogen, Fluxus, dll.
-- Fitur: Pure Physics (Tanpa Toolbox)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "KRIPTOS PHYSICAL ENGINE v6.0",
   LoadingTitle = "Pure Physics Framework",
   LoadingSubtitle = "by @sptzyy & @ikyy",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- State Fitur
local ActiveStates = {
    ["Mass Drag"] = false,
    ["Mass Spin"] = false,
    ["Black Hole"] = false,
    ["Fling Slingshot"] = false,
    ["Break Constraints"] = false
}

local StoredObjects = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function ClearAllFisika()
    for _, obj in pairs(StoredObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    StoredObjects = {}
end

local function isAPlayerCharacterPart(part)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and part:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end

-- Loop Engine Fisika
RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    local anyFeatureActive = false
    for _, state in pairs(ActiveStates) do
        if state then anyFeatureActive = true break end
    end
    
    if not hrp or not anyFeatureActive then
        ClearAllFisika()
        return
    end
    
    local scanRadius = 150
    local targetParts = {}
    
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored and not isAPlayerCharacterPart(part) then
            local distance = (part.Position - hrp.Position).Magnitude
            if distance <= scanRadius then
                table.insert(targetParts, part)
            end
        end
    end
    
    for _, part in pairs(targetParts) do
        if part.Velocity.Magnitude < 1 then
            part.Velocity = Vector3.new(0, -0.1, 0)
        end
        
        -- [1] MASS DRAG
        if ActiveStates["Mass Drag"] then
            if not part:FindFirstChild("DragAtt") then
                local att1 = Instance.new("Attachment")
                att1.Name = "DragAtt"
                att1.Parent = part
                
                local att0 = Instance.new("Attachment")
                att0.Name = "PlayerDragAtt"
                att0.Parent = hrp
                
                local rope = Instance.new("RopeConstraint")
                rope.Name = "DragRope"
                rope.Attachment0 = att0
                rope.Attachment1 = att1
                rope.Length = 10
                rope.Visible = true
                rope.Color = BrickColor.new("Cyan")
                rope.Parent = part
                
                table.insert(StoredObjects, att1)
                table.insert(StoredObjects, att0)
                table.insert(StoredObjects, rope)
            end
        end
        
        -- [2] MASS SPIN
        if ActiveStates["Mass Spin"] then
            if not part:FindFirstChild("SpinVelocity") then
                local att = Instance.new("Attachment")
                att.Name = "SpinAtt"
                att.Parent = part
                
                local av = Instance.new("AngularVelocity")
                av.Name = "SpinVelocity"
                av.Attachment0 = att
                av.MaxTorque = math.huge
                av.AngularVelocity = Vector3.new(0, 80, 0)
                av.Parent = part
                
                table.insert(StoredObjects, att)
                table.insert(StoredObjects, av)
            end
        end
        
        -- [3] BLACK HOLE
        if ActiveStates["Black Hole"] then
            local lv = part:FindFirstChild("BlackHoleVelocity")
            local att = part:FindFirstChild("BlackHoleAtt")
            
            if not lv then
                att = Instance.new("Attachment")
                att.Name = "BlackHoleAtt"
                att.Parent = part
                
                lv = Instance.new("LinearVelocity")
                lv.Name = "BlackHoleVelocity"
                lv.Attachment0 = att
                lv.MaxForce = math.huge
                lv.Parent = part
                
                table.insert(StoredObjects, att)
                table.insert(StoredObjects, lv)
            end
            local targetPos = hrp.Position + Vector3.new(0, 18, 0)
            lv.VectorVelocity = (targetPos - part.Position).Unit * 55
        end
        
        -- [4] FLING SLINGSHOT
        if ActiveStates["Fling Slingshot"] then
            if not part:FindFirstChild("FlingForce") then
                local att = Instance.new("Attachment")
                att.Name = "FlingAtt"
                att.Parent = part
                
                local vf = Instance.new("VectorForce")
                vf.Name = "FlingForce"
                vf.Attachment0 = att
                vf.Force = Vector3.new(math.random(-85000, 85000), 110000, math.random(-85000, 85000))
                vf.Parent = part
                
                table.insert(StoredObjects, att)
                table.insert(StoredObjects, vf)
            end
        end
        
        -- [5] BREAK CONSTRAINTS
        if ActiveStates["Break Constraints"] then
            for _, joint in pairs(part:GetChildren()) do
                if joint:IsA("Constraint") or joint:IsA("Weld") or joint:IsA("ManualWeld") or joint:IsA("WeldConstraint") or joint:IsA("Motor6D") or joint:IsA("Snap") then
                    joint:Destroy()
                end
            end
        end
    end
end)

-- Pembuatan Tab & Toggle Menu UI Eksternal
local MainTab = Window:CreateTab("Physics Main", nil)

MainTab:CreateToggle({
   Name = "Mass Drag",
   CurrentValue = false,
   Flag = "mass_drag", 
   Callback = function(Value)
      ActiveStates["Mass Drag"] = Value
      if not Value then ClearAllFisika() end
   end,
})

MainTab:CreateToggle({
   Name = "Mass Spin",
   CurrentValue = false,
   Flag = "mass_spin",
   Callback = function(Value)
      ActiveStates["Mass Spin"] = Value
      if not Value then ClearAllFisika() end
   end,
})

MainTab:CreateToggle({
   Name = "Black Hole",
   CurrentValue = false,
   Flag = "black_hole",
   Callback = function(Value)
      ActiveStates["Black Hole"] = Value
      if not Value then ClearAllFisika() end
   end,
})

MainTab:CreateToggle({
   Name = "Fling Slingshot",
   CurrentValue = false,
   Flag = "fling_slingshot",
   Callback = function(Value)
      ActiveStates["Fling Slingshot"] = Value
      if not Value then ClearAllFisika() end
   end,
})

MainTab:CreateToggle({
   Name = "Break Constraints",
   CurrentValue = false,
   Flag = "break_constraints",
   Callback = function(Value)
      ActiveStates["Break Constraints"] = Value
   end,
})

Rayfield:Notify({
   Title = "Kriptos Physics Loaded",
   Content = "Pure physics mode sukses dijalankan!",
   Duration = 4.5,
   Image = nil,
})
