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

function ModelUser:getCoin(  )
	self:loadData()
	return self._coin
end

function ModelUser:setCoin( coin )
	self._coin = coin
	self:saveData()
end

local COIN_COUNT = "coin"
local USER_NAME = "user"
local DEFAULT_USER_NAME = 'abc'

function ModelUser:loadData(  )
	local userExist = cc.UserDefault:getInstance():getStringForKey(USER_NAME)
	if(userExist == nil or userExist == '') then
		local WorldConfig = require("app.controller.battle.config.worldConfig")
		cc.UserDefault:getInstance():setStringForKey(USER_NAME,DEFAULT_USER_NAME)
		self:setCoin(WorldConfig.defaultCoin)
	end
	-- print(userExist)
	self._coin = cc.UserDefault:getInstance():getIntegerForKey(COIN_COUNT)
end

function ModelUser:saveData(  )
	cc.UserDefault:getInstance():setIntegerForKey(COIN_COUNT, self._coin)
end

return ModelUser