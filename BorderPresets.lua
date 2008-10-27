SexyMap.borderPresets = {				
	["Blue Runes"] = {
		borders = {
			{
				["a"] = 1,
				["r"] = 0.3098039215686275,
				["name"] = "Rune 1",
				["b"] = 1,
				["scale"] = 1.4,
				["rotSpeed"] = -16,
				["g"] = 0.4784313725490196,
				["texture"] = "SPELLS\\AURARUNE256.BLP",
			}, -- [1]
			{
				["a"] = 0.3799999952316284,
				["r"] = 0.196078431372549,
				["rotSpeed"] = 4,
				["b"] = 1,
				["scale"] = 2.1,
				["name"] = "Rune 2",
				["g"] = 0.2901960784313725,
				["texture"] = "SPELLS\\AuraRune_A.blp",
			}, -- [2]
			{
				["a"] = 1,
				["name"] = "Fade",
				["b"] = 1,
				["scale"] = 1.6,
				["r"] = 0,
				["g"] = 0.2235294117647059,
				["texture"] = "SPELLS\\T_VFX_HERO_CIRCLE.BLP",
			}, -- [3]
		},
		shape = "Textures\\MinimapMask"
	},
	["Purple Rune Square"] = {
		borders = {
			{
				["a"] = 0.5,
				["hNudge"] = 0,
				["rotSpeed"] = 0,
				["b"] = 1,
				["scale"] = 1.6,
				["g"] = 0.2666666666666667,
				["vNudge"] = 0,
				["rotation"] = 0,
				["name"] = "Rune",
				["r"] = 0.6705882352941176,
				["texture"] = "SPELLS\\AuraRune256b.blp",
			}, -- [1]
			{
				["a"] = 0.1899999976158142,
				["name"] = "Inner Circle",
				["b"] = 1,
				["scale"] = 3,
				["r"] = 0.4705882352941176,
				["g"] = 0,
				["texture"] = "Interface\\GLUES\\MODELS\\UI_Tauren\\gradientCircle.blp",
			}, -- [2]
		},
		shape = "Interface\\AddOns\\SexyMap\\shapes\\diamond"
	},
}