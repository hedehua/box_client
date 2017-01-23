-- 战斗中对象的基类
local Vector2 = require("app.controller.battle.core.vector2")
local CircleCollider = require("app.controller.battle.core.circleCollider")
local BoxCollider = require("app.controller.battle.core.boxCollider")


local BattleObject = {}
BattleObject.__cname = "BattleObject"

-- static 
local static_count = 0
local objects = nil
local objectsDic = nil
local getNextId = function()
	static_count = static_count + 1
	return static_count;
end
local renderCreator = nil
local renderDestroy = nil
local needRender = true

local createRender = function(obj)
	if(renderCreator ~= nil)then
		return renderCreator(obj);
	end
	return nil
end
local destoryRender = function(obj)
	if(renderDestroy~= nil)then
		return renderDestroy(obj);
	end
end
local addObject = function (obj) 
	if(objects == nil)then
		objects = {}
		objectsDic = {}
	end
	table.insert(objects,obj)
	objectsDic[obj._id] = obj
end
local removeObject = function (obj) 
	if(objects == nil) then
		return
	end
	for i = table.length(objects) ,1,-1 do
		local o = objects[i]
		if(o == obj) then 
			table.remove(objects,i)
			objectsDic[obj._id] = nil
		end
	end
end

BattleObject.getAll = function()
	return objects
end
BattleObject.clearAll = function()
	if(objects ~= nil) then
		for i = 1,#objects do
			local obj = objects[i]
			if(obj ~= nil) then
				obj:uninit()
			end
		end
	end
	
	objects = nil
end
BattleObject.getObjectById = function (id) 
	-- if(objects == nil)
	-- 	return nil
	-- end
	-- for(local i = objects.length - 1;i >=0 ;i--)
	-- 	local obj = objects[i]
	-- 	if(id === obj._id)
	-- 		return obj
	-- 	end
	-- end
	if(objectsDic == nil)then
		return nil
	end
	return objectsDic[id]
end

BattleObject.getObjectByType = function(classType)
	if(objects == nil) then 
		return nil
	end
	for  i = table.length(objects),1,-1 do
		local obj = objects[i]
		if(classType == obj.__cname) then
			return obj
		end
	end
	return nil
end

BattleObject.getObjectsByType = function()
	if(objects == nil) then
		return nil
	end
	local arr = {}
	for i = table.length(objects),1,-1 do
		local obj = objects[i]
		if(classType == obj.__cname) then
			table.insert(arr,obj)
		end
	end
	return arr
end

BattleObject.setRenderFactory = function(createor,destroyor)
	renderCreator = createor
	renderDestroy = destroyor
end

BattleObject.setNeedRender = function(need)
	needRender = need
end

function BattleObject.new()
	local obj = {}
	setmetatable(obj,{__index = BattleObject})
	obj._valid = false
	obj._id = getNextId()
	obj._pos = nil
	obj._radius = 1					-- 半径 					
	obj._speed = 0       				-- 每帧移动距离
	obj._isMove = false  				-- 是否移动中
	obj._targetPos = nil  			-- 期望移动的目的地
	obj._restMoveTime = 0 			-- 剩余的移动时间
	obj._dir = nil					-- 当前的移动方向

	obj._collider = nil				-- 碰撞盒（可能为空）
	obj._layer    = 0				-- 层，用于区分是否需要碰撞检测
	obj._enableRot = true			-- 用于显示用的标识位，表现是否有朝向

	obj._queier = nil
	obj._render = nil

	return obj
end
-- static end


function BattleObject:init()
	
	self._pos = Vector2.new();
	self._valid = true
	self._recalcMove = true
	
	if(self._render == nil) then
		self._render = createRender(self);
		-- print(self.__cname,self._id,self._render._id,debug.traceback())
	end

	addObject(self)

end

function BattleObject:loadAvatar(res)
	if(self._render ~= nil and needRender) then
		self._render:loadAvatar(res)
	end
end

function BattleObject:uninit()

	-- print("--------------------------------remove --------",self._id)
	removeObject(self)

	self._pos = nil
	self._valid = false

	if(self._render ~= nil) then
		destoryRender(self._render);
		self._render = nil
	end
end

function BattleObject:setQueier(q)
	self._queier = q
end
function BattleObject:request(eventType,arg1,arg2,arg3)
	if(self._queier == nil) then
		return nil;
	end
	local r = self._queier[eventType]
	if(r ~= nil) then
		return r(arg1,arg2,arg3);
	end
	return nil;
end
function BattleObject:notify(eventType,arg1,arg2,arg3)
	if(self._queier == nil) then
		return nil;
	end
	local r = self._queier[eventType]
	if(r ~= nil) then
		r(arg1,arg2,arg3);
	end
end

function BattleObject:isValid()
	return self._valid
end

function BattleObject:move(v)
	self._pos:add(v)
end

function BattleObject:needCheckCollider()   -- 只有队长需要主动发起碰撞检测
	return false
end

function BattleObject:isBlock(argument)    -- 是否是阻挡物
	return true
end

function BattleObject:recieveKnock(  )
	return true
end

