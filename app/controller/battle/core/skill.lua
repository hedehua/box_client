local Utils = require("app.controller.battle.core.battleUtils")
local SkillConfig = require("app.controller.battle.config.skillConfig")
local Missile = require("app.controller.battle.core.missile")
-- local Character = require("./character")

local Skill = {}
function Skill.new(  )
    local skill = {}
    setmetatable(skill,{__index = Skill})
    skill._id = 0                -- 唯一索引
    skill._typeId = 0  			-- 配置表id
    skill._cd = 0
    skill._frameCount = 1
    skill._valid　= false
    skill._casterId = -1
    skill._camp = nil
    skill._config = nil

    skill._queier = nil
    skill._missiles = nil
    skill._restMissile = 0
    skill._nextMissileTime = -1

    return skill
end

function Skill:init(typeId,camp,casterId) 
    self._typeId = typeId
    self._camp = camp
    self._casterId = casterId
    self._config = Utils.getConfig(SkillConfig,self._typeId)
    self._valid = true

    self:resetRestMissile()
    self:resetCd()
    
end
function Skill:uninit() 
    if(self._missiles ~= nil) then
        for i = 1,table.length(self._missiles) do
            local m = self._missiles[i]
            if(m ~= nil) then
                m:uninit()
            end
        end
    end
    self._valid = false    
end
function Skill:setQueier(q)
    self._queier = q
end
function Skill:request(eventType,arg1,arg2,arg3)
    if(self._queier == nil) then
        return nil;
    end
    local r = self._queier[eventType]
    if(r ~= nil) then
        return r(arg1,arg2,arg3);
    end
    return nil;
end
function Skill:notify(eventType,arg1,arg2,arg3)
    if(self._queier == nil) then
        return nil;
    end
    local r = self._queier[eventType]
    if(r ~= nil) then
        r(arg1,arg2,arg3);
    end
end

function Skill:resetCd(params) 
    self._cd = self._config.cd  
end

function Skill:resetInterval() 
    self._nextMissileTime = self._frameCount + self._config.interval
end

function Skill:resetRestMissile() 
    self._restMissile = self._config.missileCount
end
function Skill:update() 

    if(not self._valid) then
        return
    end
    self._frameCount = self._frameCount + 1;
    if(self._cd > 0) then
        self._cd = self._cd - 1;
    end

    if(self._frameCount >= self._nextMissileTime and self._nextMissileTime >0) then
        if(self._restMissile >0) then
            self:castMissile()
            self:resetInterval()
        end
        
    end

end
function Skill:isOk() 
    return self._cd == 0  
end

function Skill:getAttack() 
    if(self._config == nil) then
        return 0
    end
    return self._config.attack
end
function Skill:cast() 
    if(self._cd > 0) then
        return false
    end

    if(not self:castMissile()) then
        return false
    end
    
    self:resetCd() 
    self:resetInterval()
    return true
end

function Skill:findTarget() 
    if(self._config == nil) then
        return nil
    end
    local dist = self._config.attackRadius

    local refs = {
        [1] = function( ... )
           return Utils.getEnemyByDist(self._casterId,dist);
        end,
        [2] = function( ... )
            return Utils.getLessHpPartner(self._casterId)
        end,
        [3] = function( ... )
            return Utils.getAllPartner(self._casterId)
        end
    }
    return refs[self._config.target]()

end
function Skill:castMissile(typeId,parentId) 
    
    if(typeId == nil) then
        typeId = self._config.script
    end
    
    if(parentId == nil) then
        parentId = -1
    end
    
    local targets = nil

    if(Missile.needTarget(typeId)) then
        targets = self:findTarget()
        if(targets == nil) then
            return false
        end
    end

    local camp = self._camp
    local missile = Missile.new()
    missile:setQueier({
        onTriger = function (sourceObj,targetObj) 
            self:notify("onTriger",sourceObj,targetObj,self)
        end,
        castMissile = function(missileTypeId,parent) 
            self:castMissile(missileTypeId,parent)
        end
    })

    missile:init(typeId,camp,self._casterId)
    if(targets ~= nil) then
        missile:setTargetId(targets._id)
    end

    missile:setParentId(parentId)
    missile:setLocation()

    missile:cast()
    self._restMissile = self._restMissile - 1;
    self:notify("castMissile",missile)
    return true
end

function Skill:getId(  )
    return self._id
end

return Skill