local Common = require "app.common.include"
local StateMain = require "app.state.stateMain"
local StateResUpdate = require "app.state.stateResUpdate"

-- // normal type manager
local ResManager = require "app.manager.resManager"
local AudioManager = require "app.manager.audioManager"
local EffectManager = require "app.manager.effectManager"
local ConfigureManager = require "app.manager.configureManager"
local SpriteFrameManager = require "app.manager.spriteFrameManager"

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
	EffectManager:getInstance():uninit();
	ConfigureManager:getInstance():uninit()
	SpriteFrameManager:getInstance():uninit()
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

	for i = 1,#self._states do
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
	EffectManager:getInstance():init();
	ConfigureManager:getInstance():init()
	SpriteFrameManager:getInstance():init()
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
	local director = cc.Director:getInstance()
	 --turn on display FPS
    director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
end

return Game
