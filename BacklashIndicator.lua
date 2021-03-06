if select(2, UnitClass("player")) ~= "WARLOCK" then
	return
end

local BacklashFrame = CreateFrame("Frame", "BacklashFrame", UIParent)
BacklashFrame:SetPoint("CENTER")
BacklashFrame:SetWidth(36)
BacklashFrame:SetHeight(36)

local BacklashBackground = BacklashFrame:CreateTexture(nil, "BACKGROUND")
BacklashBackground:SetAllPoints()
BacklashBackground:SetTexture(0, 0, 0, 0.3)
BacklashBackground:SetWidth(36)
BacklashBackground:SetHeight(36)

local BacklashTexture = BacklashFrame:CreateTexture(nil)
BacklashTexture:SetTexture("Interface\\Icons\\Spell_Fire_PlayingWithFire")
BacklashTexture:SetPoint("LEFT")
BacklashTexture:SetWidth(36)
BacklashTexture:SetHeight(36)
BacklashTexture:SetTexCoord(0.06, 0.94, 0.06, 0.94)
BacklashTexture:Hide()

local BacklashFont = BacklashFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
BacklashFont:SetPoint("CENTER", BacklashFrame, -1, -30)
BacklashFont:SetFont("Fonts\\FRIZQT__.TTF", 18)
BacklashFont:SetJustifyH("CENTER")
BacklashFont:SetTextColor(1, 0, 0)
BacklashFont:SetText("")

BacklashFrame:SetMovable(true)
BacklashFrame:EnableMouse(true)
BacklashFrame:RegisterForDrag("LeftButton")
BacklashFrame:SetScript("OnDragStart", function() BacklashFrame:StartMoving() end)
BacklashFrame:SetScript("OnDragStop", function() BacklashFrame:StopMovingOrSizing() end)

local NightfallFrame = CreateFrame("Frame", "NightfallFrame", UIParent)
NightfallFrame:SetPoint("CENTER")
NightfallFrame:SetWidth(36)
NightfallFrame:SetHeight(36)

local NightfallBackground = NightfallFrame:CreateTexture(nil, "BACKGROUND")
NightfallBackground:SetAllPoints()
NightfallBackground:SetTexture(0, 0, 0, 0.3)
NightfallBackground:SetWidth(36)
NightfallBackground:SetHeight(36)

local NightfallTexture = NightfallFrame:CreateTexture(nil)
NightfallTexture:SetTexture("Interface\\Icons\\Spell_shadow_twilight")
NightfallTexture:SetPoint("RIGHT")
NightfallTexture:SetWidth(36)
NightfallTexture:SetHeight(36)
NightfallTexture:SetTexCoord(0.06, 0.94, 0.06, 0.94)
NightfallTexture:Hide()

local NightfallFont = NightfallFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
NightfallFont:SetPoint("CENTER", NightfallFrame, -1, -30)
NightfallFont:SetFont("Fonts\\FRIZQT__.TTF", 18)
NightfallFont:SetJustifyH("CENTER")
NightfallFont:SetTextColor(1, 0, 0)
NightfallFont:SetText("")

NightfallFrame:SetMovable(true)
NightfallFrame:EnableMouse(true)
NightfallFrame:RegisterForDrag("LeftButton")
NightfallFrame:SetScript("OnDragStart", function() NightfallFrame:StartMoving() end)
NightfallFrame:SetScript("OnDragStop", function() NightfallFrame:StopMovingOrSizing() end)

