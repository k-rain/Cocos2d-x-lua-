--[[
    desc:坦克的实现
    author:wangyu
    email:w3333y@126.com
    time:2019-12-27 19:05:00
]]
local Object = require("app/Object")
local SpriteAnimate = require("app/SpriteAnimate")
local Bullet = require("app.Bullet")

local Tank = class("Tank", Object)
--构造函数
function Tank:ctor(node, name, map)
    Tank.super.ctor(self, node)
    self.node = node
    self.map = map
    -- local winSize = cc.Director:getInstance():getWinSize()
    -- self.sp:setPosition(winSize.width/2,winSize.height/2)
    -- local cache = cc.SpriteFrameCache:getInstance()
    -- local sprite = cache:getSpriteFrame("tank_green_run0.png")
    -- self.sp:setSpriteFrame(sprite)
    self.dir = GConst.dir.up
    self.dx = 0
    self.dy = 0
    self.speed = 100
    -- 定义动画
    self.animate = SpriteAnimate:new(self.sp)
    self.animate:define("run", name, 8, 0.1)
    self.animate:setFrame("run", 0)
end

function Tank:update()
    self:updatePosition(
        function(nextPosX, nextPosY)
            local hit = self.map:colide(nextPosX, nextPosY, -5)
            return hit
        end
    )
end

function Tank:setDir(dir)
    if not dir then
        self.dx = 0
        self.dy = 0
        self.animate:stop("run")
        return
    end
    local angel = 0
    if dir == GConst.dir.up then
        angel = 0
        self.dx = 0
        self.dy = self.speed
    elseif dir == GConst.dir.down then
        angel = 180
        self.dx = 0
        self.dy = -self.speed
    elseif dir == GConst.dir.left then
        angel = -90
        self.dx = -self.speed
        self.dy = 0
    elseif dir == GConst.dir.right then
        angel = 90
        self.dx = self.speed
        self.dy = 0
    end
    self.sp:setRotation(angel)
    self.animate:play("run")
    self.dir = dir
end

--析构函数
function Tank:destroy()
    self.animate:destroy()
    self.super:destroy(self)
end

function Tank:fire()
    if self.bullet and self.bullet:isAlive() then
        return
    end
    self.bullet = Bullet.new(self.node, self.map, GConst.bulletType.normal, self, self.dir)
end

return Tank
