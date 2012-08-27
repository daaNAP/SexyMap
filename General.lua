
local _, sm = ...
sm.General = {}

local parent = sm.Core
local mod = sm.General
local L = sm.L

local db
local options = {
	type = "group",
	name = "General",
	args = {
		lock = {
			order = 1,
			name = L["Lock Minimap"],
			type = "toggle",
			get = function()
				return db.lock
			end,
			set = function(info, v)
				db.lock = v
				Minimap:SetMovable(not db.lock)
			end,
		},
		clamp = {
			order = 2,
			type = "toggle",
			name = L["Clamp to screen"],
			desc = L["Prevent the minimap from being moved off the screen"],
			get = function()
				return db.clamp
			end,
			set = function(info, v)
				db.clamp = v
				Minimap:SetClampedToScreen(v)
			end,
		},
		rotate = {
			order = 3,
			type = "toggle",
			name = ROTATE_MINIMAP,
			desc = OPTION_TOOLTIP_ROTATE_MINIMAP,
			get = function()
				return GetCVar("rotateMinimap") == "1"
			end,
			set = ToggleMiniMapRotation,
		},
		rightClickToConfig = {
			order = 4,
			type = "toggle",
			name = L["Right Click Configure"],
			desc = L["Right clicking the map will open the SexyMap options"],
			get = function()
				return db.rightClickToConfig
			end,
			set = function(info, v)
				db.rightClickToConfig = v
			end,
		},
		scale = {
			order = 5,
			type = "range",
			name = L["Scale"],
			min = 0.2,
			max = 3.0,
			step = 0.01,
			bigStep = 0.01,
			width = "double",
			get = function(info)
				return db.scale or 1
			end,
			set = function(info, v)
				db.scale = v
				Minimap:SetScale(v)
			end,
		},
		northTag = {
			order = 6,
			type = "toggle",
			name = L["Show North Tag"],
			get = function()
				return db.northTag
			end,
			set = function(info, v)
				if v then
					MinimapNorthTag.Show = MinimapNorthTag.oldShow
					MinimapNorthTag.oldShow = nil
					MinimapNorthTag:Show()
				else
					MinimapNorthTag:Hide()
					MinimapNorthTag.oldShow = MinimapNorthTag.Show
					MinimapNorthTag.Show = MinimapNorthTag.Hide
				end
				db.northTag = v
			end,
		},
		zoom = {
			order = 7,
			type = "range",
			name = L["Auto Zoom-Out Delay"],
			desc = L["If you zoom into the map, this feature will automatically zoom out after the selected period of time (seconds)"],
			width = "double",
			min = 0,
			max = 30,
			step = 1,
			bigStep = 1,
			get = function()
				return mod.db.profile.autoZoom
			end,
			set = function(info, v)
				mod.db.profile.autoZoom = v
			end,
		},
		presetSpacer = {
			order = 8,
			type = "header",
			name = L["Preset"],
		},
	}
}

mod.options = options

-- Make sure the various minimap buttons follow the minimap
-- We do this before login to prevent button placement issues
MinimapBackdrop:ClearAllPoints()
MinimapBackdrop:SetParent(Minimap)
MinimapBackdrop:SetPoint("CENTER", Minimap, "CENTER", -8, -23)

local animGroup, anim
function mod:OnGeneralEnable()
	local Minimap = Minimap

	local defaults = {
		profile = {
			lock = true,
			clamp = true,
			rightClickToConfig = true,
			autoZoom = 5,
			northTag = true,
		}
	}
	self.db = parent.db:RegisterNamespace("General", defaults)
	db = self.db.profile
	parent:RegisterModuleOptions("General", options, "General")

	--[[ Auto Zoom Out ]]--
	animGroup = Minimap:CreateAnimationGroup()
	anim = animGroup:CreateAnimation()
	animGroup:SetScript("OnFinished", function()
		for i = 1, 5 do
			MinimapZoomOut:Click()
		end
	end)
	anim:SetOrder(1)
	anim:SetDuration(1)

	-- XXX temp, kill the tracker fix addon
	if select(2, GetAddOnInfo("SexyMapTrackerButtonFix")) then
		DisableAddOn("SexyMapTrackerButtonFix")
		local c = CreateFrame"Frame"
		local t = GetTime()
		c:SetScript("OnUpdate", function()
			if GetTime()-t > 7 then
				ChatFrame1:AddMessage("SexyMapTrackerButtonFix: I'm no longer needed, please remove this addon.", 0, 0.3, 1)
				c:SetScript("OnUpdate", nil)
			end
		end)
	end

	--[[ MouseWheel Zoom ]]--
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(frame, d)
		if d > 0 then
			MinimapZoomIn:Click()
		elseif d < 0 then
			MinimapZoomOut:Click()
		end
		if mod.db.profile.autoZoom > 0 then
			animGroup:Stop()
			anim:SetDuration(mod.db.profile.autoZoom)
			animGroup:Play()
		end
	end)
	if self.db.profile.autoZoom > 0 then
		animGroup:Play()
	end

	MinimapCluster:EnableMouse(false) -- Don't leave an invisible dead zone

	if not db.northTag then
		MinimapNorthTag:Hide()
		MinimapNorthTag.oldShow = MinimapNorthTag.Show
		MinimapNorthTag.Show = MinimapNorthTag.Hide
	end

	MinimapBorderTop:Hide()
	Minimap:RegisterForDrag("LeftButton")
	Minimap:SetClampedToScreen(db.clamp)
	Minimap:SetScale(db.scale or 1)
	Minimap:SetMovable(not db.lock)

	Minimap:SetScript("OnDragStart", function(self) if self:IsMovable() then self:StartMoving() end end)
	Minimap:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = Minimap:GetPoint()
		db.point, db.relpoint, db.x, db.y = p, rp, x, y
	end)

	if db.point then
		Minimap:ClearAllPoints()
		Minimap:SetParent(UIParent)
		Minimap:SetPoint(db.point, UIParent, db.relpoint, db.x, db.y)
	end
end

