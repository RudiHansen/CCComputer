 --[[
    util Function Library   
    Developed by Rudi Hansen, Start 2023-03-18

    TODO

    CHANGE LOG
    2023-05-22 : Initial Version.
]]

local util = {}

function util.waitForUserKey()
    print("And press a key for next step")
    os.pullEvent("key")
end

function util.incNumberMax(number,max)
    number = number + 1
    if(number==max)then
        number = 1
    end
    return number
end

function util.any2String(anyType)
    if type(anyType) == 'table' then
       local s = '{ '
       for k,v in pairs(anyType) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. util.any2String(v) .. ','
       end
       return s .. '} '
    else
       return tostring(anyType)
    end
end

function util.stringLen(txt,length)
    if(length>99)then
        print("ERROR IN util.stringLen, length more than 99")
        error()
    end
    txt = string.format( "%-99s", txt )
    txt = string.sub(txt,1,length)
    return txt
end

function util.splitString(text)
    fields = {}
    for field in string.gmatch(text, "[^,]+") do
        table.insert(fields, field)
    end
    return fields
end

function util.setDefaultValueIfEmpty(value,default)
    if(value == nil or value == "") then
        return default
    else
        return value
    end
end

return util