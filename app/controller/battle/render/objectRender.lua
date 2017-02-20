local ObjManager = require("app.manager.objManager")
local ResManager = require("app.manager.resManager")
local AudioManager = require("app.manager.audioManager")
local EffectManager = require("app.manager.effectManager")
local SpriteFrameManager = require("app.manager.spriteFrameManager")

local CharConfig = require("app.controller.battle.config.characterConfig")
local WorldConfig = require("app.controller.battle.config.worldConfig")
local Utils = require("app.controller.battle.core.battleUtils")
local Common = require("app.common.include")

local objRoot = nil
local CampIcon = {
    [1] = "circle_mian",
    [2] = "circle_blue",
    [3] = "circle_green",
    [4] = "circle_orange",
}

local CampColor = {
    [1] = cc.color(255, 255, 255),
    [2] = cc.color(1, 145, 242),
    [3] = cc.color(98, 202, 1),
    [4] = cc.color(255, 114, 43),
}

local rate = 1
local ext = 0.5
local tweenTime = 0.05

local centerPosX = 0
local centerPosY = 0
local static_count = 0
local objects = nil
local getNextId = function()
    static_count = static_count + 1
    return static_count;
end

local setCenterPos = function(x,y)
    centerPosX = x  or  0
    centerPosY = y  or  0
end

local inScreen = function(x,y,w,h)
    if(x == nil  or  y == nil)then
        return false
    end
    local screenSize = Common.utils.getVisibleSize()
    if(screenSize == nil)then
        -- print("what's up")
        return false
    end
    return  (x + w/2 > centerPosX - screenSize.width * ext) and (x - w/2 < centerPosX + screenSize.width * ext) 
        and (y + h/2 > centerPosY-screenSize.height * ext) and (y - h/2 < centerPosY + screenSize.height * ext)
    -- print(debug.traceback())
    -- print('xywh',x,y,w,h)
    -- print(r,'#',centerPosX,centerPosY,screenSize.width,screenSize.height)
    
    -- return r
end

local ObjectRender = {}

function ObjectRender.new()
    local obj = {}
    setmetatable(obj,{__index = ObjectRender})

    obj._id = getNextId()
    obj._typeId = nil

    obj._valid = nil
    obj._resPath = nil
    obj._avatar = nil

    obj._bloodBarSprite = nil
    obj._iconSprite = nil
    obj._textNode = nil

    obj._speedX = nil
    obj._speedY = nil
    obj._restTime = nil

    obj._visible = false
    obj._isLoading = false
    obj._removed = false
    obj._isFollowTarget = false
    obj._disableDynamic = false

    obj._config = nil

    obj._campNode = nil
    obj._campSprite = nil

    obj._camp = nil
    obj._name = nil

    obj._pos = nil
    obj._dir = nil

    obj._cacheFunc = nil

    obj._sizeX = 1
    obj._sizeY = 1
    obj._x = nil
    obj._y = nil

    return obj
end

function ObjectRender:addFunc( ... )
    if(self._cacheFunc == nil) then
        self._cacheFunc = {}
    end
    table.insert(self._cacheFunc,{...})
end

function ObjectRender:callCacheFunc(  )
    if(self._cacheFunc == nil) then
        return
    end
    for i,v in ipairs(self._cacheFunc) do
        pcall(unpack(v))
    end
end

function ObjectRender:init()
    self._valid = true
end  
function ObjectRender:uninit()
    if(self._avatar ~= nil) then
        self._avatar:setOpacity(255) 
        self._avatar:stopAllActions()
    end
    self:destroyAvatar()
end

function ObjectRender:setVisible(value)
    
    self._visible = value
    if(self._avatar == nil) then
        return
    end

    if(self._avatar.isVisible == value) then
        return
    end

    
    self._avatar:setVisible(value);
end

function ObjectRender:disableDynamic( ... )
    self._disableDynamic = true
end

function ObjectRender:setFollowTarget(flag) 
    self._isFollowTarget = flag
end

function ObjectRender:isFollowTarget() 
    return self._isFollowTarget  
end

function ObjectRender:destroyAvatar()
    
    if(self._isLoading) then
        self._removed = true
        return
    end

    if(self._avatar ~= nil) then
        objRoot:removeChild(self._avatar)
        ObjManager:getInstance():unload(self._avatar);
        self._avatar = nil
    end
end
function ObjectRender:setTypeId(typeId,objType)
    self._typeId = typeId
    self._config = Utils.getConfig(CharConfig,self._typeId)
