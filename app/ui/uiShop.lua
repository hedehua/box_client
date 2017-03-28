  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UIShop = cc.class("UIShop",UIBase)

function UIShop:ctor( ... )

end

function UIShop:init( ... )
  -- body
    self.super.init(self)
    self:setResPath(Common.assetPathTable.uiShop)
end

function UIShop:useStack( ... )
    return false
end

function UIShop:loaded(res)
      
    self.super.loaded(self,res)

    local mask = res:getChildByName("mask");
    local maskBtn = mask:getComponent("cc.Button")

    maskBtn:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
        self:notify("close")
    end)

    for i = 1,3 do
      local nodeName = "goods_"..i
      local mod = res:getChildByName(nodeName);
      local btn = mod:getComponent("cc.Button")
      btn:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
          Common.utils.playButtonClick()
          self:notify("selectItem",i)
      end)
    end

end

function UIShop:fresh()
      

end

function UIShop:setResult(tittle,rank,score)

end

function UIShop:isTweenShow() 
    return true
end
  
return UIShop