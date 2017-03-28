local worldConfig = {
	defaultUname = math.floor(math.random(201600,920160)*900000),
	battleInterval = 25,  -- 比server略高一点 消除update颗粒问题
	aiInterval = 5,
	minStep = 50,
	minAngle = math.pi /360,
	bornTime = 60,
	reviewTime = 40,
	dropSpeed = 100,		--  掉落飞向玩家的速度
	rubsRate = 10, 			-- 每增加一个单位速度削弱
	vectorPrecision = 1000,

	defaultBattle = 1001,
	defaultPlayer = 1000,
	defaultMode　= 2, 		-- 1 = console 2 = online
	defaultCoin = 50,

	touchDist = 10, 		-- 自由移动使用
	touchAngle = math.pi / 4,
	touchTime = 40,

	maxTouch = 40,			-- 虚拟摇杆使用
	minTouch = 5,

	hpTime = 0.2,

	goods1 = 10,
	goods2 = 60,
	goods3 = 300,

	serverAddr = "192.168.0.111",
	serverPort = "3014",
}

return worldConfig