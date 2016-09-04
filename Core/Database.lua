local _, _, _, DB = unpack(select(2, ...))
NDuiADB = NDuiADB or {}
NDuiDB = NDuiDB or {}
DB.Version = GetAddOnMetadata("NDui", "Version")

-- Colors
DB.MyClass = select(2, UnitClass("player"))
DB.cc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[DB.MyClass]
DB.MyColor = format("|cff%02x%02x%02x", DB.cc.r*255, DB.cc.g*255, DB.cc.b*255)
DB.InfoColor = "|cff70C0F5"
DB.GreyColor = "|cffB5B5B5"

-- Fonts
DB.Font = {STANDARD_TEXT_FONT, 12, "THINOUTLINE"}
DB.TipFont = {GameTooltipText:GetFont(), 14, 0}
NumberFontNormal:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")
TextStatusBarText:SetFont(STANDARD_TEXT_FONT, 14)

-- Textures
local Media = "Interface\\Addons\\NDui\\Media\\"
DB.bdTex = "Interface\\ChatFrame\\ChatFrameBackground"
DB.glowTex = Media.."glowTex"
DB.normTex = Media.."normTex"
DB.Mail = Media.."Mail.tga"
DB.Micro = Media.."MicroMenu\\"
DB.bgTex = Media.."bgTex"
DB.TexCoord = {0.08, 0.92, 0.08, 0.92}
DB.textures = {
    normal            = Media.."ActionBar\\gloss",
    flash             = Media.."ActionBar\\flash",
    pushed            = Media.."ActionBar\\pushed",
    checked           = Media.."ActionBar\\checked",
    equipped          = Media.."ActionBar\\gloss_grey",
    buttonbackflat    = Media.."ActionBar\\button_background_flat",
    outer_shadow      = Media.."ActionBar\\outer_shadow",
}

