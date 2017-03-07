-- skillType = 1 主动技能  2， 被动技能
-- target = 1  范围内敌人（1个）2 -- 我方全体 3  -- 我方血量最少

local skillConfig = {
	{id = 1000,script = 1000,missileCount = 1,interval = 0,name = "散弹",skillType = 1,target = 1,attackRadius = 300,attack = 2,cd = 10},
	{id = 1001,script = 1001,missileCount = 2,interval = 5,name = "散弹",skillType = 1,target = 1,attackRadius = 300,attack = 2,cd = 10},
	{id = 1002,script = 1002,missileCount = 1,interval = 0,name = "散弹",skillType = 1,target = 1,attackRadius = 300,attack = 2,cd = 10},
	{id = 1003,script = 1003,missileCount = 2,interval = 5,name = "散弹",skillType = 1,target = 1,attackRadius = 300,attack = 2,cd = 10},
	{id = 1004,script = 1004,missileCount = 1,interval = 0,name = "散弹",skillType = 1,target = 1,attackRadius = 300,attack = 2,cd = 10},
	{id = 1005,script = 1005,missileCount = 2,interval = 5,name = "散弹",skillType = 1,target = 1,attackRadius = 300,attack = 2,cd = 10},
	

	{id = 2001,script = 2001,missileCount = 1,interval = 0,name = "目标",skillType = 1,target = 1,attackRadius = 300,attack = 1,cd = 30},

	{id = 6001,script = 6001,missileCount = 1,interval = 0,name = "远程",skillType = 1,target = 1,attackRadius = 350,attack = 1,cd = 60},
	{id = 6002,script = 6002,missileCount = 3,interval = 5,name = "远程",skillType = 1,target = 1,attackRadius = 350,attack = 1,cd = 20},
}

return skillConfig