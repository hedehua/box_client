local MissileConfig = require("app.controller.battle.config.missileConfig")
local BattleObject = require("app.controller.battle.core.battleObject")
local Utils = require("app.controller.battle.core.battleUtils")
local Vector2 = require("app.controller.battle.core.vector2")
local Enum = require("app.controller.battle.core.battleEnum")

local Missile = {}
Missile.super = BattleObject
Missile.__cname = "Missile"
setmetatable(Missile,{__index = BattleObject})

function Missile.new()
    local obj = BattleObject.new()
    setmetatable(obj,{__index = Missile})

    obj._typeId = 0  			-- 配置表id
    obj._framecount = 0
    obj._timeOut = -1
    obj._camp = nil
    obj._needRemove　= false
    obj._casted = false
    obj._config = nil

    obj._targetObj = nil       -- 跟随目标（可为空)

    obj._targetId = -1         -- 目标Id （可为空）
    obj._casterId = -1         -- 施法Id （不可为空）
    obj._parentId = -1         -- 父Id   (子弹触发子弹的情况使用)

    obj._hitObjs = nil
    obj._hitCount = 0

    return obj
end
-- static
function Missile.needTarget(typeId) 
    local config = Utils.getConfig(MissileConfig,typeId)
    if(config == nil) then
        print('not init config missile',typeId)
        return false
    end
    if(config.moveType == 1) then
        return false
    end
   
    return true
end 
-- end

function Missile:init(typeId,camp,casterId) 
  
    Missile.super.init(self,typeId,camp,casterId)

    self._typeId = typeId
    self._camp = camp
    self._casterId = casterId
    self._config = Utils.getConfig(MissileConfig,self._typeId)
    self._timeOut = self._config.timeOut
    self:setSpeed(self._config.speed)
    self._enableRot = self._config.dir >=0 
    
    if(self._render ~= nil) then
        self._render:setTypeId(self._typeId);
        self._render:setSize(self._config.radius * 2,self._config.radius * 2)
        self._render:playAudio(self._config.audio)
        self._render:setCamp(self._camp)
    end
    self:loadAvatar(self._config.res)

    -- cc.error(self._id, 'missile',typeId,'xxxxxxxxxxxxxxxxxxxxxxxxx')

end
function Missile:setTargetId(targetId) 
    self._targetId =  targetId
end
function Missile:setParentId(parentId) 
    self._parentId = parentId  
end
function Missile:uninit() 
    self._targetObj = nil
    Missile.super.uninit(self)
end
function Missile:update() 

    self:tryCastSubmissile();
    self._framecount = self._framecount + 1;
    
    if(self._timeOut ~=-1 and self._framecount >= self._timeOut) then   -- timeOut 表示不是时间限制
        if(self._render ~= nil) then
            self._render:fadeOut()
        end
        self._needRemove = true
        return
    end

    -- 跟随
    if(self._targetObj ~=nil and  self._targetObj:isValid())then
        self:moveTo(self._targetObj:getPos(),true)
    end

    Missile.super.update(self)
end
function Missile:tryCastSubmissile() 
    if(self._config.subMissile ~= nil and  self._config.subMissile > 0)then
        if(self._config.missileDelayTime == self._framecount)then
            self:notify("castMissile",self._config.subMissile,self._id)
            return true
        end
    end
    return false
end
function Missile:tryCastCollidermissile() 
        if(self._config.collierMissile ~= nil and  self._config.collierMissile > 0)then
        self:notify("castMissile",self._config.collierMissile,self._id)
        return true
    end
    return false
end
function Missile:needCheckCollider(params) 
    return true  
end
function Missile:needRemove(params) 
    return self._needRemove  
end
function Missile:isBlock(params) 
    return false  
end
function Missile:cast() 

    if(self._casted)then
        return false
    end

    if(self._config == nil)then
        return false
    end


    local refs = {
        [Enum.EMoveType.Direction] = function(  )
            local dir = self:getDir()
            self:moveDir(dir)
        end,
        [Enum.EMoveType.ToTargetPos]  = function(  )
            -- local dir = self:getDir()
            -- dir = dir:rotate(self._config.dir)   -- 朝向旋转
            local obj = self:findObjectById(self._targetId)
            local dir = obj:getPos():sub(self:getPos())
            self:moveDir(dir)
        end,
        [Enum.EMoveType.ToTarget] = function(  )
            self._targetObj = self:findObjectById(self._targetId)
        end,
        [Enum.EMoveType.ToCasterPos] = function(  )
            local obj = self:findObjectById(self._targetId)
            if(obj == nil)then
                print("target missing")
                return false
            end
            local dir = self:getPos():sub(obj:getPos())
            self:moveDir(dir)
        end,
        [Enum.EMoveType.ToCaster] = function(  )
            self._targetObj = self:findObjectById(self._casterId)
        end
    }

    refs[self._config.moveType]();
    self._casted = true

    return true
end

function Missile:setLocation() 
    if(self._config == nil)then
        return
    end
    local refs = {
        [1] = function( ... )
            return self:findObjectById(self._casterId)
        end,
        [2] = function( ... )
            return self:findObjectById(self._targetId)
        end,
        [3] = function( ... )
            return self:findObjectById(self._parentId)
        end
    }   
    local cooderate = refs[self._config.start]()

    if(cooderate == nil)then
        print("can't find cooderate",self._casterId)
        return
    end
    local pos = cooderate:getPos()
    if(pos == nil)then
        print("error pos")
        return
    end

    if(self._config.startPos ~= nil)then
        local dx = self._config.startPos[1]
        local dy = self._config.startPos[2]
        local d = Vector2.new(dx,dy)
        d:cross(cooderate:getDir())    
        pos:add(d)
    end

    self:setPos(pos)    
    self:setDir(cooderate:getDir())
    self:setCircleCollider(pos.x,pos.y,self._config.radius)
    
    if(self._render~=nil) then
        self._render:updatePos(self._pos,self._dir,self._enableRot);
    end    
end
function Missile:findObjectById(id)
    return BattleObject.getObjectById(id)
end
function Missile:getCamp(params) 
    return self._camp  
end
function Missile:getCasterId()
    return self._casterId
end

function Missile:onTriger(source,target) 
    self:notify("onTriger",source,target)
end
function Missile:tryHitTarget(target) 
    if(self:needRemove())then
        return false
    end
    if(self._hitObjs ~= nil)then
        for i = 1,#self._hitObjs do   -- 一个子弹只撞一次
            local objId = self._hitObjs[i]
            if(objId == target._id)then
                return false
            end
        end
    end

    if(self._hitCount > self._config.hitCount )then
        return false
    end

    if(self._hitObjs == nil)then
        self._hitObjs = {}
    end

    table.insert(self._hitObjs,target._id)
    self:tryCastCollidermissile()

    if(self._config.hitEffect ~= nil)then
        if(self._render~= nil) then
            self._render:playEffect(self._config.hitEffect,self:getPos(),0.2)
        end
    end

    self._hitCount = self._hitCount + 1
    if(self._hitCount  >= self._config.hitCount)then
        self._needRemove = true
    end
    return true
end

function Missile:isClass( clsName )
    return Missile.super.isClass(self,clsName) or Missile.__cname == clsName
end

return Missile