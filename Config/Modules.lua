-- Configure 配置页面
local _, C, _, _ = unpack(select(2, ...))

-- 全局
C.NDui = {
	numbType		= 1,											-- 单位格式，1为m/k，2为y/w，3为详细
}

-- BUFF/DEBUFF相关
C.Auras = {
	IconSize		= 32,											-- BUFF图标大小
	IconsPerRow		= 14,											-- BUFF每行个数
	Spacing			= 6,											-- BUFF图标间距
	BuffPos			= {"TOPRIGHT", Minimap, "TOPLEFT", -10, -5},	-- BUFF位置
	DebuffPos		= {"TOPRIGHT", Minimap, "TOPLEFT", -10, -130},	-- DEBUFF位置

	CheckerPos		= {"TOPLEFT", UIParent, "TOPLEFT", 4, -23},		-- 团队BUFF框体位置
	BHPos			= {"CENTER", UIParent, "CENTER", 0, -200},		-- 血盾助手默认位置
	StaggerPos		= {"CENTER", UIParent, "CENTER", 0, -220},		-- 坦僧工具默认位置
	TotemsPos		= {"CENTER", UIParent, "CENTER", 0, -190},		-- 图腾助手默认位置
	CPointsPos		= {"CENTER", UIParent, "CENTER", 0, -190},		-- 连击点工具默认位置
}

-- 头像相关
C.UFs = {
	Enable			= true,											-- 启用头像
	Playercb		= {"BOTTOM", UIParent, "BOTTOM", 16, 190},		-- 玩家施法条默认位置
	PlayercbSize	= {300, 20},									-- 玩家施法条尺寸
	Targetcb		= {"BOTTOM", UIParent, "BOTTOM", 16, 350},		-- 目标施法条默认位置
	TargetcbSize	= {280, 20},									-- 目标施法条尺寸
	Focuscb			= {"CENTER", UIParent, "CENTER", 10, 200},		-- 焦点施法条默认位置
	FocuscbSize		= {320, 20},									-- 焦点施法条尺寸

	PlayerPos		= {"TOPRIGHT", UIParent, "BOTTOM", -200, 300},	-- 玩家框体默认位置
	TargetPos		= {"TOPLEFT", UIParent, "BOTTOM", 200, 300},	-- 目标框体默认位置
	ToTPos			= {"BOTTOM", UIParent, "BOTTOM", 136, 241},		-- 目标的目标框体默认位置
	PetPos			= {"BOTTOM", UIParent, "BOTTOM", -136, 241},	-- 宠物框体默认位置
	FocusPos		= {"LEFT", UIParent, "LEFT", 5, -150},			-- 焦点框体默认位置

	BarPoint		= {"TOPLEFT", 12, 4},							-- 资源条位置（以自身头像为基准）
	BarSize			= {215, 10},										-- 资源条的尺寸（宽，长）
	BarMargin		= 2,											-- 资源条间隔
}

-- 聊天框体
C.Chat = {
	Enable			= true,											-- 启用聊天框体
	HideTabBG		= true,											-- 隐藏聊天栏背景
	TabColor1		= {1,0.75,0},									-- 当前聊天标题颜色
	TabColor2		= {0.5,0.5,0.5},								-- 未选择的聊天标题颜色
	Chatbar = {
		Width 		= 42,											-- 频道栏宽度
		Height 		= 10,											-- 频道栏高度
		Spacing 	= 3,											-- 频道栏间隔
	},
}

-- 地图
C.Maps = {
	Enable			= true,											-- 启用世界地图的额外元素
	IconSize		= 28,											-- 队友图标大小
}
C.Minimap = {
	Enable			= true,											-- 启用小地图
	Scale			= 1.2,											-- 小地图尺寸以1为基准增大/缩放
	Pos				= {"TOPRIGHT", UIParent, "TOPRIGHT", -7, -7},	-- 小地图位置
}

-- 姓名板
C.Nameplate = {
	Height			= 5,											-- 姓名板高度
	Width			= 120,											-- 姓名板宽度
	AuraSize		= 20,											-- 姓名板DEBUFF大小
}

-- 美化及皮肤
C.Skins = {
	EnableBag		= false,											-- 启用背包
	BagScale		= 1,											-- 背包尺寸以1为基准增大/缩放
	IconSize		= 34,											-- 背包栏大小
	MicroMenuPos 	= {"BOTTOM", UIParent, "BOTTOM", -118, 3},		-- 微型菜单坐标
	RMPos  			= {"TOP", UIParent, "TOP", 0, 0},				-- 团队工具默认坐标
}

-- 鼠标提示窗口
C.Tooltip = {
	Enable			= true,											-- 启用（总开关）
	Scale			= 1,											-- 窗口尺寸以1为基准增大/缩放
	Pos				= {"BOTTOMRIGHT", "BOTTOMRIGHT", -55, 230},		-- 窗口位置
}

-- 小工具
C.Sets = {
	Keyword			= "raid",										-- 关键字密语时自动邀请
	Cooldown		= true,											-- 插件的冷却计时，使用OmniCC等需禁用
}