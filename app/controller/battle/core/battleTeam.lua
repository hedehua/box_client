local Character = require("app.controller.battle.core.character")
local Missile = require("app.controller.battle.core.missile")
local BattleDrop = require("app.controller.battle.core.battleDrop")
local Enum = require("app.controller.battle.core.battleEnum")
local Vector2 = require("app.controller.battle.core.vector2")
local Utils = require("app.controller.battle.core.battleUtils")
local WorldConfig = require("app.controller.battle.config.worldConfig")
local Ai = require("app.controller.battle.core.ai")
local maxSize = 100

local BattleTeam = {}
BattleTeam.super = Character
BattleTeam.__cname = "BattleTeam"

setmetatable( BattleTeam,{__index = Character})
function BattleTeam.new()

	local obj = Character.new()
	setmetatable(obj,{__index = BattleTeam})
	obj._ctrlId 	= nil

	obj._members = nil
	obj._curDirection = nil
	obj._bornPos = nil
	obj._bornDir = nil

	obj._isAi = false
	obj._queier = nil
	obj._ai = nil
	obj._isBasement = false 
	obj._paths = nil

	obj._reviveTime = -1
	obj._waitJoinMember = nil

	obj._dropId = nil			-- 死亡時掉落

	obj._killCount = 0
	obj._coinCount = 0
	obj._aiInterval = 0

	obj._moveInterval = 1
	obj._tickTime = 0

	return obj
end

function BattleTeam:onCast( )
	self:addCoin(-1)
end

function BattleTeam:castSkillEx()
	if(self._skills == nil) then
		print('no skill')
		return
	end
	if(self._coinCount <= 0) then
		return
	end

	local index = self:getMass()
	local skill = self._skills[index]
	if(skill == nil) then
		print("no skill")
		return
	end

	self:castSkill(skill:getId())
end

function BattleTeam:update()

	BattleTeam.super.update(self)

	if(self._reviveTime >= 0 and self._frameCount > self._reviveTime)then
		self:revive()
		self._reviveTime = -1
	end

	if(not self:isAlive())then
		return;
	end
	
	self:updatePath()
	self:updateAi();
	self:updateMember();

end

function BattleTeam:init (typeId,pos,dir,camp,flag,ctrlId,coin)
	
	BattleTeam.super.init(self,typeId,pos,dir,camp)
	
	self._ctrlId = ctrlId
	self._bornPos = self:getPos()
	self._bornDir = self:getDir()
	self._coinCount = coin or 0
	self._curDirection = Utils.arrToDirection(self._bornDir.x,self._bornDir.y)
	self:setLeader(flag)
	self:setLayer(1)
	self:initAi()

end

function BattleTeam:uninit()

	BattleTeam.super.uninit(self)

	if(self._members ~= nil)then
		for i =1,#self._members do
			local m = self._members[i]
			if(m ~= nil)then
				m:uninit()
			end
		end
		self._members = nil
	end

	self._bornDir = nil
	self._bornPos = nil
	self._curDirection = nil
end

function BattleTeam:isMonster() 
	return self._camp == Enum.ECamp.Red
end

function BattleTeam:initAi() 
	self._ai = Ai.new(self._config.ai,self)
	self:resetAi()
end

function BattleTeam:resetAi(  )
	self._aiInterval = self._frameCount + WorldConfig.aiInterval
end

function BattleTeam:updateAi() 
	if(not self._isAi)then
		return
	end

	if(self._frameCount < self._aiInterval) then
		return
	end

	self:updateSkillAi()

	if(self._ai ~= nil)then
		self._ai:update();
	end

	self:resetAi()

end

function BattleTeam:isClass( clsName )
	return BattleTeam.super.isClass(self,clsName) or BattleTeam.__cname == clsName
end

function BattleTeam:setAi(ai) 
	self._isAi = ai
end

function BattleTeam:setDrop(dropId)
	self._dropId = dropId
end

function BattleTeam:setBasement()
	self._isBasement = true
end

function BattleTeam:move(dir)
	if(dir == self._curDirection)then
		return;
	end

	local arr = Utils.directionToArr(dir)

	if(arr == nil)then
		cc:log("dir to arr failure",dir)
		return;
	end

	self:moveEx(arr[1],arr[2]);

	self._curDirection = dir;
end

function BattleTeam:getLeader()
	return self
end

