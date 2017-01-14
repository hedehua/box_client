local ModelBase = cc.class("ModelBase")
function ModelBase:ctor(  )
	self._listners = nil
end

function ModelBase:init ()
	
end
function ModelBase:reset()

end
function ModelBase:uninit()

end
function ModelBase:sendMessage()         
	-- // body...
end
function ModelBase:addListner (eventName,func)
	if(eventName == nil or func == nil) then
		cc.log("invalid arguments,eventName or func == nil.");
		return;
	end
	if(self._listners == nil) then
		self._listners = {}
	end
	local lst = self._listners[eventName]

	if(lst == nil) then
		lst = {}
		self._listners[eventName] = lst
	end

	lst.push(func)
	table.insert(lst,func)
end
function ModelBase:removeListner (eventName,func)
	if(eventName == nil) then
		cc.log("invalid arguments,eventName cant be nil.");
		return;
	end
	if(self._listners == nil) then
		return;
	end
	if(func == nil) then
		self._listners[eventName] = nil
		return;
	end
	local lst = self._listners[eventName]

	if(lst == nil) then
		return;
	end

	for i = lst.length,1,-1 do
		local obverser = lst[i]
		if(obverser == func) then
			table.remove(lst,1)
		end
	end

end
function ModelBase:dispatchEvent (eventName,arg1,arg2,arg3)
	if(eventName == nil) then
		cc.log("invalid arguments,eventName == nil.");
		return;
	end
	if(self._listners == nil) then
		cc.log("there is no any listner");
		return;
	end

	local lst = self._listners[eventName]
	for  i = 0,self._listners.length do   
		local abverser = self._listners[i]
		if(abverser ~= nil) then
			abverser(arg1,arg2,arg3);
		end
	end	
end

return ModelBase