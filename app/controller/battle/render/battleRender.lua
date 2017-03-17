local BattleObject = require("app.controller.battle.core.battleObject")
local ObjectRender = require("app.controller.battle.render.objectRender")
local Common = require("app.common.include")

local BattleRender = cc.class("BattleRender")

function BattleRender:onCreate( ... )
    self._queier = nil
    self._objects = nil
    self._rootNode = nil
    self._followObj = nil
end


function BattleRender:init (params) 
    self._objects = {}

    BattleObject.setRenderFactory(
        function(obj)
            return self:addRender(obj)
        end,
        function(obj)
            self:removeRender(obj)
        end
    )

    self:initRoot()
end

function BattleRender:uninit(params) 

    self:uninitRoot()

    if(self._objects ~= nil) then
        for i = 1,#self._objects do
            local obj = self._objects[i]
            if(obj ~= nil) then
                obj:uninit()
            end
        end
        self._objects = nil
    end
end
function BattleRender:update(dt) 
    for i = 1,#self._objects do
        local obj = self._objects[i]
        if(self._followObj == nil and obj:isFollowTarget() and obj:getRoot() ~= nil) then
            self._followObj = obj
        end
        obj:update(dt)
    end
    
   self:asyncPos()
end
-- -1024 1024
-- -1024+screen.width/2
function BattleRender:asyncPos()
    if(self._followObj ~= nil ) then
        local x,y = self._followObj:getRoot():getPosition()
        local screen = Common.utils.getVisibleSize()
        local width,height = self:request("getSize")
        if(width ~= nil) then
            x = math.max(-width/2 + screen.width/2,x)
            x = math.min(width/2 - screen.width/2,x)
        end
        self._rootNode:setPositionX(-x + screen.width/2)
        -- self._rootNode:setPosition(-x + screen.width/2,-y + screen.height/2)
    end
end

function BattleRender:setQueier(q)
	self._queier = q
end
function BattleRender:request(eventType,arg1,arg2,arg3)
	if(self._queier == nil) then
		return nil;
	end
	local r = self._queier[eventType]
	if(r ~= nil) then
		return r(arg1,arg2,arg3);
	end
	return nil;
end
function BattleRender:notify(eventType,arg1,arg2,arg3)
	if(self._queier == nil) then
		return nil;
	end
	local r = self._queier[eventType]
	if(r ~= nil) then
		r(arg1,arg2,arg3);
	end
end

function BattleRender:initRoot() 
  if(self._rootNode ~= nil) then
      return;
  end
  local scene = cc.Director:getInstance():getRunningScene()
  self._rootNode = scene:getChildByName("scene_root")         
  local screen = Common.utils.getVisibleSize()
  self._rootNode:setPosition(screen.width/2,screen.height/2)
end

function BattleRender:uninitRoot() 
    if(self._rootNode == nil) then
        return;
    end
    self._rootNode = nil
end
function BattleRender:setEventListner(events)
    self._events = events
end
function BattleRender:addRender(obj) 

    local render = ObjectRender.new();
    render:init();
    render:setParent(self._rootNode)

    if(self._objects == nil) then
        self._objects = {}
    end
    table.insert(self._objects,render);
    return render
end
function BattleRender:removeRender (obj)
    if(obj == nil) then
        print("rm render err,obj == nil.")
        return;
    end
    if(self._objects == nil) then
        return;
    end

    for i = #self._objects,1,-1 do
        local o = self._objects[i]
        if(obj == o) then

            if(obj == self._followObj) then
                self._followObj = nil
            end

            table.remove(self._objects,i)
            obj:uninit();
        end
    end
end


return BattleRender