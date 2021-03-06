-- // 對象管理器，實例化對象都向改類請求
local resManager = require("app.manager.resManager")

local ObjManager = cc.class("ObjManager")

function ObjManager:ctor( ... )
	self._tasks = nil
    self._taskSeq = 0

    self._objectsArr = {}
	self._objectsCache = {}
	self._objRoot = nil

end
   
local _instance = nil
function ObjManager:getInstance(  )
	if(_instance ~= nil) then
		return _instance
	end
	_instance = ObjManager.new()
	return _instance
end

function ObjManager:init()
end

function ObjManager:reset()
	
end

function ObjManager:uninit()
	self:reset()
end

function ObjManager:update()
    
end

function ObjManager:load(resName,callback,objRoot) 				

	local info = self:getFromCache(resName)

	if(info ~= nil) then
		self:addTo(info.path,info.res,info.root)
		if(callback ~= nil)then
			callback(nil,info.res);
		end
		return
	end

	local creator = require "creator.init"
    local assets = creator.getAssets()
    local asset = assets:createPrefab(resName)

    self:addTo(resName,asset,objRoot)

    objRoot:addChild(asset)
	if(callback ~= nil) then
		callback(err,asset);
	end

end

function ObjManager:unload(obj,clear) 
	if(obj == nil) then
		return false;
	end
	for i = #self._objectsArr,1,-1 do
		local info = self._objectsArr[i]
		if(info ~= nil and info.res == obj) then
			if(clear) then
				info.root:removeChild(obj)
			else
				self:addToCache(info) 
			end
			
			table.remove(self._objectsArr,i)
			return true
		end
	end

	print("unload error")
	return false		
end

function ObjManager:addTo(resName,obj,root) 
	if(obj == nil) then
		return
	end

	table.insert(self._objectsArr,{res = obj,path = resName,root = root})
end

function ObjManager:addToCache(info)
	if(info == nil) then
		print("add to cache failure")
		return
	end
	if(self._objectsCache == nil) then
		self._objectsCache = {}
	end
	info.res:setVisible(false)
	info.res:stopAllActions()
	table.insert(self._objectsCache,info)
end
function ObjManager:getFromCache(resName)
	if(resName == nil) then
		print("argument nil")
		return nil
	end
	if(self._objectsCache == nil) then
		return nil
	end

	for i = #self._objectsCache,1,-1 do
		local info = self._objectsCache[i]
		if(info.path == resName) then
			table.remove(self._objectsCache,i)
			info.res:setVisible(true) 
			info.res:setOpacity(255)
			return info
		end
	end
	return nil
end
-- // 卸載緩存
function ObjManager:unloadCache() 
	
end
    
return ObjManager
