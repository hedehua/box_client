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

function EffectManager:playEffect(resName,pos,duration)

	ObjManager:getInstance():load(resName,function(err,newNode) 
		newNode:setPosition(pos.x,pos.y)
		TimerManager:getInstance():runOnce(function() 
			ObjManager:getInstance():unload(newNode)
		end, duration);
	end)

end

return EffectManager