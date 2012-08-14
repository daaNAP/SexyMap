
local _, addon = ...
local parent = addon.SexyMap
local modName = "Ping"
local mod = addon.SexyMap:NewModule(modName)
local L = addon.L
local pingFrame

local defaults = {
	profile = {
		showPing = true,
		showAt = "map"
	}
}

local options = {
	type = "group",
	name = modName,
	disabled = function() return not mod.db.profile.showPing end,
	args = {
		show = {
			type = "toggle",
			order = 1,
			name = L["Show who pinged"],
			width = "full",
			get = function()
				return mod.db.profile.showPing
			end,
			set = function(info, v)
				mod.db.profile.showPing = v
				if v then
					pingFrame:RegisterEvent("MINIMAP_PING")
				else
					pingFrame:UnregisterEvent("MINIMAP_PING")
				end
			end,
			disabled = false,
		},
		showChat = {
			type = "toggle",
			order = 2,
			name = L["Show inside chat"],
			set = function(info, v)
				mod.db.profile.showAt = "chat"
			end,
			get = function(info)
				return mod.db.profile.showAt == "chat" and true or false
			end,
		},
		showMap = {
			type = "toggle",
			order = 3,
			name = L["Show on minimap"],
			set = function(info, v)
				mod.db.profile.showAt = "map"
			end,
			get = function(info)
				return mod.db.profile.showAt == "map" and true or false
			end,
		},
	}
}

pingFrame = CreateFrame("Frame", "SexyMapPingFrame", Minimap)
pingFrame:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	insets = {left = 2, top = 2, right = 2, bottom = 2},
	edgeSize = 12,
	tile = true
})
pingFrame:SetBackdropColor(0,0,0,0.8)
pingFrame:SetBackdropBorderColor(0,0,0,0.6)
pingFrame:SetHeight(20)
pingFrame:SetWidth(100)
pingFrame:SetPoint("TOP", Minimap, "TOP", 0, 15)
pingFrame:SetFrameStrata("HIGH")
pingFrame.name = pingFrame:CreateFontString(nil, nil, "GameFontNormalSmall")
pingFrame.name:SetAllPoints()
pingFrame:Hide()

local animGroup = pingFrame:CreateAnimationGroup()
local anim = animGroup:CreateAnimation("Alpha")
animGroup:SetScript("OnFinished", function() pingFrame:Hide() end)
anim:SetChange(-1)
anim:SetOrder(1)
anim:SetDuration(3)
anim:SetStartDelay(3)

pingFrame:SetScript("OnEvent", function(_, _, unit)
	local class = select(2, UnitClass(unit))
	local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class] or GRAY_FONT_COLOR
	if mod.db.profile.showAt == "chat" then
		DEFAULT_CHAT_FRAME:AddMessage(("Ping: |cFF%02x%02x%02x%s|r"):format(color.r * 255, color.g * 255, color.b * 255, UnitName(unit)))
	else
		pingFrame.name:SetFormattedText("|cFF%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, UnitName(unit))
		pingFrame:SetWidth(pingFrame.name:GetStringWidth() + 14)
		pingFrame:SetHeight(pingFrame.name:GetStringHeight() + 10)
		animGroup:Stop()
		pingFrame:Show()
		animGroup:Play()
	end
end)

function mod:OnInitialize()
	self.db = parent.db:RegisterNamespace(modName, defaults)
	parent:RegisterModuleOptions(modName, options, modName)
	if self.db.profile.showPing then
		pingFrame:RegisterEvent("MINIMAP_PING")
	end
end

