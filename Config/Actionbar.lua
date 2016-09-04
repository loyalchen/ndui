-- Configure
local _, C, _, _ = unpack(select(2, ...))

-- ������ϸ�ڵ���
C.bars = {
	layout					= 1,		-- 1ΪĬ�ϣ�2Ϊ�ɲ��֣�3�Ƕ�����4����������½ǣ��ı�������ö�����
	--BAR1 ��������
	bar1 = {
		enable          	= true,		-- ����
		scale           	= 1.2,		-- ��1Ϊ��׼����/����
		size				= 28,		-- ͼ���С
		mouseover           = {			-- �����ͣ����
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
			},
		combat          	= {			-- ս��ʱ����
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --BAR2 ���·�������
    bar2 = {
		enable          	= true,		-- ����
		scale          		= 1.2,		-- ��1Ϊ��׼����/����
		size           		= 28,		-- ͼ���С
		mouseover           = {			-- �����ͣ����
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
		combat          	= {			-- ս��ʱ����
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --BAR3 ���·�������
    bar3 = {
		enable         	 	= true,		-- ����
		uselayout2x3x2  	= true,		-- falseΪһ����
		scale           	= 1.2,		-- ��1Ϊ��׼����/����
		size        	    = 26,		-- ͼ���С
		mouseover       	= {			-- �����ͣ����
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.7},
		},
		combat          	= {			-- ս��ʱ����
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --BAR4 �ұ߶�����1
    bar4 = {
		enable          	= true,		-- ����
		scale           	= 1.2,		-- ��1Ϊ��׼����/����
		size           		= 26,		-- ͼ���С
		mouseover       	= {			-- �����ͣ����
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.5},
		},
		combat          	= {			-- ս��ʱ����
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --BAR5 �ұ߶�����2
    bar5 = {
		enable          	= true,		-- ����
		scale          		= 1.2,		-- ��1Ϊ��׼����/����
		size				= 26,		-- ͼ���С
		mouseover       	= {
			enable          = true,		-- �����ͣ����
			fadeIn          = {time = 0.3, alpha = 1},
			fadeOut         = {time = 0.8, alpha = 0},
		},
		combat          	= {
			enable          = false,	-- ս��ʱ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.5},
		},
    },
    --PETBAR ���ﶯ����
    petbar = {
		enable          	= true,		-- ����
		show            	= true,		-- ��ʾ
		scale           	= 1,		-- ��1Ϊ��׼����/����
		size	            = 26,		-- ͼ���С
		mouseover       	= {
			enable          = false,	-- �����ͣ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.7},
		},
		combat          	= {
			enable          = false,	-- ս��ʱ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --STANCE- + POSSESSBAR ��̬��
    stancebar = {
		enable          	= true,		-- ����
		show            	= true,		-- ��ʾ
		scale           	= 1.1,		-- ��1Ϊ��׼����/����
		size          		= 26,		-- ͼ���С
		mouseover       	= {
			enable          = true,		-- �����ͣ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.7},
		},
		combat          	= {
			enable          = false,	-- ս��ʱ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --EXTRABAR ���⶯����
    extrabar = {
		enable          	= true,		-- ����
		scale          		= 1.2,		-- ��1Ϊ��׼����/����
		size    	        = 36,		-- ͼ���С
		mouseover       	= {
			enable          = false,	-- �����ͣ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --VEHICLE EXIT �뿪�ؾ߰�ť
    leave_vehicle 			= {
		enable          	= true,		-- ����
		scale           	= 1.2,		-- ��1Ϊ��׼����/����
		size          		= 26,		-- ͼ���С
		mouseover       	= {
			enable          = false,	-- �����ͣ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
    --MICROMENU ΢�Ͳ˵���ť
    micromenu = {
		enable          	= true,		-- ����
		show            	= false,	-- Ĭ�ϲ���ʾ
		scale           	= 0.82,		-- ��1Ϊ��׼����/����
		mouseover       	= {
			enable          = false,	-- �����ͣ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.1},
		},
    },
    --BAGS ������
    bags = {
		enable          	= true,		-- ����
		show            	= false,	-- Ĭ�ϲ���ʾ
		scale           	= 1.2,		-- ��1Ϊ��׼����/����
		mouseover      		= {
			enable          = false,	-- �����ͣ����
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.1},
		},
    },
	userplaced				= true,		-- ʹ���ͨ����Ϸ�������ƶ�
}

-- Actionbar ��������Ҫ����
C.Actionbar = {
	ShowBG		= true,												-- ��ʾ����ɫ
	ShowSD		= true,												-- ��ʾ�߿���Ӱ
	BGColor		= { r = 0.2, g = 0.2, b = 0.2, a = 0.2},			-- ����ɫ����
	SDColor		= { r = 0, g = 0, b = 0, a = 0.9},					-- ��Ӱɫ����
	Normal		= { r = 0.37, g = 0.3, b = 0.3, },
	Equipped	= { r = 0.1, g = 0.5, b = 0.1, },
}