local missileConfig = {

	-- 参数说明：
	-- id= 子弹的唯一标识
	-- speed= 子弹的飞行速度，0 表示静止
	-- moveType= 运动的模式，1：定向移动，2= 追踪目标，3= 运动至敌人位置，4：跟随发起者
	-- start = 起始参考系，1 = 发起者（可能是角色，可能是子弹），2= 被攻击者, 3=父（通常为子弹）
	-- startPos = 起始位置偏移，配合start一起使用
	-- dir ： 起始朝向，一般在定向移动中使用
	-- timeOut = 子弹存活时间（也决定了飞行时间）

	-- 近攻示例
	-- {id = 1,speed = 0,radius = 6000,moveType = 0,start = 1,startPos = nil,dir = 0,timeOut = 2,res = "role/missile_01"},	
	-- 直接攻击目标，与1003不同的是 1003是飞过去的
	-- {id = 2,speed = 0,radius = 100,moveType = nil,start = 2,startPos = [0,0],dir = 0,timeOut = 0,res = "role/missile_02"},
	-- 定向示例
	-- {id = 1002,speed = 800,radius = 500,moveType = 1,start = 1,startPos = nil,dir = 0, timeOut = 30,res = "role/missile_02"},	
	-- 目标位置示例
	-- {id = 3,speed = 400,radius = 500,moveType = 3,start = 1,startPos = nil,dir = 0,timeOut = 40,res = "role/missile_02"},
	-- 追击示例
	-- {id = 4,speed = 400,radius = 400,moveType = 2,start = 1,startPos = nil,dir = 0,timeOut = 30,res = "role/missile_02"},

	-- 子弹发射子弹示例
	-- 	{id = 1002,speed = 80,radius = 50,moveType = 1,start = 1,startPos = nil,dir = 0, timeOut = 60,subMissile = 10020,missileDelayTime=0,collierMissile = -1,colliderCount=1,res = "role/missile_02",audio="audio/bottle"},
	-- {id = 10020,speed = 80,radius = 50,moveType = 1,start = 1,startPos = nil,dir = 45, timeOut = 60,subMissile = 10021,missileDelayTime=0,collierMissile = -1,colliderCount=1,res = "role/missile_02"},
	-- {id = 10021,speed = 80,radius = 50,moveType = 1,start = 1,startPos = nil,dir : -45, timeOut : 60,subMissile : -1,missileDelayTime:0,collierMissile : -1,colliderCount:1,res : "role/missile_02"},
	--o:collierMissile 碰撞后产生子弹
	--o:subMissile 延迟产生子弹，delaytime  并发 或 先后

	{id = 1000,speed = 30,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0,timeOut = 10,subMissile = -1,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil},	
	{id = 1001,speed = 30,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0,timeOut = 10,subMissile = -1,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil}, 	
	{id = 1002,speed = 30,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0, timeOut = 10,subMissile = -1,missileDelayTime = 2,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil},
	-- {id = 10020,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 30, timeOut = 8,subMissile = 10021,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10021,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = -30, timeOut = 8,subMissile = -1,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	{id = 1003,speed = 30,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0, timeOut = 10,subMissile = -1,missileDelayTime = 2,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil},
	-- {id = 10030,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0, timeOut = 8,subMissile = 10031,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10031,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 30, timeOut = 8,subMissile = 10032,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10032,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = -30, timeOut = 8,subMissile = -1,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	{id = 1004,speed = 30,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0, timeOut = 10,subMissile = -1,missileDelayTime = 2,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil},
	-- {id = 10040,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 30, timeOut = 8,subMissile = 10041,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10041,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = -30, timeOut = 8,subMissile = 10042,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10042,speed = 20,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 60, timeOut = 8,subMissile = 10043,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10043,speed = 20,radius = 10,moveType = 3,start = 1,startPos = nil,dir = -60, timeOut = 8,subMissile = -1,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	{id = 1005,speed = 30,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0, timeOut = 10,subMissile = -1,missileDelayTime = 2,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil},
	-- {id = 10050,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 30, timeOut = 8,subMissile = 10051,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10051,speed = 25,radius = 10,moveType = 3,start = 1,startPos = nil,dir = -30, timeOut = 8,subMissile = 10052,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10052,speed = 20,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 60, timeOut = 8,subMissile = 10053,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},
	-- {id = 10053,speed = 20,radius = 10,moveType = 3,start = 1,startPos = nil,dir = -60, timeOut = 8,subMissile = -1,missileDelayTime = 0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,},


	{id = 2001,speed = 16,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0,timeOut = 20,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil},  	
	{id = 2002,speed = 16,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0,timeOut = 20,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount = 1,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil},  	

	{id = 6001,speed = 50,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0,timeOut = 12,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount = 5,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil},	
	{id = 6002,speed = 30,radius = 10,moveType = 3,start = 1,startPos = nil,dir = 0,timeOut = 12,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount = 5,res = "resources/effect/missile_1.prefab",hitEffect = nil,audio = nil}, 	

}

return missileConfig