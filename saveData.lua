--[[
MIT License

Copyright (c) 2024 Milo:3 Silli Denote

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local SaveData = {};
SaveData.__index = SaveData;

function SaveData.new(name)
    assert(type(name) == "string", "must have name to creat saveData");

    local instance = setmetatable({}, SaveData);

    instance.name = name;
    instance.data = {};

    return instance;
end

function SaveData:setData(name, setTo)
    self.data[name] = setTo;
end

function SaveData:load(_prim_)
    local file = love.filesystem.load(self.name .. ".lua");

    if _prim_ then
        return file()[_prim_];
    end

    return file();
end

function SaveData:save()
    local file = love.filesystem.newFile(self.name .. ".lua");
    file:open("w");

    if not file:isOpen() then
        print("WARNING: could not save to file: '" .. self.name .. ".lua'");
        return;
    end

    file:write("return {\r\n");
    file:write(self.getDataAsString(self.data));
    file:write("};");
    file:close();
end

function SaveData.getDataAsString(data)
    local str = "";

    for k, v in pairs(data) do
        local val = nil;

        if type(v) == "string" then
            val = "\"" .. v .. "\"";
        elseif type(v) == "number" then
            val = tostring(v);
        elseif type(v) == "boolean" then
            val = v and "true" or "false";
        elseif type(v) == "nil" then
            val = "nil";
        elseif type(v) == "table" then
            val = string.gsub("{\r\n" .. self.getDataAsString(v) .. "}", "\r\n", "\r\n\t");
        end

        if val then
            if type(k) == "string" then
                str = str .. "\t[\"" .. k .. "\"] = " .. val .. ";\r\n";
            elseif type(k) == "number" then
                str = str .. "\t[" .. tostring(k) .. "] = " .. val .. ";\r\n";
            end
        end
    end

    return str;
end

return SaveData;
