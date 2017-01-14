

-- let BlinkTxt = cc.Class({
--     name: 'BlinkTxt',

--     properties: {
--         txtNode : {
--             default : null,
--             type : cc.Label
--         },
--         bgNode : {
--             default : null,
--             type : cc.Sprite
--         },
--         interval : 1.0,
--         _blink : null,
--     },

--     playTips : function(tips) {
--         if(this.txtNode == null){
--             return
--         }
--         this.txtNode.node.active = true
--         this.bgNode.node.active = true
--         this.txtNode.string = tips
--         var fadeIn = cc.fadeIn(this.interval);
--         var fadeOut = cc.fadeOut(this.interval);
--         var fade = cc.sequence(fadeIn,fadeOut)
--         this._blink = cc.repeatForever(fade)
--         this.txtNode.node.runAction(this._blink)
--     },
--     stopTips : function() {
--         if(this.txtNode == null){
--             return
--         }
--         if(this._blink == null){
--             return
--         }
--         this.txtNode.node.stopAction(this._blink)
--         this._blink = null
--         this.txtNode.node.active = false
--         this.bgNode.node.active = false
--     }
-- });

-- let CoolDown = cc.Class({
--     name: 'CoolDown',

--     properties: {
--         animNode : {
--             default : null,
--             type : cc.Animation
--         },
--     },

--     playTips : function(t) {
--         if(this.animNode == null){
--             return
--         }
--         this.animNode.node.active = true
--         this.animNode.play();
--     },
--     stopTips : function() {
--         if(this.animNode == null){
--             return
--         }
 
--         this.animNode.node.active = false
--         this.animNode.stop();
--     }
-- });

local TipsManager = cc.class("TipsManager")

local _instance = nil

function TipsManager:getInstance( ... )
    if(_instance ~= nil) then
        return _instance
    end
    _instance = TipsManager.new()
    return _instance
end

function TipsManager:onCreate( ... )
    -- body
end

function TipsManager:init()
   
end
function TipsManager:reset() end

function TipsManager:uninit() end

function TipsManager:playBlink(tips) 
    -- this.blinkStyle.playTips(tips)
end

function TipsManager:stopBlink() 
    -- this.blinkStyle.stopTips()
end

function TipsManager:playCd(t) 
    -- this.cdStyle.playTips()

    -- this.schedule(function(){
    --     TipsManager.instance.stopCd();
    -- },t);
end

function TipsManager:stopCd()
    -- this.cdStyle.stopTips()
end

return TipsManager
