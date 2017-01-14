local BoxCollider = {}
BoxCollider.__cname = "BoxCollider"
function BoxCollider.new( x,y,w,h )
	local collider = {}
	setmetatable(collider,{__index = BoxCollider})
	collider:setv(x,y,w,h)
	return collider
end

function BoxCollider:setv(x,y,w,h) 
	self._x = x
	self._y = y
	self._w = w
	self._h = h
end
function BoxCollider:setPos (x,y) 
	self._x = x
	self._y = y
end

function BoxCollider:left() 
	if(self._w == 0) then
		cc.log("no no no")
		return 0
	end

	return math.floor(self._x - self._w / 2) 
end
function BoxCollider:right() 
	if(self._w == 0)then
		return 0
	end
	return math.floor(self._x + self._w / 2)
end
function BoxCollider:top() 
	if(self._h == 0) then
		return 0
	end
	return math.floor(self._y + self._h / 2)
end
function BoxCollider:bottom() 
	if(self._h == 0) then
		return 0
	end
	return math.floor(self._y - self._h / 2)
end

return BoxCollider