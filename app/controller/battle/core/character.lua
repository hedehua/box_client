----////////////////////////////////////////////////////////////////////
-- // local charConfig = [
-- // 	{id : 1001,name : "哥布林法师",attack : 10,speed : 200,radius : 500,maxHp : 100,res : "role/prefab/hero_0"end
-- // 	{id : 1002,name : "哥布林投手",attack : 10,speed : 200,radius : 500,maxHp : 100,res : "role/prefab/hero_1"end
-- // 	{id : 1003,name : "哥布林战士",attack : 10,speed : 200,radius : 500,maxHp : 100,res : "role/prefab/hero_2"end
-- // ]
-- //////////////////////////////////////////////////////////////////////////

local Utils = require("app.controller.battle.core.battleUtils")
local CharConfig = require("app.controller.battle.config.characterConfig")
local BattleObject = require("app.controller.battle.core.battleObject")
local WorldConfig = require("app.controller.battle.config.worldConfig")
local Skill = require("app.controller.battle.core.skill")

local Character = {}
Character.super = BattleObject
Character.__cname = "Character"
setmetatable(Character,{__index = BattleObject})

function Character.new()
	local obj = BattleObject.new()
	setmetatable(obj,{__index = Character})
	obj._typeId = 0  			-- 配置表id
	obj._isFollowTarget = false
	obj._hp = 0
	obj._maxHp = 0
	obj._attack = 0
	obj._skillIds = nil
	obj._posQue = nil   --  目标点队列  {pos,dirend	
	obj._posHist = nil
	obj._buffs = nil 			--  buff
	obj._skills = nil			--  技能
	obj._config = nil    		--  配置表
	obj._moveStateChange = false
	obj._isLeader = false
	obj._teamId= -1  			-- 无队伍
	obj._isAlive = false
	obj._needRemove = false
	obj._moveEndDirty = false

	obj._isBornning = false       -- 出生的缓冲区
	obj._stopBlinkTime = 0
	obj._frameCount = 0
	obj._camp = nil
	obj._knockCd = 0
	return obj
end

function Character:init(typeId,pos,dir,camp)
	Character.super.init(self,typeId,pos,dir,camp)
	
	self._typeId = typeId
	self._camp = camp
	self._isAlive = true
	self._isBornning = true
	self._stopBlinkTime = self._frameCount + WorldConfig.bornTime

	self:initConfig()
	self:setSpeed(self:getBasicSpeed())
	self:setPos(pos)  				-- s设置初始位置
	self:setDir(dir)				-- 设置初始朝向
	self:initSkill()
	self:initAi()

	if(self._config ~= nil) then
		self:setCircleCollider(pos.x,pos.y,self._config.radius)
		self:setMaxHp(self._config.maxHp);  			
		self:setHp(self._config.defaultHp,false);
	end
	
	self._enableRot = false

	if(self._render ~= nil and self._config ~= nil) then
		self._render:setTypeId(self._typeId);
		self._render:setCamp(self._camp)
		self._render:setIcon(self._config.icon)
		self._render:setSize(self._config.radius * 2,self._config.radius * 2)
		self._render:startBlink()
		self:loadAvatar(self._config.res)
	end
	
end
function Character:uninit()

	if(self._buffs ~= nil) then
		for i = 1,#self._buffs do
			local b = self._buffs[i]
			if(b ~= nil) then
				b:uninit()
			end
		end
		self._buffs = nil
	end

	if(self._skills ~= nil) then
		for i = 1,#self._skills do
			local s = self._skills[i]
			if(s ~= nil) then
				s:uninit()
			end
		end
		self._skills = nil
	end

	self._posQue = nil
	self._skillIds = nil

	Character.super.uninit(self)
	-- cc.log("character uninit",self._id)
end

function Character:initConfig() 
	if(self._typeId == nil or self._typeId <=0 ) then
		return
	end

	self._config = Utils.getConfig(CharConfig,self._typeId)

	if(self._config == nil) then
		error("can't get config from characterConfig",self._typeId)
	end
end
function Character:getBasicSpeed(argument) 
	if(self._config == nil)then
		-- error("you should init config first")
		return 0
	end
	return self._config.speed
end
function Character:getCollectRange()
	return self._config.collect
end
function Character:getCategory()
	return self._config.category
end
function Character:getAttack() 
	return self._config.attack
end
function Character:update()

	if(not self:isValid()) then
		return
	end

	if(not self:isAlive()) then
		self._needRemove = true
		-- return
	end
	
	if(self._hp <=0) then
		self:die()
		-- return
	end

	self._frameCount = self._frameCount + 1;
	
	if(self._knockCd ~= nil and self._knockCd > 0) then
		self._knockCd = self._knockCd - 1;
	end
	
	--  解除出生态
	if(self._frameCount >= self._stopBlinkTime and self._stopBlinkTime > 0)then

		self._isBornning = false
		self._stopBlinkTime = -1

		if(self._render ~= nil) then
			self._render:stopBlink()
		end
	end

	-- self.tryMove();
	self:tryAi()

	self:updateSkill()
	Character.super.update(self)
	
end

function Character:isAlive()
	return self._isAlive ;
end
function Character:needRemove()
	return self._needRemove
end
function Character:isBlock(argument)
	return false
end
function Character:recieveKnock()
	return not self._isBornning
end
function Character:die()
	-- print(self._id,"die",self._hp,debug.traceback())
	if(self._needRemove) then
		return
	end

	self:setHp(0,false)
	self._isAlive = false
	if(self._render ~= nil) then 
		self._render:fadeOut()
	end
	
end
function Character:revive()
	
end

-- character: caster
-- demage : skill atatck
function Character:behit(character,damage)
	-- /*
	-- self:addHp(character,-damage)
	-- */

	local preHp = self._hp
	self:setHp(math.floor(self:getHp()-damage),true)
	return self._hp <= 0 and preHp > 0
end
function Character:beKnock(character,damage)
	if(self._knockCd ~= nil and self._knockCd > 0) then
		return
	end
	self._knockCd = self._config.knockCd or 0
	return self:behit(character,damage)
end
function Character:beMerge(ch)
	self:setHp(0,true)
end
function Character:merge(ch)
	self:setHp(self:getHp() * 2,true)
end
function Character:setLeader(flag) 
	self._isLeader = true
	self._isFollowTarget = flag
	-- print("vvvvvvvv",flag)
	if(self._render ~= nil) then
		self._render:setFollowTarget(self._isFollowTarget)
	end
end
function Character:isLeader(argument) 
	return self._isLeader
end
function Character:setTeam(id) 
	self._teamId = id
end
function Character:getTeam(argument)
	return self._teamId
end
function Character:addHp(character,hp)
	self:setHp(self._hp + hp,true)
	-- if(self._render~= nil){
	-- 	if(hp > 0){
	-- 		self._render.playEffectByName("AddHp",self.getPos(),0.5)
	-- 	endelse{

	-- 	end
		
	-- end
end
function Character:setMaxHp(value)
	self._maxHp = value
end
function Character:setHp(value,tween)

	self._hp = value
	self._hp = math.max(math.min(self._hp,self._maxHp),0) 

	if(self._render ~= nil) then
		-- self._render.setHp(self._hp,self._maxHp,tween)
		self._render:setIcon(self._hp,tween)
	end
end
function Character:getHp()
	return self._hp
end
function Character:castSkill(skillId)
	if(skillId <=0 ) then
		return
	end
	
end
-- 达到cross点之后改变方向dir
function Character:changeDir(cross,dir,imm)

	if(self._posQue == nil) then
		self._posQue = {}
	end

	if(imm) then
		if(#self._posQue ~= 1) then
			return
		end
		local first = self._posQue[1]
		first.dir = dir:clone()
		self._moveStateChange = true 
		return
	end

	if(#self._posQue > 0) then

		local first = self._posQue[1]
		
		if(first.cross == nil) then
			self._moveStateChange = true            -- 朝向移动改为定点移动
		end

		local lastIndex = #self._posQue - 1
		local last = self._posQue[lastIndex]
		last.cross = cross:clone()
	end

	table.insert(self._posQue,{dir = dir:clone(),cross = nil})

end
function Character:getFrontPos()
	if(self._posQue == nil) then
		return nil;
	end
	return self._posQue[1]
end
function Character:getPosQueSize()
	if(self._posQue == nil) then
		return 0
	end
	return table.length(self._posQue)
end
function Character:popFrontPos()
	if(self._posQue == nil) then
		return false
	end
	local top = self._posQue[1]
	if(top ~= nil) then
		table.remove(self._posQue,1)
	end
	return top
end
function Character:cloneQuePos() 
	if( self._posQue == nil) then
		return;
	end
	
	local t = {}
	local posQue = self._posQue

	if(not self:isMove()) then
		table.insert(t,{cross= self:getPos(),dir = self:getDir()})
	end

	for i = 1 ,table.length(posQue) do
		local item = posQue[i]
		local last = {dir = item.dir,cross = nil}
		if(item.cross ~= nil) then
			last.cross = item.cross
		end
		table.insert(t,last)
	end
	return t
end
function Character:inherit(target) 
	self._posQue = target:cloneQuePos()
	self._isMove = target._isMove
	self._dir = target:getDir()
	self._restMoveTime = target._restMoveTime
	self._targetPos = target._targetPos
	self._speedChange = target._speedChange
	-- self._distCompensate = target._distCompensate
	self:setPos(target:getPos())
end
function Character:meetBlock() 

	self:moveEnd()
	self._posQue = nil
end
function Character:getCamp() 
	return self._camp
end
function Character:moveEnd(argument) 
	Character.super.moveEnd(self)
	self._posHist = self:getPos()
end

 function Character:moveDir(dir) 
	if(self:isMove()) then
		self._posHist = self:getPos()
	end
	Character.super.moveDir(self,dir)
end
--  function Character:tryMove()

-- 	if(not self:isAlive()) then
-- 		return
-- 	end

-- 	if(self._posQue == nil) then
-- 		return
-- 	end

-- 	local frontPos = self:getFrontPos();

-- 	if(frontPos == nil) then
-- 		return
-- 	end

-- 	-- 当前为定向移动
-- 	if(not self:isMoveT())				
-- 	then
-- 		if(frontPos.cross == nil)then  		-- 改变方向
-- 			if(not self:isMove())then
-- 				self:moveDir(frontPos.dir);
-- 				return
-- 			end
-- 			if(self._moveStateChange) then
-- 				self:moveDir(frontPos.dir);
-- 				self._moveStateChange = false
-- 				return
-- 			end
-- 			return
-- 		end
-- 		self:moveTo(frontPos.cross,true)     -- 切换为定点
-- 		return
-- 	end

-- 	-- 当前为定点运动
-- 	if(frontPos.cross == nil)then     -- 切换为定向
-- 		if(not self:isMove())then
-- 			self:moveDir(frontPos.dir);
-- 		end
-- 		return
-- 	end

-- 	-- 当前未移动（刚出生时）
-- 	if(not self:isMove())then		
-- 		self:moveTo(frontPos.cross)
-- 	end
	
-- end
function Character:initSkill() 
	if(self._config == nil or self._config.skill == nil) then
		return
	end
	self._skillIds = self._config.skill
	if(self._skillIds == nil)then
		return
	end
	
	if(self._skills == nil)then
		self._skills = {}
	end

	for i = 1,table.length(self._skillIds) do
		local id = self._skillIds[i]
		local skill = Skill.new()
		skill:setQueier({
			onTriger = function(sourceObj,targetObj,skill) 
				self:notify("onTriger",sourceObj,targetObj,skill)
			end,
			castMissile = function(missile) 
				self:notify("castMissile",missile)
			end
		})
		skill:init(id,self:getCamp(),self._id)
		table.insert(self._skills,skill)
	end
end
function Character:updateSkill() 
	if(self._skills == nil) then
		return
	end
	for i = table.length(self._skills),1,-1 do
		local skill = self._skills[i]
		if(skill ~= nil)then
			skill:update()
		end
	end
end
function Character:tryAi() 

	if(not self:isAlive())then
		return
	end

	if(self._skills == nil )then
		return
	end
	for i = table.length(self._skills),1,-1 do
		local skill = self._skills[i]
		if(skill ~= nil and skill:cast())then
			self:initAi()
			break
		end
	end
	
end
function Character:initAi() 
	-- self._aiInterval = self._frameCount + WorldConfig.aiInterval
end
function Character:needCheckCollider() 
	return false
end
function Character:onTriger(source,target) 
	self:notify("onTriger",source,target)
end

return Character