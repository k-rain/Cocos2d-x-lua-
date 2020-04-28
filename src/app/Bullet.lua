--[[
    desc:子弹类
    author:wangyu
    email:w3333y@126.com
    time:2020-04-26 14:43:45
]]
require("app.Map")
local Object = require("app.Object")
local SpriteAnimate = require("app.SpriteAnimate")
local Bullet = class("Bullet", Object)

function Bullet:ctor(node, map, type, obj, dir)
    self.super.ctor(self, node)
    self.map = map
    self.dir = dir
    self.dx, self.dy = self:getDeltaByDir(dir, GConst.bSpeed)
    self.sp:setPositionX(obj.sp:getPositionX())
    self.sp:setPositionY(obj.sp:getPositionY())
    self.animate = SpriteAnimate.new(self.sp)
    self.animate:define(nil, "bullet", 2, 0.1)
    self.animate:define(nil, "explode", 3, 0.1, true)
    self.animate:setFrame("bullet", 0)
end

function Bullet:getDeltaByDir(dir, speed)
    local speedx, speedy = 0, 0
    if dir == GConst.dir.left then
        speedx = -speed
        speedy = 0
    elseif dir == GConst.dir.right then
        speedx = speed
        speedy = 0
    elseif dir == GConst.dir.up then
        speedx = 0
        speedy = speed
    elseif dir == GConst.dir.dowen then
        speedx = 0
        speedy = -speed
    end
    return speedx, speedy
end

function Bullet:update()
    self:updatePosition(
        function(nextPosX, nextPosY)
            local hit
            local block, out = self.map:hit(nextPosX, nextPosY)
            if block or out then
                hit = "explode"
                --打到东西或者出界
                if block and block.breakable then
                    if (not block.needAP) or (block.needAP and self.type == GConst.bulletType.AP) then
                        block:beHit()
                    end
                end
                --hit可能是打到砖块也可能是子弹对冲
                if hit then
                    self:stop()
                    if hit == "explode" then
                        self:explode()
                    end
                end
            end
            return false
        end
    )
end

function Bullet:explode()
    self.animate:play(
        "explode",
        function()
            self:destroy()
        end
    )
end

return Bullet
