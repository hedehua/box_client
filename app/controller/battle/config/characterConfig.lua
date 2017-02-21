local charConfig = {
	-- 圆形
	{id = 1000,name = "", skill ={1002},speed = 8,collect = nil,radius = 30,maxHp = 4,defaultHp = 4, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '4'},
	
	{id = 1001,name = "", skill = nil,speed = 8,collect = nil,radius = 30,maxHp = 2,defaultHp = 2, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '1'},
	{id = 1002,name = "", skill = nil,speed = 8,collect = nil,radius = 30,maxHp = 4,defaultHp = 4, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '2'},
	{id = 1003,name = "", skill = nil,speed = 8,collect = nil,radius = 30,maxHp = 8,defaultHp = 8, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '3'},
	
	-- 怪物 3v3
	{id = 5001,name = "",skill = nil,speed = 2,collect = nil,radius = 30,maxHp = 1,defaultHp = 1, knockCd = 10,category = 1,attack = 1,res = "resources/role/monster.prefab",icon = "monster"},
	{id = 5002,name = "",skill = nil,speed = 0,collect = nil,radius = 30,maxHp = 1,defaultHp = 1, knockCd = 10,category = 2,attack = 1,res = "resources/role/monster.prefab",icon = "monster"},
	
	-- 怪物 endless 
	{id = 5003,name = "",skill = nil,speed = 2,collect = nil,radius = 30,maxHp = 2,defaultHp = 1, knockCd = 10,category = 1,attack = 1,res = "resources/role/monster.prefab",icon = "monster"},
	{id = 5004,name = "",skill = nil,speed = 0,collect = nil,radius = 30,maxHp = 2,defaultHp = 1, knockCd = 10,category = 2,attack = 1,res = "resources/role/monster.prefab",icon = "monster"},
	

	-- 塔 3v3
	{id = 6001,name = "16",skill ={1001},speed = 0,collect = nil,radius = 60,maxHp = 32,defaultHp = 32, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '16'},
	{id = 6002,name = "16",skill ={1001},speed = 0,collect = nil,radius = 60,maxHp = 32,defaultHp = 32, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '16'},

}

return charConfig