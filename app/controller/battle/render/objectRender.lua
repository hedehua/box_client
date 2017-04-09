local ObjManager = require("app.manager.objManager")
local ResManager = require("app.manager.resManager")
local EffectManager = require("app.manager.effectManager")
local SpriteFrameManager = require("app.manager.spriteFrameManager")

local CharConfig = require("app.controller.battle.config.characterConfig")
local WorldConfig = require("app.controller.battle.config.worldConfig")
local Utils = require("app.controller.battle.core.battleUtils")
local Common = require("app.common.include")
local transition = require "cocos.framework.transition"


local objRoot = nil

local CampColor = {
    [0] = cc.color(255, 255, 255),
    [1] = cc.color(1, 145, 242),
    [2] = cc.color(135, 219, 21),
    [3] = cc.color(255, 114, 43),
}

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
        return false
    end
    return  (x + w/2 > centerPosX - screenSize.width * ext) and (x - w/2 < centerPosX + screenSize.width * ext) 
        and (y + h/2 > centerPosY-screenSize.height * ext) and (y - h/2 < centerPosY + screenSize.height * ext)
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
    obj._scaleX = 1
    obj._scaleY  = 1

    obj._motion = nil
    obj._queier = nil

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
    self._valid = false

end


function ObjectRender:addMotion(  )
    if(self._avatar == nil) then
        self:addFunc(self.addMotion,self)
        return
    end

end

function ObjectRender:setQueier(q)
    self._queier = q
end

function ObjectRender:request(eventType,arg1,arg2,arg3)
    if(self._queier == nil) then
        return nil;
    end
    local r = self._queier[eventType]
    if(r ~= nil) then
        return r(arg1,arg2,arg3);
    end
    return nil;
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

function ObjectRender:setFollowTarget() 
    self._isFollowTarget = true
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
    if(objRoot == nil) then
        local scene = cc.Director:getInstance():getRunningScene()
        objRoot = scene:getChildByName("scene_root")
    end
    ObjManager:getInstance():load(resPath,function(err,res)

        self._avatar = res
        self._isLoading = false

        if(self._removed) then
            self:destroyAvatar()
            self._removed = false
            return
        end
        self:callCacheFunc()
  
    end,objRoot);
    
    
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

    self._x = pos.x
    self._y = pos.y

    if(self._isFollowTarget)then
        setCenterPos(self._x ,self._y)
    end

    if(self._pos == nil) then
        self._pos = cc.p(self._x,self._y)
        self:setPos(self._x,self._y)
    else
        self._pos.x = self._x
        self._pos.y = self._y
        self:tweenPos(self._x,self._y,1 / WorldConfig.battleInterval)
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
    self:stepPos(cc.detaTime)
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

    if(self._motion ~= nil) then
        self._motion:setPosition(cc.p(x,y))
    end
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
    self._scaleX = x
    self._scaleY = y

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
        print('icon nil')
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
        print("no sprite")
        return
    end
    
    local sp = SpriteFrameManager:getInstance():getSpriteFrame(icon)
    if(sp == nil) then
        print("no sprite",icon) -- TODO::
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
    [0] = "empty",
    [1] = "blue",
    [2] = "green",
    [3] = "orange",   
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

    if(self._bloodBarSprite == nil) then
        self:initBloodNode();
    end

    if(self._bloodBarSprite ~= nil)then
        self._bloodBarSprite.node:setColor(CampColor[camp])
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
    if(self._avatar == nil) then
        self:addFunc(self.fadeIn,self,duration)
        return
    end
    self._avatar:stopAllActions();
    duration = duration or 0.1
    transition.fadeIn(self._avatar,{time = duration})

end

-- 淡出 duration :时长
function ObjectRender:fadeOut(duration) 
    if(self._avatar == nil) then
        return
    end
    if(not self._valid) then
        return
    end
    duration = duration or 0.1
    self._avatar:stopAllActions();
    
    transition.fadeOut(self._avatar,{time = duration});
    self._valid = false
end

-- 闪烁，interval：闪烁周期
function ObjectRender:startBlink() 

end
-- 停止闪烁
function ObjectRender:stopBlink() 

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
    self._bloodBarSprite.node:setContentSize({width=80*percent,height=10})
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

function ObjectRender:playBoomEffect( pos,duration )
    self:playEffect(Common.assetPathTable.hit,pos,duration)
end

function ObjectRender:playMissileAudio(  )
    self:playAudio(Common.assetPathTable.missile)
end

function ObjectRender:playBoomAudio() 
    self:playAudio(Common.assetPathTable.boom)
end

function ObjectRender:playPickAudio(dropType)

    if(dropType == 1) then 
        self:playAudio(Common.assetPathTable.pick)
        return
    end
    if(dropType == 2) then
        self:playAudio(Common.assetPathTable.coin)
        return
    end
end

function ObjectRender:playAudio(path) 

    if(path == nil or path == '') then
        return
    end
    local AudioManager = require "app.manager.audioManager"
    AudioManager:getInstance():playEffect(path)
end

function ObjectRender:playEffect(effectPath,pos,duration) 
    if(self._avatar == nil)then
        return
    end
    
    local p = cc.p(pos.x,pos.y)
    EffectManager:getInstance():playEffect(effectPath,p,duration)
end

function ObjectRender:tweenShow( dropType  )
    if(self._avatar == nil) then
        self:addFunc(self.tweenShow,self,dropType)
        return
    end
    if(dropType == 1) then
        local action1 = cc.ScaleTo:create(0.1, 1.2)
        local action2 = cc.ScaleTo:create(0.05, self._scaleX)
        local seq = cc.Sequence:create({action1,action2})
        self._avatar:runAction(seq)
        return
    end
    if(dropType == 2) then
        local seq = cc.FadeIn:create(0.1)
        self._avatar:runAction(seq)
        return
    end
    print('unkown',dropType)
end

function ObjectRender:flyEffect(pos,dropType )

    if(dropType ~= 2) then
        return
    end

    if(self._avatar == nil) then
        return
    end

    local TimerManager = require "app.manager.timerManager"
    local AudioManager = require "app.manager.audioManager"
    
    TimerManager:getInstance():start(function(  )
        local cx,cy = self:request("getCenter")
        local effectPath = Common.assetPathTable.reward
        local pos1 = cc.p(pos.x,pos.y)
        local pos2 = cc.p(700-cx,700-cy) 
        EffectManager:getInstance():flyEffect(effectPath,pos1,pos2)
    end, 0.2, 3, nil) 
    
    TimerManager:getInstance():runOnce(function( )
        AudioManager:getInstance():playEffect(Common.assetPathTable.eatCoin)
    end,1)
end

return ObjectRender