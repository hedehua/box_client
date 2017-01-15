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
   
function ObjManager:init()
end

function ObjManager:reset()
	
end

function ObjManager:uninit()
	self:reset()
end
function ObjManager:update()
    if(self._dirty ~= nil) then
        return
    end
    if(self._tasks == nil) then
        return
    end
    
    -- local item = self._tasks.shift();
    -- if(item == nil) then
    --     return
    -- end
    -- item.cb(cc.instantiate(item.asset))
    -- if(table.length(self._tasks) == 0) then
    --     self._dirty = false
    -- end
end
function ObjManager:hasTask() 
	return self._tasks ~= nil and table.length(self._tasks) > 0  
end
function ObjManager:addTask(asset,cb) 
    if(self._tasks == nil)then
        self._tasks = {}
    end
    self._taskSeq = self._taskSeq + 1
    local item = {id = self._taskSeq,asset = asset,cb = cb}
    table.insert(self._tasks,item)
    self._dirty = true
    return item.id
end
function ObjManager:instantiate(asset,cb) 
    if(asset == nil or cb == nil)then
        cc.error("instantiate arguments error")
        return nil
    end
    return self:addTask(asset,cb)
end
function ObjManager:destroyObject(id) 
    if(id == nil or id < 0) then
        return
    end
    if(self._tasks == nil) then
        return
    end
    for i = table.length(self._tasks),1 do
        local item = self._tasks[i]
        if(item.id == id) then
            table.remove(self._tasks,i)
            break;
        end
    end
end
function ObjManager:load(resName,callback) 				
	-- print('ObjManager load',resName)
	local info = self:getFromCache(resName)

	if(info ~= nil) then
		self:addTo(info.path,info.res)
		if(callback ~= nil)then
			callback(nil,info.res);
		end
		return
	end

	local creator = require "creator.init"
    local assets = creator.getAssets()
    local asset = assets:createPrefab(resName)

    if(self._objRoot == nil) then
        local scene = cc.Director:getInstance():getRunningScene()
        self._objRoot = scene:getChildByName("scene_root")
    end

    self._objRoot:addChild(asset)
    self:addTo(resName,asset)
	if(callback ~= nil) then
		callback(err,asset);
	end

end

function ObjManager:unload(obj) 
	if(obj == nil) then
		return false;
	end
	for i = #self._objectsArr,1,-1 do
		local info = self._objectsArr[i]
		if(info ~= nil and info.res == obj) then
			table.remove(self._objectsArr,i)
			self:addToCache(info)
			return true
		end
	end

	cc.log("unload error")
	return false		
end

function ObjManager:addTo(resName,obj) 
	if(obj == nil) then
		return
	end
	obj.parent = self._objRoot

	table.insert(self._objectsArr,{res = obj,path = resName})
end

function ObjManager:addToCache(info)
	if(info == nil) then
		cc.log("add to cache failure")
		return
	end
	if(self._objectsCache == nil) then
		self._objectsCache = {}
	end
	
	info.res:setVisible(false)  
	table.insert(self._objectsCache,info)
end
function ObjManager:getFromCache(resName)
	if(resName == nil) then
		cc.log("argument nil")
		return nil
	end
	if(self._objectsCache == nil) then
		return nil
	end

	for i = table.length(self._objectsCache),1,-1 do
		local info = self._objectsCache[i]
		if(info.path == resName) then
			table.remove(self._objectsCache,i)
			info.res:setVisible(true) 
			return info
		end
	end
	return nil
end
-- // 卸載緩存
function ObjManager:unloadCache() 
	
end
    
return ObjManager
