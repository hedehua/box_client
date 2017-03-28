-- -- itemType: 1 = hp 2 = coin 

local ItemConfig = {
	{id = 1001,name = "1",itemType = 1,arg1 = 1,radius = 30,res = "resources/item/item_role.prefab",icon = '1'},   				-- 回复血量1点
	{id = 1002,name = "2",itemType = 1,arg1 = 2,radius = 30,res = "resources/item/item_role.prefab",icon = '2'},   				-- 回复血量1点
	{id = 2001,name = "coin",itemType = 2,arg1 = 5,radius = 30,res = "resources/item/item_coin.prefab",icon =""}, 			-- 一枚金币
	{id = 2002,name = "coin",itemType = 2,arg1 = 100,radius = 30,res = "resources/item/item_coin.prefab",icon =""}, 			-- 十枚金币
}

return  ItemConfig