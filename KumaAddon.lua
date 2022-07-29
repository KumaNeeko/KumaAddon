--Prints on Load
print("|cff00FF96Kuma|cffffffff's Addon is Loaded")

--Hides MacroNames from toolbar
local r={"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"}
for b=1,#r do 
	for i=1,12 do 
		_G[r[b].."Button"..i.."Name"]:SetAlpha(0) 
	end 
end

--new slash command for reloading UI with /rl
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI
