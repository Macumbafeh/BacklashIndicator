if select(2, UnitClass("player")) ~= "WARLOCK" then
	return
end

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
NightfallTexture:SetAllPoints()
Nightfallexture:SetWidth(36)
NightfallTexture:SetHeight(36)
NightfallTexture:SetTexCoord(0.06, 0.94, 0.06, 0.94)
NightfallTexture:Hide()

local NightfallFont = NightfallFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
NightfallFont:SetPoint("CENTER", NightfallFrame, -1, -30)
NightfallFont:SetFont("Fonts\\FRIZQT__.TTF", 18)
NightfallFont:SetJustifyH("CENTER")
Nightfallont:SetTextColor(1, 0, 0)
NightfallFont:SetText("")

NightfallFrame:SetMovable(true)
NightfallFrame:EnableMouse(true)
NightfallFrame:RegisterForDrag("LeftButton")
NightfallFrame:SetScript("OnDragStart", function() NightfallFrame:StartMoving() end)
NightfallFrame:SetScript("OnDragStop", function() NightfallFrame:StopMovingOrSizing() end)

SLASH_NIGHTFALL1, SLASH_NIGHTFALL2 = "/Nightfall", "/nf"
SlashCmdList["NIGHTFALL"] = function(msg)
	if msg == "reset" then
		NightfallFrame:SetPoint("CENTER")
		NightfallBackground:Show()
		NightfallFrame:SetScript("OnDragStart", function() NightfallFrame:StartMoving() end)
		NightfallFrame:SetScript("OnDragStop", function() NightfallFrame:StopMovingOrSizing() end)
		savedNightfallSettings[1] = 0
		savedNightfallSettings[2] = 0
	elseif msg == "hide" then
		NightfallBackground:Hide()
		savedNightfallSettings[1] = 1
	elseif msg == "show" then
		NightfallBackground:Show()
		savedNightfallSettings[1] = 0
	elseif msg == "lock" then
		NightfallFrame:SetScript("OnDragStart", nil)
		NightfallFrame:SetScript("OnDragStop", nil)
		savedBacklashSettings[2] = 1
	elseif msg == "unlock" then
		NightfallFrame:SetScript("OnDragStart", function() NightfallFrame:StartMoving() end)
		NightfallFrame:SetScript("OnDragStop", function() NightfallFrame:StopMovingOrSizing() end)
		savedNightfallSettings[2] = 0
	else
		DEFAULT_CHAT_FRAME:AddMessage("Available arguments are:\n reset - resets its position and settings\n hide - hides the background\n show - displays the background\n lock - locks its position\n unlock - unlocks its position")
	end
end

local SavedSettingsFrame = CreateFrame("Frame")
SavedSettingsFrame:RegisterEvent("ADDON_LOADED")
SavedSettingsFrame:RegisterEvent("PLAYER_LOGIN")
SavedSettingsFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if (event == "ADDON_LOADED" and arg1 == "NightfallIndicator") or event == "PLAYER_LOGIN" then
		SavedSettingsFrame:UnregisterEvent("ADDON_LOADED")
		SavedSettingsFrame:UnregisterEvent("PLAYER_LOGIN")
		if not savedNightfallSettings then
			savedNightfallSettings = {}
			savedNightfallSettings[1] = 0
			savedNightfallSettings[2] = 0
		else
			if savedNightfallSettings[1] == 1 then
				NightfallBackground:Hide()
			end
			if savedNightfallSettings[2] == 1 then
				NightfallFrame:SetScript("OnDragStart", nil)
				NightfallFrame:SetScript("OnDragStop", nil)
			end
		end
	end
end)

local NightfallUpdateFrame = CreateFrame("Frame")
NightfallUpdateFrame:SetScript("OnUpdate", function(self, event, arg1)
	local NightfallCheck = 0
	for i=1,40 do
		if select(1, UnitBuff("player", i)) ~= nil then
			local spellName, _, _, _, _, spellDur = UnitBuff("player", i)
			if spellName == "Nightfall" then
				NightfallTexture:Show()
				NightfallFont:SetText(spellDur - spellDur % 0.1)
				NightfallCheck = 1
			end
                        if spellName == "Crépuscule" then
				NightfallTexture:Show()
				NightfallFont:SetText(spellDur - spellDur % 0.1)
				NightfallCheck = 1
			end
		elseif NightfallCheck == 0 and NightfallTexture:IsShown() then
			NightfallTexture:Hide()
			NightfallFont:SetText("")
			break
		else
			break
		end
	end
end)
