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

function AudioManager:playMusic( path )
	local audio = require "cocos.framework.audio"
	audio.playMusic(path)
end

function AudioManager:playEffect( path )
	local audio = require "cocos.framework.audio"
    audio.playSound(path,false)
end

function AudioManager:stopMusic( path )
	local audio = require "cocos.framework.audio"
	audio.stopMusic(path)
end

return AudioManager
