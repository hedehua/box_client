
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
	
    -- add background image
    -- cc.display.newSprite("HelloWorld.png")
    --     :move(cc.display.center)
    --     :addTo(self)

    -- add HelloWorld label
    -- cc.Label:createWithSystemFont("loading...", "Arial", 48)
    --     :move(cc.display.cx, cc.display.cy)
    --     :addTo(self)
end

return MainScene
