local battleConfig = {
	-- {
	-- 	id = 1,
	-- 	name = "mode",
	-- 	res = "resources/scene/map05.prefab",
	-- 	rank = false,
	-- 	revive = false,
	-- 	bornPos = {0,-100},
	-- 	bornDir = {0,1},
	-- 	width =  2048, 
	-- 	height = 640,
	-- 	drop = 1001,						-- dropConfig
	-- 	dropInterval = -1,      		
	-- 	playerDrop = 2003,
	-- 	monster = 1001,					-- monsterFreshConfig
	-- 	monsterInterval = 60,
	-- 	monsterDelay = 10, 				-- 延迟多久刷第一波怪（通常为1即） 		
	-- 	timeOut = 4500,			
	-- 	maxMonsterCount = 20, 			-- 怪物数量上限

	-- 	basement1 = 6001,   				-- 塔1
	-- 	basement2 = 6002,					-- 塔2

	-- 	camp1Pos = {-800,0},
	-- 	camp2Pos = {800,0},
	-- 	camp1Dir = {1,0},
	-- 	camp2Dir = {-1,0},
	-- },
	{
		id = 1,
		name = "mode",
		res = "resources/scene/map05.prefab",
		rank = false,
		revive = false,
		bornPos = {0,-100},
		bornDir = {0,1},
		width =  1600, 
		height = 640,
		drop = 1001,						-- dropConfig
		dropInterval = -1,      		
		playerDrop = 2003,
		monster = 1001,					-- monsterFreshConfig
		monsterInterval = 60,
		monsterDelay = 10, 				-- 延迟多久刷第一波怪（通常为1即） 		
		timeOut = 3000,			
		maxMonsterCount = 50, 			-- 怪物数量上限

		basement1 = 6001,					-- 塔2
		basement2 = 6002,					-- 塔2

		camp1Pos = {-700,0},
		camp2Pos = {700,0},

		cost = 10,
		reward = 20,
	},
	{
		id = 2,
		name = "mode",
		res = "resources/scene/map05.prefab",
		rank = false,
		revive = false,
		bornPos = {0,-100},
		bornDir = {0,1},
		width =  1600, 
		height = 640,
		drop = 1001,						-- dropConfig
		dropInterval = -1,      		
		playerDrop = 2003,
		monster = 1002,					-- monsterFreshConfig
		monsterInterval = 60,
		monsterDelay = 10, 				-- 延迟多久刷第一波怪（通常为1即） 		
		timeOut = 3000,			
		maxMonsterCount = 50, 			-- 怪物数量上限

		basement1 = 6003,					-- 塔2
		basement2 = 6004,					-- 塔2

		camp1Pos = {-700,0},
		camp2Pos = {700,0},

		cost = 20,
		reward = 40,
	},
	{
		id = 3,
		name = "mode",
		res = "resources/scene/map05.prefab",
		rank = false,
		revive = false,
		bornPos = {0,-100},
		bornDir = {0,1},
		width =  1600, 
		height = 640,
		drop = 1001,						-- dropConfig
		dropInterval = -1,      		
		playerDrop = 2003,
		monster = 1003,					-- monsterFreshConfig
		monsterInterval = 60,
		monsterDelay = 10, 				-- 延迟多久刷第一波怪（通常为1即） 		
		timeOut = 3000,			
		maxMonsterCount = 50, 			-- 怪物数量上限

		basement1 = 6005,					-- 塔2
		basement2 = 6006,					-- 塔2

		camp1Pos = {-700,0},
		camp2Pos = {700,0},

		cost = 50,
	},
	
}

return battleConfig