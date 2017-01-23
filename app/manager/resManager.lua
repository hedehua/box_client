-- // 资源管理器，所有的prefab,音频，图片等都通过该类申请

local ResManager = cc.class("ResManager")
function ResManager:ctor(  )
	-- body
	self._cache = nil;
	self._task = nil;
	self._taskSeq = 0;

	self._dirty = nil;
	self._loading = nil;
	self._nextTime = 0;
end

local _instance = nil
function ResManager:getInstance(  )
	if(_instance ~= nil) then
		return _instance
	end
	_instance = ResManager.new()
	return _instance
end

function ResManager:init()
	
end
function ResManager:reset()
	cc.loader.releaseAll()
end
function ResManager:uninit()
	self:reset()
end
function ResManager:update() 
    if(not self._dirty) then
        return
    end
	if(self._nextTime > 0) then
		--self._nextTime
		return
	end
	if(self._loading) then
		return
	end
    if(self._tasks == nil) then
        return
    end
    local item = self._tasks[1]
    if(item == nil) then
        return
    end
    table.remove(self,_tasks,1)
    
	self:loadImm(item.resName,item.callback)
   	if(#self._tasks == 0) then
        self._dirty = false
    end
end
function ResManager:hasRunningTask() 
  return self._tasks ~= nil and table.length(self._tasks) > 0  
end
function ResManager:addTask(resName,callback) 
    if(self._tasks == nil) then
        self._tasks = {}
    end
    self._taskSeq = self._taskSeq + 1
    local item = {id = self._taskSeq,resName=resName,callback=callback}
    table.insert(self._tasks,item)
    self._dirty = true
    return item.id
end

function ResManager:load(resName,callback) 

	if(resName == nil) then
		return
	end

	local asset = self:getFromCache(resName)

	if(asset ~= nil) then
		callback(nil,asset)
		return nil
	end
	return self:addTask(resName,callback)
end

function ResManager:loadImm(resName,callback)
	callback(nil,Assets:getFile(resName))
end

function ResManager:addToCache(resName,res)
	if(self._cache == nil) then
		self._cache = {}
	end
	self._cache[resName] = res
end
function ResManager:getFromCache(resName)
	if(self._cache == nil) then
		return
	end
	return self._cache[resName]
end
-- // 通用卸载接口
function ResManager:unload(obj) 
	cc.loader.releaseAsset(obj)
end
function ResManager:isLoading()
	return self._loading
end

return ResManager