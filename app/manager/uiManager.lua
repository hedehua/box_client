local ResManager = require("app.manager.resManager")
local Common = require("app.common.include")
local UIManager = cc.class("UIManager")

local _instance = nil
function UIManager:getInstance( ... )
    if(_instance == nil) then
        _instance = UIManager.new()
    end
    return _instance
end

function UIManager:ctor( ... )
    self._uiRoot = nil
    self._objectsArr = {}
end

function UIManager:init()
    self._uiRoot = nil
end

function UIManager:uninit()

end

function UIManager:reset()
        
end

function UIManager:load(resName,callback)
    
    local creator = require "creator.init"
    local assets = creator.getAssets()
    local asset = assets:createPrefab(resName)

    if(self._uiRoot == nil) then
        local scene = cc.Director:getInstance():getRunningScene()
        self._uiRoot = scene:getChildByName("ui_root")  
    end
    
    self._uiRoot:addChild(asset)
    asset:setPosition({x=0,y=0,z=0})
    table.insert(self._objectsArr,asset)
    if(callback ~= nil) then
        callback(err,asset);
    end

end

function UIManager:unload(obj) 
	if(obj == nil) then
        return;
    end

    for i = table.length(self._objectsArr),1,-1 do
        local o = self._objectsArr[i]
        if(o ~= nil and o == obj) then
            table.remove(self._objectsArr,i)
            obj:removeFromParent(true);
            break
        end
    end
end

return UIManager