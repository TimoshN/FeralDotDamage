local AddOn, ns = ...
local L = AleaUI_GUI.GetLocale("FeralDotDamage")

local COOLDOWN_TAG 		= "COOLDOWN"
local AURA_TAG 			= "AURA"
local COOLDOWN_AURA_TAG = "COOLDOWN_AURA"

local options

local initialDBUpdate = 5

local GetSpellCooldownCharges
local perSpellMethids

local cooldownsParent = CreateFrame("Frame", AddOn.."cooldownsParent", UIParent)
cooldownsParent:SetScale(1)
cooldownsParent:SetSize(1,1)
cooldownsParent:SetPoint("TOP", ns.movingFrame, "BOTTOM", 0, 0)
cooldownsParent:Hide()

ns.cooldownsParent = cooldownsParent

-- 145152 

ns.berserk_spid = 106951
ns.berserk_name = GetSpellInfo(ns.berserk_spid)

ns.skullbuch_spid = 106839
ns.skillbuch_name = GetSpellInfo(ns.skullbuch_spid)

ns.dash_spid = 1850
ns.dash_name = GetSpellInfo(ns.dash_spid)

ns.survival_spid = 61336
ns.survival_name = GetSpellInfo(ns.survival_spid)

ns.predator_spid = 69369
ns.predator_name = GetSpellInfo(ns.predator_spid)

ns.trollberserk_spid = 26297
ns.trollberserk_name = GetSpellInfo(ns.trollberserk_spid)

--ns.silaprirodi_spid = 102703
--ns.silaprirodi_name = GetSpellInfo(ns.silaprirodi_spid)

--ns.serdcedikoy_spid = 108292
--ns.serdcedikoy_name = GetSpellInfo(ns.serdcedikoy_spid)

ns.prirodnaya_spid = 124974
ns.prirodnaya_name = GetSpellInfo(ns.prirodnaya_spid)

ns.sremit_rivok_spid = 102401
ns.sremit_rivok_name = GetSpellInfo(ns.sremit_rivok_spid)

ns.astralskachek_spid = 102280
ns.astralskachek_name = GetSpellInfo(ns.astralskachek_spid)

ns.trevogniyrev_spid = 77764
ns.trevogniyrev_name = GetSpellInfo(ns.trevogniyrev_spid)

ns.eluneguid_spid = 202060
ns.eluneguid_name = GetSpellInfo(ns.eluneguid_spid)

ns.ashamane_spid = 210722
ns.ashamane_name = GetSpellInfo(ns.ashamane_spid) 

ns.feralFrenzy_spid = 274837
ns.feralFrenzy_name = GetSpellInfo(ns.feralFrenzy_spid) 

ns.ydarkogtiami_spid = 202028
ns.ydarkogtiami_name = GetSpellInfo(ns.ydarkogtiami_spid)

ns.maim_spid = 22570
ns.maim_name = GetSpellInfo(ns.maim_spid)

local maimLegProcID = 236757

local format = format
local math_fmod = math.fmod
	
local formatList = {
	[1] = function(numb)
		if numb > 60 then
			return format(" %dm ", ceil(numb / 60))
		elseif numb > 3 then
			return format(" %.0f ", numb)
		elseif numb > 0 then
			return format(" %.0f ", numb)
		end
		
		return ''
	end,
	[2] = function(numb)
		if numb > 60 then
			return format(" %dm ", ceil(numb / 60))
		elseif numb > 3 then
			return format(" %.0f ", numb)
		elseif numb > 0 then
			return format(" %.1f ", numb)
		end
		
		return ''
	end,
	[3] = function(numb)
		if numb > 60 then
			return format("%d:%0.2d", numb/60, math_fmod(numb, 60))
		elseif numb > 3 then
			return format(" %.0f ", numb)
		elseif numb > 0 then
			return format(" %.0f ", numb)
		end	
		
		return ''
	end,
	[4] = function(numb)
		if numb > 60 then
			return format("%d:%0.2d", numb/60, math_fmod(numb, 60))
		elseif numb > 3 then
			return format(" %.0f ", numb)
		elseif numb > 0 then
			return format(" %.1f ", numb)
		end
		
		return ''
	end,
}

