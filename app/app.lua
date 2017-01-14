
-- // *********************************************************************
-- // ***** 编码规范：驼峰命名法
-- // ***** 1.类名：大写开头
-- // ***** 2.私有变量：_小写开头
-- // ***** 3.共有变量：小写开头
-- // ***** 4.文件夹，文件 命名大写开头（文件名和类名统一命名）
-- // ***** 5.静态成员：static_ 开头
-- // ***** 6.成员变量的申明一律写在properties中
-- // *********************************************************************
-- // Author:h.d.h
-- // Date:2016-08-01
-- // *********************************************************************

-- //  cc.director.end();

local Game = require 'app.game'
local App = cc.class("App")

local _instance = nil

function App:getInstance(  )
	if(_instance == nil) then
		_instance = App.new()
	end
	return _instance
end

function App:ctor()
    math.randomseed(os.time())

    self._game = nil
end

function App:init(  )
    -- body
end

function App:uninit () 
    if(self._game ~= nil) then
        self._game:uninit();
        self._game = nil;
    end
end

function App:run ()
    self._game = Game.new();
    self._game:init();
    self._game:start();
end


return App

