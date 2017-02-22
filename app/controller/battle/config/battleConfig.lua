local battleConfig = {
	-- {
	-- 	id = 1,
	-- 	name = "mode1",
	-- 	res = "resources/scene/plane_box1.prefab",
	-- 	rank = true,
	-- 	revive = false,
	-- 	bornPos = {0,-100},
	-- 	bornDir = {1,0},
	-- 	width =  1280, 
	-- 	height = 640,
	-- 	drop = -1,						-- dropConfig
	-- 	dropInterval = 20,      		
	-- 	playerDrop = 1003,
	-- 	monster = 1001,					-- monsterFreshConfig
	-- 	monsterInterval = 1000,
	-- 	monsterDelay = 50, 				-- 延迟多久刷第一波怪（通常为1即） 		
	-- 	timeOut = 22500,			
	-- 	maxMonsterCount = 20, 			-- 怪物数量上限
	-- },
	{
		id = 1,
		name = "mode",
		res = "resources/scene/map_01_01.prefab",
		rank = false,
		revive = true,
		bornPos = {0,-100},
		bornDir = {0,1},
		width =  2048, 
		height = 640,
		drop = 1001,						-- dropConfig
		dropInterval = 1000,      		
		playerDrop = 2003,
		monster = 1001,					-- monsterFreshConfig
		monsterInterval = 1000,
		monsterDelay = 50, 				-- 延迟多久刷第一波怪（通常为1即） 		
		timeOut = 3000,			
		maxMonsterCount = 20, 			-- 怪物数量上限

		camp1 = 6001,   				-- 塔1
		camp2 = 6002,					-- 塔2

		camp1Pos = {-800,0},
		camp2Pos = {800,0},
		camp1Dir = {1,0},
		camp2Dir = {-1,0},
	},
	
}

return battleConfig