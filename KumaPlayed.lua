local PlayedFrame = CreateFrame("Frame", "Kuma_PlayTime", UIParent)
PlayedFrame:SetMovable(true)
PlayedFrame:EnableMouse(true)
PlayedFrame:RegisterForDrag("LeftButton")
PlayedFrame:SetScript("OnDragStart", PlayedFrame.StartMoving)
PlayedFrame:SetScript("OnDragStop", PlayedFrame.StopMovingOrSizing)
-- The code below makes the PlayedFrame visible, and is not necessary to enable dragging.
PlayedFrame:SetPoint("CENTER"); PlayedFrame:SetWidth(200); PlayedFrame:SetHeight(60);
tex = PlayedFrame:CreateTexture("ARTWORK");
tex:SetAllPoints();
tex:SetColorTexture(0, 0, 0); tex:SetAlpha(0.75);
   
PlayText=PlayedFrame:CreateFontString(nil,"OVERLAY","GameFontNormal");
PlayText:SetText("Total time played: \nTime played this level: \nEstimated time for next Level: ");
PlayText:SetPoint("TOPLEFT",PlayedFrame,"TOPLEFT",5,-5)
PlayText:SetJustifyV("TOP");
PlayText:SetJustifyH("LEFT");

PlayedFrame:Hide()

function KumaAddon_OnUpdate(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed;
	if (self.elapsed >= 1.0) then -- The 1.0 is the delay, in seconds, between each OnUpdate
		XPCalc = 100 / (UnitXP("player") / UnitXPMax("player") * 100) * TimeLevel
		
        PlayText:SetText("Total time played: "..KumaSecondsToDays(TimeTotal).."\nTime played this level: "..KumaSecondsToDays(TimeLevel).."\nEstimated time for this Level: "..KumaSecondsToDays(XPCalc).."\nEstimated time for level up: "..KumaSecondsToDays(XPCalc-TimeLevel));
        width = PlayText:GetStringWidth() + 10;
        PlayedFrame:SetWidth(width);
         
        TimeLevel = TimeLevel + 1
		TimeTotal = TimeTotal + 1
		
        self.elapsed = 0
    end
end

local o = ChatFrame_DisplayTimePlayed
ChatFrame_DisplayTimePlayed = function(...)
	if (cachingPlaytime) then
		cachingPlaytime = false
		return
	end
	return o(...)
end 
 
function Kuma_PlayFrame()
	if PlayedFrame:IsVisible() then
		PlayedFrame:Hide()
	else
		cachingPlaytime = true
		RequestTimePlayed()
		PlayedFrame:Show()
		PlayedFrame:SetScript("OnUpdate", KumaAddon_OnUpdate)
	end
end

local KumaTime = CreateFrame("Frame")
KumaTime:RegisterEvent("TIME_PLAYED_MSG")
KumaTime:RegisterEvent("PLAYER_LOGIN")
KumaTime:RegisterEvent("PLAYER_LEVEL_UP")

function KumaTime:TIME_PLAYED_MSG(total, currentLevel)
   TimeTotal = total
   TimeLevel = currentLevel
end

KumaDB = KumaDB or {}
function KumaTime:PLAYER_LEVEL_UP(newLevel)
	--if PlayedFrame:IsVisible() == false then
	--	Kuma_PlayFrame()
	--end
	
	oldLevel = newLevel - 1
	print("|cffFF4700[Level "..oldLevel.."] |cffFFFF00took: ".. KumaSecondsToDays(TimeLevel))
	
	cachingPlaytime = true
	RequestTimePlayed()

	KumaDB[oldLevel] = TimeLevel
	
end

function KumaTime:PLAYER_LOGIN()
	if (UnitLevel("player") < 60) then
		Kuma_PlayFrame()
	end
end

KumaTime:SetScript("OnEvent", function(self, event, ...)
      return self[event] and self[event](self, ...)
end)


function KumaSecondsToDays(inputSeconds)
   fullTime = ""
   
   fDays = math.floor(inputSeconds/86400)
   fHours = math.floor((bit.mod(inputSeconds,86400))/3600)
   fMinutes = math.floor(bit.mod((bit.mod(inputSeconds,86400)),3600)/60)
   fSeconds = math.floor(bit.mod(bit.mod((bit.mod(inputSeconds,86400)),3600),60)) 
   
   fullTime = strjoin("",fullTime,KumaTimeCalc(fDays, "day", fullTime))   
   fullTime = strjoin("",fullTime,KumaTimeCalc(fHours, "hour", fullTime))   
   fullTime = strjoin("",fullTime,KumaTimeCalc(fMinutes, "minute", fullTime))   
   fullTime = strjoin("",fullTime,KumaTimeCalc(fSeconds, "second", fullTime))   
   
   return fullTime   
end

function KumaTimeCalc(fUnit, mUnit, fullString)
   calcOut = ""
   
   if fUnit == 0 then 
      return
   end

   if fullString ~= "" then
      calcOut = ", "
   end
   
   if fUnit == 1 then
      calcOut = strjoin("", calcOut,fUnit .." "..mUnit)
   else
      calcOut = strjoin("", calcOut..fUnit.." "..mUnit.."s")
   end
   
   return calcOut
end

function KumaLevels()	
	newKumaDB = {}
	for level,time in pairs(KumaDB) do
		local int = string.match(level , "%d+")

		newKumaDB[tonumber(int)] = time
	end
	
	KumaDB = newKumaDB
	
	local playerName = UnitName("player")	
	local realmName = GetRealmName()
	
	local kumaKeys = {}
	-- populate the table that holds the keys
	for key in pairs(KumaDB) do 
		table.insert(kumaKeys, key)
	end
	-- sort the keys
	table.sort(kumaKeys)
	-- use the keys to retrieve the values in the sorted order
	for _, key in ipairs(kumaKeys) do 
		print(playerName.." ("..realmName..") Level "..key..": "..KumaSecondsToDays(KumaDB[key]))
	end
end

SLASH_TIME1 = "/kumatime"
SlashCmdList["TIME"] = Kuma_PlayFrame

SLASH_LEVELS1 = "/kumalevels"
SlashCmdList["LEVELS"] = KumaLevels
