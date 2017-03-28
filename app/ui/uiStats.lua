  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UIStats = cc.class("UIStats",UIBase)

function UIStats:ctor( ... )

end

function UIStats:init( ... )
  -- body
    self.super.init(self)
    self:setResPath(Common.assetPathTable.uiStats)
end

function UIStats:useStack( ... )
    return false
end

function UIStats:loaded(res)
      
    self.super.loaded(self,res)

    local stats = res:getChildByName("mask");
    local mask = stats:getComponent("cc.Button")

    mask:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
    		self:notify("close")
    end)

end

function UIStats:isTweenShow() 
    return true
end
  
return UIStats