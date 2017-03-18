  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UILogin = cc.class("UILogin",UIBase)

function UILogin:onCreate(  )
  self._button1 = nil
  self._button2 = nil
end
  
function UILogin:init()
  self:setResPath(Common.assetPathTable.uiLogin)
end


function UILogin:loaded(res)
  self.super.loaded(self,res)

  local bottom = res:getChildByName("bottom")
  local mode1 = bottom:getChildByName("mode_1");
  self._button1 = mode1:getComponent("cc.Button")

  self._button1:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
    self:onButtonClick(1)
  end)

  local effect = res:getChildByName("effect")

  local transition = require "cocos.framework.transition"
  
  local actions = {}
  for i = 1,10 do
      local action = transition.moveTo(effect,{x = math.random(-200,200), y = math.random(0,200),time = 5});
      table.insert(actions,action)
  end

  local seq = transition.sequence(actions);
  effect:runAction(cc.RepeatForever:create(seq))

  local logo = res:getChildByName("logo")
  -- local SpriteFrameManager = require("app.manager.spriteFrameManager")
  -- local gridNode = cc.NodeGrid:create()
  -- local spriteFrame = SpriteFrameManager:getInstance():getSpriteFrame("logo")
  -- local sprite = cc.Sprite:createWithSpriteFrame(spriteFrame)
  -- logo:addChild(gridNode)
  -- gridNode:addChild(sprite)
    
  -- local waveAction = cc.Waves:create(32, cc.size(16,16), 8, 4, true, true)
  -- gridNode:runAction(cc.RepeatForever:create(waveAction))

  local actionTo1 = transition.scaleTo(logo,{scaleX = 1.05, scaleY = 1.05,time = 2});
  local actionTo2 = transition.scaleTo(logo,{scaleX = 1, scaleY = 1,time = 0.1});
  local actionTo2 = transition.scaleTo(logo,{scaleX = 1, scaleY = 1,time = 5});
  local seq = transition.sequence({actionTo1,actionTo2,actionTo3});
  logo:runAction(cc.RepeatForever:create(seq))

end

function UILogin:unload( )
  self._button1:off(cc.Handler.EVENT_TOUCH_ENDED,self._onStart)
  UIBase.unload(self)
end

function UILogin:fresh()
end

function UILogin:onButtonClick(arg1,arg2)
    self:notify("start",arg1,arg2);
end

return UILogin