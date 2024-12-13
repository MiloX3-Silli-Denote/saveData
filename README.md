# saveData
saving and loading for love2d

## Basic Usage
download and place saveData.lua into your project and add ```SaveData = require("saveData");``` into your main file.
liscense is in file

create and use save data like so:
```lua
local saveFile = SaveData.new("saveName"); -- name needs to be a string
-- create a save file

saveFile:setData("num", 30.4);
saveFile:setData("str", "text");
saveFile:setData("tbl", {10,9,8,7,6,5});
saveFile:setData("bol", true);
saveFile:setData("dic", {
  ["something"] = "nothing";
  ["something else"] = "more nothing";
  differentFormat = "same thing";
});
saveFile:setData("num", 13.5); -- overwrite first :setData()

saveFile:setData("doesntWork", function(x) return x + 3 end);
-- no support for: functions, userdata, threads, must create conversions yourself

saveFile:save(); -- write to file

local saveCopy = saveFile:load(); -- load from file
--[[
{
  num = 13.5;
  str = "text";
  tbl = {
    10,
    9,
    8,
    7,
    6,
    5
  };
  bol = true;
  dic = {
    something = "nothing";
    ["something else"] = "more nothing";
    differentFormat = "same thing";
  }
}
]]

local num = saveFile:load("num"); -- load specific value from file
-- 13.5
```
