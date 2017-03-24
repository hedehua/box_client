local AiConfig = require("app.controller.battle.config.aiConfig")
local Utils = require("app.controller.battle.core.battleUtils")
local Random = require("app.controller.battle.core.random")
local Enum = require("app.controller.battle.core.battleEnum")
local Vector2 = require("app.controller.battle.core.vector2")

local Ai = {}
local Base = {}

local ExceptLeft = { Enum.Direction.Right,Enum.Direction.Down,Enum.Direction.Up}
local ExceptRight = { Enum.Direction.Left,Enum.Direction.Down,Enum.Direction.Up}
local ExceptUp = { Enum.Direction.Left,Enum.Direction.Right,Enum.Direction.Down}
local ExceptDown = { Enum.Direction.Left,Enum.Direction.Right,Enum.Direction.Up}

function Base:getSmartDir( exceptDir )
    self._cache = self._cache or {}
    for i = #self._cache,1 do
        table.remove(self._cache,i)
    end

    for i = Enum.Direction.Up,Enum.Direction.Left do
        if(i ~= exceptDir and i ~= self._lastDir) then
            table.insert(self._cache,i)
        end
    end
    return self._cache[Utils.random(1,#self._cache)]
end

function Base:check()
    local map = Utils.getObjectByType("BattleMap")
    if(map ~= nil)then
        local leader = self._team:getLeader()
        local circle = leader:getCollider();
        local rect = map:getCollider()
        if(circle:detectBoundR(rect,self._config.panicDist))then
            return self:getSmartDir(Enum.Direction.Right)
        end
        if(circle:detectBoundL(rect,self._config.panicDist))then
            return self:getSmartDir(Enum.Direction.Left)
        end
        if(circle:detectBoundT(rect,self._config.panicDist))then
            return self:getSmartDir(Enum.Direction.Up)
        end
        if(circle:detectBoundB(rect,self._config.panicDist))then
            return self:getSmartDir(Enum.Direction.Down)
        end

    end
    return nil
end

function Base:search(  )
    local leader = self._team:getLeader()
    if(leader == nil)then
        print("error,no leader")
        return
    end

    self._ai._enemy = Utils.getEnemyByDist(leader._id,self._config.fov)
    self._ai._drop = Utils.getDropByDist(leader._id,self._config.fov)

end

function Base:move( d )
    self._lastDir = d
    self._team:move(d)
end

-- 随机溜达
local Idle = {}
Idle.__cname = "Idle"
setmetatable(Idle,{__index = Base})

function Idle.new( )
    local obj = {}
    obj._team = nil
    obj._config = nil
    obj._ai = nil
    setmetatable(obj,{__index = Idle})
    return obj
end

function Idle:init(ai,team,conf)
    self._team = team
    self._config = conf
    self._ai = ai
end

function Idle:enter()
    self:search()
end

function Idle:leave()
    
end

function Idle:getNext()
    local r = Utils.random(0,self._config.maxPercent)
    if(r <= self._config.search )then
        return "search"
    end
    return nil;
end

function Idle:update()
  
    local d = self:check()

    if(d == nil)then

        if(Utils.random(0,self._config.maxPercent) > self._config.activity)then
            self._team:stopMove()
            return
        end

        d = Utils.random(Enum.Direction.Up,Enum.Direction.Left)
    end

    self:move(d)
end


local Search = {}
setmetatable(Search,{__index = Base})

function Search.new( )
    local obj = {}
    obj._team = nil
    obj._config = nil
    obj._ai = nil
    setmetatable(obj,{__index = Search})
    return obj
end

function Search:init(ai,team,conf)
    self._team = team
    self._config = conf
    self._ai = ai
end

function Search:getNext()
    if(self._ai._enemy ~= nil)then           -- 发现敌人了 有多大概率追击
        local r = Utils.random(0,self._config.maxPercent)
        if(r <= self._config.pursue )then
            return "pursue"
        end
        return nil
    end

    if(self._ai._drop ~= nil)then
        local r = Utils.random(0,self._config.maxPercent)
        if(r <= self._config.pick )then
            return "pick"
        end
        return nil
    end
    
    return "idle";
end

function Search:enter()
   self:search()
end

function Search:leave()

end

function Search:update()
    
    local d = self:check()
    if(d ~= nil)then
        self:move(d)
        return
    end
   
end

local Pursue = {}
Pursue.__cname = "Pursue"
setmetatable(Pursue,{__index = Base})

function Pursue.new( )
    local obj = {}
    obj._team = nil
    obj._config = nil
    obj._ai = nil
    setmetatable(obj,{__index = Pursue})
    return obj
end

function Pursue:init(ai,team,conf)
    self._team = team
    self._config = conf
    self._ai = ai
end

function Pursue:getNext()
    if(self._ai._enemy == nil or not self._ai._enemy:isAlive())then
        return "idle"
    end

    local pos = self._team:getLeaderPos();
    local dist = pos:dist(self._ai._enemy:getPos()) 
    if(dist < self._config.panicDist) then
        local r = Utils.random(0,self._config.maxPercent)
        if(r <= self._config.escape )then
            return "escape" 
        end
        return nil
    end

    return nil
end

function Pursue:enter()
    self:search()
end

function Pursue:leave()

end

function Pursue:update()
    local d = self:check()
    if(d ~= nil)then
        self:move(d)
        return
    end
    if(self._ai._enemy == nil or not self._ai._enemy:isAlive())then
        return
    end

    local leaderPos = self._team:getLeaderPos()
    local enemyPos = self._ai._enemy:getPos();
    local delta = enemyPos:sub(leaderPos)
    local angle  = delta:signAngle(Vector2.new(1,0))

    d = Utils.angleToDirection(angle)

    self:move(d)
end

local Pick = {}
Pick.__cname = "Pick"
setmetatable(Pick,{__index = Base})

function Pick.new( )
    local obj = {}
    obj._team = nil
    obj._config = nil
    obj._ai = nil
    setmetatable(obj,{__index = Pick})
    return obj
end

function Pick:init(ai,team,conf)
    self._team = team
    self._config = conf
    self._ai = ai
end

function Pick:getNext()
    if(self._ai._drop == nil or self._ai._drop:needRemove() or not self._ai._drop:isValid()) then
        self._ai._drop = nil
        return "idle"
    end
    return nil;
end

function Pick:enter()
    self:search()
end

function Pick:leave()

end

function Pick:update()
    local d = self:check()
    if(d ~= nil) then
        self:move(d)
        return
    end

    local leaderPos = self._team:getLeaderPos()
    if(self._ai._drop == nil)then
        return
    end

    local dropPos = self._ai._drop:getPos();
    if(dropPos == nil) then
        return
    end

    local delta = dropPos:sub(leaderPos)
    local angle  = delta:signAngle(Vector2.new(1,0))

    d = Utils.angleToDirection(angle)
    self:move(d)
end

local Escape = {}
Escape.__cname = "Escape"
setmetatable(Escape,{__index = Base})

function Escape.new( )
    local obj = {}
    obj._team = nil
    obj._config = nil
    obj._ai = nil
    setmetatable(obj,{__index = Escape})
    return obj
end

function Escape:init(ai,team,conf)
    self._team = team
    self._config = conf
    self._ai = ai
end

function Escape:getNext()
    if(self._ai._enemy == nil or not self._ai._enemy:isAlive())then
        self._ai._enemy = nil
        return "idle"
    end
    local pos = self._team:getLeaderPos();
    if(pos:dist(self._ai._enemy:getPos()) > self._config.safeDist)then
        self._ai._enemy = nil
        return "idle"  
    end
    return nil
end

function Escape:enter()
    self:search()
end

function Escape:leave()

end

function Escape:update()
    local d = self:check()
    if(d ~= nil)then
        self:move(d)
        return
    end

    local leaderPos = self._team:getLeaderPos()
    if(self._ai._enemy == nil)then
        return
    end
    local enemyPos = self._ai._enemy:getPos();
    local delta = leaderPos:sub(enemyPos)
    local angle  = delta:signAngle(Vector2.new(1,0))

    d = Utils.angleToDirection(angle)
    -- print(self._team._id,"escape",delta.x,delta.y,'@',angle,d)
    self:move(d)
end


function Ai.new(typeId,team) 
    local ai = {}
    setmetatable(ai,{__index = Ai})
    ai._config = Utils.getConfig(AiConfig,typeId);
    ai._team = team;
    ai._frameCount = 0;
    ai._state = nil;
    ai._enemy = nil;
    ai._drop = nil;
    ai:setExcuteTime();
    ai._fsm = {
        idle      = Idle.new(),
        search    = Search.new(),
        pursue    = Pursue.new(),
        escape    = Escape.new(),
        pick      = Pick.new()
    }
    for i,v in pairs(ai._fsm) do
        v:init(ai,ai._team,ai._config);
    end
    return ai
end

function Ai:setExcuteTime(t)
    self._excuteTime = self._config.interval + (t or 0)
end

function Ai:update()
    self._frameCount = self._frameCount + 1;
    if(self._frameCount >= self._excuteTime)then
        if(self._state == nil)then
            self._state = self._fsm["idle"]
        end
        
        if(self._state ~= nil)then
            local stateName = self._state:getNext();
            if(stateName ~= nil)then
                local state = self._fsm[stateName]
                if(state == nil)then
                    print("can't find state",stateName)
                    return
                end

                -- print(self._team._id,stateName)
                self._state:leave()
                self._state = state
                self._state:enter();
            end
        end
        
        if(self._state ~= nil)then
            self._state:update();
        end
        self:setExcuteTime(self._frameCount)
    end
end


return Ai