local function updateGlow(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + ( elapsed * self.dir )
	if self.elapsed > 1 then
		self.dir = -1.7
	elseif self.elapsed <= 0 then
		self.dir = 1.7
	end

	self:SetAlpha(self.elapsed)
end

perSpellMethids = {
	["Predator"] = function(parent, timer)
		if ns.db.profile.cooldowns.specificSpell[ns.predator_spid].predatorIconRed and timer < 2 then
			local c = ns.db.profile.cooldowns.specificSpell[ns.predator_spid].color
			parent.icon:SetVertexColor(c[1], c[2], c[3], c[4])
		else
			parent.icon:SetVertexColor(1, 1, 1, 1)
		end
	end,
	['TF_ShowGlow'] = function(parent)
		if AuraUtil.FindAuraByName((GetSpellInfo(5217)), 'player', "HELPFUL") then --UnitBuff('player', (GetSpellInfo(5217))) then
			local start, duration = GetSpellCooldownCharges(5217)
			if start == 0 and duration == 0 then
				if parent._tfGlow ~= true then
					parent._tfGlow = true
					
					if not parent.glow:GetScript("OnUpdate") then
						parent.glow.elapsed = 0
						parent.glow:SetAlpha(0)
						parent.glow:SetScript("OnUpdate", updateGlow)
					end

					parent.glow:Show()
				end
			else
				if parent._tfGlow ~= false then
					parent._tfGlow = false
					
					parent.glow.elapsed = 0
					parent.glow:Hide()
					parent.glow:SetAlpha(0)
				end
			end
		else
			if parent._tfGlow ~= false then
				parent._tfGlow = false
				
				parent.glow.elapsed = 0
				parent.glow:Hide()
				parent.glow:SetAlpha(0)
			end
		end
	end,
	['Art_Regen'] = function(parent, timer)
	--	perSpellMethids['TF_ShowGlow'](parent)
		
		if ns.db.profile.cooldowns.specificSpell[ns.tigrinoe_spid].artRegen then	
			local name = AuraUtil.FindAuraByName((GetSpellInfo(210583)), 'player', "HELPFUL") -- UnitBuff('player', (GetSpellInfo(210583)))			
			if name then
				local c = ns.db.profile.cooldowns.specificSpell[ns.tigrinoe_spid].color
				parent.icon:SetVertexColor(c[1], c[2], c[3], c[4])
			else
				parent.icon:SetVertexColor(1, 1, 1, 1)
			end
		end
	end,
	["CP_ShowGlow"] = function()
		return ns.db.profile.cooldowns.specificSpell[ns.predator_spid].ShowGlow
	end,
	["CP_ShowPandemia"] = function(parent, timer)
	
		if ns.db.profile.cooldowns.specificSpell[ns.dikiyrev_spid].CP_Pandemia then
			
			if timer < 12.5  then
				if ns.db.profile.cooldowns.specificSpell[ns.dikiyrev_spid].CP_Pandemia_anim then			
					if not parent.glow:GetScript("OnUpdate") then
						parent.glow.elapsed = 0
						parent.glow:SetAlpha(0)
						parent.glow:SetScript("OnUpdate", updateGlow)
					end

					parent.glow:Show()
				else
					if parent.glow:GetScript("OnUpdate") then
						parent.glow:SetScript("OnUpdate", nil)
					end

					parent.glow:Show()
					parent.glow:SetAlpha(1)
				end
			else 
				parent.glow.elapsed = 0
				parent.glow:Hide()
				parent.glow:SetAlpha(0)
			end
		else
			parent.glow:Hide()
		end
	end,
	
	['Maim_LegendaryProc'] = function(parent, start, duration, stacks, status, maxstacks, reset)
		local name = AuraUtil.FindAuraByName((GetSpellInfo(maimLegProcID)), 'player', "HELPFUL") -- UnitBuff('player', (GetSpellInfo(maimLegProcID)))		-- 212875
		
		if name and status == 3 then
			FeralDotDamage.ShowOverlayGlow(parent)
		else
			FeralDotDamage.HideOverlayGlow(parent)
		end
	end,

	['AzeritBerserkTrait'] = function()
		local name = AuraUtil.FindAuraByName((GetSpellInfo(279526)), 'player', "HELPFUL") -- UnitBuff('player', (GetSpellInfo(maimLegProcID)))		-- 212875
		
		if name then
			return true
		else
			return false
		end
	end,
}

local placeholder = {
	[279526] = ns.berserk_spid,
	[108291] = 319454,
}

local spellPriorityList = {}
for i=1, 99 do 
	spellPriorityList[i] = '#'..i
end

local spells_to_show = {
	{ id = ns.berserk_spid, 		cd = 180 ,	default = true,  tip = COOLDOWN_AURA_TAG, onShowGlow = 'AzeritBerserkTrait' },
	{ id = ns.tigrinoe_spid, 		cd = 30 ,	default = true,  tip = COOLDOWN_AURA_TAG, onTimeIcon = 'Art_Regen' },
	{ id = ns.skullbuch_spid,		cd = 15	,	default = false, tip = COOLDOWN_AURA_TAG	},
	{ id = ns.dash_spid,			cd = 180,	default = false, tip = COOLDOWN_AURA_TAG	},
	{ id = ns.survival_spid,		cd = 120,	default = false, tip = COOLDOWN_AURA_TAG	},
	{ id = ns.predator_spid,		cd = 12,	default = true,  tip = AURA_TAG			 , onTimeIcon = "Predator" },
	{ id = ns.trollberserk_spid,	cd = 12,	default = true,  tip = COOLDOWN_AURA_TAG	},
	{ id = ns.krovaviekogti_spid,	cd = 30,	default = true,  tip = AURA_TAG			 , talent = 319439 },
	{ id = ns.sremit_rivok_spid,	cd = 15,	default = false, tip = COOLDOWN_TAG 	 , talent = 102401 },
	{ id = ns.trevogniyrev_spid,	cd = 120,	default = false, tip = COOLDOWN_AURA_TAG},
	{ id = ns.clearcast_id,			cd = 15,	default = false, tip = AURA_TAG, },
	{ id = ns.dikiyrev_spid,		cd = 40,	default = false, tip = AURA_TAG, onTimeIcon = "CP_ShowPandemia", onShowGlow = "CP_ShowGlow", talent = 52610 },
	{ id = ns.feralFrenzy_spid,		cd = 45,	default = true,  tip = COOLDOWN_TAG,	   talent = 274837 },
	{ id = ns.ydarkogtiami_spid, 	cd = 16, 	default = true,  tip = COOLDOWN_TAG,	   talent = ns.ydarkogtiami_spid },
	{ id = ns.maim_spid,			cd = 1,		default = true,  tip = COOLDOWN_TAG,  onUpdate = 'Maim_LegendaryProc', item = 144354 },
	{ id = 319454, 					cd = 5*60,  default = false, tip = COOLDOWN_AURA_TAG, talent = 319454  }
}

local id_to_spell = {}
for i=1, #spells_to_show do
	id_to_spell[spells_to_show[i].id] = i
end

local order_spell = {}
local order_spell_to_id = {}

local frames = {}
local statusbars = {}

function ns:UpdateCooldownsFrames()
	
	if ns.db.profile.cooldowns.isvertical == 2 then
		ns:Mover(cooldownsParent, "CooldownsFrames", 20, 220, "CENTER")
	else
		ns:Mover(cooldownsParent, "CooldownsFrames", 220, 20, "CENTER")
	end
	
	options = ns.db.profile

	local numicons = #order_spell
	local partial_1 = numicons%2  -- если 0 то середина между иконками 1 то середина иконки
	local numIconStep = floor(#order_spell*0.5)
	local width = ns.db.profile.cooldowns.width-(ns.db.profile.cooldowns.gap*(numicons-1))

	local rwidth = width/numicons
	
	if rwidth > ns.db.profile.cooldowns.max_width then
		rwidth = ns.db.profile.cooldowns.max_width 
	end
	
	local iconOffset = 0
	
	if partial_1 == 1 then
		-- Середина иконки			
		iconOffset = ( numIconStep * ( rwidth + ns.db.profile.cooldowns.gap ) ) --+  ( swidth * 0.5 )
	else
		-- Середина отступа				
		iconOffset = ( numIconStep * rwidth ) + (( numIconStep - 1 ) * ns.db.profile.cooldowns.gap) + ( ns.db.profile.cooldowns.gap * 0.5 ) - ( rwidth * 0.5 )
	end
	
	for i=1, #order_spell do
		
		local spellID = order_spell[i]
		
		frames[i] = frames[i] or ns:AddCooldownIcon(order_spell[i], cooldownsParent)
		
		frames[i].spellID2 = nil
		
		if spellID == 106951 and ns.IsTalentKnown(102543) then
			frames[i].spellID2 = 102543
		end
		
		frames[i].spellID = spellID
		frames[i].spellName = GetSpellInfo(spellID)
		
		frames[i].disabled = false
		frames[i]:Show()
		frames[i]:SetWidth(rwidth)
		frames[i]:SetHeight(rwidth)
		frames[i]:ClearAllPoints()
		
		frames[i].icon:SetTexture(GetSpellTexture(spellID))
		
		if ns.db.profile.cooldowns.isvertical == 2 then -- 1 Горизонт 2 - Вертикально			
			if i == 1 then
				if ns.db.profile.cooldowns.anchoring == 1 then
					frames[i]:SetPoint("LEFT", cooldownsParent, "LEFT", 0, iconOffset)
				else
					frames[i]:SetPoint("RIGHT", cooldownsParent, "RIGHT", 0, iconOffset)
				end
			else
				frames[i]:SetPoint("TOP", frames[i-1], "BOTTOM", 0, -ns.db.profile.cooldowns.gap)
			end		
		else		
			if i == 1 then
				if ns.db.profile.cooldowns.anchoring == 1 then
					frames[i]:SetPoint("BOTTOM", cooldownsParent, "BOTTOM", -iconOffset, 0)
				else
					frames[i]:SetPoint("TOP", cooldownsParent, "TOP", -iconOffset, 0)
				end
			else
				frames[i]:SetPoint("LEFT", frames[i-1], "RIGHT", ns.db.profile.cooldowns.gap, 0)
			end
		end
	end
end

local function GetSpellNameGUI(spellID)
	local name, _, icon = GetSpellInfo(spellID)
	
	return "\124T"..( icon or '' )..":14\124t "..( name or 'InvalidID:'..spellID )
end

function ns:UpdateStatusBarOrder()

	ns:Mover(cooldownsParent, "CooldownsFrames", 220, 20, "CENTER")
	
	options = ns.db.profile
	
	local width = ns.db.profile.cooldowns.width
	
	for i=1, #order_spell do
		
		local spellID = order_spell[i]
		
		statusbars[i] = statusbars[i] or ns:AddStatusBar(order_spell[i], cooldownsParent)
	
		statusbars[i].spellID = spellID
		
		statusbars[i].spellID2 = nil
		
		if spellID == 106951 and ns.IsTalentKnown(102543) then
			statusbars[i].spellID2 = 102543
		end
		
		statusbars[i].spellName = GetSpellInfo(spellID)
		
		statusbars[i].disabled = false
		statusbars[i]:SetWidth(width)
		statusbars[i]:SetHeight(16)
		statusbars[i]:ClearAllPoints()
		
		statusbars[i].icon:SetTexture(GetSpellTexture(spellID))
		statusbars[i].icon:SetSize(16, 16)
	end
	
	ns:PostupdateOrdering()
end

function ns:PostupdateOrdering()

	if ns.db.profile.cooldowns.showmissing then
		for i=1, #order_spell do
			if i == 1 then		
				if ns.db.profile.cooldowns.anchoring == 1 then
					statusbars[i]:SetPoint("BOTTOM", cooldownsParent, "BOTTOM", 0, 0)
				else
					statusbars[i]:SetPoint("TOP", cooldownsParent, "TOP", 0, 0)
				end
			else
				if ns.db.profile.cooldowns.anchoring == 1 then
					statusbars[i]:SetPoint("BOTTOM", statusbars[i-1], "TOP", 0, ns.db.profile.cooldowns.gap)
				else
					statusbars[i]:SetPoint("TOP", statusbars[i-1], "BOTTOM", 0, -ns.db.profile.cooldowns.gap)
				end
			end	
			
			statusbars[i]:Show()
		end
	else
		local prev = nil
		for i=1, #order_spell do
			statusbars[i]:ClearAllPoints()
	
			if statusbars[i].statusbar._status == 1 or statusbars[i].statusbar._status == 2 or statusbars[i].statusbar._status == 3 then
				statusbars[i]:Show()

				if prev == nil then		
					if ns.db.profile.cooldowns.anchoring == 1 then
						statusbars[i]:SetPoint("BOTTOM", cooldownsParent, "BOTTOM", 0, 0)
					else
						statusbars[i]:SetPoint("TOP", cooldownsParent, "TOP", 0, 0)
					end
					
					prev = statusbars[i]
				else
					if ns.db.profile.cooldowns.anchoring == 1 then
						statusbars[i]:SetPoint("BOTTOM", prev, "TOP", 0, ns.db.profile.cooldowns.gap)
					else
						statusbars[i]:SetPoint("TOP", prev, "BOTTOM", 0, -ns.db.profile.cooldowns.gap)
					end
					prev = statusbars[i]
				end
			else
				statusbars[i]:Hide()
			end
		end
	end
end

function ns:AddCooldownIcon(spellid, parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(1, 1)
	local spellName, _, spellIcon = GetSpellInfo(spellid)

	local icon = f:CreateTexture(nil, "BACKGROUND")
	icon:SetAllPoints()
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:SetTexture(spellIcon)
	
	f.icon2 = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.icon2:SetAllPoints()
	f.icon2:SetColorTexture(0, 0, 0, 1)
	
	f.backdrop = CreateFrame("Frame", nil, f, BackdropTemplateMixin and 'BackdropTemplate')
	f.backdrop:SetFrameStrata("LOW")
	
	f.bg = f.backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
	f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -1, 1)
	f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, -1)
	f.bg:SetColorTexture(0,0,0,1)

	local cd = CreateFrame("Cooldown", parent:GetName().."Cooldown", f, "CooldownFrameTemplate")
	cd.parent = f
	cd:SetAllPoints()
	cd:SetReverse(true)
	
	if false then		
		cd:SetSwipeColor(0, 0, 0, 0)
		cd:SetDrawEdge(false)
	else
		cd:SetSwipeColor(0, 0, 0, 0.7)
		cd:SetDrawEdge(false)
	end
		
	cd.noCooldownCount = true
	cd:SetHideCountdownNumbers(true)
	
	cd:SetScript("OnUpdate", function(self, elapsed)
		local numb = ((self.parent._start + self.parent._duration) - GetTime())

		self.parent.timer:SetText(formatList[ns.db.profile.cooldowns.time_format or 1](numb))

		if spells_to_show[id_to_spell[self.parent.spellID]].onTimeIcon then
			perSpellMethids[spells_to_show[id_to_spell[self.parent.spellID]].onTimeIcon](self.parent, numb)
		end
	end)
	
	local textparent = CreateFrame("Frame", nil, parent)
	textparent:SetFrameLevel(cd:GetFrameLevel()+4)
	textparent:SetSize(1,1)
	textparent:Show()
	textparent:SetPoint("CENTER")
	
	local timer = textparent:CreateFontString(nil, "OVERLAY")
	timer:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
	timer:SetPoint("TOPLEFT", cd, "TOPLEFT", -5, 0)
	timer:SetPoint("BOTTOMRIGHT", cd, "BOTTOMRIGHT", 5, 0)
	timer:SetJustifyH("CENTER")
	timer:SetJustifyV("BOTTOM")
	timer:SetText("")
	
	local stack = textparent:CreateFontString(nil, "OVERLAY")
	stack:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
	stack:SetPoint("TOPLEFT", cd, "TOPLEFT", -5, 0)
	stack:SetPoint("BOTTOMRIGHT", cd, "BOTTOMRIGHT", 5, 0)
	stack:SetJustifyH("CENTER")
	stack:SetJustifyV("BOTTOM")
	stack:SetText("")

	f.glow = CreateFrame("Frame", nil, cd, BackdropTemplateMixin and 'BackdropTemplate')
	f.glow:SetFrameLevel(cd:GetFrameLevel()+2)
	f.glow:SetBackdrop({
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeSize = 1,
	})
	f.glow:SetBackdropBorderColor(1, 1, 0, 1)
	f.glow:SetPoint("TOPLEFT", 1, -1)
	f.glow:SetPoint("BOTTOMRIGHT", -1, 1)	
	f.glow.dir = -1.7
	f.glow:Hide()

	f.icon = icon
	f.cooldown = cd
	f.timer = timer
	f.stack = stack
	
	f.SetTimer = function(self, start, duration, stacks, status, maxstacks, reset) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
		self.stack:SetText( ( stacks and stacks > 0 ) and stacks or '')

		self.icon:SetTexture(GetSpellTexture(self.spellID))
		
		if spells_to_show[id_to_spell[self.spellID]].onUpdate then
			perSpellMethids[spells_to_show[id_to_spell[self.spellID]].onUpdate](self, start, duration, stacks, status, maxstacks, reset)
		end
		
		if self._start == start and
			self._duration == duration and
			self._status == status and
			self._stacks == stacks then
			return
		end
		
		self._start = start
		self._duration = duration
		self._status = status
		self._stacks = stacks
	
		if status == 1 then
			self.icon:SetDesaturated(false)
			
			if not self.cooldown:IsShown() then
				self.cooldown:Show()
			end
			self.cooldown:SetSwipeColor(0, 0, 0, ns.db.profile.cooldowns.swipe_alpha or 0.7) --0.7)
			self.cooldown:SetDrawEdge(false)	
			self.cooldown:SetReverse(true)
			self.cooldown:SetCooldown(start, duration)
			
			self.icon:SetVertexColor(1, 1, 1, 1)
			self.icon2:SetColorTexture(0, 0, 0, ns.db.profile.cooldowns.icon_dark)
			
			self:SetAlpha(1)
			
			if ns.db.profile.cooldowns.glowAnim then
				
				if spells_to_show[id_to_spell[self.spellID]].onShowGlow then
					if perSpellMethids[spells_to_show[id_to_spell[self.spellID]].onShowGlow]() then
						FeralDotDamage.ShowOverlayGlow(self.cooldown)
					end
				else
					FeralDotDamage.ShowOverlayGlow(self.cooldown) 
				end
			end
		elseif status == 2 then
			if maxstacks and maxstacks > 0 then
				self.icon:SetDesaturated(stacks == 0 and true or false)
				
				if stacks == 0 then
					self.cooldown:SetSwipeColor(0, 0, 0, ns.db.profile.cooldowns.swipe_alpha or 0.7) --0.7)
					self.cooldown:SetDrawEdge(false)		
				else
					self.cooldown:SetSwipeColor(0, 0, 0, 0)	
					self.cooldown:SetDrawEdge(true)					
				end
				
				if not self.cooldown:IsShown() then
					self.cooldown:Show()
				end
				self.cooldown:SetReverse(false)
				self.cooldown:SetCooldown(start, duration)
			
				self:SetAlpha(1)
				self.icon:SetVertexColor(1, 1, 1, 1)
				self.icon2:SetColorTexture(0, 0, 0, 0)
			else
				self.icon:SetDesaturated(ns.db.profile.cooldowns.blackwhite)
				if not self.cooldown:IsShown() then
					self.cooldown:Show()
				end
				self.cooldown:SetReverse(false)
				self.cooldown:SetCooldown(start, duration)

				self:SetAlpha(ns.db.profile.cooldowns.nonactivealpha)
				self.icon:SetVertexColor(1, 1, 1, 1)
				self.icon2:SetColorTexture(0, 0, 0, ns.db.profile.cooldowns.icon_dark)
			end

			FeralDotDamage.HideOverlayGlow(self.cooldown)
		elseif status == 3 then
			self.icon:SetDesaturated(false)
			self.cooldown:Hide()
			self.cooldown:SetSwipeColor(0, 0, 0, ns.db.profile.cooldowns.swipe_alpha or 0.7) --0.7)
			self.cooldown:SetDrawEdge(false)	
			self.cooldown:SetReverse(true)
			self.cooldown:Clear()
			self.icon:SetVertexColor(1, 1, 1, 1)
			self.icon2:SetColorTexture(0, 0, 0, 0)
			
			self:SetAlpha(1)
			 
			self.timer:SetText('')

			FeralDotDamage.HideOverlayGlow(self.cooldown)
		elseif status == 4 then	
			self.icon:SetDesaturated(ns.db.profile.cooldowns.blackwhite)
			self.cooldown:Hide()
			self.cooldown:SetSwipeColor(0, 0, 0, ns.db.profile.cooldowns.swipe_alpha or 0.7) --0.7)
			self.cooldown:SetDrawEdge(false)	
			self.cooldown:SetReverse(true)
			self.cooldown:Clear()
			
			self:SetAlpha(ns.db.profile.cooldowns.nonactivealpha)
			self.icon:SetVertexColor(1, 1, 1, 1)
			self.icon2:SetColorTexture(0, 0, 0, ns.db.profile.cooldowns.icon_dark)
			
			self.timer:SetText('')
			FeralDotDamage.HideOverlayGlow(self.cooldown)
		end
	end
	
	return f
