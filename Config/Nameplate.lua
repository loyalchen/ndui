local _, C, _, _ = unpack(select(2, ...))

-- 自身法术白名单
C.WhiteList = {
	-- 死亡骑士
	[108194]		= true,	-- 窒息
	[221562]		= true,	-- 窒息
	[55078] 		= true,	-- 血之疫病
	[55095]			= true,	-- 冰霜疫病
	[191587]		= true,	-- 恶性瘟疫
	[156004]		= true,	-- 亵渎
	[45524]			= true,	-- 寒冰锁链
	[56222]			= true,	-- 黑暗命令
	[130736]		= true,	-- 灵魂收割
	-- 德鲁伊
	[6795] 			= true,	-- 低吼
	[33786] 		= true,	-- 旋风
	[339]			= true,	-- 纠缠根须
	[102359]		= true,	-- 群体缠绕
	[164812] 		= true,	-- 月火术
	[164815] 		= true,	-- 阳炎术
	[202347] 		= true,	-- 星辰耀斑
	[155722]		= true,	-- 斜掠
	[1079]			= true,	-- 割裂
	[203123]		= true,	-- 割碎
	[106830]		= true,	-- 痛击
	[192090]		= true,	-- 痛击
	-- 猎人
	[3355]			= true,	-- 冰冻陷阱
	[13812] 		= true,	-- 爆炸陷阱
	[118253] 		= true,	-- 毒蛇钉刺
	[5116] 			= true,	-- 震荡射击
	[131894] 		= true,	-- 夺命黑鸦
	[206505] 		= true,	-- 夺命黑鸦
	[194599] 		= true,	-- 黑箭
	[187131] 		= true,	-- 易伤
	[213424] 		= true,	-- 死亡之眼
	[199803] 		= true,	-- 精确瞄准
	[185365] 		= true,	-- 猎人印记
	[19386] 		= true,	-- 翼龙钉刺
	-- 法师
	[31661] 		= true,	-- 龙息术
	[118] 			= true,	-- 变形术
	[122] 			= true,	-- 冰霜新星
	[114923] 		= true,	-- 虚空风暴
	[217694] 		= true,	-- 活动炸弹
	[157997] 		= true,	-- 寒冰新星
	[31589] 		= true,	-- 减速
	-- 圣骑士
	[20066] 		= true,	-- 忏悔
	[853] 			= true,	-- 制裁之锤
	[62124] 		= true,	-- 清算
	-- 牧师
	[589] 			= true,	-- 痛
	[34914] 		= true,	-- 触
	[8122] 			= true,	-- 心灵尖啸
	[9484] 			= true,	-- 束缚亡灵
	[15487] 		= true,	-- 沉默
	[200196] 		= true,	-- 罚
	[200200] 		= true,	-- 罚
	-- 盗贼
	[2094] 			= true,	-- 致盲
	[1776] 			= true,	-- 凿击
	[6770] 			= true,	-- 闷棍
	[408] 			= true,	-- 肾击
	[137619] 		= true,	-- 死亡标记
	[79140] 		= true,	-- 宿敌
	[1943] 			= true,	-- 割裂
	[16511] 		= true,	-- 出血
	[703] 			= true,	-- 锁喉
	[209786] 		= true,	-- 赤喉之咬
	[196958] 		= true,	-- 暗影打击
	[196937] 		= true,	-- 鬼魅攻击
	[199804] 		= true,	-- 正中眉心
	-- 萨满
	[51514] 		= true,	-- 妖术
	[3600] 			= true,	-- 地缚术
	[188838] 		= true,	-- 烈焰震击
	[188389] 		= true,	-- 烈焰震击
	[196840] 		= true,	-- 冰霜震击
	[197209] 		= true,	-- 避雷针
	-- 术士
	[710] 			= true,	-- 放逐术
	[6789] 			= true,	-- 死亡缠绕
	[118699] 		= true,	-- 恐惧
	[5484] 			= true,	-- 恐惧嚎叫
	[6358]			= true,	-- 诱惑
	[30283] 		= true,	-- 暗影之怒
	[603] 			= true,	-- 末日灾祸
	[980] 			= true,	-- 痛楚
	[146739] 		= true,	-- 腐蚀术
	[48181] 		= true,	-- 鬼影缠身
	[30108] 		= true,	-- 痛苦无常
	[157736]	 	= true,	-- 献祭
	[80240] 		= true,	-- 浩劫
	[17877] 		= true,	-- 暗影灼烧
	-- 战士
	[355] 			= true,	-- 嘲讽
	[772] 			= true,	-- 撕裂
	[115767] 		= true,	-- 重伤
	[132168] 		= true,	-- 震荡波
	[5246] 			= true,	-- 破胆怒吼
	[208086] 		= true,	-- 巨人打击
	[132169] 		= true,	-- 风暴之锤
	-- 武僧
	[115078] 		= true,	-- 分筋错骨
	[123586] 		= true,	-- 翔龙在天
	[116189] 		= true,	-- 豪镇八方
	[121253] 		= true,	-- 醉酿投
	[123725] 		= true,	-- 龙焰酒
	[119381] 		= true,	-- 扫堂腿
	-- 恶魔猎手
	[198813] 		= true,	-- 复仇回避
	[207690] 		= true,	-- 血滴子
	[179057] 		= true,	-- 混乱新星
	[206491] 		= true,	-- 涅墨西斯
	[213405] 		= true,	-- 战刃大师
	[207407] 		= true,	-- 灵魂切削
	[207744] 		= true,	-- 烈火烙印
	[224509] 		= true,	-- 幽魂炸弹
	-- 种族技能
	[25046] 		= true,	-- 奥术洪流
	[20549] 		= true,	-- 战争践踏
	[107079] 		= true,	-- 震山掌
}

-- 自身法术黑名单
C.BlackList = {
	[15407] = true,			-- 精神鞭笞
}

-- 其他法术名单
C.OtherList = {
	[117526] = true,		-- 束缚射击
}