-- Nameplate Debuff 姓名板增减益
DB.DebuffWhiteList = {
	-- 死亡骑士
	[GetSpellInfo(115001)]		= true,	-- 冷酷严冬
	[GetSpellInfo(47476)] 		= true,	-- 绞袭
	[GetSpellInfo(108194)]		= true,	-- 窒息
	[GetSpellInfo(55078)] 		= true,	-- 血之疫病
	[GetSpellInfo(55095)]		= true,	-- 冰霜疫病
	[GetSpellInfo(155159)]		= true,	-- 死疽
	[GetSpellInfo(155166)]		= true,	-- 辛达苟萨之息
	[GetSpellInfo(156004)]		= true,	-- 亵渎
	[GetSpellInfo(130735)]		= true,	-- 冰收割
	[GetSpellInfo(114866)]		= true,	-- 血收割
	[GetSpellInfo(130736)]		= true,	-- 邪收割
	[GetSpellInfo(45524)]		= true,	-- 寒冰锁链
	[GetSpellInfo(160715)]		= true,	-- 死握寒冰锁链
	[GetSpellInfo(56222)]		= true,	-- 黑暗命令
	-- 德鲁伊
	[GetSpellInfo(33786)] 		= true,	-- 旋风
	[GetSpellInfo(339)]			= true,	-- 纠缠根须
	[GetSpellInfo(102359)]		= true,	-- 群体缠绕
	[GetSpellInfo(164812)] 		= true,	-- 月火术
	[GetSpellInfo(164815)] 		= true,	-- 阳炎术
	[GetSpellInfo(152221)] 		= true,	-- 星辰耀斑
	[GetSpellInfo(58180)] 		= true,	-- 感染伤口
	[GetSpellInfo(33745)] 		= true,	-- 割伤
	[GetSpellInfo(155722)]		= true,	-- 斜掠
	[GetSpellInfo(1079)]		= true,	-- 割裂
	-- 猎人
	[GetSpellInfo(3355)]		= true,	-- 冰冻陷阱
	[GetSpellInfo(118253)] 		= true,	-- 毒蛇钉刺
	[GetSpellInfo(53301)] 		= true,	-- 爆炸射击
	[GetSpellInfo(3674)] 		= true,	-- 黑箭
	[GetSpellInfo(5116)] 		= true,	-- 震荡射击
	[GetSpellInfo(136634)] 		= true,	-- 险境求生
	[GetSpellInfo(131894)] 		= true,	-- 夺命黑鸦
	[GetSpellInfo(13812)] 		= true,	-- 爆炸陷阱
	[GetSpellInfo(162546)] 		= true,	-- 寒冰弹
	-- 法师
	[GetSpellInfo(31661)] 		= true,	-- 龙息术
	[GetSpellInfo(118)] 		= true,	-- 变形术
	[GetSpellInfo(122)] 		= true,	-- 冰霜新星
	[GetSpellInfo(111340)] 		= true,	-- 寒冰结界
	[GetSpellInfo(114923)] 		= true,	-- 虚空风暴
	[GetSpellInfo(44457)] 		= true,	-- 活动炸弹
	[GetSpellInfo(157997)] 		= true,	-- 寒冰新星
	-- 圣骑士
	[GetSpellInfo(20066)] 		= true,	-- 忏悔
	[GetSpellInfo(10326)] 		= true,	-- 超度邪恶
	[GetSpellInfo(853)] 		= true,	-- 制裁之锤
	[GetSpellInfo(105593)] 		= true,	-- 制裁之拳
	[GetSpellInfo(2812)] 		= true,	-- 神圣愤怒
	-- 牧师
	[GetSpellInfo(589)] 		= true,	-- 痛
	[GetSpellInfo(34914)] 		= true,	-- 触
	[GetSpellInfo(2944)] 		= true,	-- 瘟疫
	[GetSpellInfo(64044)] 		= true,	-- 心灵惊骇
	[GetSpellInfo(8122)] 		= true,	-- 心灵尖啸
	[GetSpellInfo(9484)] 		= true,	-- 束缚亡灵
	[GetSpellInfo(15487)] 		= true,	-- 沉默
	-- 盗贼
	[GetSpellInfo(2094)] 		= true,	-- 致盲
	[GetSpellInfo(1776)] 		= true,	-- 凿击
	[GetSpellInfo(6770)] 		= true,	-- 闷棍
	[GetSpellInfo(122233)] 		= true,	-- 猩红风暴
	-- 萨满
	[GetSpellInfo(51514)] 		= true,	-- 妖术
	[GetSpellInfo(3600)] 		= true,	-- 地缚术
	[GetSpellInfo(8056)] 		= true,	-- 冰霜震击
	[GetSpellInfo(8050)] 		= true,	-- 烈焰震击
	[GetSpellInfo(63685)] 		= true,	-- 冰冻
	-- 术士
	[GetSpellInfo(710)] 		= true,	-- 放逐术
	[GetSpellInfo(6789)] 		= true,	-- 死亡缠绕
	[GetSpellInfo(5782)] 		= true,	-- 恐惧
	[GetSpellInfo(5484)] 		= true,	-- 恐惧嚎叫
	[GetSpellInfo(6358)]		= true,	-- 诱惑
	[GetSpellInfo(30283)] 		= true,	-- 暗影之怒
	[GetSpellInfo(603)] 		= true,	-- 末日降临
	[GetSpellInfo(980)] 		= true,	-- 痛楚
	[GetSpellInfo(172)] 		= true,	-- 腐蚀术
	[GetSpellInfo(48181)] 		= true,	-- 鬼影缠身
	[GetSpellInfo(30108)] 		= true,	-- 痛苦无常
	[GetSpellInfo(157736)]	 	= true,	-- 献祭
	[GetSpellInfo(80240)] 		= true,	-- 浩劫
	[GetSpellInfo(17877)] 		= true,	-- 暗影灼烧
	[GetSpellInfo(105174)] 		= true,	-- 古尔丹之手
	-- 战士
	[GetSpellInfo(772)] 		= true,	-- 撕裂
	[GetSpellInfo(115767)] 		= true,	-- 重伤
	[GetSpellInfo(132168)] 		= true,	-- 震荡波
	[GetSpellInfo(5246)] 		= true,	-- 破胆怒吼
	-- 武僧
	[GetSpellInfo(115078)] 		= true,	-- 分筋错骨
	[GetSpellInfo(123586)] 		= true,	-- 翔龙在天
	[GetSpellInfo(138130)] 		= true,	-- 风火雷电
	-- 种族技能
	[GetSpellInfo(25046)] 		= true,	-- 奥术洪流
	[GetSpellInfo(20549)] 		= true,	-- 战争践踏
	[GetSpellInfo(107079)] 		= true,	-- 震山掌
}

