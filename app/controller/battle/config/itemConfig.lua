-- -- itemType = 类别 1=加血 2=加速 

local ItemConfig = {
	{id = 1001,name = "1",itemType = 1,arg1 = 1,radius = 30,res = "resources/item/item_default.prefab",icon = '1'},   				-- 回复血量1点
	{id = 1002,name = "2",itemType = 1,arg1 = 2,radius = 30,res = "resources/item/item_default.prefab",icon = '2'},   				-- 回复血量1点
	{id = 1003,name = "3",itemType = 1,arg1 = 3,radius = 30,res = "resources/item/item_default.prefab",icon = '3'},   				-- 回复血量1点
	{id = 1004,name = "4",itemType = 1,arg1 = 4,radius = 30,res = "resources/item/item_default.prefab",icon = 'hp'},   
	{id = 2001,name = "加速瓶",arg1 = 2000,radius = 30,res = "resources/item/item_default.prefab",icon =""}, 				-- 速度加快20%
	{id = 3001,name = "金币袋（小）",arg1 = 1,radius = 30,res = "resources/item/item_default.prefab",icon =""}, 			-- 一枚金币
	{id = 4001,name = "金币袋（大）",arg1 = 100,radius = 30,res = "resources/item/item_default.prefab",icon =""}, 			-- 十枚金币
}

return  ItemConfig