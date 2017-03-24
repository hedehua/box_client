local TimerManager = require("app.manager.timerManager")
local ObjManager = require("app.manager.objManager")
local Common = require("app.common.include")
local EffectManager = cc.class("EffectManager")

local _instance = nil
function EffectManager:getInstance(  )
	if(_instance ~= nil) then
		return _instance
	end
	_instance = EffectManager.new()
	return _instance
end

function EffectManager:init( ... )
	-- body
end

local objRoot = nil

function EffectManager:playEffect(resName,pos,duration)

	ObjManager:getInstance():load(resName,function(err,res) 
		local scene = cc.Director:getInstance():getRunningScene()
        
        if(objRoot == nil) then
            objRoot = scene:getChildByName("scene_root")
        end

        objRoot:addChild(res)

		res:setPosition(pos.x,pos.y)
		TimerManager:getInstance():runOnce(function()
			objRoot:removeChild(res)
			ObjManager:getInstance():unload(res)
		end, duration);
	end)

end

function EffectManager:tweenEffect( resName,pos1,pos2 )
	ObjManager:getInstance():load(resName,function(err,res) 
		local scene = cc.Director:getInstance():getRunningScene()
        
        if(objRoot == nil) then
            objRoot = scene:getChildByName("scene_root")
        end

        objRoot:addChild(res)

		res:setPosition(pos1.x,pos1.y)
  	    local action1 = cc.ScaleTo:create(0.1, 1.2)
  	    local action2 = cc.ScaleTo:create(0.05, 1)
	    local action3 = cc.FadeOut:create(0.1)
	    local seq = cc.Sequence:create({action1,action2,action3})
	    res:runAction(seq)
		TimerManager:getInstance():runOnce(function() 
			objRoot:removeChild(res)
			ObjManager:getInstance():unload(res)
		end, 0.25);
	end)
end

return EffectManager