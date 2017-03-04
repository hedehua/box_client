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

return EffectManager