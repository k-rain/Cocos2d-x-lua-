--[[
    desc:对象的工具函数类
    author:wangyu
    email:w3333y@126.com
    time:2019-12-27 18:55:15
]]
local Object = class("Object")

function Object:ctor(node)
    --UI对象的节点
    self.node = node
    --UI对象的精灵图
    self.sp = cc.Sprite:create()
    --把精灵挂在节点上
    self.node:addChild(self.sp)
    --对象的update函数
    self.updateFuncId =
        cc.Director:getInstance():getScheduler():scheduleScriptFunc(
        function()
            if self.update then
                self:update()
            end
        end,
        0,
        false
    )
end

--判断是否还存在
function Object:isAlive()
    return self.sp ~= nil
end

--获取格子区域
function Object:getRect( )
    return GMethod.newRect(self.sp:getPositionX(),self.sp:getPositionY())
end

--更新位置
function Object:updatePosition(callback)
    --获取帧间隔,这样获取可以绕开cpu帧频不同带来的干扰
    local diff = cc.Director:getInstance():getDeltaTime()

    --下一个位置
    local nextPosX = self.sp:getPositionX() + self.dx * diff
    local nextPosY = self.sp:getPositionY() + self.dy * diff

    --用于手写碰撞
    if callback and callback(nextPosX, nextPosY) then
        return
    end

    --移动
    if self.dx ~= 0 then
        self.sp:setPositionX(nextPosX)
    end
    if self.dy ~= 0 then
        self.sp:setPositionY(nextPosY)
    end
end

--获取对象的格子位置
function Object:getPos()
    return GameLogic.pos2Grid(self.sp:getPositionX(),self.sp:getPositionY())
end

--按格子设置位置
function Object:setPos(x, y)
    local posx,posy=GameLogic.grid2Pos(x,y)
    self.sp:setPosition(posx,posy)
end

--停止运动，例如击中目标后的子弹
function Object:stop( )
    self.dx=0
    self.dy=0
end

--销毁对象
function Object:destroy()
    if self.updateFuncId then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateFuncId)
    end
    self.node:removeChild(self.sp)
    self.sp = nil
end

return Object
