local BoxCollider = {}
BoxCollider.__cname = "BoxCollider"
function BoxCollider.new( x,y,w,h )
	local collider = {}
	setmetatable(collider,{__index = BoxCollider})
	collider:setv(x,y,w,h)
	return collider
end

function BoxCollider:setv(x,y,w,h) 
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end
function BoxCollider:setPos (x,y) 
	self.x = x
	self.y = y
end

function BoxCollider:left() 
	if(self.w == 0) then
		cc.log("no no no")
		return 0
	end

	return math.floor(self.x - self.w / 2) 
end
function BoxCollider:right() 
	if(self.w == 0)then
		return 0
	end
	return math.floor(self.x + self.w / 2)
end
function BoxCollider:top() 
	if(self.h == 0) then
		return 0
	end
	return math.floor(self.y + self.h / 2)
end
function BoxCollider:bottom() 
	if(self.h == 0) then
		return 0
	end
	return math.floor(self.y - self.h / 2)
end

return BoxCollider