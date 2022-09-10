--Prints on Load
print("|cff00FF96Kuma|cffffffff's Addon is Loaded")

--Hides MacroNames from toolbar
function hideMacroName()
   local r={"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"}
   for b=1,#r do 
      for i=1,12 do
         _G[r[b].."Button"..i.."Name"]:SetAlpha(KumaSettings["hideMacroNames"] and 0 or 1)
      end 
   end
end

local f = CreateFrame("Frame")

f.defaults = {
	scriptErrors = false,
	hideMacroNames = true,
}

function KumaUpdateCVar(CVar)
   if KumaSettings[CVar] then
      SetCVar(CVar, 1)
   else
      SetCVar(CVar, 0)
   end
end
   
function f:OnEvent(event, addOnName)
	if addOnName == "KumaAddon" then
		KumaSettings = KumaSettings or CopyTable(self.defaults)
		self.db = KumaSettings
		self:InitializeOptions()
      KumaUpdateCVar("scriptErrors")
      hideMacroName()
	end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)

function f:InitializeOptions()
	self.panel = CreateFrame("Frame")
	self.panel.name = "KumaAddon"

	local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, -20)
	cb.Text:SetText("Display LUA Errors")
	cb.SetValue = function(_, value)
		self.db.scriptErrors = (value == "1") -- value can be either "0" or "1"
      KumaUpdateCVar("scriptErrors")
	end
	cb:SetChecked(self.db.scriptErrors) -- set the initial checked state

	local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", 20, -40)
	cb.Text:SetText("Hide Macro Names")
	cb.SetValue = function(_, value)
		self.db.hideMacroNames = (value == "1") -- value can be either "0" or "1"
      hideMacroName()
	end
	cb:SetChecked(self.db.hideMacroNames) -- set the initial checked state

	local btn = CreateFrame("Button", nil, self.panel, "UIPanelButtonTemplate")
	btn:SetPoint("TOPLEFT", cb, 0, -60)
	btn:SetText("Reload")
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
      ReloadUI()
	end)

	InterfaceOptions_AddCategory(self.panel)
end

--new slash command for reloading UI with /rl
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI
