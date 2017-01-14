local TimerManager = require("app.manager.timerManager")
local ObjManager = require("app.manager.objManager")
local Common = require("app.common.include")
local EffectManager = cc.class("EffectManager",ObjManager)

local _instance = nil
function EffectManager:getInstance(  )
	if(_instance ~= nil) then
		return _instance
	end
	_instance = EffectManager.new()
	return _instance
end

function EffectManager:playEffect(resName,pos,duration)

	self:load(resName,function(err,newNode) 
		newNode.position = pos
		-- // var comps = newNode.getComponentsInChildren("cc.Animation")
		-- // if(comps ~= null) then
		-- // 	for i = 1,comps.length do
		-- // 		comps[i].play()
		-- // 	end
		-- // end
		TimerManager:getInstance():runOnce(function() 
			self:unload(newNode)
		end, duration);
	end)

end

return EffectManager