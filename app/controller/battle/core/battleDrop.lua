local Utils = require("app.controller.battle.core.battleUtils")
local BattleObject = require("app.controller.battle.core.battleObject")
local DropConfig = require("app.controller.battle.config.dropConfig")
local WorldConfig = require("app.controller.battle.config.worldConfig")
local Enum = require("app.controller.battle.core.battleEnum")

local BattleDrop = {}
BattleDrop.super = BattleObject
BattleDrop.__cname = "BattleDrop"

setmetatable(BattleDrop,{__index = BattleObject})

function BattleDrop.new(  )
	local obj = BattleObject:new();
	setmetatable(obj,{__index = BattleDrop})

	obj._typeId = 0  			-- 配置表id
	obj._frameCount = 0
	obj._timeOut = 0
	obj._needRemove = false
	obj._config = nil    		--  配置表
	obj._camp = nil			--  只能被所属阵营拾取
	obj._contentConfig = nil  --  实际承载的物品配置

	obj._targetObj = nil		-- 被玩家吸引

	return obj
end

function BattleDrop:init(typeId,camp,pos) 
	
	BattleDrop.super.init(self,typeId,camp,pos)
	self._typeId = typeId
	self._camp = camp
	self._enableRot = false

	self._config = Utils.getConfig(DropConfig,self._typeId)

	if(self._config == nil)then
		return
	end

	self._timeOut = self._config.timeOut
	self._contentConfig = Utils.getConfigByDrop(self._config.dropType,self._config.typeId)

	self:setPos(pos)
	self:setCircleCollider(pos.x,pos.y,self._contentConfig.radius)
	self:setSpeed(WorldConfig.dropSpeed)
	
	if(self._render ~= nil)then
		self._render:setIcon(self._contentConfig.icon)
		self._render:setCamp(Enum.ECamp.None)
		self._render:setSize(self._contentConfig.radius * 2,self._contentConfig.radius * 2)
	end
	self:loadAvatar(self._contentConfig.res) 
end
function BattleDrop:update() 
	
	self._frameCount = self._frameCount+1;
	if(self._frameCount > self._timeOut)then
		self._needRemove = true
		return
	end

	if(self._targetObj ~=nil and self._targetObj:isValid())then
        self:moveTo(self._targetObj:getPos(),true)
    end

	if(self._render ~= nil)then
		self._render:updatePos(self._pos,self._dir);
	end

	-- if(self._frameCount == self._timeOut - WorldConfig.bornTime){
	-- 	if(self._render ~= nil){
	-- 		self._render.startBlink()
	-- 	}
	-- }

	BattleDrop.super.update(self)
end
function BattleDrop:needRemove(argument) 
	return self._needRemove
end
function BattleDrop:bePicked(argument)  -- 被拾取
	self._needRemove = true
end
function BattleDrop:getCamp() 
	return self._camp
end
function BattleDrop:getDrop() 
	if(self._config == nil)then
		return nil
	end
	return {
		dropType 	= self._config.dropType,
		typeId 		= self._config.typeId,
		config 		= self._contentConfig,
	}
end
function BattleDrop:isBlock(argument) 
	return false
end
function BattleDrop:beDetect(character,dist)
	
	if(self._targetObj ~= nil)then
		return
	end
	if(character == nil)then
		return 
	end
	local range = character:getCollectRange()
	if(range == nil)then
		return
	end

	if(range >= dist )then
		self._targetObj = character
	end
end

return BattleDrop