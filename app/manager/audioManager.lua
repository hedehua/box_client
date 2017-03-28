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
	audio.setMusicVolume(0.1)
	audio.playMusic(path)
end

function AudioManager:playEffect( path )
	local audio = require "cocos.framework.audio"
    audio.playSound(path,false)
end

function AudioManager:playUIClick(  )
	local path = "raw-assets/resources/music/button.mp3"
	local audio = require "cocos.framework.audio"
    audio.playSound(path,false)
end

function AudioManager:stopMusic( path )
	local audio = require "cocos.framework.audio"
	audio.stopMusic(path)
end

function AudioManager:setAudioVolume( volume )
	local audio = require "cocos.framework.audio"
	audio.setSoundsVolume(volume)
end

function AudioManager:setMusicVolume( volume )
	local audio = require "cocos.framework.audio"
	audio.setMusicVolume(volume)
end



return AudioManager
