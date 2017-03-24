  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UISetting = cc.class("UISetting",UIBase)

function UISetting:ctor( ... )

end

function UISetting:init( ... )
  -- body
    self.super.init(self)
    self:setResPath(Common.assetPathTable.uiSetting)
end

function UIBase:useStack( ... )
    return false
end

function UISetting:loaded(res)
      
  self.super.loaded(self,res)

  local stats = res:getChildByName("mask");
  local mask = stats:getComponent("cc.Button")

  mask:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
      self:notify("close")
  end)

end

function UISetting:fresh()
      

end

function UISetting:setResult(tittle,rank,score)

end

function UISetting:isTweenShow() 
  return true
end
  
return UISetting