function BattleObject:moveForward() 
	if(self._pos == nil) then
		print("self._pos == nil.");
		return false
	end
	local x = self._pos.x
	local y = self._pos.y 

	local step = self._speed 
	self._pos:moveFace(self._dir,step)

	if(self._collider ~=nil) then
		self._collider:setPos(self._pos.x,self._pos.y)
	end
	if(not self:needCheckCollider()) then
		return
	end

	local targets = objects
	local targetObjs = nil
	if(targets ~= nil) then
		for i = #targets,1,-1 do
			local target = targets[i]
			if(target ~= self and self:detect(target)) then

				if(targetObjs == nil) then
					targetObjs = {}
				end
				table.insert(targetObjs,target)
			end
		end
	end

	if(targetObjs ~= nil and #targetObjs >0) then
		for i = 1,#targetObjs do
			local targetObj = targetObjs[i]
			self:onTriger(self,targetObj)
		end
	end
	

	return true
end

function BattleObject:onTriger(source,target) 
	-- virtual
end

function BattleObject:beTriger(source) 
	-- body...
end

function BattleObject:updateMoveInfo() 
	if(not self._recalcMove) then
		return false
	end
	if(self._targetPos == nil or self._pos == nil) then
		return false
	end
	
	self._dir = self._targetPos:clone():sub(self._pos):norm()
	
	self._restMoveTime = self:getRestMoveTime() 
	self._recalcMove = false
	
	return true
end

function BattleObject:getRestMoveTime() 
	if(self._targetPos == nil or self._pos == nil) then
		return 0
	end
	local dist = self._pos:dist(self._targetPos)
	return math.floor(dist/self._speed);
end

function BattleObject:moveTo(pos,interrupt)   -- interrupt == true,强制打断当前移动

	if(self._isMove and not interrupt) then
		return;
	end

	if(self._speed <= 0 ) then
		return;
	end		

	self._recalcMove = true
	self._targetPos = pos:clone()
	self._isMove = true
	
end

function BattleObject:moveDir(dir)
	self._targetPos = nil
	self._dir = dir:clone():norm()
	self._restMoveTime = 0
	self._isMove = true
	self._recalcMove = true
	
end

function BattleObject:moveEnd()
	if(self._targetPos ~= nil) then
		if(self._pos == nil) then
			print("self._Pos nil !")
		end
		local dist = self._pos:dist(self._targetPos)
		self._pos:setv(self._targetPos.x,self._targetPos.y);
	end
	self:stopMove()
end

function BattleObject:stopMove() 
	self._isMove = false	
	self._targetPos = nil
	self._restMoveTime = 0
end

function BattleObject:update()

	if(not self:isValid()) then
		return;
	end

	self:updateMoveInfo();
	
	if(self:updatePos()) then
		-- print(self.__cname,self._id,"updatePos",'pos',self._pos.x,self._pos.y)
		self:updateRenderPos();
	end

end

function BattleObject:updateRenderPos() 
	if(self._render ~= nil) then
		self._render:updatePos(self._pos,self._dir,self._enableRot);
	end	
end

function BattleObject:getPos()
	if(self._pos == nil) then
		return nil
	end
	return self._pos:clone()
end
function BattleObject:setPosAsync(pos) 
	self._posCache = pos
end
function BattleObject:setPos(pos)
	self._pos = pos
	if(self._collider ~= nil) then
		self._collider:setPos(pos.x,pos.y)
	end
end
function BattleObject:dist(obj) 
	if(obj == nil) then
			return 0
	end
	return self._pos:dist(obj:getPos())
end
function BattleObject:setDir(dir)
	self._dir = dir:norm()
end
function BattleObject:getDir()
	if(self._dir == nil) then
		print("exception.")
		return
	end
	return self._dir:clone()
end
function BattleObject:isMove()
	return self._isMove
end
function BattleObject:isMoveT()   -- 当前模式为定点移动
	return self._targetPos ~= nil
end
function BattleObject:setSpeed(speed)
	self._speed = math.max(speed,0)
	self._recalcMove = true
end
function BattleObject:getSpeed() 
	return self._speed
end
function BattleObject:updatePos()
	if(self._posCache ~= nil) then
		self:setDir(self._posCache:clone():sub(self._pos))
		self:setPos(self._posCache)
		self._posCache = nil
		return true
	end
	if(not self._isMove) then
		return false;
	end
	if(self._targetPos == nil) then
		return self:moveForward()
	end
	
	self._restMoveTime = self._restMoveTime -1; --;

	if(self._restMoveTime <=0 ) then
		self:moveEnd()
		return true;
	end
	return self:moveForward()

end
function BattleObject:getRadius()
	if(self._collider == nil) then
		return 0
	end
	return self._collider.r
end

function BattleObject:getDiameter(value)
	return self:getRadius() * 2
end

function BattleObject:getCollider() 
	return self._collider
end
function BattleObject:detect(intruder) 

	if(intruder == nil or intruder:getCollider() == nil) then
		return false
	end
	if(self._collider == nil) then
		return false
	end

	local ret = false
	if(self._collider.__cname == "CircleCollider") then 
		if(intruder:getCollider().__cname == "CircleCollider" ) then
			ret = self._collider:detectCircle(intruder:getCollider())
		end
		if(intruder:getCollider().__cname == "BoxCollider")then
			ret = self._collider:detectBound(intruder:getCollider())
		end
		
		intruder:beDetect(self,self._collider:getDist())
	end
	return ret
end
function BattleObject:getCollectRange()
	return nil
end
-- @virtual
function BattleObject:beDetect(intruder,dist)
	
end
function BattleObject:setCircleCollider(x,y,r) 	 			
	if(self._collider == nil) then 
		self._collider = CircleCollider.new()
	end
	self._collider:setv(x,y,r)
end
function BattleObject:setBoxCollider(x,y,w,h) 
 				-- 目前以居中对齐的方式实现（上下居中，左右居中）
	if(self._collider == nil) then
		self._collider = BoxCollider.new();
	end
	self._collider:setv(x,y,w,h)
end
function BattleObject:setLayer( layer ) 
	self._layer = layer
end
function BattleObject:getLayer()
	return self._layer
end

return BattleObject 