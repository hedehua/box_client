-- ----////////////////////////////////////////////////////////////////////

-- // local battleConfig = {
-- // 	bornPos : [0,-100],
-- // 	bornDir : [0,1],
-- // 	width : 25000, 
-- // 	height : 45000,
-- // end

-- //////////////////////////////////////////////////////////////////////////

local Enum = require("app.controller.battle.core.battleEnum")
local Utils = require("app.controller.battle.core.battleUtils")
local BattleTeam = require("app.controller.battle.core.battleTeam")
local BattleMap = require("app.controller.battle.core.battleMap")
local BattleObject = require("app.controller.battle.core.battleObject")
local BattleDrop = require("app.controller.battle.core.battleDrop")
local BattleConfig = require("app.controller.battle.config.battleConfig")
local DropConfig = require("app.controller.battle.config.dropConfig")
local MonsterFreshConfig = require("app.controller.battle.config.monsterFreshConfig")
local Vector2 = require("app.controller.battle.core.vector2")

local Battle = {}
function Battle.new()
	local obj = {}
	setmetatable(obj,{__index = Battle})
	obj._typeId = 0				-- 
	obj._frameCount = 0			-- int 
	obj._teams = nil				-- array (队伍)
	obj._playerIds = nil
	obj._missiles = nil
	obj._config = nil  			
	obj._map = nil 				-- 地图对象
	obj._drops = nil				-- 掉落
	obj._dropInterval = -1 		-- -1标识为无效
	obj._monsterInterval = -1 		-- -1标识为无效
	obj._isOver = false
	obj._mode = nil

	obj._curState = nil
	obj._running = false

	obj._result = nil
	obj._score = nil

	return obj
end

function Battle:init()
end

function Battle:uninit()
	self:reset();
	BattleObject.clearAll();
end

function Battle:reset()
	if(self._teams ~= nil) then
		for i = 1,table.length(self._teams) do
			self._teams[i]:uninit()
		end
		self._teams = nil
	end
	if(self._drops ~= nil)then
		for i = 1,table.length(self._drops) do
			self._drops[i]:uninit()
		end
		self._drops = nil
	end
	if(self._missiles ~= nil)then
		for i = 1,table.length(self._missiles) do
			self._missiles[i]:uninit()
		end
		self._missiles = nil
	end
	if(self._map ~= nil)then
		self._map:uninit()
		self._map = nil
	end
end
function Battle:start(params) 

	Utils.setSeed(self:getSeed())
	self._typeId = self:getTypeId()
	self._config = Utils.getConfig(BattleConfig,self._typeId)
	self:initIntervalDrop()
	self:initIntervalMonster(self._config.monsterDelay)
	self:initMap(self._config.width,self._config.height,self._config.res)
	self:initCamps();
	self:initPlayers();

	self._running = true

end

function Battle:pause(params) 
	cc:log("[user] battle pause ");
end

function Battle:stop(params) 
	self._isOver = true
end

function Battle:exec(cmd,arg1,arg2,arg3,arg4,arg5) 

	if(self:isOver())then
		return
	end
	local refs = {
		[Enum.CMD.MoveEx] = function(  )
			self:moveEx(arg1,arg2,arg3)
		end,
		[Enum.CMD.Move] = function(  )
			self:move(arg1,arg2,arg3)
		end,
		[Enum.CMD.Join] = function(  )
			self:joinPlayer(arg1,arg2,arg3,arg4)
		end,
		[Enum.CMD.Leave] = function(  )
			self:leaveTeam(arg1)
		end,
		[Enum.CMD.SetAI] = function(  )
			self:setAi(arg1,arg2)
		end,
		[Enum.CMD.StopMove] = function(  )
			self:stopMove(arg1)
		end,
		[Enum.CMD.Skill] = function(  )
			self:castSkill(arg1)
		end
	}
	local func = refs[cmd];
	if(func == nil) then
		print("unknown cmd")
		return
	end
	func()
	
