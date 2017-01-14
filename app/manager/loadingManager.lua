local ResManager = require("app.manager.resManager")
local LoadingManager = cc.class("LoadingManager")

local _instance = nil
function LoadingManager:getInstance( ... )
    if(_instance ~= nil) then
        return _instance
    end
    _instance = LoadingManager.new()
    return _instance
end

function LoadingManager:start( ... )
    -- body
end

function LoadingManager:stop( ... )
    -- body
end

return LoadingManager
