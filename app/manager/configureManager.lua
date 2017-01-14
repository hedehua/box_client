local ConfigureManager = cc.class("ConfigureManager")

local _instance = nil

function ConfigureManager:getInstance( ... )
	if(_instance == nil) then
		_instance = ConfigureManager.new()
	end
	return _instance
end

function ConfigureManager:init( ... )
	-- body
end

function ConfigureManager:uninit( ... )
	-- body
end

return ConfigureManager