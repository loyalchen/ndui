-- Configure
local _, C, _, _ = unpack(select(2, ...))
--[[
	>>>自定义添加时，要注意格式，注意逗号，注意字母大小写<<<
	AuraID支持BUFF和DEBUFF，在游戏中触发时，请鼠标移过去看看，或者自己查询数据库；
	UnitID是你想监视的目标，支持宠物pet，玩家自身player，目标target和焦点focus；
	SpellID只是用来监视技能的CD，直接鼠标到技能上就可以看到该ID，大部分情况下与其触发后的BUFF/DEBUFF ID不一样；
	Caster是法术的释放者，如果你没有标明，则任何释放该法术的都会被监视，例如猎人印记，元素诅咒等；
	Stack是部分法术的层数，未标明则全程监视，有标明则只在达到该层数后显示，例如DK鲜血充能仅在10层后才提示；
	Value，新增过滤，为true时启用，用于监视一些BUFF/DEBUFF的具体数值，如坦克的复仇，DK的血盾等等；
	SlotID，新增过滤，对应装备栏各部位，常用的有10手套，6腰带，15披风，13/14饰品栏（仅主动饰品）；
	TotemID，新增过滤，具体ID对应的是图腾位。武僧的玄牛算1号图腾，萨满1-4对应4个图腾；
	Timeless，新增过滤，具体例如萨满的闪电盾，因为持续1个小时，没有必要一直监视时间，启用timeless则只监视层数；
	Combat，新增过滤，启用时将仅在战斗中监视该buff，例如猎人的狙击训练，萨满的闪电护盾。
]]
C.AuraWatchList = {
	-- 全职业
	["ALL"] = {
		{	Name = "ActiveBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 377},
			List = {
				--狂暴（巨魔种族天赋）
				{AuraID =  26297, UnitID = "player"},
				--血性狂怒（兽人种族天赋）
				{AuraID =  20572, UnitID = "player"},
				{AuraID =  33697, UnitID = "player"},
		------>新版本附魔
				--血环之印
				{AuraID = 173322, UnitID = "player"},
				--雷神之印
				{AuraID = 159234, UnitID = "player"},
				--战歌之印
				{AuraID = 159675, UnitID = "player"},
				--霜狼之印
				{AuraID = 159676, UnitID = "player"},
				--影月之印
				{AuraID = 159678, UnitID = "player"},
				--黑石之印
				{AuraID = 159679, UnitID = "player"},
				--瞄准镜
				{AuraID = 156055, UnitID = "player"},--溅射
				{AuraID = 156061, UnitID = "player"},--爆击
				{AuraID = 173288, UnitID = "player"},--精通
				--橙戒
				{AuraID = 177161, UnitID = "player"},--敏捷690
				{AuraID = 177172, UnitID = "player"},--敏捷710
				{AuraID = 177159, UnitID = "player"},--智力690
				{AuraID = 177176, UnitID = "player"},--智力710
				{AuraID = 177160, UnitID = "player"},--力量690
				{AuraID = 177175, UnitID = "player"},--力量710
		------>新版本药水以及饰品
				--德拉诺敏捷
				{AuraID = 156423, UnitID = "player"},
				--德拉诺智力
				{AuraID = 156426, UnitID = "player"},
				--德拉诺力量
				{AuraID = 156428, UnitID = "player"},
				--德拉诺护甲
				{AuraID = 156430, UnitID = "player"},
				--炼金石
				{AuraID =  60233, UnitID = "player"},--敏捷
				{AuraID =  60229, UnitID = "player"},--力量
				{AuraID =  60234, UnitID = "player"},--智力
			---->坦克
				--暴击20s
				{AuraID = 162917, UnitID = "player"},
				--暴击10s
				{AuraID = 176982, UnitID = "player"},
				--急速10s
				{AuraID = 176937, UnitID = "player"},
				--使用，生命上限20s
				{AuraID = 176460, UnitID = "player"},
				--使用，精通20s
				{AuraID = 176876, UnitID = "player"},
				--精通10s
				{AuraID = 165824, UnitID = "player"},
				--护甲10s
				{AuraID = 177053, UnitID = "player"},
				--精通10s
				{AuraID = 177056, UnitID = "player"},
				--递增急速10s
				{AuraID = 177102, UnitID = "player"},
			---->力量dps
				--全能10s
				{AuraID = 176974, UnitID = "player"},
				--精通10s
				{AuraID = 176935, UnitID = "player"},
				--使用，力量10s
				{AuraID = 177189, UnitID = "player"},
				--暴击10s
				{AuraID = 177040, UnitID = "player"},
				--使用，溅射15s
				{AuraID = 176874, UnitID = "player"},
				--精通10s
				{AuraID = 177042, UnitID = "player"},
				--递增暴击10s
				{AuraID = 177096, UnitID = "player"},
			---->敏捷dps
				--暴击20s
				{AuraID = 162915, UnitID = "player"},
				--溅射10s
				{AuraID = 176984, UnitID = "player"},
				--精通10s
				{AuraID = 176939, UnitID = "player"},
				--使用，敏捷20s
				{AuraID = 177597, UnitID = "player"},
				--溅射10s
				{AuraID = 177038, UnitID = "player"},
				--急速10s
				{AuraID = 177035, UnitID = "player"},
				--使用，溅射20s
				{AuraID = 176878, UnitID = "player"},
				--递增暴击10s
				{AuraID = 177067, UnitID = "player", Value = true},
				--PVP饰品
				{AuraID = 126707, UnitID = "player"},
				--使用，精通
				{AuraID = 165485, UnitID = "player"},
			---->法系dps
				--暴击20s
				{AuraID = 162919, UnitID = "player"},
				--急速10s
				{AuraID = 176980, UnitID = "player"},
				--使用，急速20s
				{AuraID = 176875, UnitID = "player"},
				--精通10s
				{AuraID = 176941, UnitID = "player"},
				--使用，法强20s
				{AuraID = 177594, UnitID = "player"},
				--暴击10s
				{AuraID = 177046, UnitID = "player"},
				--急速10s
				{AuraID = 177051, UnitID = "player"},
				--递增暴击10s
				{AuraID = 177081, UnitID = "player"},
			---->治疗
				--精神10s
				{AuraID = 162913, UnitID = "player"},
				--精通10s
				{AuraID = 176943, UnitID = "player"},
				--使用，法力值20s
				{AuraID = 177592, UnitID = "player"},
				--暴击10s
				{AuraID = 176978, UnitID = "player"},
				--使用，急速20s
				{AuraID = 176879, UnitID = "player"},
				--溅射10s
				{AuraID = 177063, UnitID = "player"},
				--精神10s
				{AuraID = 177060, UnitID = "player"},
				--递增急速10s
				{AuraID = 177086, UnitID = "player"},
		------>6.2饰品
			---->敏捷
				--触发敏捷
				{AuraID = 183926, UnitID = "player"},
				--储能爆炸
				{AuraID = 184293, UnitID = "player"},
			---->力量
				--触发力量
				{AuraID = 183941, UnitID = "player"},
				--阿克狂暴战
				{AuraID = 185230, UnitID = "player"},
				--阿克惩戒骑
				{AuraID = 185102, UnitID = "player"},
			---->法系
				--阿克暗牧
				{AuraID = 184915, UnitID = "player"},
				--阿克毁灭
				{AuraID = 185229, UnitID = "player"},
				--触发智力
				{AuraID = 183924, UnitID = "player"},
				--AOE饰品
				{AuraID = 184073, UnitID = "player"},
			---->治疗
				--阿克奶骑
				{AuraID = 185100, UnitID = "player"},
				--阿克戒律牧
				{AuraID = 184912, UnitID = "player"},
				--使用加爆击
				{AuraID = 183929, UnitID = "player"},
				--吸血效果
				{AuraID = 184671, UnitID = "player"},
			---->坦克
				--触发精通
				{AuraID = 183931, UnitID = "player"},
				--触发耐力
				{AuraID = 184770, UnitID = "player"},
			},
		},
		{	Name = "RaidBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 45,
			Pos = {"CENTER", UIParent, "CENTER", -220, 200},
			List = {
				--变羊
				{AuraID =    118, UnitID = "player"},
				--制裁之锤
				{AuraID =    853, UnitID = "player"},
				--肾击
				{AuraID =    408, UnitID = "player"},
				--撕扯
				{AuraID =  47481, UnitID = "player"},
				--沉默
				{AuraID =  55021, UnitID = "player"},
				--割碎
				{AuraID =  22570, UnitID = "player"},
				--断筋
				{AuraID =   1715, UnitID = "player"},

				--时间扭曲
				{AuraID =  80353, UnitID = "player"},
				--嗜血
				{AuraID =   2825, UnitID = "player"},
				--英勇
				{AuraID =  32182, UnitID = "player"},
				--熔岩犬：远古狂乱
				{AuraID =  90355, UnitID = "player"},
				--虚空鳐：虚空之风
				{AuraID = 160452, UnitID = "player"},
				--鼓
				{AuraID = 178207, UnitID = "player"},
				--火箭靴
				{AuraID =  54861, UnitID = "player"},

				--豹群
				{AuraID =  13159, UnitID = "player"},
				--狂奔怒吼
				{AuraID =  77761, UnitID = "player"},
				{AuraID =  77764, UnitID = "player"},
				{AuraID = 106898, UnitID = "player"},
				--虔诚光环
				{AuraID =  31821, UnitID = "player"},
				--集结呐喊
				{AuraID =  97463, UnitID = "player"},
				--神圣赞美诗
				{AuraID =  64843, UnitID = "player"},
				--真言术：障
				{AuraID =  81782, UnitID = "player"},
				--反魔法领域
				{AuraID = 145629, UnitID = "player"},
				--烟雾弹
				{AuraID =  88611, UnitID = "player"},
				--五气归元
				{AuraID = 115310, UnitID = "player"},
				--蟠龙之息
				{AuraID = 157535, UnitID = "player"},
				--作茧缚命
				{AuraID = 116849, UnitID = "player"},
				--警戒
				{AuraID = 114030, UnitID = "player"},
				--保护之手
				{AuraID =   1022, UnitID = "player"},
				--拯救之手
				{AuraID =   1038, UnitID = "player"},
				--牺牲之手
				{AuraID =   6940, UnitID = "player"},
				--纯净之手
				{AuraID = 114039, UnitID = "player"},
				--铁木树皮
				{AuraID = 102342, UnitID = "player"},
				--守护之魂
				{AuraID =  47788, UnitID = "player"},
				--痛苦压制
				{AuraID =  33206, UnitID = "player"},
				--圣光道标
				{AuraID =  53563, UnitID = "player"},
				--信阳道标
				{AuraID = 156910, UnitID = "player"},
				--灵魂连接图腾
				{AuraID =  98007, UnitID = "player"},
				--风行图腾
				{AuraID = 114896, UnitID = "player"},
				--群体反射
				{AuraID = 114028, UnitID = "player"},
			},
		},
		{	Name = "RaidDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 45,
			Pos = {"CENTER", UIParent, "CENTER", 0, 200},
			List = {
		-->悬槌堡
			--卡加斯·刃拳
				--迸裂创伤
				{AuraID = 159178, UnitID = "player"},
				--刺穿
				{AuraID = 159113, UnitID = "player"},
				--老虎盯人
				{AuraID = 162497, UnitID = "player"},
				--屠夫：捶肉槌
				{AuraID = 156151, UnitID = "player"},
				--龟裂创伤
				{AuraID = 156152, UnitID = "player"},
			--深渊行者布兰肯斯波
				--溃烂
				{AuraID = 163241, UnitID = "player"},
				--烧苔藓
				{AuraID = 165223, UnitID = "player"},
				--寄生孢子
				{AuraID = 163242, UnitID = "player"},
			--泰克图斯
				--石化
				{AuraID = 162892, UnitID = "player"},
			--独眼魔双子
				--双子小怪，奥能动荡
				{AuraID = 166200, UnitID = "player"},
				--弱化防御
				{AuraID = 159709, UnitID = "player"},
				--致衰咆哮
				{AuraID = 158026, UnitID = "player"},
				--奥术之伤
				{AuraID = 167200, UnitID = "player"},
				--扭曲奥能
				{AuraID = 163297, UnitID = "player"},
				--M5奥能动荡，分散
				{AuraID = 163372, UnitID = "player"},
			--克拉戈
				--废灵璧垒
				{AuraID = 163134, UnitID = "player", Value = true},
				--魔能散射邪能
				{AuraID = 172895, UnitID = "player"},
			--元首马尔高克
				--混沌标记（换坦）
				{AuraID = 158605, UnitID = "player"},	--P1
				{AuraID = 164176, UnitID = "player"},	--P2
				{AuraID = 164178, UnitID = "player"},	--P3
				{AuraID = 164191, UnitID = "player"},	--P4
				--拘禁
				{AuraID = 158619, UnitID = "player"},
				--烙印
				{AuraID = 156225, UnitID = "player"},	--P1
				{AuraID = 164004, UnitID = "player"},	--P2
				{AuraID = 164005, UnitID = "player"},	--P3
				{AuraID = 164006, UnitID = "player"},	--P4
				--锁定
				{AuraID = 157763, UnitID = "player"},
				--减速
				{AuraID = 157801, UnitID = "player"},
				--毁灭共鸣
				{AuraID = 159200, UnitID = "player"},
				{AuraID = 174106, UnitID = "player"},
		-->黑石铸造厂
			--格鲁尔
				--石化
				{AuraID = 155330, UnitID = "player"},
				{AuraID = 155506, UnitID = "player"},
				--炼狱切割
				{AuraID = 155080, UnitID = "player"},
				--M火耀石
				{AuraID = 165298, UnitID = "player"},
			--奥尔高格
				--酸液洪流，ST
				{AuraID = 156297, UnitID = "player"},
				--酸液巨口，MT
				{AuraID = 173471, UnitID = "player"},
				--翻滚之怒
				{AuraID = 155900, UnitID = "player"},
			--爆裂熔炉
				--高热，T
				{AuraID = 155242, UnitID = "player"},
				--熔化
				{AuraID = 155225, UnitID = "player"},
				--锁定
				{AuraID = 155196, UnitID = "player"},
				--不稳定的火焰
				{AuraID = 176121, UnitID = "player"},
				--炸弹
				{AuraID = 178279, UnitID = "player"},
				{AuraID = 155192, UnitID = "player"},
			--汉斯加尔与弗兰佐克 
				--折脊碎椎
				{AuraID = 157139, UnitID = "player"},
				--干扰怒吼
				{AuraID = 160838, UnitID = "player"},
				{AuraID = 160845, UnitID = "player"},
				{AuraID = 160847, UnitID = "player"},
				{AuraID = 160848, UnitID = "player"},
				--灼热燃烧
				{AuraID = 155818, UnitID = "player"},
			--缚火者卡格拉兹
				--锁定
				{AuraID = 154952, UnitID = "player"},
				--焦灼吐息，T
				{AuraID = 155074, UnitID = "player"},
				--升腾烈焰，T
				{AuraID = 163284, UnitID = "player"},
				--火焰链接
				{AuraID = 155049, UnitID = "player"},
				--熔岩激流
				{AuraID = 154932, UnitID = "player"},
				--炽热光辉
				{AuraID = 155277, UnitID = "player"},
			--克罗莫格
				--扭曲护甲，T
				{AuraID = 156766, UnitID = "player"},
				--纠缠之地符文
				{AuraID = 157059, UnitID = "player"},
				--破碎大地符文
				{AuraID = 161923, UnitID = "player"},
				{AuraID = 161839, UnitID = "player"},
			--兽王达玛克
				--狂乱撕扯，T
				{AuraID = 155061, UnitID = "player"},
				{AuraID = 162283, UnitID = "player"},
				--炽燃利齿，T
				{AuraID = 155030, UnitID = "player"},
				--碾碎护甲，T
				{AuraID = 155236, UnitID = "player"},
				--爆燃
				{AuraID = 154981, UnitID = "player"},
				--高热弹片
				{AuraID = 155499, UnitID = "player"},
				--M地动山摇
				{AuraID = 162276, UnitID = "player"},
				{AuraID = 155826, UnitID = "player"},
			--主管索戈尔
				--点燃，T
				{AuraID = 155921, UnitID = "player"},
				--定时炸弹
				{AuraID = 159481, UnitID = "player"},
				--实验型脉冲手雷
				{AuraID = 165195, UnitID = "player"},
				--M燃烧
				{AuraID = 164380, UnitID = "player"},
				--M热能冲击
				{AuraID = 164280, UnitID = "player"},
			--女武神
				--急速射击
				{AuraID = 156631, UnitID = "player"},
				--穿透射击
				{AuraID = 164271, UnitID = "player"},
				--震颤暗影
				{AuraID = 156214, UnitID = "player"},
				--鲜血仪式
				{AuraID = 159724, UnitID = "player"},
				--锁定
				{AuraID = 158702, UnitID = "player"},
				--致命投掷
				{AuraID = 158692, UnitID = "player"},
				--暗影猎杀
				{AuraID = 158315, UnitID = "player"},
			--黑手
				--坦克盯人
				{AuraID = 156653, UnitID = "player"},
				--死亡标记
				{AuraID = 156096, UnitID = "player"},
				--穿刺
				{AuraID = 156743, UnitID = "player"},
				{AuraID = 175020, UnitID = "player"},
				--断骨
				{AuraID = 157354, UnitID = "player"},
				--熔渣冲击
				{AuraID = 156047, UnitID = "player"},
				{AuraID = 157018, UnitID = "player"},
				{AuraID = 157322, UnitID = "player"},
				--巨力粉碎猛击
				{AuraID = 158054, UnitID = "player"},
				--熔火熔渣
				{AuraID = 156401, UnitID = "player"},
				--投掷熔渣炸弹
				{AuraID = 159179, UnitID = "player"},
				--投掷熔渣炸弹，T
				{AuraID = 157000, UnitID = "player"},
		--地狱火堡垒
			--奇袭地狱火
				--啸风战斧
				{AuraID = 184379, UnitID = "player"},
				--钻孔
				{AuraID = 180022, UnitID = "player"},
				--灼烧
				{AuraID = 185157, UnitID = "player"},
			--钢铁掠夺者
				--炮击
				{AuraID = 182280, UnitID = "player"},
				--染料污渍
				{AuraID = 182003, UnitID = "player"},
				--献祭
				{AuraID = 182074, UnitID = "player"},
			--考莫克
				--攫取之手
				{AuraID = 181345, UnitID = "player"},
				--邪能之触
				{AuraID = 181321, UnitID = "player"},
				--爆裂冲击
				{AuraID = 181306, UnitID = "player"},
			--地狱火高阶议会
				--堕落狂怒
				{AuraID = 184360, UnitID = "player"},
				--酸性创伤
				{AuraID = 184847, UnitID = "player"},
				--血液沸腾M
				{AuraID = 184355, UnitID = "player"},
				--死灵印记
				{AuraID = 184449, UnitID = "player"},
				{AuraID = 184450, UnitID = "player"},
				{AuraID = 184676, UnitID = "player"},
				{AuraID = 185065, UnitID = "player"},
				{AuraID = 185066, UnitID = "player"},
			--基尔罗格
				--恶魔腐化
				{AuraID = 182159, UnitID = "player"},
				{AuraID = 184396, UnitID = "player"},
				--不朽决心
				{AuraID = 180718, UnitID = "player"},
				--撕碎护甲
				{AuraID = 180200, UnitID = "player"},
			--血魔
				--消化
				{AuraID = 181295, UnitID = "player"},
				--嗜命
				{AuraID = 180148, UnitID = "player"},
				--毁灭之触
				{AuraID = 179977, UnitID = "player"},
			--暗影领主伊斯卡
				--幻影之伤
				{AuraID = 182325, UnitID = "player"},
				--幻影腐蚀
				{AuraID = 181824, UnitID = "player"},
				--邪能炸弹
				{AuraID = 181753, UnitID = "player"},
				--邪能飞轮
				{AuraID = 182178, UnitID = "player"},
			--永恒者索奎萨尔
				--粉碎防御
				{AuraID = 182038, UnitID = "player"},
				--易爆的邪能宝珠
				{AuraID = 189627, UnitID = "player"},
				--邪能牢笼
				{AuraID = 180415, UnitID = "player"},
				--堕落者之赐
				{AuraID = 184124, UnitID = "player"},
				--魅影重重
				{AuraID = 182769, UnitID = "player"},
				--暗言术：恶
				{AuraID = 184239, UnitID = "player"},
				--恶毒鬼魅
				{AuraID = 182900, UnitID = "player"},
				--永世饥渴
				{AuraID = 188666, UnitID = "player"},
			--女暴君维哈里
				--凋零契印
				{AuraID = 180000, UnitID = "player"},
				--腐蚀序列
				{AuraID = 180526, UnitID = "player"},
			--恶魔领主扎昆
				--魂不附体
				{AuraID = 179407, UnitID = "player"},
				--玷污
				{AuraID = 189032, UnitID = "player"},
				{AuraID = 189031, UnitID = "player"},
				{AuraID = 189030, UnitID = "player"},
				--毁灭之种
				{AuraID = 181515, UnitID = "player"},
			--祖霍拉克
				--邪蚀
				{AuraID = 186134, UnitID = "player"},
				--灵媒
				{AuraID = 186135, UnitID = "player"},
				--邪影屠戮
				{AuraID = 185656, UnitID = "player"},
				--魔能喷涌
				{AuraID = 186407, UnitID = "player"},
				--灵能涌动
				{AuraID = 186333, UnitID = "player"},
			--玛诺洛斯
				--末日印记
				{AuraID = 181099, UnitID = "player"},
				--末日之刺
				{AuraID = 189717, UnitID = "player"},
				--强化暗影之力
				{AuraID = 182088, UnitID = "player"},
			--阿克蒙德
				--暗影爆破
				{AuraID = 183864, UnitID = "player"},
				--锁定
				{AuraID = 182879, UnitID = "player"},
				--束缚折磨
				{AuraID = 184964, UnitID = "player"},
			},
		},
		{	Name = "Warning",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 42,
			Pos = {"CENTER", UIParent, "CENTER", 220, -80},
			List = {
			-->悬槌堡
				--M1老虎易伤
				{AuraID = 163130, UnitID = "target"},
				--M1BOSS易伤
				{AuraID = 159029, UnitID = "target"},
				--克拉戈废灵璧垒
				{AuraID = 156803, UnitID = "target", Value = true},
			-->黑石铸造厂
				--1震地暴怒
				{AuraID = 155539, UnitID = "target"},
				--2黑石弹幕
				{AuraID = 156834, UnitID = "target"},
				--2如饥似渴
				{AuraID = 155819, UnitID = "target"},
				--3减伤护盾
				{AuraID = 155176, UnitID = "target"},
				--3护盾消失
				{AuraID = 158345, UnitID = "target"},
				--3大地反馈护盾
				{AuraID = 155173, UnitID = "target"},
				--5过热
				{AuraID = 154950, UnitID = "target"},
				--5烈焰之怒
				{AuraID = 163273, UnitID = "target"},
				--6雷霆轰击
				{AuraID = 157054, UnitID = "target"},
				--6狂暴
				{AuraID = 156861, UnitID = "target"},
				--7野蛮怒吼
				{AuraID = 155208, UnitID = "target"},
				--7防御
				{AuraID = 160382, UnitID = "target"},
				--M7势不可挡
				{AuraID = 155321, UnitID = "target"},
				--8呵斥
				{AuraID = 156281, UnitID = "target"},
				--9钢铁意志
				{AuraID = 159336, UnitID = "target"},
				--9利刃沖刺
				{AuraID = 155794, UnitID = "target"},
				--9土之壁垒
				{AuraID = 158708, UnitID = "target"},
				--坦克过载
				{AuraID = 159199, UnitID = "target"},
				--坦克易伤
				{AuraID = 157322, UnitID = "target"},
				--坦克黑铁铠甲
				{AuraID = 156667, UnitID = "target"},
			-->地狱火堡垒
				--血魔，灵魂盛宴
				{AuraID = 181973, UnitID = "target"},
				--永恒者索奎萨尔，邪能壁垒
				{AuraID = 184053, UnitID = "target"},
				--永恒者索奎萨尔，染血追踪者
				{AuraID = 188767, UnitID = "target"},
				--女暴君维哈里，统御者壁垒
				{AuraID = 180040, UnitID = "target"},
				--祖霍拉克，混乱压制
				{AuraID = 187204, UnitID = "target"},
			-->PLAYER
				--痛苦压制
				{AuraID =  33206, UnitID = "target"},
				--盾墙
				{AuraID =    871, UnitID = "target"},
				--冰封之韧
				{AuraID =  48792, UnitID = "target"},
				--反魔法护罩
				{AuraID =  48707, UnitID = "target"},
				--保护之手
				{AuraID =   1022, UnitID = "target"},
				--生存本能
				{AuraID =  61336, UnitID = "target"},
				--威慑
				{AuraID = 148467, UnitID = "target"},
				{AuraID =  19263, UnitID = "target"},
				--寒冰屏障
				{AuraID =  45438, UnitID = "target"},
				--强化隐形术
				{AuraID = 113862, UnitID = "target"},
				--剑在人在
				{AuraID = 118038, UnitID = "target"},
				--法术反射
				{AuraID =  23920, UnitID = "target"},
				--升腾
				{AuraID = 114050, UnitID = "target"},	--元素
				{AuraID = 114051, UnitID = "target"},	--增强
				{AuraID = 114052, UnitID = "target"},	--恢复
				--圣佑术
				{AuraID =    498, UnitID = "target"},
				--圣盾术
				{AuraID =    642, UnitID = "target"},
				--自由之手
				{AuraID =   1044, UnitID = "target"},
				--复仇之怒
				{AuraID =  31842, UnitID = "target"},	--神圣
				{AuraID =  31884, UnitID = "target"},	--惩戒
				--狂野怒火
				{AuraID =  19574, UnitID = "target"},
				--急速射击
				{AuraID =   3045, UnitID = "target"},
				--不灭决心
				{AuraID = 104773, UnitID = "target"},
				--黑暗交易
				{AuraID = 110913, UnitID = "target"},
				--闪避
				{AuraID =   5277, UnitID = "target"},
				--壮胆酒
				{AuraID = 120954, UnitID = "target"},
				--躯不坏
				{AuraID = 122278, UnitID = "target"},
				--散魔功
				{AuraID = 122783, UnitID = "target"},
				--爱情光线
				{AuraID = 171607, UnitID = "target"},
			},
		},
	},

	-- 德鲁伊
	["DRUID"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--潜行
				{AuraID =   5215, UnitID = "player"},
				--回春术
				{AuraID =    774, UnitID = "player"},
				--生命绽放
				{AuraID =  33763, UnitID = "player"},
				--急奔
				{AuraID =   1850, UnitID = "player"},
				--野性位移
				{AuraID = 137452, UnitID = "player"},
				--野性冲锋：泳速
				{AuraID = 102416, UnitID = "player"},
				--塞纳里奥结界
				{AuraID = 102351, UnitID = "player"},
				--野性之心
				{AuraID = 108291, UnitID = "player"},
				{AuraID = 108292, UnitID = "player"},
				{AuraID = 108293, UnitID = "player"},
				{AuraID = 108294, UnitID = "player"},
				--掠食者的迅捷(猫)
				{AuraID =  69369, UnitID = "player"},
				--尖牙与利爪(熊)
				{AuraID = 135286, UnitID = "player"},
			},
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--野性冲锋：晕眩
				{AuraID =  50259, UnitID = "target", Caster = "player"},
				--野性冲锋：定身
				{AuraID =  45334, UnitID = "target", Caster = "player"},
				--台风：晕眩
				{AuraID =  61391, UnitID = "target", Caster = "player"},
				--纠缠根须
				{AuraID =    339, UnitID = "target", Caster = "player"},
				--群体缠绕
				{AuraID = 102359, UnitID = "target", Caster = "player"},
				--蛮力猛击
				{AuraID =   5211, UnitID = "target", Caster = "player"},
				--夺魂咆哮
				{AuraID =     99, UnitID = "target", Caster = "player"},
				--割裂(猫)
				{AuraID =   1079, UnitID = "target", Caster = "player"},
				--斜掠(猫)
				{AuraID = 155722, UnitID = "target", Caster = "player"},
				--割碎(猫)
				{AuraID =  22570, UnitID = "target", Caster = "player"},
				--割伤(熊)
				{AuraID =  33745, UnitID = "target", Caster = "player"},
				--月火术(鸟)
				{AuraID = 164812, UnitID = "target", Caster = "player"},
				{AuraID = 155625, UnitID = "target", Caster = "player"},
				--阳炎术(鸟)
				{AuraID = 164815, UnitID = "target", Caster = "player"},
				--星辰耀斑(鸟)
				{AuraID = 152221, UnitID = "target", Caster = "player"},
				--日光术(鸟)
				{AuraID =  81261, UnitID = "target", Caster = "player"},
				--回春术
				{AuraID =    774, UnitID = "target", Caster = "player"},
				--生命绽放(奶)
				{AuraID =  33763, UnitID = "target", Caster = "player"},
				--铁木树皮(奶)
				{AuraID = 102342, UnitID = "target", Caster = "player"},
				--源生(奶)
				{AuraID = 162359, UnitID = "target", Caster = "player"},
				--萌芽(奶)
				{AuraID = 155777, UnitID = "target", Caster = "player"},
				--愈合
				{AuraID =   8936, UnitID = "target", Caster = "player"},
				--痛击
				{AuraID = 106830, UnitID = "target", Caster = "player"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--树皮术
				{AuraID =  22812, UnitID = "player"},
				--生存本能
				{AuraID =  61336, UnitID = "player"},
				--自然的守护
				{AuraID = 124974, UnitID = "player"},
				--化身
				{AuraID = 102560, UnitID = "player"},
				{AuraID = 117679, UnitID = "player"},
				{AuraID = 102558, UnitID = "player"},
				{AuraID = 102543, UnitID = "player"},
				--节能施法
				{AuraID =  16870, UnitID = "player"},
				{AuraID = 135700, UnitID = "player"},
				--星辰坠落(鸟)
				{AuraID =  48505, UnitID = "player"},
				--超凡之盟(鸟)
				{AuraID = 112071, UnitID = "player"},
				--月之巅(鸟)
				{AuraID = 171743, UnitID = "player"},
				--日之巅(鸟)
				{AuraID = 171744, UnitID = "player"},
				--日光增效(鸟)
				{AuraID = 164545, UnitID = "player"},
				--月光增效(鸟)
				{AuraID = 164547, UnitID = "player"},
				--强化枭兽(鸟)
				{AuraID = 157228, UnitID = "player"},
				--猛虎之怒(猫)
				{AuraID =   5217, UnitID = "player"},
				--野蛮咆哮(猫)
				{AuraID =  52610, UnitID = "player"},
				{AuraID = 174544, UnitID = "player"},
				--血腥爪击(猫)
				{AuraID = 145152, UnitID = "player"},
				--狂暴(熊,猫)
				{AuraID =  50334, UnitID = "player"},
				{AuraID = 106951, UnitID = "player"},
				--野蛮防御(熊)
				{AuraID = 132402, UnitID = "player"},
				--鬃毛倒竖(熊)
				{AuraID = 155835, UnitID = "player"},
				--粉碎(熊)
				{AuraID = 158792, UnitID = "player"},
				--巨熊之力(熊)
				{AuraID = 159233, UnitID = "player", Value = true},
				--相生(奶)
				{AuraID = 100977, UnitID = "player"},
				--丛林之魂(奶)
				{AuraID = 114108, UnitID = "player"},
				--洞察秋毫(奶)
				{AuraID = 155631, UnitID = "player"},
				--自然的睿智
				{AuraID = 167715, UnitID = "player"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--月火术(鸟)
				{AuraID = 164812, UnitID = "focus", Caster = "player"},
				{AuraID = 155625, UnitID = "focus", Caster = "player"},
				--阳炎术(鸟)
				{AuraID = 164815, UnitID = "focus", Caster = "player"},
				--星辰耀斑(鸟)
				{AuraID = 152221, UnitID = "focus", Caster = "player"},
				--生命绽放
				{AuraID =  33763, UnitID = "focus", Caster = "player"},
				--回春术
				{AuraID =    774, UnitID = "focus", Caster = "player"},
				--萌芽
				{AuraID = 155777, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--生存本能
				{SpellID = 61336, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
				--蘑菇
				{TotemID =     1, UnitID = "player"},
				{TotemID =     2, UnitID = "player"},
				{TotemID =     3, UnitID = "player"},
			},
		},
	},
	
	-- 猎人
	["HUNTER"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--误导
				{AuraID =  35079, UnitID = "player"},
				--陷阱发射器
				{AuraID =  77769, UnitID = "player"},
				--伪装
				{AuraID =  51755, UnitID = "player"},
				--迅疾如风
				{AuraID = 118922, UnitID = "player"},
				--灵魂治愈
				{AuraID =  90361, UnitID = "player"},
				--生存专家
				{AuraID = 164857, UnitID = "player"},
				--独来独往
				{AuraID = 164273, UnitID = "player"},
				--猎豹守护
				{AuraID =   5118, UnitID = "player"},
			},
		},	
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--毒蛇钉刺
				{AuraID = 118253, UnitID = "target", Caster = "player"},
				--毒液弹
				{AuraID = 162543, UnitID = "target", Caster = "player"},
				--寒冰弹
				{AuraID = 162546, UnitID = "target", Caster = "player"},
				--黑箭
				{AuraID =   3674, UnitID = "target", Caster = "player"},
				--爆炸射击
				{AuraID =  53301, UnitID = "target", Caster = "player"},
				--震荡射击
				{AuraID =   5116, UnitID = "target", Caster = "player"},
				--扰乱射击
				{AuraID =  20736, UnitID = "target", Caster = "player"},
				--险境求生
				{AuraID = 136634, UnitID = "target", Caster = "player"},
				--夺命黑鸦
				{AuraID = 131894, UnitID = "target", Caster = "player"},
				--爆炸陷阱
				{AuraID =  13812, UnitID = "target", Caster = "player"},
				--冰霜陷阱：诱捕
				{AuraID = 135373, UnitID = "target", Caster = "player"},
				--束缚射击
				{AuraID = 117526, UnitID = "target"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--治疗宠物
				{AuraID =    136, UnitID = "pet"},
				--威慑
				{AuraID = 148467, UnitID = "player"},
				{AuraID =  19263, UnitID = "player"},
				--主人的召唤
				{AuraID =  54216, UnitID = "player"},
				--狩猎刺激
				{AuraID =  34720, UnitID = "player"},
				--稳固集中
				{AuraID = 177668, UnitID = "player"},
				--荷枪实弹
				{AuraID = 168980, UnitID = "player"},
				--威猛射击4T17
				{AuraID = 167165, UnitID = "player"},
				--狂乱
				{AuraID =  19615, UnitID = "pet"},
				--野兽瞬劈斩
				{AuraID = 118455, UnitID = "pet"},
				--集中火力
				{AuraID =  82692, UnitID = "player"},
				--狂野怒火
				{AuraID =  19574, UnitID = "player"},
				--狂轰滥炸
				{AuraID =  82921, UnitID = "player"},
				--急速射击
				{AuraID =   3045, UnitID = "player"},
				--狙击训练
				{AuraID = 168811, UnitID = "player", Combat = true},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--毒蛇钉刺
				{AuraID = 118253, UnitID = "focus", Caster = "player"},
				--黑箭
				{AuraID =   3674, UnitID = "focus", Caster = "player"},
				--夺命黑鸦
				{AuraID = 131894, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--群兽奔腾
				{SpellID =121818, UnitID = "player"},
				--急速射击
				{SpellID =  3045, UnitID = "player"},
				--威慑
				{SpellID =148467, UnitID = "player"},
				{SpellID = 19263, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
			},
		},
	},
	
	-- 法师
	["MAGE"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--寒冰护体
				{AuraID =  11426, UnitID = "player"},
				--隐形术
				{AuraID =  32612, UnitID = "player"},
				--强化隐形术
				{AuraID = 110960, UnitID = "player"},
				--缓落
				{AuraID =    130, UnitID = "player"},
				--灸灼
				{AuraID =  87023, UnitID = "player"},
			},
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {		
				--燃烧(火)
				{AuraID =  83853, UnitID = "target", Caster = "player"},
				--点燃(火)
				{AuraID =  12654, UnitID = "target", Caster = "player"},
				--炎爆术(火)
				{AuraID =  11366, UnitID = "target", Caster = "player"},
				--活动炸弹(火)
				{AuraID =  44457, UnitID = "target", Caster = "player"},
				--龙息术(火)
				{AuraID =  31661, UnitID = "target", Caster = "player"},
				--变形术
				{AuraID =    118, UnitID = "target", Caster = "player"},
				--冰霜新星
				{AuraID =    122, UnitID = "target", Caster = "player"},
				--冰霜之环
				{AuraID =  82691, UnitID = "target", Caster = "player"},
				--减速
				{AuraID =  31589, UnitID = "target", Caster = "player"},
				--虚空风暴
				{AuraID = 114923, UnitID = "target", Caster = "player"},
				--深度冻结
				{AuraID =  44572, UnitID = "target", Caster = "player"},
				--寒冰炸弹
				{AuraID = 112948, UnitID = "target", Caster = "player"},
				--冰霜之颌
				{AuraID = 102051, UnitID = "target", Caster = "player"},
				--寒冰箭
				{AuraID =    116, UnitID = "target", Caster = "player"},
				--冰锥术
				{AuraID =    120, UnitID = "target", Caster = "player"},
				--寒冰新星
				{AuraID = 157997, UnitID = "target", Caster = "player"},
				--冻结
				{AuraID = 111340, UnitID = "target", Caster = "player"},
				--冰冻术
				{AuraID =  33395, UnitID = "target", Caster = "pet"},
				--水流喷射
				{AuraID = 135029, UnitID = "target", Caster = "pet"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--寒冰屏障
				{AuraID =  45438, UnitID = "player"},
				--隐没
				{AuraID = 157913, UnitID = "player"},
				--炽热疾速
				{AuraID = 108843, UnitID = "player"},
				--咒术洪流
				{AuraID = 116267, UnitID = "player"},
				--能量符文
				{AuraID = 116014, UnitID = "player"},
				--操控时间
				{AuraID = 110909, UnitID = "player"},
				--热力迸发(火)
				{AuraID =  48107, UnitID = "player"},
				--浮冰
				{AuraID = 108839, UnitID = "player"},
				--气定神闲
				{AuraID =  12043, UnitID = "player"},
				--奥术充能
				{AuraID =  36032, UnitID = "player"},
				--奥术飞弹!
				{AuraID =  79683, UnitID = "player"},
				--奥术强化
				{AuraID =  12042, UnitID = "player"},
				--冰冷血脉
				{AuraID =  12472, UnitID = "player"},
				--寒冰指
				{AuraID =  44544, UnitID = "player"},
				--冰冷智慧
				{AuraID =  57761, UnitID = "player"},
				--冰霜结界
				{AuraID = 111264, UnitID = "player"},
				--强化隐形术
				{AuraID = 113862, UnitID = "player"},
				--炎爆术！
				{AuraID =  48108, UnitID = "player"},
				--奥术动荡4T17
				{AuraID = 166872, UnitID = "player"},
				--奥术亲和2T17
				{AuraID = 166871, UnitID = "player"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--活动炸弹(火)
				{AuraID =  44457, UnitID = "focus", Caster = "player"},
				--虚空风暴
				{AuraID = 114923, UnitID = "focus", Caster = "player"},
				--寒冰炸弹
				{AuraID = 112948, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--冰冷血脉
				{SpellID = 12472, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
				--能量符文
				{TotemID =     1, UnitID = "player"},
				{TotemID =     2, UnitID = "player"},
			},
		},
	},
	
	-- 战士
	["WARRIOR"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--胜利
				{AuraID =  32216, UnitID = "player"},
				--致死打击雕文
				{AuraID =  12294, UnitID = "player"},
				--破坏者
				{AuraID = 152277, UnitID = "player"},
				--剑盾猛攻
				{AuraID =  50227, UnitID = "player"},
				--挑战战旗
				{AuraID = 114192, UnitID = "player"},
				--血脉喷张
				{AuraID =  46916, UnitID = "player"},
				--怒击
				{AuraID = 131116, UnitID = "player"},
				--最后通牒
				{AuraID = 122510, UnitID = "player"},
			},
		},	
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--撕裂
				{AuraID =    772, UnitID = "target", Caster = "player"},
				--重伤
				{AuraID = 115767, UnitID = "target", Caster = "player"},
				--冲锋：昏迷
				{AuraID =   7922, UnitID = "target", Caster = "player"},
				--冲锋：定身
				{AuraID = 105771, UnitID = "target", Caster = "player"},
				--震荡波
				{AuraID = 132168, UnitID = "target", Caster = "player"},
				--断筋
				{AuraID =   1715, UnitID = "target", Caster = "player"},
				--风暴之锤
				{AuraID = 132169, UnitID = "target", Caster = "player"},
				--破胆
				{AuraID =   5246, UnitID = "target", Caster = "player"},
				--巨人打击
				{AuraID = 167105, UnitID = "target", Caster = "player"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--剑在人在
				{AuraID = 118038, UnitID = "player"},
				--英勇飞跃雕文
				{AuraID = 133278, UnitID = "player"},
				--狂暴回复
				{AuraID =  55694, UnitID = "player"},
				--猛击
				{AuraID =   1464, UnitID = "player"},
				--鲁莽
				{AuraID =   1719, UnitID = "player"},
				--浴血奋战
				{AuraID =  12292, UnitID = "player"},
				--天神下凡
				{AuraID = 107574, UnitID = "player"},
				--粗暴打断
				{AuraID =  86663, UnitID = "player"},
				--横扫攻击
				{AuraID =  12328, UnitID = "player"},
				--狂暴之怒
				{AuraID =  18499, UnitID = "player"},
				--不屈打击
				{AuraID = 169686, UnitID = "player", Stack = 6},
				--挫志怒吼
				{AuraID = 125565, UnitID = "player"},
				--法术反射
				{AuraID =  23920, UnitID = "player"},
				--破釜沉舟
				{AuraID =  12975, UnitID = "player"},
				--盾墙
				{AuraID =    871, UnitID = "player"},
				--盾牌屏障
				{AuraID = 112048, UnitID = "player", Value = true},
				--盾牌格挡
				{AuraID = 132404, UnitID = "player"},
				--盾牌冲锋
				{AuraID = 169667, UnitID = "player"},
				--激怒
				{AuraID =  12880, UnitID = "player"},
				--剑刃风暴
				{AuraID =  46924, UnitID = "player"},
				--猝死
				{AuraID =  52437, UnitID = "player"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--撕裂
				{AuraID =    772, UnitID = "focus", Caster = "player"},
				--重伤
				{AuraID = 115767, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--鲁莽
				{SpellID =  1719, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
			},
		},
	},
	
	-- 萨满
	["SHAMAN"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--能量增效
				{AuraID = 118350, UnitID = "player"},
				--石壁图腾
				{AuraID = 114893, UnitID = "player"},
				--幽魂步
				{AuraID =  58875, UnitID = "player"},
				--风之释放
				{AuraID =  73681, UnitID = "player"},
				--强化释放
				{AuraID = 162557, UnitID = "player"},
			},
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--烈焰震击
				{AuraID =   8050, UnitID = "target", Caster = "player"},
				--冰霜震击
				{AuraID =   8056, UnitID = "target", Caster = "player"},
				--冰霜之力
				{AuraID =  63685, UnitID = "target", Caster = "player"},
				--束缚元素
				{AuraID =  76780, UnitID = "target", Caster = "player"},
				--妖术
				{AuraID =  51514, UnitID = "target", Caster = "player"},
				--陷地图腾
				{AuraID =  64695, UnitID = "target", Caster = "player"},
				--电能图腾
				{AuraID = 118905, UnitID = "target", Caster = "player"},
				--大地之盾
				{AuraID =    974, UnitID = "target", Caster = "player"},
				--激流
				{AuraID =  61295, UnitID = "target", Caster = "player"},
				--风暴打击
				{AuraID =  17364, UnitID = "target", Caster = "player"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--闪电护盾
				{AuraID =    324, UnitID = "player", Stack = 5, Timeless = true, Combat = true},
				--灵魂行者的恩赐
				{AuraID =  79206, UnitID = "player"},
				{AuraID = 159652, UnitID = "player"},	--神盾雕文
				--升腾
				{AuraID = 114050, UnitID = "player"},	--元素
				{AuraID = 114051, UnitID = "player"},	--增强
				{AuraID = 114052, UnitID = "player"},	--恢复
				--治疗大雨
				{AuraID =  73920, UnitID = "player"},
				--怒火释放
				{AuraID = 118470, UnitID = "player"},	--元素
				{AuraID = 118472, UnitID = "player"},	--增强
				--元素回响
				{AuraID = 159101, UnitID = "player"},
				{AuraID = 159105, UnitID = "player"},	--恢复
				--萨满之怒
				{AuraID =  30823, UnitID = "player"},
				--元素冲击
				{AuraID = 118522, UnitID = "player"},	--爆击
				{AuraID = 173183, UnitID = "player"},	--急速
				{AuraID = 173184, UnitID = "player"},	--精通
				{AuraID = 173185, UnitID = "player"},	--溅射
				{AuraID = 173186, UnitID = "player"},	--敏捷
				--星界转移
				{AuraID = 108271, UnitID = "player"},
				--自然守护者
				{AuraID =  30884, UnitID = "player"},
				--先祖迅捷
				{AuraID =  16188, UnitID = "player"},
				--先祖指引
				{AuraID = 108281, UnitID = "player"},
				--元素掌握
				{AuraID =  16166, UnitID = "player"},
				--潮汐奔涌
				{AuraID =  53390, UnitID = "player"},
				--生命释放
				{AuraID =  73685, UnitID = "player"},
				--火焰释放
				{AuraID = 165462, UnitID = "player", Flash = true},	--元素
				{AuraID =  73683, UnitID = "player"},	--增强
				--漩涡武器
				{AuraID =  53817, UnitID = "player"},
				--元素融合
				{AuraID = 157174, UnitID = "player"},
				--强化闪电链
				{AuraID = 157766, UnitID = "player"},
				--熔岩奔腾
				{AuraID =  77762, UnitID = "player"},
				--元素专注（元素2T17）
				{AuraID = 167205, UnitID = "player", Value = true},
				--元素和谐（恢复4T17）
				{AuraID = 167703, UnitID = "player", Value = true},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--大地之盾
				{AuraID =    974, UnitID = "focus", Caster = "player"},
				--激流
				{AuraID =  61295, UnitID = "focus", Caster = "player"},
				--烈焰震击
				{AuraID =   8050, UnitID = "focus", Caster = "player"},
				--妖术
				{AuraID =  51514, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--复生
				{SpellID = 20608, UnitID = "player"},
				--升腾
				{SpellID =165344, UnitID = "player"},
				{SpellID =165341, UnitID = "player"},
				{SpellID =165339, UnitID = "player"},
				--治疗之潮
				{SpellID =108280, UnitID = "player"},
				--灵魂链接
				{SpellID = 98008, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
			},
		},
	},
	
	-- 圣骑士
	["PALADIN"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--自律
				{AuraID =  25771, UnitID = "player"},
				--强化神圣震击
				{AuraID = 160002, UnitID = "player"},
				--圣光灌注
				{AuraID =  54149, UnitID = "player"},
				--圣洁护盾
				{AuraID = 148039, UnitID = "player"},
				{AuraID =  20925, UnitID = "player"},
				--永恒之火
				{AuraID = 156322, UnitID = "player"},
				--荣耀堡垒
				{AuraID = 114637, UnitID = "player"}, 
				--大十字军
				{AuraID =  85416, UnitID = "player"},
				--神圣十字军
				{AuraID = 144595, UnitID = "player"},
				--强化圣印
				{AuraID = 156990, UnitID = "player"},	--真理
				{AuraID = 156989, UnitID = "player"},	--正义
				{AuraID = 156987, UnitID = "player"},	--公正
				{AuraID = 156988, UnitID = "player"},	--洞察
			},
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--圣光道标
				{AuraID =  53563, UnitID = "target", Caster = "player"},
				--信仰道标
				{AuraID = 156910, UnitID = "target", Caster = "player"},
				--制裁之锤
				{AuraID =    853, UnitID = "target", Caster = "player"},
				--制裁之拳
				{AuraID = 105593, UnitID = "target", Caster = "player"},
				--神圣愤怒
				{AuraID =   2812, UnitID = "target", Caster = "player"},
				--超度邪恶
				{AuraID =  10326, UnitID = "target", Caster = "player"},
				--忏悔
				{AuraID =  20066, UnitID = "target", Caster = "player"},
				--牺牲之手
				{AuraID =   6940, UnitID = "target", Caster = "player"},
				--谴责
				{AuraID =   2812, UnitID = "target", Caster = "player"},
				--圣洁护盾
				{AuraID = 148039, UnitID = "target", Caster = "player"},
				--永恒之火
				{AuraID = 156322, UnitID = "target", Caster = "player"},
				--纯净之手
				{AuraID = 114039, UnitID = "target", Caster = "player"},
				--自律
				{AuraID =  25771, UnitID = "target", Caster = "player"},
				--圣光救赎
				{AuraID = 157047, UnitID = "target", Caster = "player"},
				--洞察道标
				{AuraID = 157007, UnitID = "target", Caster = "player"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--圣佑术
				{AuraID =    498, UnitID = "player"},
				--圣盾术
				{AuraID =    642, UnitID = "player"},
				--复仇之怒
				{AuraID =  31842, UnitID = "player"},	--神圣
				{AuraID =  31884, UnitID = "player"},	--惩戒
				--自由之手
				{AuraID =   1044, UnitID = "player"},
				--破晓
				{AuraID =  88819, UnitID = "player"},
				--圣光之速
				{AuraID =  85499, UnitID = "player"},
				--无私治愈
				{AuraID = 114250, UnitID = "player"},
				--神圣意志
				{AuraID =  90174, UnitID = "player"},
				--神圣复仇者
				{AuraID = 105809, UnitID = "player"},
				--正义盾击
				{AuraID = 132403, UnitID = "player"},
				--炽热防御者
				{AuraID =  31850, UnitID = "player"},
				--远古列王守卫
				{AuraID =  86659, UnitID = "player"},
				--炽天使
				{AuraID = 152262, UnitID = "player"},
				--最终审判
				{AuraID = 157048, UnitID = "player"},
				--光明战神
				{AuraID = 144587, UnitID = "player"},
				--十字军之怒（2T17）
				{AuraID = 165442, UnitID = "player"},
				--炽热蔑视（4T17）
				{AuraID = 166831, UnitID = "player"},
				--圣光防御者（4T17）
				{AuraID = 167742, UnitID = "player"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--圣光道标
				{AuraID =  53563, UnitID = "focus", Caster = "player"},
				--信仰道标
				{AuraID = 156910, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--圣疗术
				{SpellID =   633, UnitID = "player"},
				--复仇之怒
				{SpellID = 31884, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
			},
		},
	},

	-- 牧师
	["PRIEST"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--渐隐术
				{AuraID = 	586, UnitID = "player"},
				--圣光涌动
				{AuraID = 114255, UnitID = "player"},
				--神圣洞察
				{AuraID = 124430, UnitID = "player"},	--暗影
				{AuraID = 123266, UnitID = "player"},	--戒律
				{AuraID = 123267, UnitID = "player"},	--神圣
				--天堂之羽
				{AuraID = 121557, UnitID = "player"},
				--福音传播
				{AuraID =  81661, UnitID = "player"},
				--愈合之语
				{AuraID = 155362, UnitID = "player"},
			},
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--暗言术:痛
				{AuraID =    589, UnitID = "target", Caster = "player"},
				--噬灵疫病
				{AuraID = 158831, UnitID = "target", Caster = "player"},
				--吸血鬼之触
				{AuraID =  34914, UnitID = "target", Caster = "player"},
				--虚空熵能
				{AuraID = 155361, UnitID = "target", Caster = "player"},
				--守护之魂
				{AuraID =  47788, UnitID = "target", Caster = "player"},
				--圣言术：静
				{AuraID =  88684, UnitID = "target", Caster = "player"},
				--神圣之火
				{AuraID =  14914, UnitID = "target", Caster = "player"},
				--真言术：慰
				{AuraID = 129250, UnitID = "target", Caster = "player"},
				--恢复
				{AuraID =  	139, UnitID = "target", Caster = "player"},
				--真言术：盾
				{AuraID =	  17, UnitID = "target", Value = true},
				--意志洞悉
				{AuraID = 152118, UnitID = "target", Value = true},
				--神圣庇护
				{AuraID =  47753, UnitID = "target", Value = true},
				--虚弱灵魂
				{AuraID =   6788, UnitID = "target"},
				--虚空触须
				{AuraID = 114404, UnitID = "target", Caster = "player"},
				--统御意志
				{AuraID = 	 605, UnitID = "target", Caster = "player"},
				--心灵尖啸
				{AuraID =   8122, UnitID = "target", Caster = "player"},
				--灵魂护壳
				{AuraID = 114908, UnitID = "target", Caster = "player"},
				--神圣火花
				{AuraID = 131567, UnitID = "target", Caster = "player"},
				--意志洞悉
				{AuraID = 152118, UnitID = "target", Caster = "player"},
				--沉默
				{AuraID =  15487, UnitID = "target", Caster = "player"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--消散
				{AuraID =  47585, UnitID = "player"},
				--天使壁垒
				{AuraID = 114212, UnitID = "player"},
				--幽灵伪装潜行
				{AuraID = 119032, UnitID = "player"},
				--幻影
				{AuraID = 114239, UnitID = "player"},
				--争分夺秒
				{AuraID =  59889, UnitID = "player"},
				--命运多舛
				{AuraID = 123254, UnitID = "player"},
				--灵魂护壳
				{AuraID = 109964, UnitID = "player"},
				--能量灌注
				{AuraID =  10060, UnitID = "player"},
				--愈合之语
				{AuraID = 155363, UnitID = "player"},
				--救赎恩惠
				{AuraID = 155274, UnitID = "player"},
				--天使长
				{AuraID =  81700, UnitID = "player"},
				--吸血鬼的拥抱
				{AuraID =  15286, UnitID = "player"},
				--心灵惊骇
				{AuraID =  64044, UnitID = "player"},
				--心灵尖刺雕文
				{AuraID =  81292, UnitID = "player"},
				--妙手回春
				{AuraID =  63735, UnitID = "player"},
				--狂鞭
				{AuraID = 132573, UnitID = "player"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {				
				--恢复
				{AuraID = 	 139, UnitID = "focus", Caster = "player"},
				--虚弱灵魂
				{AuraID =   6788, UnitID = "focus", Caster = "player"},
				--真言术：盾
				{AuraID =	  17, UnitID = "focus", Caster = "player"},
				--暗言术:痛
				{AuraID =    589, UnitID = "focus", Caster = "player"},
				--吸血鬼之触
				{AuraID =  34914, UnitID = "focus", Caster = "player"},
				--噬灵疫病
				{AuraID =   2944, UnitID = "focus", Caster = "player"},
				--虚空熵能
				{AuraID = 155361, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--神圣赞美诗
				{SpellID = 64843, UnitID = "player"},
				--痛苦压制
				{SpellID = 33206, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
			},
		},
	},

	-- 术士
	["WARLOCK"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--黑暗再生
				{AuraID = 108359, UnitID = "player"},
				--牺牲契约
				{AuraID = 108416, UnitID = "player"},
				--治疗石雕文
				{AuraID = 6262, UnitID = "player"},
				--灵魂榨取
				{AuraID = 108366, UnitID = "player"},
				--献祭光环
				{AuraID = 104025, UnitID = "player"},
				--灵魂链接
				{AuraID = 108446, UnitID = "player"},
				--灼烧主人
				{AuraID = 119899, UnitID = "player"},
				--灰烬转换雕文
				{AuraID = 114635, UnitID = "player"},
			},
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--暗影之怒
				{AuraID =  30283, UnitID = "target", Caster = "player"},
				--死亡缠绕
				{AuraID =   6789, UnitID = "target", Caster = "player"},
				--恐惧嚎叫
				{AuraID =   5484, UnitID = "target", Caster = "player"},
				--腐蚀术
				{AuraID = 146739, UnitID = "target", Caster = "player"},
				--腐蚀之种
				{AuraID =  27243, UnitID = "target", Caster = "player"},
				{AuraID = 114790, UnitID = "target", Caster = "player"},
				--痛楚
				{AuraID =    980, UnitID = "target", Caster = "player"},
				--痛苦无常
				{AuraID =  30108, UnitID = "target", Caster = "player"},
				--恐惧
				{AuraID = 118699, UnitID = "target", Caster = "player"},
				--放逐术
				{AuraID =    710, UnitID = "target", Caster = "player"},
				--鬼影缠身
				{AuraID =  48181, UnitID = "target", Caster = "player"},
				--古尔丹之手
				{AuraID =  47960, UnitID = "target", Caster = "player"},
				--混乱波浪
				{AuraID = 124915, UnitID = "target", Caster = "player"},
				--献祭
				{AuraID = 157736, UnitID = "target", Caster = "player"},
				--末日灾祸
				{AuraID =    603, UnitID = "target", Caster = "player"},
				--浩劫
				{AuraID =  80240, UnitID = "target", Caster = "player"},
				--暗影灼烧
				{AuraID =  17877, UnitID = "target", Caster = "player"},
				--魅惑
				{AuraID =   6358, UnitID = "target", Caster = "pet"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--浩劫
				{AuraID =  80240, UnitID = "player"},
				--爆燃
				{AuraID = 117828, UnitID = "player"},
				--硫磺烈火
				{AuraID = 108683, UnitID = "player"},
				--爆燃冲刺
				{AuraID = 111400, UnitID = "player"},
				--黑暗灵魂：哀难
				{AuraID = 113860, UnitID = "player"},
				--黑暗灵魂：易爆
				{AuraID = 113858, UnitID = "player"},
				--黑暗灵魂：学识
				{AuraID = 113861, UnitID = "player"},
				--不灭决心
				{AuraID = 104773, UnitID = "player"},
				--黑暗交易
				{AuraID = 110913, UnitID = "player"},
				--基尔加丹的狡诈
				{AuraID = 137587, UnitID = "player"},
				--玛诺洛斯的狂怒
				{AuraID = 108508, UnitID = "player"},
				--灵魂燃烧
				{AuraID =  74434, UnitID = "player"},
				--鬼魅灵魂
				{AuraID = 157698, UnitID = "player"},
				--灵魂交换
				{AuraID =  86211, UnitID = "player"},
				--恶魔协同
				{AuraID = 171982, UnitID = "player"},
				--熔火之心
				{AuraID = 122355, UnitID = "player"},
				{AuraID = 140074, UnitID = "player"},	--绿火
				--恶魔之箭
				{AuraID = 157695, UnitID = "player"},
				--火焰之雨
				{AuraID = 104232, UnitID = "player"},
				--魔刃风暴
				{AuraID =  89751, UnitID = "pet"},
				--愤怒风暴
				{AuraID = 115831, UnitID = "pet"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--痛楚
				{AuraID =    980, UnitID = "focus", Caster = "player"},
				--腐蚀术
				{AuraID = 146739, UnitID = "focus", Caster = "player"},
				--痛苦无常
				{AuraID =  30108, UnitID = "focus", Caster = "player"},
				--末日灾祸
				{AuraID =    603, UnitID = "focus", Caster = "player"},
				--献祭
				{AuraID = 157736, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--灵魂石
				{SpellID = 20707, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
			},
		},
	},

	-- 盗贼
	["ROGUE"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--潜行
				{AuraID =   1784, UnitID = "player"},
				--复原
				{AuraID =  73651, UnitID = "player"},
				--毒刃：减速
				{AuraID = 115196, UnitID = "player"},
				--潜伏帷幕
				{AuraID = 114018, UnitID = "player"},
				--嫁祸诀窍
				{AuraID =  57934, UnitID = "player"},
				{AuraID =  59628, UnitID = "player"},
				--疾跑
				{AuraID =   2983, UnitID = "player"},
				--速度爆发
				{AuraID = 137573, UnitID = "player"},
				--备战就绪
				{AuraID =  74001, UnitID = "player"},
				--洞悉
				{AuraID =  84745, UnitID = "player"},
				{AuraID =  84746, UnitID = "player"},
				--盲点
				{AuraID = 121153, UnitID = "player"},
			}
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--凿击
				{AuraID =   1776, UnitID = "target", Caster = "player"},
				--偷袭
				{AuraID =   1833, UnitID = "target", Caster = "player"},
				--锁喉
				{AuraID =   1330, UnitID = "target", Caster = "player"},
				--肾击
				{AuraID =    408, UnitID = "target", Caster = "player"},
				--致盲
				{AuraID =   2094, UnitID = "target"},
				--猩红风暴
				{AuraID = 122233, UnitID = "target", Caster = "player"},
				--神经打击
				{AuraID = 112947, UnitID = "target", Caster = "player"},
				--要害打击
				{AuraID =  84617, UnitID = "target", Caster = "player"},
				--死亡标记
				{AuraID = 137619, UnitID = "target", Caster = "player"},
				--宿敌
				{AuraID =  79140, UnitID = "target", Caster = "player"},
				--割裂
				{AuraID =   1943, UnitID = "target", Caster = "player"},
				--出血
				{AuraID =  16511, UnitID = "target", Caster = "player"},
				--暗影反射
				{AuraID = 156745, UnitID = "target", Caster = "player"},
			}
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--影舞步
				{AuraID =  51690, UnitID = "player"},
				--佯攻
				{AuraID =   1966, UnitID = "player"},
				--冲动
				{AuraID =  13750, UnitID = "player"},
				--暗影斗篷
				{AuraID =  31224, UnitID = "player"},
				--消失
				{AuraID =  11327, UnitID = "player"},
				--切割
				{AuraID =   5171, UnitID = "player"},
				--剑刃乱舞
				{AuraID =  13877, UnitID = "player"},
				--诡诈
				{AuraID = 115192, UnitID = "player"},
				--闪避
				{AuraID =   5277, UnitID = "player"},
				--预感
				{AuraID = 115189, UnitID = "player"},
				--毒伤
				{AuraID =  32645, UnitID = "player"},
				--暗影之舞
				{AuraID =  51713, UnitID = "player"},
				--强化宿敌
				{AuraID = 158108, UnitID = "player"},
				--敏锐大师
				{AuraID =  31665, UnitID = "player"},
				--深度洞悉
				{AuraID =  84747, UnitID = "player"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--致盲
				{AuraID =   2094, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
				--冲动
				{SpellID = 13750, UnitID = "player"},
				--宿敌
				{SpellID = 79140, UnitID = "player"},
			},
		},			
	},
	
	-- 死亡骑士
	["DEATHKNIGHT"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--冰霜之路
				{AuraID =   3714, UnitID = "player"},
				--符能转换
				{AuraID = 119975, UnitID = "player"},
				--血之气息
				{AuraID =  50421, UnitID = "player", Stack = 5},
				--黑暗援助
				{AuraID = 101568, UnitID = "player"},
				--蜷缩
				{AuraID =  91838, UnitID = "pet"},
			},
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--血之疫病
				{AuraID = 55078, UnitID = "target", Caster = "player"},
				--冰霜疫病
				{AuraID = 55095, UnitID = "target", Caster = "player"},
				--血红热疫
				{AuraID = 81130, UnitID = "target", Caster = "player"},
				--灵魂收割，冰霜
				{AuraID = 130735, UnitID = "target", Caster = "player"},
				--灵魂收割，鲜血
				{AuraID = 114866, UnitID = "target", Caster = "player"},
				--灵魂收割，邪恶
				{AuraID = 130736, UnitID = "target", Caster = "player"},
				--死疽
				{AuraID = 155159, UnitID = "target", Caster = "player"},
				--辛达苟萨之息
				{AuraID = 155166, UnitID = "target", Caster = "player"},
				--亵渎
				{AuraID = 156004, UnitID = "target", Caster = "player"},
				--黑暗命令
				{AuraID =  56222, UnitID = "target", Caster = "player"},
				--寒冰锁链
				{AuraID =  45524, UnitID = "target", Caster = "player"},
				{AuraID = 160715, UnitID = "target", Caster = "player"},
				--冷库严冬
				{AuraID = 115001, UnitID = "target"},
				--窒息
				{AuraID = 108194, UnitID = "target"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--冰封之韧
				{AuraID =  48792, UnitID = "player"},
				--吸血鬼之血
				{AuraID =  55233, UnitID = "player"},
				--反魔法护罩
				{AuraID =  48707, UnitID = "player"},
				--死亡之影
				{AuraID = 164047, UnitID = "player", Value = true},
				--巫妖之躯
				{AuraID =  49039, UnitID = "player"},
				--符文分流
				{AuraID = 171049, UnitID = "player"},
				--符文刃舞
				{AuraID =  81256, UnitID = "player"},
				--白骨之盾
				{AuraID =  49222, UnitID = "player", Timeless = true, Combat = true},
				--死亡脚步
				{AuraID =  96268, UnitID = "player"},
				--鲜血充能
				{AuraID = 114851, UnitID = "player", Stack = 10},
				--符文腐蚀
				{AuraID =  51460, UnitID = "player"},
				--冷酷严冬
				{AuraID = 108200, UnitID = "player"},
				--邪恶之地
				{AuraID = 115018, UnitID = "player"},
				--冰霜之柱
				{AuraID =  51271, UnitID = "player"},
				--灵魂收割
				{AuraID = 114868, UnitID = "player"},
				--杀戮机器
				{AuraID =  51124, UnitID = "player"},
				--冰冻之雾
				{AuraID =  59052, UnitID = "player"},
				--暗影灌注
				{AuraID =  91342, UnitID = "pet", Stack = 5},
				--黑暗突变
				{AuraID =  63560, UnitID = "pet"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--血之疫病
				{AuraID = 55078, UnitID = "focus", Caster = "player"},
				--冰霜疫病
				{AuraID = 55095, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--冰封之韧
				{SpellID = 48792, UnitID = "player"},
				--复活盟友
				{SpellID = 61999, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
			},
		},
	},

	-- 武僧
	["MONK"] = {
		{	Name = "PlayerBuff",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 22,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 309},
			List = {
				--翻滚动能
				{AuraID = 119085, UnitID = "player"},
				--虎眼酒
				{AuraID = 125195, UnitID = "player"},
				--金创药
				{AuraID = 134563, UnitID = "player"},
				--力贯千钧
				{AuraID = 129914, UnitID = "player"},
				--魂体双分
				{AuraID = 101643, UnitID = "player"},
				--神鹤狂热(奶)
				{AuraID = 127722, UnitID = "player"},
				--法力茶(奶)
				{AuraID = 115867, UnitID = "player"},
				--雷光聚神茶(奶)
				{AuraID = 116680, UnitID = "player"},
				--活力之雾(奶)
				{AuraID = 118674, UnitID = "player", Stack = 5},
			},
		},
		{	Name = "TargetDebuff",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 200, 309},
			List = {
				--分筋错骨
				{AuraID = 115078, UnitID = "target", Caster = "player"},
				--豪镇八方
				{AuraID = 116189, UnitID = "target", Caster = "player"},
				--金刚震（定身）
				{AuraID = 116706, UnitID = "target", Caster = "player"},
				--迷醉酒雾
				{AuraID = 116330, UnitID = "target", Caster = "player"},
				--醉酿投
				{AuraID = 121253, UnitID = "target", Caster = "player"},
				--火焰之熄
				{AuraID = 123725, UnitID = "target", Caster = "player"},
				--风火雷电
				{AuraID = 138130, UnitID = "target", Caster = "player"},
				--旭日东升踢
				{AuraID = 130320, UnitID = "target", Caster = "player"},
				--作茧缚命(奶)
				{AuraID = 116849, UnitID = "target", Caster = "player"},
				--复苏之雾(奶)
				{AuraID = 119611, UnitID = "target", Caster = "player"},
				--氤氲之雾(奶)
				{AuraID = 132120, UnitID = "target", Caster = "player"},
			},
		},
		{	Name = "SPECIAL",
			Direction = "LEFT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 36,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -200, 336},
			List = {
				--猛虎之力
				{AuraID = 120273, UnitID = "player"},
				--迅如猛虎
				{AuraID = 116841, UnitID = "player"},
				--壮胆酒
				{AuraID = 120954, UnitID = "player"},
				--躯不坏
				{AuraID = 122278, UnitID = "player"},
				--散魔功
				{AuraID = 122783, UnitID = "player"},
				--逍遥酒
				{AuraID = 137562, UnitID = "player"},
				--虎眼酒（使用）
				{AuraID = 116740, UnitID = "player"},
				--豪能酒
				{AuraID = 115288, UnitID = "player"},
				--业报之触
				{AuraID = 125174, UnitID = "player"},
				--屏气凝神
				{AuraID = 152173, UnitID = "player"},
				--猛虎之力
				{AuraID = 125359, UnitID = "player"},
				--青龙之息(奶)
				{AuraID = 157627, UnitID = "player"},
				--风火雷电
				{AuraID = 137639, UnitID = "player"},
			},
		},
		{	Name = "FOCUS",
			Direction = "RIGHT",
			Interval = 5,
			Mode = "ICON",
			IconSize = 35,
			Pos = {"BOTTOMLEFT", UIParent, "LEFT", 5, -130},
			List = {
				--复苏之雾(奶)
				{AuraID = 119611, UnitID = "focus", Caster = "player"},
				--氤氲之雾(奶)
				{AuraID = 132120, UnitID = "focus", Caster = "player"},
			},
		},
		{	Name = "CD",
			Direction = "UP",
			Interval = 5,
			Mode = "BAR",
			IconSize = 18,
			BarWidth = 150,
			Pos = {"BOTTOMRIGHT", UIParent, "BOTTOM", -425, 500},
			List = {
				--壮胆酒
				{SpellID =115203, UnitID = "player"},
				--饰品
				{SlotID  =    13, UnitID = "player"},
				{SlotID  =    14, UnitID = "player"},
			},
		},
	},
}