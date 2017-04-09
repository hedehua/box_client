
local ComponentBase = cc.import(".ComponentBase")
local ButtonComponent = cc.class("cc.Button", ComponentBase)

local _STATE_DISABLED = "DISABLED"
local _STATE_IDLE     = "IDLE"
local _STATE_PRESSED  = "PRESSED"

local _SPRITES_MAP = {
    [_STATE_DISABLED] = "_N$disabledSprite",
    [_STATE_IDLE]     = "_N$normalSprite",
    [_STATE_PRESSED]  = "pressedSprite",
}

local _SCALE_ZOOM = "zoomScale"
local _SCALE_DURATION = "duration"

local _getRect, _inRect
local _onTouchBegan, _onTouchMoved, _onTouchEnded, _onTouchCancelled
local _updateSprite

function ButtonComponent:ctor(asset, assets)
    ButtonComponent.super.ctor(self)
    self.transition = asset["transition"]
    self._colors = {}
    self._spriteFrames = {}
    self._scale = {}

    if self.transition == 1 then
        -- colors
        self._colors[_STATE_DISABLED] = asset["_N$disabledColor"]
        self._colors[_STATE_IDLE]     = asset["_N$normalColor"]
        self._colors[_STATE_PRESSED]  = asset["pressedColor"]
    elseif self.transition == 2 then
        -- sprites
        for k1, k2 in pairs(_SPRITES_MAP) do
            if asset[k2] and asset[k2]["__uuid__"] then
                local uuid = asset[k2]["__uuid__"]
                local spriteFrame = assets:_createObject(assets:getAsset(uuid))
                spriteFrame:retain()
                self._spriteFrames[k1] = spriteFrame
            end
        end
    elseif self.transition == 3 then
        self._scale.zoom = asset[_SCALE_ZOOM]
        self._scale.duration = asset[_SCALE_DURATION]
    end

    self.state = _STATE_IDLE
end

function ButtonComponent:setEnabled(enabled)
    if enabled then
        if self.state == _STATE_DISABLED then
            self.state = _STATE_IDLE
            _updateSprite(self)
        end
    else
        if self.state ~= _STATE_DISABLED then
            self.state = _STATE_DISABLED
            _onTouchCancelled(self)
            _updateSprite(self)
        end
    end
end

function ButtonComponent:onLoad(target)
    local sprite = target:getComponent("cc.Sprite")
    local name = target.name or ""
    if name ~= "" then
        name = "'" .. name .. "': "
    end
    if not sprite then
        cc.printwarn("[Asset]   - [Button] not found sprite in target %s%s[%s]", name, target.__type, target.__id)
        return
    end
    cc.printdebug("[Asset]   - [Button] set listener for %s%s[%s]", name, target.__type, target.__id)

    local listener = cc.EventListenerTouchOneByOne:create()
    self._listner = listener
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function(touch, event)
        if(_onTouchBegan(self, touch)) then
            self:dispatcherTouchEvent(cc.Handler.EVENT_TOUCH_BEGAN)
            return true
        end
        return false
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function(touch, event)
        if(_onTouchMoved(self, touch))then
            self:dispatcherTouchEvent(cc.Handler.EVENT_TOUCH_MOVED)
            return true
        end
        return false
    end, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(function(touch, event)
        if(_onTouchEnded(self, touch)) then
            self:dispatcherTouchEvent(cc.Handler.EVENT_TOUCH_ENDED)
            return true
        end
        return false
    end, cc.Handler.EVENT_TOUCH_ENDED)
    listener:registerScriptHandler(function(touch, event)
        if(_onTouchCancelled(self, touch)) then
            self:dispatcherTouchEvent(cc.Handler.EVENT_TOUCH_CANCELLED)
            return true
        end
        return false
    end, cc.Handler.EVENT_TOUCH_CANCELLED)

    local eventDispatcher = sprite.node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, sprite.node)

    self._sprite = sprite
end