end

function ns:AddStatusBar(spellid, parent)
	
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(1, 1)

	local icon = f:CreateTexture(nil, "BACKGROUND")
	icon:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	icon:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
	icon:SetSize(20, 20)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	
	icon.backdrop = CreateFrame("Frame", nil, f)
	icon.backdrop:SetFrameStrata("LOW")
	
	icon.bg = icon.backdrop:CreateTexture(nil, "BACKGROUND", nil, -2)
	icon.bg:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	icon.bg:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
	icon.bg:SetColorTexture(0,0,0,1)
	
	local statusbar = CreateFrame("StatusBar", nil, f)
	statusbar.parent = f
	statusbar:SetSize(5, 9)
	statusbar:SetPoint("TOPLEFT", icon, "TOPRIGHT", 0, 0)
	statusbar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
	statusbar:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
	statusbar:SetStatusBarColor(.6, 0, 0, 1)
	statusbar:SetMinMaxValues(0,1)
	statusbar:SetValue(2)
	
	statusbar:GetStatusBarTexture():SetDrawLayer("ARTWORK", 1)
	
	statusbar.backdrop = CreateFrame("Frame", nil, statusbar, BackdropTemplateMixin and 'BackdropTemplate')
	statusbar.backdrop:SetFrameStrata("LOW")
	
	statusbar.bg = statusbar.backdrop:CreateTexture(nil, "BACKGROUND")
	statusbar.bg:SetPoint("TOPLEFT", statusbar, "TOPLEFT", -1, 1)
	statusbar.bg:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", 1, -1)
	statusbar.bg:SetColorTexture(0,0,0,1)
	
	statusbar.background = statusbar:CreateTexture(nil, "ARTWORK")
	statusbar.background:SetPoint("TOPLEFT", statusbar, "TOPLEFT", 0, 0)
	statusbar.background:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", 0, 0)
	statusbar.background:SetColorTexture(0,0,0,1)
	
	statusbar:Show()
	statusbar._start = 0
	statusbar._duration = -2
	statusbar._status = 3
	
	statusbar:SetScript("OnUpdate", function(self, elapsed)
		local numb = 0 
		
		if self._status == 3 or self._status == 4 then
			return
		else
			numb = ( self._start+self._duration - GetTime() )
			self:SetValue(numb)
			
			self.parent.timer:SetText(formatList[ns.db.profile.cooldowns.time_format or 1](numb))
		end

	end)

	local text1 = statusbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	text1:SetPoint("LEFT", statusbar, "LEFT", 2, 0)
	text1:SetJustifyH("LEFT")
	text1:SetJustifyV("CENTER")
	text1:SetText("TEST1")
	text1:SetTextColor(1, 1, 1)
	
	local text2 = statusbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	text2:SetPoint("RIGHT", statusbar, "RIGHT", -2, 0)
	text2:SetJustifyH("RIGHT")
	text2:SetJustifyV("CENTER")
	text2:SetText("TEST2")
	text2:SetTextColor(1, 1, 1)
	
	f.statusbar = statusbar
	f.icon = icon
	f.leftText = text1
	f.rightText = text2
	
	f.SetTimer = function(self, start, duration, stacks, status)  -- status 1 active aura buff status 2 cooldown status 3 active timer
		self.statusbar._start = start
		self.statusbar._duration = duration	
		
		self.icon:SetTexture(GetSpellTexture(self.spellID))
		
		if self.statusbar._status ~= status then
			self.statusbar._status = status
			ns:PostupdateOrdering()
		end
		self.statusbar._status = status
		
		self.leftText:SetText(self.spellName .. ( ( stacks and stacks > 0 ) and " x"..stacks or "" ))
		
		if status == 1 then
			self.statusbar:SetMinMaxValues(0, duration)
			local color = ns.db.profile.cooldowns.colors[1]			
			self.statusbar:SetStatusBarColor(color[1],color[2],color[3],color[4])
		elseif status == 2 then
			self.statusbar:SetMinMaxValues(0, duration)
			local color = ns.db.profile.cooldowns.colors[2]			
			self.statusbar:SetStatusBarColor(color[1],color[2],color[3],color[4])
		elseif status == 3 then
			self.statusbar:SetMinMaxValues(0, 1)
			self.statusbar:SetValue(1)
			self.rightText:SetText('')
			local color = ns.db.profile.cooldowns.colors[3]			
			self.statusbar:SetStatusBarColor(color[1],color[2],color[3],color[4])
		elseif status == 4 then
			self.statusbar:SetMinMaxValues(0, 1)
			self.statusbar:SetValue(1)
			self.rightText:SetText('')
			local color = ns.db.profile.cooldowns.colors[4]			
			self.statusbar:SetStatusBarColor(color[1],color[2],color[3],color[4])
		end
	end
	
	return f
