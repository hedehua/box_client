local ComponentBase = cc.import(".ComponentBase")
local SliderComponent = cc.class("cc.Slider", ComponentBase)


function SliderComponent:ctor(asset, assets)
    SliderComponent.super.ctor(self)
    self.node = asset
end


function SliderComponent:onLoad(target)
    local slider = self.node
    target:addChild(slider)
end

return SliderComponent
