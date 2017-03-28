local Utils = require("app.controller.battle.core.battleUtils")
local Vector2 = require("app.controller.battle.core.vector2")
local BattleObject = require("app.controller.battle.core.battleObject")

local BattleMap = {}
BattleMap.super = BattleObject
BattleMap.__cname = "BattleMap"
setmetatable(BattleMap,{__index = BattleObject})
function BattleMap.new( ... )
	local obj = BattleObject.new();
	setmetatable(obj,{__index = BattleMap})

	return obj
end

 function BattleMap:init(width,height,res)
	
	BattleMap.super.init(self)

	self:setBoxCollider(0,0,width,height)

	if(self._render ~= nil ) then
		-- self._render:setSize(width,height)
		self._render:setVisible(true)
		self._render:disableDynamic(true)
		self._render:loadAvatar(res)
	end
end

function BattleMap:getValidPos() 
	local bounds = self:getCollider()
	local pos = {Utils.random(bounds:left() + 100,bounds:right() -100),Utils.random(bounds:bottom() + 400,bounds:top() - 400)}
	return pos
end

function BattleMap:clampPos( pos )
	if(pos == nil) then
		return
	end


	local left = self._collider:left()
	local right = self._collider:right()
	local top = self._collider:top()
	local bottom = self._collider:bottom()
	local x = math.min(math.max(left,pos.x),right)
	local y = math.min(math.max(bottom,pos.y),top)
	return Vector2.new(x,y)
end

function BattleMap:isBlock( )
	return true
end

return BattleMap