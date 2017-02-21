local BattleObject = require("app.controller.battle.core.battleObject")
local Missile = require("app.controller.battle.core.missile")
local Character = require("app.controller.battle.core.character")
local BattleDrop = require("app.controller.battle.core.battleDrop")
local Enum = require("app.controller.battle.core.battleEnum")
local Vector2 = require("app.controller.battle.core.vector2")
local Utils = require("app.controller.battle.core.battleUtils")
local WorldConfig = require("app.controller.battle.config.worldConfig")
local Ai = require("app.controller.battle.core.ai")
local maxSize = 100

local BattleTeam = {}
BattleTeam.super = BattleObject
BattleTeam.__cname = "BattleTeam"

setmetatable( BattleTeam,{__index = BattleObject})
function BattleTeam.new()

	local obj = BattleObject.new()
	setmetatable(obj,{__index = BattleTeam})
	obj._ctrlId 	= nil
	-- obj._typeId = nil	-- same with leader
	obj._isFollowTarget = false
	obj._isAlive = nil
	obj._members = nil
	obj._curDirection = nil
	obj._bornPos = nil
	obj._bornDir = nil
	obj._needRemove = false
	obj._isAi = false
	obj._queier = nil
	obj._ai = nil
	obj._isRevive = false
	obj._isBasement = false 
	obj._paths = nil

	obj._reviveTime = -1
	obj._frameCount = 0
	obj._memberOriData = nil
	obj._waitJoinMember = nil

	obj._dropId = nil			-- 死亡時掉落

	obj._killCount = 0

	obj._moveInterval = 1
	obj._tickTime = 0

	return obj
end


function BattleTeam:update()

	if(not self:isValid()) then
		print("team",self._id,'no avalid')
		return;
	end
	self._frameCount = self._frameCount+1;

	if(self._reviveTime >= 0 and self._frameCount > self._reviveTime)then
		self:revive()
		self._reviveTime = -1
	end

	if(not self._isAlive)then
		return;
	end
	
	self:updateAi();
	self:updateMember();

	BattleTeam.super.update(self)
end
function BattleTeam:init (pos,dir,camp,flag,ctrlId)
	
	BattleTeam.super.init(self)
	
	self._isAlive = true
	self._ctrlId = ctrlId
	self._isFollowTarget = flag;
	self._bornPos = Vector2.new(pos[1],pos[2])
	self._bornDir = Vector2.new(dir[1],dir[2])
	self._camp = camp
	self._curDirection = Utils.arrToDirection(self._bornDir.x,self._bornDir.y)
	
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
	self._ai = Ai.new(1,self)
end
function BattleTeam:updateAi() 
	if(not self._isAi)then
		return
	end
	if(self._ai ~= nil)then
		self._ai:update();
	end
end
function BattleTeam:setAi(ai) 
	self._isAi = ai
end
function BattleTeam:setRevive(revive)
	self._isRevive = revive
end
function BattleTeam:setDrop(dropId)
	self._dropId = dropId
end
function BattleTeam:setBasement()
	self._isBasement = true
end
function BattleTeam:setQueier(q)
	self._queier = q
end
function BattleTeam:request(eventType,arg1,arg2,arg3)
	if(self._queier == nil)then
		return nil;
	end
	local r = self._queier[eventType]
	if(r ~= nil)then
		return r(arg1,arg2,arg3);
	end
	return nil;
end
function BattleTeam:notify(eventType,arg1,arg2,arg3)
	if(self._queier == nil)then
		return nil;
	end
	local r = self._queier[eventType]
	if(r ~= nil)then
		r(arg1,arg2,arg3);
	end
end
function BattleTeam:getCamp(argument) 
	return self._camp
end
function BattleTeam:needRemove(argument) 
	return self._needRemove
end

function BattleTeam:move(dir)
	if(dir == self._curDirection)then
		return;
	end

	-- if(Utils.isReversDirection(dir,self._curDirection)){
	-- 	return;
	-- }

	local arr = Utils.directionToArr(dir)

	if(arr == nil)then
		cc:log("dir to arr failure",dir)
		return;
	end

	self:changeTeamDir(arr[1],arr[2]);

	self._curDirection = dir;
