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
    self._uiStats = nil
    self._uiSetting = nil
    self._uiSelect = nil
    self._uiShop = nil
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
            self:openSelect()
        end,
        stats = function(  )
            self:openStats()
        end,
        setting = function(  )
            self:openSetting()
        end,
        shop = function(  )
            self:openShop()
        end,
        onLoaded = function(name)
            LoadingManager:getInstance():stop();
        end,
        getCoin = function(  )
            return UserModel:getInstance():getCoin()
        end
    });

    self._ui:init();
    self._ui:open();

    local volume = UserModel:getInstance():getMusicVolume()
    AudioManager:getInstance():setMusicVolume(volume/100)
    AudioManager:getInstance():playMusic(Common.assetPathTable.musicLogin)

end

function ControllerLogin:openStats(  )
    if(self._uiStats == nil) then
        local UIStats = require("app.ui.uiStats")
        self._uiStats = UIStats.new()
        self._uiStats:setQueier({
          close = function( ... )
            self._uiStats:uninit()
            self._uiStats = nil
          end
        })
        self._uiStats:init()
    end

    self._uiStats:open()
end

function ControllerLogin:openSelect(  )
    if(self._uiSelect == nil) then
        local UISelect = require("app.ui.uiSelect")
        self._uiSelect = UISelect.new()
        self._uiSelect:setQueier({
            selectItem = function( index )

                local TimerManager = require "app.manager.timerManager"
                TimerManager:getInstance():runOnce(function(  )
                    self._uiSelect:uninit()
                    self._uiSelect = nil
                end,0.2)
                self._uiSelect:close()

                self:loginToServer(function()
                  ControllerBattle:getInstance():requestStart(index);
                end)
            end,
            close = function(  )
                self._uiSelect:uninit()
                self._uiSelect = nil
            end
        })
        self._uiSelect:init()
    end
    self._uiSelect:open()
end

function ControllerLogin:openShop(  )
    if(self._uiShop == nil) then
        local UIShop = require("app.ui.uiShop")
        self._uiShop = UIShop.new()
        self._uiShop:setQueier({
            close = function(  )
                self._uiShop:uninit()
                self._uiShop = nil
            end,
            selectItem = function( index )
                local coin = UserModel:getInstance():getCoin()
                UserModel:getInstance():setCoin(coin + WorldConfig["goods"..index])
                self._uiShop:uninit()
                self._uiShop = nil
                self._ui:fresh()
            end
        })
        self._uiShop:init()
    end
    self._uiShop:open()
end

function ControllerLogin:openSetting(  )
    if(self._uiSetting == nil) then
        local UIStats = require("app.ui.uiSetting")
        self._uiSetting = UIStats.new()
        self._uiSetting:setQueier({
          close = function(  )
            self._uiSetting:uninit()
            self._uiSetting = nil
          end,
          confirm = function(  )
            self._uiSetting:uninit()
            self._uiSetting = nil
          end,
          cancel = function(  )
            self._uiSetting:uninit()
            self._uiSetting = nil
          end,
          setAudioVolume = function( volume )
            UserModel:getInstance():setAudioVolume( volume )
            AudioManager:getInstance():setAudioVolume(volume/100)
          end,
          getAudioVolume = function( )
            return UserModel:getInstance():getAudioVolume(  )
          end,
          setMusicVolume = function( volume )
            UserModel:getInstance():setMusicVolume( volume )
            AudioManager:getInstance():setMusicVolume(volume/100)
          end,
          getMusicVolume = function( )
            return UserModel:getInstance():getMusicVolume(  )
          end,
        })
        self._uiSetting:init()
    end

    self._uiSetting:open()
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