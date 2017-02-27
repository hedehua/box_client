local BattleEnums = {
	-- battle
	CMD = {
		None 		= 0,
		Move 		= 1,
		Join 		= 2,
		Leave		= 3,
		SetAI 		= 4,
		MoveEx 	= 5,
		StopMove	= 6,
		Skill 		= 7,
	},
	Direction = {
		None = 0,
		Up = 1,
		Right = 2,
		Down = 3,
		Left = 4,
		Count = 5,
	},
	DropType = {
		None = 0,
		Role = 1,   	-- 英雄
		Item = 2,  		-- 道具
	},
	ECamp ={
		None 	= 0,
		Blue 	= 1,
		Green  	= 2,
		Red 	= 3,
	},
	EResult = {
		Timeout = 1,		-- 超时
		Succ = 2, 			-- 胜负(基地摧毁)
		PlayerDie = 3,			-- 中场离开
	},
	EBattleState = {
		None = 0,
		Running = 1,
		Accomplish = 2,
		Transit = 3, 		-- 过渡 
	},
	-- 1：定向移动，2= 追踪目标，3= 运动至敌人位置，4：跟随发起者
	EMoveType = {
		Direction 		= 1,
		ToTarget 		= 2,
		ToTargetPos 	= 3,
		ToCaster 		= 4,
		ToCasterPos 	= 5,
	}

}

return BattleEnums