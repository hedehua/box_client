local SpriteFrameManager = cc.class("SpriteFrameManager")

local _instance = nil

function SpriteFrameManager:getInstance( ... )
	if(_instance ~= nil) then
		return _instance
	end
	_instance = SpriteFrameManager.new()
	return _instance
end

function SpriteFrameManager:init( ... )
	-- body
end

function SpriteFrameManager:ctor(  )
	self._spriteDic = nil
end

function SpriteFrameManager:getSpriteFrame( name )
	if(name == nil) then
		return nil
	end
	if(self._spriteDic == nil) then
		self._spriteDic = {}
		local scene = cc.Director:getInstance():getRunningScene() 
	    local objRoot = scene:getChildByName("sf_cache")
	    local children = objRoot:getChildren()
	    for i,v in ipairs(children) do
	    	local sp = v:getComponent("cc.Sprite")
	    	self._spriteDic[v:getName()] = sp.node:getSpriteFrame()
	    end
	    
	end
	return self._spriteDic[name]
end

return SpriteFrameManager
