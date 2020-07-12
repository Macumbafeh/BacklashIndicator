function LockNotes_OnLoad()
this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
FelArmorActive = true;
DemonArmorActive = true;
DemonicSacActive = true;
MySpellReflected = false;
MySpellGrounded = false;
end

function LockNotes_OnEvent(event)
------------------------------------------------------------- Friendly Buffs -------------------------------------------------------------
if (arg2 == "SPELL_CAST_SUCCESS") then
	if bit.band(arg8, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if (arg10 == "Blessing of Protection") or (arg10 == "Blessing of Freedom") then
			SpellName = arg10
			ZoneTextString:SetText(""..SpellName.." up.");
			ZoneTextFrame.startTime = GetTime()
			ZoneTextFrame.fadeInTime = 0
			ZoneTextFrame.holdTime = 1
			ZoneTextFrame.fadeOutTime = 2
			ZoneTextString:SetTextColor(0, 1, 0); -- green
			PVPInfoTextString:SetText("");
			ZoneTextFrame:Show()
			PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\cling.wav");
		end
	end
end

if (arg2 == "SPELL_AURA_APPLIED") then
	if bit.band(arg8, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if (arg10 == "Shadow Trance") or (arg10 == "Backlash") then
			ZoneTextString:SetText("Shadow Bolt!");
			ZoneTextFrame.startTime = GetTime()
			ZoneTextFrame.fadeInTime = 0
			ZoneTextFrame.holdTime = 1
			ZoneTextFrame.fadeOutTime = 2
			if (arg10 == "Shadow Trance") then
				ZoneTextString:SetTextColor(1, 0, 1); -- purple
			end
			if (arg10 == "Backlash") then
				ZoneTextString:SetTextColor(1, 0.5, 0); -- orange
			end
			PVPInfoTextString:SetText("");
			ZoneTextFrame:Show()
			PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\ding.wav");
		end
	end
end

if (arg2 == "SPELL_AURA_APPLIED") then
	if bit.band(arg8, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if (arg10 == "Focus") or (arg10 == "Spell Haste") then -- need to confirm what Spell haste is, new meta proc name?  also check on new exalted necklaces from SSO
			ZoneTextString:SetText("Fast cast!");
			ZoneTextFrame.startTime = GetTime()
			ZoneTextFrame.fadeInTime = 0
			ZoneTextFrame.holdTime = 1
			ZoneTextFrame.fadeOutTime = 2
			ZoneTextString:SetTextColor(0, 1, 0); -- green
			PVPInfoTextString:SetText("");
			ZoneTextFrame:Show()
			PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\bell.wav");
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------- Hostile Spells -------------------------------------------------------------
if (arg2 == "SPELL_CAST_SUCCESS") then
	if bit.band(arg5, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
		if (arg10 == "Cloak of Shadows") or (arg10 == "Divine Shield") or (arg10 == "Shadow Reflector") or (arg10 == "Fire Reflector") or (arg10 == "Ice Block") or (arg10 == "Spell Reflection") or (arg10 == "Grounding Totem") then
			SpellName = arg10
			ZoneTextString:SetText(""..SpellName.." up!");
			ZoneTextFrame.startTime = GetTime()
			ZoneTextFrame.fadeInTime = 0
			ZoneTextFrame.holdTime = 1
			ZoneTextFrame.fadeOutTime = 2
			ZoneTextString:SetTextColor(1, 0, 0); -- red
			PVPInfoTextString:SetText("");
			ZoneTextFrame:Show()
			PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\pulse.wav");
			if (arg10 == "Spell Reflection") then
				MySpellReflected = false;
			end
			if (arg10 == "Grounding Totem") then
				MySpellGrounded = false;
			end
		end
	end
end

if (arg2 == "SPELL_AURA_APPLIED") then
	if bit.band(arg8, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
		if (arg10 == "Nether Protection") then
			SpellName = arg10
			ZoneTextString:SetText(""..SpellName.." up!");
			ZoneTextFrame.startTime = GetTime()
			ZoneTextFrame.fadeInTime = 0
			ZoneTextFrame.holdTime = 1
			ZoneTextFrame.fadeOutTime = 2
			ZoneTextString:SetTextColor(1, 0, 0); -- red
			PVPInfoTextString:SetText("");
			ZoneTextFrame:Show()
			PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\pulse.wav");
		end
	end
end

if (arg2 == "SPELL_AURA_REMOVED") then
	if bit.band(arg8, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
		if (arg10 == "Cloak of Shadows") or (arg10 == "Divine Shield") or (arg10 == "Shadow Reflector") or (arg10 == "Fire Reflector") or (arg10 == "Nether Protection") or (arg10 == "Ice Block") then
			SpellName = arg10
			ZoneTextString:SetText(""..SpellName.." down.");
			ZoneTextFrame.startTime = GetTime()
			ZoneTextFrame.fadeInTime = 0
			ZoneTextFrame.holdTime = 1
			ZoneTextFrame.fadeOutTime = 2
			ZoneTextString:SetTextColor(0, 1, 0); -- green
			PVPInfoTextString:SetText("");
			ZoneTextFrame:Show()
		end
	end
end

if (arg2 == "SPELL_AURA_REMOVED") then -- will not show spell reflect down if your spell was reflected, since it would show instantly after your spell and you wouldnt see which was reflected, seeing reflect implies that its down
	if bit.band(arg8, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
		if (arg10 == "Spell Reflection") then
			if (not MySpellReflected) then
				SpellName = arg10
				ZoneTextString:SetText(""..SpellName.." down.");
				ZoneTextFrame.startTime = GetTime()
				ZoneTextFrame.fadeInTime = 0
				ZoneTextFrame.holdTime = 1
				ZoneTextFrame.fadeOutTime = 2
				ZoneTextString:SetTextColor(0, 1, 0); -- green
				PVPInfoTextString:SetText("");
				ZoneTextFrame:Show()
			end
		end
	end
end

if (arg2 == "SPELL_MISSED") then
	if (arg7 == "Grounding Totem") then
		if bit.band(arg5, COMBATLOG_OBJECT_AFFILIATION_MINE) == 0 then -- make sure its NOT my spell thats being absorbed by the totem, since it will say spell absorbed already if its mine(is this proper syntax?)
			if bit.band(arg5, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 then -- make sure its a friendly person whose spell is being absorbed
				if (not MySpellGrounded) then -- can say your spell reflected then say totem down from a friendly teammates spell being reflected right after, this removes that possibility
					ZoneTextString:SetText("Grounding Totem down.");
					ZoneTextFrame.startTime = GetTime()
					ZoneTextFrame.fadeInTime = 0
					ZoneTextFrame.holdTime = 1
					ZoneTextFrame.fadeOutTime = 2
					ZoneTextString:SetTextColor(0, 1, 0); -- green
					PVPInfoTextString:SetText("");
					ZoneTextFrame:Show()
				end
			end
		end
	end
end

if (arg2 == "SWING_DAMAGE") or (arg2 == "SPELL_DAMAGE") or (arg2 == "RANGE_DAMAGE") or (arg2 == "PARTY_KILL") or (arg2 == "UNIT_DIED") then
	if (arg7 == "Grounding Totem") then
		if bit.band(arg8, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 then
			if (not MySpellGrounded) then
				ZoneTextString:SetText("Grounding Totem down.");
				ZoneTextFrame.startTime = GetTime()
				ZoneTextFrame.fadeInTime = 0
				ZoneTextFrame.holdTime = 1
				ZoneTextFrame.fadeOutTime = 2
				ZoneTextString:SetTextColor(0, 1, 0); -- green
				PVPInfoTextString:SetText("");
				ZoneTextFrame:Show()
			end
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------- Other ----------------------------------------------------------------------
if (arg2 == "SPELL_AURA_DISPELLED") or (arg2 == "SPELL_AURA_STOLEN") then
	if bit.band(arg8, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if (arg13 == "Fel Armor") or (arg13 == "Demon Armor") then
			SpellName = arg13
			ZoneTextString:SetText(""..SpellName.." down.");
			ZoneTextFrame.startTime = GetTime()
			ZoneTextFrame.fadeInTime = 0
			ZoneTextFrame.holdTime = 1
			ZoneTextFrame.fadeOutTime = 2
			ZoneTextString:SetTextColor(1, 0, 0); -- red
			PVPInfoTextString:SetText("");
			ZoneTextFrame:Show()
			PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\buzz.wav");
			FelArmorActive = false;
			DemonArmorActive = false;
		end
	end
end

if (arg2 == "SPELL_AURA_REMOVED") then
	if bit.band(arg8, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if (arg10 == "Fel Armor") then
			if (FelArmorActive) then -- makes sure buff is still active as to not spam twice when dispelled, since it shows both dispelled and removed events, but the removed event .5sec slower
				SpellName = arg10
				ZoneTextString:SetText(""..SpellName.." down.");
				ZoneTextFrame.startTime = GetTime()
				ZoneTextFrame.fadeInTime = 0
				ZoneTextFrame.holdTime = 1
				ZoneTextFrame.fadeOutTime = 2
				ZoneTextString:SetTextColor(1, 0, 0); -- red
				PVPInfoTextString:SetText("");
				ZoneTextFrame:Show()
				PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\buzz.wav");
				FelArmorActive = false;
			end
		elseif (arg10 == "Demon Armor") or (arg10 == "Demon Skin") then
			if (DemonArmorActive) then
				SpellName = arg10
				ZoneTextString:SetText(""..SpellName.." down.");
				ZoneTextFrame.startTime = GetTime()
				ZoneTextFrame.fadeInTime = 0
				ZoneTextFrame.holdTime = 1
				ZoneTextFrame.fadeOutTime = 2
				ZoneTextString:SetTextColor(1, 0, 0); -- red
				PVPInfoTextString:SetText("");
				ZoneTextFrame:Show()
				PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\buzz.wav");
				DemonArmorActive = false;
			end
		elseif (arg10 == "Touch of Shadow") or (arg10 == "Burning Wish") or (arg10 == "Fel Stamina") or (arg10 == "Fel Energy") then
			if (DemonicSacActive) then
				ZoneTextString:SetText("Demonic Sacrifice down.");
				ZoneTextFrame.startTime = GetTime()
				ZoneTextFrame.fadeInTime = 0
				ZoneTextFrame.holdTime = 1
				ZoneTextFrame.fadeOutTime = 2
				ZoneTextString:SetTextColor(1, 0, 0); -- red
				PVPInfoTextString:SetText("");
				ZoneTextFrame:Show()
				PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\buzz.wav");
				DemonicSacActive = false;
			end
		end
	end
end

if (arg2 == "SPELL_CAST_SUCCESS") then
	if bit.band(arg5, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if (arg10 == "Fel Armor") then
			FelArmorActive = true;
			DemonArmorActive = false;
		elseif (arg10 == "Demon Armor") or (arg10 == "Demon Skin") then
			DemonArmorActive = true;
			FelArmorActive = false;
		elseif (arg10 == "Demonic Sacrifice") then
			DemonicSacActive = true;
		end
	end
end

if (arg2 == "SPELL_SUMMON") then
	if bit.band(arg5, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		DemonicSacActive = false;
	end
end
------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------- Resists --------------------------------------------------------------------
if (arg2 == "SPELL_MISSED") then -- need to add: evade, deflect (what is this?), check what happens when debuff is on an evading mob, dont want spam for each dot tick, even tho most evades remove all debuffs on them, not all
	if bit.band(arg5, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then -- Makes sure it's my own spell or my pet's spell
		if (arg10 == "Death Coil") or (arg10 == "Drain Mana") or (arg10 == "Drain Life") or (arg10 == "Corruption") or (arg10 == "Curse of Agony") or (arg10 == "Curse of Tongues") or (arg10 == "Fear") or (arg10 == "Immolate") or (arg10 == "Curse of Weakness") or (arg10 == "Siphon Life") or (arg10 == "Unstable Affliction") or (arg10 == "Curse of Exhaustion") or (arg10 == "Curse of Shadow") or (arg10 == "Curse of the Elements") or (arg10 == "Banish") or (arg10 == "Spell Lock") or (arg10 == "Seduction") or (arg10 == "Intercept") or (arg10 == "Intercept Stun") then
			SpellName = arg10
			if (arg12 == "ABSORB") then
				return;
			elseif (arg10 == "Intercept") or (arg10 == "Intercept Stun") then
				ResistMethod = "missed"
				SpellName = "Intercept"
			elseif (arg7 == "Grounding Totem") then
				ResistMethod = "grounded"
				MySpellGrounded = true;
			elseif (arg12 == "REFLECT") then -- possibly display like "Corruption reflected.  (Spell Reflect down.)" only if certain arg matches spell reflect (and not shadow reflector)
				ResistMethod = "reflected"
				MySpellReflected = true;
			elseif (arg12 == "IMMUNE") then
				ResistMethod = "immune"
			else
				ResistMethod = "resisted"
			end
			ZoneTextString:SetText(""..SpellName.." "..ResistMethod..".");
			ZoneTextFrame.startTime = GetTime()
			ZoneTextFrame.fadeInTime = 0
			ZoneTextFrame.holdTime = 1
			ZoneTextFrame.fadeOutTime = 2
			if (ResistMethod == "immune") then -- white text = spells you need to recast, red text just shows failed txt
				ZoneTextString:SetTextColor(1, 0, 0); -- red
			else
				ZoneTextString:SetTextColor(1, 1, 1); -- white
			end
			PVPInfoTextString:SetText("");
			ZoneTextFrame:Show()
			if (ResistMethod ~= "immune") then -- only play sound file when you need to instantly recast what you just casted
				PlaySoundFile("Interface\\AddOns\\LockNotes\\Sounds\\thud.wav");
			end
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------- Pet Stuff --------------------------------------------------------------------
if (arg2 == "SPELL_DISPEL") then
	if bit.band(arg5, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if (arg10 == "Devour Magic") then
			SpellName = arg13
			if bit.band(arg8, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0 then -- dispelling buff off friendly target
				UIErrorsFrame:AddMessage("["..SpellName.."]", 1, 1, 1); -- white
			else
				UIErrorsFrame:AddMessage("["..SpellName.."]", 1, 1, 0); -- yellow
			end
		end
	end
end


if (arg2 == "SPELL_INTERRUPT") then
	SpellName = arg13
	if (arg14 == 2) then
		SpellSchool = "holy"
	elseif (arg14 == 4) then
		SpellSchool = "fire"
	elseif (arg14 == 8) then
		SpellSchool = "nature"
	elseif (arg14 == 16) then
		SpellSchool = "frost"
	elseif (arg14 == 32) then
		SpellSchool = "shadow"
	elseif (arg14 == 64) then
		SpellSchool = "arcane"
	end
	if bit.band(arg5, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		UIErrorsFrame:AddMessage("Interrupted *"..SpellSchool.."* spells.", 0, 1, 0); -- green, could also make this white or yellow like dispell
	elseif bit.band(arg8, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		UIErrorsFrame:AddMessage(""..SpellSchool.." school interrupted!", 1, 0, 0); -- red
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------
end


function LockNotes_ErrorsFrame_AddMessage(self, msg, ...) 
  if (msg == "Spell is not ready yet.") or (string.find(msg,"Can't attack")) or (string.find(msg,"Can't do")) or (string.find(msg,"can't do")) or (msg == "You are unable to move") or (msg == "You must equip that item to use it.") or (msg == "Interrupted") or (msg == "Your target is dead") or (msg == "Invalid target") or (msg == "Target not in line of sight") or (msg == "You are dead") or (msg == "You can't do that when you're dead.") or (msg == "You have no target.") or (msg == "There is nothing to attack.") or (msg == "Another action is in progress") or (msg == "You can't do that yet") or (msg == "You are stunned") or (msg == "Another action is in progress.") or (msg == "Item is not ready yet.") or (msg == "Ability is not ready yet.") or (msg == "You are facing the wrong way!") or (msg == "Out of range.") or (msg == "Target needs to be in front of you.") or (msg == "You cannot attack that target.") or (msg == "You are too far away!") then 
    return; 
  end 
  return self:LockNotes_Orig_AddMessage(msg, ...); 
end 
 
function LockNotes_HookErrorsFrame() 
   local ef = getglobal("UIErrorsFrame"); 
   ef.LockNotes_Orig_AddMessage = ef.AddMessage; 
   ef.AddMessage = LockNotes_ErrorsFrame_AddMessage; 
end