end--pushCmd
function Battle:DoCMD(cmd,arg1,arg2,arg3,arg4,arg5)
	if(self._mode == nil)then
		return
	end
	self._mode.pushCmd(cmd,arg1,arg2,arg3,arg4,arg5)
end
function Battle:setMode(mode)    -- 设置模式管道
	self._mode = mode
	-- cc.log(" -- set mode -- ",self._mode)
end
function Battle:getTypeId() 
	if(self._mode == nil)then
		return nil
	end
	return self._mode.getBattleId()
end
function Battle:getSeed() 
	if(self._mode == nil)then
		return nil
	end
	return self._mode.getSeed()
end
function Battle:getBasicFrame() 
	if(self._mode == nil)then
		return 0
	end
	return self._mode.getFrame()
end
function Battle:getChars() 
	if(self._mode == nil)then
		return nil
	end
	return self._mode.getChars()
end
function Battle:update()

	if(not self._running)then
		return
	end

	if(self:isOver())then
		return
	end

	if(self._mode ~= nil)then
		local pack = self._mode.peekCmd();
	
		repeat
			if(pack == nil or pack.frame > self._frameCount) then
				break
			end
			self:exec(pack.cmd,pack.arg1,pack.arg2,pack.arg3,pack.arg4,pack.arg5)
			self._mode.popCmd();
			pack = self._mode.peekCmd();
		until (false)
	end

	self._frameCount = self._frameCount + 1;

	if(self:checkOver())then
		self:gameOver() 
	end

	self:tryGenerateDrop()
	self:tryGenerateMonster()
	self:updateTeam()
	self:updateDrop()
	self:updateMissile()
	self:updateScore()
end

function Battle:updateMissile() 
		if(self._missiles ~= nil)then
		for i = table.length(self._missiles),1,-1 do
			local missile = self._missiles[i]
			if(missile:needRemove())then
				self:removeMissile(missile)
			else
				missile:update()
			end    
			
		end
	end
end
function Battle:updateTeam() 

	if(self._teams == nil)then
		return
	end

	for i = #self._teams,1,-1 do

		local team = self._teams[i]
		if(team:needRemove())then
			self:removeTeam(team)
		else
			team:update();
		end

	end
	
end
function Battle:updateDrop() 
	if(self._drops == nil)then
		return
	end
	for i = table.length(self._drops),1,-1 do
		local drop = self._drops[i]
		
		if(drop:needRemove())then
			self:removeDrop(drop)
		else
			drop:update()
		end
		
	end
end
function Battle:initIntervalDrop() 
	if(self._config == nil)then
		return
	end
	if(self._config.dropInterval > 0 and self._config.drop > 0)then
		self._dropInterval = self._frameCount + self._config.dropInterval
	end
end
function Battle:tryGenerateDrop() 
	if(self._dropInterval == nil or self._dropInterval <=0 )then
		return
	end
	if(self._frameCount < self._dropInterval)then
		return
	end

	self:generateDrop(self._config.drop)	
	
end
function Battle:generateDrop(dropId,posCenter,radius)
	
	if(self._map == nil)then
		return
	end

	local cfgArr = Utils.getConfigByGroup(DropConfig,dropId)

	if(cfgArr == nil)then
		return
	end
	
	local i = Utils.getRandomIndexByChance(cfgArr)

	if(i <= 0) then
		return
	end
	
	for j = 1,cfgArr[i].count do
		
		local pos = Vector2.new()
		if(posCenter == nil)then 				-- map center
			local posArr = self._map:getValidPos()
			pos:setv(posArr[1],posArr[2])
		
		else
			local offset = 0
			if(radius > 0)then
				offset = Utils.random(0,radius)
			end
			pos:setv(posCenter.x + offset,posCenter.y + offset)
		end
		
		self:joinDrop(cfgArr[i].id,Enum.ECamp.None,pos)
	end
	self:initIntervalDrop()
	
end

function Battle:initPlayers( )
	local datas = self:getChars()
	if(datas == nil) then
		return
	end
	for i =1,#datas do
		local data = datas[i]
		self:joinPlayer(data.ctrlId,data.typeId,data.camp,data.isAi)
	end
