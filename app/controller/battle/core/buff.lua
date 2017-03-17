local Utils = require("app.controller.battle.core.battleUtils")

local Buff = {}
Buff.__cname = "Buff"

local static_count = 0
local getNextId = function()
	static_count = static_count + 1
	return static_count;
end

function Buff.new()
	local obj = BattleObject.new()
	setmetatable(obj,{__index = Buff})
	obj._id = getNextId()
	obj._typeId = 0  		
	obj._frameCount = 0
	obj._duration = 0
	obj._config = nil
	obj._hoster = nil
	return obj
end

function Buff:init( typeId,hoster)
	self._typeId = typeId
	self._config = Utils.getConfigByName("buffConfig",typeId)

	self._duration = self._config.duration
	self._frameCount = 0
	self._hoster = hoster
end

function Buff:update(  )
	self._frameCount = self._frameCount + 1
	if(self._frameCount >= self._duration) then
		return
	end
	
end

function Buff:uninit(  )
	self._config = nil
	self._hoster = nil
end

return Buff
