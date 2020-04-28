--[[
    desc:玩家坦克
    author:wangyu
    email:w3333y@126.com
    time:2019-12-27 22:59:10
]]
local Tank = require("app/Tank")
local PlayerTank = class("PlayerTank", Tank)

function PlayerTank:ctor(node, name, map)
    PlayerTank.super.ctor(self, node, name, map)
    self.dirTable = {0, 0, 0, 0}
end

function PlayerTank:moveBegin(dir)
    if not GMethod.isContain(GConst.dir, dir) then
        return
    end
    self.dirTable[dir] = socket.gettime()
    self:updateDir()
end

function PlayerTank:moveEnd(dir)
    if not GMethod.isContain(GConst.dir, dir) then
        return
    end
    self.dirTable[dir] = 0
    self:updateDir()
end

--[[这里是为了玩家操作平滑，对动作做了处理:
    情景：按方向键的方向辨别问题，“同时”按下了左跟右的时候，再松手了一个
    解决：同时按下不可能，必有先后，例如先左后右：先按右处理，当松开了左时，继续右，当松开的是右时，此时自动到左
    方式：dirTable会记住按下的时间，遍历时间，按最发生的设置给坦克，

]] function PlayerTank:updateDir()
    local maxTime = 0
    local maxDir
    for k, v in pairs(self.dirTable) do
        if v > maxTime then
            maxTime = v
            maxDir = k
        end
    end
    self:setDir(maxDir)
end

return PlayerTank