end

function Battle:initCamps()
	if(self._config == nil)then
		return
	end
	if(self._config.basement1 ~= nil and self._config.basement1 > 0)then
		local info = {
			camp = Enum.ECamp.Blue,
			pos = self:getCampBornPos(Enum.ECamp.Blue),
			dir = self:getCampBornDir(Enum.ECamp.Blue),
			chars = {{typeId = self._config.basement1}}
		}
		local team = self:joinTeam(info)	
		if(team ~= nil)then
			team:setAi(true)
			team:setRevive(false)
			team:setBasement()
		end
	end
	if(self._config.basement2  ~= nil and self._config.basement2 > 0 )then
		local info = {
			camp = Enum.ECamp.Green,
			pos = self:getCampBornPos(Enum.ECamp.Green),
			dir = self:getCampBornDir(Enum.ECamp.Green),
			chars = {{typeId = self._config.basement2}}
		}
		local team = self:joinTeam(info)	
		if(team ~= nil)then
			team:setAi(true)
			team:setRevive(false)
			team:setBasement()
		end
	end
end
function Battle:initIntervalMonster(delay) 
	if(self._config == nil)then
		return
	end
	if(self._config.monsterInterval > 0 and self._config.monster > 0)then
		self._monsterInterval = self._frameCount + delay
	end
end
function Battle:tryGenerateMonster() 

	if(self._map == nil)then
		return
	end

	if(self._monsterInterval == nil or self._monsterInterval <= 0 )then
		return
	end

	if(self._frameCount < self._monsterInterval)then
		return
	end

	local count = 0

	if(self._teams ~= nil)then
		for i = 1,#self._teams do
			local team = self._teams[i]
			if(team ~= nil and team:isMonster())then
				count = count + 1;
			end
		end
	end

	if(count >= self._config.maxMonsterCount)then
		return
	end

	local cfgArr = Utils.getConfigByGroup(MonsterFreshConfig,self._config.monster)

	if(cfgArr == nil)then
		return
	end

	local i = Utils.getRandomIndexByChance(cfgArr)
	if(i <= 0) then
		return
	end

	local cfg = cfgArr[i]
	local camp = cfg.camp
	local dir = self:getCampBornDir(camp)
	local pos = self:getCampBornPos(camp)
	self:generateMonster(cfg,pos,dir,camp)	
	self:initIntervalMonster(self._config.monsterInterval)		

end

function Battle:generateMonster( cfg,pos,dir,camp )
	if cfg.monsters == nil then
		print("monsters nil")
		return
	end

	for j = 1,cfg.count do
		local chars = {};
		
		for m = 1,#cfg.monsters do
			table.insert(chars,{typeId = cfg.monsters[m]})
		end

		local team = self:joinTeam({camp = camp,pos = pos,dir = dir,chars = chars})
		
		if(team ~= nil)then
			team:setAi(true)
			team:setRevive(false)
			team:setDrop(cfg.drop)
		end

	end
end

function Battle:isOver()
	return self._isOver
end

function Battle:getResult()
	if(self._score == nil) then
		return nil
	end
	return { 
		winner = nil,
		endType= Enum.EResult.PlayerDie,
		scores = self._score.item
	}
end
function Battle:checkOver() 
	if(self._frameCount >= self._config.timeOut)then
		self._result = { 
			winner = nil,
			endType= Enum.EResult.Timeout,
			scores = self._score.item
		}
		return true
	end
	if(self._teams == nil )then
		return true
	end

	for i = #self._teams ,1,-1 do
		local team = self._teams[i]
		
		if(team:needRemove() and team:isBasement())then
			self._result = { 
				winner = Utils.getOtherCamp(team:getCamp()),
				endType= Enum.EResult.Succ,
				scores = self._score.item
			}
			return true
		end
	end
	
	return false
end
function Battle:gameOver() 

	if(self._mode ~= nil)then
		self._mode.onGameOver(self._result)
	end
	self:reset()
	self._isOver = true