end

local UpdateCooldownSortings_SortFunc = function(x, y)
	if x.on == y.on then
        if x.sort == y.sort then
			return x.name > y.name
        else
			return x.sort < y.sort
        end
    else
        return x.on
    end
      
    return true
end
	
local function ResetCorruptedSettings()
	wipe(ns.db.profile.cooldowns.ordering_spells.spellList)
	for index, data in pairs(spells_to_show) do	
		ns.db.profile.cooldowns.ordering_spells.spellList[data.id] = { sort = index, on = data.default }
	end
end

local function CheckForCorruptedSettigns()	

	if ns.db.profile.cooldowns.ordering_spells.initialReset ~= initialDBUpdate then
		print('FDD: Update cooldown settings cuz of force update')
		ns.db.profile.cooldowns.ordering_spells.initialReset = initialDBUpdate
		ResetCorruptedSettings()
		return
	end
	
	-- for index, data in pairs(spells_to_show) do	
	-- 	if not ns.db.profile.cooldowns.ordering_spells.spellList[data.id] then
	-- 		print('FDD: Update cooldown settings cuz of invalid spell to show', data.id, (GetSpellInfo(data.id)) )
	-- 		ResetCorruptedSettings()
	-- 		return
	-- 	end
	-- end
	
	-- for spellID in pairs(ns.db.profile.cooldowns.ordering_spells.spellList) do
	-- 	if not id_to_spell[ spellID ] then
	-- 		print('FDD: Update cooldown settings cuz of invalid spellid to id', spellID, (GetSpellInfo(spellID)) )
	-- 		ResetCorruptedSettings()
	-- 		return
	-- 	end
	-- end	
end

FDD_ResetCorruptedSettings = ResetCorruptedSettings

local sortedSpellList = {}
function ns:UpdateCooldownSortings()
	CheckForCorruptedSettigns()	
	
	wipe(order_spell)
	
	local framecount = 0
	
	wipe(sortedSpellList)

	for i, data in ipairs(spells_to_show) do 

		if(data.id) then
			sortedSpellList[i] = { 
				spellID=data.id, 
				priority=(ns.db.profile.cooldowns.ordering_spells.spellList[data.id] and ns.db.profile.cooldowns.ordering_spells.spellList[data.id].sort or i) 
			}
		else 
			print('NO ID FOR', i, data.id)
		end

	end 

	table.sort(sortedSpellList, function(a,b)

		if(a.priority == b.priority) then 
			return a.spellID < b.spellID
		end 
		
		return a.priority < b.priority
	end)

	for i, __data in ipairs(sortedSpellList) do
		local spellID = __data.spellID

		local data = ns.db.profile.cooldowns.ordering_spells.spellList[spellID]
	
		if spellID == ns.trollberserk_spid then		
			if select(2, UnitRace("player")) == "Troll" and data.on then
				framecount = framecount + 1			
				order_spell[framecount] = spellID
				order_spell_to_id[spellID] = framecount
			end
		elseif spells_to_show[id_to_spell[spellID]].talent then
			if data.on and ns.IsTalentKnown(spells_to_show[id_to_spell[spellID]].talent) then
				framecount = framecount + 1
				order_spell[framecount] = spellID			
				order_spell_to_id[spellID] = framecount
			end
		elseif spells_to_show[id_to_spell[spellID]].spellKnown then
			if data.on and IsSpellKnown(spells_to_show[id_to_spell[spellID]].spellKnown) then
				framecount = framecount + 1
				order_spell[framecount] = spellID			
				order_spell_to_id[spellID] = framecount
			end
		elseif spells_to_show[id_to_spell[spellID]].item then
			if data.on and ns.IsItemEqupped(spells_to_show[id_to_spell[spellID]].item) then
				framecount = framecount + 1
				order_spell[framecount] = spellID			
				order_spell_to_id[spellID] = framecount
			end
		elseif data.on then
			framecount = framecount + 1
			order_spell[framecount] = spellID		
			order_spell_to_id[spellID] = framecount
		end
	end
	
end

