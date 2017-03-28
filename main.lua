
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("src/")

cc.DEBUG = cc.DEBUG_INFO --cc.DEBUG_VERBOSE
cc.DEBUG_DISABLE_DUMP_TRACEBACK = true
cc.detaTime = 0

local logFileName = "log_file.txt"  
local writablePath = cc.FileUtils:getInstance():getWritablePath()
local logFilePath = writablePath..logFileName

if(not cc.FileUtils:getInstance():isDirectoryExist(writablePath)) then
    os.execute("mkdir \"" .. writablePath .. "\"")
end

print = function (...)  
    release_print(...)  
    if ... then  
        local args = {...}  
        local s = args[1]  
        if #args > 1 then  
            for i=2,#args do  
                local arg = ''
                if(type(args[i]) ~= 'string') then
                    arg = type(args[i])
                end
                
                s = s .. "    |    " .. arg  
            end  
        end
        local logFile = io.open(logFilePath,'a+') 
        logFile:write(tostring(s).."\n")  
        logFile:flush() 
        logFile:close() 
    end  
end  

require "cocos.init"

local function _cleanmem()
    for i = 1, 6 do
        collectgarbage()
    end

    cc.printinfo("[MEM] used: %d KB", math.ceil(collectgarbage("count")))
end

local function __main()

    print('__main__')

    _cleanmem()

    local creator = require "creator.init"
    local assets = creator.getAssets()

    local url = assets:getStartSceneUrl()
    local scene = assets:createScene(url)
    scene:run()

    local App = require("app.app")
    local app = App:getInstance()
    app:run()

    _cleanmem()
end

xpcall(__main, __G__TRACKBACK__)
