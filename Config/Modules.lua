-- Configure ����ҳ��
local _, C, _, _ = unpack(select(2, ...))

-- ȫ��
C.NDui = {
	numbType		= 1,											-- ��λ��ʽ��1Ϊm/k��2Ϊy/w��3Ϊ��ϸ
}

-- BUFF/DEBUFF���
C.Auras = {
	IconSize		= 32,											-- BUFFͼ���С
	IconsPerRow		= 14,											-- BUFFÿ�и���
	Spacing			= 6,											-- BUFFͼ����
	BuffPos			= {"TOPRIGHT", Minimap, "TOPLEFT", -10, -5},	-- BUFFλ��
	DebuffPos		= {"TOPRIGHT", Minimap, "TOPLEFT", -10, -130},	-- DEBUFFλ��

	CheckerPos		= {"TOPLEFT", UIParent, "TOPLEFT", 4, -23},		-- �Ŷ�BUFF����λ��
	BHPos			= {"CENTER", UIParent, "CENTER", 0, -200},		-- Ѫ������Ĭ��λ��
	StaggerPos		= {"CENTER", UIParent, "CENTER", 0, -220},		-- ̹ɮ����Ĭ��λ��
	TotemsPos		= {"CENTER", UIParent, "CENTER", 0, -190},		-- ͼ������Ĭ��λ��
	CPointsPos		= {"CENTER", UIParent, "CENTER", 0, -190},		-- �����㹤��Ĭ��λ��
}

-- ͷ�����
C.UFs = {
	Enable			= true,											-- ����ͷ��
	Playercb		= {"BOTTOM", UIParent, "BOTTOM", 16, 190},		-- ���ʩ����Ĭ��λ��
	PlayercbSize	= {300, 20},									-- ���ʩ�����ߴ�
	Targetcb		= {"BOTTOM", UIParent, "BOTTOM", 16, 350},		-- Ŀ��ʩ����Ĭ��λ��
	TargetcbSize	= {280, 20},									-- Ŀ��ʩ�����ߴ�
	Focuscb			= {"CENTER", UIParent, "CENTER", 10, 200},		-- ����ʩ����Ĭ��λ��
	FocuscbSize		= {320, 20},									-- ����ʩ�����ߴ�

	PlayerPos		= {"TOPRIGHT", UIParent, "BOTTOM", -200, 300},	-- ��ҿ���Ĭ��λ��
	TargetPos		= {"TOPLEFT", UIParent, "BOTTOM", 200, 300},	-- Ŀ�����Ĭ��λ��
	ToTPos			= {"BOTTOM", UIParent, "BOTTOM", 136, 241},		-- Ŀ���Ŀ�����Ĭ��λ��
	PetPos			= {"BOTTOM", UIParent, "BOTTOM", -136, 241},	-- �������Ĭ��λ��
	FocusPos		= {"LEFT", UIParent, "LEFT", 5, -150},			-- �������Ĭ��λ��

	BarPoint		= {"TOPLEFT", 12, 4},							-- ��Դ��λ�ã�������ͷ��Ϊ��׼��
	BarSize			= {215, 10},										-- ��Դ���ĳߴ磨������
	BarMargin		= 2,											-- ��Դ�����
}

-- �������
C.Chat = {
	Enable			= true,											-- �����������
	HideTabBG		= true,											-- ��������������
	TabColor1		= {1,0.75,0},									-- ��ǰ���������ɫ
	TabColor2		= {0.5,0.5,0.5},								-- δѡ������������ɫ
	Chatbar = {
		Width 		= 42,											-- Ƶ�������
		Height 		= 10,											-- Ƶ�����߶�
		Spacing 	= 3,											-- Ƶ�������
	},
}

-- ��ͼ
C.Maps = {
	Enable			= true,											-- ���������ͼ�Ķ���Ԫ��
	IconSize		= 28,											-- ����ͼ���С
}
C.Minimap = {
	Enable			= true,											-- ����С��ͼ
	Scale			= 1.2,											-- С��ͼ�ߴ���1Ϊ��׼����/����
	Pos				= {"TOPRIGHT", UIParent, "TOPRIGHT", -7, -7},	-- С��ͼλ��
}

-- ������
C.Nameplate = {
	Height			= 5,											-- ������߶�
	Width			= 120,											-- ��������
	AuraSize		= 20,											-- ������DEBUFF��С
}

-- ������Ƥ��
C.Skins = {
	EnableBag		= false,											-- ���ñ���
	BagScale		= 1,											-- �����ߴ���1Ϊ��׼����/����
	IconSize		= 34,											-- ��������С
	MicroMenuPos 	= {"BOTTOM", UIParent, "BOTTOM", -118, 3},		-- ΢�Ͳ˵�����
	RMPos  			= {"TOP", UIParent, "TOP", 0, 0},				-- �Ŷӹ���Ĭ������
}

-- �����ʾ����
C.Tooltip = {
	Enable			= true,											-- ���ã��ܿ��أ�
	Scale			= 1,											-- ���ڳߴ���1Ϊ��׼����/����
	Pos				= {"BOTTOMRIGHT", "BOTTOMRIGHT", -55, 230},		-- ����λ��
}

-- С����
C.Sets = {
	Keyword			= "raid",										-- �ؼ�������ʱ�Զ�����
	Cooldown		= true,											-- �������ȴ��ʱ��ʹ��OmniCC�������
}