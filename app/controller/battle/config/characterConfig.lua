local charConfig = {
	-- 圆形
	{id = 1000,name = "1", skill ={1002},speed = 10,collect = nil,radius = 30,maxHp = 32,defaultHp = 4, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '4'},
	
	{id = 1001,name = "1", skill = nil,speed = 10,collect = nil,radius = 30,maxHp = 32,defaultHp = 1, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '1'},
	{id = 1002,name = "2", skill = nil,speed = 10,collect = nil,radius = 30,maxHp = 32,defaultHp = 2, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '2'},
	{id = 1003,name = "3", skill = nil,speed = 10,collect = nil,radius = 30,maxHp = 32,defaultHp = 3, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '3'},
	
	-- -- 方形
	-- {id = 2001,name = "2", skill ={1002},speed = 60,collect = nil,radius = 200,maxHp = 32,defaultHp = 2, knockCd = 10,category = 2,attack = 1,res = "resources/role/hero_2",icon = '2'},
	-- {id = 2002,name = "2", skill ={1002},speed = 60,collect = nil,radius = 200,maxHp = 32,defaultHp = 2, knockCd = 10,category = 2,attack = 1,res = "resources/role/hero_2",icon = '2'},
	-- {id = 2003,name = "2", skill ={1002},speed = 60,collect = nil,radius = 200,maxHp = 32,defaultHp = 2, knockCd = 10,category = 2,attack = 1,res = "resources/role/hero_2",icon = '2'},

	-- 怪物 3v3
	{id = 5001,name = "1",skill = nil,speed = 5,collect = nil,radius = 30,maxHp = 1,defaultHp = 1, knockCd = 10,category = 1,attack = 1,res = "resources/role/monster.prefab",icon = "monster"},
	{id = 5002,name = "1",skill = nil,speed = 0,collect = nil,radius = 30,maxHp = 1,defaultHp = 1, knockCd = 10,category = 2,attack = 1,res = "resources/role/monster.prefab",icon = "monster"},
	
	-- 怪物 endless 
	{id = 5003,name = "1",skill = nil,speed = 5,collect = nil,radius = 30,maxHp = 2,defaultHp = 1, knockCd = 10,category = 1,attack = 1,res = "resources/role/monster.prefab",icon = "monster"},
	{id = 5004,name = "1",skill = nil,speed = 0,collect = nil,radius = 30,maxHp = 2,defaultHp = 1, knockCd = 10,category = 2,attack = 1,res = "resources/role/monster.prefab",icon = "monster"},
	

	-- 塔 3v3
	{id = 6001,name = "16",skill ={1001},speed = 0,collect = nil,radius = 60,maxHp = 32,defaultHp = 16, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '16'},
	{id = 6002,name = "16",skill ={1001},speed = 0,collect = nil,radius = 60,maxHp = 32,defaultHp = 16, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '16'},

}

return charConfig