function ns:CooldownFontUpdate()
	
	for i=1, #frames do
		
		local f = frames[i]
		local justifyV, justifyH = strsplit(";", options.cooldowns.fonts.timer.text_point) -- = "BOTTOM;CENTER",
		
		if ns.db.profile.cooldowns.hide_timer_text then
			f.timer:Show()
		else
			f.timer:Hide()
		end
		
		f.cooldown:SetHideCountdownNumbers(ns.db.profile.cooldowns.hide_timer_text)	
		
		f.timer:SetFont(ns.SharedMedia:Fetch("font", options.cooldowns.fonts.font), options.cooldowns.fonts.timer.fontsize, options.cooldowns.fonts.fontflag)
		f.timer:SetJustifyH(justifyH)
		f.timer:SetJustifyV(justifyV)
		f.timer:SetShadowColor(
			options.cooldowns.fonts.timer.shadow_color[1],
			options.cooldowns.fonts.timer.shadow_color[2],
			options.cooldowns.fonts.timer.shadow_color[3],
			options.cooldowns.fonts.timer.shadow_color[4])
			
		f.timer:SetShadowOffset(options.cooldowns.fonts.shadow_pos[1],options.cooldowns.fonts.shadow_pos[2])
		f.timer:SetTextColor(
			options.cooldowns.fonts.timer.color[1],
			options.cooldowns.fonts.timer.color[2],
			options.cooldowns.fonts.timer.color[3],
			1)
		
		
		f.timer:SetPoint("TOPLEFT", f.cooldown, "TOPLEFT", -5+options.cooldowns.fonts.timer.spacing_h, options.cooldowns.fonts.timer.spacing_v)
		f.timer:SetPoint("BOTTOMRIGHT", f.cooldown, "BOTTOMRIGHT", 5+options.cooldowns.fonts.timer.spacing_h, options.cooldowns.fonts.timer.spacing_v)

		
		justifyV, justifyH = strsplit(";", options.cooldowns.fonts.stack.text_point) -- = "BOTTOM;CENTER",
		
		f.stack:SetFont(ns.SharedMedia:Fetch("font", options.cooldowns.fonts.font), options.cooldowns.fonts.stack.fontsize, options.cooldowns.fonts.fontflag)
		f.stack:SetJustifyH(justifyH)
		f.stack:SetJustifyV(justifyV)
		f.stack:SetShadowColor(
			options.cooldowns.fonts.stack.shadow_color[1],
			options.cooldowns.fonts.stack.shadow_color[2],
			options.cooldowns.fonts.stack.shadow_color[3],
			options.cooldowns.fonts.stack.shadow_color[4])
		f.stack:SetShadowOffset(options.cooldowns.fonts.shadow_pos[1],options.cooldowns.fonts.shadow_pos[2])
		f.stack:SetTextColor(options.cooldowns.fonts.stack.color[1],options.cooldowns.fonts.stack.color[2],options.cooldowns.fonts.stack.color[3],1)
		
		f.stack:SetPoint("TOPLEFT", f.cooldown, "TOPLEFT", -5+options.cooldowns.fonts.stack.spacing_h, options.cooldowns.fonts.stack.spacing_v)
		f.stack:SetPoint("BOTTOMRIGHT", f.cooldown, "BOTTOMRIGHT", 5+options.cooldowns.fonts.stack.spacing_h, options.cooldowns.fonts.stack.spacing_v)
	end
	
	for i=1, #statusbars do
		local f = statusbars[i]

		f.leftText:SetFont(ns.SharedMedia:Fetch("font", options.cooldowns.fonts.font), options.cooldowns.fonts.timer.fontsize, options.cooldowns.fonts.fontflag)
		f.leftText:SetShadowColor(options.cooldowns.fonts.timer.shadow_color[1],options.cooldowns.fonts.timer.shadow_color[2],options.cooldowns.fonts.timer.shadow_color[3],options.cooldowns.fonts.timer.shadow_color[4])
		f.leftText:SetShadowOffset(options.cooldowns.fonts.shadow_pos[1],options.cooldowns.fonts.timer.shadow_pos[2])
		f.leftText:SetTextColor(options.cooldowns.fonts.timer.color[1],options.cooldowns.fonts.timer.color[2],options.cooldowns.fonts.timer.color[3],1)
		
		f.rightText:SetFont(ns.SharedMedia:Fetch("font", options.cooldowns.fonts.font), options.cooldowns.fonts.timer.fontsize, options.cooldowns.fonts.fontflag)
		f.rightText:SetShadowColor(options.cooldowns.fonts.timer.shadow_color[1],options.cooldowns.fonts.timer.shadow_color[2],options.cooldowns.fonts.timer.shadow_color[3],options.cooldowns.fonts.timer.shadow_color[4])
		f.rightText:SetShadowOffset(options.cooldowns.fonts.shadow_pos[1],options.cooldowns.fonts.timer.shadow_pos[2])
		f.rightText:SetTextColor(options.cooldowns.fonts.timer.color[1],options.cooldowns.fonts.timer.color[2],options.cooldowns.fonts.timer.color[3],1)
	end
end

function ns:CooldownBorderUpdate()
	for i=1, #frames do
		
		local f = frames[i]
		
		f.backdrop:SetBackdrop({
			edgeFile = ns.SharedMedia:Fetch("border", options.cooldowns.border.texture),
			edgeSize = options.cooldowns.border.size,
		})
		f.backdrop:SetBackdropBorderColor(options.cooldowns.border.color[1], options.cooldowns.border.color[2], options.cooldowns.border.color[3], options.cooldowns.border.color[4])
		f.backdrop:SetPoint("TOPLEFT", -options.cooldowns.border.inset, options.cooldowns.border.inset)
		f.backdrop:SetPoint("BOTTOMRIGHT", options.cooldowns.border.inset, -options.cooldowns.border.inset)
		
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -options.cooldowns.border.bg_inset, options.cooldowns.border.bg_inset)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", options.cooldowns.border.bg_inset, -options.cooldowns.border.bg_inset)
		f.bg:SetColorTexture(options.cooldowns.border.background[1], options.cooldowns.border.background[2], options.cooldowns.border.background[3], options.cooldowns.border.background[4])
	
	end
	
	for i=1, #statusbars do
		local f = statusbars[i].statusbar
		
		f.backdrop:SetBackdrop({
			edgeFile = ns.SharedMedia:Fetch("border", options.cooldowns.border.texture),
			edgeSize = options.cooldowns.border.size,
		})
		f.backdrop:SetBackdropBorderColor(options.cooldowns.border.color[1], options.cooldowns.border.color[2], options.cooldowns.border.color[3], options.cooldowns.border.color[4])
		f.backdrop:SetPoint("TOPLEFT", -options.cooldowns.border.inset, options.cooldowns.border.inset)
		f.backdrop:SetPoint("BOTTOMRIGHT", options.cooldowns.border.inset, -options.cooldowns.border.inset)
		
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -options.cooldowns.border.bg_inset, options.cooldowns.border.bg_inset)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", options.cooldowns.border.bg_inset, -options.cooldowns.border.bg_inset)
		f.bg:SetColorTexture(options.cooldowns.border.background[1], options.cooldowns.border.background[2], options.cooldowns.border.background[3], options.cooldowns.border.background[4])
	
		f:SetStatusBarTexture(ns.SharedMedia:Fetch("statusbar", self.db.profile.cooldowns.bartexture1))
		f.background:SetTexture(ns.SharedMedia:Fetch("statusbar", self.db.profile.cooldowns.bartexturebg))
		f.background:SetVertexColor(options.cooldowns.bg_color[1], options.cooldowns.bg_color[2], options.cooldowns.bg_color[3], options.cooldowns.bg_color[4])
		
		f:SetPoint("TOPLEFT", statusbars[i].icon, "TOPRIGHT", options.cooldowns.icon_spacing, 0)
		
		f = statusbars[i].icon
		
		f.backdrop:SetBackdrop({
			edgeFile = ns.SharedMedia:Fetch("border", options.cooldowns.border.texture),
			edgeSize = options.cooldowns.border.size,
		})
		f.backdrop:SetBackdropBorderColor(options.cooldowns.border.color[1], options.cooldowns.border.color[2], options.cooldowns.border.color[3], options.cooldowns.border.color[4])
		f.backdrop:SetPoint("TOPLEFT", f, "TOPLEFT", -options.cooldowns.border.inset, options.cooldowns.border.inset)
		f.backdrop:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", options.cooldowns.border.inset, -options.cooldowns.border.inset)
		
		f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", -options.cooldowns.border.bg_inset, options.cooldowns.border.bg_inset)
		f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", options.cooldowns.border.bg_inset, -options.cooldowns.border.bg_inset)
		f.bg:SetColorTexture(options.cooldowns.border.background[1], options.cooldowns.border.background[2], options.cooldowns.border.background[3], options.cooldowns.border.background[4])
		
	end
end

