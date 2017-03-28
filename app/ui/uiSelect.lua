  -- // 战斗界面UI
local UIBase = require("app.framework.uiBase")
local Common = require("app.common.include")

local UISelect = cc.class("UISelect",UIBase)

function UISelect:ctor( ... )

end

function UISelect:init( ... )
  -- body
    self.super.init(self)
    self:setResPath(Common.assetPathTable.uiSelect)
end

function UIBase:useStack( ... )
    return false
end

function UISelect:loaded(res)
      
  self.super.loaded(self,res)

  local mask = res:getChildByName("mask");
  local maskBtn = mask:getComponent("cc.Button")

  maskBtn:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
      self:notify("close")
  end)

  for i = 1,3 do
    local nodeName = "mode_"..i
    local mod = res:getChildByName(nodeName);
    local btn = mod:getComponent("cc.Button")
    btn:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
        Common.utils.playButtonClick()
        self:notify("selectItem",i)
    end)
  end

end

function UISelect:fresh()
      
end

function UISelect:setResult(tittle,rank,score)

end

function UISelect:isTweenShow() 
    return true
end
  
return UISelect