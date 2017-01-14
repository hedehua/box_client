--  /**
--  * trace
--  * @param [int] [count=10]
--  */
-- // function trace (count) {
-- //     local caller = arguments.callee.caller;
-- //     var i = 0;
-- //     count = count || 10;
-- //     cc.log("***----------------------------------------  ** " + (i + 1));
-- //     while (caller && i < count) {
-- //         cc.log(caller.toString());
-- //         caller = caller.caller;
-- //         i++;
-- //         cc.log("***---------------------------------------- ** " + (i + 1));
-- //     }
-- // }

local formatSeconds = function(remainTime)  
    if not remainTime or remainTime <= 0 then  
        return "00:00:00"  
    end  
    local h = math.floor(remainTime/1000/60/60)  
    local m = math.floor(remainTime/1000/60)%60  
    local s = math.floor(remainTime/1000)%60  
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
}