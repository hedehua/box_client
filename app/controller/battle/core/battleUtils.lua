local Enum = require("app.controller.battle.core.battleEnum")
local CharacterConfig = require("app.controller.battle.config.characterConfig")
local ItemConfig = require("app.controller.battle.config.itemConfig")
local Random = require("app.controller.battle.core.random")
local BattleObject = require("app.controller.battle.core.battleObject")

local loadConfig = function( name )
	return require "app.controller.battle.config."..name
end

local getConfigByName = function( tableName,id )
	if(tableName == nil) then
		return nil
	end
	
	local tb = loadConfig(tableName)
	return getConfig(tb,id)
end

local getConfig = function (tb,id) 
	if(tb == nil) then
		return nil;
	end
	for i = 1,#tb do
		local item = tb[i]
		if(item ~= nil and item.id == id) then
			return item
		end
	end
	return nil;
end

local getConfigByGroup = function (tb,groupId) 
	if(tb == nil or groupId <=0 )then
		return
	end
	local t = {}
	for i = 1,#tb do
		local item = tb[i]
		if(item ~= nil and item.groupId == groupId) then
			table.insert(t,item)
		end
	end
	return t;
end

local getConfigByDrop = function (dropType,typeId) 
	if(dropType == nil or typeId == nil) then
		return nil;
	end
	local refs = {
		[Enum.DropType.Role] = function(  )
			return getConfig(CharacterConfig,typeId)
		end,
		[Enum.DropType.Item] = function( ... )
			return getConfig(ItemConfig,typeId)
		end
	}
	return refs[dropType]()	
end
local random = function (min,max) 
	return Random.random(min,max) 
end

local setSeed = function(seed) 
	Random.setSeed(seed)
end

local angleToDirection = function(angle) 
	if(angle >= -math.pi / 4 and angle < math.pi /4) then
		return Enum.Direction.Right
	end

	if(angle >= math.pi / 4 and angle < math.pi *3/4 ) then
		return Enum.Direction.Up
	end

	if(angle >= math.pi * 3/4 or angle < - math.pi * 3/4)then
		return Enum.Direction.Left
	end

	if(angle >=  - math.pi * 3/4 and angle < - math.pi *1/4 )then
		return Enum.Direction.Down
	end
	return nil
end

local directionToArr = function (dir) 
	local refs = {
		[Enum.Direction.Left] = function( ... )
			return {-1,0}
		end,
		[Enum.Direction.Right] = function( ... )
			return {1,0}
		end,
		[Enum.Direction.Down]  = function( ... )
			return {0,-1}
		end,
		[Enum.Direction.Up] = function( ... )
			return {0,1}
		end
	}
	return refs[dir]()
end

local arrToDirection = function(x,y) 
	if(x == nil or y == 0) then
		return nil
	end
	if(x < 0) then
		return Enum.Direction.Left
	end
	if(x > 0) then
		return Enum.Direction.Right
	end
	if( y > 0) then
		return Enum.Direction.Up
	end
	-- // cc.log("#",x,y,Enum.Direction.Down)
	return Enum.Direction.Down
end

local TurnLeft = function(dir) 
	local r = dir - 1
	if(r <= Enum.Direction.None) then
		r = Enum.Direction.Left
	end
	return r
end

local TurnRight = function(dir) 
	local r = dir + 1
	if(r > Enum.Direction.Left ) then
		r = Enum.Direction.Up
	end
	return r
end

local isReversDirection = function(d1,d2) 
	if(d1 == nil or d2 == nil) then
		return nil
	end
	return math.abs(d1 - d2) == 2
end

local getDropByDist = function(casterId,dist)
	local objects = BattleObject.getAll()
	if(objects == nil) then
		return nil
	end
	local self = BattleObject.getObjectById(casterId)

	if(self == nil)then
		return nil;
	end

	local d = dist
	local t = nil
	for i =1,#objects do
		local obj = objects[i]
		if(obj:isClass("BattleDrop"))then
			if(obj:dist(self)<=d and not obj:needRemove())then
				d = obj:dist(self)
				t = obj
			end
		end
	end
	return t
end

local getEnemyByDist= function(casterId,dist) 
	local objects = BattleObject.getAll()
	if(objects == nil)then
		return nil
	end
	local self = BattleObject.getObjectById(casterId)

	if(self == nil)then
		print("no casterId")
		return nil;
	end

	local d = dist
	local t = nil
	for i =1,#objects do
		local obj = objects[i]
		if(obj:isClass("Character")) then
			if(obj:isAlive() and obj:getCamp() ~= self:getCamp() and obj:dist(self)<=d) then
				d = obj:dist(self)
				t = obj
			end
		end
	end
	return t
end

local getLessHpPartner = function(casterId) 
	local objects = BattleObject.getAll()
	if(objects == nil) then
		return nil
	end

	local self = BattleObject.getObjectById(casterId)

	if(self == nil)then
		return
	end

	local ret = nil
	for i = 1,#objects do
		local obj = objects[i]
		if(obj:isClass("Character"))then
			if( obj:getTeam() == self:getTeam())then
				if(ret == nil)then
					ret = obj
				else
					if(obj:getHp() < ret:getHp())then
						ret = obj
					end
				end
				
			end
		end
	end
	return ret
end

local getAllPartner = function(casterId) 
	local objects = BattleObject.getAll()
	if(objects == nil)then
		return nil
	end

	local self = BattleObject.getObjectById(casterId)

	if(self == nil)then
		return
	end

	local ret = {}
	for i = 1,#objects do
		local obj = objects[i]
		if(obj:isClass("Character")) then
			if(obj:getTeam() == self:getTeam()) then
				table.insert(ret,obj)
			end
		end
	end
	return ret
end

local getObjectByType = function(classType)
	return BattleObject.getObjectByType(classType);
end

local getOtherCamp = function(camp) 
	if(camp == nil)then
		return nil
	end

	if(camp == Enum.ECamp.Blue) then
		return Enum.ECamp.Green
	end
	
	if(camp == Enum.ECamp.Green)then
		return Enum.ECamp.Blue
	end
	
	return nil
end

local getRandomIndexByChance = function( cfgArr )
	local t = {}
	local sum = 0;
	for i = 1, #cfgArr do
		local cfg = cfgArr[i]
		if(cfg ~= nil) then
			sum = sum + cfg.chance
			table.insert(t,sum)
		end
	end
	local r = random(0,sum)
	for i = 1,#t do
		if(r < t[i])then
			return i
		end
	end
	return -1
end

local battleUtils = {
	getConfig 			= getConfig,
	getConfigByGroup 	= getConfigByGroup,
	getConfigByDrop 	= getConfigByDrop,
	random 				= random,
	setSeed 			= setSeed,
	angleToDirection 	= angleToDirection,
	directionToArr 		= directionToArr,
	arrToDirection 		= arrToDirection,
	TurnLeft 			= TurnLeft,
	TurnRight 			= TurnRight,
	isReversDirection 	= isReversDirection,
	getDropByDist 		= getDropByDist,
	getEnemyByDist 		= getEnemyByDist,
	getLessHpPartner 	= getLessHpPartner,
	getAllPartner 		= getAllPartner,
	getObjectByType 	= getObjectByType,
	getOtherCamp 		= getOtherCamp,
	getRandomIndexByChance = getRandomIndexByChance,
}

return battleUtils