end
function ObjectRender:setParent(parent) 
    if(self._avatar == nil) then
        self._parentNode = parent
        return
    end
    self._avatar:setParent(parent)
end

function ObjectRender:loadAvatar(resPath) 

    if(resPath == nil)then
        if(self._typeId == nil) then
            print("undifine error",self._id)
            return
        end

        if(self._config.res == nil)then
            print("resPath null",self._typeId)
            return
        end
        resPath = self._config.res
    end

    if(self._isLoading) then
        print("there is a loading task,new task cant get in.")
        return;
    end

    if(self._avatar ~= nil)then
        error("avatar exist!")
        return;
    end
    
    self._isLoading = true
    ObjManager:getInstance():load(resPath,function(err,res)

        local scene = cc.Director:getInstance():getRunningScene()
        
        if(objRoot == nil) then
            objRoot = scene:getChildByName("scene_root")
        end
        
        objRoot:addChild(res)

        self._avatar = res
        self._isLoading = false

        if(self._removed) then
            self:destroyAvatar()
            self._removed = false
            return
        end
        self:callCacheFunc()
    end);
    
    
end
function ObjectRender:update(dt)
    
    if(self._avatar == nil and not self._isLoading ) then
        if(self._resPath ~= nil) then
            self:loadAvatar(self._resPath)
        end
    end
    if(self._restTime ~= nil and self._restTime > 0)then
        self:stepPos(dt)
    end
   
end
function ObjectRender:updatePos(pos,dir,enableRot)           -- 为战斗使用，其他地方不要轻易使用

    local x = pos.x/rate
    local y = pos.y/rate

    self._x = x
    self._y = y

    if(self._isFollowTarget)then
        setCenterPos(x,y)
    end

    if(self._pos == nil) then
        self._pos = cc.p(x,y)
        self:setPos(x,y)
    else
        self._pos.x = x
        self._pos.y = y
        self:tweenPos(x,y,tweenTime)
    end

    if(not enableRot) then
        return
    end

    local s = cc.p(dir.x,dir.y)
    local t = cc.p(0,100)
    self:setRot(cc.pGetAngle(s,t)* 180/3.14)
end
function ObjectRender:tweenPos(x,y,duration)
    if(self._avatar == nil) then
        return
    end
    local px,py = self._avatar:getPosition()
    self._restTime = duration
    self._speedX = (x - px) / duration
    self._speedY = (y - py) / duration
end
function ObjectRender:stepPos(dt)
    if(self._avatar == nil)then
        return
    end
    
    dt = dt  or  0
    local px,py = self._avatar:getPosition ()
    self._restTime = self._restTime - dt
    if(self._restTime <=0 )then
        self:setPos(self._x,self._y)
        self._restTime = nil
        return
    end
   
    self:setPos(px + self._speedX * dt,py + self._speedY * dt)
end
function ObjectRender:setPos (x,y)               -- 通用的设置坐标接口

    if(self._avatar == nil)then
        self:addFunc(self.setPos,self,x,y)
        return
    end
    
    self._avatar:setPosition(x,y)
end

function ObjectRender:setRot(angle) 
    
    if(self._avatar == nil) then
        self:addFunc(self.setRot,self,angle)
        return
    end

    self._avatar:setRotation(angle)
end
function ObjectRender:getPos() 
    return self._x,self._y
end
function ObjectRender:getRoot() 
    return self._avatar  
end
function ObjectRender:setScale(x,y) 
    
    if(self._avatar == nil)then
        self:addFunc(self.setScale,self,x,y)
        return
    end
   
    self._avatar:setScale(x,y)
end
function ObjectRender:setSize(x,y) 
    self._sizeX = x
    self._sizeY = y

    if(self._avatar == nil) then
        self:addFunc(self.setSize,self,x,y)
        return
    end
    local contentSize = self._avatar.contentSize
    self:setScale(x/contentSize.width,y/contentSize.height)    
end

function ObjectRender:setIcon(icon) 
    if(icon == nil) then
        return
    end
    if(self._avatar == nil) then
        self:addFunc(self.setIcon,self,icon)
        return
    end

    if(self._iconSprite == nil) then
        local node  = self._avatar:getChildByName("icon")
        if(node ~= nil) then
            self._iconSprite = node:getComponent("cc.Sprite")
        end
    end
   
    if(self._iconSprite == nil)then
        return
    end
    
    local sp = SpriteFrameManager:getInstance():getSpriteFrame(icon)
    if(sp == nil) then
        print("no sprite",icon)
        return
    end
    self._iconSprite.node:setSpriteFrame(sp) 
