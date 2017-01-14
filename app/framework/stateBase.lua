-- // 游戏整体状态机基类

local StateBase = cc.class("StateBase")

function StateBase:ctor( ... )
	-- body
	self._systemArr = {}
	self._activeSystemArr = {}
	self._name = nil
end

function StateBase:init()
	self:registSystems();
	self:initSystem();
end

function StateBase:reset ()
	-- // TODO::
end

function StateBase:uninit () 
	self:uninitSystem();
end

function StateBase:update( ... )
	for i = 1,#self._activeSystemArr do
		local item = self._activeSystemArr[i];
		if(item ~= nil) then
			item.sys:update(...)
		end
	end
end

function StateBase:enter () 
	if(self._activeSystemArr == nil)then
		return;
	end
	for i = 1,#self._activeSystemArr do
		local item = self._activeSystemArr[i];
		if(item ~= nil) then
			item.sys:enter()
		end
	end

end
function StateBase:leave()
	if(self._activeSystemArr == nil) then
		return;
	end
	for i = 1,table.length(self._activeSystemArr) do
		local item = self._activeSystemArr[i];
		if(item ~= nil) then
			item.sys:leave();
		end
	end
end

function StateBase:initSystem() 
	if(self._systemArr == nil )then
		return;
	end
	for i = 1,table.length(self._systemArr) do
		local sys = self._systemArr[i];
		if(sys ~= nil) then
			sys:init();
		end
	end

end
function StateBase:uninitSystem() 
	if(self._systemArr == nil) then
		return;
	end
	for i = 0,table.length(self._systemArr) do
		local sys = self._systemArr[i];
		if(sys ~= nil) then
			sys:uninit()
		end
	end
	self._systemArr = nil;
end
function StateBase:registSystems() 
	-- // virtual function
end
function StateBase:addSystem(sys) 
	if(sys == nil) then
		return;
	end
	if(self._systemArr == nil)then
		self._systemArr = {}
	end

	sys.onOpenHandle = function(arg0,arg1,arg2,arg3) 
		self:onSystemOpen(arg0,arg1,arg2,arg3)
	end
	sys.onCloseHandle = function(arg0,arg1,arg2,arg3) 
		self:onSystemClose(arg0,arg1,arg2,arg3)
	end

	table.insert(self._systemArr,sys)
end
function StateBase:onSystemOpen (sys,auto,arg1,arg2)
	
	if(auto)then
		return
	end

	if(self._activeSystemArr == nil)then
		self._activeSystemArr = {}
	end

	local last = self._activeSystemArr[#self._activeSystemArr]

	if(last ~= nil) then
		last.sys:close(true)
	end

	table.insert(self._activeSystemArr,{sys = sys,arg1 = arg1,arg2 = arg2})
end
function StateBase:onSystemClose(sys,auto)
	
	if(auto)then
		return
	end

	if(self._activeSystemArr ~= nil)then
		for  i = table.length(self._activeSystemArr),1,-1 do
			local item = self._activeSystemArr[i]
			if(item.sys == sys) then
				table.remove(self._activeSystemArr,1)
			end
			break;
		end
	end

	local last = self._activeSystemArr[#self._activeSystemArr]

	if(last ~= nil) then
		last.sys:open(true,last.arg1,last.arg2)
	end

end
function StateBase:getNextState() 
	return nil
end



return StateBase