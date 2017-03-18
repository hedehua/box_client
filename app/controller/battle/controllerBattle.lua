  -- // 战斗的逻辑模块
local ControllerBase = require('app.framework.controllerBase'); 
local UIBattle = require("app.ui.uiBattle")
local UIBattleEnd = require("app.ui.uiBattleEnd")
local BattleRender = require("app.controller.battle.render.battleRender")
local Battle = require("app.controller.battle.core.battle") 

local Enum =   require("app.controller.battle.core.battleEnum")
local Utils = require("app.controller.battle.core.battleUtils")
local WorldConfig = require("app.controller.battle.config.worldConfig")
local Common = require("app.common.include")

local TimerManager = require("app.manager.timerManager")
local AudioManager = require("app.manager.audioManager")
local TipsManager = require("app.manager.tipsManager")

local Net = require("app.network.net")
local UserModel = require("app.model.modelUser")
local ControllerBattle = cc.class("ControllerBattle",ControllerBase)

local _instance = nil
function ControllerBattle:getInstance( ... )

    if(_instance == nil) then
      _instance = ControllerBattle.new();
    end
  
    return _instance
end

function ControllerBattle:ctor( ... )
    self._battle = nil
    self._players = nil
    self._cmds = nil
    self._uiBattle = nil
    self._uiBattleEnd = nil
    self._running = false
    self._waiting = false
    self._frameCount = 0
    self._renderBattle = nil
    self._curDirection = nil
    self._lastTouchTime = 0
    self._lastDir = nil

    self._curId = -1
    self._curCamp = nil

    self._totalTime = 0
    self._battleTick = -1

    self._uiTime = 0

    self._curMode = nil
    self._curBattleId = nil
end

function ControllerBattle:init()
    self.super:init(self);
    -- self:initNet();
end

function ControllerBattle:reset()
  
    self.super.reset(self)

    if(self._uiBattle ~= nil) then
        self._uiBattle:uninit()
        self._uiBattle = nil
    end

    if(self._uiBattleEnd ~= nil) then
        self._uiBattleEnd:uninit()
        self._uiBattleEnd = nil
    end

    if(self._battle ~= nil) then
        self._battle:uninit()
        self._battle = nil
    end

    self._running = false
    self._curDirection = nil
    self._curId = nil
    self._frameCount = 0
    self._battleTick = 0
end

function ControllerBattle:uninit()
  
    if(self._running) then
        self:close();
    end
    
    self.super.uninit(self)
end

local frame = 0
local second = 0

function ControllerBattle:update(dt)
  
    self.super.update(self,dt)

    if(self._battle == nil) then
        return
    end

    if(self._renderBattle ~= nil) then
        self._renderBattle:update(dt)
    end
    self._uiTime = self._uiTime + dt
    if(self._uiTime > 1) then
        self._uiTime = 0

        if(self._uiBattle ~= nil) then
            self._uiBattle:fresh()
        end
    end

    if(self._curMode == 2) then
        local temp = 0;
        repeat 
            temp = temp + 1
            if(temp < 100) then
              temp = 0
              break
            end
            self:tick()
        until (self._frameCount > self._battle.getFrame())
        return
    end

    if(self._curMode == 1) then
        self._totalTime = self._totalTime + dt;
        if(self._totalTime < self._battleTick) then 
            return
        end
        self._totalTime = 0
        self:tick(dt)
        return
    end

end

function ControllerBattle:tick(dt) 
    if(self._battle ~= nil) then
        self._battle:update();
    end 
end

function ControllerBattle:requestStart(arg) 
  -- local tos = {
  --   uid = UserModel:getInstance():getUid(),
  --   battleTid = arg,
  --   playerTid = WorldConfig.defaultPlayer,
  --   battleType = WorldConfig.defaultMode,
  -- }

  -- Net:request("connector.entryHandler.startBattle",tos,function(data) 
  --    if(data.code ~= 200) then
  --      cc.error("error");
  --      return;
  --    end
  --    self:open(false,data.battleInfo)
  -- end)
    self:open(false,{
        ctrlId = 1,
        mode = 1,
        battleTid = arg,
        players = {
          { ctrlId = 1,typeId = 1000 ,camp = Enum.ECamp.Blue ,isAi = false}
        },
        seed = 2016,
        frame = 0,
    })
  
end

