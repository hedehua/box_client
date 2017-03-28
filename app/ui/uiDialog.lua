  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UIDialog = cc.class("UIDialog",UIBase)

function UIDialog:ctor( ... )

end

function UIDialog:init( ... )
  -- body
  self.super.init(self)
  self:setResPath(Common.assetPathTable.uiDialog)
end

function UIDialog:useStack( ... )
    return false
end

function UIDialog:loaded(res)
      
    self.super.loaded(self,res)

    local node = res:getChildByName("mask");
    local mask = node:getComponent("cc.Button")

    mask:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
    		self:notify("close")
    end)

    local node1 = res:getChildByName("bt_1")
    local node2 = res:getChildByName("bt_2")

    local btn1 = node1:getComponent("cc.Button")
    local btn2 = node2:getComponent("cc.Button")

    btn1:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
        self:notify("cancel")
    end)

    btn2:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
        self:notify("confirm")
    end)
end

function UIDialog:isTweenShow()
    return true
end
  
return UIDialog