local maxshort = 65535
local multiplier = 1194211693
local adder = 12345
local randSeed = 197
local randomRange = function(range) 
    -- if(range == 0) then
    --     return 0
    -- end
    -- randSeed = multiplier * (randSeed + adder) + adder;
    -- randSeed = ((randSeed >>> 16));
    -- return randSeed % range
    return math.random(range)
end

local random = function(min,max) 
    return randomRange(max - min) + min
end

local setSeed = function(seed) 
    randSeed = seed
end
return  {
    random = random,
    setSeed = setSeed
}