end
function Battle:joinDrop(typeId,camp,pos) 
	local drop = BattleDrop.new()
	
	drop:setQueier({
		
	})
	drop:init(typeId,camp,pos)
	drop:setLayer(2)
	self:addDrop(drop)
end
function Battle:addDrop(drop) 
	if(self._drops == nil)then
		self._drops = {}
	end
	table.insert(self._drops,drop)
end
function Battle:removeDrop(drop) 
	if(self._drops == nil)then
		return;
	end
	for i = table.length(self._drops),1,-1 do
		local d = self._drops[i]
		if(d ~= nil and d == drop)then
			drop:uninit()
			table.remove(self._drops,i)
			break
		end
	end
end
function Battle:addTeam(team)
	if(self._teams == nil)then
		self._teams = {}
	end
	table.insert(self._teams,team)
end
function Battle:removeTeam(team)
	if(self._teams == nil)then
		return;
	end

	for i = table.length(self._teams),1,-1 do
		local t = self._teams[i]
		if(t == team)then
			team:uninit()
			table.remove(self._teams,i)
			break
		end
	end
end
function Battle:setAi(ctrlId,aiId)
	local team = self:getTeamByCtrlId(ctrlId)
	if(team == nil)then
		return
	end
	team:setAi(aiId > 0)
end

function Battle:getCampBornPos( camp )
	if(self._config == nil) then
		return nil
	end

	local pos = self._config["camp"..camp.."Pos"]
	if(pos == nil) then
		pos = self._map:getValidPos()
	end
	return pos
end

function Battle:getCampBornDir( camp )
	if(self._config == nil) then
		return nil
	end

	local dir = self._config["camp"..camp.."Dir"]
	if(dir == nil) then
		dir = self._config.bornDir
	end
	return dir
end

function Battle:getCampTypeId( camp )
	if(self._config == nil) then
		return nil
	end

	return self._config["basement"..camp]
end

function Battle:joinPlayer(ctrlId,typeId,camp,isAi) 
	
	if(self._map == nil)then
		error("map error,can't join player")
		return
	end

	local flag = false

	if(self._mode ~= nil )then
		flag = self._mode.getCtrlId() == ctrlId
	end

	local pos = self:getCampBornPos(camp)
	local dir = self:getCampBornDir(camp)

	if(pos == nil)then
		pos = self._map:getValidPos()
	end
	if(dir == nil)then
		dir = self._config.bornDir
	end

	local team = self:joinTeam({ctrlId = ctrlId,camp = camp,pos = pos,dir =dir,flag = flag,chars = {{typeId = typeId}}})
	if(team == nil)then
		return -1;
	end

	team:setRevive(self._config.revive)
	team:setAi(isAi)
	team:setDrop(self._config.playerDrop)
	
	return team._id
end

function Battle:leaveTeam(ctrlId) 
	if(self._teams == nil)then
		return
	end	
	for i = table.length(self._teams),1,-1 do
		local team = self._teams[i];
		if(team:getCtrlId() == ctrlId)then
			self:removeTeam(team);
		end
	end
end
function Battle:joinTeam(data)
	local pos = data.pos
	local dir = data.dir
	local camp = data.camp
	local chars = data.chars
	local flag = data.flag
	local ctrlId = data.ctrlId
	
	local team = BattleTeam.new();
	team:setQueier({
		onTriger = function (sourceObj,targetObj,skill) 
			self:dispatchTriger(sourceObj,targetObj,skill)
		end,
		castMissile = function(missile) 
			self:addMissile(missile)
		end,
		needRender = function() 
			return self:needRender()
		end,
		onDie = function(team,dropId)
			if(dropId == nil)then
				return;
			end

			if(self._mode ~= nil)then
				self._mode.onTeamDie(team:getCtrlId(),self._config.revive)
			end
			
			self:generateDrop(dropId,team:getLeaderPos(),0)
		end
		
	})
      
	local typeId = chars[1].typeId
	local vpos = Vector2.new(pos[1],pos[2])
	local vdir = Vector2.new(dir[1],pos[2])
	team:init(typeId,vpos,vdir,camp,flag,ctrlId); 
	self:addTeam(team);
	return team
