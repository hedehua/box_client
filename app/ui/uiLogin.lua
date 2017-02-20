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

  self._button1:on(cc.Handler.EVENT_TOUCH_BEGAN,function(  )
    self:onButtonClick(1)
  end)

end

function UILogin:unload( )
  self._button1:off(cc.Handler.EVENT_TOUCH_BEGAN,self._onStart)
  UIBase.unload(self)
end

function UILogin:fresh()
end

function UILogin:onButtonClick(arg1,arg2)
    self:notify("start",arg1,arg2);
end

return UILogin