-- skillType = 1 主动技能  2， 被动技能
-- target = 1  范围内敌人（1个）2 -- 我方全体 3  -- 我方血量最少

local skillConfig = {
	{id = 1001,script = 1001,missileCount=1,interval = 0,name = "散弹",skillType = 1,target = 1,attackRadius =300,attack = 2,cd = 10},
	{id = 1002,script = 1002,missileCount=1,interval = 5,name = "目标",skillType = 1,target = 1,attackRadius =300,attack = 1,cd = 10},

	-- {id = 1003,script = 1003,missileCount=1,interval = 0,name = "闪电",skillType = 1,target = 1,attackRadius =1000,attack = 0,cd = 250},
	-- {id = 1004,script = 1004,missileCount=1,interval = 0,name = "近战",skillType = 1,target = 1,attackRadius =1000,attack = 0,cd = 250}, 
	-- {id = 1005,script = 1005,missileCount=3,interval = 5,name = "远程",skillType = 1,target = 1,attackRadius =1000,attack = 0,cd = 250},
	-- {id = 1006,script = null,missileCount=0,interval = 0,name = "生命",skillType = 2,target = 3,attackRadius =0,attack = 0,cd = 250},
	-- {id = 1007,script = 1007,missileCount=1,interval = 0,name = "扔雷",skillType = 1,target = 1,attackRadius =1000,attack = 0,cd = 250}, 
	
	-- {id = 1009,script = 1009,missileCount=1,interval = 0,name = "陨石",skillType = 1,target = 1,attackRadius =1000,attack = 0,cd = 250}, 
	
	{id = 5001,script = 5001,missileCount=1,interval = 0,name = "远程",skillType = 1,target = 1,attackRadius =300,attack = 0,cd = 60},
	{id = 5002,script = 5002,missileCount=2,interval = 0,name = "远程",skillType = 1,target = 1,attackRadius =300,attack = 0,cd = 20},
	{id = 5003,script = 5003,missileCount=1,interval = 0,name = "远程",skillType = 1,target = 1,attackRadius =300,attack = 0,cd = 30},
}

return skillConfig