--[[
    desc:全局可调用的自造轮子
    author:wangyu
    email:w3333y@126.com
    time:2020-04-24 03:13:18
]]
GMethod = {}

--查看某元素是否包含在某表中
function GMethod.isContain(table, content)
    for _, v in pairs(table) do
        if v == content then
            return true
        end
    end
    return false
end