-- RoleUpdater
local RoleUpdater = CreateFrame("Frame")
local function CheckRole(self, event, unit)
	local tree = GetSpecialization()
	if not tree then return end
	local _, _, _, _, _, role, stat = GetSpecializationInfo(tree)
	if role == "TANK" then
		local gladStance = GetSpellInfo(156291)	--角斗士姿态
		if DB.MyClass == "WARRIOR" and UnitBuff("player", gladStance) then
			DB.Role = "Melee"
		else
			DB.Role = "Tank"
		end
	elseif role == "HEALER" then
		DB.Role = "Healer"
	elseif role == "DAMAGER" then
		if stat == 4 then	--1力量，2敏捷，4智力
			DB.Role = "Caster"
		else
			DB.Role = "Melee"
		end
	end
end
RoleUpdater:RegisterEvent("PLAYER_LOGIN")
RoleUpdater:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
RoleUpdater:SetScript("OnEvent", CheckRole)

-- Itemlevel Upgrade Table
DB.UpgradeTable = {
	[0]		=  0,
	[1]		=  8,
	[373]	=  4,
	[374]	=  8,
	[375]	=  4,
	[376]	=  4,
	[377]	=  4,
	[379]	=  4,
	[380]	=  4,
	[445]	=  0,
	[446]	=  4,
	[447]	=  8,
	[451]	=  0,
	[452]	=  8,
	[453]	=  0,
	[454]	=  4,
	[455]	=  8,
	[456]	=  0,
	[457]	=  8,
	[458]	=  0,
	[459]	=  4,
	[460]	=  8,
	[461]	= 12,
	[462]	= 16,
	[465] 	=  0,
	[466]	=  4,
	[467] 	=  8,
	[468] 	=  0,
	[469] 	=  4,
	[470] 	=  8,
	[471] 	= 12,
	[472] 	= 16,
	[476] 	=  0,
	[477] 	=  4,
	[478] 	=  8,
	[479] 	=  0,
	[480] 	=  8,
	[491] 	=  0,
    [492] 	=  4,
    [493] 	=  8,
    [494] 	=  0,
    [495] 	=  4,
    [496] 	=  8,
    [497] 	= 12,
    [498] 	= 16,
	[504] 	= 12,
	[505] 	= 16,
	[506] 	= 20,
	[507] 	= 24,
}

