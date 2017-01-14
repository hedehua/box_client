local ControllerBase = cc.class("ControllerBase")

function ControllerBase:ctor(  )
	-- body
	self._name = nil
	self._onOpen = nil
	self._onClose = nil

	-- public
	self.name = nil
	self.onOpenHandle = nil
	self.onCloseHandle = nil
end
function ControllerBase:init()

end
function ControllerBase:reset()

end
function ControllerBase:uninit()

end
function ControllerBase:open(arg1,arg2,arg3)
	self.onOpenHandle(self,arg1,arg2,arg3);
end
function ControllerBase:close(arg1,arg2,arg3)
	self.onCloseHandle(self,arg1,arg2,arg3);
end
function ControllerBase:update()
	
end

return ControllerBase