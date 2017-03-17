
local formatSeconds = function(remainTime)  

    if remainTime == nil or remainTime <= 0 then  
        return "00:00:00"  
    end  
    local h = math.floor(remainTime/60/60)  
    local m = math.floor(remainTime/60)%60  
    local s = math.floor(remainTime)%60  
    return string.format("%02d:%02d:%02d",h,m,s)  
end

local visibleSize = nil
local getVisibleSize = function()
    if(visibleSize == nil)then
        visibleSize = cc.Director:getInstance():getVisibleSize()
    end
    return visibleSize
end

return {
   formatSeconds = formatSeconds,
   getVisibleSize = getVisibleSize,
   fileLog = fileLog,
}