local Tank = require("app/Tank")
local PlayerTank = require("app/PlayerTank")
local Map = require("app.Map")

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- -- add background image
    -- display.newSprite("HelloWorld.png")
    --     :move(display.center)
    --     :addTo(self)
    -- -- add HelloWorld label
    -- cc.Label:createWithSystemFont("Hello World", "Arial", 40)
    --     :move(display.cx, display.cy + 200)
    --     :addTo(self)
end

function MainScene:onEnter()
    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("res/ui.plist")

    self.map = Map.new(self)
    self.tank = PlayerTank.new(self, "tank_green", self.map)
    local winSize = cc.Director:getInstance():getWinSize()
    self.tank:setPos(5,5)
    -- self.tank.sp:setPosition(winSize.width / 2, winSize.height / 2)
    self:pressInput()
end

function MainScene:pressInput()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(
        function(keycode, event)
            if not self.tank then
                return
            end
            if keycode == 146 then
                --w
                self.tank:moveBegin(GConst.dir.up)
            elseif keycode == 142 then
                --s
                self.tank:moveBegin(GConst.dir.down)
            elseif keycode == 124 then
                --a
                self.tank:moveBegin(GConst.dir.left)
            elseif keycode == 127 then
                --d
                self.tank:moveBegin(GConst.dir.right)
            elseif keycode==133 then
                --j,射击
                self.tank:fire()
            end
        end,cc.Handler.EVENT_KEYBOARD_PRESSED
    )
    listener:registerScriptHandler(
        function(keycode, event)
            if not self.tank then
                return
            end
            if keycode == 146 then
                --w
                self.tank:moveEnd(GConst.dir.up)
            elseif keycode == 142 then
                --s
                self.tank:moveEnd(GConst.dir.down)
            elseif keycode == 124 then
                --a
                self.tank:moveEnd(GConst.dir.left)
            elseif keycode == 127 then
                --d
                self.tank:moveEnd(GConst.dir.right)
            end
        end,cc.Handler.EVENT_KEYBOARD_RELEASED
    )
    --把事件监听器加入到场景
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end

function MainScene:onExit()
end

return MainScene
