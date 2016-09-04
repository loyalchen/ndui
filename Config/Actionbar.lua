-- Configure
local _, C, _, _ = unpack(select(2, ...))

-- 动作条细节调整
C.bars = {
	layout					= 1,		-- 1为默认，2为旧布局，3是动作条4会出现在右下角，改变后需重置动作条
	--BAR1 主动作条
	bar1 = {
		enable          	= true,		-- 启用
		scale           	= 1.2,		-- 以1为基准增大/缩放
		size				= 28,		-- 图标大小
		mouseover           = {			-- 鼠标悬停显隐
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
			},
		combat          	= {			-- 战斗时显隐
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --BAR2 左下方动作条
    bar2 = {
		enable          	= true,		-- 启用
		scale          		= 1.2,		-- 以1为基准增大/缩放
		size           		= 28,		-- 图标大小
		mouseover           = {			-- 鼠标悬停显隐
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
		combat          	= {			-- 战斗时显隐
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --BAR3 右下方动作条
    bar3 = {
		enable         	 	= true,		-- 启用
		uselayout2x3x2  	= true,		-- false为一横条
		scale           	= 1.2,		-- 以1为基准增大/缩放
		size        	    = 26,		-- 图标大小
		mouseover       	= {			-- 鼠标悬停显隐
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.7},
		},
		combat          	= {			-- 战斗时显隐
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --BAR4 右边动作条1
    bar4 = {
		enable          	= true,		-- 启用
		scale           	= 1.2,		-- 以1为基准增大/缩放
		size           		= 26,		-- 图标大小
		mouseover       	= {			-- 鼠标悬停显隐
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.5},
		},
		combat          	= {			-- 战斗时显隐
			enable          = false,
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --BAR5 右边动作条2
    bar5 = {
		enable          	= true,		-- 启用
		scale          		= 1.2,		-- 以1为基准增大/缩放
		size				= 26,		-- 图标大小
		mouseover       	= {
			enable          = true,		-- 鼠标悬停显隐
			fadeIn          = {time = 0.3, alpha = 1},
			fadeOut         = {time = 0.8, alpha = 0},
		},
		combat          	= {
			enable          = false,	-- 战斗时显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.5},
		},
    },
    --PETBAR 宠物动作条
    petbar = {
		enable          	= true,		-- 启用
		show            	= true,		-- 显示
		scale           	= 1,		-- 以1为基准增大/缩放
		size	            = 26,		-- 图标大小
		mouseover       	= {
			enable          = false,	-- 鼠标悬停显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.7},
		},
		combat          	= {
			enable          = false,	-- 战斗时显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --STANCE- + POSSESSBAR 姿态条
    stancebar = {
		enable          	= true,		-- 启用
		show            	= true,		-- 显示
		scale           	= 1.1,		-- 以1为基准增大/缩放
		size          		= 26,		-- 图标大小
		mouseover       	= {
			enable          = true,		-- 鼠标悬停显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.7},
		},
		combat          	= {
			enable          = false,	-- 战斗时显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --EXTRABAR 额外动作条
    extrabar = {
		enable          	= true,		-- 启用
		scale          		= 1.2,		-- 以1为基准增大/缩放
		size    	        = 36,		-- 图标大小
		mouseover       	= {
			enable          = false,	-- 鼠标悬停显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
		},
    },
    --VEHICLE EXIT 离开载具按钮
    leave_vehicle 			= {
		enable          	= true,		-- 启用
		scale           	= 1.2,		-- 以1为基准增大/缩放
		size          		= 26,		-- 图标大小
		mouseover       	= {
			enable          = false,	-- 鼠标悬停显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
    --MICROMENU 微型菜单按钮
    micromenu = {
		enable          	= true,		-- 启用
		show            	= false,	-- 默认不显示
		scale           	= 0.82,		-- 以1为基准增大/缩放
		mouseover       	= {
			enable          = false,	-- 鼠标悬停显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.1},
		},
    },
    --BAGS 背包栏
    bags = {
		enable          	= true,		-- 启用
		show            	= false,	-- 默认不显示
		scale           	= 1.2,		-- 以1为基准增大/缩放
		mouseover      		= {
			enable          = false,	-- 鼠标悬停显隐
			fadeIn          = {time = 0.4, alpha = 1},
			fadeOut         = {time = 0.3, alpha = 0.1},
		},
    },
	userplaced				= true,		-- 使其可通过游戏内命令移动
}

-- Actionbar 动作条主要设置
C.Actionbar = {
	ShowBG		= true,												-- 显示背景色
	ShowSD		= true,												-- 显示边框阴影
	BGColor		= { r = 0.2, g = 0.2, b = 0.2, a = 0.2},			-- 背景色参数
	SDColor		= { r = 0, g = 0, b = 0, a = 0.9},					-- 阴影色参数
	Normal		= { r = 0.37, g = 0.3, b = 0.3, },
	Equipped	= { r = 0.1, g = 0.5, b = 0.1, },
}