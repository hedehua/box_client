  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UILogin = cc.class("UILogin",UIBase)

function UILogin:onCreate(  )
    self._button1 = nil
    self._button2 = nil
    self._button3 = nil
    self._button4 = nil
end
  
function UILogin:init()
    self:setResPath(Common.assetPathTable.uiLogin)
end


function UILogin:loaded(res)
    self.super.loaded(self,res)

    local bottom = res:getChildByName("bottom")
    local top = res:getChildByName("top")

    local coin = top:getChildByName("coin")
    self._coin = coin:getComponent("cc.Label")
    self._coin.node:setString(self:request("getCoin"))

    local start = bottom:getChildByName("start");
    self._button1 = start:getComponent("cc.Button")

    self._button1:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
      self:onButtonClick(1)
    end)

    local stats = bottom:getChildByName("stats");
    self._button2 = stats:getComponent("cc.Button")

    self._button2:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
      self:onStatsButtonClick()
    end)

    local setting = top:getChildByName("setting");
    self._button3 = setting:getComponent("cc.Button")

    self._button3:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
      self:onSettingButtonClick()
    end)

    local shop = bottom:getChildByName("shop");
    self._button4 = shop:getComponent("cc.Button")

    self._button4:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
      self:onShopButtonClick()
    end)

    local effect = res:getChildByName("effect")

    local transition = require "cocos.framework.transition"
    
    local actions = {}
    for i = 1,10 do
        local action = cc.MoveTo:create(5, cc.p(math.random(-200,200),math.random(0,200)))
        table.insert(actions,action)
    end

    local seq = transition.sequence(actions);
    effect:runAction(cc.RepeatForever:create(seq))

    local logo = res:getChildByName("logo")
    local actionTo1 = cc.ScaleTo:create(2, 1.1)
    local actionTo2 = cc.ScaleTo:create(1, 1)
    local actionTo3 = cc.ScaleTo:create(3, 1)
    local seq = transition.sequence({actionTo1,actionTo2,actionTo3});
    logo:runAction(cc.RepeatForever:create(seq))

    local img = Common.assetPathTable.texturePix
    self._motion = cc.MotionStreak:create(2, 1.0, 50.0, cc.c3b(255, 255, 0),img)
    res:addChild(self._motion)
    self._motion:runAction(seq)
end

function UILogin:unload( )
    self._button1:off(cc.Handler.EVENT_TOUCH_ENDED,self._onStart)
    UIBase.unload(self)
end

function UILogin:fresh()
    self._coin.node:setString("x"..self:request("getCoin"))
end


function UILogin:onShopButtonClick(  )
    Common.utils.playButtonClick()
    self:notify("shop");
end

function UILogin:onButtonClick(arg1,arg2)
    Common.utils.playButtonClick()
    self:notify("start",arg1,arg2);
end

function UILogin:onSettingButtonClick(  )
    Common.utils.playButtonClick()
    self:notify("setting")
end

function UILogin:onStatsButtonClick(  )
    Common.utils.playButtonClick()
    self:notify("stats")
end

return UILogin