function ns:UpdateCooldownOrders()
	options = ns.db.profile
	
	ns:ToggleCooldownBar("Show")
	
	self:UpdateCooldownSortings()
	
		
	for i=1, #frames do
		frames[i].disabled = true
		frames[i]:Hide()
		frames[i].timer:SetText('')
		frames[i].stack:SetText('')
		
	--	print("T", frames[i].timer)
	end
	
	for i=1, #statusbars do
		statusbars[i].disabled = true
		statusbars[i]:Hide()
	end
	
	if ns.db.profile.cooldowns.visual == 1 then self:UpdateCooldownsFrames() end
	if ns.db.profile.cooldowns.visual == 2 then self:UpdateStatusBarOrder() end
	
	self:CooldownFontUpdate()
	self:CooldownBorderUpdate()
end

function ns:ToggleCooldownBar(status)
	
	if not ns.db.profile.cooldowns.enable then
		cooldownsParent:Hide()
		cooldownsParent:UnregisterEvent("UNIT_AURA")
		cooldownsParent:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		return
	end
	
	cooldownsParent:RegisterEvent("UNIT_AURA")
	cooldownsParent:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	
	cooldownsParent:GetScript("OnEvent")(cooldownsParent,"SPELL_UPDATE_COOLDOWN")
	
	if status == "Show" then
		cooldownsParent:Show()
	else
		cooldownsParent:Hide()
	end
end

function GetSpellCooldownCharges(spellID)
	local startTime, duration, enabled = GetSpellCooldown(spellID)
	local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(spellID)
	local charger = false

	if charges and charges ~= maxCharges then
		charger = true
	end

	return ( charger and chargeStart or startTime ), ( charger and chargeDuration or duration ), enabled, charges, maxCharges
end
	
cooldownsParent:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + elapsed
	if self.elapsed < 0.1 then return end
	self.elapsed = 0
	
	ns:RefreshCooldownFrames()	
end)

cooldownsParent:SetScript("OnEvent", function(self, event, unit)
	
	if event == "UNIT_AURA" and unit == "player" then
		ns:RefreshCooldownFrames()	
	elseif event == "SPELL_UPDATE_COOLDOWN" then
		ns:RefreshCooldownFrames()	
	end
end)

local function GetAuras(spellID)
	local i = 1

	while ( true ) do
	
		local name, icon, count, debuffType, duration2, expirationTime, unitCaster, isStealable, _, spellID2 = UnitAura("player", i, "HELPFUL")
	
		
		if not name then
			return false
		end
		
		i = i + 1
		
		if name and ( ( spellID == spellID2 ) or ( placeholder[spellID2] == spellID ) ) then
			return name, count, duration2, expirationTime
		end
	end
end

function ns:RefreshCooldownFrames()
	
	cooldownsParent.elapsed = 0
	
	local _frames = ns.db.profile.cooldowns.visual == 1 and frames or statusbars
	for i=1, #_frames do
		
		local f = _frames[i]
		
		if not f.disabled then
			local spellID = f.spellID
		
			local tip = spells_to_show[id_to_spell[spellID]].tip

			if tip == COOLDOWN_AURA_TAG then
				local start, duration, enable, currentCharges, maxCharges, oldstart = GetSpellCooldownCharges(f.spellID2 or spellID)

				local name, count, duration2, expirationTime = GetAuras(f.spellID2 or spellID)
				
				if spellID == 5217 and start == 0 and duration == 0 then
					f:SetTimer(0, 0, count, 3) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer		
				elseif name then
					f:SetTimer(expirationTime-duration2, duration2, currentCharges, 1) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				elseif duration > 0 and duration ~= ns.GetGCD() then
					f:SetTimer(start, duration, currentCharges, 2, maxCharges) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				else
					f:SetTimer(0, 0, count, 3) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				end
			elseif tip == COOLDOWN_TAG then
				local start, duration, enable, currentCharges, maxCharges, oldstart = GetSpellCooldownCharges(f.spellID2 or spellID)
				
				if duration > 0 and duration ~= ns.GetGCD() then
					f:SetTimer(start, duration, currentCharges, 2, maxCharges) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				else
					f:SetTimer(0, 0, currentCharges, 3, maxCharges) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				end
			elseif tip == AURA_TAG then

				local name, count, duration2, expirationTime = GetAuras(f.spellID2 or spellID)
				
				if name then
					f:SetTimer(expirationTime-duration2, duration2, count, 1) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				else
					f:SetTimer(0, 0, count, 4) -- status 1 active aura buff ; status 2 cooldown ; status 3 active timer
				end
			end
		end
	end
end

