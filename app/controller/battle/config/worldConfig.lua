local worldConfig = {
	defaultUname = math.floor(math.random(201600,920160)*900000),
	gameInterval=60,
	battleInterval = 25,  -- 比server略高一点 消除update颗粒问题
	minStep = 50,
	minAngle = math.pi /36,
	bornTime = 60,
	reviewTime = 100,
	dropSpeed = 100,		--  掉落飞向玩家的速度
	rubsRate = 10, 			-- 每增加一个单位速度削弱
	vectorPrecision = 100,

	defaultBattle = 1001,
	defaultPlayer = 1000,
	defaultMode　= 2, 		-- 1 = console 2 = online

	touchDist = 10, 		-- 自由移动使用
	touchAngle = math.pi / 4,
	touchTime = 40,

	maxTouch = 70,			-- 虚拟摇杆使用
	minTouch = 30,

	hpTime = 0.2,

	serverAddr = "192.168.0.111",
	-- serverAddr = "115.28.181.162",
	serverPort = "3014",
}

return worldConfig