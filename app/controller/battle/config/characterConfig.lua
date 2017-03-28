local charConfig = {
	-- player
	{id = 1000,name = "", ai = 1, skill = {1000,1001,1002,1003,1004,1005},speed = 7,collect = nil,radius = 30,mass = 2,maxHp = 4,defaultHp = 4, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '2'},
	
	-- partner
	{id = 1001,name = "", ai = 1, skill = nil,speed = 6,collect = nil,radius = 30,maxHp = 2,defaultHp = 2,mass = 1, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '1'},	
	
	-- npc
	{id = 2001,name = "", ai = 1, skill = {2001},speed = 6,collect = nil,radius = 30,maxHp = 4,defaultHp = 4,mass = 2, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '1'},
	
	-- monster
	{id = 2002,name = "", ai = 1, skill = {2002},speed = 4,collect = nil,radius = 30,maxHp = 2,defaultHp = 2,mass = 2, knockCd = 10,category = 1,attack = 1,res = "resources/role/hero_1.prefab",icon = '1'},

	-- tower
	{id = 6001,name = "", ai = 2, skill = {6001},speed = 2,collect = nil,radius = 60,maxHp = 8,defaultHp = 8,mass = 3, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '3'},
	{id = 6002,name = "", ai = 2, skill = {6002},speed = 2,collect = nil,radius = 60,maxHp = 8,defaultHp = 8,mass = 3, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '2'},

	{id = 6003,name = "", ai = 2, skill = {6001},speed = 2,collect = nil,radius = 60,maxHp = 8,defaultHp = 8,mass = 3, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '3'},
	{id = 6004,name = "", ai = 2, skill = {6002},speed = 2,collect = nil,radius = 60,maxHp = 16,defaultHp = 16,mass = 4, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '4'},

	{id = 6005,name = "", ai = 2, skill = {6001},speed = 2,collect = nil,radius = 60,maxHp = 8,defaultHp = 8,mass = 3, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '3'},
	{id = 6006,name = "", ai = 2, skill = {6002},speed = 2,collect = nil,radius = 60,maxHp = 32,defaultHp = 32,mass = 5, knockCd = 1,category = 1,attack = 16,res = "resources/role/hero_1.prefab",icon = '5'},


}

return charConfig