end

function ObjectRender:setText(name)

    if(self._avatar == nil)then
        self:addFunc(self.setText,self,name)
        return
    end

    if(self._textNode == nil)then
        local node = self._avatar:getChildByName("txt");
        if(node ~= nil)then
            self._textNode = node:getComponent("cc.Label") 
        end
    end
    if(self._textNode ~= nil)then
        self._textNode.node:setString(name or '')
    end
end

local sprefs = {
    [0] = "circle_mian",
    [1] = "circle_blue",
    [2] = "circle_green",
    [3] = "circle_orange",   
}
function ObjectRender:setCamp(camp)  
    if(self._avatar == nil) then
        self:addFunc(self.setCamp,self,camp)
        return;
    end

    if(self._campNode == nil)then
        self:initCampNode()
    end

    if(self._campSprite ~= nil)then
        local icon = sprefs[camp]
        local sp = SpriteFrameManager:getInstance():getSpriteFrame(icon)
        if(sp == nil) then
            print("no sprite",icon)
            return
        end
        self._campSprite.node:setSpriteFrame(sp)
    end
end

function ObjectRender:initCampNode()
    if(self._campNode ~= nil) then
        return
    end
    self._campNode = self._avatar:getChildByName("camp")
    if(self._campNode == nil) then
        return
    end
    self._campSprite = self._campNode:getComponent("cc.Sprite")
end


function ObjectRender:getId()
    return self._id
end

-- 淡入接口 duration:时长
function ObjectRender:fadeIn(duration) 
    -- local action1 = cc.fadeOut(0);
    -- local action2 = cc.fadeIn(duration)
    -- local fadeIn = cc.sequence(action1,action2)
    -- self._avatar:runAction(fadeIn)
end

-- 淡出 duration :时长
function ObjectRender:fadeOut(duration) 
    -- if(self._avatar == nil) then
    --     return
    -- end
    -- self._avatar:stopAllActions();
    -- local fadeOut = cc.fadeOut(duration  or  0.1);
    -- self._avatar:runAction(fadeOut)
    self._valid = false
end
-- 闪烁，interval：闪烁周期
function ObjectRender:startBlink() 

    -- local interval = 0.25
    -- if(self._avatar == nil) then
    --     self._blinkInterval = interval
    --     return
    -- end
    
    -- self._blink = cc.repeatForever(cc.sequence(cc.fadeIn(interval), cc.fadeOut(interval)));
    -- self._avatar:runAction(self._blink)
    
end
-- 停止闪烁
function ObjectRender:stopBlink() 

    -- if(self._avatar == nil) then
    --     self._blinkInterval = -1
    --     return
    -- end

    -- if(self._blink ~= nil and self._blink.getOriginalTarget ()~= nil) then
    --     self._avatar:stopAction(self._blink)
    -- end
        
    -- self._blink = nil
    -- self._avatar:setOpacity(255);
end
function ObjectRender:setHpPercent(percent) 

    if(self._avatar  == nil) then
        self:addFunc(self.setHpPercent,self,percent)
        return
    end

    if(self._bloodBarSprite == nil) then
        self:initBloodNode();
    end

    if(self._bloodBarSprite == nil) then
        return
    end

    -- local size = self._bloodBarSprite.node:getContentSize()
    self._bloodBarSprite.node:setContentSize({width=100*percent,height=15})
end


function ObjectRender:initBloodNode()
    if(self._bloodBarSprite ~= nil)then
        return
    end
    local node = self._avatar:getChildByName("bloodBar");
    if(node == nil) then
        return
    end

    local bar = node:getChildByName("bar")
    if(bar ~= nil) then
        self._bloodBarSprite = bar:getComponent("cc.Sprite") 
    end
end


-- 设置血条
function ObjectRender:setHp(cur,max,tween) 
    
    local percent = math.min(cur/max,1)

    self:setHpPercent(percent)

end

function ObjectRender:playAudio(path) 
    AudioManager:getInstance():playEffect(path)  
end

function ObjectRender:playEffect(effectPath,pos,duration) 
    if(self._avatar == nil)then
        return
    end
    
    local p = cc.p(pos.x/rate,pos.y/rate)
    EffectManager:getInstance():playEffect(effectPath,p,duration)
end
function ObjectRender:playEffectByName(effectName,pos,duration) 
    local effectPath = Common.assetPathTable[effectName]
    self:playEffect(effectPath,pos,duration)
end

return ObjectRender