function ns:UpdateCooldownStyleOpts(o)
	local o = o or self.GUI.args.cooldowns
	if ns.db.profile.cooldowns.visual == 1 then
		
			
		o.args.isvertical = {
			order = 1.2, name = L["Расположение"],
			type = "dropdown",
			values = { L['Горизонтально'], L['Вертикально'] },
			set = function(self, value)
				ns.db.profile.cooldowns.isvertical = value;
				ns:UpdateCooldownOrders()
			end,
			get = function(self)		
				return ns.db.profile.cooldowns.isvertical
			end	
		}
	
	
		o.args.blackwhite = {
			order = 1.3, name = L["Черно-белая"],
			type = "toggle", 
			set = function(self)
				ns.db.profile.cooldowns.blackwhite = not ns.db.profile.cooldowns.blackwhite;
			end,
			get = function(self)
				return ns.db.profile.cooldowns.blackwhite;
			end
		}
		
		o.args.glowAnim = {
			order = 1.4, name = L["Свечение"],
			type = "toggle", 
			set = function(self)
				ns.db.profile.cooldowns.glowAnim = not ns.db.profile.cooldowns.glowAnim;
			end,
			get = function(self)
				return ns.db.profile.cooldowns.glowAnim;
			end
		}
		
		
		o.args.font.args.timer.args.hide_timer_text = {
			order = 1,name = L["Показать текст таймера"],type = "toggle",
			desc = L["Показать текст таймера"],
			set = function(info,val) self.db.profile.cooldowns.hide_timer_text = not self.db.profile.cooldowns.hide_timer_text; ns:CooldownFontUpdate(); end,
			get = function(info) return self.db.profile.cooldowns.hide_timer_text end
		}
		
		o.args.icon_darkness = {
			order = 2, name = L["Затемнение"],
			type = "slider", min = 0, max = 1, step = 0.1,
			set = function(self, value)
				ns.db.profile.cooldowns.icon_dark = value;
				ns:UpdateCooldownOrders()
			end,
			get = function(self)		
				return ns.db.profile.cooldowns.icon_dark
			end	
		}
		
		o.args.swipe_alpha_test = {
			order = 2.1, name = L["Текстура перезарядки"],
			type = "slider", min = 0, max = 1, step = 0.1,
			set = function(self, value)
				ns.db.profile.cooldowns.swipe_alpha = value;
				ns:UpdateCooldownOrders()
			end,
			get = function(self)		
				return ns.db.profile.cooldowns.swipe_alpha
			end	
		}

		o.args.font.args.stacks ={
			order = 20,name = L["Стаки"],type = "group", embend = true,
			args={
				fontisize_stack = {
					name = L["Размер шрифта"], disabled = false,
					type = "slider",
					order	= 1,
					min		= 1,
					max		= 32,
					step	= 1,
					set = function(info,val) 
						self.db.profile.cooldowns.fonts.stack.fontsize = val
						ns:CooldownFontUpdate()
					end,
					get =function(info)
						return self.db.profile.cooldowns.fonts.stack.fontsize
					end,
				},
				textposition_stack = {	
					type = "dropdown",order = 6,
					name = L["Выравнивание текста"],
					desc = L["Выравнивание текста"],
					values = {
						["TOP;CENTER"] = L["Сверху"],
						["TOP;LEFT"] = L["Слева вверху"],
						["TOP;RIGHT"] = L["Справа вверху"],
						["CENTER;CENTER"] = L["Центр"],
						["BOTTOM;CENTER"] = L["Снизу"],
						["BOTTOM;LEFT"] = L["Слева внизу"],
						["BOTTOM;RIGHT"] = L["Справа внизу"],
						["CENTER;LEFT"] = L["По центру слева"],
						["CENTER;RIGHT"] = L["По центру справа"],
					},
					set = function(info,val) 
						self.db.profile.cooldowns.fonts.stack.text_point = val
						ns:CooldownFontUpdate()
					end,
					get = function(info) return self.db.profile.cooldowns.fonts.stack.text_point end
				},
				color = {
					order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
					set = function(info,r,g,b,a) 
						self.db.profile.cooldowns.fonts.stack.color ={r,g,b,1};
						ns:CooldownFontUpdate()
					end,
					get = function(info) 
						return self.db.profile.cooldowns.fonts.stack.color[1], self.db.profile.cooldowns.fonts.stack.color[2], self.db.profile.cooldowns.fonts.stack.color[3], 1
					end
				},
				font_pos_x = {
					name = L["Смещение по горизонтали"], disabled = false,
					type = "slider",
					order	= 10,
					min		= -50,
					max		= 50,
					step	= 1,
					set = function(info,val) 
						self.db.profile.cooldowns.fonts.stack.spacing_h = val
						ns:CooldownFontUpdate()
					end,
					get =function(info)
						return self.db.profile.cooldowns.fonts.stack.spacing_h
					end,
				},
				font_pos_7 = {
					name = L["Смещение по вертикали"], disabled = false,
					type = "slider",
					order	= 15,
					min		= -50,
					max		= 50,
					step	= 1,
					set = function(info,val) 
						self.db.profile.cooldowns.fonts.stack.spacing_v = val
						ns:CooldownFontUpdate()
					end,
					get =function(info)
						return self.db.profile.cooldowns.fonts.stack.spacing_v
					end,
				},
			},
		}
		
		o.args.nonactivealpha = {
			order = 3.2, name = L["Прозрачность"],
			desc = L["Если заклинание на перезарядке и аура отсутствует"],
			type = "slider", min = 0, max = 1, step = 0.1,
			set = function(self, value)
				ns.db.profile.cooldowns.nonactivealpha = value;
				ns:UpdateCooldownOrders()
			end,
			get = function(self)		
				return ns.db.profile.cooldowns.nonactivealpha
			end	
		}
		
		o.args.max_width = {
			order = 3.3, name = L["Максимальный размер"],
			desc = L["Размер иконки не будет превышать максимального значения при изменении колличества иконок"],
			type = "slider", min = 1, max = 60, step = 1,
			set = function(self, value)
				ns.db.profile.cooldowns.max_width = value;
				ns:UpdateCooldownOrders()
			end,
			get = function(self)		
				return ns.db.profile.cooldowns.max_width
			end	
		}
		
		o.args.showmissing = nil
		o.args.statusbargrp = nil
		o.args.barscolor = nil
		o.args.icon_gap = nil
	else
		o.args.isvertical = nil
		o.args.icon_darkness = nil
		o.args.swipe_alpha_test = nil
		o.args.blackwhite = nil
		o.args.glowAnim = nil
		o.args.font.args.timer.args.hide_timer_text = nil
		o.args.font.args.stacks = nil
		o.args.nonactivealpha = nil
		o.args.max_width = nil
		
		o.args.showmissing = {
			order = 1, name = L["Показать отсутствующие ауры"], desc = L["Только для полос"],
			type = "toggle", 
			set = function(self)
				ns.db.profile.cooldowns.showmissing = not ns.db.profile.cooldowns.showmissing;
				ns:UpdateCooldownOrders()
			end,
			get = function(self)
				return ns.db.profile.cooldowns.showmissing;
			end
		}
	
		o.args.icon_gap = {
			order = 3.1, name = L["Отступ иконки"],
			type = "slider", min = 0, max = 50, step = 1,
			set = function(self, value)
				ns.db.profile.cooldowns.icon_spacing = value;
				ns:UpdateCooldownOrders()
			end,
			get = function(self)		
				return ns.db.profile.cooldowns.icon_spacing
			end	
		}
	
		o.args.statusbargrp ={
			order = 5.1, name = L["Текстуры полосы"],type = "group", embend = true,
			args={
			
			},
		}

		o.args.statusbargrp.args.statusbar1 = {
			order = 1,type = 'statusbar',name = L["Основная текстура"], 
			values = ns.SharedMedia:HashTable("statusbar"),
			set = function(info,value) self.db.profile.cooldowns.bartexture1 = value; ns:UpdateCooldownOrders();end,
			get = function(info) return self.db.profile.cooldowns.bartexture1 end,
		}

		o.args.statusbargrp.args.statusbarbg = {
			order = 2,type = 'statusbar',name = L["Текстура фона"], 
			values = ns.SharedMedia:HashTable("statusbar"),
			set = function(info,value) self.db.profile.cooldowns.bartexturebg = value; ns:UpdateCooldownOrders();end,
			get = function(info) return self.db.profile.cooldowns.bartexturebg end,
		}

		o.args.barscolor ={
			order = 5,name = L["Цвет полосы"],type = "group", embend = true,
			args={
			
			},
		}

		for i=1, 4 do	
			o.args.barscolor.args["color"..i]	= {
				order = i,name = L["statusbar_color"..i], type = "color", hasAlpha = true,
				set = function(info,r,g,b,a) 
					self.db.profile.cooldowns.colors[i]={r,g,b,a};
				end,
				get = function(info) 
					return self.db.profile.cooldowns.colors[i][1],
					self.db.profile.cooldowns.colors[i][2],
					self.db.profile.cooldowns.colors[i][3],
					self.db.profile.cooldowns.colors[i][4]
				end
			}	
		end

		o.args.barscolor.args["background"]	= {
			order = 5,name = L["Фон"], type = "color", hasAlpha = true,
			set = function(info,r,g,b,a) 
				self.db.profile.cooldowns.bg_color={r,g,b,a};
			end,
			get = function(info) 
				return self.db.profile.cooldowns.bg_color[1],
				self.db.profile.cooldowns.bg_color[2],
				self.db.profile.cooldowns.bg_color[3],
				self.db.profile.cooldowns.bg_color[4]
			end
		}
	end
end