function BattleTeam:getTail()
	if(self._members == nil)then
		return self;
	end
	if(#self._members == 0)then
		return self;
	end
	return self._members[#self._members]
end

function BattleTeam:getLeaderPos() 			-- 获取队长的坐标
	local leader = self:getLeader()
	if(leader == nil)then
		return nil;
	end
	return leader:getPos()
end

function BattleTeam:getLeaderHp()
	local leader = self:getLeader()
	if(leader == nil)then
		return nil;
	end
	return leader:getHp()
end

function BattleTeam:updatePath( ... )
	if(self._paths == nil)then
		self._paths = {}
	end

	if(self:isMove()) then
		table.insert(self._paths,self:getPos())
	end

	if(#self._paths > maxSize)then
		table.remove(self._paths,1)
	end
end

function BattleTeam:updateMember()
	-- 新增队员
	if(self._waitJoinMember ~=nil) then
		for i = 1,#self._waitJoinMember do
			self:joinMember(self._waitJoinMember[i])
		end
		self._waitJoinMember = nil
	end

	if(self._members == nil)then
		return;
	end

	-- 同类别合并
	for i = 0,#self._members do
		local cur = self._members[i]
		if(i == 0) then
			cur = self
		end
		
		local nxt = self._members[i+1]
		if(cur:needRemove() or nxt == nil or nxt:needRemove())then
			
		else		
			if(cur:getMass() == nxt:getMass() and cur:getCategory() == nxt:getCategory())then
				cur:merge(nxt)
				nxt:beMerge(cur);
			end
		end
	end

	-- 更新逻辑

	local preMember = nil
	local step = math.floor(self:getDiameter() / self:getSpeed()) 
	local length = #self._paths

	for i = 1,#self._members do
		local member = self._members[i];
		local index = length - (i)* step
		local pos = self._paths[index] 
		if(pos == nil)then
			pos = self:getNextPos(preMember)
		end
		member:setPosAsync(pos)
		member:update();
		preMember = member
	end
	
	-- 移除队员
	-- update 后处理
	for i = #self._members,1,-1 do
		local member = self._members[i];
		if(member ~= nil and member:needRemove())then		 -- important
			self:removeMember(member)
		end
	end

end
function BattleTeam:addMember(member)
	if(self._members == nil)then
		self._members = {}
	end

	member:setTeam(self._id)
	table.insert(self._members,member);
end
function BattleTeam:removeMember(member)
	if(member == nil)then
		return;
	end
	if(self._members == nil)then
		return;
	end
	for i = #self._members,1,-1 do
		local m = self._members[i];
		if(m == member)then
			member:uninit()
			table.remove(self._members,i)
			break;
		end
	end
end

function BattleTeam:hitOther( target )
	self._killCount = self._killCount + 1
end

function BattleTeam:die() 

	if(self._state ~= Enum.ECharacterState.Init) then
		return
	end

	BattleTeam.super.die(self)

	self:notify("onDie",self,self._dropId)

	if(self._members ~= nil)then
		for i = #self._members,1, - 1 do
			local m = self._members[i]
			if(m ~= nil)then
				m:die()
			end
		end
	end

	self:initRevive()
end

function BattleTeam:initRevive() 

	if(not self._enableRevive)then
		return false
	end

	self._state = Enum.ECharacterState.Revive
	self._reviveTime = self._frameCount + WorldConfig.reviewTime
	print("revive time",self._reviveTime)
	return true

end
function BattleTeam:revive() 
	-- body...
	if(self._members ~= nil)then
		for i = #self._members,1,-1 do
			local m = self._members[i]
			if(m ~= nil)then
				m:uninit()
				table.remove(self._members,i)
			end
		end
	end

	self._curDirection = Utils.arrToDirection(self._bornDir.x,self._bornDir.y)
	self._killCount = 0
	self:setPos(self._bornPos:clone())
	self:updateRenderPos()

	BattleTeam.super.revive(self)	
end

function BattleTeam:addCoin( count )
	self._coinCount = self._coinCount + count
end

function BattleTeam:pickMember(data) 
	local typeId = data.typeId
	if(self._waitJoinMember == nil)then
		self._waitJoinMember = {}
	end
	table.insert(self._waitJoinMember,typeId)
end

function BattleTeam:pickItem(data) 
	local config = data.config
	if(config == nil)then
		print("pickItem error")
		return
	end
	local itemType = config.itemType
	local val = config.arg1
	
	local refs = {
		[1] = function ( )
			self:addHp(nil,val)
		end,
		[2] = function( )
			self:addCoin(val)
		end
	}
	refs[itemType]()
	
end

function BattleTeam:getNextPos(ch)
	if(ch == nil)then
		return self:getPos()
	end

	local pos =  ch:getPos();
	local dir = ch:getDir();
	local dist = ch:getDiameter()   	 -- 暂时认为所有成员体积一致（简化模型）
	return pos:moveFace(dir:reverse(),dist)  
end

function BattleTeam:joinMember(typeId)
	
	local lastChar = self:getTail();
	local pos =  self:getNextPos(lastChar)
	local dir = lastChar:getDir();

	local member = Character.new();
	member:init(typeId,pos,dir,self._camp);
	member:setLayer(1);

	self:addMember(member);

end

function BattleTeam:moveEx(dx,dy)
	if(not self:isAlive()) then
		return
	end

	local dir =  Vector2.new(dx,dy);
	self:moveDir(dir)
	self._tickTime = 0
end

function BattleTeam:getDirection() 
	return self._curDirection
end

function BattleTeam:applyMemberPosQue(member,posQue) 
	if(posQue ~= nil and #posQue > 1)then
		for i = 1, #posQue do
			local c = posQue[i]
			local n = posQue[i + 1]
			member:changeDir(c.cross,n.dir)
		end
	end
end

function BattleTeam:isBlock(argument) 
	return false
end

function BattleTeam:beKnock(member) 
	if(member == nil)then
		return
	end

	if(member:isLeader())then
		return
	end

	member:die()
end

function BattleTeam:recieveKnock(  )
	return false
end

function BattleTeam:needCheckCollider()
	if(self:isBasement()) then
		return false
	end
	return true
end

function BattleTeam:getCoinCount( )
	return self._coinCount
end

function BattleTeam:getKillCount( ) 
	return self._killCount
end

function BattleTeam:getCtrlId( ) 
	return self._ctrlId
end

function BattleTeam:isBasement()
	return self._isBasement
end

return BattleTeam