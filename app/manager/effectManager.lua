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

	if(objRoot == nil) then
		local scene = cc.Director:getInstance():getRunningScene()
		objRoot = scene:getChildByName("scene_root")
	end
	ObjManager:getInstance():load(resName,function(err,res) 

		res:setPosition(pos.x,pos.y)
		TimerManager:getInstance():runOnce(function()
			ObjManager:getInstance():unload(res)
		end, duration);
	end,objRoot)

end

function EffectManager:flyEffect( resName,pos1,pos2 )
	
	if(objRoot == nil) then
		local scene = cc.Director:getInstance():getRunningScene()
	    objRoot = scene:getChildByName("scene_root")
	end

	ObjManager:getInstance():load(resName,function(err,res) 
        
		res:setPosition(pos1.x,pos1.y)
		local action5 = cc.FadeIn:create(0.05)
  	    local action1 = cc.ScaleTo:create(0.1, 0.8)
  	    local action2 = cc.ScaleTo:create(0.2, 0.5)
  	    local action3 = cc.DelayTime:create(0.2)
  	    local action4 = cc.ScaleTo:create(0.3, 0.5)
  	    local action5 = cc.FadeOut:create(0.15)

	    local bezier = {  
		    cc.p(pos1.x, pos1.y),  
		    cc.p(pos1.x + 20,pos1.y + 20),  
		    cc.p(pos2.x, pos2.y),  
		}  
		-- CatmullRomBy BezierBy
		local action6 = cc.BezierBy:create(0.8, bezier)
		local action7 = cc.MoveTo:create(0.1, cc.p(pos2.x,pos2.y))

	    local seq1 = cc.Sequence:create({action1,action2,action3,action4,action5})
	    local seq2 = cc.Sequence:create({action6,action7})
	    res:runAction(seq1)
	    res:runAction(seq2)
		TimerManager:getInstance():runOnce(function() 
			ObjManager:getInstance():unload(res)
		end, 1.1);
	end,objRoot)
end

return EffectManager