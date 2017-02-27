  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")
local WorldConfig = require("app.controller.battle.config.worldConfig")

local nameCache = {}
local getName = function(uid)
  uid = uid or 0
  local name = nameCache[uid]
  if(name == nil) then
    name = Common.stringTable["Name"..math.abs(uid%10)]
    nameCache[uid] = name
  end
  return name 
end

local UIBattle = cc.class("UIBattle",UIBase)
function UIBattle:ctor( ... )
  self._timeNode = nil
  self._killNode = nil

  self._upNode = nil
  self._downNode = nil
  self._leftNode = nil
  self._rightNode = nil

  self._stickNode = nil
  self._touchNode = nil

  self._skillButton = nil

  self._rankNode = nil
  self._rankGrid = nil
  self._rankItems= nil

  self._myRankRoot = nil
  self._myRankNode = nil
  self._myContextNode = nil

  self._basementRoot = nil
  self._basementHpNode = nil

  self._basementHp = nil

  self._touchPos = nil

  self._listener = nil
  self._touchListner = nil 
end

    
function UIBattle:init()
  self:setResPath(Common.assetPathTable.uiBattle)
end
function UIBattle:uninit() 
  self:removeListner();
  self.super.uninit(self)
end
function UIBattle:loaded(res)
  self.super.loaded(self)
  local top = res:getChildByName("top")
  local topRight = res:getChildByName("top_right")
  local topLeft = res:getChildByName("top_left")
  local bottomRight = res:getChildByName("bottom_right")

  local timeNode = top:getChildByName("restTime") 
  local countNode = top:getChildByName("kill_count")
  self._timeNode = timeNode:getComponent("cc.Label")
  self._killNode = countNode:getComponent("cc.Label")

  self._rankNode = topRight:getChildByName("rank")
  self._rankGrid = self._rankNode:getChildByName("grid")

  self._myRankRoot = topRight:getChildByName("myRank")
  local rankNode = self._myRankRoot:getChildByName("rank")
  self._myRankNode = rankNode:getComponent("cc.Label")

  local contextNode = self._myRankRoot:getChildByName("context")
  self._myContextNode = contextNode:getComponent("cc.Label")

  self._basementRoot = topLeft:getChildByName("info")
  local hpNode = self._basementRoot:getChildByName("hp")
  self._basementHpNode = hpNode:getComponent("cc.Label") 

  local skillNode = bottomRight:getChildByName("skill")
  self._skillButton = skillNode:getComponent("cc.Button")
  self._skillButton:on(cc.Handler.EVENT_TOUCH_BEGAN,function(  )
    self:onSkillButtonClick()
  end)

  -- // keyboard
  local node = res;
  self._stickNode = res:getChildByName("stick")
  self._touchNode = self._stickNode:getChildByName("touch")
  self:setStickActive(false)

  local _onTouchBegan = function (touch, event) 

      local pos = res:convertTouchToNodeSpaceAR (touch)
      if(pos.x > 0 or pos.y > 0) then
        return true
      end
      self:setStickActive(true)
      self:setStickPos(pos)
      self._touchPos = self._stickNode:convertTouchToNodeSpaceAR (touch)
      self:setTouchPos(self._touchPos) 
      return true; 
  end
  local _onTouchMoved = function (touch, event) 
    if(self._touchPos == nil) then
      return
    end

    local originPos = self._touchPos
    local curPos = self._stickNode:convertTouchToNodeSpaceAR (touch)

    local pos =  cc.p(curPos.x,curPos.y)
    local delta = cc.pSub(pos,originPos)
    
    local dist = cc.pGetLength(delta);
    
    if(dist > WorldConfig.maxTouch) then
      pos = cc.pAdd(cc.p(originPos.x,originPos.y),cc.pMul(cc.pNormalize(delta),70));
    end
  
    self:setTouchPos( pos )  

    if(dist < WorldConfig.minTouch) then
      return 
    end

    local angle  = cc.pGetAngle(delta,cc.p(1,0)) 

    -- -- /* 4向逻辑
   
    
    -- if(angle > -WorldConfig.touchAngle and angle < WorldConfig.touchAngle) then
    --   self.onTouchBegin(cc.KEY.right)
    --   return
    -- end

    -- if(angle > Math.PI/2 -WorldConfig.touchAngle and angle < Math.PI/2 + WorldConfig.touchAngle) then
    --   self.onTouchBegin(cc.KEY.up)
    --   return
    -- end

    -- if(angle > -Math.PI/2 -WorldConfig.touchAngle and angle < -Math.PI/2 + WorldConfig.touchAngle)then
    --   self.onTouchBegin(cc.KEY.down)
    --   return
    -- end

    -- if(angle > Math.PI - WorldConfig.touchAngle or angle < -Math.PI + WorldConfig.touchAngle) then
    --   self.onTouchBegin(cc.KEY.left)
    --   return
    -- end
    self:onTouchBegin(cc.pNormalize(pos),angle) 
  end
  local _onTouchEnded = function (touch, event) 
      self:setStickActive(false)
      self:onTouchEnd()
      self._touchPos = nil
  end
  local _onTouchCancelled = function (touch, event) 

  end

  self:removeListner();

  local listener = cc.EventListenerTouchOneByOne:create()
  listener:setSwallowTouches(true)
  listener:registerScriptHandler(function(touch, event)
      return _onTouchBegan(touch,event)
  end, cc.Handler.EVENT_TOUCH_BEGAN)
  listener:registerScriptHandler(function(touch, event)
      return _onTouchMoved(touch,event)
  end, cc.Handler.EVENT_TOUCH_MOVED)
  listener:registerScriptHandler(function(touch, event)
      return _onTouchEnded(touch,event)
  end, cc.Handler.EVENT_TOUCH_ENDED)
  listener:registerScriptHandler(function(touch, event)
      return _onTouchCancelled(touch,event)
  end, cc.Handler.EVENT_TOUCH_CANCELLED)

  cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node);
  self._listener = self._listener or {}
  table.insert(self._listener,listener)


  -- keyborad
  local function onKeyPressed(keyCode, event)  
    self:onKeyPressed(keyCode)
  end  

  local function onKeyReleased(keyCode, event)  
    self:onKeyReleased(keyCode)
  end  

  listener = cc.EventListenerKeyboard:create()  
  listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)  
  listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)  

  cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)  
  table.insert(self._listener,listener)
end

function UIBattle:onSkillButtonClick(  )
  self:notify("onSkillButtonClick")
end

function UIBattle:onTouchBegin(delta,angle)
  self:notify("onTouchBegin",delta,angle)
end

function UIBattle:onTouchEnd(  )
  self:notify("onTouchEnd")
end

function UIBattle:onKeyPressed(keyCode) 

  local pos = nil
  if(keyCode == 127) then     -- right
    pos = cc.p(1,0)
  elseif(keyCode == 124) then -- left
    pos = cc.p(-1,0)
  elseif(keyCode == 146) then -- up
    pos = cc.p(0,1)
  elseif(keyCode == 142) then -- down
    pos = cc.p(0,-1)
  end
  if(pos == nil) then return end
  self:notify("onTouchBegin",pos,cc.pGetAngle(pos,cc.p(1,0)))
end

function UIBattle:onKeyReleased( keyCode )
  self:notify("onTouchEnd")
end

function UIBattle:removeListner() 
  local dispatch = cc.Director:getInstance():getEventDispatcher()
  if(self._listener ~= nil) then
    for i,v in ipairs(self._listener) do
      dispatch:removeEventListener(v)
    end
    self._listener = nil
  end

end

function UIBattle:setStickActive(active) 
  if(self._stickNode == nil)then
    return
  end
  self._stickNode:setVisible(active)
end
function UIBattle:setStickPos(pos) 
  if(self._stickNode == nil) then
    return
  end
  self._stickNode:setPosition(pos)
end
function UIBattle:setTouchActive(active) 
  if(self._touchNode == nil) then
    return
  end
  self._touchNode:setVisible(active)
end
function UIBattle:setTouchPos(pos) 
  if(self._touchNode == nil) then
    return
  end
  
  self._touchNode:setPosition(pos)
end
function UIBattle:fresh()
  if(not self._active) then
    return
  end
  self:freshTime()
  self:freshKillCount()
  self:freshRank()
  self:freshBasementHp();
end
function UIBattle:freshTime()
  if(self._timeNode ~= nil) then
    self._timeNode.node:setString(Common.utils.formatSeconds(self:request("getRestTime")))
  end
end
function UIBattle:freshKillCount()
  if(self._killNode ~= nil) then
   self._killNode.node:setString(self:request("getKillCount"))
  end
end

function UIBattle:freshRank()
 if(self._rankNode == nil) then
   return
 end
 local rank = self:request("getRank")
 
 if(rank == nil or rank.item == nil) then
   self:setRankActive(false)
   self:setMyRankActive(false)
   return
 end
 self:setRankActive(true)
 self:setMyRankActive(true)

 if(not rank.dirty) then
   return
 end

 rank.dirty = false

 if(self._rankItems == nil) then
   self._rankItems = {}
   local children = self._rankGrid:getChildren()
   for i = 1,#children do
     local node = children[i]
     table.insert(self._rankItems,node:getComponent("cc.Label"))
   end
 end
 local myRankInfo = nil
 local ctrlId = self:request("getMyId")
 for i = 1,#rank.item do
   local info = rank.item[i]
   if(info.ctrlId == ctrlId) then
     myRankInfo = info
   end
   local lb = self._rankItems[i]
   if(lb == nil) then
     break
   end
   lb.node:setString(getName(info.ctrlId).." "..info.score)
 end
 if(self._myRankRoot == nil or myRankInfo == nil) then
   return
 end
 self._myRankNode.node:setString(Common.stringTable.Rank..''..myRankInfo.rank)
 self._myContextNode.node:setString(getName(myRankInfo.ctrlId).." "..myRankInfo.score)
end
function UIBattle:freshBasementHp()
 
 if(self._basementHpNode == nil) then
   return
 end
 local hp = self:request("getBasementHp")
 if(hp == nil ) then
   self:setBasementActive(false)
   return
 end

  if(hp == self._basementHp ) then
    return
  end

 self:setBasementActive(true)

 self._basementHpNode.node:setString(hp)
 self._basementHp = hp
end
function UIBattle:setRankActive(active)
 if(self._rankNode == nil) then
   return
 end
 if(self._rankNode:isVisible() == active) then
   return
 end
 self._rankNode:setVisible(active) 
end
function UIBattle:setMyRankActive(active)
 if(self._myRankRoot == nil) then
   return
 end
 if(self._myRankRoot:isVisible() == active) then
   return
 end
 self._myRankRoot:setVisible(active)
end
function UIBattle:setBasementActive(active)
 if(self._basementRoot == nil) then
   return
 end
 if(self._basementRoot:isVisible() == active) then
   return
 end
 self._basementRoot:setVisible(active)
end

function UIBattle:getTempName()

end
  

return UIBattle