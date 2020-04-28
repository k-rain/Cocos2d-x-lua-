--[[
    desc:
    author:wangyu
    email:w3333y@126.com
    time:2020-04-24 17:37:00
]]

GameUI={}

--给定地图位置，得出格子的区域与大小
function GameUI.newRect(x,y,ex,iscenter)
    --ex是用来做缩放的参数
    ex=ex and ex or 0
    if iscenter then
        return {
            left = x-GConst.halfGrid-ex,
            right = x+GConst.halfGrid+ex,
            top = y+GConst.halfGrid+ex,
            bottom = y-GConst.halfGrid-ex,

            Width=function (self)
                return math.abs(self.right-self.left)
            end,
            height=function (self)
                return math.abs(self.top-self.bottom)
            end,
            center =function (self)
                return x,y
            end,
            printInfo=function (self)
                return string.format("%d %d %d %d",self.left,self.top,self.right,self.bottom)
            end
        }
    else
        return {
            left = x,
            right = x+GConst.gridSize+2*ex,
            top = y+GConst.gridSize+2*ex,
            bottom = y,

            width=function (self)
                return math.abs(self.right-self.left)
            end,
            height=function (self)
                return math.abs(self.top-self.bottom)
            end,
            center =function (self)
                return x,y
            end,
            printInfo=function (self)
                return string.format("%d %d %d %d",self.left,self.top,self.right,self.bottom)
            end
        }
    end
end

--判断并输出两个容器的相交区域，方法内容自己想象两个相交的矩形就好理解一些了
function GameUI.rectIntersert(r1,r2)
    if r1:width() == 0 or r1:height()==0 then
        return r2
    end
    if r2:width() == 0 or r2:height()==0 then
        return r1
    end
    local left = math.max(r1.left,r2.left)
    if not (left < r1.right and left < r2.right) then
        return
    end
    local right = math.min(r1.right,r2.right)
    if not (right > r1.left and right > r2.left) then
        return
    end
    local top = math.min(r1.top,r2.top)
    if not (top > r1.bottom and top > r2.bottom) then
        return
    end
    local bottom = math.max(r1.bottom,r2.bottom)
    if not (bottom < r1.top and bottom < r2.top) then
        return
    end
    return {left,top,right,bottom}
end