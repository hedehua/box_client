local battleConfig = {
	{
		id = 0,
		name = "测试",
		res = "resources/scene/plane_box1.prefab",
		rank = false,
		revive = false,
		bornPos = {0,-100},
		bornDir = {0,1},
		width = 3200, 
		height = 4800,
		drop = -1,						-- dropConfig
		dropInterval = 300,      		
		monster = -1,					-- monsterFreshConfig
		monsterInterval = -1,
		monsterDelay = 0, 				-- 延迟多久刷第一波怪（通常为1即） 		
		timeOut = 3000,			
		maxMonsterCount = 0, 			-- 怪物数量上限
	},
	{
		id = 1,
		name = "endless",
		res = "resources/scene/plane_box1.prefab",
		rank = true,
		revive = false,
		bornPos = {0,-100},
		bornDir = {0,1},
		width =  1920, 
		height = 1920,
		drop = -1,						-- dropConfig
		dropInterval = 20,      		
		playerDrop = 1003,
		monster = 2001,					-- monsterFreshConfig
		monsterInterval = 60,
		monsterDelay = 50, 				-- 延迟多久刷第一波怪（通常为1即） 		
		timeOut = 22500,			
		maxMonsterCount = 20, 			-- 怪物数量上限
	},
	{
		id = 2,
		name = "3v3",
		res = "resources/scene/plane_box1.prefab",
		rank = false,
		revive = true,
		bornPos = {0,-100},
		bornDir = {0,1},
		width =  1280, 
		height = 720,
		drop = -1,						-- dropConfig
		dropInterval = 100,      		
		playerDrop = 2003,
		monster = -1,					-- monsterFreshConfig
		monsterInterval = 300,
		monsterDelay = 50, 				-- 延迟多久刷第一波怪（通常为1即） 		
		timeOut = 6000,			
		maxMonsterCount = 20, 			-- 怪物数量上限

		camp1 = 6001,   				-- 塔1
		camp2 = 6002,					-- 塔2

		camp1Pos = {-400,0},
		camp2Pos = {400,0},
		camp1Dir = {1,0},
		camp2Dir = {-1,0},
	},
	
}

return battleConfig