SLASH_BACKLASH1, SLASH_BACKLASH2 = "/backlash", "/bli"
SlashCmdList["BACKLASH"] = function(msg)
	if msg == "reset" then
		BacklashFrame:SetPoint("CENTER")
		BacklashBackground:Show()
		BacklashFrame:SetScript("OnDragStart", function() BacklashFrame:StartMoving() end)
		BacklashFrame:SetScript("OnDragStop", function() BacklashFrame:StopMovingOrSizing() end)
		NightfallFrame:SetPoint("CENTER")
		NightfallBackground:Show()
		NightfallFrame:SetScript("OnDragStart", function() NightfallFrame:StartMoving() end)
		NightfallFrame:SetScript("OnDragStop", function() NightfallFrame:StopMovingOrSizing() end)
		savedBacklashSettings[1] = 0
		savedBacklashSettings[2] = 0
	elseif msg == "hide" then
		BacklashBackground:Hide()
		NightfallBackground:Hide()
		savedBacklashSettings[1] = 1
	elseif msg == "show" then
		BacklashBackground:Show()
		NightfallBackground:Show()
		savedBacklashSettings[1] = 0
	elseif msg == "lock" then
		BacklashFrame:SetScript("OnDragStart", nil)
		BacklashFrame:SetScript("OnDragStop", nil)
		NightfallFrame:SetScript("OnDragStart", nil)
		NightfallFrame:SetScript("OnDragStop", nil)
		savedBacklashSettings[2] = 1
	elseif msg == "unlock" then
		BacklashFrame:SetScript("OnDragStart", function() BacklashFrame:StartMoving() end)
		BacklashFrame:SetScript("OnDragStop", function() BacklashFrame:StopMovingOrSizing() end)
		NightfallFrame:SetScript("OnDragStart", function() NightfallFrame:StartMoving() end)
		NightfallFrame:SetScript("OnDragStop", function() NightfallFrame:StopMovingOrSizing() end)
		savedBacklashSettings[2] = 0
	else
		DEFAULT_CHAT_FRAME:AddMessage("Available arguments are:\n reset - resets its position and settings\n hide - hides the background\n show - displays the background\n lock - locks its position\n unlock - unlocks its position")
	end
end


local SavedSettingsFrame = CreateFrame("Frame")
SavedSettingsFrame:RegisterEvent("ADDON_LOADED")
SavedSettingsFrame:RegisterEvent("PLAYER_LOGIN")
SavedSettingsFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if (event == "ADDON_LOADED" and arg1 == "BacklashIndicator") or event == "PLAYER_LOGIN" then
		SavedSettingsFrame:UnregisterEvent("ADDON_LOADED")
		SavedSettingsFrame:UnregisterEvent("PLAYER_LOGIN")
		if not savedBacklashSettings then
			savedBacklashSettings = {}
			savedBacklashSettings[1] = 0
			savedBacklashSettings[2] = 0
		else
			if savedBacklashSettings[1] == 1 then
				BacklashBackground:Hide()
				NightfallBackground:Hide()
			end
			if savedBacklashSettings[2] == 1 then
				BacklashFrame:SetScript("OnDragStart", nil)
				BacklashFrame:SetScript("OnDragStop", nil)
				NightfallFrame:SetScript("OnDragStart", nil)
				NightfallFrame:SetScript("OnDragStop", nil)
			end
		end
	end
end)

local BacklashUpdateFrame = CreateFrame("Frame")
BacklashUpdateFrame:SetScript("OnUpdate", function(self, event, arg1)
	local backlashCheck = 0
	for i=1,40 do
		if select(1, UnitBuff("player", i)) ~= nil then
			local spellName, _, _, _, _, spellDur = UnitBuff("player", i)
            if spellName == GetSpellInfo(34939) then 
			    BacklashTexture:Show()
                BacklashFont:SetText(spellDur - spellDur % 0.1)
                backlashCheck = 1
            end
			if spellName == GetSpellInfo(34938) then
                BacklashTexture:Show()
                BacklashFont:SetText(spellDur - spellDur % 0.1)
                backlashCheck = 1
            end
			if spellName == GetSpellInfo(34935) then
                BacklashTexture:Show()
                BacklashFont:SetText(spellDur - spellDur % 0.1)
                backlashCheck = 1
            end
			if spellName == GetSpellInfo(34936) then
                BacklashTexture:Show()
                BacklashFont:SetText(spellDur - spellDur % 0.1)
                backlashCheck = 1
            end
		elseif backlashCheck == 0 and BacklashTexture:IsShown() then
			BacklashTexture:Hide()
			BacklashFont:SetText("")
			break
		else
			break
		end
	end
end)

local NightfallUpdateFrame = CreateFrame("Frame")
NightfallUpdateFrame:SetScript("OnUpdate", function(self, event, arg1)
	local nightfallCheck = 0
	for i=1,40 do
		if select(1, UnitBuff("player", i)) ~= nil then
			local spellName, _, _, _, _, spellDur = UnitBuff("player", i)
            if spellName == GetSpellInfo(17941) then 
			    NightfallTexture:Show()
                NightfallFont:SetText(spellDur - spellDur % 0.1)
                nightfallCheck = 1
            end
			if spellName == GetSpellInfo(18095) then 
			    NightfallTexture:Show()
                NightfallFont:SetText(spellDur - spellDur % 0.1)
                nightfallCheck = 1
            end
		elseif nightfallCheck == 0 and NightfallTexture:IsShown() then
			NightfallTexture:Hide()
			NightfallFont:SetText("")
			break
		else
			break
		end
	end
end)
