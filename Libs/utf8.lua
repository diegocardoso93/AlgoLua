
local utf8 = {}

function utf8.encode(s)
    return {string.byte(s, 1, -1)}
end

function utf8.decode(t)
    local s = ""
    for i=1,#t do s = s .. string.char(t[i]) end;
    return s
end

return utf8