end

local colliderEvents = {
	BattleTeam = {
		BattleMap = function( sourceObj,targetObj )
			sourceObj:setPos(targetObj:clampPos(sourceObj:getPos()))
		end,
		BattleDrop = function( sourceObj,targetObj,skill )
			if(targetObj:needRemove())then
				return
			end

			if(sourceObj:isMonster())then
				return
			end
			
			if(sourceObj:isBasement())then
				return
			end

			local context = targetObj:getDrop()

			local refs={
				[Enum.DropType.Role]=function ( )
					sourceObj:pickMember(context)
				end,
				[Enum.DropType.Item]=function ( )
					sourceObj:pickItem(context)
				end
			}
			refs[context.dropType]()
		
			targetObj:bePicked()
		end
	},
	Missile = {
		Character = function( sourceObj,targetObj,skill )
			if(sourceObj:getCamp() == targetObj:getCamp())then
				return
			end

			if(not sourceObj:tryHitTarget(targetObj))then
				return
			end

			local caster = BattleObject.getObjectById(sourceObj:getCasterId())
			if(targetObj:behit(caster,skill:getAttack()))then
				caster:hitOther(targetObj)
			end
		end,
		BattleTeam = function( sourceObj,targetObj,skill )
			if(sourceObj:getCamp() == targetObj:getCamp())then
				return
			end

			if(not sourceObj:tryHitTarget(targetObj))then
				return
			end

			local caster = BattleObject.getObjectById(sourceObj:getCasterId())
			if(caster == nil) then
				print("no caster",sourceObj:getCasterId())
				return
			end

			if(targetObj:behit(caster,skill:getAttack()))then
				caster:hitOther(targetObj)
			end
		end,
		Missile = function( sourceObj,targetObj,skill )
			if(sourceObj:getCamp() == targetObj:getCamp())then
				return
			end
			if(not sourceObj:tryHitTarget(targetObj))then
				return
			end
		end
	}
}

function Battle:dispatchTriger(sourceObj,targetObj,skill)

	local sourceName = sourceObj:getClassName()
	local targetName = targetObj:getClassName()

	local row = colliderEvents[sourceName]
	if(row == nil) then
		return
	end

	local cel = row[targetName]
	if(cel == nil) then
		return
	end

	cel(sourceObj,targetObj,skill);
	
end	

function Battle:getTeamByCtrlId(ctrlId) 
	if(self._teams == nil)then
		return -1;
	end
	for i = 1,#self._teams do
		local team = self._teams[i]
		if(team:getCtrlId() == ctrlId)then
			return team.id;
		end
	end
end

function Battle:castSkill( ctrlId )
	if(ctrlId < 0) then
		return
	end
	
	local team = self:getTeamByCtrId(ctrlId)
	if(team == nil) then
		return
	end

	team:castSkillEx()
end

function Battle:stopMove( ctrlId )
	if(ctrlId < 0) then
		return
	end

	local team = self:getTeamByCtrId(ctrlId)

	if(team == nil)then
		return;
	end

	team:stopMove();
end

-- 4 direction
function Battle:move(ctrlId,dir)
	if(ctrlId < 0)then
		return;
	end
	
	local team = self:getTeamByCtrId(ctrlId)

	if(team == nil)then
		return;
	end

	team:move(dir);
end
-- any direction
function Battle:moveEx(ctrlId,dirX,dirY)

	if(ctrlId < 0)then
		print("invalid ctrlId");
		return;
	end
	if(self._teams == nil)then
		print("no team");
		return;
	end
	local team = self:getTeamByCtrId(ctrlId)

	if(team == nil)then
		print('nil team')
		return;
	end

	team:moveEx(dirX,dirY);
end
function Battle:getTeamCount() 
	if(self._teams == nil) then
		return -1
	end
	return #self._teams
