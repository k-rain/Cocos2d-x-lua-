--[[
    desc:游戏逻辑方法
    author:wangyu
    email:w3333y@126.com
    time:2020-04-24 17:37:00
]]
GameLogic = {}

--将格子坐标转换为像素坐标
function GameLogic.grid2Pos(x, y)
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    -- --这里是原来的写法，我觉得不好懂，改了个自己的
    -- local posOffX = GConst.gridSize * GConst.mapWidth * 0.5 - GConst.halfGrid
    -- local posOffY = GConst.gridSize * GConst.mapHeight * 0.5 - GConst.halfGrid
    -- local finalX = origin.x + visibleSize.width * 0.5 + x * GConst.gridSize - posOffX
    -- local finalY = origin.y + visibleSize.height * 0.5 + y * GConst.gridSize - posOffY
    -- return finalX, finalY

    --我自己的写法
    local offx = (visibleSize.width - GConst.gridSize * GConst.mapWidth) / 2
    local offy = (visibleSize.height - GConst.gridSize * GConst.mapHeight) / 2
    local finalX =  (x - 1) * GConst.gridSize + offx + origin.x
    local finalY =  (y - 1) * GConst.gridSize + offy + origin.y
    return finalX, finalY
end

--将像素坐标转换为格子坐标
function GameLogic.pos2Grid(posx, posy)
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    -- --这里是原来的写法，我觉得不好懂，改了个自己的
    -- local posOffX = GConst.gridSize * GConst.mapWidth * 0.5 - GConst.halfGrid
    -- local posOffY = GConst.gridSize * GConst.mapHeight * 0.5 - GConst.halfGrid
    -- local finalX = (posx - visibleSize.width * 0.5 + GConst.halfGrid) / GConst.gridSize
    -- local finalY = (posy - visibleSize.height * 0.5 + GConst.halfGrid) / GConst.gridSize
    -- finalX = math.modf(finalX)
    -- finalY = math.modf(finalY)
    -- return finalX, finalY

    --我自己的写法
    local offx = (visibleSize.width - GConst.gridSize * GConst.mapWidth) / 2
    local offy = (visibleSize.height - GConst.gridSize * GConst.mapHeight) / 2
    local finalX = (posx-offx)/GConst.gridSize
    local finalY = (posy-offy)/GConst.gridSize
    --误差兼容，算出来第8.9格肯定时第九格
    finalX = math.floor(finalX+0.5)
    finalY = math.floor(finalY+0.5)
    return finalX, finalY
end
