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

function UISetting:useStack( ... )
    return false
end

function UISetting:loaded(res)
      
    self.super.loaded(self,res)

    local mask = res:getChildByName("mask");
    local maskBtn = mask:getComponent("cc.Button")

    maskBtn:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
        self:notify("close")
    end)

    local cancel = res:getChildByName("cancel");
    local cancelBtn = cancel:getComponent("cc.Button")

    cancelBtn:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
        Common.utils.playButtonClick()
        self:notify("cancel")
    end)

    local confirm = res:getChildByName("confirm");
    local confirmBtn = cancel:getComponent("cc.Button")

    confirmBtn:on(cc.Handler.EVENT_TOUCH_ENDED,function(  )
        Common.utils.playButtonClick()
        self:notify("cancel")
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