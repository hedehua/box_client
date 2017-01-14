local resManager = require("app.manager.resManager")
local AudioManager = cc.class("AudioManager")


local _instance = nil

function AudioManager:getInstance( ... )
	if(_instance ~= nil) then
		return _instance
	end
	_instance = AudioManager.new()
	return _instance
end

function AudioManager:ctor(  )
	-- body
end

function AudioManager:playMusic( ... )
	-- body
end

function AudioManager:playEffect( ... )
	-- body
end

-- {
--     extends: cc.Component,

--     properties: {
-- 		_clips : null,
--         musicPlayer: {
--             default: null,
--             type: cc.AudioSource
--         },       
--     },
-- 	statics: {
--         instance: null
--     },
-- 	onLoad: function () {
-- 		AudioManager.instance = this
-- 	},

--     init : function(){
		
-- 	},
-- 	reset : function(){},
-- 	uninit : function(){},
-- 	playMusic : function(path){
		
-- 		-- // if(!cc.sys.isNative){       // mobile ignore
--   --       //     return;
--   --       // }
-- 		-- // if(path == null){
-- 		-- // 	return
-- 		-- // }
-- 		-- // if(this.musicPlayer == null){
-- 		-- // 	cc.log("musicPlayer missing")
-- 		-- // 	return
-- 		-- // }
-- 		-- // var clip = this.getClip(path)

-- 		-- // if(clip != null){
-- 		-- // 	cc.audioEngine.playMusic(clip,true)
-- 		-- // 	return
-- 		-- // }

-- 		-- // var self = this
-- 		-- // this.loadRes(path,function() {
-- 		-- // 	self.playMusic(path)
-- 		-- // })			

-- 	},
-- 	playEffect : function(path){
		
-- 		-- // if(!cc.sys.isNative){       // mobile ignore
--   --       //     return;
--   --       // }

-- 		-- // if(path == null){
-- 		-- // 	return
-- 		-- // }
		
-- 		-- // if(this.musicPlayer == null){
-- 		-- // 	cc.log("musicPlayer missing")
-- 		-- // 	return
-- 		-- // }
-- 		-- // var clip = this.getClip(path)

-- 		-- // if(clip != null){
-- 		-- // 	cc.audioEngine.playEffect(clip)
-- 		-- // 	return
-- 		-- // }

-- 		-- // var self = this
-- 		-- // this.loadRes(path,function() {
-- 		-- // 	self.playEffect(path)
-- 		-- // })	

-- 	},
-- 	getClip : function(path) {
-- 		if(this._clips != null){
-- 			for(var i = 0;i<this._clips.length;i++){
-- 				var item = this._clips[i]
-- 				if(item.path == path){
-- 					return item.clip
-- 				}
-- 			}
-- 		}
-- 	},
-- 	loadRes : function(path,callback) {
-- 		var self = this
-- 		resManager.instance.load(path,function(err, asset) {  		// 暂时不考虑 上层重复调用问题(实为必要)
-- 			var item = { path : path,clip : asset }
-- 			if(self._clips == null){
-- 				self._clips = new Array()
-- 			}
-- 			self._clips.push(item)
-- 			if(callback != null){
-- 				callback()
-- 			}
-- 		})	
-- 	},
-- 	stopMusic : function() {
-- 		cc.audioEngine.stopMusic()
-- 	},
-- });

return AudioManager
