
local CircleCollider = {}
CircleCollider.__cname = "CircleCollider"

function CircleCollider.new(x,y,r)
	local collider = {}
	setmetatable(collider,{__index = CircleCollider})
	collider.x = x or 0
	collider.y = y or 0
	collider.r = r or 1
	return collider
end

function CircleCollider:setv(x,y,r) 
	self.x = x
	self.y = y
	self.r = r

	self.dist = nil
end
function CircleCollider:getDist() 
	return self.dist
end
function CircleCollider:setPos(x,y) 
	self.x = x
	self.y = y
end
function CircleCollider:detectCircle(collider) 
	if(collider == nil)then
		cc.log("arguments error,collider nil");
		return false
	end

	self.dist = math.floor(math.sqrt(math.pow(collider.y - self.y,2) + math.pow(collider.x - self.x,2)))
	return self.dist < self.r + collider.r
end
function CircleCollider:detectRect(rect)                   -- 检测两个矩形是否发生碰撞
	-- TODO::	
end
function CircleCollider:detectBound(rect,dist)  
	if(rect == nil) then
		return false
	end

	dist = dist or 0
	if(self.r + self.x + dist > rect:right())then
		return true
	end

	if(-self.r + self.x - dist < rect:left()) then
		return true
	end

	if(self.r + self.y + dist > rect:top()) then
		return true
	end

	if(-self.r + self.y - dist < rect:bottom()) then
		return true
	end
	return false
end
function CircleCollider:detectBoundR(rect,dist)   				-- 检测当前圆是否和p1-p2之间的线段碰撞
	if(rect == nil) then
		return false
	end

	dist = dist or 0

	if(self.r + self.x + dist > rect:right()) then
		return true
	end
	return false
end
function CircleCollider:detectBoundL(rect,dist)   				-- 检测当前圆是否和p1-p2之间的线段碰撞
	if(rect == nil) then
		return false
	end

	dist = dist or 0

	if(-self.r + self.x - dist < rect:left()) then

		return true
	end
	return false
end
function CircleCollider:detectBoundT(rect,dist)   				-- 检测当前圆是否和p1-p2之间的线段碰撞
	if(rect == nil) then
		return false
	end

	dist = dist or 0

	if(self.r + self.y + dist > rect:top()) then
	
		return true
	end
	return false
end
function CircleCollider:detectBoundB(rect,dist)   				-- 检测当前圆是否和p1-p2之间的线段碰撞
	if(rect == nil) then
		return false
	end

	dist = dist or 0

	if(-self.r + self.y - dist < rect:bottom()) then
	
		return true
	end
	return false
end

return CircleCollider