function ButtonComponent:on( eventType,func )
    if(eventType == nil or func == nil) then
        print('eventType of func nil',eventType)
        return
    end
    self._touchEvents = self._touchEvents or {}
    local events = self._touchEvents[eventType]
    if(events == nil) then
        events = {}
        self._touchEvents[eventType] = events
    end
    table.insert(events,func)
end

function ButtonComponent:off( eventType,func )
    if(eventType == nil or func == nil) then
        return
    end
    if(self._touchEvents == nil) then
        return
    end
    local events = self._touchEvents[eventType]
    if(events == nil) then
        return
    end

    if(func == nil) then
        self._touchEvents[eventType] = nil
        return
    end

    for i =#events,1,-1 do
        if(events[i] == func) then
            table.remove(events,i)
            break;
        end
    end
end

function ButtonComponent:dispatcherTouchEvent( eventType )

    if(eventType == nil) then
        print("eventType nil")
        return
    end

    if(self._touchEvents == nil) then
        return
    end

    local events = self._touchEvents[eventType]
    if(events == nil) then
        return
    end
    for i = 1,#events do
        local e = events[i]
        if(e ~= nil) then
            e()
        end
    end
end

function ButtonComponent:onDestroy(target)
    for _, spriteFrame in pairs(self._spriteFrames) do
        spriteFrame:release()
    end

    self._sprite = nil
end

-- private

_getRect = function(node)
    local rect = node:getBoundingBox()
    local wp = node:convertToWorldSpaceAR({x = rect.x, y = rect.y})
    rect.x = wp.x
    rect.y = wp.y
    return rect
end

_inRect = function(rect, p)
    return p.x >= rect.x
        and p.x < rect.x + rect.width
        and p.y >= rect.y
        and p.y < rect.y + rect.height
end

_onTouchBegan = function(self, touch)

    if self.state ~= _STATE_IDLE then return false end
    local p = touch:getLocation()
    local rect = _getRect(self._sprite.node)
    if not _inRect(rect, p) then return false end

    self.state = _STATE_PRESSED
    _updateSprite(self)
    
    return true
end

_onTouchMoved = function(self, touch)

    if self.state ~= _STATE_IDLE and self.state ~= _STATE_PRESSED then
        return false
    end

    local p = touch:getLocation()
    local rect = _getRect(self._sprite.node)
    local lastState = self.state
    if _inRect(rect, p) then
        self.state = _STATE_PRESSED
    else
        self.state = _STATE_IDLE
    end
    if lastState ~= self.state then
        _updateSprite(self)
    end

    return true
end


_onTouchEnded = function(self,touch)
    local lastState = self.state
    if self.state == _STATE_PRESSED then
        self.state = _STATE_IDLE
    end
    if lastState ~= self.state then
        _updateSprite(self)
    end
    return true
end

_onTouchCancelled = function(self,touch)
    local lastState = self.state
    if self.state == _STATE_PRESSED then
        self.state = _STATE_IDLE
    end
    if lastState ~= self.state then
        _updateSprite(self)
    end

    return true
end

_updateSprite = function(self)
    local sprite = self._sprite
    if self.transition == 1 then
        -- colors
        local color = self._colors[self.state]
        if not color then return end
        sprite.node:setColor(color)
    elseif self.transition == 2 then
        -- sprites
        local spriteFrame = self._spriteFrames[self.state]
        if not spriteFrame then return end
        if sprite.capInsets then
            sprite.node:setSpriteFrame(spriteFrame, sprite.capInsets)
            sprite.node:setContentSize(sprite.contentSize)
        else
            sprite.node:setSpriteFrame(spriteFrame)
        end
    elseif self.transition == 3 then
        local transition = require "cocos.framework.transition"
        local actionTo1 = transition.scaleTo(sprite.node,{scaleX = self._scale.zoom, scaleY = self._scale.zoom,time = self._scale.duration});
        local actionTo2 = transition.scaleTo(sprite.node,{scaleX = 1, scaleY = 1,time = 0.1});
        local seq = transition.sequence({actionTo1,actionTo2});
        sprite.node:runAction(seq)
        
    end
end

return ButtonComponent
