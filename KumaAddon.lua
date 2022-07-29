--Prints on Load
print("|cff00FF96Kuma|cffffffff's Addon is Loaded")

--Hides MacroNames from toolbar
local r={"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"}
for b=1,#r do 
	for i=1,12 do 
		_G[r[b].."Button"..i.."Name"]:SetAlpha(0) 
	end 
end

--Used in the Karma funtions
local karmaExp = "first"

--determines if Karma is active, and sends chat messages on start and end (Used in Karma())
local function Buff()
	local aura = AuraUtil.FindAuraByName("Touch of Karma", "player") 
	if aura then 
		--print("Karma is Active")
		if karmaExp == "first" then 
			SendChatMessage("Taunting for Karma")
			karmaExp = "no"
		end
	elseif karmaExp == "no" then
		--print("Karma is Over")
		SendChatMessage("Taunt Back")
		karmaExp = "yes"
	end
end

--Starts Buff() with 0.5 second intervals if Control is pressed
local function Karma()
	local karmaExp = "no"
	if IsControlKeyDown() then
		
		local i = 0.5
		
		while i <= 30 do
			C_Timer.After(i,Buff)
	
			i = i + 0.5
		end	
	end
end

--new slash command for reloading UI with /rl
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI

--new slash command for activating Karma() with /kk for easy use in macroes
SLASH_KUMA1 = "/kk"
SlashCmdList["KUMA"] = Karma
