local Enum = require("app.controller.battle.core.battleEnum")
local CharacterConfig = require("app.controller.battle.config.characterConfig")
local ItemConfig = require("app.controller.battle.config.itemConfig")
local Random = require("app.controller.battle.core.random")
local BattleObject = require("app.controller.battle.core.battleObject")

local battleUtils = {
	getConfig = function (tb,id) 
		if(tb == nil) then
			return nil;
		end
		for i = 1,table.length(tb) do
			local item = tb[i]
			if(item ~= nil and item.id == id) then
				return item
			end
		end
		return nil;
	end,
	getConfigByGroup = function (tb,groupId) 
		if(tb == nil or groupId <=0 )then
			return
		end
		local t = {}
		for i = 1,table.length(tb) do
			local item = tb[i]
			if(item ~= nil and item.groupId == groupId) then
				table.insert(t,item)
			end
		end
		return t;
	end,
	getConfigByDrop = function (dropType,typeId) 
		if(dropType == nil or typeId == nil) then
			return nil;
		end
		local refs = {
			[Enum.DropType.Role] = function(  )
				return battleUtils.getConfig(CharacterConfig,typeId)
			end,
			[Enum.DropType.Item] = function( ... )
				return battleUtils.getConfig(ItemConfig,typeId)
			end
		}
		return refs[dropType]()	
	end,
	random = function (min,max) 
		return Random.random(min,max) 
	end,
	setSeed = function(seed) 
		Random.setSeed(seed)
	end,
	angleToDirection = function(angle) 
		if(angle >= -math.PI / 4 and angle < math.PI /4) then
			return Enum.Direction.Right
		end

		if(angle >= math.PI / 4 and angle < math.PI *3/4 ) then
			return Enum.Direction.Up
		end

		if(angle >= math.PI * 3/4 or angle < - math.PI * 3/4)then
			return Enum.Direction.Left
		end

		if(angle >=  - math.PI * 3/4 and angle < - math.PI *1/4 )then
			return Enum.Direction.Down
		end
		return nil
	end,
	directionToArr = function (dir) 
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
	end,
	arrToDirection = function(x,y) 
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
	end,
	TurnLeft = function(dir) 
		local r = dir - 1
		if(r <= Enum.Direction.None) then
			r = Enum.Direction.Left
		end
		return r
	end,
	TurnRight = function(dir) 
		local r = dir + 1
		if(r > Enum.Direction.Left ) then
			r = Enum.Direction.Up
		end
		return r
	end,
	isReversDirection = function(d1,d2) 
		if(d1 == nil or d2 == nil) then
			return nil
		end
		return math.abs(d1 - d2) == 2
	end,
	getDropByDist = function(casterId,dist)
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
		for i =1,table.length(objects) do
			local obj = objects[i]
			if(obj.__cname == "BattleDrop")then
				if(obj:dist(self)<=d and not obj:needRemove())then
					d = obj:dist(self)
					t = obj
				end
			end
		end
		return t
	end,
	getEnemyByDist= function(casterId,dist) 
		local objects = BattleObject.getAll()
		if(objects == nil)then
			return nil
		end
		local self = BattleObject.getObjectById(casterId)

		if(self == nil)then
			return nil;
		end

		local d = dist
		local t = nil
		for i =1,table.length(objects) do
			local obj = objects[i]
			if(obj.__cname == "Character") then
				
				if(obj:isAlive() and obj:getCamp() ~= self:getCamp() and obj:dist(self)<=d) then
					d = obj:dist(self)
					t = obj
				end
			end
		end
		return t
	end,
	getLessHpPartner = function(casterId) 
		local objects = BattleObject.getAll()
		if(objects == nil) then
			return nil
		end

		local self = BattleObject.getObjectById(casterId)

		if(self == nil)then
			return
		end

		local ret = nil
		for i = 1,table.length(objects) do
			local obj = objects[i]
			if(obj.__cname == "Character")then
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
	end,
	getAllPartner = function(casterId) 
		local objects = BattleObject.getAll()
		if(objects == nil)then
			return nil
		end

		local self = BattleObject.getObjectById(casterId)

		if(self == nil)then
			return
		end

		local ret = {}
		for i = 1,table.length(objects) do
			local obj = objects[i]
			if(obj.__cname == "Character") then
				if(obj:getTeam() == self:getTeam()) then
					table.insert(ret,obj)
				end
			end
		end
		return ret
	end,
	getObjectByType = function(classType)
		return BattleObject.getObjectByType(classType);
	end,
	getOtherCamp = function(camp) 
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
}

return battleUtils