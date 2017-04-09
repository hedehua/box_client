local ModelBase = require("app.framework.modelBase")
local ModelUser = cc.class("ModelUser",ModelBase)

local _instance = nil
function ModelUser:getInstance( ... )
    if(_instance == nil ) then
        _instance = ModelUser.new();
    end
    return _instance
end
function ModelUser:ctor( ... )
    self._roles = nil
    self._tools = nil
    self._uid = 10000
    self._coin = 0
end


function ModelUser:init()
	self:loadData()
	-- // 可在此处增加测试数据
	self:addRole({_roleId = 10000001,_typeId = 1001,_attack = 12,_maxHp = 100})
	self:addRole({_roleId = 10000002,_typeId = 1002,_attack = 15,_maxHp = 50})
	self:addRole({_roleId = 10000003,_typeId = 1003,_attack = 5,_maxHp = 500})
	
end

function ModelUser:setUid(uid) 
	self._uid = uid
end

function ModelUser:getUid()
	return self._uid
end

function ModelUser:getRoles()
	return self._roles
end

function ModelUser:getRoleById(roleId)
	if(self._roles == nil) then
		return nil;
	end
	for i = #self._roles,1,-1 do
		local role = self._roles[i]
		if(role._roleId == roleId) then
			return role
		end
	end
	return nil;
end

function ModelUser:addRole (role) 
	if(role == nil) then
		return;
	end
	if(self._roles == nil) then
		self._roles = {}
	end
    table.insert(self._roles,role)
end

function ModelUser:removeRole(role) 
	if(role == nil) then
		return;
	end
	if(self._roles == nil) then
		return;
	end
	for i = #self._roles,1,-1 do
		local r = self._roles[i]
		if(r ~= nil and role == r) then
            table.remove(self._roles,i)
		end
	end
end

local KEY_COIN_COUNT = "coin"
local KEY_USER_NAME = "user"
local KEY_AUDIO_VOLUME = "audio"
local KEY_MUSIC_VOLUME = "music"

local DEFAULT_USER_NAME = 'abc'
local DEFAULT_VOLUME = 80

function ModelUser:getAudioVolume(  )
	return cc.UserDefault:getInstance():getIntegerForKey(KEY_AUDIO_VOLUME)
end

function ModelUser:setAudioVolume( volume )
	cc.UserDefault:getInstance():setIntegerForKey(KEY_AUDIO_VOLUME,volume)
end

function ModelUser:getMusicVolume(  )
	return cc.UserDefault:getInstance():getIntegerForKey(KEY_MUSIC_VOLUME)
end

function ModelUser:setMusicVolume( volume )
	cc.UserDefault:getInstance():setIntegerForKey(KEY_MUSIC_VOLUME,volume)
end

function ModelUser:loadData(  )
	local userExist = cc.UserDefault:getInstance():getStringForKey(KEY_USER_NAME)
	if(userExist == nil or userExist == '') then
		local WorldConfig = require("app.controller.battle.config.worldConfig")
		cc.UserDefault:getInstance():setStringForKey(KEY_USER_NAME,DEFAULT_USER_NAME)

		self:setMusicVolume(DEFAULT_VOLUME)
		self:setAudioVolume(DEFAULT_VOLUME)
		self:setCoin(WorldConfig.defaultCoin)
	end
end

function ModelUser:getCoin(  )
	return cc.UserDefault:getInstance():getIntegerForKey(KEY_COIN_COUNT)
end

function ModelUser:setCoin( coin )
	cc.UserDefault:getInstance():setIntegerForKey(KEY_COIN_COUNT, coin)
end


return ModelUser