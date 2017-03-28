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

    local slider1 = ccui.Slider:create()
    slider1:setTouchEnabled(true)
    slider1:loadBarTexture(Common.assetPathTable.sliderBar)
    slider1:loadSlidBallTextures(Common.assetPathTable.sliderThumb, Common.assetPathTable.sliderThumb, "")
    slider1:loadProgressBarTexture(Common.assetPathTable.sliderProgress)
    slider1:setPosition(cc.p(0, 140))
    slider1:setScale9Enabled(true);
    slider1:setCapInsets(cc.rect(0, 0, 0, 0));
    slider1:setContentSize(cc.size(300, 25));
    slider1:setPercent(self:request("getMusicVolume"))
    slider1:addEventListener(function( sender,eventType )
        local percent = sender:getPercent()
        self:request("setMusicVolume",percent)
    end)
    res:addChild(slider1)

    local slider2 = ccui.Slider:create()
    slider2:setTouchEnabled(true)
    slider2:loadBarTexture(Common.assetPathTable.sliderBar)
    slider2:loadSlidBallTextures(Common.assetPathTable.sliderThumb, Common.assetPathTable.sliderThumb, "")
    slider2:loadProgressBarTexture(Common.assetPathTable.sliderProgress)
    slider2:setPosition(cc.p(0, 40))
    slider2:setScale9Enabled(true);
    slider2:setCapInsets(cc.rect(0, 0, 0, 0));
    slider2:setContentSize(cc.size(300, 25));
    slider2:setPercent(self:request("getAudioVolume"))
    slider2:addEventListener(function( sender,eventType )
        local percent = sender:getPercent()
        self:request("setAudioVolume",percent)
    end)
    res:addChild(slider2)

end

function UISetting:fresh()
      

end

function UISetting:setResult(tittle,rank,score)

end

function UISetting:isTweenShow() 
    return true
end
  
return UISetting