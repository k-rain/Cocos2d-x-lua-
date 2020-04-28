--[[
    desc:地图生成
    author:wangyu
    email:w3333y@126.com
    time:2020-04-24 19:58:34
]]
local Map = class("Map")
local Block = require("app.Block")

function Map:ctor(node)
    self.map = {}
    self.node = node
    for x = 1, GConst.mapWidth do
        for y = 1, GConst.mapHeight do
            if x == 1 or x == GConst.mapWidth or y == 1 or y == GConst.mapHeight then
                self:setBlock(x, y, "steel")
            else
                self:setBlock(x, y, "mud")
            end
        end
    end
    local str = cc.FileUtils:getInstance():getStringFromFile("data/mapData.json")
    local tab = json.decode(str)
    for type, blocks in pairs(tab) do
        for _, block in ipairs(blocks) do
            self:setBlock(block[1], block[2], type)
        end
    end
end

function Map:setBlock(x, y, type)
    local block = self.map[x * 100 + y]
    if not block then
        block = Block.new(self.node)
        self.map[x * 100 + y] = block
    end
    block:setPos(x, y)
    block:reset(type)
    block.x = x
    block.y = y
end

function Map:getBlock(x, y)
    if x <= 0 or y <= 0 or x > GConst.mapWidth or y > GConst.mapHeight then
        return
    end
    return self.map[x * 100 + y]
end

--判断坦克跟地图上某个地形方块是否有交叉
function Map:colideWithBlock(rect, x, y)
    local block = self:getBlock(x, y)
    --超出范围
    if not block then
        return
    end
    --阻尼值
    if block.damping < 1 then
        return
    end
    --砖块的区域
    local bRect = GameUI.newRect(block.sp:getPositionX(), block.sp:getPositionY())
    --是否有交叉
    if GameUI.rectIntersert(rect, bRect) then
        return block
    end
    return
end

--遍历地图所有格子，看跟指定位置的坦克是否有碰撞
function Map:colide(posx, posy, ex)
    local rect = GameUI.newRect(posx, posy, ex)
    for x = 1, GConst.mapWidth do
        for y = 1, GConst.mapHeight do
            local colideArea = self:colideWithBlock(rect, x, y)
            if colideArea then
                return colideArea
            end
        end
    end
    return
end

--精准碰撞
function Map:hit(posx,posy)
    local x,y = GameLogic.pos2Grid(posx,posy)
    local block = self:getBlock(x,y)

    if block and block.breakable then
        return block
    end
    return nil
end

return Map
