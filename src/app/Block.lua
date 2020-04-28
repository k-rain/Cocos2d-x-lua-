--[[
    desc:地图砖块
    author:wangyu
    email:w3333y@126.com
    time:2020-04-24 14:58:12
]]
local Object = require("app.Object")
local Block = class("Block", Object)
local maxBreakStep = 3
local blockPro = {
    --泥土
    mud = {
        --生命值
        hp = 0,
        --是否需要穿甲弹
        needAP = false,
        --阻尼
        damping = 0.2,
        --是否可摧毁
        breakable = false
    },
    --路面
    road = {
        --生命值
        hp = 0,
        --是否需要穿甲弹
        needAP = false,
        --阻尼
        damping = 0,
        --是否可摧毁
        breakable = false
    },
    --草丛，在坦克上方，可隐藏坦克
    grass = {
        --生命值
        hp = 0,
        --是否需要穿甲弹
        needAP = false,
        --阻尼
        damping = 0,
        --是否可摧毁
        breakable = false
    },
    --水域
    water = {
        --生命值
        hp = 0,
        --是否需要穿甲弹
        needAP = false,
        --阻尼
        damping = 1,
        --是否可摧毁
        breakable = false
    },
    --砖块
    brick = {
        --生命值
        hp = maxBreakStep,
        --是否需要穿甲弹
        needAP = false,
        --阻尼
        damping = 1,
        --是否可摧毁
        breakable = true
    },
    --钢铁
    steel = {
        --生命值
        hp = maxBreakStep,
        --是否需要穿甲弹
        needAP = true,
        --阻尼
        damping = 1,
        --是否可摧毁
        breakable = true
    }
}
function Block:ctor(node)
    self.super.ctor(self, node)
end

function Block:beHit()
    if not self.breakable then
        return
    end
    self.hp = self.hp - 1
    if self.hp <= 0 then
        self:reset("mud")
    else
        self:updateImage()
    end
end

function Block:reset(type)
    local pro = blockPro[type]
    assert(pro)
    for t, v in pairs(pro) do
        self[t] = v
    end
    self.type = type
    self:updateImage()
end

function Block:updateImage()
    local cache = cc.SpriteFrameCache:getInstance()
    local name = ""
    if self.breakable then
        name = string.format("%s%d.png", self.type, maxBreakStep - self.hp)
    else
        name = string.format("%s.png", self.type)
    end
    local frame = cache:getSpriteFrame(name)
    if not frame then
        print("sprite not found:", name)
    else
        self.sp:setSpriteFrame(frame)
        if self.type == "grass" then
            --草丛在上边且带一点点透明
            self.sp:setLocalZOrder(10)
            self.sp:setOpacity(200)
        else
            --属性可能会被复用，故先重置一下
            self.sp:setLocalZOrder(0)
            self.sp:setOpacity(255)
        end
    end
end

return Block