-- Raidbuff Checklist
DB.BuffList = {
	[1] = {		-- 合剂
		156071,	-- 力量
		156073,	-- 敏捷
		156070,	-- 智力
		156077,	-- 耐力
		156080,	-- 强效力量
		156064,	-- 强效敏捷
		156079,	-- 强效智力
		156084,	-- 强效耐力
	},
	[2] = {     -- 进食充分
		104273, -- 250敏捷，BUFF一致
	},
	[3] = {     -- 全属性
		  1126, -- 德鲁伊野性印记
		 20217, -- 圣骑王者祝福
		116781, -- 武僧白虎传承
		115921,	-- 奶僧帝王传承
		 72586, -- 遗忘王者祝福：4%属性
		159988, -- 淡水兽：野性嚎叫
		 90363, -- 页岩蛛：页岩蛛之拥
		160017, -- 猩猩：金刚的祝福
		160077, -- 虫：大地之力
		160206, -- 孤狼：巨猿之力
		144053,	-- 试炼场
	},
	[4] = {     -- 耐力
		 21562, -- 牧师真言术：韧
		   469, -- 战士命令怒吼
		166928, -- 术士血之契印
		111922, -- 坚韧符文卷轴：8%耐力
		 90364, -- 其拉虫：其拉虫群坚韧
		160003, -- 双头飞龙：野性活力
		160014, -- 山羊：坚忍不拔
		160199, -- 孤狼：巨熊之韧
		144051,	-- 试炼场
	},
	[5] = {     -- 5%爆击
		 24932, -- 野德兽群领袖
		116781, -- 武僧白虎传承
		  1459, -- 奥术光辉
		 61316, -- 达拉然光辉
		126309, -- 水黾：净水
		 24604, -- 狼：狂怒之嚎
		 90309, -- 魔暴龙：惊人咆哮
		126373, -- 魁麟：无畏之嚎
		 90363, -- 页岩蛛：页岩蛛之拥
		160052, -- 迅猛龙：兽群之力
		160200, -- 孤狼：迅猛龙之恶
		128997, -- 灵魂兽：灵魂兽祝福
		144047,	-- 试炼场
	},
	[6] = {     -- 5%精通
		 19740, -- 圣骑力量祝福
		155522, -- DKT幽冥之力
		 24907, -- 鸟德枭兽形态
		116956, -- 萨满风之优雅
		 93435, -- 豹：勇气咆哮
		128997, -- 灵魂兽：灵魂兽祝福
		160039, -- 九头蛇：敏锐感知
		160073, -- 陆行鸟：如履平地
		160198, -- 孤狼：猫之优雅
		144048,	-- 试炼场
	},
	[7] = {     -- 5%溅射
		166916,	-- 踏风风怒
		109773,	-- 术士黑暗意图
		113742, -- 盗贼迅刃之黠
		 49868, -- 暗牧思维加速
		159733, -- 蜥蜴：邪恶凝视
		 54644, -- 奇美拉：冰息
		 58604, -- 熔岩犬：双重撕咬
		 34889, -- 龙鹰：迅捷打击
		160011, -- 狐狸：灵敏反应
		 57386, -- 犀牛：狂野之力
		 24844, -- 风蛇：狂风呼啸
		172968, -- 孤狼：龙鹰之速
		175651,	-- 试炼场
	},
	[8] = {     -- 3%全能
		167187, -- 惩戒圣洁光环
		 55610, -- DK邪恶光环
		  1126, -- 德鲁伊野性印记
		167188, -- 战士振奋风采
		159735, -- 猛禽：坚韧
		 35290, -- 野猪：不屈
		160045, -- 刺猬：防御鬃毛
		 50518, -- 掠夺者：角质护甲
		 57386, -- 犀牛：狂野之力
		160077, -- 虫：大地之力
		172967, -- 孤狼：掠食者之力
		175649,	-- 试炼场
	},
	[9] = {     -- 5%急速
		113742, -- 盗贼迅刃之黠
		 49868, -- 暗牧思维加速
		 55610, -- DK邪恶光环
		116956, -- 萨满风之优雅
		160003, -- 双头飞龙：野性活力
		128432, -- 土狼：厉声嚎叫
		135678, -- 孢子蝠：充能孢子
		160074, -- 蜂：虫群疾速
		160203, -- 孤狼：土狼之速
		144046,	-- 试炼场
	},
	[10] = {    -- 10%攻强
		 19506, -- 猎人强击光环
		  6673, -- 战士战斗怒吼
		 57330, -- DK寒冬号角
		144041,	-- 试炼场
	},
	[11] = {    -- 10%法强
		  1459, -- 奥术光辉
		 61316, -- 达拉然光辉
		109773,	-- 术士黑暗意图
		126309, -- 水黾：净水
		 90364, -- 其拉虫：其拉虫群坚韧
		160205, -- 孤狼：神龙之智
		144042, -- 试炼场
	},
	[12] = {    -- 治疗石
		  5512, -- 治疗石
	},
}