end
function Battle:getTeamById(id) 
	if(self._teams == nil)then
		return nil;
	end
	for i = 1,#self._teams do
		if(self._teams[i]._id == id)then
			return self._teams[i];
		end
	end
	return nil;
end
function Battle:getTeamByCtrId(id) 
	if(self._teams == nil)then
		return nil;
	end
	for i = 1,#self._teams do
		if(self._teams[i]:getCtrlId() == id)then
			return self._teams[i];
		end
	end
	return nil;
end
function Battle:getTeamDir(ctrlId) 
	if(ctrlId < 0)then
		cc:log("invalid id");
		return nil;
	end
	if(self._teams == nil)then
		cc:log("no team");
		return nil;
	end
	local team = self:getTeamByCtrId(ctrlId)

	if(team == nil)then
		cc:log('invalid team')
		return nil;
	end

	return team:getDirection();
end
function Battle:initMap(width,height,res) 
	if(self._map == nil)then
		self._map = BattleMap.new();
	end
	self._map:init(width,height,res);
	self._map:setLayer(0);
end
function Battle:addMissile(obj) 
	if(self._missiles == nil)then
		self._missiles = {}
	end
	table.insert(self._missiles,obj)
end
function Battle:removeMissile(obj) 
	if(self._missiles == nil)then
		return
	end
	for i = #self._missiles,1,-1 do
		local m = self._missiles[i]
		if(m ~= nil and m == obj)then
			obj:uninit()
			table.remove(self._missiles,i)
			break
		end
	end

end

-- out interface

function Battle:getSize(  )
	if(self._config == nil) then
		return nil
	end
	return self._config.width,self._config.height
end

function Battle:isRunning(  )
	return self._running
end

function Battle:getRestTime() 
	if(self._config == nil)then
		return 0
	end
	return self._config.timeOut - self._frameCount
end

function Battle:getFrame() 
	return self._frameCount
end

function Battle:getKillCount(ctrlId) 
	if(ctrlId == nil or ctrlId < 0)then
		cc:log("getkillcount arguments error")
		return 0
	end
	if(self._teams == nil)then
		return 0
	end
	local team = self:getTeamByCtrId(ctrlId)
	if(team == nil)then
		return 0
	end
	return team:getKillCount()
end
function Battle:getBasementHp(camp)

	if(camp == nil)then
		return
	end

	if(self._config == nil)then
		return nil
	end

	if(self._config.basement1 == nil)then
		return nil
	end

	if(self._teams == nil)then
		return nil;
	end

	for i = 1,#self._teams do
		local team = self._teams[i]
		if(team:isBasement() and team:getCamp() == camp )then
			return team:getLeaderHp();
		end
	end
	return nil;
end
function Battle:getRank()
	if(self._config == nil or not self._config.rank)then
		return nil
	end
	if(self._score == nil)then
		return
	end
	if(self._score.dirty)then
		table.sort(self._score.item,function(a,b)return a.score < b.score end)
	end
	for i = 1,#self._score.item do
		self._score.item[i].rank = i
	end
	return self._score
end
function Battle:updateScore()

	if(self._teams == nil)then
		return 
	end
	if(self._score == nil)then
		self._score = {}
		self._score.item = {}
	end
	local dirty = false
	for i = 1,#self._teams do
		local team = self._teams[i]
		if(team:getCtrlId() == nil)then
			
		end
		local rankInfo = nil
		for k = 1,#self._score.item do
			local item = self._score.item[k]
			if(item.ctrlId == team:getCtrlId())then
				rankInfo = item
				break
			end
		end
		if(rankInfo == nil)then
			rankInfo = {ctrlId = team:getCtrlId(),score = 0,rank = nil}
			table.insert(self._score.item,rankInfo)
			dirty = true
		end
		local score = team:getKillCount()
		if(rankInfo.score ~= score)then
			dirty = true
		end
		rankInfo.score = score
	end
	if(dirty)then
		self._score.dirty = dirty
	end
	
end

return Battle;