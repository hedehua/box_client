-- // 界面管理的基类
local ObjManager = require("app.manager.objManager")
local Common = require("app.common.include")
local transition = require "cocos.framework.transition"

local uiRoot = nil
local UIBase = cc.class("UIBase")

function UIBase:ctor(  )
	-- body
	self._name =  nil
	self._resPath =  nil
	self._active =  false         -- 适配异步加载逻辑
	self._resObject =  nil
	self._queier =  nil

end


function UIBase:init()
	-- // 初始化
end
function UIBase:reset()
	
end
function UIBase:uninit()
	self:close()
	self:unload()
end

function UIBase:setResPath( path )
	self._resPath = path
end

function UIBase:setQueier(q)
	self._queier = q
end
function UIBase:request(eventType,arg1,arg2,arg3)
	
	if(self._queier == nil) then
		return nil;
	end

	if(not self._active) then
		return
	end

	local r = self._queier[eventType]
	if(r ~= nil)then
		return r(arg1,arg2,arg3);
	end
	return nil;
end
function UIBase:notify(eventType,arg1,arg2,arg3)
	
	if(self._queier == nil)then
		return nil;
	end
	
	if(not self._active) then
		return
	end

	local r = self._queier[eventType]
	if(r ~= nil) then
		r(arg1,arg2,arg3);
	end
end

function UIBase:isTweenShow() 
	return false
end

function UIBase:open()

	self._active = true;
	if(self._resObject == nil) then
		self:load()
		return;
	end
	self._resObject:setVisible(self._active);
	self:fresh();

	if(self:isTweenShow()) then
		local actionTo1 = cc.ScaleTo:create(0.05, 1.02) 
		local actionTo2 = cc.ScaleTo:create(0.05, 0.98) 
		local actionTo3 = cc.ScaleTo:create(0.1, 1)
		local seq = transition.sequence({actionTo1,actionTo2,actionTo3});
		self._resObject:runAction(seq)
	end
end
function UIBase:close()

	self._active = false
	if(self._resObject == nil) then
		return
	end

	if(self:isTweenShow()) then
		local actionTo1 = cc.ScaleTo:create(0.05, 1.05) 
		local actionTo2 = cc.ScaleTo:create(0.05, 0.9) 
		local actionTo3 = cc.FadeOut:create(0.1)
		local seq = transition.sequence({actionTo1,actionTo2,actionTo3});
		self._resObject:runAction(seq)
		return
	end

	self._resObject:setVisible(self._active);
end
function UIBase:fresh()
	if(not self._active) then
		return
	end
end

function UIBase:load()
	-- // 加载资源
	local cb = function(err,res) 
		self:_loaded(err,res);
	end

	ObjManager:getInstance():load(self._resPath,cb);
end

function UIBase:unload() 
	self._queier = nil

	if(self._resObject == nil) then
		return
	end

	if(uiRoot ~= nil) then
		uiRoot:removeChild(self._resObject)
	end
	ObjManager:getInstance():unload(self._resObject)
	self._resObject = nil

end

function UIBase:_loaded(err,res)

	if(res == nil) then
		print("error:load res nil",err,res);
		return;
	end

	if(uiRoot == nil) then
        local scene = cc.Director:getInstance():getRunningScene()
        uiRoot = scene:getChildByName("ui_root")  
    end
    
    uiRoot:addChild(res)
    res:setPosition({x=0,y=0,z=0})
    

	self._resObject = res
	self:loaded(res);

	if(self._active) then
		self:open();
	else
		self:close();
	end
	self:notify("onLoaded",self.name)
end

-- // 回调函数中不能使用函数重载，父类无法获取到参数，所以用这个函数过渡一下
-- // 这个问题是因为基于CCClass才引发的
function UIBase:loaded(res)
	-- //virtual
end


return UIBase