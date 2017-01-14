local StateBase = require("app.framework.stateBase")
local ControllerBattle = require("app.controller.battle.controllerBattle") 
local ControllerLogin = require("app.controller.login.controllerLogin")  

local StateMain = cc.class("StateMain",StateBase)

function StateMain:registSystems() 
    self:addSystem(ControllerLogin:getInstance())
    self:addSystem(ControllerBattle:getInstance())
end
function StateMain:enter()
    self.super.enter(self)
    
    ControllerLogin.getInstance():open()
end
    
return StateMain