end
function BattleTeam:getLeader()
	if(self._members == nil)then
		return nil;
	end
	if(#self._members == 0)then
		return nil;
	end
	return self._members[1]
end
function BattleTeam:getTail()
	if(self._members == nil)then
		return nil;
	end
	if(#self._members == 0)then
		return nil;
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
function BattleTeam:isAlive()
	local leader = self:getLeader()
	if(leader == nil)then
		return nil;
	end
	return leader:isAlive()
end

function BattleTeam:updateMember()

	if(self._members == nil)then
		return;
	end

	-- 同类别合并
	for i = 1,#self._members do
		local cur = self._members[i]
		local nxt = self._members[i+1]
		if(cur:needRemove() or nxt == nil or nxt:needRemove())then
			
		else		
			if(cur:getHp() == nxt:getHp() and cur:getCategory() == nxt:getCategory())then
				cur:merge(nxt)
				nxt:beMerge(cur);
			end
		end
	end


	-- 队员死亡重新整理队伍
	
	-- for(local i = 0;i<self._members.length;i++){
	-- 	local member = self._members[i]
	-- 	if(member.isAlive()){
	-- 		continue
	-- 	}
	-- 	for(local j = self._members.length -1;j >= 0;j--){   
	-- 		local curmember = self._members[j]
	-- 		if(member == curmember){
	-- 			break
	-- 		}
	-- 		local k = j - 1
	-- 		if(k >= 0 ){
	-- 			local preMember = self._members[k]  
	-- 			if(preMember ~= nil){
	-- 				curmember.inherit(preMember);
	-- 			}			
	-- 		}
	-- 	}
	-- }
	--*/
	
	-- 更新逻辑
	if(self._paths == nil)then
		self._paths = {}
	end

	table.insert(self._paths,self:getPos())
	if(#self._paths > maxSize)then
		table.remove(self._paths,1)
	end
	
	local preMember = nil
	local step = math.floor(self:getDiameter() / self:getSpeed()) 
	local length = #self._paths
	for i = 1,#self._members do
		local member = self._members[i];
		local index = length - (i-1)* step
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
		if(member ~= nil)then
			if(member:needRemove())then		 -- important
				if(member:isLeader())then		--  leader die
					self:die()
					break;
				end
				--/* 中间单位死亡 后面全部死的逻辑
				--for(local j = self._members.length -1;j >= i;j--){
				--	self.removeMember(self._members[j])
				--}
				--*/
				self:removeMember(member)
			end
			
		end
	end

	-- 新增队员
	if(self._waitJoinMember ~=nil) then
		for i = 1,#self._waitJoinMember do
			self:joinMember(self._waitJoinMember[i])
		end
		self._waitJoinMember = nil
	end

	
	-- if(self._memberCountChange){
	-- 	self.resetSpeed()
	-- 	self._memberCountChange = false
	-- }

end
function BattleTeam:addMember(member)
	if(self._members == nil)then
		self._members = {}
	end

	if(#self._members == 0)then
		member:setLeader(self._isFollowTarget)
	end
	member:setTeam(self._id)
	table.insert(self._members,member);
	self._memberCountChange = true
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
	self._memberCountChange = true
end
function BattleTeam:die() 
	self:notify("onDie",self,self._dropId)

	if(self._members == nil)then
		return
	end

	for i = #self._members,1, - 1 do
		local m = self._members[i]
		if(m ~= nil)then
			m:die()
		end
	end

	self._isAlive = false
	if(not self:initRevive())then
		self._needRemove = true
	end
end
function BattleTeam:initRevive() 

	if(not self._isRevive)then
		return false
	end

	self._reviveTime = self._frameCount + WorldConfig.reviewTime
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

	if(self._memberOriData == nil or #self._memberOriData < 1)then
		return;
	end

	self._curDirection = Utils.arrToDirection(self._bornDir.x,self._bornDir.y)
	local leaderId = self._memberOriData[1] 		-- 只复活队长
	self._memberOriData = nil;
	self:joinMember(leaderId)
	self._killCount = 0
	self._isAlive = true
	
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
		cc:error("pickItem error")
		return
	end
	local itemType = config.itemType
	local val = config.arg1
	
	local refs = {
		[1]=function ()
			local leader = self:getLeader()
			if(leader ~= nil and leader:isValid())then
				leader:addHp(nil,val)
			end
		end
	}
	refs[itemType]()
	
end
function BattleTeam:loadAvatar() 
	if(self._members == nil)then
		return
	end
	for i = 1,#self._members do
		self._members[i]:loadAvatar()
	end
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
	local pos = self._bornPos:clone()
	local dir = self._bornDir:clone()
	local posQue = nil

	if(lastChar ~= nil)then
		pos =  self:getNextPos(lastChar)
		dir = lastChar:getDir();
		posQue = lastChar:cloneQuePos()
	end

	local member = Character.new();
	member:setQueier({
		onTriger =function (sourceObj,targetObj,skill) 
			self:onTriger(sourceObj,targetObj,skill)
		end,
		castMissile = function(missile) 
			self:notify("castMissile",missile)
		end
	})
	member:init(typeId,pos,dir,self._camp);
	member:setLayer(1);

	self:applyMemberPosQue(member,posQue)
	self:addMember(member);
	if(member:isLeader())then
		self:setSpeed(member:getBasicSpeed())
		self:setPos(pos:clone())
		self:setCircleCollider(pos.x,pos.y,member:getRadius())
		self:moveDir(dir)
	end

	if(self._memberOriData == nil)then
		self._memberOriData = {}
	end

	table.insert(self._memberOriData,typeId)
end

function BattleTeam:changeTeamDir(dx,dy)
	if(self._members == nil)then
		cc:log("no member");
		return;
	end
	local dir =  Vector2.new();
	dir:setv(dx,dy);
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
function BattleTeam:onTriger(sourceObj,targetObj,skill) 
	if(sourceObj.__cname == "BattleTeam" )then

		-- 人撞到墙
		if(targetObj:isBlock())then			
			if(self._members ~= nil)then
				for i = 1,#self._members do
					local m = self._members[i]
					if(m ~= nil)then
						m:meetBlock()
					end
				end
			end
			self:die()
			return
		end

		-- 人撞到人
		if( targetObj.__cname ==  "Character" )then
			
			--/* 自己撞到自己会死的方案
			local sourcePos = -1
			local targetPos = -1

			for i = 1,#self._members do
				if(sourceObj == self._members[i])then
					sourcePos = i
				end
				if(targetObj == self._members[i])then
					targetPos = i
				end
			end


			if(sourcePos >=0 and targetPos >=0 and math.abs(sourcePos - targetPos) <= 2)then  -- 相邻的2個以內不处理
				return 
			end
			--*/

			if(not targetObj:isAlive() or not sourceObj:isAlive())then
				return
			end

			if(not sourceObj:recieveKnock() or not targetObj:recieveKnock())then
				return
			end

			if(sourceObj:needRemove()  or targetObj:needRemove())then
				return
			end
			
			if(sourceObj:getCamp() == targetObj:getCamp())then
				return
			end

			if(sourceObj:getTeam() == targetObj:getTeam())then
				return
			end
			
			-- local teamId = targetObj.getTeam()
			-- local team = getObjectById(teamId)
			
			-- if(team ~= nil){
			-- 	team.beKnock(targetObj)
			-- }

			-- self.die()

			sourceObj:beKnock(targetObj,targetObj:getAttack())
			targetObj:beKnock(sourceObj,sourceObj:getAttack())
			
			return
		end

		-- 人拾取掉落
		if(targetObj.__cname == "BattleDrop")then

			if(targetObj:needRemove())then
				return
			end

			if(self:isMonster())then
				return
			end
			
			if(self:isBasement())then
				return
			end

			local context = targetObj:getDrop()

			local refs={
				[Enum.DropType.Role]=function ( )
					self:pickMember(context)
				end,
				[Enum.DropType.Item]=function ( )
					self:pickItem(context)
				end
			}
			refs[context.dropType]()
		
			targetObj:bePicked()
			return
		end
		
	end

	if(sourceObj.__cname == "Missile"  )then

		if( targetObj.__cname == "Character") then 	-- 子弹撞到人
			if(sourceObj:getCamp() == targetObj:getCamp())then
				return
			end
			if(not sourceObj:tryHitTarget(targetObj))then
				return
			end
			local caster = BattleObject.getObjectById(sourceObj:getCasterId())
			if(targetObj:behit(caster,skill:getAttack()))then
				if(targetObj:isLeader()) then				-- 击杀队长
					self:notify("onLeaderKilled",targetObj)
				end
				self._killCount = self._killCount+1
			end
			
			return
		end
		if( targetObj.__cname ==  "Missile" ) 	-- 子弹撞到子弹
		then
			if(sourceObj:getCamp() == targetObj:getCamp())then
				return
			end
			if(not sourceObj:tryHitTarget(targetObj))then
				return
			end
			return
		end
	end

	self:notify("onTriger",sourceObj,targetObj)
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

function BattleTeam:getKillCount() 
	return self._killCount
end
function BattleTeam:getCtrlId() 
	return self._ctrlId
end
function BattleTeam:isBasement()
	return self._isBasement
end

return BattleTeam