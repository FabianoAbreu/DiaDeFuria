--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:738ddbb2450247f8f8a04fbab0abe406:7bc89ebfde27301e1e6ce8bc0cab0fbd:89bc094cb2e6813e2601375f4bd45258$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            x=1,
            y=1,
            width=160,
            height=160,
        },
        {
            x=163,
            y=1,
            width=160,
            height=160,
        },
        {
            x=325,
            y=1,
            width=160,
            height=160,

        },
        {
            x=487,
            y=1,
            width=160,
            height=160,
        },
    },
    
    sheetContentWidth = 648,
    sheetContentHeight = 162
}

SheetInfo.frameIndex =
{
    ["sprite_teste0"] = 1,
    ["sprite_teste1"] = 2,
    ["sprite_teste2"] = 3,
    ["sprite_teste3"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
