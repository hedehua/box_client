local Common = require "app.common.include"
local StateMain = require "app.state.stateMain"
local StateResUpdate = require "app.state.stateResUpdate"

-- // normal type manager
local ResManager = require "app.manager.resManager"
local AudioManager = require "app.manager.audioManager"
local UIManager = require "app.manager.uiManager"
local AvatarManager = require "app.manager.avatarManager"
local EffectManager = require "app.manager.effectManager"
local ConfigureManager = require "app.manager.configureManager"

-- // component type manager
local WorldConfig = require "app.controller.battle.config.worldConfig"
local LoadingManager = require "app.manager.loadingManager"
local TimerManager = require "app.manager.timerManager"
local UserModel = require "app.model.modelUser"
local Game = cc.class("Game")

function Game:ctor()
	self._states = nil
	self._curState = nil
	self._managers = nil
	self._models = nil
	self._frameCount = 0
end
	
function Game:init()
	self:initSetting();
	self:initModels();
	self:initManagers();
	self:initStates();
end

function Game:uninit()

	if(self._states ~= nil) then
		for i = 1,#self._states do
			local state = self._states[i];
			if(state ~= nil)then
				state:uninit()
			end
		end
		self._states = nil;
	end

	if(self._models ~= nil)then
		for i = 1,#self._models do
			local model = self._models[i]
			if(model ~= nil) then
				model:uninit()
			end
		end
		self._models = nil;
	end

	ResManager:getInstance():uninit();
	UIManager:getInstance():uninit();
	AvatarManager:getInstance():uninit()
	EffectManager:getInstance():uninit();
	ConfigureManager:getInstance():uninit()
	
end
function Game:reset()
	if(self._curState ~= nil) then
		self._curState:reset();
	end
end

function Game:update (dt) 
	
	self._frameCount = self._frameCount + 1;

	if(self._curState ~= nil) then

		local nextState = self._curState:getNextState()
		if(nextState ~= nil) then
			self:switchState(nextState)
		end

		self._curState:update(dt);
	end

	AvatarManager:getInstance():update();
	EffectManager:getInstance():update();
	ResManager:getInstance():update();
end


function Game:start()
	print('-- game start --')
	local dt = 1/WorldConfig.gameInterval
	TimerManager:getInstance():start(function( )
		self:update(dt)
	end,dt)
	self:switchState("StateResUpdate")
end

function Game:stop()
	if(self._curState ~= nil) then
		self._curState:leave()
	end
end
function Game:switchState(stateName)
	if(stateName == nil) then
		return;
	end

	if(self._states == nil) then
		return;
	end

	if(self._curState ~= nil) then
		self._curState:leave()
		self._curState = nil;
	end

	for i = 1,table.length(self._states) do
		local state = self._states[i];
	
		if(state.__cname == stateName) then
			self._curState = state
		end
	end

	if(self._curState ~= nil) then
		self._curState:enter();
	end

end

function Game:initStates()
	self._states = {}

	local state = StateMain.new()
	state:init();
	table.insert(self._states,state)

	state = StateResUpdate.new();
	state:init();
	table.insert(self._states,state)

end
function Game:initManagers()
	ResManager:getInstance():init();
	UIManager:getInstance():init();
	AvatarManager:getInstance():init()
	EffectManager:getInstance():init();
	ConfigureManager:getInstance():init()
end

function Game:initModels() 
	if(self._models == nil) then
		self._models = {}
	end
	local model = UserModel.new();
	model:init()
	table.insert(self._models,model)
end

function Game:initSetting()
	-- cc.game.setFrameRate(WorldConfig.gameInterval)
	
	-- -- // 0 - 通过引擎自动选择。 
	-- -- // 1 - 强制使用 canvas 渲染。 
	-- -- // 2 - 强制使用 WebGL 渲染，但是在部分 Android 浏览器中这个选项会被忽略。 
	-- cc.game.renderMode = 1

	-- cc.director.setDisplayStats(true)
end

return Game
