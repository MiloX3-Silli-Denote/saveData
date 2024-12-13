local SaveData = {};
SaveData.__index = SaveData;

function SaveData.new(name)
    local instance = setmetatable({}, SaveData);

    instance.name = name;
    instance.data = {};

    return instance;
end

function SaveData:setData(name, setTo)
    self.data[name] = setTo;
end

function SaveData:load(prim)
    local file = love.filesystem.load(self.name .. ".lua");

    if prim then
        return file()[prim];
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
    file:write(self:getDataAsString(self.data));
    file:write("};");
    file:close();
end

function SaveData:getDataAsString(data)
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
            val = string.gsub("{\r\n" .. self:getDataAsString(v) .. "}", "\r\n", "\r\n\t");
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