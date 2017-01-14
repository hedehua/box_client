-- 一个整型的向量封装

local pi = 3.14
local Vector2 = {}
function Vector2.new(x,y)
    local v = {} 
    setmetatable(v,{__index = Vector2})
    v._factor = 100
    v.x = x or 0
    v.y = y or 0
    return v
end

function Vector2:len () 
    return math.floor(math.sqrt(self.x * self.x + self.y * self.y))
end

function Vector2:norm () 
    local l = self:len()
    if(l == 0) then
        return self
    end
    local v = Vector2.new();
    return v:setv(self.x * self._factor  / l,self.y * self._factor  / l)
end

function Vector2:setv (x,y)
    self.x = x 
    self.y = y 
    self:round()
    return self
end

function Vector2:clone ()
    local v = Vector2.new()
    return v:setv(self.x,self.y);
end
function Vector2:reverse ()
    local v = Vector2.new();
    return v:setv(-self.x,-self.y);
end
function Vector2:floor ()
    self.x = math.floor(self.x)
    self.y = math.floor(self.y)
    return self
end
function Vector2:round () 
    self.x = math.ceil(self.x) 
    self.y = math.ceil(self.y)
    return self
end
function Vector2:add (v)
    if(v == nil)then
        cc.log("[vector]add vector exception");
        return self;
    end
    self.x = self.x + v.x
    self.y = self.y + v.y
    self:floor()
    return self
end
function Vector2:sub (v)
    if(v == nil)then
        cc.log("[vector]sub vector exception")
        return self;
    end

    self.x = self.x - v.x
    self.y = self.x - v.y
    self:floor()
    return self
end
function Vector2:scale (factor)
    self.x = self.x * factor
    self.y = self.y * factor
    self:floor()
    return self
end
function Vector2:mult (v)
    self.x = self.x * v.x
    self.y = self.y * v.y
    self:floor()
    return self
end
function Vector2:dot (v)
    return self.x * v.x + self.y * v.y
end
function Vector2:dist (v)
    if(v == nil)then
        return 1000000000
    end
    return math.floor(math.sqrt((self.x - v.x) * (self.x - v.x) + (self.y - v.y) * (self.y - v.y)))
end
function Vector2:cross (v)
    local r = Vector2.new()
    r:setv(self.x * v.x + self.x * v.y,self.y * v.x + self.y * v.y)
    return r
end

function Vector2:equals ( v )  
    if(v == nil)then
        return false
    end
    return  v.x == self.x  and  v.y == self.y ;  
end  
-- 统一在外部处理normalize以减轻此处的计算量
function Vector2:moveFace (dir,len)
    if(dir == nil)then
        cc.log("[vector]dir nil")
    end
    self.x = self.x + dir.x * len /  self._factor;
    self.y = self.y + dir.y * len / self._factor;
    self:floor()
    return self
end
function Vector2:rotate (angle)      -- 旋转角度angle
    local c = math.cos(angle * pi/180) 
    local s = math.sin(angle * pi/180) 
    self:setv(self.x * c - self.y * s,self.x * s + self.y * c )
    return self:norm()
end
function Vector2:signAngle (v)
    local s = self.x * v.y - v.x * self.y;  
    local c = self.x * v.x + self.y * v.y;
 
    return math.atan2(s,c); 
end
return Vector2