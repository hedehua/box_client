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
	-- {id = 1,speed = 0,radius = 6000,moveType = 0,start = 1,startPos = null,dir = 0,timeOut = 2,res = "role/missile_01"},	
	-- 直接攻击目标，与1003不同的是 1003是飞过去的
	-- {id = 2,speed = 0,radius = 100,moveType = null,start = 2,startPos = [0,0],dir = 0,timeOut = 0,res = "role/missile_02"},
	-- 定向示例
	-- {id = 1002,speed = 800,radius = 500,moveType = 1,start = 1,startPos = null,dir = 0, timeOut = 30,res = "role/missile_02"},	
	-- 目标位置示例
	-- {id = 3,speed = 400,radius = 500,moveType = 3,start = 1,startPos = null,dir = 0,timeOut = 40,res = "role/missile_02"},
	-- 追击示例
	-- {id = 4,speed = 400,radius = 400,moveType = 2,start = 1,startPos = null,dir = 0,timeOut = 30,res = "role/missile_02"},

	-- 子弹发射子弹示例
	-- 	{id = 1002,speed = 80,radius = 50,moveType = 1,start = 1,startPos = null,dir = 0, timeOut = 60,subMissile = 10020,missileDelayTime=0,collierMissile = -1,colliderCount=1,res = "role/missile_02",audio="audio/bottle"},
	-- {id = 10020,speed = 80,radius = 50,moveType = 1,start = 1,startPos = null,dir = 45, timeOut = 60,subMissile = 10021,missileDelayTime=0,collierMissile = -1,colliderCount=1,res = "role/missile_02"},
	-- {id = 10021,speed = 80,radius = 50,moveType = 1,start = 1,startPos = null,dir : -45, timeOut : 60,subMissile : -1,missileDelayTime:0,collierMissile : -1,colliderCount:1,res : "role/missile_02"},
	--o:collierMissile 碰撞后产生子弹
	--o:subMissile 延迟产生子弹，delaytime  并发 或 先后


	{id = 1001,speed = 30,radius = 10,moveType = 3,start = 1,startPos = null,dir = 0,timeOut = 10,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=100,res = "resources/effect/missile_1.prefab",hitEffect="resources/effect/p_collier.prefab",audio="resources/audio/bottle"},   -- TODO==	
	-- {id = 10010,speed = 160,radius = 50,moveType = 2,start = 1,startPos = null,dir = 30, timeOut = 20,subMissile = 10011,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile",hitEffect="resources/effect/p_collier.prefab",},
	-- {id = 10011,speed = 160,radius = 50,moveType = 2,start = 1,startPos = null,dir = -30, timeOut = 20,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile",hitEffect="resources/effect/p_collier.prefab",},
	-- {id = 10012,speed = 160,radius = 50,moveType = 1,start = 1,startPos = null,dir = 60, timeOut = 20,subMissile = 10013,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile",hitEffect="resources/effect/p_collier.prefab",},
	-- {id = 10013,speed = 160,radius = 50,moveType = 1,start = 1,startPos = null,dir = -60, timeOut = 20,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile",hitEffect="resources/effect/p_collier.prefab",},


	{id = 1002,speed = 25,radius = 10,moveType = 1,start = 1,startPos = null,dir = 0, timeOut = 12,subMissile = 10020,missileDelayTime=1,collierMissile = -1,hitCount=1,res = "resources/effect/missile_1.prefab",hitEffect="resources/effect/p_collier.prefab",audio="resources/audio/bottle"},
	{id = 10020,speed = 25,radius = 10,moveType = 1,start = 1,startPos = null,dir = 30, timeOut = 8,subMissile = 10021,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile_1.prefab",hitEffect="resources/effect/p_collier.prefab",},
	{id = 10021,speed = 25,radius = 10,moveType = 1,start = 1,startPos = null,dir = -30, timeOut = 8,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile_1.prefab",hitEffect="resources/effect/p_collier.prefab",},

	-- {id = 1003,speed = 0,radius = 50,moveType = 0,start = 2,startPos = null,dir = -1, timeOut = 3,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/p_shandian",hitEffect="resources/effect/p_collier.prefab"},
	-- {id = 1004,speed = 0,radius = 600,moveType = 4,start = 1,startPos = [0,0],dir = 0,timeOut = 2,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/jz_120",hitEffect="resources/effect/p_collier.prefab",audio="audio/moon"},

	-- {id = 1005,speed = 100,radius = 50,moveType = 1,start = 1,startPos =null,dir = 0,timeOut = 80,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile",hitEffect="resources/effect/p_collier.prefab",audio="audio/moon"},

	-- {id = 1007,speed = 120,radius = 60,moveType = 3,start = 1,startPos = null,dir = 0, timeOut = 25,subMissile = -1,missileDelayTime=0,collierMissile = 10070,hitCount=1,res = "resources/effect/p_daodan",hitEffect="resources/effect/p_collier.prefab",audio="audio/bottle"},
	-- {id = 10070,speed = 80,radius = 300,moveType = 1,start = 2,startPos = null,dir = 0, timeOut = 10,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile_jin_orange",hitEffect="resources/effect/p_collier.prefab",},
	
	-- {id = 1009,speed = 0,radius = 0,moveType = 0,start = 2,startPos = null,dir = -1, timeOut = 25,subMissile = 10090,missileDelayTime=9,collierMissile = -1,hitCount=1,res = "resources/effect/missile_yunshi",hitEffect=null,audio="audio/bottle"},
	-- {id = 10090,speed = 0,radius = 50,moveType = 0,start = 3,startPos = null,dir = -1, timeOut = 5,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = null,hitEffect="resources/effect/p_collier.prefab",audio=null},

	-- {id = 5001,speed = 100,radius = 50,moveType = 2,start = 1,startPos = null,dir = 0,timeOut = 10,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile_jin_orange"},
	-- {id = 5002,speed = 160,radius = 50,moveType = 1,start = 1,startPos = null,dir = 0,timeOut = 20,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/missile_yuan"},	
	-- {id = 5003,speed = 80,radius = 50,moveType = 3,start = 1,startPos = null,dir = 0,timeOut = 30,subMissile = -1,missileDelayTime=0,collierMissile = -1,hitCount=1,res = "resources/effect/p_fire"},	
}

return missileConfig