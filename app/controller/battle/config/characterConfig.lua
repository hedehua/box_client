local charConfig = {
	-- player
	{id = 1000,name = "", ai = 1, skill = {1000,1001,1002,1003,1004,1005},speed = 8,collect = nil,radius = 30,maxHp = 2,defaultHp = 2, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '1'},
	
	-- partner
	{id = 1001,name = "", ai = 1, skill = nil,speed = 6,collect = nil,radius = 30,maxHp = 2,defaultHp = 2, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '1'},	
	
	-- npc
	{id = 2001,name = "", ai = 1, skill = {2001},speed = 6,collect = nil,radius = 30,maxHp = 4,defaultHp = 4, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '2'},
	
	-- monster
	{id = 2002,name = "", ai = 1, skill = {2002},speed = 4,collect = nil,radius = 30,maxHp = 2,defaultHp = 2, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '1'},
				
	-- tower
	{id = 6001,name = "", ai = 2, skill = {6001},speed = 2,collect = nil,radius = 60,maxHp = 8,defaultHp = 8, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '3'},
	{id = 6002,name = "", ai = 2, skill = {6002},speed = 2,collect = nil,radius = 60,maxHp = 16,defaultHp = 16, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '4'},

}

return charConfig