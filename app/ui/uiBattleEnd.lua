  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UIBattleEnd = cc.class("UIBattleEnd",UIBase)
function UIBattleEnd:ctor( ... )
  self._btnEscape = nil
  self._btnRetry = nil

  self._rankRoot = nil
  self._scoreRoot = nil

  self._rankNode = nil
  self._scoreNode = nil

  self._tittleNode = nil

  self._tittle = nil
  self._score = nil
  self._rank = nil
end

function UIBattleEnd:init( ... )
  -- body
  self.super.init(self)
  self:setResPath(Common.assetPathTable.uiBattleEnd)
end

function UIBattleEnd:loaded(res)
      
  self.super.loaded(self,res)

  local tnode = nil
  self._rankRoot = res.getChildByName("rank")
  tnode = self._rankRoot.getChildByName("txt") 
  self._rankNode = tnode.getComponent("cc.Label")

  self._scoreRoot = res.getChildByName("score")
  tnode = self._scoreRoot.getChildByName("txt")
  self._scoreNode = tnode.getComponent("cc.Label")

  tnode = res.getChildByName("tittle")
  self._tittleNode = tnode.getComponent("cc.Label")

  self._btnEscape = res.getChildByName("bt_1");
  self._btnEscape.on(cc.Node.EventType.TOUCH_START, function (event) 
    self:notify("onEscape")
  end);
  self._btnRetry = res.getChildByName("bt_2");
  self._btnRetry.on(cc.Node.EventType.TOUCH_START, function (event) 
    self:notify("onRetry")  
  end);

end
function UIBattleEnd:fresh()
      
  if(self._rankRoot ~= nil) then
    self._rankRoot.active = (self._rank ~= nil)
  end
  if(self._rankNode ~= nil and self._rank ~= nil) then
    self._rankNode.string =  self._rank
  end

  if(self._scoreRoot ~= nil) then
    self._scoreRoot.active = (self._score ~= nil)
  end
  if(self._scoreNode ~= nil and self._score ~= nil) then
    self._scoreNode.string =  self._score 
  end

  if(self._tittleNode ~= nil) then
    self._tittleNode.string = self._tittle
  end

end

function UIBattleEnd:setResult(tittle,rank,score)
    self._tittle = tittle
    self._rank = rank
    self._score = score
end

function UIBattleEnd:isTweenShow() 
  return true
end
  
return UIBattleEnd