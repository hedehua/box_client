local ObjManager = require("app.manager.objManager")
local Common = require("app.common.include")

local AvatarManager = cc.class("AvatarManager",ObjManager)

local _instance = nil
function AvatarManager:getInstance(  )
	if(_instance ~= nil) then
		return _instance
	end
	_instance = AvatarManager.new()
	return _instance
end

function AvatarManager:getRootName() 
	return Common.constant.Avatar	
end

return AvatarManager