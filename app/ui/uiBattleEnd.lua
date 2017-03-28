  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UIBattleEnd = cc.class("UIBattleEnd",UIBase)
function UIBattleEnd:ctor( ... )
    self._btnEscape = nil
    self._btnRetry = nil

    self._scoreRoot = nil
    self._scoreNode = nil
    self._emptyNode = nil

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

function UIBattleEnd:useStack( ... )
    return false
end

function UIBattleEnd:loaded(res)
      
    self.super.loaded(self,res)

    local tnode = nil

    self._scoreRoot = res:getChildByName("score")
    tnode = self._scoreRoot:getChildByName("txt")
    self._scoreNode = tnode:getComponent("cc.Label")

    tnode = res:getChildByName("tittle")
    self._tittleNode = tnode:getComponent("cc.Label")

    self._emptyNode = res:getChildByName("empty")

    local bt1 = res:getChildByName("bt_1");
    self._btnEscape = bt1:getComponent("cc.Button")
    self._btnEscape:on(cc.Handler.EVENT_TOUCH_BEGAN, function (event) 
      Common.utils.playButtonClick()
      self:notify("onEscape")
    end);

    local bt2 = res:getChildByName("bt_2");
    self._btnRetry = bt2:getComponent("cc.Button")
    self._btnRetry:on(cc.Handler.EVENT_TOUCH_BEGAN, function (event) 
      Common.utils.playButtonClick()
      self:notify("onRetry")  
    end);

end
function UIBattleEnd:fresh()
      
    if(self._score ~= nil) then
        self._scoreNode.node:setString(self._score..'')
        self._scoreRoot:setVisible(true)
        self._emptyNode:setVisible(false)
    else
        self._scoreRoot:setVisible(false)
        self._emptyNode:setVisible(true)
    end

    if(self._tittleNode ~= nil) then
        self._tittleNode.node:setString(self._tittle..'')
    end

end

function UIBattleEnd:setResult(tittle,rank,score)
    self._tittle = tittle
    self._rank = rank
    self._score = score
end

function UIBattleEnd:unload( )
    UIBase.unload(self)
end

function UIBattleEnd:isTweenShow() 
    return true
end
  
return UIBattleEnd