local resManager = require("app.manager.resManager")
local AudioManager = cc.class("AudioManager")


local _instance = nil

function AudioManager:getInstance( ... )
	if(_instance ~= nil) then
		return _instance
	end
	_instance = AudioManager.new()
	return _instance
end

function AudioManager:ctor(  )
	-- body
end

function AudioManager:playMusic( ... )
	-- body
end

function AudioManager:playEffect( ... )
	-- body
end

function AudioManager:stopMusic( ... )
	-- body
end

return AudioManager