-- function ControllerBattle:wait()
--     TipsManager:getInstance():playBlink(Common.stringTable.WaitPlayer)
-- end

-- function ControllerBattle:waitEnd()
--     TipsManager:getInstance():stopBlink();
--     TipsManager:getInstance():playCd(3);
-- end

function ControllerBattle:getMyCamp()
    if(self._battle == nil) then
        return nil
    end

    local team = self._battle:getTeamByCtrId(self._curId)
    if(team == nil) then
        return
    end
    
    return team:getCamp()
end

function ControllerBattle:open(auto,info)

  self.super.open(self,auto,info)
  self._battleTick = 1 / WorldConfig.battleInterval
  if(self._battle ~= nil) then
    self._battle:uninit()
  end

  self._renderBattle = BattleRender.new();
  self._renderBattle:init();
  self._renderBattle:setQueier({
    getSize = function(  )
      if(self._battle == nil) then
        return nil
      end
      return self._battle:getSize()
    end
  }) 
  self._curId = info.ctrlId
  self._curMode = info.mode
  self._curBattleId = info.battleTid
  self._battle = Battle.new();
  
  local mode = {
    getBattleId = function()
      return info.battleTid
    end,
    getCtrlId = function() 
      return info.ctrlId
    end,
    getChars = function()
      return info.players
    end,
    getSeed = function()
      return info.seed
    end,
    getFrame = function() 
      return info.frame
    end,
    pushCmd = function(cmd,arg1,arg2,arg3)

      if(self._curMode == 1) then
        self:cacheCmd({frame = self._battle:getFrame(),cmd = cmd,arg1 = arg1,arg2 = arg2,arg3 = arg3})
        return
      end

      local tos = {cmd =cmd,arg1=arg1,arg2=arg2,arg3=arg3}
      Net:notify("battle.battleHandler.doCmd",tos);
    end,

    popCmd = function() 
      if(self._cmds == nil) then
        return nil
      end
      local top = self._cmds[1]
      table.remove(self._cmds,1)
      return top;
    end,
    peekCmd = function() 
      
      if(self._cmds == nil) then
        return nil;
      end
      
      if(#self._cmds == 0) then
        return nil;
      end
     
      return self._cmds[1];
    end,
    onGameOver = function (result)
      if(self._curCamp == nil) then
        self._curCamp = self:getMyCamp()
      end
      
      print("game over")
      -- Net:request("battle.battleHandler.leavePlayer",{},function(params) 
      --   self:onGameOver(result)
      -- end);
      self:onGameOver(result)
      
    end,
    onTeamDie = function (ctrlId,enableRevive)
      if(ctrlId == self._curId)then
        if(not enableRevive ) then
          if(self._curCamp == nil) then
            self._curCamp = self:getMyCamp()
          end
          local result = self._battle:getResult()
          
          -- Net:request("battle.battleHandler.leavePlayer",{},function(params) 
          --   self.onGameOver(result)
          -- end);
          self:onGameOver(result)
        end
        self._curDirection = nil
      end
    end,
   
  }

  if(info.cmds ~= nil) then
    for i = 1,#info.cmds do
      local data = info.cmds[i]
      self:cacheCmd(data);
    end
  end

  self._battle:setMode(mode);
  self._battle:init();
  self._battle:start();
  self._uiBattle = UIBattle.new();
  self._uiBattle:init();
  self._uiBattle:setQueier({
    getRestTime = function() 
      if(self._battle ~= nil)then
        local t = self._battle:getRestTime()
        return t/WorldConfig.battleInterval
      end
      return 0
    end,
    getKillCount = function() 
      if(self._battle ~= nil)then
        return self._battle:getKillCount(self._curId)
      end
      return 0
    end,
    onTouchBegin = function(delta,angle) 
      self:touchIn(delta,angle)
    end,
    onTouchEnd = function(  )
      self:touchOut()
    end,
    onSkillButtonClick = function(  )
      self:onSkillButtonClick()
    end,
    getRank = function()
      if(self._battle == nil) then
        return nil
      end
      return self._battle:getRank()
    end,
    getMyId = function()
      return self._curId
    end,
    getBasementHp = function()

      if(self._curCamp == nil) then
        self._curCamp = self:getMyCamp(self._curId)
      end

      return self._battle:getBasementHp(self._curCamp)
    end
  -- // extention
  });
  
  self._uiBattle:open();

  self._uiBattleEnd = UIBattleEnd.new();
  self._uiBattleEnd:init()
  self._uiBattleEnd:setQueier({
    onEscape = function()
      self:close()              
    end,
    onRetry = function()
      self:reset()
      self:requestStart(self._curBattleId);
    end
  })

  self:playMusic();       
  self._running = true;
  self._frameCount = info.frame or 0
  self._waiting = true
end

function ControllerBattle:initNet() 

  Net:on("onBattleTick",function(data) 
     if(self._battle == nil) then
      return;
    end
    
    if(not self._running) then
      cc.error("no running")
      return;
    end

    if(self._waiting == true) then
      self:waitEnd();
      self._waiting = false
    end

    self._frameCount = self._frameCount + 1;
  end);
  Net:on("onCmd",function(data) 
   self:cacheCmd(data)
  end);
end

function ControllerBattle:cacheCmd(data) 
    if(self._cmds == nil)then
      self._cmds = {};
    end
    local pack = {
      frame = data.frame,
      cmd   = data.cmd,
      arg1  = data.arg1,
      arg2  = data.arg2,
      arg3  = data.arg3,
      arg4  = data.arg4,
      arg5  = data.arg5
    }
    table.insert(self._cmds,pack)
end

function ControllerBattle:close(arg)
  self.super.close(self,arg)
  self:reset()
end

function ControllerBattle:getCtrlId() 
  return self._curId
end

function ControllerBattle:onGameOver(result)
  if(result == nil) then
    return
  end
  
  if(self._uiBattleEnd ~= nil)then

    local refs = {
      [Enum.EResult.Timeout] = function( ... )
        return Common.stringTable.TimeOut
      end,
      [Enum.EResult.Succ] = function( ... )
        if(result.winner == nil) then
          return Common.stringTable.Tied
        end
        if(result.winner == self._curCamp) then
          return Common.stringTable.Succ
        end
      
        return Common.stringTable.Fail  
      end,
      [Enum.EResult.PlayerDie] = function( ... )
        return Common.stringTable.PlayerDie
      end
    }
    local tittle = refs[result.endType]
    local scores = result.scores
    local rank = nil
    local score = nil

    if(scores ~= nil) then
      for i = 1,#scores do

        local item = scores[i]
        if(item.ctrlId == self._curId) then
          rank = item.rank
          score = item.score
        end
      end
    end

    self._uiBattleEnd:setResult(tittle,rank,score)
    self._uiBattleEnd:open()

    if(self._uiBattle ~= nil) then
      self._uiBattle:close()
    end

  end
  self:stopMusic()
end

function ControllerBattle:onSkillButtonClick(  )
  if(self._battle == nil) then
    return
  end
  self._battle:DoCMD(Enum.CMD.Skill,self:getCtrlId())
end

function ControllerBattle:touchIn(delta,angle)
    if(self._battle == nil)then
      return
    end

    if(self._curDirection ~= nil) then
      if(math.abs(self._curDirection - angle) < WorldConfig.minAngle) then
        return
      end
    end

    self._curDirection = angle
 
    local x = math.floor(delta.x * WorldConfig.vectorPrecision) 
    local y = math.floor(delta.y * WorldConfig.vectorPrecision)

    self._battle:DoCMD(Enum.CMD.MoveEx,self:getCtrlId(),x,y)
end

function ControllerBattle:touchOut(  )
    if(self._battle == nil) then
      return
    end
    self._curDirection = nil
    self._battle:DoCMD(Enum.CMD.StopMove,self:getCtrlId())
end

function ControllerBattle:excuteKeycode(keyCode) 
    if(self._battle == nil )then
      return
    end

    local refs = {
      [cc.KEY.up] = Enum.Direction.Up,
      [cc.KEY.down] = Enum.Direction.Down,
      [cc.KEY.left] = Enum.Direction.Left,
      [cc.KEY.right] = Enum.Direction.Right
    }
    local dir = refs[keyCode]
    if(self._curDirection == dir)then
        return
    end
    self._curDirection = dir
    self._battle:DoCMD(Enum.CMD.Move,self:getCtrlId(),self._curDirection); 
    
end
   
function ControllerBattle:playMusic()
    AudioManager:getInstance():playMusic(Common.assetPathTable.musicBattle)
end

function ControllerBattle:stopMusic() 
    AudioManager:getInstance():stopMusic()
end

return ControllerBattle