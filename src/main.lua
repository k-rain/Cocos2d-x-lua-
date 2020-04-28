
--@region luaide调试代码
local breakSocketHandle,debugXpCall = require("LuaDebugjit")("localhost",7004)
cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakSocketHandle, 0.3, false)
--@endregion

cc.FileUtils:getInstance():setPopupNotify(false)

__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    print(msg)
    debugXpCall()
    return msg
end

require "config"
require "cocos.init"
require "MyGlobal"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