-- Reminder Buffs Checklist
DB.ReminderBuffs = {
	PRIEST = {
		[CHAKRA] = {
			["spells"] = {
				[81206] = true,			-- 脉轮：佑
				[81208] = true,			-- 脉轮：静
				[81209] = true,			-- 脉轮：罚
			},
			["tree"] = 2,
		},
	},
	PALADIN = {
		[RIGHTEOUS_FURY] = {
			["spells"] = {
				[25780] = true,			-- 正义之怒
			},
			["role"] = "Tank",
			["instance"] = true,
			["reversecheck"] = true,
			["negate_reversecheck"] = 1,-- 奶骑
		},
		[SEALS] = {						-- 圣印
			["stance"] = true,
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["level"] = 3,
		},
	},
	SHAMAN = {
		[WATER_SHIELD] = { 	 			-- 水盾
			["spells"] = {
				[52127] = true,
			},
			["negate_spells"] = {
				[974] = true,			-- 大地之盾
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["role"] = "Healer",
		},
		[LIGHTNING_SHIELD] = { 			-- 闪电护盾
			["spells"] = {
				[324] = true,
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
			["role"] = "Caster",
		},
	},
	DEATHKNIGHT = {
		[BLOOD_PRESENCE] = {			-- 鲜血灵气
			["spells"] = {
				[48263] = true,
			},
			["tree"] = 1,
			["instance"] = true,
		},
		[FROST_PRESENCE] = {			-- 冰霜灵气
			["spells"] = {
				[48266] = true,
			},
			["negate_spells"] = {
				[48265] = true,			-- 邪恶灵气
			},
			["tree"] = 2,
			["instance"] = true,
		},
		[UNHOLY_PRESENCE] = {			-- 邪恶灵气
			["spells"] = {
				[48265] = true,
			},
			["negate_spells"] = {
				[48266] = true,			-- 冰霜灵气
			},
			["tree"] = 3,
			["instance"] = true,
		},
	},
	ROGUE = { 
		[DAMAGE_POISONS] = {			-- 伤害类毒药
			["spells"] = {
				[2823] = true,			-- 致命药膏
			},
			["negate_spells"] = {
				[8679] = true,			-- 致伤药膏
				[157584] = true,		-- 速效药膏
			},
			["combat"] = true,
			["instance"] = true,
			["pvp"] = true,
		},
		[EFFECT_POISONS] = { 			-- 效果类毒药
			["spells"] = {
				[3408] = true,   		-- 减速药膏
			},
			["negate_spells"] = {
				[108211] = true, 		-- 吸血药膏
			},
			["pvp"] = true,
		},
	},
	HUNTER = { 
		[AMMOS] = {						-- 特殊弹药
			["spells"] = {
				[162537] = true,		-- 毒液弹
			},
			["negate_spells"] = {
				[162536] = true,		-- 烈焰弹
				[162539] = true,		-- 寒冰弹
			},
			["talent"] = 21195,
		},
		[LONE_WOLF] = {					-- 独来独往
			["spells"] = {
				[164273] = true,
			},
			["instance"] = true,
			["talent"] = 21197,
		},
	},
}

DB.PlateBlacklist = {
	-- Army of the Dead
	["Army of the Dead Ghoul"] = true,
	-- Hunter Trap
	["Venomous Snake"] = true,
	["Viper"] = true,
	-- Raid
	["Liquid Obsidian"] = true,
	["Lava Parasites"] = true,
	-- Gundrak
	["Fanged Pit Viper"] = true,
	-- Totems
	["Air Totem"] = true,
	["Water Totem"] = true,
	["Fire Totem"] = true,
	["Earth Totem"] = true,
}