function ns:AddCooldownsGUI()
	local o = {
		order = 7,name = L["Перезарядки"],type = "group",
		args={
		
		},
	}
	
	o.args.enable = {
		order = 0.1, name = L["Включить"],
		type = "toggle", 
		set = function(self)
			ns.db.profile.cooldowns.enable = not ns.db.profile.cooldowns.enable;
			ns:UpdateCooldownOrders()
		end,
		get = function(self)
			return ns.db.profile.cooldowns.enable;
		end
	}
	
	o.args.movingme = {
		order = 0.2,name = L["Передвинь меня!"], type = "execute",
		set = function(info,val) ns:UnlockMover("CooldownsFrames"); end,
		get = function(info) return false end
	}
	
	o.args.visual = {
		order = 1.1, name = L["Тип"],
		type = "dropdown",
		values = { L['Иконки'], L['Полоски'] },
		set = function(self, value)
			ns.db.profile.cooldowns.visual = value;
			ns:UpdateCooldownStyleOpts()
			ns:UpdateCooldownOrders()
		end,
		get = function(self)		
			return ns.db.profile.cooldowns.visual
		end	
	}
	
	o.args.width = {
		order = 2, name = L["Ширина"],
		type = "slider", min = 1, max = 1500, step = 1,
		set = function(self, value)
			ns.db.profile.cooldowns.width = value;
			ns:UpdateCooldownOrders()
		end,
		get = function(self)		
			return ns.db.profile.cooldowns.width
		end	
	}
	
	o.args.gap = {
		order = 3, name = L["Отступ"],
		type = "slider", min = 0, max = 50, step = 1,
		set = function(self, value)
			ns.db.profile.cooldowns.gap = value;
			ns:UpdateCooldownOrders()
		end,
		get = function(self)		
			return ns.db.profile.cooldowns.gap
		end	
	}
	o.args.anchoring = {
		order = 3.4, name = L["Точка привязки"],
		type = "dropdown",
		values = function()
			return ( ns.db.profile.cooldowns.isvertical == 2 and { L['Справа'], L['Слева'] } or { L['Снизу'], L['Сверху'] } )
		end,
		set = function(self, value)
			ns.db.profile.cooldowns.anchoring = value;
			ns:UpdateCooldownOrders()
		end,
		get = function(self)		
			return ns.db.profile.cooldowns.anchoring
		end	
	}
	
	o.args.font ={
		order = 8,name = L["Шрифт"],type = "group", embend = true,
		args={
			font = {
				order = 4,name = L["Шрифт"],type = 'font',
				values = ns.SharedMedia:HashTable("font"),
				set = function(info,key) 
					self.db.profile.cooldowns.fonts.font = key
					ns:UpdateCooldownOrders()
				end,
				get = function(info) return self.db.profile.cooldowns.fonts.font end,
			},
			time_format = {
				name = L["Формат времени"],
				type = "dropdown",
				order	= 4.1,
				values = {
					"1 3 10 20 50 2m",
					"0.1 1 1.5 3 2m",
					"1 3 10 20 50 2:00",
					"0.1 1 1.5 3 2:00",
				},
				set = function(info,val) 
					self.db.profile.cooldowns.time_format = val
				end,
				get =function(info)
					return self.db.profile.cooldowns.time_format
				end,
			},
			fontflag = {
				type = "dropdown",	order = 4.2,
				name = L["Обводка шрифта"],
				values = {
					["NONE"] = NO,
					["OUTLINE"] = "OUTLINE",
					["THICKOUTLINE"] = "THICKOUTLINE",
					["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
				},
				set = function(info,val) 
					self.db.profile.cooldowns.fonts.fontflag = val
					ns:UpdateFramesStyle()
					ns:MultitargetFontUpdate()
					ns:UpdateCooldownOrders()
				end,
				get = function(info) return self.db.profile.cooldowns.fonts.fontflag end
			},
		},
	}
	
	o.args.font.args.timer ={
		order = 10,name = L["Таймер"],type = "group", embend = true,
		args={
			fontisize_stack = {
				name = L["Размер шрифта"], disabled = false,
				type = "slider",
				order	= 1,
				min		= 1,
				max		= 32,
				step	= 1,
				set = function(info,val) 
					self.db.profile.cooldowns.fonts.timer.fontsize = val
					ns:CooldownFontUpdate()
				end,
				get =function(info)
					return self.db.profile.cooldowns.fonts.timer.fontsize
				end,
			},
			textposition_stack = {	
				type = "dropdown",order = 6,
				name = L["Выравнивание текста"],
				desc = L["Выравнивание текста"],
				values = {
					["TOP;CENTER"] = L["Сверху"],
					["TOP;LEFT"] = L["Слева вверху"],
					["TOP;RIGHT"] = L["Справа вверху"],
					["CENTER;CENTER"] = L["Центр"],
					["BOTTOM;CENTER"] = L["Снизу"],
					["BOTTOM;LEFT"] = L["Слева внизу"],
					["BOTTOM;RIGHT"] = L["Справа внизу"],
					["CENTER;LEFT"] = L["По центру слева"],
					["CENTER;RIGHT"] = L["По центру справа"],
				},
				set = function(info,val) 
					self.db.profile.cooldowns.fonts.timer.text_point = val
					ns:CooldownFontUpdate()
				end,
				get = function(info) return self.db.profile.cooldowns.fonts.timer.text_point end
			},
			color = {
				order = 7,name = L["Цвет"], type = "color", hasAlpha = false,
				set = function(info,r,g,b,a) 
					self.db.profile.cooldowns.fonts.timer.color ={r,g,b,1};
					ns:CooldownFontUpdate()
				end,
				get = function(info) 
					return self.db.profile.cooldowns.fonts.timer.color[1], self.db.profile.cooldowns.fonts.timer.color[2], self.db.profile.cooldowns.fonts.timer.color[3], 1
				end
			},
			font_pos_x = {
				name = L["Смещение по горизонтали"], disabled = false,
				type = "slider",
				order	= 10,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					self.db.profile.cooldowns.fonts.timer.spacing_h = val
					ns:CooldownFontUpdate()
				end,
				get =function(info)
					return self.db.profile.cooldowns.fonts.timer.spacing_h
				end,
			},
			font_pos_7 = {
				name = L["Смещение по вертикали"], disabled = false,
				type = "slider",
				order	= 15,
				min		= -50,
				max		= 50,
				step	= 1,
				set = function(info,val) 
					self.db.profile.cooldowns.fonts.timer.spacing_v = val
					ns:CooldownFontUpdate()
				end,
				get =function(info)
					return self.db.profile.cooldowns.fonts.timer.spacing_v
				end,
			},
		},
	}
	
	
	o.args.borders ={
		order = 10,name = L["Граница"],type = "group", embend = true,
		args={
		
		},
	}
	
	o.args.borders.args.border = {
		order = 19.1,type = 'border',name = L["Текстура"],
		values = ns.SharedMedia:HashTable("border"),
		set = function(info,value) self.db.profile.cooldowns.border.texture = value;ns:CooldownBorderUpdate();end,
		get = function(info) return self.db.profile.cooldowns.border.texture end,
	}
					
	o.args.borders.args.bordercolor = {
		order = 19.2,name = L["Цвет"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) 
			self.db.profile.cooldowns.border.color={r,g,b,a};
			ns:CooldownBorderUpdate();end,
		get = function(info) 
			return self.db.profile.cooldowns.border.color[1],
			self.db.profile.cooldowns.border.color[2],
			self.db.profile.cooldowns.border.color[3],
			self.db.profile.cooldowns.border.color[4]
		end
	}
					
	o.args.borders.args.bordersize = {
		name = L["Размер"],
		type = "slider",
		order	= 19.3,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			self.db.profile.cooldowns.border.size = val
			ns:CooldownBorderUpdate();
		end,
		get =function(info)
			return self.db.profile.cooldowns.border.size
		end,
	}
	o.args.borders.args.borderinset = {
		name = L["Отступ границ"],
		type = "slider",
		order	= 19.4,
		min		= 0,
		max		= 32,
		step	= 1,
		set = function(info,val) 
			self.db.profile.cooldowns.border.inset = val
			ns:CooldownBorderUpdate();
		end,
		get =function(info)
			return self.db.profile.cooldowns.border.inset
		end,
	}
	
	o.args.borders.args.bgcolor = {
		order = 19.2,name = L["Фон"],type = "color", hasAlpha = true,
		set = function(info,r,g,b,a) 
			self.db.profile.cooldowns.border.background={r,g,b,a};
			ns:CooldownBorderUpdate();
		end,
		get = function(info) 
			return self.db.profile.cooldowns.border.background[1],
			self.db.profile.cooldowns.border.background[2],
			self.db.profile.cooldowns.border.background[3],
			self.db.profile.cooldowns.border.background[4]
		end
	}
	o.args.borders.args.bginset = {
		name = L["Отступ фона"],
		type = "slider",
		order	= 19.4,
		min		= -50,
		max		= 50,
		step	= 1,
		set = function(info,val) 
			self.db.profile.cooldowns.border.bg_inset = val
			ns:CooldownBorderUpdate();
		end,
		get =function(info)
			return self.db.profile.cooldowns.border.bg_inset
		end,
	}
	
	o.args.spells = {
		order = 7,name = L["Заклинания"],type = "group",
		args={
		
		},
	}
	
	for i=1, #spells_to_show do
		
		o.args.spells.args["ordergroup"..i] ={
			order = i,name = GetSpellNameGUI(spells_to_show[i].id) ,type = "group", embend = true,
			args={
			
			},
		}
		
		if self.db.profile.cooldowns.specificSpell[spells_to_show[i].id] then
		
			o.args.spells.args["ordergroup"..i].args.enable = {
				name = L["Показывать"],
				type = "toggle",
				order	= 1,
				set = function(info,val)
					options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on = 
						not options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on				
					ns:UpdateCooldownOrders()
				end,
				get =function(info)
					return options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on
				end,
			}	
		
			for k,v in pairs(self.db.profile.cooldowns.specificSpell[spells_to_show[i].id]) do
				
				if k == 'color' then
						o.args.spells.args["ordergroup"..i].args[k] = {
						order = 7,name = L["Цвет"],type = "color", hasAlpha = true,
						set = function(info,r,g,b,a) options.cooldowns.specificSpell[spells_to_show[i].id][k] ={r,g,b,a};end,
						get = function(info) 
							return options.cooldowns.specificSpell[spells_to_show[i].id][k][1],
							options.cooldowns.specificSpell[spells_to_show[i].id][k][2],
							options.cooldowns.specificSpell[spells_to_show[i].id][k][3],
							options.cooldowns.specificSpell[spells_to_show[i].id][k][4] 
						end
					}
				else
					o.args.spells.args["ordergroup"..i].args[k] = {
						name = L[k],
						desc = L[k.."Desc"],
						type = "toggle",
						order	= 6,
						set = function(info,val)
							options.cooldowns.specificSpell[spells_to_show[i].id][k] = 
								not options.cooldowns.specificSpell[spells_to_show[i].id][k]
						end,
						get = function(info)
							return options.cooldowns.specificSpell[spells_to_show[i].id][k]
						end,
					}
				end
			end
		else
			o.args.spells.args["ordergroup"..i].args.enable = {
				name = L["Показывать"],
				type = "toggle",
				order	= 1,
				set = function(info,val)			
					options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on = 
						not options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on				
					ns:UpdateCooldownOrders()
				end,
				get =function(info)
					return options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].on
				end,
			}		
		end
		o.args.spells.args["ordergroup"..i].args.order = {
			name = L["Приоритет"], disabled = false,
			type = "dropdown",
			order	= 2,
			values = function()
				return spellPriorityList
			end,
			set = function(info,val)
				options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].sort = val
					
				ns:UpdateCooldownOrders()
			end,
			get =function(info)
				return options.cooldowns.ordering_spells.spellList[spells_to_show[i].id].sort
			end,
		}
	
	end
	
	ns:UpdateCooldownStyleOpts(o)
	
	return o
end
