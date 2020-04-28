--[[
    desc:帧动画
    author:wangyu
    email:w3333y@126.com
    time:2019-12-27 20:22:40
]]
local SpriteAnimate = class("SpriteAnimate")

local function setFrame(sp, def, index)
    if not sp then
        return
    end
    local cache = cc.SpriteFrameCache:getInstance()
    local frameName

    if def.name then
        --精灵带动画名的动作帧，精灵名+动作名+帧号
        frameName = string.format("%s_%s%d.png", def.spname, def.name, index)
    else
        --精灵不带动画名的动作帧，精灵名+帧号
        frameName = string.format("%s%d.png", def.spname, index)
    end
    local frame = cache:getSpriteFrame(frameName)
    if frame == nil then
        print("frame not found:", frameName)
        return
    end
    sp:setSpriteFrame(frame)
end

function SpriteAnimate:ctor(node, sp)
    -- 动画列表，包含所有动画
    self.animate = {}
    self.sp = sp
end

function SpriteAnimate:define(name, spname, frameCount, interval, once)
    local cache = cc.SpriteFrameCache:getInstance()
    --定义动画
    local def = {
        --当前帧数
        curFrame = 0,
        --是否在运行
        running = false,
        --动画的总帧数
        frameCount = frameCount,
        --动画帧间隔
        interval = interval,
        --动画对象名字
        spname = spname,
        --如果同一对象有几套动作，这个就是具体某一套动作的名字
        name = name,
        --是否只播放一次
        once = once,
        --放完动作的回调
        advanceFrame = function(defSelf)
            defSelf.curFrame = defSelf.curFrame + 1
            if defSelf.curFrame >= defSelf.frameCount then
                defSelf.curFrame = 0
                return false
            end
            return true
        end
    }
    if name then
        --带动作
        self.animate[name] = def
    else
        --不带动作
        self.animate[spname] = def
    end
end

function SpriteAnimate:setFrame(name, index)
    local def = self.animate[name]
    if def then
        setFrame(self.sp, def, index)
    end
end

function SpriteAnimate:play(name, callback)
    local def = self.animate[name]
    if not def then
        return
    end
    if not def.shid then
        local scheduler = cc.Director:getInstance():getScheduler()
        def.shid =
            scheduler:scheduleScriptFunc(
            function()
                if def.running then
                    if def:advanceFrame() then
                        setFrame(self.sp, def, def.curFrame)
                    elseif def.once then
                        def.running = false
                        scheduler:unscheduleScriptEntry(def.shid)
                        def.shid=nil
                        --播放完执行的操作
                        if callback then
                            callback()
                        end
                    end
                end
            end,
            def.interval,
            false
        )
    end
    def.running = true
end

function SpriteAnimate:stop(name, callback)
    local def = self.animate[name]
    if not def then
        return
    end
    def.running = false
end

--动画销毁时，把调度器回收，把精灵也置换掉
function SpriteAnimate:destroy()
    for name, def in pairs(self.animate) do
        if def.shid then
            local scheduler = cc.Director:getInstance():getScheduler()
            scheduler:unSchedulerScriptFunc(def.scheduler)
        end
    end
    self.sp = nil
end

return SpriteAnimate
