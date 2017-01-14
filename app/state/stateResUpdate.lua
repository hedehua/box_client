-- // native 時資源更新
-- // h5 時 資源加載

local ResManager = require("app.manager.resManager")
local Common = require("app.common.include")
local StateBase = require("app.framework.stateBase")

local StateResUpdate = cc.class("StateResUpdate",StateBase)

function StateResUpdate:ctor( )
    self.super.ctor(self)
    self.taskQue = nil
    self.totolTime = 0 
end

function StateResUpdate:enter() 
    self.super.enter(self)
    local commonAsset = Common.assetPathTable
    for i,name in ipairs(commonAsset) do
        if(self.taskQue == nil) then
            self.taskQue = {}
        end
        table.insert( self.taskQue, commonAsset[name] )
    end
end
function StateResUpdate:update(dt) 
    self.super.update(self,dt)

    self.totolTime = self.totolTime  +  dt

    if(ResManager:getInstance():isLoading()) then
        return 
    end
    if(self.taskQue ~= nil and table.length(self.taskQue) > 0)then
        local assetPath = self.taskQue[1]
        if(assetPath ~= nil) then
            table.remove(self.taskQue,1)
            if(assetPath ~= "") then
                ResManager:getInstance():load(assetPath)
            end
        end
        
    end
   
end
function StateResUpdate:getNextState() 
    if(self.totolTime < 5 and self.taskQue ~= nil and table.length(self.taskQue) > 0) then
      return nil
    end
    return "StateMain"  
end
return StateResUpdate