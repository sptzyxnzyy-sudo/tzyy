--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local args = {
    "SELL",
    "Padi",
    0/0
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TutorialRemotes"):WaitForChild("RequestSell"):InvokeServer(unpack(args))
