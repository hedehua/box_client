-- //主菜单逻辑模块
local LoadingManager = require("app.manager.loadingManager")

local ControllerBase = require('app.framework.controllerBase') 
local UILogin = require("app.ui.uiLogin");
local ControllerBattle = require("app.controller.battle.controllerBattle") 
local AudioManager = require("app.manager.audioManager")
local Common = require("app.common.include")
local WorldConfig = require("app.controller.battle.config.worldConfig")
local Net =  require("app.network.net")
local UserModel = require("app.model.modelUser")
local ControllerLogin = cc.class("ControllerLogin",ControllerBase)

local _instance = nil
function ControllerLogin:getInstance( ... )
  if(_instance == nil) then
    _instance = ControllerLogin.new();
  end
  return _instance
end

function ControllerLogin:ctor( ... )
  -- body
  self._ui = nil
end

function ControllerLogin:uninit()
  self:close();
  self.super.uninit(self)
end
function ControllerLogin:open(arg1)

  self.super.open(self,arg1)

  self._ui = UILogin.new();
  self._ui:setQueier({
      start = function(arg1)
          self:loginToServer(function()
            ControllerBattle:getInstance():requestStart(arg1);
          end)
      end,
      onLoaded = function(name)
        LoadingManager:getInstance():stop();
      end
  });

  self._ui:init();
  self._ui:open();

  -- // AudioManager.instance.playMusic(Common.assetPathTable.musicLogin)

end
function ControllerLogin:close(arg1)

  if(self._ui ~= nil) then
    self._ui:close()
  end
  self.super.close(self,arg1)	
end
function ControllerLogin:loginToServer(func) 
    -- local host =  WorldConfig.serverAddr;
    -- local port =  WorldConfig.serverPort;
    -- local uname = WorldConfig.defaultUname
    -- Net:init({
    --   host = host,
    --   port = port,
    --   log = true
    -- }, function() 
    -- Net:request("gate.gateHandler.queryEntry",{uname = uname}, function(data) 
    --     if(data.code ~= 200) then
    --        cc.error("[user]gate connect failure",data.code);
    --        Net:disconnect()
    --        return;
    --     end
    --     -- // cc.log("[user]gate:",data.host,data.port,'uid',data.uid);
    --     UserModel:getInstance():setUid(data.uid)
    --     Net:disconnect()
    --     Net:init({
    --         host = data.host,
    --         port = data.port,
    --         log = true
    --     },func)
    --   end);
    -- end);

    func()
end
return ControllerLogin